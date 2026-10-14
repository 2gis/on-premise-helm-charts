## [UNRELEASED]

#### Supported versions

| Component    | Version |
| ------------ | ------- |
| core         | 2.11.1  |
| api-platform | 2.59.0  |
| pro          | 2.6.1   |
| citylens     | 2.3.0   |

#### Breaking changes
- Environment values files are now a flat map of values: `$HELMFILE_VALUES/environments/<env>.yaml(.gotmpl)`;
  the `environments:/values:` wrapper is no longer supported (migration: unwrap the file)

#### Changes
- **Parallel deploys via helmfile layers** — layer directories merge into one state (releases
  run in parallel), sequential tracks and service-directory references order dependencies
  (README, "Порядок и параллельность деплоя (слои и треки)"; пример —
  `installer/helmfile/example/deploy/layered.yaml.gotmpl` + `.../deploy/layers/`)
- **Universal per-release `set:` slots** — `values/{group}/{svc}/_common.set.yaml.gotmpl` +
  `<env>.set.yaml.gotmpl`, arbitrary set-entries incl. `file:` → helm `--set-file`
  (README, "Проброс set-записей в релиз")
- Environments are file-driven: a new environment = a new `$HELMFILE_VALUES/environments/<env>.yaml(.gotmpl)`,
  no helmfile edits (missing env file fails with the expected path)
- Optional shared layers: `environments/_common.yaml.gotmpl`, `values/{group}/{svc}/_common.yaml.gotmpl`
- Manifest pinning via `dgctlManifests` in the env file, resolved centrally in `values/dgctl.yaml.gotmpl`
- navi-back releases carry a `family: navi-back` label (whole-family selector)

## [2026-10-12]

#### Supported versions

| Component    | Version |
| ------------ | ------- |
| core         | 2.11.1  |
| api-platform | 2.59.0  |
| pro          | 2.6.1   |
| citylens     | 2.3.0   |

#### Changes
- Bumped supported pro version to 2.6.1

## [2026-10-06]

#### Supported versions

| Component    | Version |
| ------------ | ------- |
| core         | 2.11.1  |
| api-platform | 2.59.0  |
| pro          | 2.6.0   |
| citylens     | 2.3.0   |

#### Changes
- Bumped supported pro version to 2.6.0

## [2026-09-29]

#### Supported versions

| Component    | Version |
| ------------ | ------- |
| core         | 2.11.1  |
| api-platform | 2.59.0  |
| pro          | 2.5.0   |
| citylens     | 2.3.0   |

#### Changes
- Bumped supported api-platform version to 2.59.0

## [2026-09-17]

#### Supported versions

| Component    | Version |
| ------------ | ------- |
| core         | 2.11.1  |
| api-platform | 2.58.0  |
| pro          | 2.5.0   |
| citylens     | 2.3.0   |

#### Changes
- Secret encryption: sops + helm-secrets support - secrets are stored in `*.secrets.yaml`(migration notes: README, "Secrets")
- vals alternative: `ref+vault://` refs in regular values files, no encryption step (README, "Vault (vals)")
- dgctl configs moved to `example/dgctl/`
- Sandbox guide: deployment without `HELMFILE_BASE`/`HELMFILE_VALUES` variables
- Playgrounds for platform added
- Bumped supported core version to 2.11.1

## [2026-09-09]

#### Supported versions

| Component    | Version |
| ------------ | ------- |
| core         | 2.11.0  |
| api-platform | 2.58.0  |
| pro          | 2.5.0   |
| citylens     | 2.3.0   |

#### Changes
- Bumped supported api-platform version to 2.58.0

## [2026-09-08]

#### Supported versions

| Component    | Version |
| ------------ | ------- |
| core         | 2.11.0  |
| api-platform | 2.57.0  |
| pro          | 2.5.0   |
| citylens     | 2.3.0   |

#### Changes
- Initial release of the helmfile installer: example environments
  (sandbox, staging), dgctl artifact pull scripts, helper scripts
  (`kind-up.sh`, `sandbox-hosts.sh`, `create_sandbox_key.sh`)
