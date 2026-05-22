# Core Breaking-Changes

## [2.7.0]

### keys

- KeysAPI - you need to add the `X-Company-Id` header to `Access-Control-Allow-Headers` for the Platform Manager to work

## [2.5.0]

Before upgrading, update the Platform services to the [Platform:2.50.0](../platform/PLATFORM-CHANGELOG.md) release.

## [2.4.0]

### keys

- KeysAPI was splits into two applications: KeysAPI and ServiceAPI

## [2.1.0]

### keys
- Added `redis.enabled`, which is set to `false` by default
- Renamed `api.oidc.enable` to `api.oidc.enabled`
