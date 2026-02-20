# PRO Breaking-Changes

## [2.52.0]

### pro-api

#### Structural Changes

- **Removed global `imagePullSecrets` parameter**: The parameter has been moved to the pod level. Now each service (api, permissions, tasks, pagerenderer, assetImporter) has its own `pod.imagePullSecrets` parameter.

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

## [2.1.0]

### pro-api
- `kafka.eventsTopic.readerGroupId` is now required for tasks-worker deployment
- `keys` service is completely removed from values
