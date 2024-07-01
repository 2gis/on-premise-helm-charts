# Navi async-grpc-proxy Helm Chart
## Описание

Чарт разворачивает Async GRPC Proxy:
https://gitlab.2gis.ru/traffic/async-grpc-proxy


## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                   | Description                                                                                                                 | Value |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `replicaCount`         | A replica count for the pod.                                                                                                | `1`   |
| `revisionHistoryLimit` | Number of replica sets to keep for deployment rollbacks                                                                     | `3`   |
| `imagePullSecrets`     | Kubernetes image pull secrets.                                                                                              | `[]`  |
| `nameOverride`         | Base name to use in all the Kubernetes entities deployed by this chart.                                                     | `""`  |
| `fullnameOverride`     | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                 | `""`  |
| `podAnnotations`       | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`  |
| `podSecurityContext`   | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).              | `{}`  |
| `securityContext`      | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                  | `{}`  |
| `nodeSelector`         | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).         | `{}`  |
| `tolerations`          | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.           | `[]`  |
| `affinity`             | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). | `{}`  |
| `labels`               | Custom labels to set to Deployment resource.                                                                                | `{}`  |

### Deployment settings

| Name               | Description | Value                              |
| ------------------ | ----------- | ---------------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/async-grpc-proxy` |
| `image.tag`        | Tag         | `1.0.0`                            |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`                     |

### async-grpc-proxy application settings

| Name                | Description                                  | Value  |
| ------------------- | -------------------------------------------- | ------ |
| `app.containerPort` | Container port which application listens on. | `7000` |

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
| `service.port`        | Service port.                                                                                                                  | `7000`      |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `nil`       |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                               |
| ------------------------------------ | ----------------------------------------- | ----------------------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                             |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`                             |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `navi-async-grpc-proxy.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                                 |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                            |
| `ingress.tls`                        | TLS configuration                         | `[]`                                |

### Limits

| Name                        | Description       | Value |
| --------------------------- | ----------------- | ----- |
| `resources.requests.cpu`    | A CPU request.    |       |
| `resources.requests.memory` | A memory request. |       |
| `resources.limits.cpu`      | A CPU limit.      |       |
| `resources.limits.memory`   | A memory limit.   |       |

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

| Name                 | Description                                          | Value   |
| -------------------- | ---------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service.                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`     |

### Settings for navi-async-matrix service connection

| Name      | Description                                                           | Value |
| --------- | --------------------------------------------------------------------- | ----- |
| `dm.url`  | async-matrix host name with schema, ex: http://navi-async-matrix.host | `""`  |
| `dm.port` | async-matrix port                                                     | `80`  |


## Пример деплоя

```
helm install --wait test-grpc-proxy . --image.tag=v1.0.0 --set dm.host=http://navi-async-matrix.host
```
