# 2GIS API Styles service

Use this Helm chart to deploy API Styles service, which is a part of 2GIS's [On-Premise solution](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name               | Description                                                                                   | Value                        |
| ------------------ | --------------------------------------------------------------------------------------------- | ---------------------------- |
| `imagePullSecrets` | Kubernetes image pull secrets.                                                                | `[]`                         |
| `imagePullPolicy`  | Image [pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) | `IfNotPresent`               |
| `image.repository` | Styles API service image repository.                                                          | `2gis-on-premise/styles-api` |
| `image.tag`        | Styles API service image tag.                                                                 | `1.13.0`                     |

### API service settings

| Name                                        | Description                                                                                                                                                                                              | Value           |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `api.strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `api.strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `api.strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |
| `api.replicas`                              | A replica count for the pod.                                                                                                                                                                             | `1`             |
| `api.revisionHistoryLimit`                  | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                                                           | `3`             |

### api.resources **Kubernetes [resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) settings**

| Name                                          | Description                                                                                                                                                          | Value                |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- |
| `api.resources.requests.cpu`                  | A CPU request.                                                                                                                                                       | `50m`                |
| `api.resources.requests.memory`               | A memory request.                                                                                                                                                    | `128Mi`              |
| `api.resources.limits.cpu`                    | A CPU limit.                                                                                                                                                         | `1`                  |
| `api.resources.limits.memory`                 | A memory limit.                                                                                                                                                      | `256Mi`              |
| `api.annotations`                             | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                            | `{}`                 |
| `api.labels`                                  | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                      | `{}`                 |
| `api.podAnnotations`                          | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                        | `{}`                 |
| `api.podLabels`                               | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                  | `{}`                 |
| `api.nodeSelector`                            | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                  | `{}`                 |
| `api.affinity`                                | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                          | `{}`                 |
| `api.tolerations`                             | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                    | `{}`                 |
| `api.service.annotations`                     | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                    | `{}`                 |
| `api.service.labels`                          | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                              | `{}`                 |
| `api.service.type`                            | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                                       | `ClusterIP`          |
| `api.service.port`                            | Service port.                                                                                                                                                        | `80`                 |
| `api.ingress.enabled`                         | If Ingress is enabled for the service.                                                                                                                               | `false`              |
| `api.ingress.className`                       | Name of the Ingress controller class.                                                                                                                                | `nginx`              |
| `api.ingress.annotations`                     | Kubernetes [Ingress annotations](https://kubernetes.io/docs/concepts/services-networking/ingress/#the-ingress-resource).                                             | `{}`                 |
| `api.ingress.hosts[0].host`                   | Hostname for the Ingress service.                                                                                                                                    | `styles.example.com` |
| `api.ingress.hosts[0].paths[0].path`          | Path of the host for the Ingress service.                                                                                                                            | `/`                  |
| `api.ingress.hosts[0].paths[0].pathType`      | Type of the path for the Ingress service.                                                                                                                            | `Prefix`             |
| `api.ingress.tls`                             | TLS configuration                                                                                                                                                    | `[]`                 |
| `api.hpa.enabled`                             | If HPA is enabled for the service.                                                                                                                                   | `false`              |
| `api.hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`                  |
| `api.hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `2`                  |
| `api.hpa.scaleDownStabilizationWindowSeconds` | Scale-down window.                                                                                                                                                   | `""`                 |
| `api.hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window.                                                                                                                                                     | `""`                 |
| `api.hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`                 |
| `api.hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`                 |

### Worker service settings

| Name                         | Description                              | Value |
| ---------------------------- | ---------------------------------------- | ----- |
| `worker.initialDelaySeconds` | Delay in seconds at the service startup. | `0`   |

### worker.persistentVolume **Persistent Volume settings**

| Name                                   | Description                                                                                                         | Value               |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `worker.persistentVolume.enabled`      | If [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) is enabled for the service | `false`             |
| `worker.persistentVolume.accessModes`  | Persistent Volume [Access Mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)       | `["ReadWriteOnce"]` |
| `worker.persistentVolume.storageClass` | Kubernetes [Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)                          | `topolvm-ext4`      |
| `worker.persistentVolume.size`         | Volume size                                                                                                         | `256Mi`             |

### worker.resources **Kubernetes [resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) settings**

| Name                               | Description       | Value   |
| ---------------------------------- | ----------------- | ------- |
| `worker.resources.requests.cpu`    | A CPU request.    | `50m`   |
| `worker.resources.requests.memory` | A memory request. | `128Mi` |
| `worker.resources.limits.cpu`      | A CPU limit.      | `1`     |
| `worker.resources.limits.memory`   | A memory limit.   | `256Mi` |

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

### Logging settings

| Name        | Description                                                                         | Value  |
| ----------- | ----------------------------------------------------------------------------------- | ------ |
| `log.level` | Log level. Possible values: `debug`, `info`, `warn`, `error`, `fatal`. **Required** | `info` |

### Database access settings

| Name                | Description                                                                         | Value  |
| ------------------- | ----------------------------------------------------------------------------------- | ------ |
| `postgres.host`     | PostgreSQL hostname or IP. **Required**                                             | `""`   |
| `postgres.port`     | PostgreSQL port.                                                                    | `5432` |
| `postgres.timeout`  | PostgreSQL client connection timeout.                                               | `3s`   |
| `postgres.retry`    | PostgreSQL client connection retry.                                                 | `10`   |
| `postgres.name`     | PostgreSQL database name. **Required**                                              | `""`   |
| `postgres.schema`   | PostgreSQL database schema. If not specified, schema from SEARCH_PATH will be used. | `""`   |
| `postgres.username` | PostgreSQL username. **Required**                                                   | `""`   |
| `postgres.password` | PostgreSQL password. **Required**                                                   | `""`   |

### S3 like storage access settings

| Name                 | Description                                                                         | Value    |
| -------------------- | ----------------------------------------------------------------------------------- | -------- |
| `s3.endpoint`        | S3 endpoint as `host|ip:port`. **Required**                                         | `""`     |
| `s3.accessKey`       | S3 access key. **Required**                                                         | `""`     |
| `s3.secretKey`       | S3 secret key. **Required**                                                         | `""`     |
| `s3.bucket`          | S3 bucket name. **Required**                                                        | `styles` |
| `s3.publicDomain`    | S3 public access domain. **Required**                                               | `""`     |
| `s3.connectTimeout`  | S3 management client connection timeout. If not specified, the default value is 3s. | `3s`     |
| `s3.requestTimeout`  | S3 management client request timeout. If not specified, the default value is 30s.   | `5s`     |
| `s3.responseTimeout` | S3 management client response timeout. If not specified, the default value is 3s.   | `5s`     |

### customCAs **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container.                                                                          | `""`  |
