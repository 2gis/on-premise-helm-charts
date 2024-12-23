# 2GIS PRO API Service

## Values

### Geo API configuration & settings

| Name                                                        | Description                                                                                                                                                                                                                                            | Value                     |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------- |
| `api.appName`                                               | Name of the service                                                                                                                                                                                                                                    | `pro-api`                 |
| `api.image.repository`                                      | Repository                                                                                                                                                                                                                                             | `2gis-on-premise/pro-api` |
| `api.image.tag`                                             | Tag                                                                                                                                                                                                                                                    | `1.54.0`                  |
| `api.image.pullPolicy`                                      | Pull Policy                                                                                                                                                                                                                                            | `IfNotPresent`            |
| `api.ingress.enabled`                                       | If Ingress is enabled for the service.                                                                                                                                                                                                                 | `false`                   |
| `api.ingress.className`                                     | Name of the Ingress controller class.                                                                                                                                                                                                                  | `nginx`                   |
| `api.ingress.hosts[0].host`                                 | Hostname for the Ingress service.                                                                                                                                                                                                                      | `pro-api.example.com`     |
| `api.ingress.hosts[0].paths[0].path`                        | Path of the host for the Ingress service.                                                                                                                                                                                                              | `/`                       |
| `api.ingress.hosts[0].paths[0].pathType`                    | Type of the path for the Ingress service.                                                                                                                                                                                                              | `Prefix`                  |
| `api.ingress.tls`                                           | TLS configuration                                                                                                                                                                                                                                      | `[]`                      |
| `api.pod.replicaCount`                                      | A replica count for the pod.                                                                                                                                                                                                                           | `2`                       |
| `api.pod.imagePullSecrets`                                  | Kubernetes image pull secrets.                                                                                                                                                                                                                         | `[]`                      |
| `api.pod.nameOverride`                                      | Base name to use in all the Kubernetes entities deployed by this chart.                                                                                                                                                                                | `""`                      |
| `api.pod.fullnameOverride`                                  | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                                                                                                                                            | `""`                      |
| `api.pod.nodeSelector`                                      | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                                                                    | `{}`                      |
| `api.pod.affinity`                                          | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                                                                                                            | `{}`                      |
| `api.pod.priorityClassName`                                 | Kubernetes [pod priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/).                                                                                                                                           | `""`                      |
| `api.pod.terminationGracePeriodSeconds`                     | Kubernetes [termination grace period](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/). Should be at least 300 seconds                                                                                                       | `300`                     |
| `api.pod.tolerations`                                       | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                                                                                      | `[]`                      |
| `api.pod.podAnnotations`                                    | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                                                          | `{}`                      |
| `api.pod.podLabels`                                         | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                                                                    | `{}`                      |
| `api.pod.annotations`                                       | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                                                              | `{}`                      |
| `api.pod.labels`                                            | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                                                                        | `{}`                      |
| `api.pod.revisionHistoryLimit`                              | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                                                                                                         | `3`                       |
| `api.pod.resources`                                         | **Limits for the application service**                                                                                                                                                                                                                 |                           |
| `api.pod.resources.requests.cpu`                            | A CPU request.                                                                                                                                                                                                                                         | `400m`                    |
| `api.pod.resources.requests.memory`                         | A memory request.                                                                                                                                                                                                                                      | `256M`                    |
| `api.pod.resources.limits.cpu`                              | A CPU limit.                                                                                                                                                                                                                                           | `1`                       |
| `api.pod.resources.limits.memory`                           | A memory limit.                                                                                                                                                                                                                                        | `1024M`                   |
| `api.pod.strategy.type`                                     | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                                                                   | `RollingUpdate`           |
| `api.pod.strategy.rollingUpdate.maxUnavailable`             | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment).                                               | `0`                       |
| `api.pod.strategy.rollingUpdate.maxSurge`                   | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                                                                   | `1`                       |
| `api.vpa.enabled`                                           | If VPA is enabled for the service.                                                                                                                                                                                                                     | `false`                   |
| `api.vpa.updateMode`                                        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start).                                                                                                                                           | `Auto`                    |
| `api.vpa.minAllowed.cpu`                                    | Lower limit for the number of CPUs to which the autoscaler can scale down.                                                                                                                                                                             | `400m`                    |
| `api.vpa.minAllowed.memory`                                 | Lower limit for the RAM size to which the autoscaler can scale down.                                                                                                                                                                                   | `256M`                    |
| `api.vpa.maxAllowed.cpu`                                    | Upper limit for the number of CPUs to which the autoscaler can scale up.                                                                                                                                                                               | `1`                       |
| `api.vpa.maxAllowed.memory`                                 | Upper limit for the RAM size to which the autoscaler can scale up.                                                                                                                                                                                     | `1024M`                   |
| `api.service.annotations`                                   | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)                                                                                                                                       | `{}`                      |
| `api.service.labels`                                        | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                                                                | `{}`                      |
| `api.service.type`                                          | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                                                                                                                         | `ClusterIP`               |
| `api.service.port`                                          | PRO API service port.                                                                                                                                                                                                                                  | `80`                      |
| `api.service.serviceAccount`                                | Kubernetes service account                                                                                                                                                                                                                             | `runner`                  |
| `api.service.serviceAccountOverride`                        | The name of an existing custom service account. If specified, the services in the chart will use this existing service account. If not specified, a new service account will be created and used with the name from the variable `api.serviceAccount`. | `""`                      |
| `api.settings.licenseKey`                                   | License key. **Required**                                                                                                                                                                                                                              | `""`                      |
| `api.settings.tempPath`                                     | Path to directory used for temp data                                                                                                                                                                                                                   | `/tmp`                    |
| `api.settings.allowAnyOrigin`                               | Cors policy: allow any origin to perform requests to pro-api service                                                                                                                                                                                   | `false`                   |
| `api.settings.logging`                                      | Logging settings                                                                                                                                                                                                                                       |                           |
| `api.settings.logging.format`                               | Log message format, possible options: 'default' - compact json, 'renderedCompactJson' - rendered json format, 'simple' - plain text                                                                                                                    | `simple`                  |
| `api.settings.logging.targets`                              | Collection of logging targets divided by comma. Currently only 'console' and 'database' are supported. Console is used by default (no need to specify).                                                                                                | `""`                      |
| `api.settings.rateLimiter`                                  | rate limiter settings                                                                                                                                                                                                                                  |                           |
| `api.settings.rateLimiter.requestsLimit`                    | max number of requests from one user during time window (0 means rate limiter is disabled)                                                                                                                                                             | `1024`                    |
| `api.settings.rateLimiter.windowSizeInSeconds`              | the size of time windows to count and limit incoming requests                                                                                                                                                                                          | `1`                       |
| `api.settings.auth.type`                                    | Authentication type: 'openid10' - [OpenId 1.0 / OAuth 2.0 authentication protocol](https://openid.net/specs/openid-connect-core-1_0.html), 'urbi' - urbi authentication protocol. **Required**                                                         | `openid10`                |
| `api.settings.auth.url`                                     | API URL of authentication service. Example: `http(s)://keycloak.ingress.host`. **Required**                                                                                                                                                            | `""`                      |
| `api.settings.auth.userInfoEndpoint`                        | The [UserInfo endpoint](https://openid.net/specs/openid-connect-core-1_0.html#UserInfo). Example: `realms/URBI_Pro/protocol/openid-connect/userinfo`                                                                                                   | `""`                      |
| `api.settings.auth.wellKnownConfigEndpoint`                 | The [Well-Known Config endpoint](https://openid.net/specs/openid-connect-discovery-1_0.html). Example: `realms/URBI_Pro/.well-known/openid-configuration`                                                                                              | `""`                      |
| `api.settings.auth.apiKey`                                  | Secret API Key to perform authorized service actions, random string. Must be set if type not 'none'. Example: `4230b288-301e-4ec6-82c6-db6a8a72c2af`                                                                                                   | `""`                      |
| `api.settings.auth.turnOffCertValidation`                   | Turn off certificate validation for auth.url                                                                                                                                                                                                           | `false`                   |
| `api.settings.auth.shareKeys`                               | Secret keys for creating and validating shared links. Must contain at least 32 characters. All keys are used for validation. The last one is used for creation. Example: `m7nShlX1a8+IqE9ZcDqRCVjlhEud850ucT0av9bS+tcMTwIwUOUqpNikM+G8teDR`            | `[]`                      |
| `api.settings.backgroundJobs.enableUserAssetsImporter`      | If user data importer job is enabled for the service.                                                                                                                                                                                                  | `true`                    |
| `api.settings.backgroundJobs.enableAssetsStreaming`         | If the streaming data processing job is enabled for the service.                                                                                                                                                                                       | `false`                   |
| `api.settings.layerGeneration.isochroneLayerMaxPointsCount` | Maximum number of points in a layer for generating isochrones.                                                                                                                                                                                         | `500`                     |

### Permissions API configuration & settings

| Name                                             | Description                                                                                                                                                                    | Value                                 |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------- |
| `permissions.image.repository`                   | Repository                                                                                                                                                                     | `2gis-on-premise/pro-permissions-api` |
| `permissions.image.tag`                          | Tag                                                                                                                                                                            | `1.54.0`                              |
| `permissions.image.pullPolicy`                   | Pull Policy                                                                                                                                                                    | `IfNotPresent`                        |
| `permissions.ingress.enabled`                    | If Ingress is enabled for the service                                                                                                                                          | `false`                               |
| `permissions.ingress.className`                  | Name of the Ingress controller class                                                                                                                                           | `nginx`                               |
| `permissions.ingress.hosts[0].host`              | Hostname for the Ingress service                                                                                                                                               | `pro-permissions-api.example.com`     |
| `permissions.ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service                                                                                                                                       | `/`                                   |
| `permissions.ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service                                                                                                                                       | `Prefix`                              |
| `permissions.ingress.tls`                        | TLS configuration                                                                                                                                                              | `[]`                                  |
| `permissions.pod.imagePullSecrets`               | Kubernetes image pull secrets.                                                                                                                                                 | `[]`                                  |
| `permissions.pod.nodeSelector`                   | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                            | `{}`                                  |
| `permissions.pod.affinity`                       | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                                    | `{}`                                  |
| `permissions.pod.priorityClassName`              | Kubernetes [pod priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/).                                                                   | `""`                                  |
| `permissions.pod.terminationGracePeriodSeconds`  | Kubernetes [termination grace period](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/). Should be at least 300 seconds                               | `60`                                  |
| `permissions.pod.tolerations`                    | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                              | `[]`                                  |
| `permissions.pod.podAnnotations`                 | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                  | `{}`                                  |
| `permissions.pod.podLabels`                      | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                            | `{}`                                  |
| `permissions.pod.annotations`                    | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                      | `{}`                                  |
| `permissions.pod.labels`                         | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                | `{}`                                  |
| `permissions.pod.revisionHistoryLimit`           | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                                 | `3`                                   |
| `permissions.pod.resources`                      | **Limits for the application service**                                                                                                                                         |                                       |
| `permissions.pod.resources.requests.cpu`         | A CPU request.                                                                                                                                                                 | `300m`                                |
| `permissions.pod.resources.requests.memory`      | A memory request.                                                                                                                                                              | `256M`                                |
| `permissions.pod.resources.limits.cpu`           | A CPU limit.                                                                                                                                                                   | `1`                                   |
| `permissions.pod.resources.limits.memory`        | A memory limit.                                                                                                                                                                | `1G`                                  |
| `permissions.service.annotations`                | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)                                                               | `{}`                                  |
| `permissions.service.labels`                     | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                        | `{}`                                  |
| `permissions.service.type`                       | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                                                 | `ClusterIP`                           |
| `permissions.service.port`                       | PRO API service port.                                                                                                                                                          | `80`                                  |
| `permissions.settings.auth.apiKey`               | Secret Permissions API Key to perform authorized service actions, random string. Must be set if type not 'none'. Example: `c7d74870-ec28-4543-b408-b49bfed84399`. **Required** | `""`                                  |

### Tasks API configuration & settings


### asset importer settings

| Name                                               | Description                                                                                                                                              | Value                          |
| -------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `assetImporter.appName`                            | Data Import job name.                                                                                                                                    | `asset-importer`               |
| `assetImporter.repository`                         | Docker Repository Image.                                                                                                                                 | `2gis-on-premise/pro-importer` |
| `assetImporter.tag`                                | Docker image tag.                                                                                                                                        | `1.54.0`                       |
| `assetImporter.schedule`                           | Import job schedule.                                                                                                                                     | `0 18 * * *`                   |
| `assetImporter.backoffLimit`                       | The number of [retries](https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy) before considering a Job as failed.   | `2`                            |
| `assetImporter.successfulJobsHistoryLimit`         | How many completed and failed jobs should be kept. See [docs](https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/#jobs-history-limits). | `3`                            |
| `assetImporter.nodeSelector`                       | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                      | `{}`                           |
| `assetImporter.resources`                          | **Limits for the import job**                                                                                                                            |                                |
| `assetImporter.resources.requests.cpu`             | A CPU request.                                                                                                                                           | `700m`                         |
| `assetImporter.resources.requests.memory`          | A memory request.                                                                                                                                        | `768M`                         |
| `assetImporter.resources.limits.cpu`               | A CPU limit.                                                                                                                                             | `1000m`                        |
| `assetImporter.resources.limits.memory`            | A memory limit.                                                                                                                                          | `8Gi`                          |
| `assetImporter.enabled`                            | If assetImporter is enabled for the service.                                                                                                             | `true`                         |
| `assetImporter.startOnDeploy`                      | Indicates that asset import should start when service installed or updated                                                                               | `true`                         |
| `assetImporter.startOnDeployMode`                  | Import mode: 'ScheduleManifest' - copy data from manifest and schedule import, 'ManifestData' - just copy data from manifest.                            | `ScheduleManifest`             |
| `Asset`                                            | importer settings                                                                                                                                        |                                |
| `assetImporter.settings.maxParallelJobs`           | How many import jobs can be run simultaneously                                                                                                           | `1`                            |
| `assetImporter.settings.imageProxyUrl`             | URL to proxy image links (including query parameters, if any, i.e. 'https://someserver.com/proxy?url=' )                                                 | `""`                           |
| `assetImporter.settings.externalLinksProxyUrl`     | URL to proxy http links from assets data (including query parameters, if any, i.e. 'https://someserver.com/proxy?url=' )                                 | `""`                           |
| `assetImporter.settings.externalLinksAllowedHosts` | Comma separated hosts, i.e. 'someserver.com,someserver2.com' )                                                                                           | `""`                           |
| `assetImporter.settings.failedImportJobsLimit`     | How many import jobs can fail before scheduler stops creating new imports                                                                                | `0`                            |

### asset preparer settings


### common infrastructure settings


### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Deployment Artifacts Storage settings

| Name                                 | Description                                                                                                                                                                                                                                                           | Value   |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `dgctlStorage.host`                  | S3 endpoint. Format: `host:port`. **Required**                                                                                                                                                                                                                        | `""`    |
| `dgctlStorage.secure`                | Set to `true` if dgctlStorage.host must be accessed via https. **Required**                                                                                                                                                                                           | `false` |
| `dgctlStorage.bucket`                | S3 bucket name. **Required**                                                                                                                                                                                                                                          | `""`    |
| `dgctlStorage.accessKey`             | S3 access key for accessing the bucket. **Required**                                                                                                                                                                                                                  | `""`    |
| `dgctlStorage.secretKey`             | S3 secret key for accessing the bucket. **Required**                                                                                                                                                                                                                  | `""`    |
| `dgctlStorage.manifest`              | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json`.<br> This file contains the description of pieces of data that the service requires to operate. **Required** | `""`    |
| `dgctlStorage.region`                | AuthenticationRegion property for S3 client. Used in AWS4 request signing, this is an optional property                                                                                                                                                               | `""`    |
| `dgctlStorage.disablePayloadSigning` | Turns off payload signing, this is an optional property. Should be TRUE for Oracle S3 storage                                                                                                                                                                         | `false` |

### 2GIS PRO Storage configuration

| Name                      | Description                                                                 | Value |
| ------------------------- | --------------------------------------------------------------------------- | ----- |
| `s3.assetsDataBucket`     | S3 bucket with base urbi assets, aggregations, and filters. **Required**    | `""`  |
| `s3.userAssetsDataBucket` | S3 bucket with user-created assets, aggregations, and filters. **Required** | `""`  |
| `s3.layerDataBucket`      | S3 bucket with prepared layer data. **Required**                            | `""`  |
| `s3.snapshotBucket`       | S3 bucket for storing snapshots of inclemental data updates. **Required**   | `""`  |
| `s3.resourcesBucket`      | S3 bucket for storing static resources. **Required**                        | `""`  |

### PostgreSQL settings

| Name                             | Description                                                                                                            | Value  |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------ |
| `postgres.api.`                  | Settings for Geo API database connection                                                                               |        |
| `postgres.api.rw.`               | Settings for the read-write access. Same settings for read-only access can be added, if necessary (postgres.api.ro).   |        |
| `postgres.api.rw.host`           | PostgreSQL hostname or IP. **Required**                                                                                | `""`   |
| `postgres.api.rw.port`           | PostgreSQL port. **Required**                                                                                          | `5432` |
| `postgres.api.rw.timeout`        | PostgreSQL client connection timeout in seconds.                                                                       | `15`   |
| `postgres.api.rw.poolSize.`      | Settings for the pool size                                                                                             |        |
| `postgres.api.rw.poolSize.min`   | PostgreSQL minimum connection pool size. 0 means no minimal bound.                                                     | `1`    |
| `postgres.api.rw.poolSize.max`   | PostgreSQL maximum connection pool size                                                                                | `10`   |
| `postgres.api.rw.name`           | PostgreSQL database name. **Required**                                                                                 | `""`   |
| `postgres.api.rw.username`       | PostgreSQL username. **Required**                                                                                      | `""`   |
| `postgres.api.rw.password`       | PostgreSQL password. **Required**                                                                                      | `""`   |
| `postgres.api.ro`                | Settings for the read-only access.                                                                                     | `nil`  |
| `postgres.tasks.`                | Settings for Tasks API database connection                                                                             |        |
| `postgres.tasks.rw.`             | Settings for the read-write access. Same settings for read-only access can be added, if necessary (postgres.tasks.ro). |        |
| `postgres.tasks.rw.host`         | PostgreSQL hostname or IP. **Required**                                                                                | `""`   |
| `postgres.tasks.rw.port`         | PostgreSQL port. **Required**                                                                                          | `5432` |
| `postgres.tasks.rw.timeout`      | PostgreSQL client connection timeout in seconds.                                                                       | `15`   |
| `postgres.tasks.rw.poolSize.`    | Settings for the pool size.                                                                                            |        |
| `postgres.tasks.rw.poolSize.min` | PostgreSQL minimum connection pool size. 0 means no minimal bound.                                                     | `1`    |
| `postgres.tasks.rw.poolSize.max` | PostgreSQL maximum connection pool size.                                                                               | `5`    |
| `postgres.tasks.rw.name`         | PostgreSQL database name. **Required**                                                                                 | `""`   |
| `postgres.tasks.rw.username`     | PostgreSQL username. **Required**                                                                                      | `""`   |
| `postgres.tasks.rw.password`     | PostgreSQL password. **Required**                                                                                      | `""`   |
| `postgres.tasks.ro`              | Settings for the read-only access.                                                                                     | `nil`  |

### Kafka settings (supported version 2.7)

| Name                                   | Description                                                                                                                       | Value           |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `kafka.bootstrapServers`               | Kafka bootstrap servers. Format: 'host1:port1,host2:port2'                                                                        | `""`            |
| `kafka.securityProtocol`               | Kafka security protocol. Supported options: SaslPlaintext.                                                                        | `SaslPlaintext` |
| `kafka.sasl`                           | **Kafka sasl settings** (see [the documentation](https://kafka.apache.org/documentation/#security_sasl_config))                   |                 |
| `kafka.sasl.mechanism`                 | Kafka sasl mechanism. Supported options: ScramSha512.                                                                             | `ScramSha512`   |
| `kafka.sasl.username`                  | Kafka sasl username.                                                                                                              | `""`            |
| `kafka.sasl.password`                  | Kafka sasl password.                                                                                                              | `""`            |
| `kafka.assetTopicsReaderGroupId`       | Kafka consumer group for reading streaming assets data.                                                                           | `""`            |
| `kafka.importTasksTopic`               | Kafka topic settings to run import tasks.                                                                                         |                 |
| `kafka.importTasksTopic.name`          | Kafka topic name.                                                                                                                 | `""`            |
| `kafka.importTasksTopic.readerGroupId` | Kafka consumer group for reading importing tasks.                                                                                 | `""`            |
| `kafka.eventsTopic`                    | Kafka topic settings to manage events.                                                                                            |                 |
| `kafka.eventsTopic.name`               | Kafka events topic name. **Required**                                                                                             | `""`            |
| `kafka.eventsTopic.readerGroupId`      | Kafka consumer group for reading events. **Required**                                                                             | `""`            |
| `kafka.assetDataTopic`                 | Kafka topic settings to manage asset data updates.                                                                                |                 |
| `kafka.assetDataTopic.name`            | Kafka topic name.                                                                                                                 | `""`            |
| `kafka.refreshAssetsIntervalMinutes`   | Refresh interval for reading streaming assets settings in minutes.                                                                | `60`            |
| `kafka.useReplicaTopics`               | Use topic replica when using multiple kafka clusters. Each topic in the kafka settings must have a corresponding ".replica" topic | `false`         |

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

### external services


### digger settings


### Keys Service settings

| Name         | Description                                                                              | Value |
| ------------ | ---------------------------------------------------------------------------------------- | ----- |
| `keys.url`   | API URL of service for managing partners' keys to 2GIS services (keys.api). **Required** | `""`  |
| `keys.token` | keys.api access token. **Required**                                                      | `""`  |

### Catalog API settings

| Name          | Description                                                                                        | Value |
| ------------- | -------------------------------------------------------------------------------------------------- | ----- |
| `catalog.url` | URL for [Catalog API](https://docs.2gis.com/en/on-premise/search). Example: http://catalog-api.svc | `""`  |
| `catalog.key` | Access key to [Catalog API](https://docs.2gis.com/en/on-premise/search).                           | `""`  |

### Navigation API settings

| Name       | Description                                                                                                      | Value |
| ---------- | ---------------------------------------------------------------------------------------------------------------- | ----- |
| `navi.url` | URL for [Navigation API](https://docs.2gis.com/en/on-premise/navigation/overview). Example: http://navi-back.svc | `""`  |
| `navi.key` | Access key to [Navigation API](https://docs.2gis.com/en/on-premise/navigation/overview).                         | `""`  |

### License Service API settings

| Name          | Description                                                        | Value |
| ------------- | ------------------------------------------------------------------ | ----- |
| `license.url` | Licensing server v2 URL. Example: https://license.svc **Required** | `""`  |

### Search API settings

| Name         | Description                                                                                      | Value |
| ------------ | ------------------------------------------------------------------------------------------------ | ----- |
| `search.url` | URL for [Search API](https://docs.2gis.com/en/on-premise/search). Example: http://search-api.svc | `""`  |


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
