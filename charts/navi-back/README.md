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

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |


### Common settings

| Name                 | Description                                                                                                                 | Value |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `replicaCount`       | A replica count for the pod.                                                                                                | `1`   |
| `imagePullSecrets`   | Kubernetes image pull secrets.                                                                                              | `[]`  |
| `nameOverride`       | Base name to use in all the Kubernetes entities deployed by this chart.                                                     | `""`  |
| `fullnameOverride`   | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                 | `""`  |
| `podAnnotations`     | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`  |
| `podSecurityContext` | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).              | `{}`  |
| `securityContext`    | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                  | `{}`  |
| `nodeSelector`       | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).         | `{}`  |
| `tolerations`        | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.           | `[]`  |
| `affinity`           | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). | `{}`  |
| `labels`             | Custom labels to set to Deployment resource.                                                                                | `{}`  |


### Deployment settings

| Name               | Description | Value                       |
| ------------------ | ----------- | --------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/navi-back` |
| `image.tag`        | Tag         | `6.12.0`                    |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`              |


### Navi-Back application settings

| Name                                   | Description                                                                                                                                                                                               | Value                     |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `naviback.ecaHost`                     | Domain name of the [Traffic Proxy service](https://docs.2gis.com/en/on-premise/traffic-proxy). <br> This URL should be accessible from all the pods within your Kubernetes cluster.                       |                           |
| `naviback.forecastHost`                | URL of Traffic forecast service. See the [Traffic Proxy service](https://docs.2gis.com/en/on-premise/traffic-proxy). <br> This URL should be accessible from all the pods within your Kubernetes cluster. |                           |
| `naviback.dmSourcesLimit`              | Size limit for source matrices.                                                                                                                                                                           | `1000`                    |
| `naviback.dmTargetsLimit`              | Size limit for target matrices.                                                                                                                                                                           | `1000`                    |
| `naviback.handlersNumber`              | Number of HTTP handlers.                                                                                                                                                                                  | `1`                       |
| `naviback.maxProcessTime`              | Maximum processing time limit in minutes.                                                                                                                                                                 | `600`                     |
| `naviback.responseTimelimit`           | Maximum response time limit in minutes.                                                                                                                                                                   | `60`                      |
| `naviback.requestTimeout`              | Maximum request time limit in minutes.                                                                                                                                                                    | `60`                      |
| `naviback.dump.result`                 | Dump results in logs.                                                                                                                                                                                     | `false`                   |
| `naviback.dump.query`                  | Dump queries in logs.                                                                                                                                                                                     | `false`                   |
| `naviback.dump.answer`                 | Dump answers in logs.                                                                                                                                                                                     | `false`                   |
| `naviback.logLevel`                    | Logging level, one of: Verbose, Info, Warning, Error, Fatal.                                                                                                                                              | `Info`                    |
| `naviback.castleHost`                  | URL of Navi-Castle service. <br> This URL should be accessible from all the pods within your Kubernetes cluster.                                                                                          | `http://navi-castle.host` |
| `naviback.indices`                     | List of dynamic indices kill switches.                                                                                                                                                                    |                           |
| `naviback.additionalSections`          | Optinal JSON block to be added to config file as-is.                                                                                                                                                      |                           |
| `naviback.simpleNetwork.bicycle`       | Enable simple network for bicycle routing                                                                                                                                                                 |                           |
| `naviback.simpleNetwork.car`           | Enable simple network for auto routing                                                                                                                                                                    |                           |
| `naviback.simpleNetwork.emergency`     | Enable simple network for emergency vehicles routing                                                                                                                                                      | `false`                   |
| `naviback.simpleNetwork.pedestrian`    | Enable simple network for pedestrian routing                                                                                                                                                              |                           |
| `naviback.simpleNetwork.taxi`          | Enable simple network for taxi routing                                                                                                                                                                    |                           |
| `naviback.simpleNetwork.truck`         | Enable simple network for truck routing                                                                                                                                                                   |                           |
| `naviback.attractor.bicycle`           | Enable enhanced attractor for bicycle routing                                                                                                                                                             |                           |
| `naviback.attractor.car`               | Enable enhanced attractor for auto routing                                                                                                                                                                |                           |
| `naviback.attractor.pedestrian`        | Enable enhanced attractor for pedestrian routing                                                                                                                                                          |                           |
| `naviback.attractor.taxi`              | Enable enhanced attractor for taxi routing                                                                                                                                                                |                           |
| `naviback.reduceEdgesOptimizationFlag` | Enable optimizations for distance matrix queries processing                                                                                                                                               |                           |


### Service account settings

| Name                         | Description                                                                                                             | Value  |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                                                  | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account.                                                                              | `{}`   |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`   |


### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | Service port.                                                                                                                  | `80`        |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `nil`       |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                    | Description                            | Value            |
| ----------------------- | -------------------------------------- | ---------------- |
| `ingress.enabled`       | If Ingress is enabled for the service. | `false`          |
| `ingress.hosts[0].host` | Hostname for the Ingress service.      | `navi-back.host` |


### Limits

| Name                            | Description                     | Value    |
| ------------------------------- | ------------------------------- | -------- |
| `resources.requests.cpu`        | A CPU request.                  | `500m`   |
| `resources.requests.memory`     | A memory request.               | `1024Mi` |
| `resources.limits.cpu`          | A CPU limit.                    | `2`      |
| `resources.limits.memory`       | A memory limit.                 | `4000Mi` |
| `testResources`                 | **Limits for test connection.** |          |
| `testResources.requests.cpu`    | A CPU request.                  | `100m`   |
| `testResources.requests.memory` | A memory request.               | `100Mi`  |
| `testResources.limits.cpu`      | A CPU limit.                    | `100m`   |
| `testResources.limits.memory`   | A memory limit.                 | `100Mi`  |


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


### Kafka settings for interacting with Distance Matrix Async Service

| Name                                             | Description                                                                                                               | Value          |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------- | -------------- |
| `kafka.enabled`                                  | If the Kafka is enabled.                                                                                                  | `false`        |
| `kafka.groupId`                                  | Navi-Back service group identifier.                                                                                       | `navi_back`    |
| `kafka.properties`                               | Properties as supported by librdkafka. Refer to inline comments for details.                                              |                |
| `kafka.fileProperties`                           | As kafka.properties, but kept in a file, which passed to application as a filename. Refer to inline comments for details. | `{}`           |
| `kafka.distanceMatrix`                           | **Settings for interacting with Distance Matrix Async service.**                                                          |                |
| `kafka.distanceMatrix.taskTopic`                 | Name of the topic for receiving new tasks from Distance Matrix Async API.                                                 | `task_topic`   |
| `kafka.distanceMatrix.cancelTopic`               | Name of the topic for canceling or receiving information about finished tasks.                                            | `cancel_topic` |
| `kafka.distanceMatrix.statusTopic`               | Name of the topic for receiving task status information.                                                                  | `status_topic` |
| `kafka.distanceMatrix.updateTaskStatusPeriodSec` | Update period for task statuses.                                                                                          | `120`          |
| `kafka.distanceMatrix.messageExpiredPeriodSec`   | Update period for task cancellations.                                                                                     | `3600`         |
| `kafka.distanceMatrix.requestDownloadTimeoutSec` | Timeout for downloading request data.                                                                                     | `20`           |
| `kafka.distanceMatrix.responseUploadTimeoutSec`  | Timeout for uploading response data.                                                                                      | `40`           |


### S3-compatible storage settings for interacting with Distance Matrix Async Service

| Name                  | Description                             | Value                         |
| --------------------- | --------------------------------------- | ----------------------------- |
| `s3.enabled`          | if S3 storage is enabled.               | `false`                       |
| `s3.host`             | S3 endpoint URL.                        | `http://async-matrix-s3.host` |
| `s3.bucket`           | S3 bucket name.                         | `samplebucket`                |
| `s3.accessKey`        | S3 access key for accessing the bucket. | `sampleid`                    |
| `s3.secretKey`        | S3 secret key for accessing the bucket. | `samplekey`                   |
| `livenessProbeDelay`  | initial delay for liveness probes       | `60`                          |
| `readinessProbeDelay` | initial delay for readiness probes      | `75`                          |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
