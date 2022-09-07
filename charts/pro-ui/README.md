# 2GIS Pro UI service

Use this Helm chart to deploy 2GIS Pro UI service, which is a part of 2GIS's [On-Premise solution](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |


### Common settings

| Name                | Description                                                                                                                 | Value |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `ui.replicas`       | A replica count for the pod.                                                                                                | `1`   |
| `ui.nodeSelector`   | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).         | `{}`  |
| `ui.affinity`       | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). | `{}`  |
| `ui.tolerations`    | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.           | `[]`  |
| `ui.podAnnotations` | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`  |
| `ui.podLabels`      | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                         | `{}`  |
| `ui.annotations`    | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`  |
| `ui.labels`         | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`  |


### Deployment settings

| Name                  | Description                    | Value                    |
| --------------------- | ------------------------------ | ------------------------ |
| `ui.image.repository` | Repository                     | `2gis-on-premise/pro-ui` |
| `ui.image.tag`        | Tag                            | `0.0.1`                  |
| `imagePullPolicy`     | Pull Policy                    | `IfNotPresent`           |
| `imagePullSecrets`    | Kubernetes image pull secrets. | `[]`                     |


### UI service settings

| Name          | Description              | Value   |
| ------------- | ------------------------ | ------- |
| `ui.logLevel` | Log messages importance. | `error` |


### 2GIS Pro API settings

| Name          | Description                    | Value          |
| ------------- | ------------------------------ | -------------- |
| `ui.api.host` | Base URL for the 2GIS Pro API. | `pro-api.host` |


### MapGL JS API settings

| Name            | Description                                                                       | Value            |
| --------------- | --------------------------------------------------------------------------------- | ---------------- |
| `ui.mapgl.host` | Hostname for the [MapGL JS API](https://docs.2gis.com/en/on-premise/map) service. | `mapgl-api.host` |
| `ui.mapgl.key`  | A key to the [MapGL JS API](https://docs.2gis.com/en/on-premise/map) service.     | `""`             |


### Strategy settings

| Name                                       | Description                                                                                                                                                                                              | Value           |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `ui.strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `ui.strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `ui.strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |


### Service settings

| Name                     | Description                                                                                                                    | Value       |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `ui.service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `ui.service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `ui.service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `ui.service.port`        | Service port.                                                                                                                  | `3000`      |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                       | Description                            | Value         |
| -------------------------- | -------------------------------------- | ------------- |
| `ui.ingress.enabled`       | If Ingress is enabled for the service. | `false`       |
| `ui.ingress.hosts[0].host` | Hostname for the Ingress service.      | `pro-ui.host` |


### Limits

| Name                           | Description       | Value   |
| ------------------------------ | ----------------- | ------- |
| `ui.resources.requests.cpu`    | A CPU request.    | `300m`  |
| `ui.resources.requests.memory` | A memory request. | `256Mi` |
| `ui.resources.limits.cpu`      | A CPU limit.      | `1`     |
| `ui.resources.limits.memory`   | A memory limit.   | `384Mi` |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
