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

| Name                   | Description                                                                                                                                                               | Value  |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `enableServiceLinks`   | Services injection into containers environment [Accessing the Service](https://kubernetes.io/docs/tutorials/services/connect-applications-service/#accessing-the-service) | `true` |
| `replicaCount`         | A replica count for the pod.                                                                                                                                              | `1`    |
| `revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                            | `3`    |
| `imagePullSecrets`     | Kubernetes image pull secrets.                                                                                                                                            | `[]`   |
| `nameOverride`         | Base name to use in all the Kubernetes entities deployed by this chart.                                                                                                   | `""`   |
| `fullnameOverride`     | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                                                               | `""`   |
| `podAnnotations`       | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                             | `{}`   |
| `podSecurityContext`   | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                                                            | `{}`   |
| `securityContext`      | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                                                                | `{}`   |
| `nodeSelector`         | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                       | `{}`   |
| `tolerations`          | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                         | `[]`   |
| `affinity`             | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                               | `{}`   |

### Deployment settings

| Name               | Description | Value                        |
| ------------------ | ----------- | ---------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/navi-front` |
| `image.tag`        | Tag         | `1.25.2`                     |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`               |

### Navi-Front service settings

| Name                    | Description                                      | Value       |
| ----------------------- | ------------------------------------------------ | ----------- |
| `front.port`            | Navi-Front service HTTP port.                    | `8080`      |
| `front.router.discover` | Enable/disable router autodiscovery.             | `true`      |
| `front.router.host`     | Set router address if autodiscovery is disabled. | `localhost` |

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

| Name                                      | Description                                                                                                                                                          | Value   |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                             | If HPA is enabled for the service.                                                                                                                                   | `false` |
| `hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`     |
| `hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `100`   |
| `hpa.scaleDownStabilizationWindowSeconds` | Scale-down window.                                                                                                                                                   | `""`    |
| `hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window.                                                                                                                                                     | `""`    |
| `hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`    |
| `hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`    |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                          | Value   |
| -------------------- | ---------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service.                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`     |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
