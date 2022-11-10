# 2GIS On-Premise Breaking-Changes

## [#.#.#]

### navi-castle
- Renamed `castle.castle_data_path` to `castle.castleDataPath`
- Renamed `castle.restrictions_api_url` to `castle.restrictions.host`
- Renamed `castle.restrictions_api_key` to `castle.restrictions.key`

### navi-router
- Renamed `router.app_port` to `router.appPort`
- Renamed `router.app_castle_host` to `router.castleHost`
- Renamed `router.additional_sections` to `router.additionalSections`

### navi-back
- Updated structure and defaults for Kafka configuration
- Renamed `s3.url` to `s3.host`
- Renamed `s3.keyId` to `s3.accessKey`
- Renamed `s3.key` to `s3.secretKey`
- Renamed `naviback.app_port` to `naviback.appPort`
- Renamed `naviback.handlers_number` to `naviback.handlersNumber`
- Renamed `naviback.max_process_time` to `naviback.maxProcessTime`
- Renamed `naviback.response_timelimit` to `naviback.responseTimelimit`
- Renamed `naviback.request_timeout` to `naviback.requestTimeout`
- Renamed `naviback.app_castle_host` to `naviback.castleHost`
- Renamed `naviback.forecast_host` to `naviback.forecastHost`
- Renamed `naviback.eca_host` to `naviback.ecaHost`
- Renamed `naviback.additional_sections` to `naviback.additionalSections`
- Renamed `naviback.dump_query` to `naviback.dump.query`
- Renamed `naviback.dump_result` to `naviback.dump.result`
- Renamed `naviback.dump_answer` to `naviback.dump.answer`
- Renamed `naviback.dm_sources_limit` to `naviback.dmSourcesLimit`
- Renamed `naviback.dm_targets_limit` to `naviback.dmTargetsLimit`
- Renamed `naviback.termination_grace_period_seconds` to `naviback.terminationGracePeriodSeconds`

### navi-async-matrix
- Updated structure and defaults for Kafka configuration
- Renamed `s3.url` to `s3.host`
- Renamed `s3.keyId` to `s3.accessKey`
- Renamed `s3.key` to `s3.secretKey`
- Renamed `keys.endpoint` to `keys.host`
- Renamed `keys.dm_key` to `keys.token`

## [1.4.4]

#### keys
- Rename `db` to `postgres`
- Rename `admin.apiUrl` to `admin.api`
- Rename `admin.appHost` to `admin.host`

## [1.4.1]

#### navi-async-matrix
- Resources limits are not set by default.
- Mandatory dependency on API Keys service with a valid API key required.

#### navi-back
- Default values optimized for processing async-matrix.

## [1.3.3]

#### catalog-api
- Rename value db to api.db
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

#### keys
- For the HPA section, switched from `autoscaling/v2beta2` to `autoscaling/v2`

#### gis-platform
- REMOVED `.Values.spcore.s3.preview_bucket`. Move its contents to `.Values.spcore.s3.bucket`
- ADDED `.Values.spcore.s3.session_bucket`. Create it before updating

#### mapgl-js-api
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

#### navi-async-matrix
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

#### navi-back
- Rename `autoscaling` to `hpa`
- Rename `autoscaling.scaleUpWindowSeconds` to `hpa.scaleUpStabilizationWindowSeconds`
- Rename `autoscaling.scaleDownWindowsSeconds` to `hpa.scaleDownStabilizationWindowSeconds`
- Rename `podDisruptionBudget` to `pdb`
- Rename `podDisruptionBudget.create` to `pdb.enabled`

#### navi-castle
- Remove the `autoscaling` section

#### navi-front
- Rename `autoscaling` to `hpa`
- Rename `pdb.create` to `pdb.enabled`
- For the HPA section, switched from `autoscaling/v2beta2` to `autoscaling/v2`

#### navi-restrictions
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

#### navi-router
- Rename `autoscaling` to `hpa`
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v2beta2` to `autoscaling/v2`

#### search-api
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

#### tiles-api
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

#### traffic-proxy
- Rename `podDisruptionBudget` to `pdb`

---
## [1.0.4]
#### tiles-api
- `.Values.cassandra.environment` is required

---
## [0.2.2]
#### keys
- change value `api.apiUrl` from 'http://servicename/admin/v1' to 'http://servicename'

---
## [0.1.9]
#### Production Ready release
