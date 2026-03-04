# Platform Breaking-Changes

## [2.50.0]

Before upgrading, update the key service from the [Core:2.4.0](../core/CORE-CHANGELOG.md) release.

### catalog-api

- Replace `http://keys-api` with `http://keys-service-api` in the `keys.url`

### tiles-api

- Replace `http://keys-api` with `http://keys-service-api` in the `proxy.access.url`

### twins-api

- Replace `http://keys-api` with `http://keys-service-api` in the `api.keys.url`

### navi-async-matrix

- Replace `http://keys-api/service/v1/keys` with `http://keys-service-api/service/v1/keys` in the `keys.url`

### navi-router

- Replace `http://keys-api/service/v1/keys` with `http://keys-service-api/service/v1/keys` in the `keys.url`

### navi-vrp-task-manager

- Replace `http://keys-api/service/v1/keys` with `http://keys-service-api/service/v1/keys` in the `keys.url`

### navi-vrp-solver

- Renamed `naviBack` to `naviFront`

## [2.49.0]

### navi-back

- `transmitter` is deprecated. Set `remoteAttractor` instead

## [2.48.0]

### navi-back

- `naviback.bss` section renamed to `naviback.stat`
- `naviback.bss.client.serviceRemoteAddress` renamed to `naviback.stat.url`
- `naviback.validation.bss` section renamed to `naviback.validation.stat`

### navi-async-matrix

- `bss` section renamed to `stat`
- `keys.truckToken` was removed. Now, the `keys.token` is used for trucks
- You need to upgrade keys-backend to version 1.144.1 (Release Core 2.2.0)

### navi-vrp-task-manager

- `bss` section renamed to `stat`

## [2.47.0]

### catalog-api

- Removed JsQuery extension dependency from the service’s PostgreSQL database.

### platform

- You need to upgrade keys-backend to version 1.140.0 (Release Core 2.1.0)

### stat-receiver

- `kafka.sasl.jaas` splitted to several values: `kafka.sasl.jaasLoginModule`, `kafka.sasl.username` and `kafka.sasl.password`
- `kafka.sasl.createSecret` removed. If `kafka.sasl.secretName` is not an empty string, chart will use the specified name to reference the secret Otherwise a new secret will be created.

### tiles-api

- Renamed `cassandra.ssl` to `cassandra.tls`

### traffic-proxy

- Renamed `proxy.apiKey` to `proxy.licenseKey`

## [2.46.0]

### navi-back

- Renamed `naviback.app_rule` to `naviback.appRule`
- Renamed `app_project` to `appProject`

### navi-attractor

- Renamed `attractor.app_rule` to `attractor.appRule`
- Renamed `app_project` to `appProject`

### navi-splitter

- Renamed `splitter.app_rule` to `splitter.appRule`

### navi-async-matrix

- Renamed `s3.publicNetloc` to `s3.publicUrl`
