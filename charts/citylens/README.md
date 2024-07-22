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
| `api.image.tag`        | Tag.         | `1.10.0`                       |
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
| `api.ingress.hosts[0].host`                                           | Hostname for the Ingress service. Ex.: 'citylens.api'.                                                                | `citylens-api.host`                                   |
| `api.ingress.hosts[0].paths[0].path`                                  | Endpoint of host.                                                                                                     | `/`                                                   |
| `api.ingress.hosts[0].paths[0].pathType`                              | Path type of endpoint.                                                                                                | `Prefix`                                              |
| `api.ingress.tls`                                                     | Tls settings for https.                                                                                               | `[]`                                                  |

### Auth settings for authentication

| Name                     | Description                                                                                                                                                                                                   | Value  |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `api.auth.enabled`       | If authentication is needed.                                                                                                                                                                                  | `true` |
| `api.auth.authServerUrl` | API URL of authentication service, OIDC-compatibility expected. Ex.: `http(s)://keycloak.ingress.host/`. **Required**                                                                                         | `""`   |
| `api.auth.realm`         | Authentication realm. Used for constructing openid-configuration endpoint: `/realms/realm/.well-known/openid-configuration` if realm defined, `/.well-known/openid-configuration` othervise. Ex: CityLens_app | `""`   |
| `api.auth.verifySsl`     | Enable\Disable SSL check.                                                                                                                                                                                     | `true` |

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
| `web.image.tag`        | Tag.         | `1.10.0`                       |
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
| `web.ingress.hosts[0].host`                                           | Hostname for the Ingress service. Ex.: 'citylens.web'.                                                                | `citylens-web.host`                                   |
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

| Name                 | Description                                            | Value          |
| -------------------- | ------------------------------------------------------ | -------------- |
| `web.logLevel`       | Log level.                                             | `WARNING`      |
| `web.metricsAppName` | Value for service prometheus metrics label "app_name". | `citylens-web` |

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

| Name                                      | Description                                                                                                                                    | Value |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `worker.reporterPro.replicas`             | A replica count for the pod.                                                                                                                   | `1`   |
| `worker.reporterPro.revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`   |
| `worker.reporterPro.annotations`          | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`  |
| `worker.reporterPro.labels`               | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`  |
| `worker.reporterPro.podAnnotations`       | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`  |
| `worker.reporterPro.podLabels`            | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`  |
| `worker.reporterPro.nodeSelector`         | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`  |
| `worker.reporterPro.tolerations`          | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`  |
| `worker.reporterPro.affinity`             | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`  |

### Citylens Reporter Pro Tracks worker's settings (track status actualization)

| Name                                            | Description                                                                                                                                    | Value  |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `worker.reporterProTracks.enabled`              | Deploy worker or not.                                                                                                                          | `true` |
| `worker.reporterProTracks.revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`    |
| `worker.reporterProTracks.annotations`          | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`   |
| `worker.reporterProTracks.labels`               | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`   |
| `worker.reporterProTracks.podAnnotations`       | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`   |
| `worker.reporterProTracks.podLabels`            | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`   |
| `worker.reporterProTracks.nodeSelector`         | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                        | `{}`   |
| `worker.reporterProTracks.tolerations`          | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                          | `{}`   |
| `worker.reporterProTracks.affinity`             | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                    | `{}`   |

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

### Citylens Dashboard batch events worker's settings

| Name                                   | Description                  | Value |
| -------------------------------------- | ---------------------------- | ----- |
| `worker.dashboardBatchEvents.replicas` | A replica count for the pod. | `1`   |

### Citylens Dashboard batch events worker's Image settings

| Name                                               | Description                                                                                                                                    | Value                              |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `worker.dashboardBatchEvents.image.repository`     | Repository.                                                                                                                                    | `2gis-on-premise/citylens-workers` |
| `worker.dashboardBatchEvents.image.tag`            | Tag.                                                                                                                                           | `1.10.0`                           |
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
| `migrations.image.tag`                 | Tag.                                                                                                                    | `1.10.0`                            |
| `migrations.image.pullPolicy`          | Pull Policy                                                                                                             | `IfNotPresent`                      |
| `migrations.resources.requests.cpu`    | A CPU request.                                                                                                          | `100m`                              |
| `migrations.resources.requests.memory` | A memory request.                                                                                                       | `1Gi`                               |
| `migrations.resources.limits.cpu`      | A CPU limit.                                                                                                            | `200m`                              |
| `migrations.resources.limits.memory`   | A memory limit.                                                                                                         | `2Gi`                               |
| `migrations.nodeSelector`              | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector). | `{}`                                |

### Kafka settings

| Name                           | Description                                                                                   | Value |
| ------------------------------ | --------------------------------------------------------------------------------------------- | ----- |
| `kafka.bootstrapServer`        | A Kafka broker endpoint. **Required**                                                         | `""`  |
| `kafka.username`               | A Kafka username for connection. **Required**                                                 | `""`  |
| `kafka.password`               | A Kafka password for connection. **Required**                                                 | `""`  |
| `kafka.topics.frames`          | List of topics for Frames saver worker. **Required**                                          | `""`  |
| `kafka.topics.tracks`          | List of topics for Tracks metadata worker. **Required**                                       | `""`  |
| `kafka.topics.pro`             | Topic for frames synchronization with Pro (used by Reporter pro worker). **Required**         | `""`  |
| `kafka.topics.proDrivers`      | Topic for drivers tracks synchronization with Pro (used by Reporter pro worker). **Required** | `""`  |
| `kafka.topics.uploader`        | Topic for Uploader worker. **Required**                                                       | `""`  |
| `kafka.topics.logs`            | Topic for citylens mobile app logs, uploaded via citylens-api. **Required**                   | `""`  |
| `kafka.topics.framesLifecycle` | Topic for frames lifecycle events. **Required**                                               | `""`  |
| `kafka.topics.tracksLifecycle` | Topic for tracks lifecycle events. **Required**                                               | `""`  |
| `kafka.topics.predictions`     | Topic for predictions events from detectors. **Required**                                     | `""`  |
| `kafka.consumerGroups.prefix`  | Kafka topics prefix. **Required**                                                             | `""`  |

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

| Name                            | Description                                                                                                      | Value                                         |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------- | --------------------------------------------- |
| `dashboardDomain`               | Link to Citylens web address. **Required**                                                                       | `""`                                          |
| `locale`                        | Locale language (en by default).                                                                                 | `en`                                          |
| `headerLinks`                   | List of links for navbar.                                                                                        | `["drivers","tracks","interest_zones","map"]` |
| `reporters[0].name`             | Reporter name.                                                                                                   | `pro`                                         |
| `reporters[0].predictors`       | Predictor used by reporter.                                                                                      | `["camcom"]`                                  |
| `reporters[0].trackTimeoutDays` | Time in days to wait for track completion and receiving frames prediction before marking as not synced with Pro. | `1`                                           |

### PRO integration (only when Pro reporter enabled)

| Name                | Description                                                                                           | Value  |
| ------------------- | ----------------------------------------------------------------------------------------------------- | ------ |
| `pro.baseUrl`       | PRO API URL (used for filters actualization). Ex: http(s)://pro-api.svc/your_asset_name/filters       | `""`   |
| `pro.key`           | PRO API auth token                                                                                    | `""`   |
| `pro.verifySsl`     | Set to `false` if pro.baseUrl must be accessed via https without certificate validation. **Required** | `true` |
| `pro.framesAssetId` | PRO frames asset id (used for filters actualization). Ex: your_asset_name                             | `""`   |

### **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container.                                                                          | `""`  |
