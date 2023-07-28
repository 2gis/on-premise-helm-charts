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
| `image.tag`        | Twins API service image tag.                                                                  | `1.6.0`                     |
| `image.pullPolicy` | Image [pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) | `IfNotPresent`              |

### API service settings

| Name                                          | Description                                                                                                                                                                                              | Value            |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `api.strategy.type`                           | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate`  |
| `api.strategy.rollingUpdate.maxUnavailable`   | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`              |
| `api.strategy.rollingUpdate.maxSurge`         | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`              |
| `api.keys.url`                                | URL of the Keys service, ex: http://{keys-api}.svc. This URL should be accessible from all the pods within your Kubernetes cluster. **Required**                                                         | `""`             |
| `api.keys.token`                              | Keys service API key **Required**                                                                                                                                                                        | `""`             |
| `api.keys.requestTimeout`                     | Timeout for requests to the Keys API.                                                                                                                                                                    | `5s`             |
| `api.replicas`                                | A replica count for the pod.                                                                                                                                                                             | `1`              |
| `api.annotations`                             | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                | `{}`             |
| `api.labels`                                  | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                          | `{}`             |
| `api.podAnnotations`                          | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                            | `{}`             |
| `api.podLabels`                               | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                      | `{}`             |
| `api.nodeSelector`                            | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                      | `{}`             |
| `api.affinity`                                | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                                                              | `{}`             |
| `api.tolerations`                             | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                                        | `{}`             |
| `api.service.annotations`                     | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                        | `{}`             |
| `api.service.labels`                          | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                  | `{}`             |
| `api.service.type`                            | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                                                                           | `ClusterIP`      |
| `api.service.port`                            | Service port.                                                                                                                                                                                            | `80`             |
| `api.ingress.enabled`                         | If Ingress is enabled for the service.                                                                                                                                                                   | `false`          |
| `api.ingress.hosts[0].host`                   | Hostname for the Ingress service.                                                                                                                                                                        | `twins-api.host` |
| `api.hpa.enabled`                             | If HPA is enabled for the service.                                                                                                                                                                       | `false`          |
| `api.hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                                                           | `1`              |
| `api.hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                                                             | `2`              |
| `api.hpa.scaleDownStabilizationWindowSeconds` | Scale-down window.                                                                                                                                                                                       | `""`             |
| `api.hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window.                                                                                                                                                                                         | `""`             |
| `api.hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.                                           | `80`             |
| `api.hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used.                                     | `""`             |

### Migrate service settings

| Name                          | Description                                                                                                         | Value |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------- | ----- |
| `migrate.initialDelaySeconds` | Delay in seconds at the service startup.                                                                            | `0`   |
| `migrate.nodeSelector`        | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector). | `{}`  |

### Database access settings

| Name                   | Description                                                                         | Value  |
| ---------------------- | ----------------------------------------------------------------------------------- | ------ |
| `postgres.ro`          | **Settings for the read-only access**                                               |        |
| `postgres.ro.host`     | PostgreSQL hostname or IP. **Required**                                             | `""`   |
| `postgres.ro.port`     | PostgreSQL port.                                                                    | `5432` |
| `postgres.ro.timeout`  | PostgreSQL client connection timeout.                                               | `3s`   |
| `postgres.ro.name`     | PostgreSQL database name. **Required**                                              | `""`   |
| `postgres.ro.schema`   | PostgreSQL database schema. If not specified, schema from SEARCH_PATH will be used. | `""`   |
| `postgres.ro.username` | PostgreSQL username. **Required**                                                   | `""`   |
| `postgres.ro.password` | PostgreSQL password. **Required**                                                   | `""`   |
| `postgres.rw`          | **Settings for the read-write access**                                              |        |
| `postgres.rw.host`     | PostgreSQL hostname or IP. **Required**                                             | `""`   |
| `postgres.rw.port`     | PostgreSQL port.                                                                    | `5432` |
| `postgres.rw.timeout`  | PostgreSQL client connection timeout.                                               | `3s`   |
| `postgres.rw.name`     | PostgreSQL database name. **Required**                                              | `""`   |
| `postgres.rw.schema`   | PostgreSQL database schema. If not specified, schema from SEARCH_PATH will be used. | `""`   |
| `postgres.rw.username` | PostgreSQL username. **Required**                                                   | `""`   |
| `postgres.rw.password` | PostgreSQL password. **Required**                                                   | `""`   |

### Limits

| Name                                | Description                        | Value   |
| ----------------------------------- | ---------------------------------- | ------- |
| `api.resources`                     | **Limits for the API service**     |         |
| `api.resources.requests.cpu`        | A CPU request.                     | `50m`   |
| `api.resources.requests.memory`     | A memory request.                  | `128Mi` |
| `api.resources.limits.cpu`          | A CPU limit.                       | `1`     |
| `api.resources.limits.memory`       | A memory limit.                    | `256Mi` |
| `migrate.resources`                 | **Limits for the Migrate service** |         |
| `migrate.resources.requests.cpu`    | A CPU request.                     | `10m`   |
| `migrate.resources.requests.memory` | A memory request.                  | `32Mi`  |
| `migrate.resources.limits.cpu`      | A CPU limit.                       | `100m`  |
| `migrate.resources.limits.memory`   | A memory limit.                    | `64Mi`  |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
