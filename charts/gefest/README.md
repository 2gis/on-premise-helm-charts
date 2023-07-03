# Gefest service

Use this Helm chart to deploy Gefest service, which is a part of 2GIS's [On-Premise solution](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value          |
| --------------------- | --------------------------------------------------------------------------------------- | -------------- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`           |
| `imagePullPolicy`     | Pull Policy                                                                             | `IfNotPresent` |

### Common settings

| Name                | Description                                                                                                                 | Value |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `ui.replicas`       | A replica count for a pod.                                                                                                  | `1`   |
| `ui.nodeSelector`   | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).         | `{}`  |
| `ui.affinity`       | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). | `{}`  |
| `ui.tolerations`    | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.           | `[]`  |
| `ui.podAnnotations` | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`  |
| `ui.podLabels`      | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                         | `{}`  |
| `ui.annotations`    | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`  |
| `ui.labels`         | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`  |

### Deployment settings

| Name                  | Description                    | Value                  |
| --------------------- | ------------------------------ | ---------------------- |
| `ui.image.repository` | Repository                     | `on-premise/gefest-ui` |
| `ui.image.tag`        | Tag                            | `0.1.0`                |
| `imagePullSecrets`    | Kubernetes image pull secrets. | `[]`                   |

### UI service settings

| Name         | Description                                                                                                                                                                                                                                          | Value  |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `ui.appPort` | Service port.                                                                                                                                                                                                                                        | `3000` |
| `ui.brand`   | Branding inside the app. Possible values: `"2gis"` or `"urbi"`.                                                                                                                                                                                      | `""`   |
| `ui.pages`   | A list of pages available in application. Values must be written with a comma. Possible values: `"status"`, `"playground"`. E.g. "status, playground". The first page in a list is the one a user's going to be redirected to from deactivated ones. | `""`   |

### Statuses for services. A value is a string containing pairs of label and healthcheck URL for a service. Pairs must be divided with a comma. Each pair must be connected with a symbol "=", e.g. `mapgl: 'MapGL JS=https://example.com/healthcheck'`. URL must be an absolute. You can specify only one URL, e.g. `mapgl: 'https://example.com/healthcheck'`.

| Name                    | Description                                     | Value |
| ----------------------- | ----------------------------------------------- | ----- |
| `ui.status.mapgl`       | Status list within MapGL service.               | `""`  |
| `ui.status.search`      | Status list within Search service.              | `""`  |
| `ui.status.navi`        | Status list within Navigation service.          | `""`  |
| `ui.status.pro`         | Status list within Pro UI and Pro API services. | `""`  |
| `ui.status.gisPlatform` | Status list within GIS Platform service.        | `""`  |
| `ui.status.keys`        | Status list within Keys service.                | `""`  |

### MapGL JS API settings

| Name                  | Description                                                                                                                                                   | Value     |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| `ui.mapgl.url`        | URL to [MapGL JS API](https://docs.2gis.com/en/on-premise/map) host.                                                                                          | `""`      |
| `ui.mapgl.scriptPath` | URL path to [MapGL JS API](https://docs.2gis.com/en/on-premise/map) init script relative to `ui.mapgl.url`.                                                   | `/api.js` |
| `ui.mapgl.key`        | A key to the [MapGL JS API](https://docs.2gis.com/en/on-premise/map) service.                                                                                 | `""`      |
| `ui.mapgl.initCenter` | Optional default map coordinates. Contains of two numbers in an array: `[lon,lat]` (e.g., `"[55.27,25.2]"` stands for Dubai, `"[37.64,55.74]"` — for Moscow). | `""`      |

### Search API settings

| Name            | Description                                                             | Value                    |
| --------------- | ----------------------------------------------------------------------- | ------------------------ |
| `ui.search.url` | URL for [Search API](https://docs.2gis.com/en/on-premise/search).       | `http://catalog-api.svc` |
| `ui.search.key` | Access key to [Search API](https://docs.2gis.com/en/on-premise/search). | `""`                     |

### Navigation API settings

| Name          | Description                                                                              | Value                  |
| ------------- | ---------------------------------------------------------------------------------------- | ---------------------- |
| `ui.navi.url` | URL for [Navigation API](https://docs.2gis.com/en/on-premise/navigation/overview).       | `http://navi-back.svc` |
| `ui.navi.key` | Access key to [Navigation API](https://docs.2gis.com/en/on-premise/navigation/overview). | `""`                   |

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
| `ui.service.port`        | Service port.                                                                                                                  | `80`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                       | Description                            | Value   |
| -------------------------- | -------------------------------------- | ------- |
| `ui.ingress.enabled`       | If Ingress is enabled for the service. | `false` |
| `ui.ingress.hosts[0].host` | Hostname for the Ingress service.      | `""`    |

### Limits

| Name                           | Description       | Value   |
| ------------------------------ | ----------------- | ------- |
| `ui.resources.requests.cpu`    | A CPU request.    | `300m`  |
| `ui.resources.requests.memory` | A memory request. | `384M`  |
| `ui.resources.limits.cpu`      | A CPU limit.      | `1100m` |
| `ui.resources.limits.memory`   | A memory limit.   | `512M`  |
