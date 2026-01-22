# 2GIS Navi-Back service

Use this Helm chart to deploy Navi-Back service, which is a part of 2GIS's [On-Premise Navigation services](https://docs.2gis.com/en/on-premise/navigation).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/navigation) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-back.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

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
| `timezone`                           | Timezone for the navi-back container. Refer to inline comments for details                                                           | `UTC`  |

### Container image settings

| Name               | Description | Value                       |
| ------------------ | ----------- | --------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/navi-back` |
| `image.tag`        | Tag         | `7.49.0.3`                  |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`              |

### Navi-Back application settings

| Name                                                    | Description                                                                                                                                                                                                                                    | Value                                    |
| ------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `naviback.ecaHost`                                      | DEPRECATED: Use naviback.ecaUrl. Domain name of the [Traffic Proxy service](https://docs.2gis.com/en/on-premise/traffic-proxy). <br> This URL should be accessible from all the pods within your Kubernetes cluster                            |                                          |
| `naviback.ecaUrl`                                       | URL of the [Traffic Proxy service](https://docs.2gis.com/en/on-premise/traffic-proxy). <br> This URL should be accessible from all the pods within your Kubernetes cluster                                                                     |                                          |
| `naviback.forecastHost`                                 | DEPRECATED: naviback.forecastUrl. Use URL of Traffic forecast service. See the [Traffic Proxy service](https://docs.2gis.com/en/on-premise/traffic-proxy). <br> This URL should be accessible from all the pods within your Kubernetes cluster |                                          |
| `naviback.forecastUrl`                                  | URL of Traffic forecast service. See the [Traffic Proxy service](https://docs.2gis.com/en/on-premise/traffic-proxy). <br> This URL should be accessible from all the pods within your Kubernetes cluster                                       |                                          |
| `naviback.forecastFilename`                             | Filename of the forecast                                                                                                                                                                                                                       |                                          |
| `naviback.longForecastUrl`                              | URL of Traffic long forecast service. See the [Traffic Proxy service](https://docs.2gis.com/en/on-premise/traffic-proxy). <br> This URL should be accessible from all the pods within your Kubernetes cluster                                  |                                          |
| `naviback.longforecastFilename`                         | Filename of the long forecast                                                                                                                                                                                                                  |                                          |
| `naviback.walkingUserSpeedsUrl`                         | URL of walking user speeds                                                                                                                                                                                                                     |                                          |
| `naviback.routeAsUsualUrl`                              | URL of route as usual                                                                                                                                                                                                                          |                                          |
| `naviback.dmSourcesLimit`                               | Maximum number of sources in the distance matrix. For synchronous get_dist_matrix calls, the recommended limit is 25 (25x25 matrix max).                                                                                                       | `25`                                     |
| `naviback.dmTargetsLimit`                               | Maximum number of targets in the distance matrix. For synchronous get_dist_matrix calls, the recommended limit is 25 (25x25 matrix max).                                                                                                       | `25`                                     |
| `naviback.handlersNumber`                               | Total number of HTTP/GRPC handlers                                                                                                                                                                                                             | `1`                                      |
| `naviback.queueSize`                                    | Internal queue size                                                                                                                                                                                                                            | `128`                                    |
| `naviback.maxProcessTime`                               | Maximum processing time limit in seconds, may be overriden by `naviback.queryTimeouts`                                                                                                                                                         | `20`                                     |
| `naviback.responseTimelimit`                            | Maximum response time limit in seconds                                                                                                                                                                                                         | `120`                                    |
| `naviback.requestTimeout`                               | Maximum request time limit in seconds                                                                                                                                                                                                          | `120`                                    |
| `naviback.timeoutLimitSec`                              | Maximum downloading time can be reached after failures                                                                                                                                                                                         | `1200`                                   |
| `naviback.timeoutIncrementSec`                          | Downloading time increment after failures                                                                                                                                                                                                      | `140`                                    |
| `naviback.totalRetryDurationSec`                        | Downloading timeout with all failure retries                                                                                                                                                                                                   | `2400`                                   |
| `naviback.initialRetryIntervalSec`                      | Initial timeout for a failure retry                                                                                                                                                                                                            | `2`                                      |
| `naviback.clearCacheThreshold`                          | Memory usage percentage threshold to run cache cleanup                                                                                                                                                                                         | `90`                                     |
| `naviback.queryTimeouts`                                | A key-value list of per-query timeouts. If rule permits multiple queries maximum timeout is used. Defaults to `naviback.maxProcessTimeout`. Example `naviback.queryTimeouts: { route_planner: 120, map_matching: 45 }`                         | `{}`                                     |
| `naviback.dump.result`                                  | Dump results in logs                                                                                                                                                                                                                           | `false`                                  |
| `naviback.dump.query`                                   | Dump queries in logs                                                                                                                                                                                                                           | `false`                                  |
| `naviback.dump.answer`                                  | Dump answers in logs                                                                                                                                                                                                                           | `false`                                  |
| `naviback.logLevel`                                     | Logging level, one of: Verbose, Info, Warning, Error, Fatal                                                                                                                                                                                    | `Info`                                   |
| `naviback.logMessageField`                              | Field name in logs for messages data.                                                                                                                                                                                                          | `custom.navi_msg`                        |
| `naviback.indexFilename`                                | Name of the index file on Castle                                                                                                                                                                                                               | `index.json.zip`                         |
| `naviback.citiesFilename`                               | Name of the cities file on Castle                                                                                                                                                                                                              | `cities.conf.zip`                        |
| `naviback.configFilepath`                               | Configs mountpoint path                                                                                                                                                                                                                        | `/src/etc/2gis/mosesd`                   |
| `naviback.sentry.enabled`                               | If sending crash dumps to Sentry needed                                                                                                                                                                                                        | `false`                                  |
| `naviback.sentry.address`                               | Sentry URL                                                                                                                                                                                                                                     | `sentry.local`                           |
| `naviback.sentry.project`                               | Sentry project ID                                                                                                                                                                                                                              | `navi-back`                              |
| `naviback.sentry.username`                              | Sentry username                                                                                                                                                                                                                                | `navi`                                   |
| `naviback.sentry.printMessages`                         | If outgoing messages needed                                                                                                                                                                                                                    | `false`                                  |
| `naviback.sentry.debug`                                 | Debugging switch                                                                                                                                                                                                                               | `false`                                  |
| `naviback.sentry.reportPath`                            | Local directory to dump                                                                                                                                                                                                                        | `/tmp/sentry`                            |
| `naviback.sentry.handler`                               | Handler file location                                                                                                                                                                                                                          | `/usr/sbin/2gis/mosesd/crashpad_handler` |
| `naviback.castleHost`                                   | DEPRECATED: Use naviback.castleUrl. Domain name of Navi-Castle service. <br> This URL should be accessible from all the pods within your Kubernetes cluster                                                                                    |                                          |
| `naviback.castleUrl`                                    | URL of Navi-Castle service. <br> This URL should be accessible from all the pods within your Kubernetes cluster                                                                                                                                | `""`                                     |
| `naviback.castleUrlProxy`                               | URL of Proxy Navi-Castle service. Needs only OnPrem. More priority than naviback.castleUrl and naviback.restrictions.url                                                                                                                       | `""`                                     |
| `naviback.enablePassableBarriers`                       | Consider passable barriers                                                                                                                                                                                                                     |                                          |
| `naviback.grpcPort`                                     | GRPC port to serve.                                                                                                                                                                                                                            | `50051`                                  |
| `naviback.disableUpdates`                               | Test switch for disabling runtime background updates                                                                                                                                                                                           | `false`                                  |
| `naviback.indices`                                      | List of dynamic indices kill switches                                                                                                                                                                                                          |                                          |
| `naviback.additionalSections`                           | Optinal JSON block to be added to config file as-is                                                                                                                                                                                            |                                          |
| `naviback.simpleNetwork.bicycle`                        | Enable simple network for bicycle routing                                                                                                                                                                                                      |                                          |
| `naviback.simpleNetwork.car`                            | Enable simple network for auto routing                                                                                                                                                                                                         |                                          |
| `naviback.simpleNetwork.emergency`                      | Enable simple network for emergency vehicles routing                                                                                                                                                                                           |                                          |
| `naviback.simpleNetwork.pedestrian`                     | Enable simple network for pedestrian routing                                                                                                                                                                                                   |                                          |
| `naviback.simpleNetwork.taxi`                           | Enable simple network for taxi routing                                                                                                                                                                                                         |                                          |
| `naviback.simpleNetwork.truck`                          | Enable simple network for truck routing                                                                                                                                                                                                        |                                          |
| `naviback.simpleNetwork.scooter`                        | Enable simple network for scooters routing                                                                                                                                                                                                     |                                          |
| `naviback.simpleNetwork.motorcycle`                     | Enable simple network for motorcycle routing                                                                                                                                                                                                   |                                          |
| `naviback.attractor.bicycle`                            | Enable enhanced attractor for bicycle routing                                                                                                                                                                                                  |                                          |
| `naviback.attractor.car`                                | Enable enhanced attractor for auto routing                                                                                                                                                                                                     |                                          |
| `naviback.attractor.pedestrian`                         | Enable enhanced attractor for pedestrian routing                                                                                                                                                                                               |                                          |
| `naviback.attractor.taxi`                               | Enable enhanced attractor for taxi routing                                                                                                                                                                                                     |                                          |
| `naviback.attractor.truck`                              | Enable enhanced attractor for truck routing                                                                                                                                                                                                    |                                          |
| `naviback.attractor.scooter`                            | Enable enhanced attractor for scooters routing                                                                                                                                                                                                 |                                          |
| `naviback.attractor.motorcycle`                         | Enable enhanced attractor for motorcycle routing                                                                                                                                                                                               |                                          |
| `naviback.stat.enabled`                                 | Enable sending information on the construction of routes to the business statistics service                                                                                                                                                    | `false`                                  |
| `naviback.stat.url`                                     | Remote address business statistics service. Required for enabling                                                                                                                                                                              | `""`                                     |
| `naviback.stat.client.messageCountToFlush`              | Message count to flush                                                                                                                                                                                                                         | `500`                                    |
| `naviback.stat.client.useCompression`                   | Enable compression                                                                                                                                                                                                                             | `true`                                   |
| `naviback.stat.client.packageSizeMaxBytes`              | Package size max bytes                                                                                                                                                                                                                         | `1800000`                                |
| `naviback.stat.client.pendingTransmissionMaxCount`      | Pending transmission max count                                                                                                                                                                                                                 | `10`                                     |
| `naviback.stat.client.timeoutLimitMilSec`               | Maximum request time limit in milliseconds                                                                                                                                                                                                     | `5000`                                   |
| `naviback.reduceEdgesOptimizationFlag`                  | Enable optimizations for distance matrix queries processing                                                                                                                                                                                    |                                          |
| `naviback.behindSplitter`                               | The current instance is behind splitter or not                                                                                                                                                                                                 | `false`                                  |
| `naviback.overrideConfig`                               | Complete config override. For test purposes only                                                                                                                                                                                               | `""`                                     |
| `naviback.restrictions.enabled`                         | Enable restrictions                                                                                                                                                                                                                            | `false`                                  |
| `naviback.restrictions.url`                             | URL of real time restrictions server. More priority than naviback.castleUrl                                                                                                                                                                    | `""`                                     |
| `naviback.restrictions.updatePeriod`                    | Update period from restrictions server                                                                                                                                                                                                         | `60`                                     |
| `naviback.restrictions.timeoutSeconds`                  | Timeout seconds for restrictions server                                                                                                                                                                                                        | `60`                                     |
| `naviback.restrictions.filename`                        | Filename of the restrictions.                                                                                                                                                                                                                  |                                          |
| `naviback.validation.enabled`                           | Enable validation responses and requests (used for internal tests)                                                                                                                                                                             | `false`                                  |
| `naviback.validation.ctx.schemasFolder`                 | Path to folder with ctx JSON schemas                                                                                                                                                                                                           | `/usr/share/2gis/schemas/nsr_schemas`    |
| `naviback.validation.ctx.requestSchemaName`             | Name of ctx request validation schema                                                                                                                                                                                                          | `CTXRequestModel.json`                   |
| `naviback.validation.ctx.responseSchemaName`            | Name of ctx response validation schema                                                                                                                                                                                                         | `CTXResponseModelV4.json`                |
| `naviback.validation.stat.schemasFolder`                | Path to folder with stat (bss) JSON schemas                                                                                                                                                                                                    | `/usr/share/2gis/schemas/bss_schemas`    |
| `naviback.validation.stat.requestSchemaName`            | Name of stat (bss) request validation schema                                                                                                                                                                                                   | `""`                                     |
| `naviback.validation.stat.responseSchemaName`           | Name of stat (bss) response validation schema                                                                                                                                                                                                  | `401.schema.json`                        |
| `naviback.validation.distanceMatrix.schemasFolder`      | Path to folder with distance matrix JSON schemas                                                                                                                                                                                               | `/usr/share/2gis/schemas/nsr_schemas`    |
| `naviback.validation.distanceMatrix.requestSchemaName`  | Name of distance matrix request validation schema                                                                                                                                                                                              | `DistanceMatrixRequestModel.json`        |
| `naviback.validation.distanceMatrix.responseSchemaName` | Name of distance matrix response validation schema                                                                                                                                                                                             | `DistanceMatrixResponseModel.json`       |
| `naviback.validation.isochrone.schemasFolder`           | Path to folder with isochrone JSON schemas                                                                                                                                                                                                     | `/usr/share/2gis/schemas/nsr_schemas`    |
| `naviback.validation.isochrone.requestSchemaName`       | Name of isochrone request validation schema                                                                                                                                                                                                    | `IsochroneApiRequestModel.json`          |
| `naviback.validation.isochrone.responseSchemaName`      | Name of isochrone response validation schema                                                                                                                                                                                                   | `IsochroneApiResponseModel.json`         |
| `naviback.tilesMetricsThreshold`                        | The value at which we send tiles metrics (used for internal tests)                                                                                                                                                                             | `0`                                      |
| `naviback.engineUpdatePeriodSec`                        | The time interval between engine updates                                                                                                                                                                                                       | `30`                                     |
| `naviback.lightweightMode`                              | The service will be started without some resources such as geometry, instructions and etc to reduce memory consumption                                                                                                                         | `false`                                  |
| `naviback.hierarchies.enabled`                          | If SN cache available                                                                                                                                                                                                                          | `false`                                  |
| `naviback.hierarchies.skipPatches`                      | Skip patches in hierarchies cache, ignored if skipShortcuts set                                                                                                                                                                                | `false`                                  |
| `naviback.hierarchies.skipShortcuts`                    | Skip shortcuts in SN cache                                                                                                                                                                                                                     | `false`                                  |
| `naviback.hierarchies.s3path`                           | Hierarchies cache remote location                                                                                                                                                                                                              | `""`                                     |
| `naviback.hierarchies.volume`                           | Hierarchies local cache specification. Leave empty for default emptydir.                                                                                                                                                                       | `{}`                                     |
| `naviback.hierarchies.mountPath`                        | Hierarchies mountpoint filepath                                                                                                                                                                                                                | `/tmp/hierarchies`                       |
| `naviback.truckUniverse.enabled`                        | Enable Pre-calculation of the `universe' for truck driving directions.                                                                                                                                                                         | `false`                                  |
| `naviback.etaScheduleIndex.enabled`                     | If Schedule Index available                                                                                                                                                                                                                    | `false`                                  |
| `naviback.etaScheduleIndex.url`                         | Schedule Index remote url                                                                                                                                                                                                                      | `""`                                     |
| `naviback.etaScheduleIndex.etaScheduleNodes`            | ETA Schedule nodes                                                                                                                                                                                                                             | `""`                                     |
| `naviback.appRule`                                      | Item name from `rules` list to load rules from.                                                                                                                                                                                                | `""`                                     |
| `naivback.app_rule`                                     | DEPRECATED use `naviback.appRule`                                                                                                                                                                                                              |                                          |
| `naviback.rulesUrl`                                     | URL to rules file                                                                                                                                                                                                                              | `file://{LOCAL_ETC}/rules.conf`          |
| `naviback.excludedAreasLimit`                           | Maximum number of excluded areas                                                                                                                                                                                                               |                                          |
| `navigroup`                                             | Service group identifier, allows multiple stacks deployed to the same namespace.                                                                                                                                                               | `""`                                     |
| `appProject`                                            | Do not use, configure with `rules` and `appRule` instead.                                                                                                                                                                                      | `""`                                     |
| `app_project`                                           | DEPRECATED see `appProect`                                                                                                                                                                                                                     |                                          |
| `rules`                                                 | List of routing rules configured on this instance, refer to full [documentation](https://docs.2gis.com/en/on-premise/deployment/navigation#nav-lvl1--3._Create_a_rules_file) for details                                                       | `[]`                                     |

### Envoy settings, ignored if not `transmitter.enabled`.

| Name                              | Description                                                                                  | Value                        |
| --------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------- |
| `envoy.image.repository`          | Repository                                                                                   | `2gis-on-premise/navi-envoy` |
| `envoy.image.tag`                 | Tag                                                                                          | `1.36.2-tools`               |
| `envoy.image.pullPolicy`          | Pull Policy                                                                                  | `IfNotPresent`               |
| `envoy.concurrency`               | The number of worker threads to run. Use `max(1, floor(resources.limits.cpu))` if set to `0` | `""`                         |
| `envoy.resources`                 | Container resources requirements structure                                                   | `{}`                         |
| `envoy.resources.requests.cpu`    | CPU request, recommended value `100m`                                                        | `undefined`                  |
| `envoy.resources.requests.memory` | Memory request, recommended value `100Mi`                                                    | `undefined`                  |
| `envoy.resources.limits.cpu`      | CPU limit, recommended value `100m`                                                          | `undefined`                  |
| `envoy.resources.limits.memory`   | Memory limit, recommended value `100Mi`                                                      | `undefined`                  |
| `envoy.configFilepath`            | Configs mountpoint path                                                                      | `/src/etc/envoy`             |

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
| `service.headless.enabled`     | Enable creating a secondary headless service                                                                                  | `true`      |
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

### Settings for attractor connection.

| Name                              | Description                                                                                                                                                                                    | Value                        |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `transmitter.enabled`             | if attractor connection required                                                                                                                                                               | `false`                      |
| `transmitter.type`                | connection type one of: grpc, grpc-async, grpc-stream, ws, ws-async                                                                                                                            | `grpc-async-stream`          |
| `transmitter.host`                | attractor service                                                                                                                                                                              | `http://navi-attractor.host` |
| `transmitter.port`                | attractor port                                                                                                                                                                                 | `50051`                      |
| `transmitter.responseTimeoutMs`   | response waiting timeout                                                                                                                                                                       | `2000`                       |
| `transmitter.connectTimeout`      | Establish connection [timeout](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/cluster/v3/cluster.proto#envoy-v3-api-field-config-cluster-v3-cluster-connect-timeout)                | `2s`                         |
| `transmitter.clusterTimeout`      | Response [timeout](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/route/v3/route_components.proto#envoy-v3-api-field-config-route-v3-routeaction-timeout)                           | `120s`                       |
| `transmitter.retry.enabled`       | Enable retry failed requests                                                                                                                                                                   | `false`                      |
| `transmitter.retry.retryOn`       | Status [codes for retry](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/router_filter#x-envoy-retry-grpc-on)                                                      | `internal,unavailable`       |
| `transmitter.retry.numRetries`    | Failed request [retries](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/router_filter#config-http-filters-router-x-envoy-max-retries)                             | `5`                          |
| `transmitter.retry.perTryTimeout` | Specifies timeout on each [retry](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/router_filter#config-http-filters-router-x-envoy-upstream-rq-per-try-timeout-ms) | `2s`                         |

### Back-end and attractor group properties. Leave with defaults, FOR FUTURE RELEASE.

| Name                  | Description                                      | Value         |
| --------------------- | ------------------------------------------------ | ------------- |
| `dataGroup.enabled`   | if grouping enabled                              | `false`       |
| `dataGroup.prefix`    | common prefix for the group used for identifiers | `sampleGroup` |
| `dataGroup.timestamp` | data timestamp the group is running on           | `no-default`  |

### Route sharing properties. Leave with defaults, FOR FUTURE RELEASE

| Name                                | Description                                                             | Value   |
| ----------------------------------- | ----------------------------------------------------------------------- | ------- |
| `routesharing.enabled`              | If route sharing enabled                                                | `false` |
| `routesharing.kafka.topic`          | Topic to use for route sharing                                          | `""`    |
| `routesharing.kafka.properties`     | Properties as supported by librdkafka, see `kafka` section and comments |         |
| `routesharing.kafka.fileProperties` | Properties stored in file, see `kafka` section and comments             | `{}`    |

### Traffic lights processing. Leave with defaults, FOR FUTURE RELEASE

| Name                                 | Description                                                             | Value   |
| ------------------------------------ | ----------------------------------------------------------------------- | ------- |
| `trafficLights.enabled`              | If traffic lights processing enabled                                    | `false` |
| `trafficLights.projects`             | List of projects, for which traffic lights are processed                | `[]`    |
| `trafficLights.kafka.topic`          | Topic to use for traffic lights processing                              | `""`    |
| `trafficLights.kafka.properties`     | Properties as supported by librdkafka, see `kafka` section and comments |         |
| `trafficLights.kafka.fileProperties` | Properties stored in file, see `kafka` section and comments             | `{}`    |

### Road locks processing. Leave with defaults, FOR FUTURE RELEASE

| Name                                        | Description                                                              | Value    |
| ------------------------------------------- | ------------------------------------------------------------------------ | -------- |
| `roadLocks.enabled`                         | If road locks processing enabled                                         | `false`  |
| `roadLocks.modifications_limit_for_merge`   | Max amount of modifications for a single road lock before getting merged | `1000`   |
| `roadLocks.merge_timeout_limit_ms`          | Max timeout in ms for a single road lock before getting merged           | `300000` |
| `roadLocks.kafka_messages_queue_size_limit` | Max Kafka messages queue size                                            | `1000`   |
| `roadLocks.merge_poll_ms`                   | Timeout in ms for checking if merge (of modifications) is needed         | `5000`   |
| `roadLocks.kafka_group_id_prefix`           | Prefix for kafka groud_id                                                | `""`     |
| `roadLocks.kafka.properties`                | Properties as supported by librdkafka, see `kafka` section and comments  |          |
| `roadLocks.kafka.fileProperties`            | Properties stored in file, see `kafka` section and comments              | `{}`     |

### ETA display optins.

| Name                        | Description                                      | Value  |
| --------------------------- | ------------------------------------------------ | ------ |
| `etaDisplayOptions.enabled` | True if personalized ETA display options enabled | `true` |

### License settings

| Name                                        | Description                                                               | Value  |
| ------------------------------------------- | ------------------------------------------------------------------------- | ------ |
| `license.url`                               | Address of the License service v2. Ex: https://license.svc                | `""`   |
| `license.additionalTimeAfterConnectionLost` | License service unavailability grace period in seconds, cannot exceed 24h | `3600` |

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

### customCAs **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container. If empty, the default value: "/usr/local/share/ca-certificates"          | `""`  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
