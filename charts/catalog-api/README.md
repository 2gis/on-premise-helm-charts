# 2GIS Catalog API service

Use this Helm chart to deploy Catalog API service, which is a part of 2GIS's [On-Premise Search services](https://docs.2gis.com/en/on-premise/search).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/search) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-catalog.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                        | Value |
| --------------------- | ---------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry host where On-Premise services' images reside. Format: `host:port` | `""`  |

### Common settings

| Name               | Description                                                                                                                                         | Value |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `nodeSelector`     | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)                                  | `{}`  |
| `affinity`         | Kubernetes [pod affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity)                                   | `{}`  |
| `tolerations`      | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings                                    | `[]`  |
| `annotations`      | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                           | `{}`  |
| `podAnnotations`   | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)                                        | `{}`  |
| `podLabels`        | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)                                                  | `{}`  |
| `imagePullSecrets` | Kubernetes [secrets for pulling the image from the registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) | `[]`  |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                         | Value   |
| -------------------- | --------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction | `1`     |

### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                                           | Value   |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `dgctlStorage.host`      | S3 host. Format: `host:port`. **Required**                                                                                                                                                                                                                            | `""`    |
| `dgctlStorage.region`    | S3 region name.                                                                                                                                                                                                                                                       | `""`    |
| `dgctlStorage.secure`    | Set to `true` if dgctlStorage.host must be accessed via https. **Required**                                                                                                                                                                                           | `false` |
| `dgctlStorage.verifySsl` | Set to `false` if dgctlStorage.host must be accessed via https without certificate validation. **Required**                                                                                                                                                           | `true`  |
| `dgctlStorage.bucket`    | S3 bucket name. **Required**                                                                                                                                                                                                                                          | `""`    |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket. **Required**                                                                                                                                                                                                                  | `""`    |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket. **Required**                                                                                                                                                                                                                  | `""`    |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json` <br> This file contains the description of pieces of data that the service requires to operate. **Required** | `""`    |

### Strategy settings

| Name                                    | Description                                                                                                                                                                                              | Value           |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |

### API settings

| Name                       | Description                                                                                                                                    | Value  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `api.replicas`             | Number of replicas of API pods                                                                                                                 | `1`    |
| `api.logLevel`             | Log level                                                                                                                                      | `info` |
| `api.revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`    |

### api.image **Deployment settings**

| Name                   | Description                                                                                   | Value                         |
| ---------------------- | --------------------------------------------------------------------------------------------- | ----------------------------- |
| `api.image.repository` | Repository                                                                                    | `2gis-on-premise/catalog-api` |
| `api.image.tag`        | Tag                                                                                           | `3.619.0`                     |
| `api.image.pullPolicy` | Image [pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) | `IfNotPresent`                |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                          | Description                                                                                                                                                         | Value   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `api.hpa.enabled`                             | If HPA is enabled for the service                                                                                                                                   | `false` |
| `api.hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down                                                                                       | `1`     |
| `api.hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up                                                                                         | `2`     |
| `api.hpa.scaleDownStabilizationWindowSeconds` | Scale-down window                                                                                                                                                   | `""`    |
| `api.hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window                                                                                                                                                     | `""`    |
| `api.hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used       | `80`    |
| `api.hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used | `""`    |

### api.resources Kubernetes [resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) settings

| Name                            | Description      | Value    |
| ------------------------------- | ---------------- | -------- |
| `api.resources.requests.cpu`    | A CPU request    | `2`      |
| `api.resources.requests.memory` | A memory request | `6000Mi` |
| `api.resources.limits.cpu`      | A CPU limit      | `4`      |
| `api.resources.limits.memory`   | A memory limit   | `6500Mi` |

### Service settings

| Name                      | Description                                                                                                                   | Value       |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `api.service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)              | `{}`        |
| `api.service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)                        | `{}`        |
| `api.service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) | `ClusterIP` |
| `api.service.port`        | Service port                                                                                                                  | `80`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                     | Description                               | Value                     |
| ---------------------------------------- | ----------------------------------------- | ------------------------- |
| `api.ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                   |
| `api.ingress.className`                  | Name of the Ingress controller class.     | `nginx`                   |
| `api.ingress.hosts[0].host`              | Hostname for the Ingress service.         | `catalog-api.example.com` |
| `api.ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                       |
| `api.ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                  |
| `api.ingress.tls`                        | TLS configuration                         | `[]`                      |

### Database settings

| Name                                                   | Description                                                         | Value         |
| ------------------------------------------------------ | ------------------------------------------------------------------- | ------------- |
| `api.postgres.host`                                    | PostgreSQL rw/ro hostname or IP. **Required**                       | `""`          |
| `api.postgres.port`                                    | PostgreSQL port                                                     | `5432`        |
| `api.postgres.name`                                    | PostgreSQL database name. **Required**                              | `""`          |
| `api.postgres.username`                                | PostgreSQL username. **Required**                                   | `""`          |
| `api.postgres.password`                                | PostgreSQL password. **Required** if tls.enabled: false             | `""`          |
| `api.postgres.queryTimeout`                            | Max execution time PostgreSQL query timeout in seconds              | `3`           |
| `api.postgres.poolSize.api`                            | PostgreSQL connection pool size for API                             | `32`          |
| `api.postgres.poolSize.preloaders.region`              | PostgreSQL connection pool size for preloader regions               | `2`           |
| `api.postgres.poolSize.preloaders.rubric`              | PostgreSQL connection pool size for preloader rubrics               | `3`           |
| `api.postgres.poolSize.preloaders.additionalAttribute` | PostgreSQL connection pool size for preloader additional attributes | `3`           |
| `api.postgres.tls.enabled`                             | If tls connection to postgresql is enabled.                         | `false`       |
| `api.postgres.tls.rootCert`                            | Root certificate file.                                              | `""`          |
| `api.postgres.tls.cert`                                | Certificate of postgresql server.                                   | `""`          |
| `api.postgres.tls.key`                                 | Key of postgresql server.                                           | `""`          |
| `api.postgres.tls.mode`                                | Level of protection.                                                | `verify-full` |

### Preloaders settings

| Name                          | Description              | Value |
| ----------------------------- | ------------------------ | ----- |
| `api.preloaders.awaitTimeout` | Preloaders await timeout | `60s` |

### Search settings

| Name                     | Description                                                                                                                                          | Value   |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `search.url`             | URL of the Search service, ex: http://{search-api}.svc. This URL should be accessible from all the pods within your Kubernetes cluster. **Required** | `""`    |
| `search.connectTimeout`  | Timeout for connect to the Search service                                                                                                            | `300ms` |
| `search.minConnections`  | The minimum number connections to the Search service                                                                                                 | `10`    |
| `search.maxConnections`  | The maximum number connections to the Search service                                                                                                 | `100`   |
| `search.maxOpenRequests` | The maximum number open requests to the Search service                                                                                               | `128`   |

### Keys settings

| Name                                | Description                                                                                                                                      | Value |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ----- |
| `keys.url`                          | URL of the Keys service, ex: http://{keys-api}.svc. This URL should be accessible from all the pods within your Kubernetes cluster. **Required** | `""`  |
| `keys.token`                        | Keys service API key                                                                                                                             | `""`  |
| `keys.client.connectingTimeout`     | The time period within which the TCP connecting process must be completed                                                                        | `1s`  |
| `keys.client.idleTimeout`           | The time after which an idle connection will be automatically closed                                                                             | `1s`  |
| `keys.client.maxRetries`            | The maximum number of times failed requests are attempted again, (if the request can be safely retried) before giving up and returning an error  | `0`   |
| `keys.client.maxConnectionLifetime` | The maximum duration for a connection to be kept alive                                                                                           | `20s` |
| `keys.client.baseConnectionBackoff` | The minimum duration to backoff new connection attempts after the previous connection attempt failed                                             | `1s`  |
| `keys.client.maxConnectionBackoff`  | Maximum backoff duration between failed connection attempts                                                                                      | `20s` |
| `keys.client.responseTimeout`       | The time period after the response was dispatched                                                                                                | `5s`  |

### License settings

| Name                     | Description                                                            | Value |
| ------------------------ | ---------------------------------------------------------------------- | ----- |
| `license.url`            | Address of the License service v1. Ex: http://license.svc **Required** | `""`  |
| `license.requestTimeout` | Timeout for requests to the License service                            | `1s`  |

### Statistic settings

| Name                                | Description                                                                                                                                     | Value   |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `stat.request.enabled`              | If statistic by request is enabled                                                                                                              | `false` |
| `stat.request.buffer.lifetime`      | Lifetime of request Statistic buffer                                                                                                            | `5s`    |
| `stat.request.buffer.sendTimeout`   | Timeout between sending request statistic messages                                                                                              | `2s`    |
| `stat.request.buffer.sendLimit`     | The maximum number of request messages in the buffer before they are sent to the Statistic                                                      | `256`   |
| `stat.search.enabled`               | If statistic by search is enabled                                                                                                               | `false` |
| `stat.search.buffer.lifetime`       | Lifetime of search Statistic buffer                                                                                                             | `5s`    |
| `stat.search.buffer.sendTimeout`    | Timeout between sending search statistic messages                                                                                               | `2s`    |
| `stat.search.buffer.sendLimit`      | The maximum number of search messages in the buffer before they are sent to the Statistic                                                       | `256`   |
| `stat.client.url`                   | URL of the statistic service. Ex: http(s)://stat.svc                                                                                            | `""`    |
| `stat.client.connectingTimeout`     | The time period within which the TCP connecting process must be completed                                                                       | `500ms` |
| `stat.client.idleTimeout`           | The time after which an idle connection will be automatically closed                                                                            | `250ms` |
| `stat.client.minConnections`        | The minimum number of parallel connections that a pool should keep alive ("hot")                                                                | `1`     |
| `stat.client.maxConnections`        | The maximum number of parallel connections that a connection pool to a single host endpoint is allowed to establish. Must be greater than zero  | `2`     |
| `stat.client.maxOpenRequests`       | The maximum number of open requests accepted into the pool across all  materializations of any of its client flows                              | `4`     |
| `stat.client.maxRetries`            | The maximum number of times failed requests are attempted again, (if the request can be safely retried) before giving up and returning an error | `4`     |
| `stat.client.maxConnectionLifetime` | The maximum duration for a connection to be kept alive                                                                                          | `5m`    |
| `stat.client.baseConnectionBackoff` | The minimum duration to backoff new connection attempts after the previous connection attempt failed                                            | `500ms` |
| `stat.client.maxConnectionBackoff`  | Maximum backoff duration between failed connection attempts                                                                                     | `10s`   |
| `stat.client.responseTimeout`       | The time period after the response was dispatched                                                                                               | `250ms` |
| `stat.dispatcher.fixedPoolSize`     | Fixed number of threads used                                                                                                                    | `1`     |
| `stat.dispatcher.throughput`        | Throughput defines the maximum number of messages to be processed per actor before the thread jumps to the next actor                           | `4`     |

### Kubernetes Importer job settings

| Name                                  | Description                                                                                                        | Value |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ----- |
| `importer`                            | **Common settings**                                                                                                |       |
| `importer.nodeSelector`               | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}`  |
| `importer.workerNum`                  | Number of parallel import processes (workers)                                                                      | `3`   |
| `importer.initialDelaySeconds`        | Number of seconds after the container has started before liveness or readiness probes are initiated                | `1`   |
| `importer.retry.download.maxAttempts` | The maximum number of retries download before stopping                                                             | `3`   |
| `importer.retry.download.delay`       | Delay until the retry attempts download                                                                            | `1s`  |
| `importer.retry.execute.maxAttempts`  | The maximum number of retries execute psql command before stopping                                                 | `3`   |
| `importer.retry.execute.delay`        | Delay until the retry attempts execute                                                                             | `1s`  |

### importer.image **Deployment settings**

| Name                        | Description                                                                                   | Value                              |
| --------------------------- | --------------------------------------------------------------------------------------------- | ---------------------------------- |
| `importer.image.repository` | Repository                                                                                    | `2gis-on-premise/catalog-importer` |
| `importer.image.tag`        | Tag                                                                                           | `1.7.0`                            |
| `importer.image.pullPolicy` | Image [Pull Policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) | `IfNotPresent`                     |

### importer.postgres **Database settings**

| Name                                    | Description                                             | Value         |
| --------------------------------------- | ------------------------------------------------------- | ------------- |
| `importer.postgres.host`                | PostgreSQL rw hostname or IP. **Required**              | `""`          |
| `importer.postgres.port`                | PostgreSQL port                                         | `5432`        |
| `importer.postgres.name`                | PostgreSQL database name. **Required**                  | `""`          |
| `importer.postgres.username`            | PostgreSQL username with rw access. **Required**        | `""`          |
| `importer.postgres.password`            | PostgreSQL password. **Required** if tls.enabled: false | `""`          |
| `importer.postgres.schemaSwitchEnabled` | Automatic switch PostgreSQL schema on releases          | `true`        |
| `importer.postgres.schemaExtensions`    | Schema for PostgreSQL extensions                        | `extensions`  |
| `importer.postgres.tls.enabled`         | If tls connection to postgresql is enabled.             | `false`       |
| `importer.postgres.tls.rootCert`        | Root certificate file.                                  | `""`          |
| `importer.postgres.tls.cert`            | Certificate of postgresql server.                       | `""`          |
| `importer.postgres.tls.key`             | Key of postgresql server.                               | `""`          |
| `importer.postgres.tls.mode`            | Level of protection.                                    | `verify-full` |

### importer.persistentVolume **Persistent Volume settings**

| Name                                     | Description                                                                                                         | Value               |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `importer.persistentVolume.enabled`      | If [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) is enabled for the service | `false`             |
| `importer.persistentVolume.accessModes`  | Persistent Volume [Access Mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)       | `["ReadWriteOnce"]` |
| `importer.persistentVolume.storageClass` | Kubernetes [Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)                          | `topolvm-ext4`      |
| `importer.persistentVolume.size`         | Volume size                                                                                                         | `50Gi`              |

### importer.resources **Kubernetes [resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) settings**

| Name                                 | Description      | Value    |
| ------------------------------------ | ---------------- | -------- |
| `importer.resources.requests.cpu`    | A CPU request    | `256m`   |
| `importer.resources.requests.memory` | A memory request | `512Mi`  |
| `importer.resources.limits.cpu`      | A CPU limit      | `2`      |
| `importer.resources.limits.memory`   | A memory limit   | `2048Mi` |

### importer.cleaner **Cleaner scheme settings**

| Name                            | Description                                 | Value  |
| ------------------------------- | ------------------------------------------- | ------ |
| `importer.cleaner.enabled`      | If clean schemes is enabled for the service | `true` |
| `importer.cleaner.versionLimit` | Number of backup schemes                    | `2`    |

### importer.cleaner.resources **Kubernetes [resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) settings**

| Name                                         | Description      | Value   |
| -------------------------------------------- | ---------------- | ------- |
| `importer.cleaner.resources.requests.cpu`    | A CPU request    | `50m`   |
| `importer.cleaner.resources.requests.memory` | A memory request | `128Mi` |
| `importer.cleaner.resources.limits.cpu`      | A CPU limit      | `1000m` |
| `importer.cleaner.resources.limits.memory`   | A memory limit   | `512Mi` |

### customCAs **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container.                                                                          | `""`  |


## Maintainers

| Name | Email                 | Url                       |
| ---- | --------------------- | ------------------------- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
