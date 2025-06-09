# VRP Solver Helm Chart

## Описание

Данный helm-чарт предназначен для установки экземпляра VRP Sovler.

Для работы сервиса требутся:

- s3
- kafka
- dm async

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                            | Description                                                                                                                           | Value |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `replicaCount`                  | A replica count for the pod.                                                                                                          | `1`   |
| `revisionHistoryLimit`          | Number of replica sets to keep for deployment rollbacks                                                                               | `1`   |
| `imagePullSecrets`              | Kubernetes image pull secrets.                                                                                                        | `[]`  |
| `nameOverride`                  | Base name to use in all the Kubernetes entities deployed by this chart.                                                               | `""`  |
| `fullnameOverride`              | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                           | `""`  |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                         | `{}`  |
| `podSecurityContext`            | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                        | `{}`  |
| `securityContext`               | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                            | `{}`  |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                   | `{}`  |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                     | `[]`  |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).           | `{}`  |
| `labels`                        | Custom labels to set to Deployment resource.                                                                                          | `{}`  |
| `priorityClassName`             | Kubernetes [Pod Priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass) class name. | `""`  |
| `preStopDelay`                  | Delay in seconds before terminating container.                                                                                        | `5`   |
| `terminationGracePeriodSeconds` | Maximum time allowed for graceful shutdown.                                                                                           | `60`  |

### Deployment settings

| Name               | Description | Value                             |
| ------------------ | ----------- | --------------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/navi-vrp-solver` |
| `image.tag`        | Tag         | `1.13.0`                          |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`                    |

### Navi VRP Solver application settings

| Name                 | Description                                                   | Value  |
| -------------------- | ------------------------------------------------------------- | ------ |
| `vrpSolver.cpu`      | Number of CPUs use for VRP Solver.                            | `1`    |
| `vrpSolver.logLevel` | Logging level, one of: DEBUG, INFO, WARNING, ERROR, CRITICAL. | `INFO` |

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
| `service.clusterIP`   | Controls Service cluster IP allocation. Cannot be changed after resource creation.                                             | `""`        |
| `service.port`        | Service port.                                                                                                                  | `80`        |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `nil`       |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                              | Value                         |
| ------------------------------------ | ---------------------------------------- | ----------------------------- |
| `ingress.className`                  | Name of the Ingress controller class     | `nginx`                       |
| `ingress.enabled`                    | If Ingress is enabled for the service    | `false`                       |
| `ingress.hosts[0].host`              | Hostname for the Ingress service         | `navi-vrp-solver.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service | `/`                           |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service | `Prefix`                      |
| `ingress.tls`                        | TLS configuration                        | `[]`                          |

### Limits

| Name                        | Description                                 | Value       |
| --------------------------- | ------------------------------------------- | ----------- |
| `resources`                 | Container resources requirements structure. | `{}`        |
| `resources.requests.cpu`    | CPU request, recommended value `1000m`.     | `undefined` |
| `resources.requests.memory` | Memory request, recommended value `2Gi`.    | `undefined` |
| `resources.limits.cpu`      | CPU limit, recommended value `3000m`.       | `undefined` |
| `resources.limits.memory`   | Memory limit, recommended value `8Gi`.      | `undefined` |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                    | Description                                                                                                                                                          | Value   |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                           | If HPA is enabled for the service.                                                                                                                                   | `false` |
| `hpa.minReplicas`                       | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`     |
| `hpa.maxReplicas`                       | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `10`    |
| `hpa.targetCPUUtilizationPercentage`    | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`    |
| `hpa.targetMemoryUtilizationPercentage` | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`    |
| `hpa.scaleUp`                           | Behavior settings for scaleUp.                                                                                                                                       | `nil`   |
| `hpa.scaleDown`                         | Behavior settings for scaleDown.                                                                                                                                     | `nil`   |

### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                    | Description                                                                                                  | Value   |
| ----------------------- | ------------------------------------------------------------------------------------------------------------ | ------- |
| `vpa.enabled`           | If VPA is enabled for the service.                                                                           | `false` |
| `vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start). | `Auto`  |
| `vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down.                                   |         |
| `vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down.                                         |         |
| `vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up.                                     |         |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up.                                           |         |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up.                                           |         |
| `vpa.containerName`     | Custom container name for VPA.                                                                               |         |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                          | Value   |
| -------------------- | ---------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service.                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`     |

### Kafka settings

| Name                                          | Description                                                                                                               | Value             |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| `kafka.groupId`                               | Navi VRP Solver group identifier.                                                                                         | `navi_vrp_solver` |
| `kafka.properties`                            | Properties as supported by kafka-python. Refer to inline comments for details.                                            |                   |
| `kafka.properties.bootstrap.servers`          | Kafka bootstrap connection string. **Required**                                                                           | `""`              |
| `kafka.fileProperties`                        | As kafka.properties, but kept in a file, which passed to application as a filename. Refer to inline comments for details. | `{}`              |
| `kafka.sensitiveProperties`                   | As kafka.properties, but kept in Secrets. Refer to inlines comments for details.                                          | `{}`              |
| `kafka.fileProperties`                        | As kafka.properties, but kept in a file, which passed to application as a filename. Refer to inline comments for details. | `{}`              |
| `kafka.consumerOverrides.properties`          | Consumer specific properties as simple key-value pairs.                                                                   | `{}`              |
| `kafka.consumerOverrides.sensitiveProperties` | Consumer specific properties mounted as secrets.                                                                          | `{}`              |
| `kafka.consumerOverrides.fileProperties`      | Consumer specific properties mounted as regular files.                                                                    | `{}`              |
| `kafka.producerOverrides.properties`          | Consumer specific properties as simple key-value pairs.                                                                   | `{}`              |
| `kafka.producerOverrides.sensitiveProperties` | Consumer specific properties mounted as secrets.                                                                          | `{}`              |
| `kafka.producerOverrides.fileProperties`      | Consumer specific properties mounted as regular files.                                                                    | `{}`              |
| `kafka.taskTopic`                             | Name of the topic for obtaining tasks. **Required**                                                                       | `""`              |
| `kafka.statusTopic`                           | Name of the topic for sending requests. **Required**                                                                      | `""`              |

### S3-compatible storage settings

| Name               | Description                                                       | Value |
| ------------------ | ----------------------------------------------------------------- | ----- |
| `s3.url`           | S3 endpoint URL. **Required**                                     | `""`  |
| `s3.publicUrl`     | Announce proxy URL for S3 results instead of s3.url if not empty. | `""`  |
| `s3.dm.bucket`     | S3 bucket name with DM Async results. **Required**                | `""`  |
| `s3.dm.accessKey`  | S3 access key for accessing the bucket. **Required**              | `""`  |
| `s3.dm.secretKey`  | S3 secret key for accessing the bucket. **Required**              | `""`  |
| `s3.vrp.bucket`    | S3 bucket name for VRP results. **Required**                      | `""`  |
| `s3.vrp.accessKey` | S3 access key for accessing the bucket. **Required**              | `""`  |
| `s3.vrp.secretKey` | S3 secret key for accessing the bucket. **Required**              | `""`  |

### Settings for interacting with Navi Back

| Name           | Description                                   | Value |
| -------------- | --------------------------------------------- | ----- |
| `naviBack.url` | Async Navi Backend endpoint URL. **Required** | `""`  |
| `naviBack.key` | Key for access to Navi Back. **Required**     | `""`  |
