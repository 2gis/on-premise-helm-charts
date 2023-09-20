# 2GIS PRO API Service

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                            | Description                                                                                                                                    | Value     |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| `appName`                       | Name of the service.                                                                                                                           | `pro-api` |
| `replicaCount`                  | A replica count for the pod.                                                                                                                   | `2`       |
| `imagePullSecrets`              | Kubernetes image pull secrets.                                                                                                                 | `[]`      |
| `nameOverride`                  | Base name to use in all the Kubernetes entities deployed by this chart.                                                                        | `""`      |
| `fullnameOverride`              | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                                    | `""`      |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                            | `{}`      |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                    | `{}`      |
| `priorityClassName`             | Kubernetes [pod priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/).                                   | `""`      |
| `terminationGracePeriodSeconds` | Kubernetes [termination grace period](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/).                              | `60`      |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                              | `[]`      |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                  | `{}`      |
| `podLabels`                     | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                            | `{}`      |
| `annotations`                   | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`      |
| `labels`                        | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`      |
| `revisionHistoryLimit`          | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`       |

### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                                           | Value |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`. **Required**                                                                                                                                                                                                                        | `""`  |
| `dgctlStorage.bucket`    | S3 bucket name. **Required**                                                                                                                                                                                                                                          | `""`  |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket. **Required**                                                                                                                                                                                                                  | `""`  |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket. **Required**                                                                                                                                                                                                                  | `""`  |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json`.<br> This file contains the description of pieces of data that the service requires to operate. **Required** | `""`  |

### Strategy settings

| Name                                    | Description                                                                                                                                                                                              | Value           |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |

### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)               | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | PRO API service port.                                                                                                          | `80`        |

### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                    | Description                                                                                                  | Value   |
| ----------------------- | ------------------------------------------------------------------------------------------------------------ | ------- |
| `vpa.enabled`           | If VPA is enabled for the service.                                                                           | `false` |
| `vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start). | `Auto`  |
| `vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down.                                   | `400m`  |
| `vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down.                                         | `256M`  |
| `vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up.                                     | `1`     |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up.                                           | `1024M` |

### Deployment settings

| Name               | Description | Value                     |
| ------------------ | ----------- | ------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/pro-api` |
| `image.tag`        | Tag         | `1.1.39`                  |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`            |

### 2GIS PRO Storage configuration

| Name                      | Description                                                                 | Value |
| ------------------------- | --------------------------------------------------------------------------- | ----- |
| `s3.assetsDataBucket`     | S3 bucket with base urbi assets, aggregations, and filters. **Required**    | `""`  |
| `s3.userAssetsDataBucket` | S3 bucket with user-created assets, aggregations, and filters. **Required** | `""`  |
| `s3.layerDataBucket`      | S3 bucket with prepared layer data. **Required**                            | `""`  |
| `s3.snapshotBucket`       | S3 bucket for storing snapshots of inclemental data updates. **Required**   | `""`  |

### 2GIS PRO API configuration

| Name                                  | Description                                                                                                                                             | Value    |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| `api.serviceAccount`                  | Kubernetes service account                                                                                                                              | `runner` |
| `api.tempPath`                        | Path to directory used for temp data                                                                                                                    | `/tmp`   |
| `api.allowAnyOrigin`                  | Cors policy: allow any origin to perform requests to pro-api service                                                                                    | `false`  |
| `api.licensePartner`                  | Name of a partner for license verification. **Required**                                                                                                | `""`     |
| `api.logging`                         | Logging settings                                                                                                                                        |          |
| `api.logging.format`                  | Log message format, possible options: 'default' - compact json, 'renderedCompactJson' - rendered json format, 'simple' - plain text                     | `simple` |
| `api.logging.targets`                 | Collection of logging targets divided by comma. Currently only 'console' and 'database' are supported. Console is used by default (no need to specify). | `""`     |
| `api.rateLimiter`                     | rate limiter settings                                                                                                                                   |          |
| `api.rateLimiter.requestsLimit`       | max number of requests from one user during time window (0 means rate limiter is disabled)                                                              | `0`      |
| `api.rateLimiter.windowSizeInSeconds` | the size of time windows to count and limit incoming requests                                                                                           | `1`      |

### Auth configuration

| Name                         | Description                                                                                                                                                                                                                                 | Value   |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `auth.type`                  | Authentication type: 'none' - disabled, 'openid10' - [OpenId 1.0 / OAuth 2.0 authentication protocol](https://openid.net/specs/openid-connect-core-1_0.html), 'urbi' - urbi authentication protocol                                         | `none`  |
| `auth.url`                   | API URL of authentication service. Example: `http(s)://keycloak.ingress.host`                                                                                                                                                               | `""`    |
| `auth.userInfoEndpoint`      | The [UserInfo endpoint](https://openid.net/specs/openid-connect-core-1_0.html#UserInfo). Example: `realms/URBI_Pro/protocol/openid-connect/userinfo`                                                                                        | `""`    |
| `auth.apiKey`                | Secret API Key to perform authorized service actions, random string. Must be set if type not 'none'. Example: `4230b288-301e-4ec6-82c6-db6a8a72c2af`                                                                                        | `""`    |
| `auth.permissionsApiKey`     | Secret Permissions API Key to perform authorized service actions, random string. Must be set if type not 'none'. Example: `c7d74870-ec28-4543-b408-b49bfed84399`                                                                            | `""`    |
| `auth.turnOffCertValidation` | Turn off certificate validation for auth.url                                                                                                                                                                                                | `false` |
| `auth.shareKeys`             | Secret keys for creating and validating shared links. Must contain at least 32 characters. All keys are used for validation. The last one is used for creation. Example: `m7nShlX1a8+IqE9ZcDqRCVjlhEud850ucT0av9bS+tcMTwIwUOUqpNikM+G8teDR` | `[]`    |

### PostgreSQL settings

| Name                                | Description                                                                                                                | Value |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ----- |
| `postgres.connectionString`         | Connection string to the PostgreSQL database. Format: `Server=SERVER_URL;Database=DB_NAME;UID=USER_NAME;`                  | `""`  |
| `postgres.connectionStringReadonly` | Connection string to the readonly node of PostgreSQL database. Format: `Server=SERVER_URL;Database=DB_NAME;UID=USER_NAME;` | `""`  |
| `postgres.password`                 | User password to connect to the PostgreSQL database.                                                                       | `""`  |

### Keys Service settings

| Name         | Description                                                                              | Value |
| ------------ | ---------------------------------------------------------------------------------------- | ----- |
| `keys.url`   | API URL of service for managing partners' keys to 2GIS services (keys.api). **Required** | `""`  |
| `keys.token` | keys.api access token. **Required**                                                      | `""`  |

### ElasticSearch settings (supported version 7.x)

| Name                  | Description                                                                          | Value |
| --------------------- | ------------------------------------------------------------------------------------ | ----- |
| `elastic.host`        | ElasticSearch host address. Format: `http(s)://HOST:PORT`                            | `""`  |
| `elastic.credentials` | User name and password to connect to the ElasticSearch. Format: `USER_NAME:PASSWORD` | `""`  |

### Redis settings (supported version 6.x)

| Name             | Description                       | Value  |
| ---------------- | --------------------------------- | ------ |
| `redis.host`     | Redis host address. **Required**  | `""`   |
| `redis.port`     | Redis port. **Required**          | `6379` |
| `redis.username` | Username used to connect to Redis | `""`   |
| `redis.password` | Password used to connect to Redis | `""`   |

### Kafka settings (supported version 2.7)

| Name                                   | Description                                                                                                     | Value           |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------- | --------------- |
| `kafka.bootstrapServers`               | Kafka bootstrap servers. Format: 'host1:port1,host2:port2'                                                      | `""`            |
| `kafka.securityProtocol`               | Kafka security protocol. Supported options: SaslPlaintext.                                                      | `SaslPlaintext` |
| `kafka.sasl`                           | **Kafka sasl settings** (see [the documentation](https://kafka.apache.org/documentation/#security_sasl_config)) |                 |
| `kafka.sasl.mechanism`                 | Kafka sasl mechanism. Supported options: ScramSha512.                                                           | `ScramSha512`   |
| `kafka.sasl.username`                  | Kafka sasl username.                                                                                            | `""`            |
| `kafka.sasl.password`                  | Kafka sasl password.                                                                                            | `""`            |
| `kafka.assetTopicsReaderGroupId`       | Kafka consumer group for reading streaming assets data.                                                         | `""`            |
| `kafka.importTasksTopic`               | Kafka topic settings to run import tasks.                                                                       |                 |
| `kafka.importTasksTopic.name`          | Kafka topic name.                                                                                               | `""`            |
| `kafka.importTasksTopic.readerGroupId` | Kafka consumer group for reading importing tasks.                                                               | `""`            |
| `kafka.refreshAssetsIntervalMinutes`   | Refresh interval for reading streaming assets settings in minutes.                                              | `60`            |

### Import background jobs settings

| Name                                      | Description                                                      | Value   |
| ----------------------------------------- | ---------------------------------------------------------------- | ------- |
| `backgroundJobs.enableUserAssetsImporter` | If user data importer job is enabled for the service.            | `true`  |
| `backgroundJobs.enableAssetsStreaming`    | If the streaming data processing job is enabled for the service. | `false` |

### Catalog API settings

| Name          | Description                                                              | Value                    |
| ------------- | ------------------------------------------------------------------------ | ------------------------ |
| `catalog.url` | URL for [Catalog API](https://docs.2gis.com/en/on-premise/search).       | `http://catalog-api.svc` |
| `catalog.key` | Access key to [Catalog API](https://docs.2gis.com/en/on-premise/search). | `""`                     |

### Navigation API settings

| Name       | Description                                                                              | Value                  |
| ---------- | ---------------------------------------------------------------------------------------- | ---------------------- |
| `navi.url` | URL for [Navigation API](https://docs.2gis.com/en/on-premise/navigation/overview).       | `http://navi-back.svc` |
| `navi.key` | Access key to [Navigation API](https://docs.2gis.com/en/on-premise/navigation/overview). | `""`                   |

### Search API settings

| Name         | Description                                                      | Value                   |
| ------------ | ---------------------------------------------------------------- | ----------------------- |
| `search.url` | URL for [Search API](https://docs.2gis.com/en/on-premise/search) | `http://search-api.svc` |

### 2GIS PRO API Job settings

| Name                       | Description                | Value                 |
| -------------------------- | -------------------------- | --------------------- |
| `appAssetImporterName`     | Data Import job name.      | `asset-importer`      |
| `appUserAssetImporterName` | User Data Import job name. | `user-asset-importer` |

### 2GIS PRO Permissions API configuration

| Name                     | Description                                   | Value   |
| ------------------------ | --------------------------------------------- | ------- |
| `permissionsApi.enabled` | If permissionsApi is enabled for the service. | `false` |

### Import job settings

| Name                                       | Description                                                                                                                                              | Value                          |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `assetImporter.repository`                 | Docker Repository Image.                                                                                                                                 | `2gis-on-premise/pro-importer` |
| `assetImporter.tag`                        | Docker image tag.                                                                                                                                        | `1.1.39`                       |
| `assetImporter.schedule`                   | Import job schedule.                                                                                                                                     | `0 18 * * *`                   |
| `assetImporter.backoffLimit`               | The number of [retries](https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy) before considering a Job as failed.   | `2`                            |
| `assetImporter.successfulJobsHistoryLimit` | How many completed and failed jobs should be kept. See [docs](https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/#jobs-history-limits). | `3`                            |
| `assetImporter.nodeSelector`               | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                      | `{}`                           |
| `assetImporter.maxParallelJobs`            | How many import jobs can be run simultaneously                                                                                                           | `1`                            |
| `assetImporter.enabled`                    | If assetImporter is enabled for the service.                                                                                                             | `true`                         |
| `assetImporter.startOnDeploy`              | Indicates that asset import should start when service installed or updated                                                                               | `true`                         |
| `assetImporter.imageProxyUrl`              | URL to proxy image links (including query parameters, if any, i.e. 'https://someserver.com/proxy?url=' )                                                 | `""`                           |
| `assetImporter.externalLinksProxyUrl`      | URL to proxy http links from assets data (including query parameters, if any, i.e. 'https://someserver.com/proxy?url=' )                                 | `""`                           |

### Limits

| Name                                      | Description                            | Value   |
| ----------------------------------------- | -------------------------------------- | ------- |
| `resources`                               | **Limits for the application service** |         |
| `resources.requests.cpu`                  | A CPU request.                         | `400m`  |
| `resources.requests.memory`               | A memory request.                      | `256M`  |
| `resources.limits.cpu`                    | A CPU limit.                           | `1`     |
| `resources.limits.memory`                 | A memory limit.                        | `1024M` |
| `assetImporter.resources`                 | **Limits for the import job**          |         |
| `assetImporter.resources.requests.cpu`    | A CPU request.                         | `700m`  |
| `assetImporter.resources.requests.memory` | A memory request.                      | `768M`  |
| `assetImporter.resources.limits.cpu`      | A CPU limit.                           | `1000m` |
| `assetImporter.resources.limits.memory`   | A memory limit.                        | `2560M` |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                           | Description                               | Value                 |
| ------------------------------ | ----------------------------------------- | --------------------- |
| `ingress.enabled`              | If Ingress is enabled for the service.    | `true`                |
| `ingress.className`            | Name of the Ingress controller class.     | `nginx`               |
| `ingress.hosts.host`           | Hostname for the Ingress service.         | `pro-api.example.com` |
| `ingress.hosts.paths.path`     | Path of the host for the Ingress service. | `/`                   |
| `ingress.hosts.paths.pathType` | Type of the path for the Ingress service. | `Prefix`              |
| `ingress.tls`                  | TLS configuration                         | `[]`                  |


## Installing

1. Create a configuration file values-api.yaml and fill in all the required parameters according to the docs above.
2. Then execute command:<br/>
`- helm upgrade "pro-api" --install --atomic --wait --wait-for-jobs --timeout 10m --values ./values-api.yaml`
3. Check installation by executing request<br/>
`https://pro-api.host/health/ready`
4. If this is the initial installation of the service, wait for a while for the data import process to complete.<br/>
This may take from several minutes to several hours depending on the number of territories available and your environment.
To check import progress you can use request<br/>
`https://pro-api.host/tasks/working`
5. Check installation by executing request<br/>
`https://pro-api.host/bounds?wkt=POLYGON((-170.507812 83.676943,-167.343750 -62.267922,213.398437 -63.391521,197.2265625 83.559716,-170.507812 83.676943))`
<br/>The response must contain bound of any territory in json format, response http code = 200

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
