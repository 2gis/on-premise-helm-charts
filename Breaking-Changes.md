# 2GIS On-Premise Breaking-Changes

## [x.y.z]

### navi-router

- `router.keyManagementService.apis.*` tokens renamed, `-api` suffix added

## [1.14.0]

### keys-api

- Added new required dgctlStorage parameters

```yaml
dgctlStorage:
  host: ''
  bucket: keys
  accessKey: ''
  secretKey: ''
  manifest: manifest.json
```

## [1.13.0]

### tiles-api

- Backward compatibility with `license` versions before `2.0.0` (on-premise version `1.8.0`) is broken.
- License v2 over HTTPS is required.
- Update migrations, when updating the service you need to update the data

### pro-api

- Add required topic `assetDataTopic`

## [1.12.0]

### navi-async-matrix

- Remove `hpa.scaleUpStabilizationWindowSeconds` and `.hpa.scaleDownStabilizationWindowSeconds`
- Add `hpa.behavior`

```yaml
hpa:
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 500
    scaleDown:
      stabilizationWindowSeconds: 600
```

## [1.10.0]

### pro-api

- Added new required setting api.licensePartner. Now pro-api only works with a valid license file, which can be requested from your sales manager. The license file must be placed in the s3.assetsDataBucket.

## [1.9.1]

### license

- Added `license.type`
- Added `persistence`

```yaml
persistence:
  type: s3
  fs:
    storage: 10Mi
    storageClassName: ''
  s3:
    host: ''
    bucket: ''
    root: ''
    accessKey: ''
    secretKey: ''
```

## [1.7.6]

### pro-api

- Added new setting s3.assetsDataBucket. dgclStorage.bucket and buckets for the service app are completely separate now.

## [1.7.5]

### gis-platform

- Rename `external_proto` and `external_hostname` to `url`
- Rename `spcore.debug_mode` to `spcore.debug`
- Rename `spcore.reset_cluster` to `spcore.resetCluster`
- Rename `spcore.update_db` to `spcore.updateDb`
- Rename `spcore.cloud_port` to `spcore.nodePort`
- Rename `spcore.http_port` to `spcore.appPort`
- Rename `spcore.sync_parameters` to `spcore.syncParameters`
- Rename `spcore.cors.allow_everyone` to `spcore.cors.allowEveryone`
- Rename `spcore.s3.access_key` to `spcore.s3.accessKey`
- Rename `spcore.s3.secret_key` to `spcore.s3.secretKey`
- Rename `spcore.s3.session_bucket` to `spcore.s3.sessionBucket`
- Rename `spcore.pg` to `spcore.postgres`
- Rename `spcore.pg.user` to `spcore.postgres.username`
- Rename `spcore.pg.dbname` to `spcore.postgres.name`
- Rename `spcore.jwt.token_key` to `spcore.jwt.tokenKey`
- Rename `spcore.jwt.token_admin` to `spcore.jwt.tokenAdmin`
- Rename `portal.max_body_size` to `portal.maxBodySize`
- Rename `portal.gzip_enabled` to `portal.gzip.enabled`

### citylens

- Remove `kafka.topics.prediction`
- Remove `kafka.topics.framesGroupId`
- Remove `kafka.topics.tracksGroupId`
- Remove `kafka.topics.predictionGroupId`
- Remove `kafka.topics.camcomSenderGroupId`
- Add `kafka.predictors`

```
kafka:
  predictors:
  - name: ''
    topic: ''
```

- Add `kafka.consumerGroups.prefix`

## [1.6.0]

### catalog-api

- Rename

```
keys.tokens
```

to

```
keys.token
```

### navi-router

- For zero downtime, update navi-router first, then update keys

## [1.5.3]

### tiles-api

- Rename

```
serviceName: tiles-api-webgl
type: web
```

to

```
types:
  - kind: web
```

- Rename

```
serviceName: tiles-api-raster
type: raster
```

to

```
types:
  - kind: raster
```

### navi-restrictions

- Rename `api_key` to `api.api_key`


## [1.4.7]

### catalog-api

- Rename `search.host` to `search.url`
- Rename `keys.host` to `keys.url`

### keys

- Remove `admin.api`

### tiles-api

- Rename `proxy.access.host` to `proxy.access.url`

### navi-async-matrix

- Renamed `keys.host` to `keys.url`

### pro-ui

- Renamed `api.host` to `api.url`


## [1.4.5]

### navi-castle

- Renamed `castle.castle_data_path` to `castle.castleDataPath`
- Renamed `castle.restrictions_api_url` to `castle.restrictions.host`
- Renamed `castle.restrictions_api_key` to `castle.restrictions.key`

### navi-router

- Renamed `router.app_port` to `router.appPort`
- Renamed `router.app_castle_host` to `router.castleHost`
- Renamed `router.additional_sections` to `router.additionalSections`

### navi-back

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
- Renamed `naviback.simple_network_bicycle` to `naviback.simpleNetwork.bicycle`
- Renamed `naviback.simple_network_car` to `naviback.simpleNetwork.car`
- Renamed `naviback.simple_network_emergency` to `naviback.simpleNetwork.emergency`
- Renamed `naviback.simple_network_pedestrian` to `naviback.simpleNetwork.pedestrian`
- Renamed `naviback.simple_network_taxi` to `naviback.simpleNetwork.taxi`
- Renamed `naviback.simple_network_truck` to `naviback.simpleNetwork.truck`
- Renamed `naviback.attractor_bicycle` to `naviback.attractor.bicycle`
- Renamed `naviback.attractor_car` to `naviback.attractor.car`
- Renamed `naviback.attractor_pedestrian` to `naviback.attractor.pedestrian`
- Renamed `naviback.attractor_taxi` to `naviback.attractor.taxi`
- Renamed `naviback.reduce_edges_optimization_flag` to `naviback.reduceEdgesOptimizationFlag`

### navi-async-matrix

- Renamed `s3.url` to `s3.host`
- Renamed `s3.keyId` to `s3.accessKey`
- Renamed `s3.key` to `s3.secretKey`
- Renamed `keys.endpoint` to `keys.host`
- Renamed `keys.dm_key` to `keys.token`

### keys

- Rename `db` to `postgres`
- Rename `admin.apiUrl` to `admin.api`
- Rename `admin.appHost` to `admin.host`

### search-api

- Rename `redeploy_label` to `redeployLabel`
- Rename `api.data_dir` to `api.dataDir`
- Rename `api.fcgi_port` to `api.fcgiPort`
- Rename `nginx.http_port` to `nginx.httpPort`

### catalog-api

- Rename `dgctlStorage.endpoint` to `dgctlStorage.host`
- Rename `keys.endpoint` to `keys.host`
- Rename `api.db` to `api.postgres`
- Rename `importer.db` to `importer.postgres`
- Rename `search.url` to `search.host`
- Rename `keys.serviceKeys` to `keys.tokens`

## [1.4.1]

### navi-async-matrix

- Resources limits are not set by default.
- Mandatory dependency on API Keys service with a valid API key required.

### navi-back

- Default values optimized for processing async-matrix.

## [1.3.3]

### catalog-api

- Rename value db to api.db
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

### keys

- For the HPA section, switched from `autoscaling/v2beta2` to `autoscaling/v2`

### gis-platform

- REMOVED `.Values.spcore.s3.preview_bucket`. Move its contents to `.Values.spcore.s3.bucket`
- ADDED `.Values.spcore.s3.session_bucket`. Create it before updating

### mapgl-js-api

- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

### navi-async-matrix

- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

### navi-back

- Rename `autoscaling` to `hpa`
- Rename `autoscaling.scaleUpWindowSeconds` to `hpa.scaleUpStabilizationWindowSeconds`
- Rename `autoscaling.scaleDownWindowsSeconds` to `hpa.scaleDownStabilizationWindowSeconds`
- Rename `podDisruptionBudget` to `pdb`
- Rename `podDisruptionBudget.create` to `pdb.enabled`

### navi-castle

- Remove the `autoscaling` section

### navi-front

- Rename `autoscaling` to `hpa`
- Rename `pdb.create` to `pdb.enabled`
- For the HPA section, switched from `autoscaling/v2beta2` to `autoscaling/v2`

### navi-restrictions

- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

### navi-router

- Rename `autoscaling` to `hpa`
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v2beta2` to `autoscaling/v2`

### search-api

- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

### tiles-api

- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

### traffic-proxy

- Rename `podDisruptionBudget` to `pdb`

---

## [1.0.4]

### tiles-api

- `.Values.cassandra.environment` is required

---

## [0.2.2]

### keys

- change value `api.apiUrl` from 'http://servicename/admin/v1' to 'http://servicename'

---

## [0.1.9]

### Production Ready release
