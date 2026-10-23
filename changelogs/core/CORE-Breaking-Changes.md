# Core Breaking-Changes

## [2.12.0]

### platform-id

- Keycloak service replaced by Platform ID: chart and helm release `keycloak` renamed to `platform-id`.
- The `keycloak-config-cli` job is replaced with the native startup import (`kc.sh start --import-realm`).
  Realms are provisioned from the chart (`charts/platform-id/realms/`) on the FIRST deployment only (seed-once).
  On upgrade, realm configuration changes from the chart are NO LONGER applied to existing realms —
  apply changes via the admin API / admin console.
- Images `keycloak`, `keycloak-config-cli`, `keycloak-themes` are no longer required — a single `platform-id` image is used.
- The `keycloakThemes` values section is removed. The `keycloakConfigCli.enabled` parameter now controls the
  vanilla config-cli job with an empty configuration.
- Existing realms keep their current login theme; fresh installations get the SPA theme `platform-id-2gis`
  (login by email).

### keys

- New `bootstrap.enabled` flag (default: `false`). When enabled, a bootstrap Job creates the default partner, an unlimited subscription, and an API key during the first deployment if the keys table is empty. The created API key is printed in the Job logs — set `bootstrap.logLevel` to `info` or lower and read it via `kubectl logs job/<bootstrap-job>`. The finished Job is retained for `bootstrap.ttlSecondsAfterFinished` seconds (default: `86400`) before automatic cleanup.
- The Keys administration UI is deprecated. Use Platform Manager to work with keys. The new `admin.enabled` flag (default: `true`) allows disabling the UI.

## [2.8.0]

### keys

- Deprecated services removed: Public Transport API (merged into Routing API) and Truck Distance Matrix API (merged into Distance Matrix API)
- New service added: Static API

## [2.7.0]

### keys

- KeysAPI - you need to add the `X-Company-Id` header to `Access-Control-Allow-Headers` for the Platform Manager to work

### keycloak

- Renamed `postgres.host` to `externalDatabase.host`
- Renamed `postgres.port` to `externalDatabase.port`
- Renamed `postgres.name` to `externalDatabase.database`
- Renamed `postgres.username` to `externalDatabase.user`
- Renamed `postgres.password` to `externalDatabase.password`
- Renamed realm `Inspection_Portal_backend` to `Citylens-web`
- Renamed realm `CityLens_app` to `Citylens`
- Renamed realm `URBI_Pro` to `Pro`
- Production mode is disabled by default

## [2.5.0]

Before upgrading, update the Platform services to the [Platform:2.50.0](../platform/PLATFORM-CHANGELOG.md) release.

## [2.4.0]

### keys

- KeysAPI was splits into two applications: KeysAPI and ServiceAPI

## [2.1.0]

### keys
- Added `redis.enabled`, which is set to `false` by default
- Renamed `api.oidc.enable` to `api.oidc.enabled`
