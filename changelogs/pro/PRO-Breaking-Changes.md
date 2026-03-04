# PRO Breaking-Changes

## [2.3.0]

### pro-api
- Removed parameters `tasks.settings.admin.auth.*` (schema, basic, oidc)
- Added replacement parameters `tasks.settings.auth.*` (enabled, apiKey, adminRequiredRoles) and new `authProvider.*` configuration block for Permissions UI and Tasks Admin UI authentication
- Added required `authProvider.*` configuration: `authProvider.host`, `authProvider.schema` and `permissions.settings.auth.uiRequiredRoles` must be set. `tasks.settings.auth.adminRequiredRoles` is required if `tasks.settings.auth.enabled: true`. In the simplest case, set `authProvider.schema: Basic` and define users with arbitrary usernames, passwords and roles under `authProvider.basic.users` — roles are arbitrary strings, but must match the values set in `permissions.settings.auth.uiRequiredRoles` and (if applicable) `tasks.settings.auth.adminRequiredRoles`. Alternatively, if an OIDC provider is available, set `authProvider.schema: Oidc` and configure `authProvider.oidc.*`
- Removed feature `tasks.settings.features.removeExpiredSmbDashboards`
- Removed parameter `pagerenderer.settings.auth.apiKey`

## [2.1.0]

### pro-api
- `kafka.eventsTopic.readerGroupId` is now required for tasks-worker deployment
- `keys` service is completely removed from values
