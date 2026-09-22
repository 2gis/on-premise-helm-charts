## [UNRELEASED]

#### Supported versions

| Component    | Version |
| ------------ | ------- |
| core         | 2.11.1  |
| api-platform | 2.58.0  |
| pro          | 2.5.0   |
| citylens     | 2.3.0   |

#### Breaking changes
- Environment values files are now a flat map of values: `$HELMFILE_VALUES/environments/<env>.yaml(.gotmpl)`;
  the `environments:/values:` wrapper is no longer supported (migration: unwrap the file)

#### Changes
- Environment block is generated for the selected environment (`-e`): a new environment is added by
  creating `$HELMFILE_VALUES/environments/<env>.yaml(.gotmpl)`, no helmfile edits; a missing env file
  fails with the expected path
- Shared environment layer (optional): `environments/_common.yaml.gotmpl` (below env-file priority)
  and `environments/_common.secrets.yaml` (sops)
- Per-service shared values slot: `values/{group}/{svc}/_common.yaml.gotmpl` is loaded for every release
  of the service before the env file, if present (opt-out by absence); also wired into multi-release
  services (tiles multi/raster, navi-back async chains)
- Manifest pinning moved to the environment level: `dgctlManifests` map (core/api-platform/pro/citylens)
  resolved centrally in `values/dgctl.yaml.gotmpl` by release name; per-service `dgctlStorage.manifest`
  overrides are no longer needed (README, "Фиксация/переключение манифестов")

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
