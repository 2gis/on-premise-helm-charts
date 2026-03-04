# 2GIS Navi-Router service

Use this Helm chart to deploy Navi-Router service, which is a part of 2GIS's [On-Premise Navigation services](https://docs.2gis.com/en/on-premise/navigation).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

See the [documentation](https://docs.2gis.com/en/on-premise/navigation) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-router.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                            | Value |
| --------------------- | -------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port` | `""`  |

### Common settings

| Name                            | Description                                                                                                                                   | Value |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `replicaCount`                  | A replica count for the pod                                                                                                                   | `1`   |
| `revisionHistoryLimit`          | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment) | `3`   |
| `imagePullSecrets`              | Kubernetes image pull secrets                                                                                                                 | `[]`  |
| `nameOverride`                  | Base name to use in all the Kubernetes entities deployed by this chart                                                                        | `""`  |
| `fullnameOverride`              | Base fullname to use in all the Kubernetes entities deployed by this chart                                                                    | `""`  |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)                                  | `{}`  |
| `podSecurityContext`            | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)                                 | `{}`  |
| `securityContext`               | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)                                     | `{}`  |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)                            | `{}`  |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings                              | `[]`  |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity)                    | `{}`  |
| `preStopDelay`                  | Delay in seconds before terminating container                                                                                                 | `5`   |
| `terminationGracePeriodSeconds` | Grace period for container shutdown, refer to [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/) for details  | `60`  |
| `timezone`                      | Timezone for the router container. Refer to inline comments for details                                                                       | `UTC` |

### Deployment settings

| Name               | Description | Value                         |
| ------------------ | ----------- | ----------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/navi-router` |
| `image.tag`        | Tag         | `6.38.0.2`                    |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`                |

### Navi-Router service settings

| Name                                                       | Description                                                                                                                                                  | Value                                    |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------- |
| `router.appPort`                                           | Navi-Router service HTTP port                                                                                                                                | `8080`                                   |
| `router.logLevel`                                          | Logging level, one of: Verbose, Info, Warning, Error, Fatal. Default: `Warning`                                                                              | `Warning`                                |
| `router.logMessageField`                                   | Field name in logs                                                                                                                                           | `custom.navi_msg`                        |
| `router.additionalSections`                                | Additional configurations sections for the Navi-Router service                                                                                               | `""`                                     |
| `router.castleUrl`                                         | URL of Navi-Castle service. <br> This URL should be accessible from all the pods within your Kubernetes cluster                                              | `""`                                     |
| `router.citiesFilename`                                    | Name of the cities file on Castle                                                                                                                            | `cities.conf.zip`                        |
| `router.sentry.enabled`                                    | If sending crash dumps to Sentry needed                                                                                                                      | `false`                                  |
| `router.sentry.address`                                    | Sentry URL                                                                                                                                                   | `sentry.local`                           |
| `router.sentry.project`                                    | Sentry project ID                                                                                                                                            | `router`                                 |
| `router.sentry.username`                                   | Sentry username                                                                                                                                              | `navi`                                   |
| `router.sentry.printMessages`                              | If outgoing messages needed                                                                                                                                  | `false`                                  |
| `router.sentry.debug`                                      | Debugging switch                                                                                                                                             | `false`                                  |
| `router.sentry.reportPath`                                 | Local directory to dump                                                                                                                                      | `/tmp/sentry`                            |
| `router.sentry.handler`                                    | Handler file location                                                                                                                                        | `/usr/sbin/2gis/mosesd/crashpad_handler` |
| `router.localRestrictions.distanceBetweenPointsKm`         | Max allowed distance between points                                                                                                                          |                                          |
| `router.localRestrictions.pointsCount`                     | Max allowed points count                                                                                                                                     |                                          |
| `router.localRestrictions.matrixSize`                      | Max allowed matrix size                                                                                                                                      |                                          |
| `router.localRestrictions.privateRoutingWalkingDistanceKm` | Max allowed distance between points in different projects in pedestrian mode **FOR FUTURE RELEASE**                                                          |                                          |
| `router.backupPorts`                                       | Optional creation of backup ports duplicating the service                                                                                                    |                                          |
| `router.backupPorts.base`                                  | Backup ports start with `base` and assignd sequentially up                                                                                                   | `50000`                                  |
| `router.backupPorts.number`                                | Number of backup ports created                                                                                                                               | `0`                                      |
| `router.rulesUrl`                                          | URL of the rules file                                                                                                                                        |                                          |
| `navigroup`                                                | Service group identifier, allows multiple stacks deployed to the same namespace                                                                              | `""`                                     |
| `rules`                                                    | List of routing rules, refer to full [documentation](https://docs.2gis.com/en/on-premise/deployment/navigation#nav-lvl1--3._Create_a_rules_file) for details | `[]`                                     |

### Key management service settings

| Name                      | Description                                                                           | Value       |
| ------------------------- | ------------------------------------------------------------------------------------- | ----------- |
| `keys.enabled`            | Disable or enable key management service                                              | `false`     |
| `keys.url`                | API keys service URL, ex: http://keys-service-api.svc/service/v1/keys                 | `""`        |
| `keys.refreshIntervalSec` | Keys refresh interval in seconds                                                      | `30`        |
| `keys.downloadTimeoutSec` | Keys download timeout in seconds                                                      | `30`        |
| `keys.commonToken`        | Mater key to retrieve all per-service API keys, keys.apis ignored, if commonToken set | `""`        |
| `keys.apis`               | Used API types and their tokens. Format: `type: token`                                | `undefined` |

### Service account settings

| Name                         | Description                                                                                                            | Value   |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created                                                                  | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account                                                                              | `{}`    |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template | `""`    |

### Strategy settings

| Name                                    | Description                                                                                                                                                                                             | Value           |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`                                                                                                                                     | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process                     | `1`             |

### Service settings

| Name                  | Description                                                                                                                   | Value       |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) | `ClusterIP` |
| `service.port`        | Service port                                                                                                                  | `80`        |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)                        | `nil`       |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                              | Value                     |
| ------------------------------------ | ---------------------------------------- | ------------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service    | `false`                   |
| `ingress.className`                  | Name of the Ingress controller class     | `nginx`                   |
| `ingress.hosts[0].host`              | Hostname for the Ingress service         | `navi-router.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service | `/`                       |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service | `Prefix`                  |
| `ingress.tls`                        | TLS configuration                        | `[]`                      |

### Limits

| Name                        | Description                                | Value       |
| --------------------------- | ------------------------------------------ | ----------- |
| `resources`                 | Container resources requirements structure | `{}`        |
| `resources.requests.cpu`    | CPU request, recommended value `500m`      | `undefined` |
| `resources.requests.memory` | Memory request, recommended value `384Mi`  | `undefined` |
| `resources.limits.cpu`      | CPU limit, recommended value `1000m`       | `undefined` |
| `resources.limits.memory`   | Memory limit, recommended value `768Mi`    | `undefined` |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                    | Description                                                                                                                                                         | Value   |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                           | If HPA is enabled for the service                                                                                                                                   | `false` |
| `hpa.minReplicas`                       | Lower limit for the number of replicas to which the autoscaler can scale down                                                                                       | `1`     |
| `hpa.maxReplicas`                       | Upper limit for the number of replicas to which the autoscaler can scale up                                                                                         | `100`   |
| `hpa.targetCPUUtilizationPercentage`    | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used       | `80`    |
| `hpa.targetMemoryUtilizationPercentage` | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used | `""`    |
| `hpa.scaleUp`                           | To configure separate scale-up [policy](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#scaling-policies)                                | `{}`    |
| `hpa.scaleDown`                         | To configure separate scale-down [policy](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#scaling-policies)                              | `{}`    |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                         | Value   |
| -------------------- | --------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction | `1`     |

### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                    | Description                                                                                                 | Value   |
| ----------------------- | ----------------------------------------------------------------------------------------------------------- | ------- |
| `vpa.enabled`           | If VPA is enabled for the service                                                                           | `false` |
| `vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start) | `Auto`  |
| `vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down                                   | `500m`  |
| `vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down                                         | `128Mi` |
| `vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up                                     | `2000`  |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up                                           | `512Mi` |

### Requests sign check. **FOR FUTURE RELEASE**

| Name                            | Description                                             | Value |
| ------------------------------- | ------------------------------------------------------- | ----- |
| `requestsSignCheck.enabledKeys` | Array of keys and salt id mappings                      | `[]`  |
| `requestsSignCheck.hashSalt`    | id:salt mappings for verifying requests signature       | `{}`  |
| `requestsSignCheck.keys`        | List of keys for verifying requests sign **DEPRECATED** | `[]`  |
| `requestsSignCheck.salt`        | Salt for verifying requests sign. **DEPRECATED**        | `""`  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
