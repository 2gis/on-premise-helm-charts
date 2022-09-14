# Proxy Traffic Jams
# Traffic Proxy API

Use this Helm chart to deploy Traffic Proxy API service, which is a part of 2GIS's [On-Premise Traffic Proxy services](https://docs.2gis.com/en/on-premise/traffic-proxy).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/traffic-proxy) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-traffic-proxy.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |


### Common settings

| Name               | Description                                                                                                                 | Value |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `replicaCount`     | A replica count for the pod.                                                                                                | `1`   |
| `imagePullSecrets` | Kubernetes image pull secrets.                                                                                              | `[]`  |
| `nameOverride`     | Base name to use in all the Kubernetes entities deployed by this chart.                                                     | `""`  |
| `fullnameOverride` | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                 | `""`  |
| `podAnnotations`   | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`  |
| `podLabels`        | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                         | `{}`  |
| `nodeSelector`     | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).         | `{}`  |
| `affinity`         | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). | `{}`  |
| `tolerations`      | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.           | `[]`  |


### Proxy server settings

| Name                  | Description                                        | Value                            |
| --------------------- | -------------------------------------------------- | -------------------------------- |
| `proxy.host`          | URL for the proxy server to serve.                 | `https://traffic-proxy-api.host` |
| `proxy.listen`        | Port for the proxy server to listen.               | `8080`                           |
| `proxy.cache.enabled` | If caching should be enabled for the proxy server. | `true`                           |
| `proxy.cache.age`     | Cache vailidity period.                            | `1m`                             |
| `proxy.cache.size`    | Maximum cache size.                                | `32m`                            |


### Deployment settings

| Name               | Description | Value                   |
| ------------------ | ----------- | ----------------------- |
| `image.repository` | Repository  | `2gis-on-premise/nginx` |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`          |
| `image.tag`        | Tag         | `1.21.6`                |


### Strategy settings

| Name                                    | Description                                                                                                                                                                                              | Value           |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |


### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | Service port.                                                                                                                  | `80`        |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                    | Description                            | Value                    |
| ----------------------- | -------------------------------------- | ------------------------ |
| `ingress.enabled`       | If Ingress is enabled for the service. | `false`                  |
| `ingress.hosts[0].host` | Hostname for the Ingress service.      | `traffic-proxy-api.host` |


### Limits

| Name                        | Description       | Value   |
| --------------------------- | ----------------- | ------- |
| `resources.requests.cpu`    | A CPU request.    | `10m`   |
| `resources.requests.memory` | A memory request. | `32Mi`  |
| `resources.limits.cpu`      | A CPU limit.      | `500m`  |
| `resources.limits.memory`   | A memory limit.   | `256Mi` |


### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                          | Value  |
| -------------------- | ---------------------------------------------------- | ------ |
| `pdb.enabled`        | If PDB is enabled for the service.                   | `true` |
| `pdb.minAvailable`   | How many pods must be available after the eviction.  | `1`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`    |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |

