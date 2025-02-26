# Attractor Helm Chart

## Description

Данный helm-чарт предназначен для установки экземпляра Attractor, который позволяет обслуживать запросы, исходя из файла *rules.conf*

Файл *rules.conf* повторяет содержимое аналогичного файла из navi-back.
Attractor не имеет смысла без сервиса navi-back.


## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                                 | Description                                                                                                                 | Value  |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------- | ------ |
| `replicaCount`                       | A replica count for the pod.                                                                                                | `1`    |
| `revisionHistoryLimit`               | Number of replica sets to keep for deployment rollbacks                                                                     | `1`    |
| `imagePullSecrets`                   | Kubernetes image pull secrets.                                                                                              | `[]`   |
| `nameOverride`                       | Base name to use in all the Kubernetes entities deployed by this chart.                                                     | `""`   |
| `fullnameOverride`                   | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                 | `""`   |
| `podAnnotations`                     | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`   |
| `podSecurityContext`                 | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).              | `{}`   |
| `securityContext`                    | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                  | `{}`   |
| `nodeSelector`                       | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).         | `{}`   |
| `tolerations`                        | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.           | `[]`   |
| `affinity`                           | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). | `{}`   |
| `labels`                             | Custom labels to set to Deployment resource.                                                                                | `{}`   |
| `preStopDelay`                       | Delay in seconds before terminating container.                                                                              | `5`    |
| `terminationGracePeriodSeconds`      | Maximum time allowed for graceful shutdown.                                                                                 | `60`   |
| `extraVolumes`                       | Optionally specify extra list of additional volumes                                                                         | `[]`   |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts                                                                    | `[]`   |
| `initContainers`                     | Add additional init containers                                                                                              | `[]`   |
| `sidecars`                           | Add additional sidecar containers                                                                                           | `[]`   |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                                                        | `true` |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                     | `0`    |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                            | `5`    |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                           | `3`    |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                         | `5`    |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                         | `1`    |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                                                       | `true` |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                    | `0`    |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                           | `5`    |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                          | `3`    |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                        | `2`    |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                        | `1`    |
| `startupProbe.enabled`               | Enable startupProbe                                                                                                         | `true` |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                                      | `0`    |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                                             | `5`    |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                                            | `5`    |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                                          | `100`  |
| `startupProbe.successThreshold`      | Success threshold for startupProbe                                                                                          | `1`    |
| `customLivenessProbe`                | Override default liveness probe                                                                                             | `{}`   |
| `customReadinessProbe`               | Override default readiness probe                                                                                            | `{}`   |
| `customStartupProbe`                 | Override default startup probe                                                                                              | `{}`   |
| `command`                            | Override default command                                                                                                    | `[]`   |
| `args`                               | Override default args                                                                                                       | `[]`   |

### Container image settings

| Name               | Description | Value                            |
| ------------------ | ----------- | -------------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/navi-attractor` |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`                   |
| `image.tag`        | Tag         | `7.27.1.2`                       |

### Service account settings

| Name                         | Description                                                                                                             | Value   |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                                                  | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account.                                                                              | `{}`    |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |

### Service settings

| Name                       | Description                                                                                                                    | Value       |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.labels`           | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `service.annotations`      | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.http.port`        | Service HTTP port.                                                                                                             | `80`        |
| `service.http.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.http.clusterIP`   | Controls Service cluster IP allocation. Cannot be changed after resource creation.                                             | `""`        |
| `service.http.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `service.http.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.grpc.port`        | Service GRPC port.                                                                                                             | `50051`     |
| `service.grpc.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.grpc.clusterIP`   | Controls Service cluster IP allocation. Cannot be changed after resource creation.                                             | `None`      |
| `service.grpc.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `service.grpc.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                              | Value                        |
| ------------------------------------ | ---------------------------------------- | ---------------------------- |
| `ingress.className`                  | Name of the Ingress controller class     | `nginx`                      |
| `ingress.enabled`                    | If Ingress is enabled for the service    | `false`                      |
| `ingress.hosts[0].host`              | Hostname for the Ingress service         | `navi-attractor.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service | `/`                          |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service | `Prefix`                     |
| `ingress.tls`                        | TLS configuration                        | `[]`                         |

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
| `hpa.maxReplicas`                       | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `100`   |
| `hpa.scaleDown`                         | Scale-down settings structure                                                                                                                                        | `""`    |
| `hpa.scaleUp`                           | Scale-up settings structure                                                                                                                                          | `""`    |
| `hpa.targetCPUUtilizationPercentage`    | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`    |
| `hpa.targetMemoryUtilizationPercentage` | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`    |

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

### Navi-Attractor application settings

| Name                              | Description                                                                                                             | Value             |
| --------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ----------------- |
| `attractor.appPort`               | Container port for HTTP interface                                                                                       | `8080`            |
| `attractor.handlersNumber`        | Total number of HTTP/GRPC handlers.                                                                                     | `20`              |
| `attractor.maxProcessTime`        | Maximum processing time limit in minutes.                                                                               | `20`              |
| `attractor.responseTimelimit`     | Maximum response time limit in minutes.                                                                                 | `120`             |
| `attractor.requestTimeout`        | Maximum request time limit in minutes.                                                                                  | `120`             |
| `attractor.dump.result`           | Dump results in logs.                                                                                                   | `true`            |
| `attractor.dump.query`            | Dump queries in logs.                                                                                                   | `true`            |
| `attractor.dump.answer`           | Dump answers in logs.                                                                                                   | `false`           |
| `attractor.logLevel`              | Logging level, one of: Verbose, Info, Warning, Error, Fatal.                                                            | `Info`            |
| `attractor.logMessageField`       | Field name in logs for messages data.                                                                                   | `custom.navi_msg` |
| `attractor.grpcPort`              | Container port for gRPC interface                                                                                       | `50051`           |
| `attractor.indexFilename`         | Name of the index file on Castle                                                                                        | `index.json.zip`  |
| `attractor.citiesFilename`        | Name of the cities file on Castle                                                                                       | `cities.conf.zip` |
| `attractor.indices`               | List of dynamic indices kill switches.                                                                                  |                   |
| `attractor.overrideConfig`        | Complete config override. For test purposes only.                                                                       | `""`              |
| `attractor.rtr.enabled`           | Enable real time restrictions.                                                                                          | `false`           |
| `attractor.rtr.url`               | URL real time restrictions server.                                                                                      | `""`              |
| `attractor.rtr.updatePeriod`      | Update period from real time restrictions server.                                                                       | `60`              |
| `attractor.tilesMetricsThreshold` | The value at which we send tiles metrics (used for internal tests).                                                     | `0`               |
| `navigroup`                       | Routing group identifier, needed only if multiple navi-front/navi-router installations performed to the same namespace. | `""`              |
| `app_rule`                        | Item name from `rules` list to load rules from.                                                                         | `""`              |
| `app_project`                     | Do not use, configure with `rules` and `app_rule` instead.                                                              | `""`              |

### Kafka settings for interacting with Distance Matrix Async Service

| Name                                             | Description                                                                                                              | Value            |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| `kafka.enabled`                                  | If the Kafka is enabled                                                                                                  | `false`          |
| `kafka.groupId`                                  | Navi-Attractor service group identifier                                                                                  | `navi_attractor` |
| `kafka.handlersNumber`                           | Number of Kafka handlers                                                                                                 | `2`              |
| `kafka.properties`                               | Properties as supported by librdkafka. Refer to inline comments for details                                              |                  |
| `kafka.fileProperties`                           | As kafka.properties, but kept in a file, which passed to application as a filename. Refer to inline comments for details | `{}`             |
| `kafka.distanceMatrix`                           | **Settings for interacting with Distance Matrix Async service**                                                          |                  |
| `kafka.distanceMatrix.taskTopic`                 | Name of the topic for receiving new tasks from Distance Matrix Async API                                                 | `""`             |
| `kafka.distanceMatrix.cancelTopic`               | Name of the topic for canceling or receiving information about finished tasks                                            | `""`             |
| `kafka.distanceMatrix.statusTopic`               | Name of the topic for receiving task status information                                                                  | `""`             |
| `kafka.distanceMatrix.updateTaskStatusPeriodSec` | Update period for task statuses                                                                                          | `120`            |
| `kafka.distanceMatrix.messageExpiredPeriodSec`   | Update period for task cancellations                                                                                     | `3600`           |
| `kafka.distanceMatrix.requestDownloadTimeoutSec` | Timeout for downloading request data                                                                                     | `20`             |
| `kafka.distanceMatrix.responseUploadTimeoutSec`  | Timeout for uploading response data                                                                                      | `40`             |

### S3-compatible storage settings for interacting with Distance Matrix Async Service

| Name           | Description                                  | Value   |
| -------------- | -------------------------------------------- | ------- |
| `s3.enabled`   | if S3 storage is enabled                     | `false` |
| `s3.host`      | S3 endpoint                                  | `""`    |
| `s3.bucket`    | S3 bucket name                               | `""`    |
| `s3.accessKey` | S3 access key for accessing the bucket       | `""`    |
| `s3.secretKey` | S3 secret key for accessing the bucket       | `""`    |
| `s3.suffix`    | String to be prepended to file name in reply | `""`    |

### Back-end and attractor group properties. Leave with defaults, FOR FUTURE RELEASE.

| Name                  | Description                                      | Value         |
| --------------------- | ------------------------------------------------ | ------------- |
| `dataGroup.enabled`   | if grouping enabled                              | `false`       |
| `dataGroup.prefix`    | common prefix for the group used for identifiers | `sampleGroup` |
| `dataGroup.timestamp` | data timestamp the group is running on           | `no-default`  |


## Usage example

```
helm upgrade --install --dependency-update test-attractor .
```
