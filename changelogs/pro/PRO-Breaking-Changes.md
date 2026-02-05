# Changelog for Breaking Changes in Pro

## [2.51.0]

### pro-api

#### Structural Changes

- **Removed global `imagePullSecrets` parameter**: The parameter has been moved to the pod level. Now each service (api, permissions, tasks, pagerenderer, assetImporter) has its own `pod.imagePullSecrets` parameter.

#### Changes in Permissions API

- **Added new authentication parameters**:
  - `permissions.settings.auth.enabled` - enable/disable authentication (default `false`)
  - `permissions.settings.auth.uiRequiredRoles` - roles required to access Permissions UI (default `[]`)

#### Changes in Tasks API

- **Completely changed authentication schema for Tasks Admin UI**:
  - Removed parameters `tasks.settings.admin.auth.*` (schema, basic, oidc)
  - Added new parameters `tasks.settings.auth.*`:
    - `auth.enabled` - enable/disable authentication (default `false`)
    - `auth.apiKey` - API key for service-to-service calls
    - `auth.adminRequiredRoles` - roles required to access Tasks Admin UI (default `[]`)
- **Removed feature**: `tasks.settings.features.removeExpiredSmbDashboards`

#### Changes in Page Renderer API

- **Removed parameter**: `pagerenderer.settings.auth.apiKey`

#### Changes in Asset Importer

- **Added parameter**: `assetImporter.imagePullSecrets` (default `[]`)

#### New Section: Auth Provider

Added new global authentication provider configuration:
- `authProvider.enabled` - enable/disable the provider (default `false`)
- `authProvider.host` - authentication provider host address
- `authProvider.schema` - authentication schema: "Basic" or "Oidc"
- `authProvider.allowedHosts` - list of allowed hosts
- `authProvider.basic.users` - users for Basic authentication
- `authProvider.oidc.*` - OIDC provider settings

#### New Section: Security

Added new section with parameter `security.secretKey`

## [2.1.0]

### pro-api
- `kafka.eventsTopic.readerGroupId` is now required for tasks-worker deployment
- `keys` service is completely removed from values
