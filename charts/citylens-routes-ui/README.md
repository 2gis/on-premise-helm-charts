## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value          |
| --------------------- | --------------------------------------------------------------------------------------- | -------------- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`           |
| `imagePullPolicy`     | Pull Policy                                                                             | `IfNotPresent` |
| `imagePullSecrets`    | Kubernetes image pull secrets.                                                          | `[]`           |

### Strategy settings

| Name                                    | Description                                                                                                                                                                                              | Value           |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |

### Deployment settings

| Name               | Description | Value                                |
| ------------------ | ----------- | ------------------------------------ |
| `image.repository` | Repository  | `2gis-on-premise/citylens-routes-ui` |
| `image.tag`        | Tag         | `1.0.2`                              |

### Environment

| Name                          | Description                                              | Value |
| ----------------------------- | -------------------------------------------------------- | ----- |
| `env.CATALOG_API_URL`         | Catalog API base URL **Required**                        | `""`  |
| `env.MAPGL_API_URL`           | Map API base URL **Required**                            | `""`  |
| `env.MAPGL_COPYRIGHT_VARIANT` | Copyright variant, can be '2gis', 'urbi' or empty        | `""`  |
| `env.MAPGL_KEY`               | API key for mapgl **Required**                           | `""`  |
| `env.MAPGL_STYLE_ID`          | Map style ID                                             | `""`  |
| `env.ROUTES_API_URL`          | Backend (citylens-routes-api) base URL **Required**      | `""`  |
| `env.SSO_API_URL`             | Single sign-on API URL **Required**                      | `""`  |
| `env.SSO_CLIENT_ID`           | OpenID client identifier for single sign-on **Required** | `""`  |
| `env.SSO_CLIENT_SECRET`       | OpenID client identifier for single sign-on **Required** | `""`  |
| `env.SSO_SCOPE`               | OpenID scope for single sign-on **Required**             | `""`  |

### Common deployment settings

| Name                            | Description                                                                                                                                     | Value     |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| `replicas`                      | A replica count for the pod.                                                                                                                    | `1`       |
| `revisionHistoryLimit`          | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).  | `3`       |
| `terminationGracePeriodSeconds` | Seconds pod needs to [terminate](https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods) gracefully                        | `60`      |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                             | `{}`      |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                     | `{}`      |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                               | `[]`      |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                   | `{}`      |
| `podLabels`                     | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                             | `{}`      |
| `annotations`                   | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                       | `{}`      |
| `labels`                        | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                 | `{}`      |
| `healthcheckPath`               | Application http path for health check                                                                                                          | `/health` |
| `readinessProbe.enabled`        | Enable [readinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes) | `true`    |
| `livenessProbe.enabled`         | Enable [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes)  | `true`    |
| `containerPort`                 | Port on which application listen connection in container                                                                                        | `3000`    |

### Logs

| Name                 | Description                                                                                            | Value       |
| -------------------- | ------------------------------------------------------------------------------------------------------ | ----------- |
| `log.formats`        | List of log formats to be used in NGINX configuration, has `name`, `escape` and `format` properties    | `[]`        |
| `log.errorLog.level` | Error log level. Allowed values: `debug`, `info`, `notice`, `warn`, `error`, `crit`, `alert`, `emerg`. | `debug`     |
| `log.accessLog`      | NGINX access log definition. To enable add log path and format name, for example: '/dev/stdout main'   | `/dev/null` |

### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | Service port.                                                                                                                  | `80`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                                                                                               | Value                            |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.                                                                    | `false`                          |
| `ingress.annotations`                | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/). | `{}`                             |
| `ingress.className`                  | Name of the Ingress controller class.                                                                     | `nginx`                          |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.                                                                         | `citylens-routes-ui.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service.                                                                 | `/`                              |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service.                                                                 | `Prefix`                         |
| `ingress.tls`                        | TLS configuration                                                                                         | `[]`                             |

### Limits

| Name                        | Description       | Value   |
| --------------------------- | ----------------- | ------- |
| `resources.requests.cpu`    | A CPU request.    | `300m`  |
| `resources.requests.memory` | A memory request. | `256Mi` |
| `resources.limits.cpu`      | A CPU limit.      | `1`     |
| `resources.limits.memory`   | A memory limit.   | `384Mi` |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                         | Value   |
| -------------------- | --------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction | `1`     |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                      | Description                                                                                                                                                         | Value   |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                             | If HPA is enabled for the service                                                                                                                                   | `false` |
| `hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down                                                                                       | `1`     |
| `hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up                                                                                         | `100`   |
| `hpa.scaleDownStabilizationWindowSeconds` | Scale-down window                                                                                                                                                   | `""`    |
| `hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window                                                                                                                                                     | `""`    |
| `hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used       | `80`    |
| `hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used | `""`    |

### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                    | Description                                                                                                  | Value   |
| ----------------------- | ------------------------------------------------------------------------------------------------------------ | ------- |
| `vpa.enabled`           | If VPA is enabled for the service.                                                                           | `false` |
| `vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start). | `Auto`  |
| `vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down.                                   | `500m`  |
| `vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down.                                         | `128Mi` |
| `vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up.                                     | `2000`  |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up.                                           | `512Mi` |
