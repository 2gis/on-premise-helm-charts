# 2GIS Catalog API service

Use this Helm chart to deploy Catalog API service, which is a part of 2GIS's [On-Premise Search services](https://docs.2gis.com/en/on-premise/search).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/search) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-catalog.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |


### Common settings

| Name               | Description                                                                                                                                          | Value |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `nodeSelector`     | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                  | `{}`  |
| `affinity`         | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                          | `{}`  |
| `tolerations`      | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                    | `[]`  |
| `podAnnotations`   | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)                                         | `{}`  |
| `podLabels`        | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                  | `{}`  |
| `imagePullSecrets` | Kubernetes secrets for [pulling the image from the registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/). | `[]`  |


### Kubernetes [pod disruption budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                                 | Description                                          | Value   |
| ------------------------------------ | ---------------------------------------------------- | ------- |
| `podDisruptionBudget.enabled`        | If PDB is enabled for the service.                   | `false` |
| `podDisruptionBudget.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`     |


### API settings

| Name           | Description                     | Value |
| -------------- | ------------------------------- | ----- |
| `api.replicas` | Number of replicas of API pods. | `1`   |


### Deployment settings

| Name                   | Description | Value                     |
| ---------------------- | ----------- | ------------------------- |
| `api.image.repository` | Repository  | `2gis-on-premise/catalog` |
| `api.image.tag`        | Tag         | `3.567.0`                 |
| `api.image.pullPolicy` | Pull Policy | `IfNotPresent`            |


### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                     | Description                                                                                                                                                    | Value   |
| ---------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `api.hpa.enabled`                        | If HPA is enabled for the service.                                                                                                                             | `false` |
| `api.hpa.minReplicas`                    | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                 | `1`     |
| `api.hpa.maxReplicas`                    | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                   | `2`     |
| `api.hpa.targetCPUUtilizationPercentage` | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used. | `80`    |


### Limits

| Name                            | Description       | Value    |
| ------------------------------- | ----------------- | -------- |
| `api.resources.requests.cpu`    | A CPU request.    | `2`      |
| `api.resources.requests.memory` | A memory request. | `6000Mi` |
| `api.resources.limits.cpu`      | A CPU limit.      | `4`      |
| `api.resources.limits.memory`   | A memory limit.   | `6500Mi` |


### Service settings

| Name                      | Description                                                                                                                    | Value       |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `api.service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)               | `{}`        |
| `api.service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `api.service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `api.service.port`        | Service port.                                                                                                                  | `80`        |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                            | Description                                 | Value                   |
| ------------------------------- | ------------------------------------------- | ----------------------- |
| `api.ingress.enabled`           | If Ingress is enabled for the service.      | `true`                  |
| `api.ingress.hosts[0].host`     | Hostname for the Ingress service.           | `mapgl-js-api.host`     |
| `api.ingress.tls[0].hosts`      | TLS hosts for the Ingress service.          | `["mapgl-js-api.host"]` |
| `api.ingress.tls[0].secretName` | Secret name to use for the Ingress service. | `mapgl-js-api`          |


### Database settings

| Name          | Description               | Value           |
| ------------- | ------------------------- | --------------- |
| `db.host`     | PostgreSQL host.          | `postgres.host` |
| `db.port`     | PostgreSQL port.          | `5432`          |
| `db.name`     | PostgreSQL database name. | `catalog`       |
| `db.username` | PostgreSQL username.      | `postgres`      |
| `db.password` | PostgreSQL password.      | `secret`        |


### Search

| Name         | Description                                                                                                | Value                    |
| ------------ | ---------------------------------------------------------------------------------------------------------- | ------------------------ |
| `search.url` | URL of the Search service. This URL should be accessible from all the pods within your Kubernetes cluster. | `http://search-api.host` |


### Keys

| Name                          | Description                                                                                              | Value                   |
| ----------------------------- | -------------------------------------------------------------------------------------------------------- | ----------------------- |
| `keys.endpoint`               | URL of the Keys service. This URL should be accessible from all the pods within your Kubernetes cluster. | `https://keys-api.host` |
| `keys.requestTimeout`         | Timeout for requests to the Keys API.                                                                    | `5s`                    |
| `keys.serviceKeys.places`     | Places API key (if available).                                                                           | `""`                    |
| `keys.serviceKeys.geocoder`   | Geocoder API key (if available).                                                                         | `""`                    |
| `keys.serviceKeys.suggest`    | Suggest API key (if available).                                                                          | `""`                    |
| `keys.serviceKeys.categories` | Categories API key (if available).                                                                       | `""`                    |
| `keys.serviceKeys.regions`    | Regions API key (if available).                                                                          | `""`                    |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
