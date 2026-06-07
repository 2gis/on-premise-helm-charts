# Core Breaking-Changes

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
