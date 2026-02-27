# 2GIS On-Premise Helm Charts — Code Review Instructions

This repository contains Helm charts for deploying 2GIS On-Premise products on Kubernetes.
Charts share a common library chart (`generic-chart`) and follow internal coding standards.

## Review Language

When performing a code review, respond in **Russian**.

## Repository Structure

- `charts/` — 31 application Helm charts + `generic-chart` (shared library)
- `changelogs/` — per-product-group changelogs (`core/`, `platform/`, `pro/`, `citylens/`, `evergis/`)
- `.github/workflows/` — CI: `lint.yaml`, `check-readme.yaml`, `release.yaml`, `release-oci.yaml`
- `CONTRIBUTING.md` — branching model (Gitflow, PRs target `develop`)
- `Breaking-Changes.md` — index of breaking changes

## PR Checklist (mirrors `pull_request_template.md`)

When performing a code review, verify:

- PR targets `develop` branch (except urgent hotfixes, which target `master`)
- PR title starts with the service name, e.g. `navi-back: add X feature` or `[tiles-api] Upgraded version`
- PR description includes a **Changelog** section and **Issues** references
- Breaking changes are documented in `Breaking-Changes.md`
- If `values.yaml` was changed, `README.md` must be regenerated (`make prepare && make charts/<chart-name>`, Linux only)
- If a new chart is added, it has `templates/NOTES.txt` and a generated `README.md`

## Breaking Changes

When performing a code review, verify:

- Any change that removes or renames a parameter, changes a default value in a breaking way, or changes the chart API must be documented in the group's `changelogs/<group>/*-Breaking-Changes.md` (referenced from `Breaking-Changes.md`) and in the PR description
- Add a deprecation notice in `templates/NOTES.txt` for renamed/removed parameters instead of silently dropping them

## What to Flag in Review

When performing a code review, use the following format for comments:

```
**[CRITICAL/WARNING] Brief title**

Description of the issue.

**Why this matters:** explanation of impact.

**Suggested fix:** corrected example (if applicable).
```

When performing a code review, flag the following:

**CRITICAL (block merge):**
- Missing `required` validation for mandatory settings that have empty defaults
- Missing `required` validation for conditionally-mandatory parameters inside their guard block (e.g., a parameter marked `**Required** if schema is "Oidc"` must use `required` inside the `{{- if eq .Values.schema "Oidc" }}` block, not just be referenced bare)
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
