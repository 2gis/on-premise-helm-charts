# 2GIS Catalog API (Helm chart)

This repository contains a [Helm chart](https://helm.sh/docs/topics/charts/) for deploying the Catalog API service. This service is part of 2GIS On-Premise services, which allow you to deploy [2GIS products](https://dev.2gis.com/) on your own sites.

For more information on Catalog API, see the [service documentation](https://docs.2gis.com/en/on-premise/search).

To learn more about 2GIS On-Premise services, visit [docs.2gis.com](https://docs.2gis.com/en/on-premise/overview).

## Installing

Before installing Catalog API, make sure that you have a running PostgreSQL instance and a running [Search API](https://docs.2gis.com/en/on-premise/search) service.

To install the service create a YAML file that will contain:

- Registry URL of the service's Docker image
- PostgreSQL access parameters
- Search API URL
- API Keys service credentials

```yaml
# Docker image
dgctlDockerRegistry: 'your-docker-hub-registry'

# PostgreSQL access
db:
  host: localhost
  port: 5432
  name: catalog
  username: postgres
  password: secret

# Sapphire API
search:
  url: http://localhost:80

# API Keys service
keys:
  endpoint: https://keys-api.host
  serviceKeys:
    places: ""  # set if available in API Keys service
    geocoder: ""  # set if available in API Keys service
    suggest: ""  # set if available in API Keys service
    categories: ""  # set if available in API Keys service
    regions: ""  # set if available in API Keys service
```

Then, call the `helm install` command and specify the name of the created file:

```shell
helm repo add 2gis-on-premise https://2gis.github.io/on-premise-helm-charts
helm install catalog 2gis-on-premise/catalog-api -f values.yaml
```

## Updating

To update the service after changing the settings or after updating the Docker image, call the `helm upgrade` command:

```bash
helm upgrade catalog 2gis-on-premise/catalog-api -f values.yaml
```

## Values

### Common settings

| Name               | Description                                                                                                                                          | Value |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `nodeSelector`     | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                  | `{}`  |
| `affinity`         | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                          | `{}`  |
| `tolerations`      | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                    | `[]`  |
| `podAnnotations`   | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)                                         | `{}`  |
| `podLabels`        | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                  | `{}`  |
| `imagePullSecrets` | Kubernetes secrets for [pulling the image from the registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/). | `[]`  |


### Kubernetes [pod diruption budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

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
| `api.service.port`        | Tiles API service port.                                                                                                        | `80`        |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                  | Description                            | Value   |
| --------------------- | -------------------------------------- | ------- |
| `api.ingress.enabled` | If Ingress is enabled for the service. | `false` |


### Database settings

| Name          | Description               | Value       |
| ------------- | ------------------------- | ----------- |
| `db.host`     | PostgreSQL host.          | `localhost` |
| `db.port`     | PostgreSQL port.          | `5432`      |
| `db.name`     | PostgreSQL database name. | `catalog`   |
| `db.username` | PostgreSQL username.      | `postgres`  |
| `db.password` | PostgreSQL password.      | `secret`    |


### Search

| Name         | Description                                                                                                | Value                 |
| ------------ | ---------------------------------------------------------------------------------------------------------- | --------------------- |
| `search.url` | URL of the Search service. This URL should be accessible from all the pods within your Kubernetes cluster. | `http://localhost:80` |


### Keys dsxsxsxs

| Name                          | Description                                                                                              | Value                   |
| ----------------------------- | -------------------------------------------------------------------------------------------------------- | ----------------------- |
| `keys.endpoint`               | URL of the Keys service. This URL should be accessible from all the pods within your Kubernetes cluster. | `https://keys-api.host` |
| `keys.requestTimeout`         | Timeout, after which                                                                                     | `5s`                    |
| `keys.serviceKeys.places`     | Places API key (if available).                                                                           | `""`                    |
| `keys.serviceKeys.geocoder`   | Geocoder API key (if available).                                                                         | `""`                    |
| `keys.serviceKeys.suggest`    | Suggest API key (if available).                                                                          | `""`                    |
| `keys.serviceKeys.categories` | Categories API key (if available).                                                                       | `""`                    |
| `keys.serviceKeys.regions`    | Regions API key (if available).                                                                          | `""`                    |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
