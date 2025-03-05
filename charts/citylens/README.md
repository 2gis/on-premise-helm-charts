# 2GIS Citylens service

Use this Helm chart to deploy Citylens services, which is a part of 2GIS's [On-Premise recognitions services]().

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation]() to learn about:

- Architecture of the service.

- Installing the service.

  When filling in the keys for `values.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                                         | Value |
| --------------------- | --------------------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port` **Required** | `""`  |

### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                                           | Value   |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `dgctlStorage.host`      | S3 host. Format: `host:port`. **Required**                                                                                                                                                                                                                            | `""`    |
| `dgctlStorage.secure`    | Set to `true` if dgctlStorage.host must be accessed via https. **Required**                                                                                                                                                                                           | `false` |
| `dgctlStorage.bucket`    | S3 bucket name. **Required**                                                                                                                                                                                                                                          | `""`    |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket. **Required**                                                                                                                                                                                                                  | `""`    |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket. **Required**                                                                                                                                                                                                                  | `""`    |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json` <br> This file contains the description of pieces of data that the service requires to operate. **Required** | `""`    |
| `dgctlStorage.verifySsl` | Set to `false` if dgctlStorage.host must be accessed via https without certificate validation. **Required**                                                                                                                                                           | `true`  |
| `dgctlStorage.region`    | S3 region name.                                                                                                                                                                                                                                                       | `""`    |

### Citylens API service settings


### Image settings

| Name                   | Description  | Value                          |
| ---------------------- | ------------ | ------------------------------ |
| `api.image.repository` | Repository.  | `2gis-on-premise/citylens-api` |
| `api.image.tag`        | Tag.         | `1.17.5`                       |
| `api.image.pullPolicy` | Pull Policy. | `IfNotPresent`                 |

### Resources settings

| Name                            | Description                                                                                                                                    | Value   |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `api.replicas`                  | A replica count for the pod.                                                                                                                   | `4`     |
| `api.revisionHistoryLimit`      | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`     |
| `api.resources.requests.cpu`    | A CPU request.                                                                                                                                 | `1000m` |
| `api.resources.requests.memory` | A memory request.                                                                                                                              | `1Gi`   |
| `api.resources.limits.cpu`      | A CPU limit.                                                                                                                                   | `2000m` |
| `api.resources.limits.memory`   | A memory limit.                                                                                                                                | `2Gi`   |

### Service settings

| Name                            | Description                                                                                                                    | Value       |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `api.service.type`              | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `api.service.port`              | Service port.                                                                                                                  | `80`        |
| `api.service.targetPort`        | Service target port.                                                                                                           | `8000`      |
| `api.service.metricsTargetPort` | Service prometheus metrics target port. Metrics are available on /healthz/metrics endpoint.                                    | `8001`      |
| `api.service.annotations`       | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `api.service.labels`            | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                                                  | Description                                                                                                           | Value                                                 |
| --------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| `api.ingress.enabled`                                                 | If Ingress is enabled for the service.                                                                                | `false`                                               |
| `api.ingress.className`                                               | Resource that contains additional configuration including the name of the controller that should implement the class. | `""`                                                  |
| `api.ingress.annotations.nginx.ingress.kubernetes.io/proxy-body-size` | Proxy-body-size parameter (default 1MB).                                                                              | `{"nginx.ingress.kubernetes.io/proxy-body-size":"0"}` |
| `api.ingress.hosts[0].host`                                           | Hostname for the Ingress service. Ex.: 'citylens.api'.                                                                | `citylens-api.example.com`                            |
| `api.ingress.hosts[0].paths[0].path`                                  | Endpoint of host.                                                                                                     | `/`                                                   |
| `api.ingress.hosts[0].paths[0].pathType`                              | Path type of endpoint.                                                                                                | `Prefix`                                              |
| `api.ingress.tls`                                                     | Tls settings for https.                                                                                               | `[]`                                                  |

### Auth settings for authentication

| Name                               | Description                                                                                                                                                                                                   | Value  |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `api.auth.enabled`                 | If authentication is needed.                                                                                                                                                                                  | `true` |
| `api.auth.authServerUrl`           | API URL of authentication service, OIDC-compatibility expected. Ex.: `http(s)://keycloak.ingress.host/`. **Required**                                                                                         | `""`   |
| `api.auth.storeOIDCUserinfoFields` | List of fields from OIDC userinfo_endpoint response to store for users, uploading tracks. Ex.: `['en_name', 'id_no']`.                                                                                        | `[]`   |
| `api.auth.realm`                   | Authentication realm. Used for constructing openid-configuration endpoint: `/realms/realm/.well-known/openid-configuration` if realm defined, `/.well-known/openid-configuration` othervise. Ex: CityLens_app | `""`   |
| `api.auth.verifySsl`               | Enable\Disable SSL check.                                                                                                                                                                                     | `true` |

### Bearer tokens for callbacks & predictors

| Name                               | Description                                                                                                             | Value |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ----- |
| `api.auth.predictorsTokens.camcom` | Bearer token, expected on CamCom callback endpoint and CamCom prediction endpoint (if integration with CamCom enabled). | `""`  |

### Licensing server settings

| Name                | Description                                                | Value |
| ------------------- | ---------------------------------------------------------- | ----- |
| `api.licensing.url` | Licensing server v2 URL. https://license.svc. **Required** | `""`  |

### Custom settings

| Name                 | Description                                            | Value          |
| -------------------- | ------------------------------------------------------ | -------------- |
| `api.showDocs`       | Show documentation link if needed.                     | `false`        |
| `api.logLevel`       | Log level.                                             | `INFO`         |
| `api.metricsAppName` | Value for service prometheus metrics label "app_name". | `citylens-api` |

### Metadata settings

| Name                 | Description                                                                                                                 | Value |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `api.annotations`    | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`  |
| `api.labels`         | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`  |
| `api.podAnnotations` | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`  |
| `api.podLabels`      | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`  |
| `api.nodeSelector`   | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).     | `{}`  |
| `api.tolerations`    | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.       | `{}`  |
| `api.affinity`       | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings. | `{}`  |

### Citylens web service settings


### Image settings

| Name                   | Description  | Value                          |
| ---------------------- | ------------ | ------------------------------ |
| `web.image.repository` | Repository.  | `2gis-on-premise/citylens-web` |
| `web.image.tag`        | Tag.         | `1.17.5`                       |
| `web.image.pullPolicy` | Pull Policy. | `IfNotPresent`                 |

### Resources settings

| Name                            | Description                                                                                                                                    | Value   |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `web.replicas`                  | A replica count for the pod.                                                                                                                   | `1`     |
| `web.revisionHistoryLimit`      | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`     |
| `web.resources.requests.cpu`    | A CPU request.                                                                                                                                 | `1000m` |
| `web.resources.requests.memory` | A memory request.                                                                                                                              | `1Gi`   |
| `web.resources.limits.cpu`      | A CPU limit.                                                                                                                                   | `2000m` |
| `web.resources.limits.memory`   | A memory limit.                                                                                                                                | `2Gi`   |

### Service settings

| Name                            | Description                                                                                                                    | Value       |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `web.service.type`              | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `web.service.port`              | Service port.                                                                                                                  | `80`        |
| `web.service.targetPort`        | Service target port.                                                                                                           | `5000`      |
| `web.service.metricsTargetPort` | Service prometheus metrics target port. Metrics are available on /healthz/metrics endpoint.                                    | `5001`      |
| `web.service.annotations`       | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `web.service.labels`            | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `web.service.metricsEnabled`    | Enable prometheus metrics                                                                                                      | `true`      |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                                                  | Description                                                                                                           | Value                                                 |
| --------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| `web.ingress.enabled`                                                 | If Ingress is enabled for the service.                                                                                | `false`                                               |
| `web.ingress.className`                                               | Resource that contains additional configuration including the name of the controller that should implement the class. | `""`                                                  |
| `web.ingress.annotations.nginx.ingress.kubernetes.io/proxy-body-size` | Proxy-body-size parameter (default 1MB).                                                                              | `{"nginx.ingress.kubernetes.io/proxy-body-size":"0"}` |
| `web.ingress.hosts[0].host`                                           | Hostname for the Ingress service. Ex.: 'citylens.web'.                                                                | `citylens-web.example.com`                            |
| `web.ingress.hosts[0].paths[0].path`                                  | Endpoint of host.                                                                                                     | `/`                                                   |
| `web.ingress.hosts[0].paths[0].pathType`                              | Path type of endpoint.                                                                                                | `Prefix`                                              |
| `web.ingress.tls`                                                     | Tls settings for https.                                                                                               | `[]`                                                  |

### Auth settings for authentication

| Name                     | Description                                                                                                                                                                                                                | Value   |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `web.auth.enabled`       | If authentication is needed.                                                                                                                                                                                               | `false` |
| `web.auth.realm`         | Authentication realm. Used for constructing openid-configuration endpoint: `/realms/realm/.well-known/openid-configuration` if realm defined, `/.well-known/openid-configuration` othervise. Ex: Inspection_Portal_backend | `""`    |
| `web.auth.authServerUrl` | API URL of authentication service, OIDC-compatibility expected. Ex: `http(s)://keycloak.ingress.host` **Required**                                                                                                         | `""`    |
| `web.auth.clientId`      | Client id from keycloak. Ex: citylens-web-client **Required**                                                                                                                                                              | `""`    |
| `web.auth.clientSecret`  | Client Secret from keycloak. **Required**                                                                                                                                                                                  | `""`    |
| `web.auth.verifySsl`     | Enable\Disable SSL check.                                                                                                                                                                                                  | `true`  |
| `web.auth.pkce`          | Enable\Disable PKCE (Proof Key for Code Exchange) in Authorization Code flow.                                                                                                                                              | `false` |

### Custom settings

| Name                    | Description                                                                                 | Value          |
| ----------------------- | ------------------------------------------------------------------------------------------- | -------------- |
| `web.logLevel`          | Log level.                                                                                  | `WARNING`      |
| `web.metricsAppName`    | Value for service prometheus metrics label "app_name".                                      | `citylens-web` |
| `web.pgPoolSize`        | Postgres: maximum number of connections in connections pool to maintain.                    | `5`            |
| `web.pgPoolMaxOverflow` | Postgres: maximum number of extra connections in connections pool (relative of pgPoolSize). | `10`           |

### Metadata settings

| Name                 | Description                                                                                                                 | Value |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `web.annotations`    | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`  |
| `web.labels`         | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`  |
| `web.podAnnotations` | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`  |
| `web.podLabels`      | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`  |
| `web.nodeSelector`   | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).     | `{}`  |
| `web.tolerations`    | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.       | `{}`  |
| `web.affinity`       | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings. | `{}`  |

### Citylens workers service settings


### Resources settings

| Name                               | Description       | Value   |
| ---------------------------------- | ----------------- | ------- |
| `worker.resources.requests.cpu`    | A CPU request.    | `1000m` |
| `worker.resources.requests.memory` | A memory request. | `1Gi`   |
| `worker.resources.limits.cpu`      | A CPU limit.      | `2000m` |
| `worker.resources.limits.memory`   | A memory limit.   | `2Gi`   |

### Citylens Frames Saver worker's settings

| Name                                      | Description                                                                                                                                    | Value |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `worker.framesSaver.replicas`             | A replica count for the pod.                                                                                                                   | `4`   |
| `worker.framesSaver.revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`   |
| `worker.framesSaver.annotations`          | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`  |
| `worker.framesSaver.labels`               | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`  |
| `worker.framesSaver.podAnnotations`       | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`  |
| `worker.framesSaver.podLabels`            | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`  |
| `worker.framesSaver.nodeSelector`         | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`  |
| `worker.framesSaver.tolerations`          | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`  |
| `worker.framesSaver.affinity`             | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`  |

### Citylens Camcom sender worker's settings

| Name                                          | Description                                                                                                                                    | Value   |
| --------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `worker.camcomSender.enabled`                 | If Camcom Sender worker is enabled for the service.                                                                                            | `false` |
| `worker.camcomSender.replicas`                | A replica count for the pod.                                                                                                                   | `1`     |
| `worker.camcomSender.revisionHistoryLimit`    | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`     |
| `worker.camcomSender.apiKey`                  | A key for Camcom's API access                                                                                                                  | `""`    |
| `worker.camcomSender.endpointUrl`             | Camcom endpoint URL                                                                                                                            | `""`    |
| `worker.camcomSender.requestTimeout`          | Camcom request timeout                                                                                                                         | `1`     |
| `worker.camcomSender.requestRateLimit.calls`  | Camcom calls rate limit                                                                                                                        | `1000`  |
| `worker.camcomSender.requestRateLimit.period` | Camcom period rate limit                                                                                                                       | `60`    |
| `worker.camcomSender.requestRetries`          | Camcom request retries                                                                                                                         | `3`     |
| `worker.camcomSender.requestRetriesBackoff`   | request retries backoff                                                                                                                        | `1`     |
| `worker.camcomSender.sourceEnv`               | Environment name to send to CamCam (source_env field in request), ignored if empty.                                                            | `""`    |
| `worker.camcomSender.annotations`             | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`    |
| `worker.camcomSender.labels`                  | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`    |
| `worker.camcomSender.podAnnotations`          | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`    |
| `worker.camcomSender.podLabels`               | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`    |
| `worker.camcomSender.nodeSelector`            | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`    |
| `worker.camcomSender.tolerations`             | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`    |
| `worker.camcomSender.affinity`                | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`    |

### Citylens Predictions Saver worker's settings

| Name                                           | Description                                                                                                                                    | Value |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `worker.predictionsSaver.replicas`             | A replica count for the pod.                                                                                                                   | `1`   |
| `worker.predictionsSaver.revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`   |
| `worker.predictionsSaver.annotations`          | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`  |
| `worker.predictionsSaver.labels`               | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`  |
| `worker.predictionsSaver.podAnnotations`       | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`  |
| `worker.predictionsSaver.podLabels`            | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`  |
| `worker.predictionsSaver.nodeSelector`         | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`  |
| `worker.predictionsSaver.tolerations`          | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`  |
| `worker.predictionsSaver.affinity`             | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`  |

### Citylens Logs Saver worker's settings

| Name                                    | Description                                                                                                                                    | Value |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `worker.logsSaver.replicas`             | A replica count for the pod.                                                                                                                   | `1`   |
| `worker.logsSaver.revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`   |
| `worker.logsSaver.annotations`          | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`  |
| `worker.logsSaver.labels`               | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`  |
| `worker.logsSaver.podAnnotations`       | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`  |
| `worker.logsSaver.podLabels`            | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`  |
| `worker.logsSaver.nodeSelector`         | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`  |
| `worker.logsSaver.tolerations`          | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`  |
| `worker.logsSaver.affinity`             | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`  |

### Citylens Reporter Pro worker's settings (synchronization with Pro)

| Name                                      | Description                                                                                                                                    | Value        |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| `worker.reporterPro.enabled`              | If integration with Pro is enabled for the service.                                                                                            | `true`       |
| `worker.reporterPro.predictors`           | From what sources detections should be localized.                                                                                              | `["camcom"]` |
| `worker.reporterPro.trackTimeoutDays`     | Timeout in days for track to be considered being uploading.                                                                                    | `1`          |
| `worker.reporterPro.replicas`             | A replica count for the pod.                                                                                                                   | `1`          |
| `worker.reporterPro.revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`          |
| `worker.reporterPro.annotations`          | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`         |
| `worker.reporterPro.labels`               | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`         |
| `worker.reporterPro.podAnnotations`       | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`         |
| `worker.reporterPro.podLabels`            | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`         |
| `worker.reporterPro.nodeSelector`         | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`         |
| `worker.reporterPro.tolerations`          | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`         |
| `worker.reporterPro.affinity`             | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`         |

### Citylens Reporter Pro Tracks worker's settings (track status actualization, requires Reporter Pro)

| Name                                            | Description                                                                                                                                    | Value |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `worker.reporterProTracks.revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`   |
| `worker.reporterProTracks.annotations`          | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`  |
| `worker.reporterProTracks.labels`               | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`  |
| `worker.reporterProTracks.podAnnotations`       | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`  |
| `worker.reporterProTracks.podLabels`            | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`  |
| `worker.reporterProTracks.nodeSelector`         | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`  |
| `worker.reporterProTracks.tolerations`          | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`  |
| `worker.reporterProTracks.affinity`             | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`  |

### Citylens Track Metadata Saver worker's settings

| Name                                             | Description                                                                                                                                    | Value |
| ------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `worker.trackMetadataSaver.replicas`             | A replica count for the pod.                                                                                                                   | `1`   |
| `worker.trackMetadataSaver.revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`   |
| `worker.trackMetadataSaver.annotations`          | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`  |
| `worker.trackMetadataSaver.labels`               | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`  |
| `worker.trackMetadataSaver.podAnnotations`       | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`  |
| `worker.trackMetadataSaver.podLabels`            | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`  |
| `worker.trackMetadataSaver.nodeSelector`         | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`  |
| `worker.trackMetadataSaver.tolerations`          | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`  |
| `worker.trackMetadataSaver.affinity`             | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`  |

### Citylens Tracks Uploader worker's settings

| Name                                              | Description                                                                                                                                    | Value   |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `worker.tracksUploader.enabled`                   | If Tracks Uploader worker is enabled for the service.                                                                                          | `false` |
| `worker.tracksUploader.replicas`                  | A replica count for the pod.                                                                                                                   | `1`     |
| `worker.tracksUploader.revisionHistoryLimit`      | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`     |
| `worker.tracksUploader.api`                       | Destination API address citylens. Ex.: http(s)://citylens-api.host/                                                                            | `""`    |
| `worker.tracksUploader.source`                    | Source address citylens-web. Ex.: http(s)://citylens-web.host                                                                                  | `""`    |
| `worker.tracksUploader.verifySsl`                 | Set to `false` if tracksUploader.api or tracksUploader.source must be accessed via https without certificate validation **Required**           | `true`  |
| `worker.tracksUploader.reloadTrackTimeoutSeconds` | Track reload timeout, seconds.                                                                                                                 | `900`   |
| `worker.tracksUploader.annotations`               | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`    |
| `worker.tracksUploader.labels`                    | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`    |
| `worker.tracksUploader.podAnnotations`            | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`    |
| `worker.tracksUploader.podLabels`                 | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`    |
| `worker.tracksUploader.nodeSelector`              | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`    |
| `worker.tracksUploader.tolerations`               | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`    |
| `worker.tracksUploader.affinity`                  | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`    |

### Citylens Map Matcher worker's settings

| Name                                     | Description                                                                                                                                            | Value   |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------- |
| `worker.mapMatcher.enabled`              | If Map Matcher worker is enabled for the service.                                                                                                      | `false` |
| `worker.mapMatcher.replicas`             | A replica count for the pod.                                                                                                                           | `1`     |
| `worker.mapMatcher.revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).         | `3`     |
| `worker.mapMatcher.baseUrl`              | Map Matching API address. Ex.: http://navi-front.svc **Required**                                                                                      | `""`    |
| `worker.mapMatcher.key`                  | Map Matching API key. **Required**                                                                                                                     | `""`    |
| `worker.mapMatcher.interpolation`        | Set to `true` for compatibility with Map Matching API which requires gps points timestamps in seconds as integers (w/o millisecond precision support). | `true`  |
| `worker.mapMatcher.retries`              | Total number of retries in case of Map Matching API unavailability/errors.                                                                             | `3`     |
| `worker.mapMatcher.timeoutSeconds`       | Map Matching API timeout, seconds.                                                                                                                     | `30`    |
| `worker.mapMatcher.annotations`          | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                              | `{}`    |
| `worker.mapMatcher.labels`               | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                        | `{}`    |
| `worker.mapMatcher.podAnnotations`       | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                              | `{}`    |
| `worker.mapMatcher.podLabels`            | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                        | `{}`    |
| `worker.mapMatcher.nodeSelector`         | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                | `{}`    |
| `worker.mapMatcher.tolerations`          | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                  | `{}`    |
| `worker.mapMatcher.affinity`             | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                            | `{}`    |

### Citylens Detections Localizer worker's settings

| Name                                              | Description                                                                                                                                    | Value        |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| `worker.detectionsLocalizer.enabled`              | If Detections Localizer worker is enabled for the service.                                                                                     | `false`      |
| `worker.detectionsLocalizer.predictors`           | From what sources detections should be localized.                                                                                              | `["camcom"]` |
| `worker.detectionsLocalizer.revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`          |
| `worker.detectionsLocalizer.annotations`          | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`         |
| `worker.detectionsLocalizer.labels`               | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`         |
| `worker.detectionsLocalizer.podAnnotations`       | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`         |
| `worker.detectionsLocalizer.podLabels`            | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`         |
| `worker.detectionsLocalizer.nodeSelector`         | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`         |
| `worker.detectionsLocalizer.tolerations`          | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`         |
| `worker.detectionsLocalizer.affinity`             | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`         |

### Citylens Lifecycle Controller worker's settings (depends on Detections Localizer worker)

| Name                                                             | Description                                                                                                                                    | Value  |
| ---------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `worker.lifecycleController.scheduledLocalizationTimeoutMinutes` | Timeout in minutes after that track localization will be rescheduled if it was scheduled and not done.                                         | `1380` |
| `worker.lifecycleController.minTrackLocalizationIntervalMinutes` | Interval in minutes between scheduling track detections localization again.                                                                    | `10`   |
| `worker.lifecycleController.revisionHistoryLimit`                | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`    |
| `worker.lifecycleController.annotations`                         | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`   |
| `worker.lifecycleController.labels`                              | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`   |
| `worker.lifecycleController.podAnnotations`                      | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`   |
| `worker.lifecycleController.podLabels`                           | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`   |
| `worker.lifecycleController.nodeSelector`                        | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`   |
| `worker.lifecycleController.tolerations`                         | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`   |
| `worker.lifecycleController.affinity`                            | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`   |

### Citylens Dashboard batch events worker's settings

| Name                                   | Description                  | Value |
| -------------------------------------- | ---------------------------- | ----- |
| `worker.dashboardBatchEvents.replicas` | A replica count for the pod. | `1`   |

### Citylens Dashboard batch events worker's Image settings

| Name                                               | Description                                                                                                                                    | Value                              |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `worker.dashboardBatchEvents.image.repository`     | Repository.                                                                                                                                    | `2gis-on-premise/citylens-workers` |
| `worker.dashboardBatchEvents.image.tag`            | Tag.                                                                                                                                           | `1.17.5`                           |
| `worker.dashboardBatchEvents.image.pullPolicy`     | Pull Policy.                                                                                                                                   | `IfNotPresent`                     |
| `worker.dashboardBatchEvents.logLevel`             | Worker's log level.                                                                                                                            | `INFO`                             |
| `worker.dashboardBatchEvents.revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`                                |
| `worker.dashboardBatchEvents.annotations`          | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`                               |
| `worker.dashboardBatchEvents.labels`               | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`                               |
| `worker.dashboardBatchEvents.podAnnotations`       | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`                               |
| `worker.dashboardBatchEvents.podLabels`            | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`                               |
| `worker.dashboardBatchEvents.nodeSelector`         | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`                               |
| `worker.dashboardBatchEvents.tolerations`          | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`                               |
| `worker.dashboardBatchEvents.affinity`             | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`                               |

### Migration job settings

| Name                                   | Description                                                                                                             | Value                               |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `migrations.enabled`                   | If migrations needed.                                                                                                   | `true`                              |
| `migrations.image.repository`          | Repository.                                                                                                             | `2gis-on-premise/citylens-database` |
| `migrations.image.tag`                 | Tag.                                                                                                                    | `1.17.1`                            |
| `migrations.image.pullPolicy`          | Pull Policy                                                                                                             | `IfNotPresent`                      |
| `migrations.resources.requests.cpu`    | A CPU request.                                                                                                          | `100m`                              |
| `migrations.resources.requests.memory` | A memory request.                                                                                                       | `1Gi`                               |
| `migrations.resources.limits.cpu`      | A CPU limit.                                                                                                            | `200m`                              |
| `migrations.resources.limits.memory`   | A memory limit.                                                                                                         | `2Gi`                               |
| `migrations.nodeSelector`              | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector). | `{}`                                |

### Kafka settings

| Name                            | Description                                                                                                                               | Value            |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `kafka.bootstrapServer`         | A Kafka broker endpoint. **Required**                                                                                                     | `""`             |
| `kafka.username`                | A Kafka username for connection. **Required**                                                                                             | `""`             |
| `kafka.password`                | A Kafka password for connection. **Required**                                                                                             | `""`             |
| `kafka.securityProtocol`        | Protocol used to communicate with brokers. Currently supported: SASL_PLAINTEXT.                                                           | `SASL_PLAINTEXT` |
| `kafka.saslMechanism`           | Authentication mechanism. Valid values are: PLAIN, SCRAM-SHA-256, SCRAM-SHA-512.                                                          | `SCRAM-SHA-512`  |
| `kafka.produceTimeoutSeconds`   | Timeout for producer.                                                                                                                     | `5`              |
| `kafka.topics.frames`           | List of topics for Frames saver worker. **Required**                                                                                      | `""`             |
| `kafka.topics.tracks`           | List of topics for Tracks metadata worker. **Required**                                                                                   | `""`             |
| `kafka.topics.pro`              | Topic for frames synchronization with Pro (used by Reporter pro worker). **Required**                                                     | `""`             |
| `kafka.topics.proObjects`       | Topic for localized detections synchronization with Pro (used by Reporter pro worker, requires Detections Localizer worker). **Required** | `""`             |
| `kafka.topics.proDrivers`       | Topic for drivers tracks synchronization with Pro (used by Reporter pro worker). **Required**                                             | `""`             |
| `kafka.topics.uploader`         | Topic for Uploader worker. **Required**                                                                                                   | `""`             |
| `kafka.topics.logs`             | Topic for citylens mobile app logs, uploaded via citylens-api. **Required**                                                               | `""`             |
| `kafka.topics.framesLifecycle`  | Topic for frames lifecycle events. **Required**                                                                                           | `""`             |
| `kafka.topics.objectsLifecycle` | Topic for objects lifecycle events. **Required**                                                                                          | `""`             |
| `kafka.topics.tracksLifecycle`  | Topic for tracks lifecycle events. **Required**                                                                                           | `""`             |
| `kafka.topics.predictions`      | Topic for predictions events from detectors. **Required**                                                                                 | `""`             |
| `kafka.consumerGroups.prefix`   | Kafka topics prefix. **Required**                                                                                                         | `""`             |

### S3 settings

| Name                  | Description                                                         | Value   |
| --------------------- | ------------------------------------------------------------------- | ------- |
| `s3.verifySsl`        | Verify SSL certificate when connecting to s3.endpoint.              | `true`  |
| `s3.endpoint`         | S3 endpoint. Format: `host:port` or `url`. **Required**             | `""`    |
| `s3.accessKey`        | S3 access key for accessing the bucket. **Required**                | `""`    |
| `s3.secretAccessKey`  | S3 secret key for accessing the bucket. **Required**                | `""`    |
| `s3.bucketPrefix`     | S3 bucket name prefix for the frames buckets. **Required**          | `""`    |
| `s3.logsBucketPrefix` | S3 bucket name prefix for the mobile app logs buckets. **Required** | `""`    |
| `s3.region`           | S3 region.                                                          | `""`    |
| `s3.setPublicReadACL` | Set "public-read" ACL on buckets and objects.                       | `false` |

### postgres **Database settings**

| Name                | Description                                      | Value  |
| ------------------- | ------------------------------------------------ | ------ |
| `postgres.host`     | PostgreSQL rw hostname or IP. **Required**       | `""`   |
| `postgres.port`     | PostgreSQL port. **Required**                    | `5432` |
| `postgres.database` | PostgreSQL database name. **Required**           | `""`   |
| `postgres.username` | PostgreSQL username with rw access. **Required** | `""`   |
| `postgres.password` | PostgreSQL password. **Required**                | `""`   |

### Map settings

| Name                     | Description                                                | Value |
| ------------------------ | ---------------------------------------------------------- | ----- |
| `map.tileserverUrl`      | URL template for tileserver. Ex.: `http://tileserver.host` | `""`  |
| `map.mapgl.host`         | Hostname of mapgl server. **Required**                     | `""`  |
| `map.mapgl.key`          | Key of mapgl server. **Required**                          | `""`  |
| `map.projects[0].name`   | Name of project.                                           | `""`  |
| `map.projects[0].coords` | Coordinates of area.                                       | `[]`  |
| `map.initialProject`     | Default project shown on Map.                              | `""`  |

### Custom settings

| Name              | Description                                | Value                                         |
| ----------------- | ------------------------------------------ | --------------------------------------------- |
| `dashboardDomain` | Link to Citylens web address. **Required** | `""`                                          |
| `locale`          | Locale language (en by default).           | `en`                                          |
| `headerLinks`     | List of links for navbar.                  | `["drivers","tracks","interest_zones","map"]` |

### PRO integration (only when Pro reporter enabled)

| Name                 | Description                                                                                           | Value  |
| -------------------- | ----------------------------------------------------------------------------------------------------- | ------ |
| `pro.baseUrl`        | PRO API URL. Ex: http(s)://pro-api.svc                                                                | `""`   |
| `pro.key`            | PRO API auth token                                                                                    | `""`   |
| `pro.verifySsl`      | Set to `false` if pro.baseUrl must be accessed via https without certificate validation. **Required** | `true` |
| `pro.framesAssetId`  | PRO Frames asset id (used for filters actualization). Ex: your_frames_asset_name                      | `""`   |
| `pro.objectsAssetId` | PRO Objects asset id (used for filters actualization). Ex: your_objects_asset_name                    | `""`   |

### **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container.                                                                          | `""`  |

### Citylens routes services settings

| Name                                           | Description                                                                                                                                                                                              | Value           |
| ---------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `routes.imagePullSecrets`                      | Kubernetes image pull secrets.                                                                                                                                                                           | `[]`            |
| `routes.terminationGracePeriodSeconds`         | Kubernetes [termination grace period](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/). Should be at least 300 seconds                                                         | `60`            |
| `routes.migration.enabled`                     | If migrations needed.                                                                                                                                                                                    | `true`          |
| `routes`                                       | **Strategy**                                                                                                                                                                                             |                 |
| `routes.strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `routes.strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `routes.strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |
| `routes`                                       | **Postgres**                                                                                                                                                                                             |                 |
| `routes.postgres.database`                     | PostgreSQL database name. **Required**                                                                                                                                                                   | `""`            |
| `routes.postgres.timeout`                      | The time to wait (in seconds) while trying to establish a connection before terminating the attempt and generating an error.                                                                             | `15`            |
| `routes.postgres.commandTimeout`               | The time to wait (in seconds) while trying to execute a command before terminating the attempt and generating an error.                                                                                  | `30`            |
| `routes.postgres.maxPoolSize`                  | The maximum connection pool size.                                                                                                                                                                        | `30`            |
| `routes.postgres.pooling`                      | Whether connection pooling should be used.                                                                                                                                                               | `false`         |
| `routes`                                       | **Hangfire**                                                                                                                                                                                             |                 |
| `routes.hangfire.postgres.database`            | PostgreSQL database name. **Required**                                                                                                                                                                   | `""`            |
| `routes.hangfire.postgres.timeout`             | The time to wait (in seconds) while trying to establish a connection before terminating the attempt and generating an error.                                                                             | `15`            |
| `routes.hangfire.postgres.commandTimeout`      | The time to wait (in seconds) while trying to execute a command before terminating the attempt and generating an error.                                                                                  | `30`            |
| `routes.hangfire.postgres.maxPoolSize`         | The maximum connection pool size.                                                                                                                                                                        | `30`            |
| `routes.hangfire.postgres.pooling`             | Whether connection pooling should be used.                                                                                                                                                               | `false`         |

### Citylens routes API


### Image settings

| Name                          | Description  | Value                                 |
| ----------------------------- | ------------ | ------------------------------------- |
| `routes.api.image.repository` | Repository.  | `2gis-on-premise/citylens-routes-api` |
| `routes.api.image.tag`        | Tag.         | `1.0.15`                              |
| `routes.api.image.pullPolicy` | Pull Policy. | `IfNotPresent`                        |

### Resources settings

| Name                                   | Description                                                                                                                                    | Value   |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `routes.api.replicaCount`              | A replica count for the pod.                                                                                                                   | `1`     |
| `routes.api.revisionHistoryLimit`      | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`     |
| `routes.api.resources.requests.cpu`    | A CPU request.                                                                                                                                 | `400m`  |
| `routes.api.resources.requests.memory` | A memory request.                                                                                                                              | `256M`  |
| `routes.api.resources.limits.cpu`      | A CPU limit.                                                                                                                                   | `1`     |
| `routes.api.resources.limits.memory`   | A memory limit.                                                                                                                                | `1024M` |

### Service settings

| Name                             | Description                                                                                                                    | Value       |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `routes.api.service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `routes.api.service.port`        | Service port.                                                                                                                  | `80`        |
| `routes.api.service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `routes.api.service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                            | Description                                                                                                           | Value                             |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `routes.api.ingress.enabled`                    | If Ingress is enabled for the service.                                                                                | `false`                           |
| `routes.api.ingress.className`                  | Resource that contains additional configuration including the name of the controller that should implement the class. | `""`                              |
| `routes.api.ingress.annotations`                | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).             | `{}`                              |
| `routes.api.ingress.hosts[0].host`              | Hostname for the Ingress service. Ex.: 'citylens.api'.                                                                | `citylens-routes-api.example.com` |
| `routes.api.ingress.hosts[0].paths[0].path`     | Endpoint of host.                                                                                                     | `/`                               |
| `routes.api.ingress.hosts[0].paths[0].pathType` | Path type of endpoint.                                                                                                | `Prefix`                          |
| `routes.api.ingress.tls`                        | Tls settings for https.                                                                                               | `[]`                              |

### Kubernetes [pod disruption budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                            | Description                                          | Value  |
| ------------------------------- | ---------------------------------------------------- | ------ |
| `routes.api.pdb.enabled`        | If PDB is enabled for the service.                   | `true` |
| `routes.api.pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`   |
| `routes.api.pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`    |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                                 | Description                                                                                                                                                          | Value   |
| ---------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `routes.api.hpa.enabled`                             | If HPA is enabled for the service.                                                                                                                                   | `false` |
| `routes.api.hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`     |
| `routes.api.hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `1`     |
| `routes.api.hpa.scaleDownStabilizationWindowSeconds` | Scale-down window.                                                                                                                                                   | `""`    |
| `routes.api.hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window.                                                                                                                                                     | `""`    |
| `routes.api.hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `50`    |
| `routes.api.hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`    |

### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                               | Description                                                                                                  | Value   |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------ | ------- |
| `routes.api.vpa.enabled`           | If VPA is enabled for the service.                                                                           | `false` |
| `routes.api.vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start). | `Auto`  |
| `routes.api.vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down.                                   | `100m`  |
| `routes.api.vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down.                                         | `128Mi` |
| `routes.api.vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up.                                     | `1`     |
| `routes.api.vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up.                                           | `512Mi` |

### Metadata settings

| Name                        | Description                                                                                                                 | Value         |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `routes.api.annotations`    | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`          |
| `routes.api.labels`         | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`          |
| `routes.api.podAnnotations` | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`          |
| `routes.api.podLabels`      | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`          |
| `routes.api.nodeSelector`   | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).     | `{}`          |
| `routes.api.tolerations`    | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.       | `[]`          |
| `routes.api.affinity`       | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings. | `{}`          |
| `routes.api.tempPath`       | Path to directory used for temp data                                                                                        | `/tmp`        |
| `routes.api.logging`        | Routes **Logging** settings                                                                                                 |               |
| `routes.api.logging.level`  | Log message level. verbose, debug, information, warning, error, fatal.                                                      | `information` |

### Citylens routes Worker


### Image settings

| Name                             | Description  | Value                                     |
| -------------------------------- | ------------ | ----------------------------------------- |
| `routes.worker.image.repository` | Repository.  | `2gis-on-premise/citylens-worker-service` |
| `routes.worker.image.tag`        | Tag.         | `1.0.15`                                  |
| `routes.worker.image.pullPolicy` | Pull Policy. | `IfNotPresent`                            |

### Resources settings

| Name                                      | Description                                                                                                                                    | Value   |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `routes.worker.replicaCount`              | A replica count for the pod.                                                                                                                   | `1`     |
| `routes.worker.revisionHistoryLimit`      | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`     |
| `routes.worker.resources.requests.cpu`    | A CPU request.                                                                                                                                 | `400m`  |
| `routes.worker.resources.requests.memory` | A memory request.                                                                                                                              | `256M`  |
| `routes.worker.resources.limits.cpu`      | A CPU limit.                                                                                                                                   | `1`     |
| `routes.worker.resources.limits.memory`   | A memory limit.                                                                                                                                | `1024M` |

### Kubernetes [pod disruption budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                               | Description                                          | Value  |
| ---------------------------------- | ---------------------------------------------------- | ------ |
| `routes.worker.pdb.enabled`        | If PDB is enabled for the service.                   | `true` |
| `routes.worker.pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`   |
| `routes.worker.pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`    |

### Metadata settings

| Name                           | Description                                                                                                                 | Value         |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `routes.worker.annotations`    | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`          |
| `routes.worker.labels`         | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`          |
| `routes.worker.podAnnotations` | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`          |
| `routes.worker.podLabels`      | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`          |
| `routes.worker.nodeSelector`   | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).     | `{}`          |
| `routes.worker.tolerations`    | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.       | `[]`          |
| `routes.worker.affinity`       | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings. | `{}`          |
| `routes.worker.tempPath`       | Path to directory used for temp data                                                                                        | `/tmp`        |
| `routes.worker.logging`        | Routes **Logging** settings                                                                                                 |               |
| `routes.worker.logging.level`  | Log message level. verbose, debug, information, warning, error, fatal.                                                      | `information` |

### Kafka Bus configuration settings. Based on Kafka values

| Name                                                           | Description                                                                                                                                                  | Value           |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------- |
| `routes.worker.busConfig`                                      | Bus configuration                                                                                                                                            |                 |
| `routes.worker.busConfig.securityInformation`                  | SecurityInformation for the bus configuration                                                                                                                |                 |
| `routes.worker.busConfig.securityInformation.saslMechanism`    | Authentication mechanism when security_protocol is configured. Valid values are: Gssapi, Plain, ScramSha256, ScramSha512, OAuthBearer. Default: ScramSha512. | `ScramSha512`   |
| `routes.worker.busConfig.securityInformation.securityProtocol` | Valid values are: Plaintext, Ssl, SaslPlaintext, SaslSsl. Default: SaslPlaintext.                                                                            | `SaslPlaintext` |
| `routes.worker.busConfig.consumers`                            | Consumers for the bus configuration.                                                                                                                         |                 |
| `routes.worker.busConfig.consumers.appEvents`                  | App events for the consumers.                                                                                                                                |                 |
| `routes.worker.busConfig.consumers.appEvents.groupId`          | The group ID for the app events. **Required**                                                                                                                | `""`            |
| `routes.worker.busConfig.consumers.appEvents.bufferSize`       | The buffer size for the app events.                                                                                                                          | `100`           |
| `routes.worker.busConfig.consumers.appEvents.workersCount`     | The workers count for the app events.                                                                                                                        | `10`            |

### Citylens routes Clients


### Navi integration

| Name              | Description                                                  | Value |
| ----------------- | ------------------------------------------------------------ | ----- |
| `routes.navi.url` | Navi gateway url (used for getting navigation). **Required** | `""`  |
| `routes.navi.key` | Navi Api Key.                                                | `""`  |

### Pro integration

| Name                            | Description                                              | Value |
| ------------------------------- | -------------------------------------------------------- | ----- |
| `routes.pro.authorizationToken` | Pro Authorization Token (need for creating assets).      | `""`  |
| `routes.pro.mainTerritoryId`    | Available territory identity (need for creating assets). | `""`  |

### Keys integration

| Name              | Description                                                                  | Value |
| ----------------- | ---------------------------------------------------------------------------- | ----- |
| `routes.keys.url` | API Keys endpoint url, ex: http://keys-api.svc (used for getting oidc auth). | `""`  |
