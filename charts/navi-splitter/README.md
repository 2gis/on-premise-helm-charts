# 2GIS Splitter service

Use this Helm chart to deploy Splitter service, which is a part of 2GIS's Navi [On-Premise Navigation services](https://docs.2gis.com/en/on-premise/navigation).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/navigation) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-splitter.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.


## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                   | Description                                                                                                                 | Value |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `replicaCount`         | A replica count for the pod.                                                                                                | `1`   |
| `revisionHistoryLimit` | Number of replica sets to keep for deployment rollbacks                                                                     | `1`   |
| `imagePullSecrets`     | Kubernetes image pull secrets.                                                                                              | `[]`  |
| `nameOverride`         | Base name to use in all the Kubernetes entities deployed by this chart.                                                     | `""`  |
| `fullnameOverride`     | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                 | `""`  |
| `navigroup`            | Name of navigation deploy group.                                                                                            | `""`  |
| `podAnnotations`       | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`  |
| `podSecurityContext`   | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).              | `{}`  |
| `securityContext`      | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                  | `{}`  |
| `nodeSelector`         | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).         | `{}`  |
| `tolerations`          | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.           | `[]`  |
| `affinity`             | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). | `{}`  |
| `labels`               | Custom labels to set to Deployment resource.                                                                                | `{}`  |

### Deployment settings

| Name               | Description | Value                           |
| ------------------ | ----------- | ------------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/navi-splitter` |
| `image.tag`        | Tag         | `1.0.1`                         |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`                  |

### Splitter application settings

| Name                          | Description                                                                                    | Value  |
| ----------------------------- | ---------------------------------------------------------------------------------------------- | ------ |
| `splitter.logLevel`           | Logging level.                                                                                 | `info` |
| `splitter.app_rule`           | Rule name of navi-back host.                                                                   | `""`   |
| `splitter.goMaxProcs`         | Number of golang processes.                                                                    | `1`    |
| `splitter.appPort`            | Application port.                                                                              | `8080` |
| `splitter.ctxUrl`             | URL of get_dist_matrix_ctx host. Format: `http(s)://HOST:PORT/ctx/2.0/?source=distance_matrix. | `""`   |
| `splitter.ctxTimeout`         | get_dist_matrix_ctx request timeout.                                                           | `60s`  |
| `splitter.subrequestRetryN`   | Number of retries to host.                                                                     | `5`    |
| `splitter.writeTimeout`       | Write timeout.                                                                                 | `10s`  |
| `splitter.readTimeout`        | Read timeout.                                                                                  | `10s`  |
| `splitter.idleTimeout`        | Idle timeout.                                                                                  | `60s`  |
| `splitter.statHost`           | Statistic receiver host                                                                        | `""`   |
| `splitter.statThreadPoolSize` | Number of statistic sender threads                                                             | `16`   |

### Service account settings

| Name                         | Description                                                                                                             | Value   |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                                                  | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account.                                                                              | `{}`    |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |

### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | Service port.                                                                                                                  | `80`        |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `nil`       |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                           | Description                               | Value                       |
| ------------------------------ | ----------------------------------------- | --------------------------- |
| `ingress.className`            | Name of the Ingress controller class.     | `nginx`                     |
| `ingress.enabled`              | If Ingress is enabled for the service.    | `true`                      |
| `ingress.hosts.host`           | Hostname for the Ingress service.         | `navi-splitter.example.com` |
| `ingress.hosts.paths.path`     | Path of the host for the Ingress service. | `/`                         |
| `ingress.hosts.paths.pathType` | Type of the path for the Ingress service. | `Prefix`                    |
| `ingress.tls`                  | TLS configuration                         | `[]`                        |

### Limits

| Name                            | Description                     | Value |
| ------------------------------- | ------------------------------- | ----- |
| `resources.requests.cpu`        | A CPU request.                  |       |
| `resources.requests.memory`     | A memory request.               |       |
| `resources.limits.cpu`          | A CPU limit.                    |       |
| `resources.limits.memory`       | A memory limit.                 |       |
| `testResources`                 | **Limits for test connection.** | `{}`  |
| `testResources.requests.cpu`    | A CPU request.                  |       |
| `testResources.requests.memory` | A memory request.               |       |
| `testResources.limits.cpu`      | A CPU limit.                    |       |
| `testResources.limits.memory`   | A memory limit.                 |       |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                      | Description                                                                                                                                                          | Value   |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                             | If HPA is enabled for the service.                                                                                                                                   | `false` |
| `hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`     |
| `hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `100`   |
| `hpa.scaleDownStabilizationWindowSeconds` | Scale-down window.                                                                                                                                                   | `""`    |
| `hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window.                                                                                                                                                     | `""`    |
| `hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`    |
| `hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`    |
