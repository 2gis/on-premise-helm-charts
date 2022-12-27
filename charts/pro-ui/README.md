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
| `ui.image.tag`        | Tag                            | `0.1.0`                  |
| `imagePullPolicy`     | Pull Policy                    | `IfNotPresent`           |
| `imagePullSecrets`    | Kubernetes image pull secrets. | `[]`                     |


### UI service settings

| Name                     | Description                                                                                                                                              | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `ui.ssoAuth`             | Flag to turn on/off the authorization. Possible values: `"true"` or `"false"`.                                                                           | `false`         |
| `ui.appTheme`            | Branding inside the app. Possible values: `"2gis"` or `"urbi"`.                                                                                          | `urbi`          |
| `ui.appLocale`           | Language in the app. Possible values: `"en_AE"` or `"ru_RU"`.                                                                                            | `en_AE`         |
| `ui.appInitialMapCenter` | Default map coordinates, it contains of two numbers in an array: [lng, lat] (e.g., `"[55.27, 25.2]"` stands for Dubai, `"[37.64, 55.74]"` — for Moscow). | `[55.27, 25.2]` |


### 2GIS Pro API settings

| Name         | Description                                                                                  | Value |
| ------------ | -------------------------------------------------------------------------------------------- | ----- |
| `ui.api.url` | Base URL for the Pro API with protocol and trailing slash, ex: http://pro-api.ingress.host/. | `""`  |


### MapGL JS API settings

| Name                     | Description                                                                                                                                 | Value                        |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `ui.mapgl.host`          | FQDN (domain or IP) for the [MapGL JS API](https://docs.2gis.com/en/on-premise/map) service without protocol and trailing slash.            | `mapgl-api.host`             |
| `ui.mapgl.key`           | A key to the [MapGL JS API](https://docs.2gis.com/en/on-premise/map) service.                                                               | `""`                         |
| `ui.mapgl.styleUri`      | FQDN (domain or IP) for the [MapGL Style](https://docs.2gis.com/en/mapgl/styles/overview/editor) file without protocol and trailing slash.  | `mapgl-api.host/style`       |
| `ui.mapgl.styleIconsUri` | FQDN (domain or IP) for the [MapGL Style](https://docs.2gis.com/en/mapgl/styles/overview/editor) icons without protocol and trailing slash. | `mapgl-api.host/style/icons` |
| `ui.mapgl.styleFontsUri` | FQDN (domain or IP) for the [MapGL Style](https://docs.2gis.com/en/mapgl/styles/overview/editor) fonts without protocol and trailing slash. | `mapgl-api.host/style/fonts` |


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
