# Citylens Breaking-Changes

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
