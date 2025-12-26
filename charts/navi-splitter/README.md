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

| Name                            | Description                                                                                                                                  | Value |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `replicaCount`                  | A replica count for the pod.                                                                                                                 | `1`   |
| `revisionHistoryLimit`          | Number of replica sets to keep for deployment rollbacks                                                                                      | `3`   |
| `imagePullSecrets`              | Kubernetes image pull secrets.                                                                                                               | `[]`  |
| `nameOverride`                  | Base name to use in all the Kubernetes entities deployed by this chart.                                                                      | `""`  |
| `fullnameOverride`              | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                                  | `""`  |
| `navigroup`                     | Name of navigation deploy group.                                                                                                             | `""`  |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                | `{}`  |
| `podSecurityContext`            | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                               | `{}`  |
| `securityContext`               | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                                   | `{}`  |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                          | `{}`  |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                            | `[]`  |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                  | `{}`  |
| `labels`                        | Custom labels to set to Deployment resource.                                                                                                 | `{}`  |
| `preStopDelay`                  | Delay in seconds before terminating container.                                                                                               | `5`   |
| `terminationGracePeriodSeconds` | Grace period for container shutdown, refer to [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/) for details | `60`  |

### Deployment settings

| Name               | Description | Value                           |
| ------------------ | ----------- | ------------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/navi-splitter` |
| `image.tag`        | Tag         | `1.15.0`                        |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`                  |

### Splitter application settings

| Name                          | Description                                                                                          | Value  |
| ----------------------------- | ---------------------------------------------------------------------------------------------------- | ------ |
| `splitter.logLevel`           | Logging level.                                                                                       | `info` |
| `splitter.appRule`            | Rule name of navi-back instance                                                                      | `""`   |
| `splitter.app_rule`           | DEPRECATED see `splitter.appRule`                                                                    |        |
| `splitter.goMaxProcs`         | Number of golang processes.                                                                          | `1`    |
| `splitter.appPort`            | Application port.                                                                                    | `8080` |
| `splitter.ctxBaseUrl`         | URL of ctx host. Format: `http(s)://HOST:PORT/ctx/2.0`.                                              | `""`   |
| `splitter.ctxV3BaseUrl`       | URL of ctx v3 host. Format: `http(s)://HOST:PORT/ctx/3.0`.                                           | `""`   |
| `splitter.ctxUrl`             | Full URL of get_dist_matrix_ctx host. Format: `http(s)://HOST:PORT/ctx/2.0/?source=distance_matrix`. | `""`   |
| `splitter.findPlatformUrl`    | Full URL of find_platform host. Format: `http(s)://HOST:PORT/find_platforms`.                        | `""`   |
| `splitter.ctxTimeout`         | get_dist_matrix_ctx request timeout.                                                                 | `60s`  |
| `splitter.subrequestRetryN`   | Number of retries to host.                                                                           | `5`    |
| `splitter.writeTimeout`       | Write timeout.                                                                                       | `10s`  |
| `splitter.readTimeout`        | Read timeout.                                                                                        | `10s`  |
| `splitter.idleTimeout`        | Idle timeout.                                                                                        | `60s`  |
| `splitter.proxyTimeout`       | Proxy timeout.                                                                                       | `15s`  |
| `splitter.subrequestTimeout`  | Subrequest timeout.                                                                                  | `60s`  |
| `splitter.statHost`           | Statistic receiver host.                                                                             | `""`   |
| `splitter.statThreadPoolSize` | Number of statistic sender threads                                                                   | `16`   |

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

| Name                                 | Description                               | Value                       |
| ------------------------------------ | ----------------------------------------- | --------------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                     |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`                     |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `navi-splitter.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                         |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                    |
| `ingress.tls`                        | TLS configuration                         | `[]`                        |

### Limits

| Name                        | Description                                | Value       |
| --------------------------- | ------------------------------------------ | ----------- |
| `resources.requests.cpu`    | A CPU request.                             |             |
| `resources.requests.memory` | A memory request.                          |             |
| `resources.limits.cpu`      | A CPU limit.                               |             |
| `resources.limits.memory`   | A memory limit.                            |             |
| `resources`                 | Container resources requirements structure | `{}`        |
| `resources.requests.cpu`    | CPU request, recommended value `500m`      | `undefined` |
| `resources.requests.memory` | Memory request, recommended value `512Mi`  | `undefined` |
| `resources.limits.cpu`      | CPU limit, recommended value `1000m`       | `undefined` |
| `resources.limits.memory`   | Memory limit, recommended value `1Gi`      | `undefined` |

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

### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                    | Description                                                                                                  | Value   |
| ----------------------- | ------------------------------------------------------------------------------------------------------------ | ------- |
| `vpa.enabled`           | If VPA is enabled for the service.                                                                           | `false` |
| `vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start). | `Auto`  |
| `vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down.                                   |         |
| `vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down.                                         |         |
| `vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up.                                     |         |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up.                                           |         |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                          | Value  |
| -------------------- | ---------------------------------------------------- | ------ |
| `pdb.enabled`        | If PDB is enabled for the service.                   | `true` |
| `pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`   |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`    |

### Attractor

| Name                | Description                                        | Value   |
| ------------------- | -------------------------------------------------- | ------- |
| `attractor.enabled` | If attractor is enabled.                           | `false` |
| `attractor.host`    | Attractor host. Ex.: navi-attractor.svc            | `""`    |
| `attractor.port`    | Attractor port.                                    | `50051` |
| `attractor.timeout` | Attractor timeout configured on application level. | `2s`    |

### One to Many (navi-back) host

| Name                | Description                                             | Value |
| ------------------- | ------------------------------------------------------- | ----- |
| `oneToMany.enabled` | If one-to-many request (sends to navi-back) is enabled. |       |
| `oneToMany.host`    | One-to-many(navi-back) host. Ex.: navi-back.svc         |       |
| `oneToMany.port`    | One-to-many(navi-back) port.                            |       |

### Pass Through (proxy mode)

| Name                  | Description                               | Value |
| --------------------- | ----------------------------------------- | ----- |
| `passThrough.enabled` | If proxy mode enabled.                    |       |
| `passThrough.host`    | Proxy destination hostname or IP-address. |       |
| `passThrough.port`    | Proxy destination port number.            |       |
| `passThrough.scheme`  | Proxy destination protocol.               |       |

### Envoy configuration

| Name                              | Description                                                                                                                                                                                    | Value                            |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `envoy.image.repository`          | Repository                                                                                                                                                                                     | `2gis-on-premise/navi-envoy`     |
| `envoy.image.tag`                 | Tag                                                                                                                                                                                            | `1.36.2-tools`                   |
| `envoy.image.pullPolicy`          | Pull Policy                                                                                                                                                                                    | `IfNotPresent`                   |
| `envoy.resources.requests.cpu`    | CPU request, recommended value `100m`                                                                                                                                                          | `undefined`                      |
| `envoy.resources.requests.memory` | Memory request, recommended value `100Mi`                                                                                                                                                      | `undefined`                      |
| `envoy.resources.limits.cpu`      | CPU limit, recommended value `100m`                                                                                                                                                            | `undefined`                      |
| `envoy.resources.limits.memory`   | Memory limit, recommended value `100Mi`                                                                                                                                                        | `undefined`                      |
| `envoy.systemLogs.logLevel`       | System log level: [trace][debug][info][warning|warn][error][critical][off].                                                                                                                    | `info`                           |
| `envoy.systemLogs.logFormat`      | System log format (if empty — plain-text is used)                                                                                                                                              | `json`                           |
| `envoy.accessLogs.enabled`        | if access logging enabled                                                                                                                                                                      | `false`                          |
| `envoy.clusterTimeout`            | Cluster timeout.                                                                                                                                                                               | `15s`                            |
| `envoy.connectTimeout`            | Connect timeout.                                                                                                                                                                               | `1s`                             |
| `envoy.concurrency`               | The number of worker threads to run. Use `max(1, floor(resources.limits.cpu))` if set to `0`                                                                                                   | `""`                             |
| `envoy.retry.enabled`             | Enable retry failed requests                                                                                                                                                                   | `false`                          |
| `envoy.retry.retryOn`             | Status [codes for retry](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/router_filter#x-envoy-retry-grpc-on)                                                      | `internal,unavailable,5xx,reset` |
| `envoy.retry.numRetries`          | Failed request [retries](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/router_filter#config-http-filters-router-x-envoy-max-retries)                             | `1`                              |
| `envoy.retry.perTryTimeout`       | Specifies timeout on each [retry](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/router_filter#config-http-filters-router-x-envoy-upstream-rq-per-try-timeout-ms) | `2s`                             |
| `envoy.configFilepath`            | Configs mountpoint path                                                                                                                                                                        | `/src/etc/envoy`                 |

### Fixed data group attributes

| Name                | Description                                                       | Value |
| ------------------- | ----------------------------------------------------------------- | ----- |
| `dataGroup.enabled` | If fixed data topology enabled.                                   |       |
| `dataGroup.prefix`  | Unique name for this data group across the navigroup environment. |       |

### Metrics aggregator container

| Name                                | Description                                     | Value                                     |
| ----------------------------------- | ----------------------------------------------- | ----------------------------------------- |
| `metrics.enabled`                   | Enable metrics container and scrape annotations | `false`                                   |
| `metrics.image.repository`          | Repository                                      | `2gis-on-premise/navi-metrics-aggregator` |
| `metrics.image.tag`                 | Tag                                             | `1.0.0`                                   |
| `metrics.image.pullPolicy`          | Pull Policy                                     | `IfNotPresent`                            |
| `metrics.port`                      | Port of container.                              | `9090`                                    |
| `metrics.resources`                 | Container resources requirements structure.     | `{}`                                      |
| `metrics.resources.requests.cpu`    | CPU request, recommended value `10m`.           | `undefined`                               |
| `metrics.resources.requests.memory` | Memory request, recommended value `10Mi`.       |                                           |
| `metrics.resources.limits.cpu`      | CPU limit, recommended value `100m`.            |                                           |
| `metrics.resources.limits.memory`   | Memory limit, recommended value `10Mi`.         |                                           |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
