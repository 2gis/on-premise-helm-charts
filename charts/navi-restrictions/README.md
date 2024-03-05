# 2GIS Restrictions service

Use this Helm chart to deploy Restrictions API service, which is a part of 2GIS's [On-Premise Navigation services](https://docs.2gis.com/en/on-premise/navigation).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/restrictions) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-navi-restrictions.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                            | Value |
| --------------------- | -------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port` | `""`  |

### Common settings

| Name                            | Description                                                                                                                | Value  |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ------ |
| `replicaCount`                  | A replica count for the pod                                                                                                | `1`    |
| `imagePullSecrets`              | Kubernetes image pull secrets                                                                                              | `[]`   |
| `nameOverride`                  | Base name to use in all the Kubernetes entities deployed by this chart                                                     | `""`   |
| `fullnameOverride`              | Base fullname to use in all the Kubernetes entities deployed by this chart                                                 | `""`   |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)               | `{}`   |
| `podLabels`                     | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)                         | `{}`   |
| `labels`                        | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)                             | `{}`   |
| `podSecurityContext`            | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)              | `{}`   |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)         | `{}`   |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings           | `[]`   |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) | `{}`   |
| `priorityClassName`             | Kubernetes [pod priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/)                | `""`   |
| `terminationGracePeriodSeconds` | Kubernetes [termination grace period](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/)           | `120`  |
| `prometheusEnabled`             | If Prometheus scrape is enabled                                                                                            | `true` |

### Docker registry settings

| Name                    | Description                     | Value                                      |
| ----------------------- | ------------------------------- | ------------------------------------------ |
| `api.image.repository`  | API service image repository    | `2gis-on-premise/navi-restrictions-api`    |
| `api.image.pullPolicy`  | API service pull policy         | `IfNotPresent`                             |
| `api.image.tag`         | API service image tag           | `1.0.1`                                    |
| `cron.image.repository` | Syncer service image repository | `2gis-on-premise/navi-restrictions-syncer` |
| `cron.image.pullPolicy` | Syncer service pull policy      | `IfNotPresent`                             |
| `cron.image.tag`        | Syncer service image tag        | `1.0.1`                                    |

### Service account settings

| Name                         | Description                                                                                                            | Value   |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created                                                                  | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account                                                                              | `{}`    |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template | `""`    |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                         | Value  |
| -------------------- | --------------------------------------------------- | ------ |
| `pdb.enabled`        | If PDB is enabled for the service                   | `true` |
| `pdb.minAvailable`   | How many pods must be available after the eviction  | `""`   |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction | `1`    |

### Strategy settings

| Name                                    | Description                                                                                                                                                                                             | Value           |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`                                                                                                                                     | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process                     | `1`             |

### API service settings

| Name                      | Description                                                                                                                   | Value       |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `api.key`                 | API key **required**                                                                                                          | `""`        |
| `api.debug`               | If the debug mode is enabled                                                                                                  | `false`     |
| `api.isInitDb`            | If `true` and the database does not exist, it will be created                                                                 | `true`      |
| `api.attractorUrl`        | URL of Navi-Back service, example: `http://restrictions-api.host/attract` **required**                                        | `""`        |
| `api.securityContext`     | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)                     | `{}`        |
| `api.service`             | **Service settings.**                                                                                                         |             |
| `api.service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) | `ClusterIP` |
| `api.service.port`        | Service port                                                                                                                  | `80`        |
| `api.service.targetPort`  | Port inside the container                                                                                                     | `8000`      |
| `api.service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)              | `{}`        |
| `api.service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)                        | `{}`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                     | Description                              | Value                           |
| ---------------------------------------- | ---------------------------------------- | ------------------------------- |
| `api.ingress.enabled`                    | If Ingress is enabled for the service    | `false`                         |
| `api.ingress.className`                  | Name of the Ingress controller class     | `nginx`                         |
| `api.ingress.hosts[0].host`              | Hostname for the Ingress service         | `navi-restrictions.example.com` |
| `api.ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service | `/`                             |
| `api.ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service | `Prefix`                        |
| `api.ingress.tls`                        | TLS configuration                        | `[]`                            |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                          | Description                                                                                                                                                         | Value   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `api.hpa.enabled`                             | If HPA is enabled for the service                                                                                                                                   | `false` |
| `api.hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down                                                                                       | `1`     |
| `api.hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up                                                                                         | `2`     |
| `api.hpa.scaleDownStabilizationWindowSeconds` | Scale-down window                                                                                                                                                   | `""`    |
| `api.hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window                                                                                                                                                     | `""`    |
| `api.hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used       | `80`    |
| `api.hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used | `""`    |

### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                        | Description                                                                                                 | Value    |
| --------------------------- | ----------------------------------------------------------------------------------------------------------- | -------- |
| `api.vpa.enabled`           | If VPA is enabled for the service                                                                           | `false`  |
| `api.vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start) | `Auto`   |
| `api.vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down                                   | `500m`   |
| `api.vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down                                         | `256Mi`  |
| `api.vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up                                     | `2000m`  |
| `api.vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up                                           | `1024Mi` |

### Database settings

| Name          | Description                           | Value  |
| ------------- | ------------------------------------- | ------ |
| `db.host`     | PostgreSQL host **required**          | `""`   |
| `db.port`     | PostgreSQL port                       | `5432` |
| `db.name`     | PostgreSQL database name **required** | `""`   |
| `db.user`     | PostgreSQL username **required**      | `""`   |
| `db.password` | PostgreSQL password. **required**     | `""`   |

### Cron job settings

| Name                              | Description                                                              | Value                                                                        |
| --------------------------------- | ------------------------------------------------------------------------ | ---------------------------------------------------------------------------- |
| `cron.enabled`                    | If Cron job is enabled                                                   | `false`                                                                      |
| `cron.schedule`                   | Cron job schedule                                                        | `1 * * * *`                                                                  |
| `cron.concurrencyPolicy`          | Cron job concurrency policy: `Allow` or `Forbid`                         | `Forbid`                                                                     |
| `cron.successfulJobsHistoryLimit` | How many completed and failed jobs should be kept                        | `3`                                                                          |
| `cron.containerPort`              | Cron container port                                                      | `8000`                                                                       |
| `cron.edgesUrlTemplate`           | URL template for getting edges                                           | `http://navi-back.host/restrictions_json/{project}/{date_str}_{hour}.json`   |
| `cron.edgeAttributesUrlTemplate`  | URL template for getting an edge's details                               | `http://navi-back.host/edge?edge_id={edge_id}&offset=200&routing=carrouting` |
| `cron.projects`                   | List of projects to get data for                                         | `["moscow"]`                                                                 |
| `cron.maxAttributesFetcherRps`    | Maximum amount oif requests to `edge_attributes_url_template` per second | `25`                                                                         |

### Limits

| Name                             | Description                     | Value    |
| -------------------------------- | ------------------------------- | -------- |
| `api.resources`                  | **Limits for the API service**  |          |
| `api.resources.requests.cpu`     | A CPU request                   | `100m`   |
| `api.resources.requests.memory`  | A memory request                | `256Mi`  |
| `api.resources.limits.cpu`       | A CPU limit                     | `1000m`  |
| `api.resources.limits.memory`    | A memory limit                  | `1024Mi` |
| `cron.resources`                 | **Limits for the Cron service** |          |
| `cron.resources.requests.cpu`    | A CPU request                   | `100m`   |
| `cron.resources.requests.memory` | A memory request                | `256Mi`  |
| `cron.resources.limits.cpu`      | A CPU limit                     | `1000m`  |
| `cron.resources.limits.memory`   | A memory limit                  | `1024Mi` |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
