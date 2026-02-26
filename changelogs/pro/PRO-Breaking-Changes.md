# PRO Breaking-Changes

## [2.3.0]

### pro-api
- Removed parameters `tasks.settings.admin.auth.*` (schema, basic, oidc)
- Added replacement parameters `tasks.settings.auth.*` (enabled, apiKey, adminRequiredRoles) and new `authProvider.*` configuration block for Permissions UI and Tasks Admin UI authentication
- Removed feature `tasks.settings.features.removeExpiredSmbDashboards`
- Removed parameter `pagerenderer.settings.auth.apiKey`

## [2.1.0]

### pro-api
- `kafka.eventsTopic.readerGroupId` is now required for tasks-worker deployment
- `keys` service is completely removed from values
