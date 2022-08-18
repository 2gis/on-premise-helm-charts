# 2GIS-PRO UI service

Use this Helm chart to deploy 2GIS-PRO UI service, which is a part of 2GIS's [On-Premise solution](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

## Values

### Docker registry settings

| Name                  | Description                                                                             | Value                    |
| --------------------- | --------------------------------------------------------------------------------------- | ------------------------ |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`                     |
| `imagePullSecrets`    | Kubernetes image pull secrets.                                                          | `[]`                     |
| `imagePullPolicy`     | Pull policy.                                                                            | `IfNotPresent`           |
| `ui.image.repository` | UI service image repository.                                                            | `2gis-on-premise/pro-ui` |
| `ui.image.tag`        | UI service image tag.                                                                   | `0.0.1`                  |


### UI service settings

| Name                                       | Description                                                                                                                    | Value                       |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ | --------------------------- |
| `ui.replicas`                              | A replica count for the pod.                                                                                                   | `1`                         |
| `ui.URBI_API_URL`                          | Base URL for the API.                                                                                                          | `https://2gis-pro-api.host` |
| `ui.MAPGL_HOST`                            | FQDN for MapGL service.                                                                                                        | `mapgl.host`                |
| `ui.MAPGL_KEY`                             | A key to MapGL service.                                                                                                        | `""`                        |
| `ui.LOG_LEVEL`                             | Log messages importance.                                                                                                       | `error`                     |
| `ui.IS_ON_PREM`                            | Application's environment.                                                                                                     | `True`                      |
| `ui.annotations`                           | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                      | `{}`                        |
| `ui.labels`                                | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                | `{}`                        |
| `ui.strategy.rollingUpdate.maxSurge`       | Kubernetes [maxSurge](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#max-surge).                        | `1`                         |
| `ui.strategy.rollingUpdate.maxUnavailable` | Kubernetes [maxUnavailable](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#max-unavailable).            | `0`                         |
| `ui.strategy.type`                         | Kubernetes [type](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy).                             | `RollingUpdate`             |
| `ui.podAnnotations`                        | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                  | `{}`                        |
| `ui.podLabels`                             | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                            | `{}`                        |
| `ui.nodeSelector`                          | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).            | `{}`                        |
| `ui.affinity`                              | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).    | `{}`                        |
| `ui.tolerations`                           | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.              | `{}`                        |
| `ui.service.annotations`                   | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`                        |
| `ui.service.labels`                        | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`                        |
| `ui.service.type`                          | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP`                 |
| `ui.service.port`                          | UI service port.                                                                                                               | `3000`                      |
| `ui.ingress`                               | If [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) is enabled for the service.                     | `{}`                        |


### Limits

| Name                           | Description                   | Value   |
| ------------------------------ | ----------------------------- | ------- |
| `ui.resources`                 | **Limits for the UI service** |         |
| `ui.resources.requests.cpu`    | A CPU request.                | `300m`  |
| `ui.resources.requests.memory` | A memory request.             | `256Mi` |
| `ui.resources.limits.cpu`      | A CPU limit.                  | `1`     |
| `ui.resources.limits.memory`   | A memory limit.               | `384Mi` |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
