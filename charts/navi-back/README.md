# Mosesd Helm Chart
## Описание
Данный helm-чарт предназначен для установки экземпляра Mosesd, который позволяет обслуживать запросы, исходя из файла *rules.conf*

## Файл *rules.conf*
Является важнейшим файлом, описывающим правила и проекты, которые будет обслуживать разворачиваемый экземпляр Mosesd.
Пример файла *rules.conf*:
```
[
  {
    "name": "ukhta_cr",
    "router_projects": [
        "ukhta"
    ],
    "moses_projects": [
        "ukhta"
    ],
    "projects": [
        "ukhta"
    ],
    "queries": [
        "routing"
    ],
    "routing": [
        "driving"
    ]
  }
]
```
В данном примере создается правило ukhta_cr, содержащее регион Ухта с типом запроса "routing" и видом роутина "driving".
Значение поля "name" передается экземпляру mosesd через переменную окружения *RULE*, вследствие чего mosesd выкачивает проекты для Ухты и обслуживает только для этого региона - Ухта.

Содержимое *rules.conf* передаётся параметром `rules` или файл подкладывается в директорию с helm-чартом.


## Values

### Docker Registry settings

| Name                  | Description                                                                            | Value |
| --------------------- | -------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port` | `""`  |

### Common settings

| Name                                 | Description                                                                                                                          | Value  |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ | ------ |
| `replicaCount`                       | A replica count for the pod                                                                                                          | `1`    |
| `revisionHistoryLimit`               | Number of replica sets to keep for deployment rollbacks                                                                              | `1`    |
| `imagePullSecrets`                   | Kubernetes image pull secrets                                                                                                        | `[]`   |
| `nameOverride`                       | Base name to use in all the Kubernetes entities deployed by this chart                                                               | `""`   |
| `fullnameOverride`                   | Base fullname to use in all the Kubernetes entities deployed by this chart                                                           | `""`   |
| `podAnnotations`                     | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)                         | `{}`   |
| `podSecurityContext`                 | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)                        | `{}`   |
| `securityContext`                    | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)                            | `{}`   |
| `nodeSelector`                       | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)                   | `{}`   |
| `tolerations`                        | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings                     | `[]`   |
| `affinity`                           | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity)           | `{}`   |
| `labels`                             | Custom labels to set to Deployment resource                                                                                          | `{}`   |
| `priorityClassName`                  | Kubernetes [Pod Priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass) class name | `""`   |
| `preStopDelay`                       | Delay in seconds before terminating container                                                                                        | `5`    |
| `terminationGracePeriodSeconds`      | Maximum time allowed for graceful shutdown                                                                                           | `60`   |
| `extraVolumes`                       | Optionally specify extra list of additional volumes                                                                                  | `[]`   |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts                                                                             | `[]`   |
| `initContainers`                     | Add additional init containers                                                                                                       | `[]`   |
| `sidecars`                           | Add additional sidecar containers                                                                                                    | `[]`   |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                                                                 | `true` |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                              | `0`    |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                                     | `5`    |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                                    | `3`    |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                                  | `2`    |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                                  | `1`    |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                                                                | `true` |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                             | `0`    |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                                    | `5`    |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                                   | `3`    |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                                 | `2`    |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                                 | `1`    |
| `startupProbe.enabled`               | Enable startupProbe                                                                                                                  | `true` |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                                               | `0`    |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                                                      | `5`    |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                                                     | `5`    |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                                                   | `360`  |
| `startupProbe.successThreshold`      | Success threshold for startupProbe                                                                                                   | `1`    |
| `customLivenessProbe`                | Override default liveness probe                                                                                                      | `{}`   |
| `customReadinessProbe`               | Override default readiness probe                                                                                                     | `{}`   |
| `customStartupProbe`                 | Override default startup probe                                                                                                       | `{}`   |
| `command`                            | Override default command                                                                                                             | `[]`   |
| `args`                               | Override default args                                                                                                                | `[]`   |

### Container image settings

| Name               | Description | Value          |
| ------------------ | ----------- | -------------- |
| `image.repository` | Repository  | `2gis/mosesd`  |
| `image.tag`        | Tag         | `master`       |
| `image.pullPolicy` | Pull Policy | `IfNotPresent` |

### Navi-Back application settings

| Name                                                    | Description                                                                                                                                                                                                         | Value                                    |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `naviback.ecaHost`                                      | DEPRECATED: Use naviback.ecaUrl. Domain name of the [Traffic Proxy service](https://docs.2gis.com/en/on-premise/traffic-proxy). <br> This URL should be accessible from all the pods within your Kubernetes cluster |                                          |
| `naviback.ecaUrl`                                       | URL of the [Traffic Proxy service](https://docs.2gis.com/en/on-premise/traffic-proxy). <br> This URL should be accessible from all the pods within your Kubernetes cluster                                          |                                          |
| `naviback.forecastHost`                                 | URL of Traffic forecast service. See the [Traffic Proxy service](https://docs.2gis.com/en/on-premise/traffic-proxy). <br> This URL should be accessible from all the pods within your Kubernetes cluster            |                                          |
| `naviback.dmSourcesLimit`                               | Size limit for source matrices                                                                                                                                                                                      | `1000`                                   |
| `naviback.dmTargetsLimit`                               | Size limit for target matrices                                                                                                                                                                                      | `1000`                                   |
| `naviback.handlersNumber`                               | Total number of HTTP/GRPC handlers                                                                                                                                                                                  | `1`                                      |
| `naviback.queueSize`                                    | Internal queue size                                                                                                                                                                                                 | `128`                                    |
| `naviback.maxProcessTime`                               | Maximum processing time limit in minutes                                                                                                                                                                            | `20`                                     |
| `naviback.responseTimelimit`                            | Maximum response time limit in minutes                                                                                                                                                                              | `120`                                    |
| `naviback.requestTimeout`                               | Maximum request time limit in minutes                                                                                                                                                                               | `120`                                    |
| `naviback.timeoutLimitSec`                              | Maximum downloading time can be reached after failures                                                                                                                                                              | `1200`                                   |
| `naviback.timeoutIncrementSec`                          | Downloading time increment after failures                                                                                                                                                                           | `140`                                    |
| `naviback.totalRetryDurationSec`                        | Downloading timeout with all failure retries                                                                                                                                                                        | `2400`                                   |
| `naviback.initialRetryIntervalSec`                      | Initial timeout for a failure retry                                                                                                                                                                                 | `2`                                      |
| `naviback.dump.result`                                  | Dump results in logs                                                                                                                                                                                                | `false`                                  |
| `naviback.dump.query`                                   | Dump queries in logs                                                                                                                                                                                                | `false`                                  |
| `naviback.dump.answer`                                  | Dump answers in logs                                                                                                                                                                                                | `false`                                  |
| `naviback.logLevel`                                     | Logging level, one of: Verbose, Info, Warning, Error, Fatal                                                                                                                                                         | `Info`                                   |
| `naviback.indexFilename`                                | Name of the index file on Castle                                                                                                                                                                                    | `index.json.zip`                         |
| `naviback.citiesFilename`                               | Name of the cities file on Castle                                                                                                                                                                                   | `cities.conf.zip`                        |
| `naviback.sentry.enabled`                               | If sending crash dumps to Sentry needed                                                                                                                                                                             | `false`                                  |
| `naviback.sentry.address`                               | Sentry URL                                                                                                                                                                                                          | `sentry.local`                           |
| `naviback.sentry.project`                               | Sentry project ID                                                                                                                                                                                                   | `navi-back`                              |
| `naviback.sentry.username`                              | Sentry username                                                                                                                                                                                                     | `navi`                                   |
| `naviback.sentry.printMessages`                         | If outgoing messages needed                                                                                                                                                                                         | `false`                                  |
| `naviback.sentry.debug`                                 | Debugging switch                                                                                                                                                                                                    | `false`                                  |
| `naviback.sentry.reportPath`                            | Local directory to dump                                                                                                                                                                                             | `/tmp/sentry`                            |
| `naviback.sentry.handler`                               | Handler file location                                                                                                                                                                                               | `/usr/sbin/2gis/mosesd/crashpad_handler` |
| `naviback.castleHost`                                   | DEPRECATED: Use naviback.castleUrl. Domain name of Navi-Castle service. <br> This URL should be accessible from all the pods within your Kubernetes cluster                                                         |                                          |
| `naviback.castleUrl`                                    | URL of Navi-Castle service. <br> This URL should be accessible from all the pods within your Kubernetes cluster                                                                                                     | `""`                                     |
| `naviback.enablePassableBarriers`                       | Consider passable barriers                                                                                                                                                                                          |                                          |
| `naviback.grpcPort`                                     | GRPC port to serve. Disabled if empty                                                                                                                                                                               |                                          |
| `naviback.disableUpdates`                               | Test switch for disabling runtime background updates                                                                                                                                                                | `false`                                  |
| `naviback.indices`                                      | List of dynamic indices kill switches                                                                                                                                                                               |                                          |
| `naviback.additionalSections`                           | Optinal JSON block to be added to config file as-is                                                                                                                                                                 |                                          |
| `naviback.simpleNetwork.bicycle`                        | Enable simple network for bicycle routing                                                                                                                                                                           |                                          |
| `naviback.simpleNetwork.car`                            | Enable simple network for auto routing                                                                                                                                                                              |                                          |
| `naviback.simpleNetwork.emergency`                      | Enable simple network for emergency vehicles routing                                                                                                                                                                |                                          |
| `naviback.simpleNetwork.pedestrian`                     | Enable simple network for pedestrian routing                                                                                                                                                                        |                                          |
| `naviback.simpleNetwork.taxi`                           | Enable simple network for taxi routing                                                                                                                                                                              |                                          |
| `naviback.simpleNetwork.truck`                          | Enable simple network for truck routing                                                                                                                                                                             |                                          |
| `naviback.simpleNetwork.scooter`                        | Enable simple network for scooters routing                                                                                                                                                                          |                                          |
| `naviback.attractor.bicycle`                            | Enable enhanced attractor for bicycle routing                                                                                                                                                                       |                                          |
| `naviback.attractor.car`                                | Enable enhanced attractor for auto routing                                                                                                                                                                          |                                          |
| `naviback.attractor.pedestrian`                         | Enable enhanced attractor for pedestrian routing                                                                                                                                                                    |                                          |
| `naviback.attractor.taxi`                               | Enable enhanced attractor for taxi routing                                                                                                                                                                          |                                          |
| `naviback.attractor.truck`                              | Enable enhanced attractor for truck routing                                                                                                                                                                         |                                          |
| `naviback.attractor.scooter`                            | Enable enhanced attractor for scooters routing                                                                                                                                                                      |                                          |
| `naviback.bss.enabled`                                  | Enable sending information on the construction of routes to the business statistics service                                                                                                                         | `false`                                  |
| `naviback.bss.client.serviceRemoteAddress`              | Remote address business statistics service. Requeruired for enable sending information                                                                                                                              | `""`                                     |
| `naviback.bss.client.messageCountToFlush`               | Message count to flush                                                                                                                                                                                              | `500`                                    |
| `naviback.bss.client.useCompression`                    | Enable compression                                                                                                                                                                                                  | `true`                                   |
| `naviback.bss.client.packageSizeMaxBytes`               | Package size max bytes                                                                                                                                                                                              | `1800000`                                |
| `naviback.bss.client.pendingTransmissionMaxCount`       | Pending transmission max count                                                                                                                                                                                      | `10`                                     |
| `naviback.bss.client.timeoutLimitMilSec`                | Maximum request time limit in milliseconds                                                                                                                                                                          | `5000`                                   |
| `naviback.reduceEdgesOptimizationFlag`                  | Enable optimizations for distance matrix queries processing                                                                                                                                                         |                                          |
| `naviback.behindSplitter`                               | The current instance is behind splitter or not                                                                                                                                                                      | `false`                                  |
| `naviback.overrideConfig`                               | Complete config override. For test purposes only                                                                                                                                                                    | `""`                                     |
| `naviback.rtr.enabled`                                  | Enable real time restrictions                                                                                                                                                                                       | `false`                                  |
| `naviback.rtr.url`                                      | URL real time restrictions server                                                                                                                                                                                   | `http://rtr`                             |
| `naviback.rtr.updatePeriod`                             | Update period from real time restrictions server                                                                                                                                                                    | `60`                                     |
| `naviback.validation.enabled`                           | Enable validation responses and requests (used for internal tests)                                                                                                                                                  | `false`                                  |
| `naviback.validation.ctx.schemasFolder`                 | Path to folder with ctx JSON schemas                                                                                                                                                                                | `/usr/share/2gis/schemas/nsr_schemas`    |
| `naviback.validation.ctx.requestSchemaName`             | Name of ctx request validation schema                                                                                                                                                                               | `CTXRequestModel.json`                   |
| `naviback.validation.ctx.responseSchemaName`            | Name of ctx response validation schema                                                                                                                                                                              | `CTXResponseModelV4.json`                |
| `naviback.validation.bss.schemasFolder`                 | Path to folder with bss JSON schemas                                                                                                                                                                                | `/usr/share/2gis/schemas/bss_schemas`    |
| `naviback.validation.bss.requestSchemaName`             | Name of bss request validation schema                                                                                                                                                                               | `""`                                     |
| `naviback.validation.bss.responseSchemaName`            | Name of bss response validation schema                                                                                                                                                                              | `401.schema.json`                        |
| `naviback.validation.distanceMatrix.schemasFolder`      | Path to folder with distance matrix JSON schemas                                                                                                                                                                    | `/usr/share/2gis/schemas/nsr_schemas`    |
| `naviback.validation.distanceMatrix.requestSchemaName`  | Name of distance matrix request validation schema                                                                                                                                                                   | `DistanceMatrixRequestModel.json`        |
| `naviback.validation.distanceMatrix.responseSchemaName` | Name of distance matrix response validation schema                                                                                                                                                                  | `DistanceMatrixResponseModel.json`       |
| `naviback.validation.isochrone.schemasFolder`           | Path to folder with isochrone JSON schemas                                                                                                                                                                          | `/usr/share/2gis/schemas/nsr_schemas`    |
| `naviback.validation.isochrone.requestSchemaName`       | Name of isochrone request validation schema                                                                                                                                                                         | `IsochroneApiRequestModel.json`          |
| `naviback.validation.isochrone.responseSchemaName`      | Name of isochrone response validation schema                                                                                                                                                                        | `IsochroneApiResponseModel.json`         |
| `naviback.tilesMetricsThreshold`                        | The value at which we send tiles metrics (used for internal tests)                                                                                                                                                  | `0`                                      |
| `naviback.hierarchies.enabled`                          | If hierarchies cache available                                                                                                                                                                                      | `false`                                  |
| `naviback.hierarchies.s3path`                           | Hierarchies cache remote location                                                                                                                                                                                   | `""`                                     |
| `naviback.etaScheduleIndex.enabled`                     | If Schedule Index available                                                                                                                                                                                         | `false`                                  |
| `naviback.etaScheduleIndex.url`                         | Schedule Index remote url                                                                                                                                                                                           | `""`                                     |

### Envoy settings, ignored if not `transmitter.enabled`. Leave with defaults, FOR FUTURE RELEASE.

| Name                              | Description                                | Value                   |
| --------------------------------- | ------------------------------------------ | ----------------------- |
| `envoy.image.repository`          | Repository                                 | `2gis-on-premise/envoy` |
| `envoy.image.tag`                 | Tag                                        | `v1.27.0`               |
| `envoy.image.pullPolicy`          | Pull Policy                                | `IfNotPresent`          |
| `envoy.resources`                 | Container resources requirements structure | `{}`                    |
| `envoy.resources.requests.cpu`    | CPU request, recommended value `100m`      | `undefined`             |
| `envoy.resources.requests.memory` | Memory request, recommended value `100Mi`  | `undefined`             |
| `envoy.resources.limits.cpu`      | CPU limit, recommended value `100m`        | `undefined`             |
| `envoy.resources.limits.memory`   | Memory limit, recommended value `100Mi`    | `undefined`             |

### Service account settings

| Name                         | Description                                                                                                            | Value   |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created                                                                  | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account                                                                              | `{}`    |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template | `""`    |

### Service settings

| Name                           | Description                                                                                                                   | Value       |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `service.type`                 | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) | `ClusterIP` |
| `service.clusterIP`            | Controls Service cluster IP allocation. Cannot be changed after resource creation                                             | `""`        |
| `service.port`                 | Service port                                                                                                                  | `80`        |
| `service.grpcPort`             | Service GRPC port if `naviback.grpcPort` enabled                                                                              | `50051`     |
| `service.annotations`          | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)              | `{}`        |
| `service.labels`               | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)                        | `nil`       |
| `service.extraPorts`           | Extra ports to expose in the service (normally used with the `sidecar` value)                                                 | `[]`        |
| `service.headless.enabled`     | Enable creating a secondary headless service                                                                                  | `false`     |
| `service.headless.annotations` | Annotations for secondary headless service                                                                                    | `{}`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                              | Value                   |
| ------------------------------------ | ---------------------------------------- | ----------------------- |
| `ingress.className`                  | Name of the Ingress controller class     | `nginx`                 |
| `ingress.enabled`                    | If Ingress is enabled for the service    | `false`                 |
| `ingress.hosts[0].host`              | Hostname for the Ingress service         | `navi-back.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service | `/`                     |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service | `Prefix`                |
| `ingress.tls`                        | TLS configuration                        | `[]`                    |

### Limits

| Name                        | Description                                | Value       |
| --------------------------- | ------------------------------------------ | ----------- |
| `resources`                 | Container resources requirements structure | `{}`        |
| `resources.requests.cpu`    | CPU request, recommended value `1000m`     | `undefined` |
| `resources.requests.memory` | Memory request, recommended value `2Gi`    | `undefined` |
| `resources.limits.cpu`      | CPU limit, recommended value `3000m`       | `undefined` |
| `resources.limits.memory`   | Memory limit, recommended value `8Gi`      | `undefined` |

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

| Name                    | Description                                                                                                 | Value   |
| ----------------------- | ----------------------------------------------------------------------------------------------------------- | ------- |
| `vpa.enabled`           | If VPA is enabled for the service                                                                           | `false` |
| `vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start) | `Auto`  |
| `vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down                                   |         |
| `vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down                                         |         |
| `vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up                                     |         |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up                                           |         |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                         | Value   |
| -------------------- | --------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction | `1`     |

### Kafka settings for interacting with Distance Matrix Async Service

| Name                                             | Description                                                                                                              | Value          |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ | -------------- |
| `kafka.enabled`                                  | If the Kafka is enabled                                                                                                  | `false`        |
| `kafka.groupId`                                  | Navi-Back service group identifier                                                                                       | `navi_back`    |
| `kafka.handlersNumber`                           | Number of Kafka handlers                                                                                                 | `2`            |
| `kafka.properties`                               | Properties as supported by librdkafka. Refer to inline comments for details                                              |                |
| `kafka.fileProperties`                           | As kafka.properties, but kept in a file, which passed to application as a filename. Refer to inline comments for details | `{}`           |
| `kafka.distanceMatrix`                           | **Settings for interacting with Distance Matrix Async service.**                                                         |                |
| `kafka.distanceMatrix.taskTopic`                 | Name of the topic for receiving new tasks from Distance Matrix Async API                                                 | `task_topic`   |
| `kafka.distanceMatrix.cancelTopic`               | Name of the topic for canceling or receiving information about finished tasks                                            | `cancel_topic` |
| `kafka.distanceMatrix.statusTopic`               | Name of the topic for receiving task status information                                                                  | `status_topic` |
| `kafka.distanceMatrix.updateTaskStatusPeriodSec` | Update period for task statuses                                                                                          | `120`          |
| `kafka.distanceMatrix.messageExpiredPeriodSec`   | Update period for task cancellations                                                                                     | `3600`         |
| `kafka.distanceMatrix.requestDownloadTimeoutSec` | Timeout for downloading request data                                                                                     | `20`           |
| `kafka.distanceMatrix.responseUploadTimeoutSec`  | Timeout for uploading response data                                                                                      | `40`           |

### S3-compatible storage settings for interacting with Distance Matrix Async Service

| Name           | Description                               | Value   |
| -------------- | ----------------------------------------- | ------- |
| `s3.enabled`   | if S3 storage is enabled                  | `false` |
| `s3.host`      | S3 endpoint, ex: async-matrix-s3.host     | `""`    |
| `s3.bucket`    | S3 bucket name                            | `""`    |
| `s3.accessKey` | S3 access key for accessing the bucket    | `""`    |
| `s3.secretKey` | S3 secret key for accessing the bucket    | `""`    |
| `s3.suffix`    | String to append to file names in replies | `""`    |

### Settings for attractor connection. Leave with defaults, FOR FUTURE RELEASE.

| Name                            | Description                                                                                                                               | Value                        |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `transmitter.enabled`           | if attractor connection required                                                                                                          | `false`                      |
| `transmitter.type`              | connection type one of: grpc, grpc-async, grpc-stream, ws, ws-async                                                                       | `grpc-async-stream`          |
| `transmitter.host`              | attractor service                                                                                                                         | `http://navi-attractor.host` |
| `transmitter.port`              | attractor port                                                                                                                            | `50051`                      |
| `transmitter.responseTimeoutMs` | response waiting timeout                                                                                                                  | `2000`                       |
| `transmitter.retry.enabled`     | Enable retry failed requests                                                                                                              | `false`                      |
| `transmitter.retry.retryOn`     | Status [codes for retry](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/router_filter#x-envoy-retry-grpc-on) | `internal,unavailable`       |
| `transmitter.retry.numRetries`  | Specifies the allowed number of retries                                                                                                   | `5`                          |

### Back-end and attractor group properties. Leave with defaults, FOR FUTURE RELEASE.

| Name                  | Description                                      | Value         |
| --------------------- | ------------------------------------------------ | ------------- |
| `dataGroup.enabled`   | if grouping enabled                              | `false`       |
| `dataGroup.prefix`    | common prefix for the group used for identifiers | `sampleGroup` |
| `dataGroup.timestamp` | data timestamp the group is running on           | `no-default`  |

### License settings

| Name          | Description                                                | Value |
| ------------- | ---------------------------------------------------------- | ----- |
| `license.url` | Address of the License service v2. Ex: https://license.svc | `""`  |

### Metrics aggregator container. Leave with defaults, FOR FUTURE RELEASE.

| Name                                | Description                                     | Value                                |
| ----------------------------------- | ----------------------------------------------- | ------------------------------------ |
| `metrics.enabled`                   | Enable metrics container and scrape annotations | `false`                              |
| `metrics.image.repository`          | Repository                                      | `2gis-on-premise/metrics-aggregator` |
| `metrics.image.tag`                 | Tag                                             | `""`                                 |
| `metrics.image.pullPolicy`          | Pull Policy                                     | `IfNotPresent`                       |
| `metrics.port`                      | Port of container                               | `9090`                               |
| `metrics.resources`                 | Container resources requirements structure      | `{}`                                 |
| `metrics.resources.requests.cpu`    | CPU request, recommended value `10m`            | `undefined`                          |
| `metrics.resources.requests.memory` | Memory request, recommended value `10Mi`        |                                      |
| `metrics.resources.limits.cpu`      | CPU limit, recommended value `100m`             |                                      |
| `metrics.resources.limits.memory`   | Memory limit, recommended value `10Mi`          |                                      |


## Пример деплоя
Деплой mosesd для региона Даммам
1. Создать файл rules.conf в директории с helm-чартом
```
[
  {
    "name": "ukhta_cr",
    "router_projects": [
        "ukhta"
    ],
    "moses_projects": [
        "ukhta"
    ],
    "projects": [
        "ukhta"
    ],
    "queries": [
        "routing"
    ],
    "routing": [
        "driving"
    ]
  }
]
```
2. Создать файл ukhta_values.yaml со следующим содержимым:
```
affinity: "nodeAffinity:\n  preferredDuringSchedulingIgnoredDuringExecution:\n  - preference:\n      matchExpressions:\n      - key: cpu\n        operator: In\n        values:\n        - slow\n    weight: 50\n  - preference:\n      matchExpressions:\n      - key: role\n        operator: In\n        values:\n        - worker\n    weight: 20\n  requiredDuringSchedulingIgnoredDuringExecution: \n    nodeSelectorTerms:\n    - matchExpressions:\n      - key: role\n        operator: In\n        values:\n        - worker\npodAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n  - labelSelector:\n      matchExpressions:\n      - key: app.kubernetes.io/instance\n        operator: In\n        values:\n        - {{ .Release.Name }}\n    topologyKey: kubernetes.io/hostname\n"
autoscaling:
  enabled: "true"
  maxReplicas: 6
  minReplicas: 2
  scaleDownWindowsSeconds: 600
  scaleUpWindowSeconds: 300
  targetCPUUtilizationPercentage: 90
image:
  pullPolicy: IfNotPresent
  repository: docker-hub.2gis.ru/navi/mosesd
  tag: releases-navi-moses-6-3-0-ffe19b6f
mosesd:
  app_castle_host: castle1.m1.navi
  eca_host: eca1.m9.navi
  forecast_host: speeds-forecast-m9.d.s
  ftp_conn_string: UK.BuildFTP.Traffic:Nhfaabr!@buildftp.2gis.local/trafficedro
  rules_filename: rules.conf.dev
  app_rule: ukhta_cr
  type: carrouting
  server_id: '{{ include "generic-chart.fullname" . }}.m9'
replicaCount: 2
resources:
  limits:
    cpu: 2000m
    memory: 16000Mi
  requests:
    cpu: 1000m
    memory: 1024Mi
podAnnotations:
  prometheus.io/path: /metrics
  prometheus.io/port: "8080"
  prometheus.io/scrape: "true"
service:
  annotations:
    prometheus.io/probe: "true"
    prometheus.io/probe-path: /
    router.deis.io/domains: ukhta-cr
    router.deis.io/maintenance: "False"
  labels:
    router.deis.io/routable: "true"
tolerations:
  - key: cpu
    operator: Equal
    value: slow
```
3. Запусить установку helm-чарта
```
helm upgrade --install --dependency-update test-ukhta-cr . -f ukhta_values.yaml
```
4. Отправить POST-запрос на pod(в примере через port forwarding kubernetes):
```
kubectl port-forward test-ukhta-cr-mosesd-6864944c7-vrpns 7777:8080
```

```
ukhta_data.json:

{"locale":"ru","point_a_name":"Source","point_b_name":"Target","points":[{"type":"pedo","x":53.67348,"y":63.571784,"object_id":"70030076127900506"},{"type":"pedo","x":53.669005,"y":63.558914}],"purpose":"autoSearch","type":"online5","viewport":{"topLeft":{"x":53.64547555649268,"y":63.57189772727365},"bottomRight":{"x":53.72430944350733,"y":63.55683211146105},"zoom":14.771602140757102}}
```
Отправляем через curl например
```
curl -Lv http://localhost:7777/carrouting/6.0.0/global -d @ukhta_data.json
```

Примерный вариант ответ:
```
{"query":{"locale":"ru","point_a_name":"Source","point_b_name":"Target","points":[{"object_id":"70030076127900506","type":"pedo","x":53.67348,"y":63.571784},{"type":"pedo","x":53.669005,"y":63.558914}],"purpose":"autoSearch","type":"online5","viewport":{"bottomRight":{"x":53.72430944350733,"y":63.55683211146105},"topLeft":{"x":53.64547555649268,"y":63.57189772727365},"zoom":14.7716021407571}},"result":[{"algorithm":"с учётом пробок","begin_pedestrian_path":{"geometry":{"selection":"LINESTRING(53.673479 63.571784, 53.673621 63.571731)"}},"end_pedestrian_path":{"geometry":{"selection":"LINESTRING(53.669007 63.558917, 53.669005 63.558914)"}},"id":"3729920572486797516","maneuvers":[{"comment":"Source","icon":"start","id":"10755905698081772690","outcoming_path":{"distance":2326,"duration":252,"geometry":[{"color":"ignore","length":55,"selection":"LINESTRING(53.673621 63.571731, 53.673472 63.571605, 53.673395 63.571532)"},{"color":"fast","length":4900,"selection":"LINESTRING(53.673395 63.571532, 53.673386 63.571505, 53.673410 63.571494, 53.673439 63.571482, 53.673589 63.571421, 53.674036 63.571239, 53.674240 63.571155, 53.674244 63.571143, 53.674205 63.571133, 53.674141 63.571126, 53.674084 63.571118, 53.674036 63.571108, 53.673990 63.571094, 53.673941 63.571076, 53.673896 63.571057, 53.673857 63.571041, 53.673808 63.571020, 53.673708 63.570972, 53.673558 63.570897, 53.673430 63.570830, 53.673361 63.570788, 53.673333 63.570761, 53.673317 63.570731, 53.673310 63.570699, 53.673312 63.570666, 53.673321 63.570636, 53.673339 63.570607, 53.673366 63.570579, 53.673405 63.570552, 53.673462 63.570519, 53.673534 63.570481, 53.673601 63.570447, 53.673649 63.570425, 53.673810 63.570357, 53.674094 63.570237, 53.674183 63.570198, 53.674228 63.570171, 53.674285 63.570130, 53.674335 63.570085, 53.674367 63.570042, 53.674384 63.570002, 53.674393 63.569967, 53.674394 63.569936, 53.674382 63.569908, 53.674356 63.569881, 53.674326 63.569859, 53.674307 63.569846, 53.674290 63.569837, 53.674245 63.569817, 53.674167 63.569782, 53.674091 63.569745, 53.674042 63.569716, 53.674017 63.569693, 53.674004 63.569669, 53.674000 63.569646, 53.674000 63.569629, 53.674003 63.569620, 53.674011 63.569612, 53.674025 63.569599, 53.674082 63.569546, 53.674268 63.569371, 53.674367 63.569276, 53.674351 63.569256, 53.674281 63.569236, 53.674181 63.569219, 53.674102 63.569206, 53.673981 63.569186, 53.673459 63.569101, 53.673067 63.569037, 53.673003 63.569027, 53.672956 63.569019, 53.672790 63.568992, 53.672258 63.568905, 53.671988 63.568858, 53.671959 63.568825, 53.671957 63.568754, 53.671973 63.568664, 53.671986 63.568583, 53.671993 63.568511, 53.672000 63.568421, 53.672010 63.568304, 53.672019 63.568192, 53.672027 63.568114, 53.672035 63.568067, 53.672047 63.568027, 53.672064 63.567991, 53.672083 63.567959, 53.672102 63.567931, 53.672296 63.567680, 53.672714 63.567139, 53.672842 63.566973, 53.672858 63.566952, 53.672878 63.566927, 53.672979 63.566795, 53.673120 63.566612, 53.673153 63.566569, 53.673164 63.566555, 53.673172 63.566545, 53.673189 63.566523, 53.673222 63.566479, 53.673268 63.566420, 53.673317 63.566355, 53.673366 63.566289, 53.673401 63.566240, 53.673419 63.566212, 53.673429 63.566195, 53.673437 63.566178, 53.673445 63.566159, 53.673452 63.566137, 53.673457 63.566111, 53.673457 63.566083, 53.673450 63.566054, 53.673438 63.566026, 53.673427 63.566003, 53.673417 63.565984, 53.673405 63.565966, 53.673389 63.565946, 53.673361 63.565918, 53.673314 63.565874, 53.673256 63.565823, 53.673210 63.565785, 53.673166 63.565752, 53.673007 63.565640, 53.672868 63.565543, 53.672836 63.565520, 53.672809 63.565501, 53.672745 63.565455, 53.672525 63.565296, 53.672392 63.565201, 53.672345 63.565167, 53.672266 63.565110, 53.672165 63.565037, 53.672063 63.564964, 53.671965 63.564894, 53.671890 63.564840, 53.671838 63.564803, 53.671567 63.564609, 53.671100 63.564274, 53.670981 63.564188, 53.670954 63.564169, 53.670903 63.564133, 53.670549 63.563879, 53.670138 63.563584, 53.670065 63.563532, 53.670038 63.563513, 53.669949 63.563449, 53.669485 63.563116, 53.669124 63.562857, 53.669078 63.562825, 53.669053 63.562806, 53.669035 63.562790, 53.669042 63.562775, 53.669082 63.562760, 53.669307 63.562697, 53.669555 63.562628, 53.669615 63.562611, 53.669658 63.562599, 53.669729 63.562579, 53.669996 63.562506, 53.670199 63.562450, 53.670247 63.562437, 53.670289 63.562426, 53.670428 63.562387, 53.670862 63.562268, 53.671086 63.562206, 53.671162 63.562184, 53.671290 63.562149, 53.671433 63.562109, 53.671531 63.562082, 53.671643 63.562051, 53.672065 63.561935, 53.672368 63.561851, 53.672454 63.561827, 53.672601 63.561787, 53.672790 63.561734, 53.672958 63.561688, 53.673094 63.561650, 53.673228 63.561613, 53.673376 63.561572, 53.673523 63.561532, 53.673644 63.561498, 53.673739 63.561472, 53.673818 63.561450, 53.673890 63.561430, 53.673992 63.561402, 53.674161 63.561355, 53.674361 63.561300, 53.674499 63.561262, 53.674561 63.561245, 53.674599 63.561234, 53.674642 63.561222, 53.674984 63.561128, 53.675664 63.560940, 53.675868 63.560883, 53.675910 63.560871, 53.675975 63.560854, 53.676423 63.560730, 53.677021 63.560564, 53.677139 63.560529, 53.677156 63.560512, 53.677151 63.560482, 53.677096 63.560349, 53.677046 63.560229, 53.677034 63.560202, 53.677025 63.560180, 53.676983 63.560079, 53.676809 63.559664, 53.676703 63.559412, 53.676681 63.559358, 53.676644 63.559269, 53.676595 63.559152, 53.676545 63.559034, 53.676498 63.558920, 53.676450 63.558808, 53.676403 63.558696, 53.676355 63.558580, 53.676304 63.558457, 53.676234 63.558339, 53.676093 63.558270, 53.675875 63.558261, 53.675667 63.558276, 53.675549 63.558285, 53.675364 63.558299, 53.674937 63.558331, 53.674763 63.558344, 53.674714 63.558348, 53.674657 63.558352, 53.674308 63.558379, 53.673719 63.558423, 53.673561 63.558435, 53.673511 63.558439, 53.673428 63.558447, 53.672901 63.558500, 53.672296 63.558560, 53.672183 63.558571, 53.672129 63.558577, 53.672073 63.558582, 53.672031 63.558587, 53.672006 63.558592, 53.671992 63.558597, 53.671980 63.558602, 53.671971 63.558608, 53.671965 63.558615, 53.671961 63.558624, 53.671960 63.558638, 53.671961 63.558660, 53.671962 63.558685, 53.671959 63.558703, 53.671951 63.558713, 53.671941 63.558720, 53.671927 63.558726, 53.671912 63.558731, 53.671896 63.558734, 53.671861 63.558735, 53.671757 63.558728, 53.671581 63.558715, 53.671423 63.558702, 53.671341 63.558696)"},{"color":"normal","length":265,"selection":"LINESTRING(53.671341 63.558696, 53.671309 63.558695, 53.671281 63.558695, 53.671251 63.558696, 53.671213 63.558699, 53.671136 63.558706, 53.670382 63.558781, 53.669266 63.558892, 53.669007 63.558917)"}],"names":["Пионерская"]},"outcoming_path_comment":"2.5 км прямо","type":"begin"},{"comment":"Target","icon":"finish","id":"2423480463229791020","outcoming_path_comment":"Вы на месте!","type":"end"}],"reliability":1.0,"route_id":"null/carrouting/1646118461.061","total_distance":2326,"total_duration":252,"type":"carrouting","ui_total_distance":{"unit":"км","value":"2.5"},"ui_total_duration":"4 мин","waypoints":[{"original_point":{"lat":63.57173103384198,"lon":53.67362181970232},"projected_point":{"lat":63.57173103384198,"lon":53.67362181970232},"transit":false},{"original_point":{"lat":63.55891765470773,"lon":53.66900762324544},"projected_point":{"lat":63.55891765470773,"lon":53.66900762324544},"transit":false}]}],"type":"result"}
```
