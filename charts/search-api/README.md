# 2GIS Search API service

Use this Helm chart to deploy Search API service, which is a part of 2GIS's [On-Premise Search services](https://docs.2gis.com/en/on-premise/search).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

See the [documentation](https://docs.2gis.com/en/on-premise/search) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-search.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                            | Value |
| --------------------- | -------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port` | `""`  |

### Common settings

| Name                            | Description                                                                                                                                                               | Value  |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `enableServiceLinks`            | Services injection into containers environment [Accessing the Service](https://kubernetes.io/docs/tutorials/services/connect-applications-service/#accessing-the-service) | `true` |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)                                                              | `{}`   |
| `podLabels`                     | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)                                                                        | `{}`   |
| `replicaCount`                  | A replica count for the pod                                                                                                                                               | `1`    |
| `revisionHistoryLimit`          | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                            | `3`    |
| `terminationGracePeriodSeconds` | Kubernetes [termination grace period](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/)                                                          | `30`   |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)                                                        | `{}`   |
| `affinity`                      | Kubernetes [pod affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity)                                                         | `{}`   |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings                                                          | `[]`   |
| `redeployLabel`                 | If this label is changed since the last deployment, the whole chart will be redeployed                                                                                    | `""`   |

### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                             | Value   |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`                                                                                                                                                                                                                        | `""`    |
| `dgctlStorage.bucket`    | S3 bucket name                                                                                                                                                                                                                                          | `""`    |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket                                                                                                                                                                                                                  | `""`    |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket                                                                                                                                                                                                                  | `""`    |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json` <br> This file contains the description of pieces of data that the service requires to operate | `""`    |
| `dgctlStorage.secure`    | If S3 uses https.                                                                                                                                                                                                                                       | `false` |
| `dgctlStorage.region`    | S3 region                                                                                                                                                                                                                                               | `""`    |

### Deployment settings

| Name                   | Description                                                                                   | Value                        |
| ---------------------- | --------------------------------------------------------------------------------------------- | ---------------------------- |
| `api.image.repository` | Repository                                                                                    | `2gis-on-premise/search-api` |
| `api.image.tag`        | Tag                                                                                           | `7.90.0`                     |
| `api.image.pullPolicy` | Image [pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) | `IfNotPresent`               |

### API settings

| Name            | Description                                  | Value   |
| --------------- | -------------------------------------------- | ------- |
| `api.dataDir`   | Path to the directory storing search indexes | `/data` |
| `api.fcgiPort`  | TCP port of the Search API                   | `9090`  |
| `api.logLevel`  | Log level                                    | `Info`  |
| `api.logFormat` | Log format: `json` or `plaintext`            | `json`  |
| `api.timeout`   | Search timeout (in milliseconds)             | `5000`  |
| `api.configOpt` | Additional options (for debugging purposes)  | `[]`    |

### NGINX settings

| Name                     | Description                                                                                   | Value                   |
| ------------------------ | --------------------------------------------------------------------------------------------- | ----------------------- |
| `nginx.image.repository` | Docker Repository                                                                             | `2gis-on-premise/nginx` |
| `nginx.image.tag`        | Docker image tag                                                                              | `1.25.5`                |
| `nginx.image.pullPolicy` | Image [pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) | `IfNotPresent`          |
| `nginx.httpPort`         | HTTP port on which NGINX will be listening                                                    | `8080`                  |

### Strategy settings

| Name                                    | Description                                                                                                                                                                                             | Value           |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate` [Strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy)                                          | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process                     | `1`             |

### Service settings

| Name                  | Description                                                                                                                   | Value       |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)                        | `{}`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) | `ClusterIP` |
| `service.port`        | Service port                                                                                                                  | `80`        |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                         | Value  |
| -------------------- | --------------------------------------------------- | ------ |
| `pdb.enabled`        | If PDB is enabled for the service                   | `true` |
| `pdb.minAvailable`   | How many pods must be available after the eviction  | `""`   |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction | `1`    |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                      | Description                                                                                                                                                         | Value   |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                             | If HPA is enabled for the service                                                                                                                                   | `false` |
| `hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down                                                                                       | `1`     |
| `hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up                                                                                         | `2`     |
| `hpa.scaleDownStabilizationWindowSeconds` | Scale-down window                                                                                                                                                   | `""`    |
| `hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window                                                                                                                                                     | `""`    |
| `hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used       | `80`    |
| `hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used | `""`    |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                    |
| ------------------------------------ | ----------------------------------------- | ------------------------ |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                  |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`                  |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `search-api.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                      |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                 |
| `ingress.tls`                        | TLS configuration                         | `[]`                     |

### api.resources Kubernetes [resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) settings

| Name                              | Description                      | Value |
| --------------------------------- | -------------------------------- | ----- |
| `api.resources`                   | **Limits for the API service**   | `{}`  |
| `api.resources.requests.cpu`      | A CPU request, e.g., `100m`      |       |
| `api.resources.requests.memory`   | A memory request, e.g., `128Mi`  |       |
| `api.resources.limits.cpu`        | A CPU limit, e.g., `100m`        |       |
| `api.resources.limits.memory`     | A memory limit, e.g., `128Mi`    |       |
| `nginx.resources`                 | **Limits for the NGINX service** | `{}`  |
| `nginx.resources.requests.cpu`    | A CPU request, e.g., `100m`      |       |
| `nginx.resources.requests.memory` | A memory request, e.g., `128Mi`  |       |
| `nginx.resources.limits.cpu`      | A CPU limit, e.g., `100m`        |       |
| `nginx.resources.limits.memory`   | A memory limit, e.g., `128Mi`    |       |

### customCAs **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container. If empty, the default value: "/usr/local/share/ca-certificates"          | `""`  |


## Maintainers

| Name | Email                 | Url                       |
| ---- | --------------------- | ------------------------- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
