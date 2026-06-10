# Citylens Breaking-Changes

## [2.3.0]

### citylens

- Added new required parameters:
  - `.Values.routes.endpointInternalApiKey.users`
  - `.Values.routes.adminCredentials.cookieSigningKey`

- Introduced a new role model. After upgrading, the following manual steps are required:
  - Open the admin panel at `https://<.Values.routes.api.ingress.hosts[0].host>/internal/admin` (credentials: `.Values.routes.adminCredentials`) and assign the **Owner** role to at least one user.
  - In the admin panel, go to **Hangfire Dashboard → Recurring Jobs** and manually trigger the **`MigrateUserRolesJob`** job to migrate existing users to the new role model.

## [2.2.0]

### citylens

- Added new required parameters:
  - `.Values.routes.adminCredentials.password`
  - `.Values.routes.adminCredentials.username`
  - `.Values.routes.endpointInternalApiKey.dataScience`
  - `.Values.routes.endpointInternalApiKey.companies`

## [2.1.0]

### citylens

- Changed REST request logging: `extended` -> `extendedRestLogging`
- Modified service database connection: moved to a separate block, `maxPoolSize` and `pooling` replaced with `poolSize`:
```
routes:
  postgres:
    api:
      database: ''
      timeout: 15
      commandTimeout: 30
      poolSize:
        min: 1
        max: 10
    hangfire:
      database: ''
      timeout: 15
      commandTimeout: 30
      poolSize:
        min: 1
        max: 10
    realtimeDataApi:
      database: ''
      timeout: 15
      commandTimeout: 30
      poolSize:
        min: 1
        max: 10
```

### citylens-routes-ui
- Added new required parameters: `env.MAPGL_DEFAULT_CENTER`
