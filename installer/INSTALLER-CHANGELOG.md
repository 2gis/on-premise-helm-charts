## [UNRELEASED]

#### Supported versions

| Component    | Version |
| ------------ | ------- |
| core         | 2.11.0  |
| api-platform | 2.58.0  |
| pro          | 2.5.0   |
| citylens     | 2.3.0   |

#### Changes
- Secret encryption: sops + helm-secrets support (`example/.sops.yaml` creation rules;
  plaintext `*.secrets.yaml` per-service and environment files in `example/`,
  encrypt before deploy, decrypt back)
- dgctl configs moved to `example/dgctl/` (sandbox/staging/fs/s3); presets removed from
  `installer/dgctl/`; `pull.sh` runs from any directory (config resolution
  `$1` > `$HELMFILE_VALUES/dgctl/<name>` > example default; `auto_values` via `HELMFILE_BASE`)
- `create_sandbox_key.sh` is sops-aware: decrypts sops-encrypted env secrets and
  re-encrypts the written-back key
- helmfile: `HELMFILE_VALUES`/`HELMFILE_BASE` path defaults in `common.yaml.gotmpl`,
  `secrets:`/`values:` routing in services templates
- README: "Secrets" section (age/GPG/Vault), sandbox guide without environment
  variables, manifest pinning
- Playgrounds for platforms added

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

