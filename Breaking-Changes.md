# 2GIS On-Premise Breaking-Changes

## [NEW_VERSION]

### pro-ui

- You need to upgrade MapGL to version 1.61.0

## [1.39.1]

### navi-async-matrix

- `kafka.statusTopic` and `kafka.archiveTopic` were no longer used
- new required params `kafka.mergerStatusTopic` and `kafka.mergerTaskTopic`
- `rbac` was removed

## [1.38.0]

### citylens-routes-ui

- env.SSO_PROXY_ENABLED was removed

### pro-api
- elastic.host and elastic.port were removed, elastic.nodes was added instead.
- Minimum supported Postgres version is now 15
- Labels in tasks/deployment-worker.yaml have changed. You need to remove the tasks-worker and install it again.

### tiles-api

- Single `proxy.access.token` has been split into two separate tokens:
  - `proxy.access.raster.token` - for raster data authentication
  - `proxy.access.vector.token` - for vector data authentication

## [1.37.1]

### citylens-routes-ui

- env.PLATFORM_MANAGER_API_URL renamed to env.SSO_API_URL
- env.PLATFORM_MANAGER_CLIENT_ID renamed to env.SSO_CLIENT_ID
- env.PLATFORM_MANAGER_CLIENT_SECRET renamed to env.SSO_CLIENT_SECRET
- env.PLATFORM_MANAGER_SCOPE renamed to env.SSO_SCOPE

### mapgl-js-api

- env.MAPGL_FLOORSSERVER was removed

### floors-api

- Chart floors-api was removed

### navi-async-matrix

- Now attraction works only through an external attractor.

```yml
  attractTopicRules:
  - topic: attract_car_task_topic
    default: true
    type: car
  - topic: attract_truck_task_topic
    default: true
    type: truck
```

- Archiver always enabled. Required `serviceAccount` and `rbac`.

## [1.37.0]

### pro-ui

- Updated a config verification code. If the config is not valid your application will be stopped.

### pro-api

- tasksApi.useForLayerDataPreparation is true by default
- added tasks settings, tasks.settings.enabled is true by default
- added required postgres settings for tasks and permissions: host, port, name, username, password
- elastic settings are set to standard, host must contain only the host, secure and port are mandatory, username and password can be set if needed, credentials is removed

## [1.36.0]

### keys

- The in-chart Redis deployment has been **removed**. You must configure an **external Redis instance** for the application to function **before upgrading**. If you were using the in-chart Redis instance for additional tasks, make sure to **migrate those workloads** to a different Redis instance before proceeding with the upgrade.

## [1.35.0]

### platform

- Added `ui.playgrounds` for enable playgrounds on the playground page

### pro-ui

- You need to upgrade MapGL to version 1.54.1
- Updated ui.auth.oAuthProvider. Removed "ugc" value. Now possible values: "keycloak" | "openid". "keycloak" value is deprecated.

### pro-api

- api.settings.allowAnyOrigin was removed, api.settings.corsOrigins was added instead
- assetImporter.enabled was removed, assetImporter is now always mandatory

### navi-async-matrix

- Existing DBs need task status type updated, in case public schema used:

  ```
  ALTER TYPE public."statusvalues" ADD VALUE 'ATTRACT_PUSHED';
  ALTER TYPE public."statusvalues" ADD VALUE 'ATTRACT_READY';
  ALTER TYPE public."statusvalues" ADD VALUE 'ATTRACT_PROCESSED';
  ALTER TYPE public."statusvalues" ADD VALUE 'ONE_TO_MANY_PUSHED';
  ALTER TYPE public."statusvalues" ADD VALUE 'ONE_TO_MANY_READY';
  ALTER TYPE public."statusvalues" ADD VALUE 'MERGER_PUSHED';
  ALTER TYPE public."statusvalues" ADD VALUE 'MERGER_IN_PROGRESS';
  ```

### citylens

- Before installing new version of citylens it is required to prepare database manually:
  `update tracks set localization_status = 2006;`
  This is required as in on-premise environments this column was newer user before, and may contain unexpected values.
- Values section `.Values.reporters` replaced with `.Values.worker.reporterPro.enabled` field.
- Worker `.Values.worker.detectionsLocalizer` requires
  - Asset "Objects" in Pro and topic `.Values.kafka.topics.proObjects` to be tied to that asset
  - topic `.Values.kafka.topics.objectsLifecycle` required
- Added new services: `citylens-routes-api` and `citylens-worker-service`
- Added new required parameters:
  - `.Values.routes.postgres.database`
  - `.Values.routes.hangfire.postgres.database`
  - `.Values.routes.navi.url`

## [1.34.0]

### keys

- Before upgrading to the next version, make sure to update to the current version (1.34.0).
- Ensure that `keys` service is upgraded prior to upgrading any of the `navi` services.
- A temporary flag, `--migrate-data`, has been added for this release. This flag triggers the data migration required for the Routing API data in the service.

### navi-castle

- `castle.restrictions.host` renamed to `castle.restrictions.url` and empty by default
- `persistentVolume.storageClass` is now empty by default

## [1.33.0]

### pro-api

- permissions.settings.enabled was removed, permissions api is now always mandatory
- postgres.connectionString, postgres.connectionStringReadonly, postgres.password were changed to postgres.api.rw / postgres.api.ro settings

## [1.32.0]

### tiles-api

- proxy.access.bss.enabled renamed to proxy.access.stat.enabled
- proxy.access.bss.url renamed to proxy.access.stat.url

## [1.30.0]

### pro-api

- api.pod.appName renamed api.appName
- api.settings.enableUserAssetsImporter renamed to api.settings.backgroundJobs.enableUserAssetsImporter
- api.settings.enableAssetsStreaming renamed to api.settings.backgroundJobs.enableAssetsStreaming
- api.settings.auth.permissionsApiKey renamed permissions.settings.auth.apiKey

## [1.29.0]

### mapgl-js-api

- MAPGL_ICONSPATH renamed to MAPGL_ICONS_URL
- MAPGL_MODELSPATH renamed to MAPGL_MODELS_URL

### pro-api

- appName renamed to api.appName
- image renamed to api.image
- ingress renamed to api.ingress
- pod renamed to api.pod
- vpa renamed to api.vpa
- service renamed to api.service
- licenseKey renamed to api.settings.licenseKey
- api.tempPath renamed to api.settings.tempPath
- api.allowAnyOrigin renamed to api.settings.allowAnyOrigin
- api.logEsQueries renamed to api.settings.logEsQueries
- api.debug renamed to api.settings.debug
- api.env renamed to api.settings.env
- api.filterByZoneCodes renamed to api.settings.filterByZoneCodes
- api.esDataCentersCount renamed to api.settings.esDataCentersCount
- api.rateLimiter renamed to api.settings.rateLimiter
- api.localCache renamed to api.settings.localCache
- api.openApi renamed to api.settings.openApi
- auth renamed to api.settings.auth
- permissionsApiImage renamed to permissions.image
- permissionsApiIngress renamed to permissions.ingress
- permissionsPodSettings renamed to permissions.pod
- permissionApiService renamed to permissions.service
- add permissions.settings block
- add assetImporter.appName
- assetImporter.maxParallelJobs renamed to assetImporter.settings.maxParallelJobs
- assetImporter.files renamed to assetImporter.settings.files
- assetImporter.imageProxyUrl renamed to assetImporter.settings.imageProxyUrl
- assetImporter.externalLinksProxyUrl renamed to assetImporter.settings.externalLinksProxyUrl
- assetImporter.externalLinksAllowedHosts renamed to assetImporter.settings.externalLinksAllowedHosts
- assetImporter.esMetricsEnabled renamed to assetImporter.settings.esMetricsEnabled
- assetPreparer.maxParallelJobs renamed to assetPreparer.settings.maxParallelJobs

## [1.28.0]

### navi-async-matric

- `s3.publicNetloc` now MUST start with `http://` or `https://` scheme

## [1.27.0]

### catalog-api

- Backward compatibility with `license` versions before `2.0.0` (on-premise version `1.8.0`) is broken.
- License v2 over HTTPS is required.

### pro-ui

- ui.strategy renamed to strategy
- ui.image renamed to image
- ui.replicas renamed to replicas
- ui.revisionHistoryLimit renamed to revisionHistoryLimit
- ui.terminationGracePeriodSeconds renamed to terminationGracePeriodSeconds
- ui.nodeSelector renamed to nodeSelector
- ui.affinity renamed to affinity
- ui.tolerations renamed to tolerations
- ui.podAnnotations renamed to podAnnotations
- ui.podLabels renamed to podLabels
- ui.annotations renamed to annotations
- ui.labels renamed to labels
- ui.readinessProbe renamed to readinessProbe
- ui.livenessProbe renamed to livenessProbe
- ui.containerPort renamed to containerPort
- ui.service renamed to service
- ui.ingress renamed to ingress
- ui.resources renamed to resources
- ui.hpa renamed to hpa

## [1.26.0]

### citylens

- Added new worker `worker.dashboardBatchEvents`
- Added new kafka topics
  - `kafka.topics.tracksLifecycle` - tracks lifecycle events
  - `kafka.topics.proDrivers` - synchonization drivers tracks with Pro

## [1.24.0]

### pro-api

- Added new required parameters: licenseKey, license.url
- Removed api.licensePartner

### citylens

- Parameter `pro.url` replaced with `pro.baseUrl` and `pro.framesAssetId` (ex: `pro.url: "http://pro-api:8080/my_asset/filters"` -> `pro.baseUrl: "http://pro-api:8080"` , `pro.framesAssetId: "my_asset"`)

## [1.22.0]

## citylens

- `kafka.predictors` is removed. Topics `kafka.predictors[0].topic` (`camcom` in values example), `kafka.predictors[1].topic` (`manual` in values example) replaced with single topic `kafka.topics.predictions`.

### pro-api

- Added new required parameters: kafka.eventsTopic.name, kafka.eventsTopic.readerGroupId

## [1.21.0]

### navi-restrictions

- `api.api_key` renamed to `api.key`
- `api.is_init_db` renamed to `api.isInitDb`
- `db` renamed to `postgres`
- `cron.max_attributes_fetcher_rps` renamed to `cron.maxAttributesFetcherRps`
- `api.attractor_url`, `cron.edges_url_template` and `cron.edge_attributes_url_template` are deprecated. Set `naviBackHost` and `naviCastleHost` with `api.attractorUri`, `cron.edgeAttributesUriTemplate` and `cron.maxAttributesFetcherRps` instead
- New values required `naviBackHost`, `naviCastleHost`

### citylens

- `worker.reporterProTracks.replicas` replaced with `worker.reporterProTracks.enabled`. One replica will be deployed if enabled.

## [1.20.0]

### navi-router

- `router.keyManagementService.host` renamed to `router.keyManagementService.url`
- `router.keyManagementService` renamed to `keys`
- `router.castleHost` renamed to `router.castleUrl`

### citylens

- Backward compatibility for citylens 1.6.0 is broken:
  - Parameter `api.auth.camcomToken` is replaced with `api.auth.predictorsTokens.camcom`
  - License v2 service now required: `api.licensing.url`
  - Parameter `map.tileserverUrl` now required
  - Parameters group `worker.reporterProTracks` now required
  - Database structure changed

## [1.17.0]

### citylens

- Backward compatibility for citylens 1.3.0 is broken. Parameters `api.auth.publicKey` and `api.auth.algoritm` are replaced
  with `api.auth.authServerUrl`, `api.auth.realm`, `api.auth.verifySsl`.

### license

- Backward compatibility for license v1 is broken. If you have a version lower than `1.9.1`, you need to upgrade first
  to version `1.16.0` to get license v2 without downtime - after that you can upgrade to version `1.17.0`.
- Removed `fs` persistence type, now only `s3` is available. `persistence.type` is no more provided, old `persistence.s3`
  settings now should be located under `persistence`.

  ```yaml
  --- # old
  persistence:
    type: s3
    s3: ...
  --- # new
  persistence: ...
  ```

### navi-back

- added integration with license service (v2), mandatory for recent navi-back versions

  ```yaml
  license:
    url: https://license
  ```

- renamed parameter naviback.ecaHost to naviback.ecaUrl
- `livenessProbeDelay` and `readinessProbeDelay` are ignored in favor of startup probes

## [1.16.0]

### catalog-api

- Changes in data for catalog, if you have a version lower than 1.16.0, you need to update to version 1.16.0 to get the latest data

## [1.15.0]

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
