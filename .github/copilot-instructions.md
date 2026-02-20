# 2GIS On-Premise Helm Charts — Coding Agent Guide

This repository contains Helm charts for deploying 2GIS On-Premise products on Kubernetes.
Charts share a common library chart (`generic-chart`) and follow internal coding standards.

## Required Before Each Commit

```sh
# Lint the chart(s) you modified
helm lint charts/<chart-name>

# If you changed values.yaml, regenerate README.md (requires Docker; Linux only)
make prepare && make charts/<chart-name>

# Run pre-commit hooks (trailing whitespace, end-of-file, etc.)
pre-commit run --all-files
```

## Development Flow

```sh
# Build dependencies for a chart (needed after cloning or adding a dependency)
helm dependency build charts/<chart-name>

# Lint a single chart (quick sanity check)
helm lint charts/<chart-name>

# Full lint as used in CI
ct lint --charts charts/<chart-name>

# Validate that all README.md files are up-to-date
.github/scripts/check-readme.sh
```

CI runs `ct lint --target-branch master` on every PR and fails if any `README.md` is out of date.

## Repository Structure

```
charts/                   # 31 application charts + generic-chart (shared library)
  generic-chart/          # Library chart — templates/_*.yaml, _helpers.tpl
  <chart-name>/
    Chart.yaml            # apiVersion: v2, type: application, version, appVersion, dependencies
    values.yaml           # All configurable parameters with @param/@section/@skip annotations
    README.md             # Auto-generated from values.yaml — do not edit by hand
    templates/
      NOTES.txt           # Required: post-install instructions
      _helpers.tpl        # Named templates, all namespaced with chart name
      *.yaml              # One Kubernetes resource per file, dashed-case filenames
changelogs/               # Per-group changelogs: core/, platform/, pro/, citylens/, evergis/
  core/CORE-CHANGELOG.md
  core/CORE-Breaking-Changes.md
  ...
Breaking-Changes.md       # Index pointing to per-group breaking changes files
styleguide.md             # Full style reference — read this when in doubt
CONTRIBUTING.md           # Gitflow branching model, PR requirements
Makefile                  # `make prepare` + `make charts/<name>` to regenerate README
bitnami-config.json       # Config for readme-generator-for-helm annotation tags
.github/
  pull_request_template.md
  scripts/check-readme.sh # Used by CI to validate README is up-to-date
  workflows/
    lint.yaml             # `ct lint` on PRs to master/develop
    check-readme.yaml     # Validates README.md is regenerated when values.yaml changes
    release.yaml          # Publishes charts to GitHub Pages
    release-oci.yaml      # Publishes charts as OCI artifacts
```

## Gitflow / Branching Model

- `master` — stable releases only
- `develop` — integration branch; **all feature PRs must target `develop`**
- Feature branches: branch off from `develop`, merge back to `develop` via PR
- Urgent hotfixes only: branch from `master`, PR to `master`, then cherry-pick to `develop`
- PRs are reviewed weekly on Mondays; drafts and WIP PRs are skipped

## How to Modify an Existing Chart

1. Edit `charts/<chart-name>/values.yaml` and/or `templates/`
2. If `values.yaml` changed, regenerate `README.md`:
   ```sh
   make prepare              # builds the readme-generator Docker image (requires Docker)
   make charts/<chart-name>  # regenerates README.md for that chart
   ```
   On Linux only (see **Known Issues and Workarounds** below).
3. Bump `version` in `Chart.yaml` (semver patch/minor/major as appropriate)
4. If `appVersion` (Docker image tag) changed, update it in `Chart.yaml`
5. Add an entry to the group changelog, e.g. `changelogs/core/CORE-CHANGELOG.md`
6. If there is a breaking change, document it in the group's `*-Breaking-Changes.md` and add a deprecation notice in `templates/NOTES.txt`
7. Lint locally: `helm lint charts/<chart-name>`

## How to Add a New Chart

1. Copy an existing chart as a starting point (e.g., `charts/navi-back`)
2. Update `Chart.yaml`: set `name`, `description`, `version`, `appVersion`; keep the `generic-chart` dependency
3. Run `helm dependency build charts/<chart-name>` to generate `charts/` symlink
4. Add required sections to `values.yaml` (see **values.yaml conventions** below)
5. Create `templates/NOTES.txt` (required)
6. Create `templates/_helpers.tpl` with named templates namespaced by chart name
7. Create one `.yaml` file per Kubernetes resource using dashed filenames
8. Generate `README.md`: `make prepare && make charts/<chart-name>`
9. Lint: `helm lint charts/<chart-name>`

## values.yaml Conventions

### Required sections (in order)

1. **Docker Registry settings** — always first:
   ```yaml
   # @section Docker Registry settings
   # @param dgctlDockerRegistry Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`
   dgctlDockerRegistry: ''
   ```
2. **Common settings** — `replicaCount`, `imagePullSecrets`, image, etc.
3. Service-specific sections
4. Kubernetes resource sections (hpa, vpa, pdb, serviceAccount, ingress, service, resources, …)

### Naming rules

- **camelCase**, starts with lowercase: `accessKey`, `bootstrapServers`
- Toggle parameters are always named `enabled` (not `create`, not `autoscaling.enabled` → use `hpa.enabled`)
- Standard abbreviations: `hpa`, `vpa`, `pdb`, `serviceAccount`, `importer`, `logLevel`, `logFormat`
- Use full, universal names: not `bss` → `stat`; not internal codenames
- Connection to another service: group under service name, address in `.url`, auth token in `.key`

### Standard external service schemas

| Service | Required keys |
|---------|--------------|
| PostgreSQL | `postgres.host`, `port` (5432), `name`, `username`, `password`, `tls.enabled`, `tls.rootCert`, `tls.cert`, `tls.key`, `tls.mode` |
| Kafka | `kafka.groupId`, `bootstrapServers`, `securityProtocol`, `saslMechanism`, `username`, `password`, `tls.*` |
| S3 | `s3.host`, `region`, `secure`, `verifySsl`, `bucket`, `accessKey`, `secretKey` |
| Ingress | `ingress.enabled`, `ingress.host` |

### Default value rules

- **Mandatory settings** (DB host, service URLs, required secrets): default must be `''` (empty string with single quotes); template must call `required`:
  ```yaml
  # values.yaml
  postgres:
    host: ''
  # deployment.yaml
  host: {{ required "Valid .Values.postgres.host required!" .Values.postgres.host }}
  ```
- **Optional settings**: provide a sensible default that works for a typical partner deployment
- Non-empty string defaults — no quotes: `repository: 2gis-on-premise/navi-back`
- Empty string defaults — single quotes: `name: ''`
- Enum parameters — list all valid values in the comment:
  ```yaml
  # @param logLevel Log level: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.
  logLevel: error
  ```
- Default city in examples: always **Moscow**

### @param annotation rules (for README generation)

- `README.md` is auto-generated by `readme-generator-for-helm` from `values.yaml` comments — do **not** edit README manually
- Tags: `@param`, `@section`, `@skip`, `@extra`
- K8s section headers must link to official docs:
  ```yaml
  # @section Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings
  ```
- Descriptions must **not** start with `[` (square bracket at start is parsed as a type declaration)
- Mark never-changing parameters with `@skip` to hide them from README
- No duplicate `@param` for the same key

### URL parameter format hints

Include an `Ex:` hint to clarify whether the URL is internal or external:
- Internal: `Ex: http://{service-name}.svc`
- External ingress: `Ex: http(s)://{service-name}.ingress.host`
- Any location: `Ex: {service-name}.host`

## templates/ Conventions

- File names: **dashed notation** (`my-config.yaml`, not `myConfig.yaml`)
- One Kubernetes resource per file; file name reflects resource kind
- Named templates must be **namespaced** with the chart name: `{{- define "navi-back.fullname" -}}`
- Template directives: whitespace inside braces: `{{ .foo }}` not `{{.foo}}`
- Never hardcode `namespace:` in `metadata` — it is set by the caller via `--namespace`
- Never use floating image tags (`latest`, `head`, `canary`)
- Use `generic-chart` library templates for standard resources (Deployment, Service, Ingress, HPA, VPA, PDB) instead of duplicating them
- When `hpa.enabled: true`, omit `replicas` from the Deployment spec
- CronJobs must set `successfulJobsHistoryLimit` and `failedJobsHistoryLimit` (default `3`)
- ConfigMaps and Secrets must have checksum annotations to trigger rolling restarts:
  ```yaml
  annotations:
    checksum/config: {{ (include (print $.Template.BasePath "/configmap.yaml") . | fromYaml).data | toYaml | sha256sum }}
    checksum/secret: {{ (include (print $.Template.BasePath "/secret.yaml") . | fromYaml).data | toYaml | sha256sum }}
  ```

### Standard labels (every resource)

| Label | Value |
|-------|-------|
| `app.kubernetes.io/name` | `{{ template "<chart>.name" . }}` |
| `helm.sh/chart` | `{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}` |
| `app.kubernetes.io/managed-by` | `{{ .Release.Service }}` |
| `app.kubernetes.io/instance` | `{{ .Release.Name }}` |

Hooks must be set as annotations, not labels.

## Chart.yaml Rules

- `apiVersion: v2`
- `type: application` (except `generic-chart` which is `type: library`)
- `appVersion` reflects the Docker image version (not the chart version)
- `dependencies` must include `generic-chart` with `repository: file://../generic-chart`

## Breaking Changes

A change is **breaking** if it removes or renames a parameter, changes a default value in a potentially destructive way, or alters the chart API.

When introducing a breaking change:
1. Document it in the group's `changelogs/<group>/*-Breaking-Changes.md`
2. Add a deprecation/migration notice in `templates/NOTES.txt`
3. Reference it in the PR description

## PR Requirements

- Target branch: `develop` (hotfixes only → `master`)
- PR title: start with service name, e.g. `navi-back: add X feature` or `[tiles-api] Upgraded version`
- PR description must include a **Changelog** section and an **Issues** reference
- `values.yaml` changed → `README.md` must be regenerated
- Breaking changes → documented in `*-Breaking-Changes.md`

## Code Review Language

When performing a code review, respond in **Russian**.

## What to Flag in Review

When flagging issues in code review, use this format:

```
**[CRITICAL/WARNING] Brief title**

Description of the issue.

**Why this matters:** explanation of impact.

**Suggested fix:** corrected example (if applicable).
```

**CRITICAL (block merge):**
- Missing `required` validation for mandatory settings that have empty defaults
- `values.yaml` changed but `README.md` not regenerated
- Breaking change not documented in `Breaking-Changes.md`
- PR targets `master` without being a documented hotfix
- Missing checksum annotations on ConfigMap/Secret
- `replicas` field present in Deployment when `hpa.enabled: true`
- Non-camelCase parameter names or inconsistent naming (e.g., `serviceAccount.create` instead of `serviceAccount.enabled`)
- `NOTES.txt` missing from a new chart
- Duplicate `@param` for the same key in `values.yaml`

**WARNING (suggest fix):**
- Enum parameter missing list of valid values in comment
- K8s section header missing link to official docs
- Default city not set to Moscow in examples that reference a city
- CronJob missing `successfulJobsHistoryLimit` / `failedJobsHistoryLimit`
- Parameters that never change in typical use not marked with `@skip`
- Non-empty string default written with quotes (should be without)
- Empty string default written without quotes (should be `''`)
- Service URL parameter description missing the recommended URL format hint (`http://{service-name}.svc`, etc.)
- Template file name uses camelCase instead of dashed notation
- Named template not namespaced with chart name
- Template directive missing whitespace inside braces (`{{.foo}}` instead of `{{ .foo }}`)
- Standard `app.kubernetes.io/*` labels missing from a resource
- `namespace:` hardcoded in template metadata
- Floating image tag used (`latest`, `head`, `canary`)

## Known Issues and Workarounds

- **README generation on Windows**: `make charts/<name>` produces extra blank lines on Windows. Use Linux or WSL2 for README regeneration.
- **Description starting with `[`**: `readme-generator-for-helm` interprets a `[` at the start of a `@param` description as a type declaration. Rephrase descriptions so links are not at the beginning.
- **`helm dependency build` required**: After cloning or adding a dependency, run `helm dependency build charts/<chart-name>` before linting; otherwise `ct lint` will fail with a missing dependency error.
