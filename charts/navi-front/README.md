# 2GIS Navi-Front service

Use this Helm chart to deploy Navi-Front service, which is a part of 2GIS's [On-Premise Navigation services](https://docs.2gis.com/en/on-premise/navigation).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/navigation) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-front.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                                 | Description                                                                                                                                                               | Value   |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `enableServiceLinks`                 | Services injection into containers environment [Accessing the Service](https://kubernetes.io/docs/tutorials/services/connect-applications-service/#accessing-the-service) | `false` |
| `replicaCount`                       | A replica count for the pod.                                                                                                                                              | `1`     |
| `revisionHistoryLimit`               | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                            | `3`     |
| `imagePullSecrets`                   | Kubernetes image pull secrets.                                                                                                                                            | `[]`    |
| `nameOverride`                       | Base name to use in all the Kubernetes entities deployed by this chart.                                                                                                   | `""`    |
| `fullnameOverride`                   | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                                                               | `""`    |
| `podAnnotations`                     | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                             | `{}`    |
| `podSecurityContext`                 | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                                                            | `{}`    |
| `securityContext`                    | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                                                                | `{}`    |
| `nodeSelector`                       | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                       | `{}`    |
| `tolerations`                        | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                         | `[]`    |
| `affinity`                           | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                               | `{}`    |
| `sidecars`                           | List of additional sidecar containers                                                                                                                                     | `[]`    |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                                                                                                      | `true`  |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                                                                   | `0`     |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                                                                          | `10`    |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                                                                         | `1`     |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                                                                       | `3`     |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                                                                       | `1`     |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                                                                                                     | `true`  |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                                                                  | `0`     |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                                                                         | `10`    |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                                                                        | `1`     |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                                                                      | `3`     |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                                                                      | `1`     |
| `customLivenessProbe`                | Override default liveness probe                                                                                                                                           | `{}`    |
| `customReadinessProbe`               | Override default readiness probe                                                                                                                                          | `{}`    |

### Deployment settings

| Name               | Description | Value                        |
| ------------------ | ----------- | ---------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/navi-front` |
| `image.tag`        | Tag         | `1.28.1`                     |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`               |

### Navi-Front service settings

| Name                                     | Description                                                                                                                | Value                                            |
| ---------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| `front.port`                             | Navi-Front service HTTP port                                                                                               | `8080`                                           |
| `front.router.discover`                  | Enable/disable router autodiscovery                                                                                        | `true`                                           |
| `front.router.host`                      | Set router address if autodiscovery is disabled                                                                            | `localhost`                                      |
| `front.router.backupPorts`               | Support for backup ports on router                                                                                         |                                                  |
| `front.router.backupPorts.base`          | Backup router ports start with `base` and assignd sequentially up                                                          | `50000`                                          |
| `front.router.backupPorts.number`        | Number of backup router ports                                                                                              | `0`                                              |
| `front.router.keepalive`                 | Allows router upstream overrides to front.keepalive settings                                                               | `{}`                                             |
| `front.router.proxy`                     | Settings for router proxy rule                                                                                             |                                                  |
| `front.router.proxy.nextUpstreamTimeout` | nginx [proxy_next_upstream_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream_timeout) | `750ms`                                          |
| `front.router.proxy.connectTimeout`      | nginx [proxy_connect_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_connect_timeout)             | `100ms`                                          |
| `front.router.proxy.readTimeout`         | nginx [proxy_read_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout)                   | `500ms`                                          |
| `front.router.proxy.sendTimeout`         | nginx [proxy_send_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_send_timeout)                   | `500ms`                                          |
| `front.router.proxy.nextUpstream`        | nginx [proxy_next_upstream](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream)                 | `error timeout non_idempotent http_502 http_504` |
| `front.tsp_carrouting.enabled`           | Enable/disable carrouting TSP                                                                                              | `false`                                          |
| `front.tsp_carrouting.host`              | Set carrouting TSP hostname                                                                                                | `""`                                             |
| `front.multimod.enabled`                 | Add multimodal routing service location                                                                                    | `false`                                          |
| `front.multimod.host`                    | Multimodal routing service hostname                                                                                        | `""`                                             |
| `front.keepalive.enabled`                | Enable keepalive (for upstreams)                                                                                           | `false`                                          |
| `front.keepalive.connections`            | Maximum number of idle keepalive connections (per upstream)                                                                | `50`                                             |
| `front.keepalive.requests`               | Maximum number of requests that can be served through one keepalive connection                                             | `100`                                            |
| `front.keepalive.time`                   | Maximum time for one keepalive connection                                                                                  | `1h`                                             |
| `front.keepalive.timeout`                | Timeout for idle keepalive connection                                                                                      | `60s`                                            |
| `front.locationExtraProxyHeaders`        | Additional headers to pass to backend `locationExtraProxyHeaders: { header1: value1, header2: 'value 2'}`                  | `{}`                                             |
| `navigroup`                              | Service group identifier, allows multiple stacks deployed to the same namespace.                                           | `""`                                             |

### Service account settings

| Name                         | Description                                                                                                             | Value   |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                                                  | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account.                                                                              | `{}`    |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |

### Service settings

| Name           | Description                                                                                                                    | Value       |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.type` | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port` | Service port.                                                                                                                  | `80`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                    |
| ------------------------------------ | ----------------------------------------- | ------------------------ |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                  |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`                  |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `navi-front.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                      |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                 |
| `ingress.tls`                        | TLS configuration                         | `[]`                     |

### Limits

| Name                        | Description                                 | Value       |
| --------------------------- | ------------------------------------------- | ----------- |
| `resources`                 | Container resources requirements structure. | `{}`        |
| `resources.requests.cpu`    | CPU request, recommended value `100m`.      | `undefined` |
| `resources.requests.memory` | Memory request, recommended value `128Mi`.  | `undefined` |
| `resources.limits.cpu`      | CPU limit, recommended value `1000m`.       | `undefined` |
| `resources.limits.memory`   | Memory limit, recommended value `1Gi`.      | `undefined` |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                    | Description                                                                                                                                                          | Value   |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                           | If HPA is enabled for the service.                                                                                                                                   | `false` |
| `hpa.minReplicas`                       | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`     |
| `hpa.maxReplicas`                       | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `100`   |
| `hpa.targetCPUUtilizationPercentage`    | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`    |
| `hpa.targetMemoryUtilizationPercentage` | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`    |
| `hpa.scaleUp`                           | To configure separate scale-up [policy](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#scaling-policies)                                 | `{}`    |
| `hpa.scaleDown`                         | To configure separate scale-down [policy](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#scaling-policies)                               | `{}`    |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                          | Value   |
| -------------------- | ---------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service.                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`     |

### Nginx container

| Name                                             | Description                                                                                                                                     | Value        |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| `nginx.customConfigPath`                         | Path to custom nginx config file. If set, default config will be ignored.                                                                       | `""`         |
| `nginx.setRealIpFrom`                            | Defines trusted addresses that are known to send correct replacement addresses                                                                  | `127.0.0.1`  |
| `nginx.opentracing.enabled`                      | If opentracing enabled for nginx requests                                                                                                       | `false`      |
| `nginx.opentracing.serviceName`                  | Service name sent to jaeger                                                                                                                     | `navi-front` |
| `nginx.opentracing.host`                         | Jaeger agent host. If empty than used status.hostIP                                                                                             | `""`         |
| `nginx.opentracing.port`                         | Jaeger agent port                                                                                                                               | `6831`       |
| `nginx.opentracing.samplerType`                  | Sampler type: const, probabilistic, ratelimiting, remote. [Doc](https://www.jaegertracing.io/docs/1.56/sampling/#client-sampling-configuration) | `const`      |
| `nginx.opentracing.samplerParam`                 | Sampler parameter                                                                                                                               | `1`          |
| `nginx.opentracing.tags`                         | Sets tags for span                                                                                                                              |              |
| `nginx.hideBackendHostname`                      | Do not pass X-Back-Hostname header from navi-back to client                                                                                     | `true`       |
| `nginx.protectInternalLocations`                 |                                                                                                                                                 |              |
| `nginx.protectInternalLocations.allowedNetworks` | CIDR blocks to allow access to internal locations from. For debug purposes only                                                                 | `[]`         |

### Location overrides

| Name                    | Description                                                                                      | Value |
| ----------------------- | ------------------------------------------------------------------------------------------------ | ----- |
| `locationBlock`         | Optional nginx config block with additional locations                                            | `""`  |
| `carroutingLocation`    | Override for default /carrouting                                                                 | `""`  |
| `distMatrixCtxLocation` | Override for default /get_dist_matrix_ctx                                                        | `""`  |
| `hullLocation`          | Override for default /get_hull                                                                   | `""`  |
| `multimodLocation`      | Override for default /ctx_multi_mod and /find_platforms if enabled with `front.multimod.enabled` | `""`  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
