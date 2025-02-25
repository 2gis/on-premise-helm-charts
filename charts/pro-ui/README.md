# 2GIS Pro UI service

Use this Helm chart to deploy 2GIS Pro UI service, which is a part of 2GIS's [On-Premise solution](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value          |
| --------------------- | --------------------------------------------------------------------------------------- | -------------- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`           |
| `imagePullPolicy`     | Pull Policy                                                                             | `IfNotPresent` |
| `imagePullSecrets`    | Kubernetes image pull secrets.                                                          | `[]`           |

### Strategy settings

| Name                                    | Description                                                                                                                                                                                              | Value           |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |

### Deployment settings

| Name               | Description | Value                    |
| ------------------ | ----------- | ------------------------ |
| `image.repository` | Repository  | `2gis-on-premise/pro-ui` |
| `image.tag`        | Tag         | `4.5.0`                  |

### Common deployment settings

| Name                            | Description                                                                                                                                                          | Value   |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `replicas`                      | A replica count for the pod.                                                                                                                                         | `1`     |
| `revisionHistoryLimit`          | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                       | `3`     |
| `terminationGracePeriodSeconds` | Seconds pod needs to [terminate](https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods) gracefully                                             | `60`    |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                  | `{}`    |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                          | `{}`    |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                    | `[]`    |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                        | `{}`    |
| `podLabels`                     | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                  | `{}`    |
| `annotations`                   | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                            | `{}`    |
| `labels`                        | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                      | `{}`    |
| `readinessProbe.enabled`        | Enable [readinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes) on PRO UI containers | `true`  |
| `livenessProbe.enabled`         | Enable [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes) on PRO UI containers  | `false` |
| `containerPort`                 | Port on which application listen connection in container                                                                                                             | `3000`  |

### UI service settings

| Name                                | Description                                                                                                                                                                                                                                                                                                                                                                                                       | Value                  |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `ui.healthcheckPath`                | Application http path for health check                                                                                                                                                                                                                                                                                                                                                                            | `/api/healthcheck/app` |
| `ui.appTheme`                       | Branding inside the app. Possible values: `"2gis"` or `"urbi"`.                                                                                                                                                                                                                                                                                                                                                   | `urbi`                 |
| `ui.appLocale`                      | Language in the app. Possible values: `"ar_AE"`, `"en_AE"` or `"ru_RU"`.                                                                                                                                                                                                                                                                                                                                          | `en_AE`                |
| `ui.appInitialMapCenter`            | Default map coordinates, it contains of two numbers in an array: [lng, lat] (e.g., [55.27, 25.2] stands for Dubai, [37.64, 55.74] — for Moscow).                                                                                                                                                                                                                                                                  | `[46.71, 24.72]`       |
| `ui.supportDocumentationLink`       | Product online documentation root link. Ex.: 'https://docs.urbi.ae/en/pro', 'https://docs.2gis.com/ru/pro'                                                                                                                                                                                                                                                                                                        | `""`                   |
| `ui.immersiveModels`                | A string value for config to enabling 3D-models. Possible values: [{"id":4,"name":"Ground","mapOptions":{"center":[53.287567,23.564967],"styleZoom":19.2,"pitch":45,"rotation":0},"objects":[{"buildingIds":[],"coords":[53.284762,23.569323],"scale":90,"rotateX":0.5,"rotateY":0,"moveX":0,"moveY":0,"moveZ":0,"models":[{"path":"/static/models/adnoc/ground.glb","name":"Ground","displayName":"Ground"}]}]}] | `""`                   |
| `ui.publicS3Url`                    | Optional URL of public S3 where style data will be placed. Example: https://s3.domain.example.com/                                                                                                                                                                                                                                                                                                                | `""`                   |
| `ui.auth.sso`                       | Flag to turn on/off the authorization. Possible values: `"true"` or `"false"`.                                                                                                                                                                                                                                                                                                                                    | `false`                |
| `ui.auth.secure`                    | Flag to turn on/off the https for auth. Possible values: `"true"` or `"false"`.                                                                                                                                                                                                                                                                                                                                   | `true`                 |
| `ui.auth.safeHosts`                 | a string with regExp, which checks incoming authCodeUrl                                                                                                                                                                                                                                                                                                                                                           | `.*`                   |
| `ui.auth.codeUrl`                   | an URL, which is used to exchange code to token: host/api/auth/code                                                                                                                                                                                                                                                                                                                                               | `""`                   |
| `ui.auth.brand`                     | Fill in the brand if you are using integration with the Platform Manager. The brand is defined in the Platform Manager space, they should be the same. The application will use the brand to define the realm on the Platform Manager's side. If you're not using integration with the Platform Manager, leave it empty.                                                                                          | `""`                   |
| `ui.auth.clientId`                  | a client_id from keycloack                                                                                                                                                                                                                                                                                                                                                                                        | `""`                   |
| `ui.auth.clientSecret`              | a client_secret from keycloack                                                                                                                                                                                                                                                                                                                                                                                    | `""`                   |
| `ui.auth.oAuthProvider`             | a provider name. Possible values: "keycloak" | "openid"                                                                                                                                                                                                                                                                                                                                                           | `keycloak`             |
| `ui.auth.oAuthScopes`               | scopes for openid connect. Possible values:                                                                                                                                                                                                                                                                                                                                                                       | `""`                   |
| `ui.auth.identityProviderUrl`       | a provider base URL                                                                                                                                                                                                                                                                                                                                                                                               | `""`                   |
| `ui.auth.oAuthApiUrl`               | an oAuth provider base URL                                                                                                                                                                                                                                                                                                                                                                                        | `""`                   |
| `ui.auth.platformManagerHost`       | Fill in the Platform Manager host if you're using integration with it. Application will use it for redirecting to the SignUp page. Without protocol we will put App's protocol. If you're not using integration with the Platform Manager, leave it empty.                                                                                                                                                        | `""`                   |
| `ui.auth.turnOffCertValidation`     | Flag to turn off certificate validation. Possible values: `"true"` or `"false"`.                                                                                                                                                                                                                                                                                                                                  | `false`                |
| `ui.auth.openIdWellKnownUrlListUrl` | URL to OpenID Connect Discovery data                                                                                                                                                                                                                                                                                                                                                                              | `""`                   |

### 2GIS Pro API settings

| Name                   | Description                                                                                  | Value   |
| ---------------------- | -------------------------------------------------------------------------------------------- | ------- |
| `ui.api.url`           | Base URL for the Pro API with protocol and trailing slash, ex: http://pro-api.ingress.host/. | `""`    |
| `ui.api.timeout`       | Timeout in ms for API request on client side, ex: 30000.                                     | `30000` |
| `ui.api.serverTimeout` | Timeout in ms for API request on server side, ex: 30000.                                     | `30000` |

### MapGL JS API settings

| Name                      | Description                                                                                                                                                                                          | Value            |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `ui.mapgl.host`           | FQDN (domain or IP) for the [MapGL JS API](https://docs.2gis.com/en/on-premise/map) service with or without protocol. Without protocol we will put App's protocol.                                   | `mapgl-api.host` |
| `ui.mapgl.key`            | A key to the [MapGL JS API](https://docs.2gis.com/en/on-premise/map) service.                                                                                                                        | `""`             |
| `ui.mapgl.styleUrl`       | Optional URL for [MapGL Style](https://docs.2gis.com/en/mapgl/styles/overview/editor) `style.json` folder, e.g., '//mapgl.ingress.host/style'. ui.mapgl.styleUrl has priority over ui.mapgl.styleId. | `""`             |
| `ui.mapgl.styleIconsUrl`  | Optional URL for [MapGL Style](https://docs.2gis.com/en/mapgl/styles/overview/editor) icons folder, e.g., '//mapgl.ingress.host/style/icons'                                                         | `""`             |
| `ui.mapgl.styleFontsUrl`  | Optional URL for [MapGL Style](https://docs.2gis.com/en/mapgl/styles/overview/editor) fonts folder, e.g., '//mapgl.ingress.host/style/fonts'                                                         | `""`             |
| `ui.mapgl.stylePreview`   | URL to image for ui.mapgl.styleUrl or ui.mapgl.styleId. It needs for preview in manager styles.                                                                                                      | `""`             |
| `ui.mapgl.styleModelsUrl` | Optional URL for [MapGL Style](https://docs.2gis.com/en/mapgl/styles/overview/editor) models folder, e.g., '//mapgl.ingress.host/style/models'                                                       | `""`             |

### Mapbox style config settings

| Name                   | Description                                                           | Value |
| ---------------------- | --------------------------------------------------------------------- | ----- |
| `ui.mapbox.styleToken` | Optional [Mapbox Token](https://docs.mapbox.com/api/accounts/tokens/) | `""`  |

### External style manager configuration.

| Name                              | Description                                            | Value   |
| --------------------------------- | ------------------------------------------------------ | ------- |
| `ui.externalStyleManager.enabled` | - Set "true" to enable External Style Manager features | `false` |

### Map styles config settings

| Name                  | Description                                                     | Value |
| --------------------- | --------------------------------------------------------------- | ----- |
| `ui.styles.s3Bucket`  | Optional S3 bucket name for style files. Bucket must be public. | `""`  |
| `ui.styles.configUrl` | Optional URL for styles config file                             | `""`  |

### WhiteLabel config settings

| Name                      | Description                                                                                                                                                                                          | Value |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `ui.whiteLabel.configUrl` | Optional URL for whitelabel config file                                                                                                                                                              | `""`  |
| `ui.whiteLabel.s3Bucket`  | Optional S3 bucket name for whitelabel files. Bucket must be public. If set with ui.publicS3Url all relative URL in config will be replaced to ui.publicS3Url + ui.whiteLabel.s3Bucket + originalURL | `""`  |

### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | Service port.                                                                                                                  | `3000`      |
| `service.targetPort`  | Service target port.                                                                                                           | `http`      |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                |
| ------------------------------------ | ----------------------------------------- | -------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`              |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`              |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `pro-ui.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                  |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`             |
| `ingress.tls`                        | TLS configuration                         | `[]`                 |

### Limits

| Name                        | Description       | Value   |
| --------------------------- | ----------------- | ------- |
| `resources.requests.cpu`    | A CPU request.    | `300m`  |
| `resources.requests.memory` | A memory request. | `256Mi` |
| `resources.limits.cpu`      | A CPU limit.      | `1`     |
| `resources.limits.memory`   | A memory limit.   | `384Mi` |

### Autoscaling configuration

| Name               | Description                          | Value   |
| ------------------ | ------------------------------------ | ------- |
| `hpa.enabled`      | Enable hpa for PRO UI                | `false` |
| `hpa.minReplicas`  | Minimum number of PRO UI replicas    | `2`     |
| `hpa.maxReplicas`  | Maximum number of PRO UI replicas    | `5`     |
| `hpa.targetCPU`    | Target CPU utilization percentage    | `100`   |
| `hpa.targetMemory` | Target Memory utilization percentage | `""`    |

### Artifacts Storage settings

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

### Import job settings

| Name                                       | Description                                                                                                                                            | Value                          |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------ |
| `stylesImporter.name`                      | Styles Import job name.                                                                                                                                | `styles-importer`              |
| `stylesImporter.image.repository`          | Docker Repository Image.                                                                                                                               | `2gis-on-premise/pro-importer` |
| `stylesImporter.image.tag`                 | Docker image tag.                                                                                                                                      | `1.54.0`                       |
| `stylesImporter.backoffLimit`              | The number of [retries](https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy) before considering a Job as failed. | `2`                            |
| `stylesImporter.nodeSelector`              | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                    | `{}`                           |
| `stylesImporter.maxParallelJobs`           | How many import jobs can be run simultaneously                                                                                                         | `1`                            |
| `stylesImporter.startOnDeploy`             | Indicates that styles import should start when service installed or updated                                                                            | `false`                        |
| `stylesImporter.resources.requests.cpu`    | A CPU request.                                                                                                                                         | `700m`                         |
| `stylesImporter.resources.requests.memory` | A memory request.                                                                                                                                      | `768M`                         |
| `stylesImporter.resources.limits.cpu`      | A CPU limit.                                                                                                                                           | `1000m`                        |
| `stylesImporter.resources.limits.memory`   | A memory limit.                                                                                                                                        | `8Gi`                          |


## Maintainers

| Name | Email                 | Url                       |
| ---- | --------------------- | ------------------------- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
