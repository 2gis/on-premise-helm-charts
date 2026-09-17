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
