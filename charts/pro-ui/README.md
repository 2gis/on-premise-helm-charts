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
| `ui.image.tag`        | Tag                            | `1.7.5`                  |
| `imagePullPolicy`     | Pull Policy                    | `IfNotPresent`           |
| `imagePullSecrets`    | Kubernetes image pull secrets. | `[]`                     |

### UI service settings

| Name                            | Description                                                                                                                                                                                                                                                                                                                                                                                                       | Value            |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `ui.appTheme`                   | Branding inside the app. Possible values: `"2gis"` or `"urbi"`.                                                                                                                                                                                                                                                                                                                                                   | `urbi`           |
| `ui.appLocale`                  | Language in the app. Possible values: `"ar_AE"`, `"en_AE"` or `"ru_RU"`.                                                                                                                                                                                                                                                                                                                                          | `en_AE`          |
| `ui.appInitialMapCenter`        | Default map coordinates, it contains of two numbers in an array: [lng, lat] (e.g., [55.27, 25.2] stands for Dubai, [37.64, 55.74] — for Moscow).                                                                                                                                                                                                                                                                  | `[46.71, 24.72]` |
| `ui.supportDocumentationLink`   | Product online documentation link. Ex.: 'https://docs.urbi.ae/en/pro/start'                                                                                                                                                                                                                                                                                                                                       | `""`             |
| `ui.immersiveModels`            | A string value for config to enabling 3D-models. Possible values: [{"id":4,"name":"Ground","mapOptions":{"center":[53.287567,23.564967],"styleZoom":19.2,"pitch":45,"rotation":0},"objects":[{"buildingIds":[],"coords":[53.284762,23.569323],"scale":90,"rotateX":0.5,"rotateY":0,"moveX":0,"moveY":0,"moveZ":0,"models":[{"path":"/static/models/adnoc/ground.glb","name":"Ground","displayName":"Ground"}]}]}] | `""`             |
| `ui.auth.sso`                   | Flag to turn on/off the authorization. Possible values: `"true"` or `"false"`.                                                                                                                                                                                                                                                                                                                                    | `false`          |
| `ui.auth.secure`                | Flag to turn on/off the https for auth. Possible values: `"true"` or `"false"`.                                                                                                                                                                                                                                                                                                                                   | `true`           |
| `ui.auth.safeHosts`             | a string with regExp, which checks incoming authCodeUrl                                                                                                                                                                                                                                                                                                                                                           | `.*`             |
| `ui.auth.codeUrl`               | an URL, which is used to exchange code to token: host/api/auth/code                                                                                                                                                                                                                                                                                                                                               | `""`             |
| `ui.auth.clientId`              | a client_id from keycloack                                                                                                                                                                                                                                                                                                                                                                                        | `""`             |
| `ui.auth.clientSecret`          | a client_secret from keycloack                                                                                                                                                                                                                                                                                                                                                                                    | `""`             |
| `ui.auth.oAuthProvider`         | a provider name. Possible values: "keycloak" | "ugc"                                                                                                                                                                                                                                                                                                                                                              | `keycloak`       |
| `ui.auth.oAuthScopes`           | scopes for openid connect. Possible values:                                                                                                                                                                                                                                                                                                                                                                       | `""`             |
| `ui.auth.identityProviderUrl`   | a provider base URL                                                                                                                                                                                                                                                                                                                                                                                               | `""`             |
| `ui.auth.oAuthApiUrl`           | an oAuth provider base URL                                                                                                                                                                                                                                                                                                                                                                                        | `""`             |
| `ui.auth.userDataApiUrl`        | an user data provider URL                                                                                                                                                                                                                                                                                                                                                                                         | `""`             |
| `ui.auth.turnOffCertValidation` | Flag to turn off certificate validation. Possible values: `"true"` or `"false"`.                                                                                                                                                                                                                                                                                                                                  | `false`          |

### 2GIS Pro API settings

| Name         | Description                                                                                  | Value |
| ------------ | -------------------------------------------------------------------------------------------- | ----- |
| `ui.api.url` | Base URL for the Pro API with protocol and trailing slash, ex: http://pro-api.ingress.host/. | `""`  |

### MapGL JS API settings

| Name                      | Description                                                                                                                                                                                          | Value            |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `ui.mapgl.host`           | FQDN (domain or IP) for the [MapGL JS API](https://docs.2gis.com/en/on-premise/map) service with or without protocol. Without protocol we will put App's protocol.                                   | `mapgl-api.host` |
| `ui.mapgl.key`            | A key to the [MapGL JS API](https://docs.2gis.com/en/on-premise/map) service.                                                                                                                        | `""`             |
| `ui.mapgl.styleUrl`       | Optional URL for [MapGL Style](https://docs.2gis.com/en/mapgl/styles/overview/editor) `style.json` folder, e.g., '//mapgl.ingress.host/style'. ui.mapgl.styleUrl has priority over ui.mapgl.styleId. | `""`             |
| `ui.mapgl.styleIconsUrl`  | Optional URL for [MapGL Style](https://docs.2gis.com/en/mapgl/styles/overview/editor) icons folder, e.g., '//mapgl.ingress.host/style/icons'                                                         | `""`             |
| `ui.mapgl.styleFontsUrl`  | Optional URL for [MapGL Style](https://docs.2gis.com/en/mapgl/styles/overview/editor) fonts folder, e.g., '//mapgl.ingress.host/style/fonts'                                                         | `""`             |
| `ui.mapgl.styleModelsUrl` | Optional URL for [MapGL Style](https://docs.2gis.com/en/mapgl/styles/overview/editor) models folder, e.g., '//mapgl.ingress.host/style/models'                                                       | `""`             |

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

| Name                                    | Description                               | Value                |
| --------------------------------------- | ----------------------------------------- | -------------------- |
| `ui.ingress.enabled`                    | If Ingress is enabled for the service.    | `false`              |
| `ui.ingress.className`                  | Name of the Ingress controller class.     | `nginx`              |
| `ui.ingress.hosts[0].host`              | Hostname for the Ingress service.         | `pro-ui.example.com` |
| `ui.ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                  |
| `ui.ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`             |
| `ui.ingress.tls`                        | TLS configuration                         | `[]`                 |

### Limits

| Name                           | Description       | Value   |
| ------------------------------ | ----------------- | ------- |
| `ui.resources.requests.cpu`    | A CPU request.    | `300m`  |
| `ui.resources.requests.memory` | A memory request. | `256Mi` |
| `ui.resources.limits.cpu`      | A CPU limit.      | `1`     |
| `ui.resources.limits.memory`   | A memory limit.   | `384Mi` |


## Maintainers

| Name | Email                 | Url                       |
| ---- | --------------------- | ------------------------- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
