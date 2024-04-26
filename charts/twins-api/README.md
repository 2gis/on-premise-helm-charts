# 2GIS API Twins service

Use this Helm chart to deploy API Twins service, which is a part of 2GIS's [On-Premise solution](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name               | Description                                                                                   | Value                       |
| ------------------ | --------------------------------------------------------------------------------------------- | --------------------------- |
| `imagePullSecrets` | Kubernetes image pull secrets.                                                                | `[]`                        |
| `image.repository` | Twins API service image repository.                                                           | `2gis-on-premise/twins-api` |
| `image.tag`        | Twins API service image tag.                                                                  | `1.7.3`                     |
| `image.pullPolicy` | Image [pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) | `IfNotPresent`              |

### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                                           | Value |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `dgctlStorage.host`      | S3 host. Format: `host:port`. **Required**                                                                                                                                                                                                                            | `""`  |
| `dgctlStorage.bucket`    | S3 bucket name. **Required**                                                                                                                                                                                                                                          | `""`  |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket. **Required**                                                                                                                                                                                                                  | `""`  |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket. **Required**                                                                                                                                                                                                                  | `""`  |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json` <br> This file contains the description of pieces of data that the service requires to operate. **Required** | `""`  |

### API service settings

| Name                                        | Description                                                                                                                                                                                              | Value           |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `api.logLevel`                              | Log level (debug|info|warning|error)                                                                                                                                                                     | `info`          |
| `api.strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `api.strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `api.strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |
| `api.keys.url`                              | URL of the Keys service, ex: http://{keys-api}.svc. This URL should be accessible from all the pods within your Kubernetes cluster. **Required**                                                         | `""`            |
| `api.keys.token`                            | Keys service API key **Required**                                                                                                                                                                        | `""`            |
| `api.keys.requestTimeout`                   | Timeout for requests to the Keys API.                                                                                                                                                                    | `5s`            |
| `api.replicas`                              | A replica count for the pod.                                                                                                                                                                             | `1`             |

### api.resources **Kubernetes [resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) settings**

| Name                                          | Description                                                                                                                                                          | Value                   |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `api.resources.requests.cpu`                  | A CPU request.                                                                                                                                                       | `50m`                   |
| `api.resources.requests.memory`               | A memory request.                                                                                                                                                    | `128Mi`                 |
| `api.resources.limits.cpu`                    | A CPU limit.                                                                                                                                                         | `1`                     |
| `api.resources.limits.memory`                 | A memory limit.                                                                                                                                                      | `256Mi`                 |
| `api.annotations`                             | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                            | `{}`                    |
| `api.labels`                                  | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                      | `{}`                    |
| `api.podAnnotations`                          | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                        | `{}`                    |
| `api.podLabels`                               | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                  | `{}`                    |
| `api.nodeSelector`                            | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                  | `{}`                    |
| `api.affinity`                                | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                          | `{}`                    |
| `api.tolerations`                             | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                    | `{}`                    |
| `api.service.annotations`                     | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                    | `{}`                    |
| `api.service.labels`                          | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                              | `{}`                    |
| `api.service.type`                            | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                                       | `ClusterIP`             |
| `api.service.port`                            | Service port.                                                                                                                                                        | `80`                    |
| `api.ingress.enabled`                         | If Ingress is enabled for the service.                                                                                                                               | `false`                 |
| `api.ingress.className`                       | Name of the Ingress controller class.                                                                                                                                | `nginx`                 |
| `api.ingress.hosts[0].host`                   | Hostname for the Ingress service.                                                                                                                                    | `twins-api.example.com` |
| `api.ingress.hosts[0].paths[0].path`          | Path of the host for the Ingress service.                                                                                                                            | `/`                     |
| `api.ingress.hosts[0].paths[0].pathType`      | Type of the path for the Ingress service.                                                                                                                            | `Prefix`                |
| `api.ingress.tls`                             | TLS configuration                                                                                                                                                    | `[]`                    |
| `api.hpa.enabled`                             | If HPA is enabled for the service.                                                                                                                                   | `false`                 |
| `api.hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`                     |
| `api.hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `2`                     |
| `api.hpa.scaleDownStabilizationWindowSeconds` | Scale-down window.                                                                                                                                                   | `""`                    |
| `api.hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window.                                                                                                                                                     | `""`                    |
| `api.hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`                    |
| `api.hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`                    |

### Migrate service settings

| Name                          | Description                              | Value |
| ----------------------------- | ---------------------------------------- | ----- |
| `migrate.initialDelaySeconds` | Delay in seconds at the service startup. | `0`   |

### migrate.resources **Kubernetes [resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) settings**

| Name                                | Description                                                                                                         | Value  |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------ |
| `migrate.resources.requests.cpu`    | A CPU request.                                                                                                      | `10m`  |
| `migrate.resources.requests.memory` | A memory request.                                                                                                   | `32Mi` |
| `migrate.resources.limits.cpu`      | A CPU limit.                                                                                                        | `100m` |
| `migrate.resources.limits.memory`   | A memory limit.                                                                                                     | `64Mi` |
| `migrate.nodeSelector`              | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector). | `{}`   |

### Database access settings

| Name                   | Description                                                                         | Value  |
| ---------------------- | ----------------------------------------------------------------------------------- | ------ |
| `postgres.ro`          | **Settings for the read-only access**                                               |        |
| `postgres.ro.host`     | PostgreSQL hostname or IP. **Required**                                             | `""`   |
| `postgres.ro.port`     | PostgreSQL port.                                                                    | `5432` |
| `postgres.ro.timeout`  | PostgreSQL client connection timeout.                                               | `3s`   |
| `postgres.ro.retry`    | PostgreSQL client connection retry.                                                 | `10`   |
| `postgres.ro.name`     | PostgreSQL database name. **Required**                                              | `""`   |
| `postgres.ro.schema`   | PostgreSQL database schema. If not specified, schema from SEARCH_PATH will be used. | `""`   |
| `postgres.ro.username` | PostgreSQL username. **Required**                                                   | `""`   |
| `postgres.ro.password` | PostgreSQL password. **Required**                                                   | `""`   |
| `postgres.rw`          | **Settings for the read-write access**                                              |        |
| `postgres.rw.host`     | PostgreSQL hostname or IP. **Required**                                             | `""`   |
| `postgres.rw.port`     | PostgreSQL port.                                                                    | `5432` |
| `postgres.rw.timeout`  | PostgreSQL client connection timeout.                                               | `3s`   |
| `postgres.rw.retry`    | PostgreSQL client connection retry.                                                 | `10`   |
| `postgres.rw.name`     | PostgreSQL database name. **Required**                                              | `""`   |
| `postgres.rw.schema`   | PostgreSQL database schema. If not specified, schema from SEARCH_PATH will be used. | `""`   |
| `postgres.rw.username` | PostgreSQL username. **Required**                                                   | `""`   |
| `postgres.rw.password` | PostgreSQL password. **Required**                                                   | `""`   |

### Kubernetes Importer job settings

| Name                                  | Description                                                                                                        | Value  |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ------ |
| `importer`                            | **Common settings**                                                                                                |        |
| `importer.enabled`                    | If importer is enabled for the service                                                                             | `true` |
| `importer.nodeSelector`               | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}`   |
| `importer.initialDelaySeconds`        | Number of seconds after the container has started before liveness or readiness probes are initiated                | `1`    |
| `importer.retry.download.maxAttempts` | The maximum number of retries download before stopping                                                             | `3`    |
| `importer.retry.download.delay`       | Delay until the retry attempts download                                                                            | `1s`   |
| `importer.retry.execute.maxAttempts`  | The maximum number of retries execute psql command before stopping                                                 | `3`    |
| `importer.retry.execute.delay`        | Delay until the retry attempts execute                                                                             | `1s`   |

### importer.postgres **Database settings**

| Name                                    | Description                                    | Value  |
| --------------------------------------- | ---------------------------------------------- | ------ |
| `importer.postgres.schemaSwitchEnabled` | Automatic switch PostgreSQL schema on releases | `true` |

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


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
