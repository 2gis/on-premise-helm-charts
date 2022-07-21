# Search API (Helm chart)

## Values

### Common settings

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`.                                     | `""`  |
| `podAnnotations`      | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`  |
| `podLabels`           | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                         | `{}`  |
| `replicaCount`        | A replica count for the pod.                                                                                                | `1`   |
| `nodeSelector`        | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).         | `{}`  |
| `affinity`            | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). | `{}`  |
| `tolerations`         | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.           | `[]`  |
| `redeploy_label`      | If this label is changed since the last deployment, the whole chart will be redeployed.                                     | `""`  |


### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                              | Value |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`.                                                                                                                                                                                                                        | `""`  |
| `dgctlStorage.bucket`    | S3 bucket name.                                                                                                                                                                                                                                          | `""`  |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket.                                                                                                                                                                                                                  | `""`  |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket.                                                                                                                                                                                                                  | `""`  |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json`.<br> This file contains the description of pieces of data that the service requires to operate. | `""`  |


### Deployment settings

| Name                   | Description | Value                        |
| ---------------------- | ----------- | ---------------------------- |
| `api.image.repository` | Repository  | `2gis-on-premise/search-api` |
| `api.image.tag`        | Tag         | `7.25.0`                     |
| `api.image.pullPolicy` | Pull Policy | `IfNotPresent`               |


### API settings

| Name            | Description                                   | Value   |
| --------------- | --------------------------------------------- | ------- |
| `api.resources` | API container resources.                      | `{}`    |
| `api.data_dir`  | Path to the directory storing search indexes. | `/data` |
| `api.fcgi_port` | TCP port of the Search API.                   | `9090`  |
| `api.logLevel`  | Log level.                                    | `Info`  |
| `api.logFormat` | Log format: `json` or `plaintext`.            | `json`  |
| `api.configOpt` | Additional options (for debugging purposes).  | `[]`    |


### NGINX settings

| Name                     | Description                                            | Value                          |
| ------------------------ | ------------------------------------------------------ | ------------------------------ |
| `nginx.image.repository` | Docker Repository.                                     | `2gis-on-premise/search-nginx` |
| `nginx.image.tag`        | Docker image tag.                                      | `1.21.6`                       |
| `nginx.image.pullPolicy` | Kubernetes pull policy for the service's Docker image. | `IfNotPresent`                 |
| `nginx.resources`        | NGINX container resources.                             | `{}`                           |
| `nginx.http_port`        | HTTP port on which NGINX will be listening.            | `8080`                         |


### Strategy settings

| Name                                    | Description                                                                                                                                                                          | Value           |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------- |
| `strategy.type`                         |                                                                                                                                                                                      | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.                                                           | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process. | `1`             |


### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | Tiles API service port.                                                                                                        | `80`        |


### Kubernetes [pod diruption budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                                 | Description                                          | Value  |
| ------------------------------------ | ---------------------------------------------------- | ------ |
| `podDisruptionBudget.enabled`        | If PDB is enabled for the service.                   | `true` |
| `podDisruptionBudget.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`    |


### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                 | Description                                                                                                                                                    | Value   |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                        | If HPA is enabled for the service.                                                                                                                             | `false` |
| `hpa.maxReplicas`                    | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                   | `2`     |
| `hpa.minReplicas`                    | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                 | `1`     |
| `hpa.targetCPUUtilizationPercentage` | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used. | `80`    |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name              | Description                            | Value   |
| ----------------- | -------------------------------------- | ------- |
| `ingress.enabled` | If Ingress is enabled for the service. | `false` |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
