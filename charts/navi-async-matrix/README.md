# 2GIS Distance Matrix Async API

Use this Helm chart to deploy Distance Matrix Async API, which is a part of 2GIS's [On-Premise Navigation services](https://docs.2gis.com/en/on-premise/navigation).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/navigation/distance-matrix) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-navi-async-matrix.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Common settings

| Name                            | Description                                                                                                                 | Value  |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ------ |
| `dgctlDockerRegistry`           | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`.                                     | `""`   |
| `replicaCount`                  | A replica count for the pod.                                                                                                | `1`    |
| `imagePullSecrets`              | Kubernetes image pull secrets.                                                                                              | `[]`   |
| `nameOverride`                  | Base name to use in all the Kubernetes entities deployed by this chart.                                                     | `""`   |
| `fullnameOverride`              | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                 | `""`   |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`   |
| `podLabels`                     | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                         | `{}`   |
| `annotations`                   | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`   |
| `labels`                        | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`   |
| `podSecurityContext`            | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).              | `{}`   |
| `securityContext`               | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                  | `{}`   |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).         | `{}`   |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.           | `[]`   |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). | `{}`   |
| `priorityClassName`             | Kubernetes [pod priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/).                | `""`   |
| `terminationGracePeriodSeconds` | Kubernetes [termination grace period](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/).           | `60`   |
| `prometheusEnabled`             | If Prometheus scrape is enabled.                                                                                            | `true` |


### Deployment settings

| Name               | Description | Value                               |
| ------------------ | ----------- | ----------------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/navi-async-matrix` |
| `image.tag`        | Tag         | `1.0.0`                             |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`                      |


### Service account settings

| Name                         | Description                                                                                                             | Value   |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                                                  | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account.                                                                              | `{}`    |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |


### Strategy settings

| Name                  | Description                                                          | Value           |
| --------------------- | -------------------------------------------------------------------- | --------------- |
| `updateStrategy.type` | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`. | `RollingUpdate` |


### Limits

| Name                        | Description       | Value   |
| --------------------------- | ----------------- | ------- |
| `resources.requests.cpu`    | A CPU request.    | `1000m` |
| `resources.requests.memory` | A memory request. | `1Gi`   |
| `resources.limits.cpu`      | A CPU limit.      | `1000m` |
| `resources.limits.memory`   | A memory limit.   | `1Gi`   |


### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.enabled`     | If the service is enabled.                                                                                                     | `true`      |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | Service port.                                                                                                                  | `80`        |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name      | Description                                                                                                                                        | Value |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `ingress` | Configuration of the Ingress resource. Adapt it to your Ingress installation. <br/> Defaults to `{'hosts': [{'host': 'navi-async-matrix.host'}]}`. |       |


### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                                 | Description                                          | Value  |
| ------------------------------------ | ---------------------------------------------------- | ------ |
| `podDisruptionBudget.enabled`        | If PDB is enabled for the service.                   | `true` |
| `podDisruptionBudget.minAvailable`   | How many pods must be available after the eviction.  | `1`    |
| `podDisruptionBudget.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`    |


### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                      | Description                                                                                                                                                          | Value   |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                             | If HPA is enabled for the service.                                                                                                                                   | `false` |
| `hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`     |
| `hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `2`     |
| `hpa.scaleDownStabilizationWindowSeconds` | Scale-down window.                                                                                                                                                   | `""`    |
| `hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window.                                                                                                                                                     | `""`    |
| `hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`    |
| `hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`    |


### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                    | Description                                                                                                  | Value   |
| ----------------------- | ------------------------------------------------------------------------------------------------------------ | ------- |
| `vpa.enabled`           | If VPA is enabled for the service.                                                                           | `false` |
| `vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start). | `Auto`  |
| `vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down.                                   | `1000m` |
| `vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down.                                         | `1Gi`   |
| `vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up.                                     | `2000m` |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up.                                           | `2Gi`   |


### Distance Matrix Async API settings

| Name                    | Description                                                              | Value                                 |
| ----------------------- | ------------------------------------------------------------------------ | ------------------------------------- |
| `dm.port`               | Distance Matrix Async API HTTP port.                                     | `8000`                                |
| `dm.configType`         | Configuration type. Must always be `env`.                                | `env`                                 |
| `dm.workerCount`        | Number of Distance Matrix Async workers.                                 | `4`                                   |
| `dm.citiesUrl`          | URL of the information about cities provided by the Navi-Castle service. | `http://navi-castle.host/cities.conf` |
| `dm.citiesUpdatePeriod` | Period (in seconds) between requesting data from `citiesUrl`.            | `3600`                                |


### Database settings

| Name          | Description                                          | Value        |
| ------------- | ---------------------------------------------------- | ------------ |
| `db.host`     | PostgreSQL host.                                     | `localhost`  |
| `db.port`     | PostgreSQL port.                                     | `5432`       |
| `db.name`     | PostgreSQL database name.                            | `dm`         |
| `db.user`     | PostgreSQL username.                                 | `dbuser`     |
| `db.password` | PostgreSQL password. Must be specified in overrides. | `dbpassword` |


### Kafka settings

| Name                          | Description                                                                                    | Value                        |
| ----------------------------- | ---------------------------------------------------------------------------------------------- | ---------------------------- |
| `kafka.bootstrap`             | URL of the Kafka server.                                                                       | `async-matrix-api.host:9092` |
| `kafka.groupId`               | Distance Matrix Async API group identifier.                                                    | `test_id`                    |
| `kafka.user`                  | Username for accessing the Kafka server.                                                       | `kafkauser`                  |
| `kafka.password`              | Password for accessing the Kafka server.                                                       | `kafkapassword`              |
| `kafka.mechanism`             | Authentication mechanism.                                                                      | `SCRAM-SHA-512`              |
| `kafka.protocol`              | Kafka protocol.                                                                                | `SASL_SSL`                   |
| `kafka.consumerTaskTopic`     | Name of the topic for sending new tasks to.                                                    | `service_message_bus`        |
| `kafka.consumerCancelTopic`   | Name of the topic for canceling or receiving information about finished tasks.                 | `cancel_topic`               |
| `kafka.topicRules`            | **Information about the topics that Distance Matrix Async API will use to send the requests.** |                              |
| `kafka.topicRules[].topic`    | Name of the topic.                                                                             |                              |
| `kafka.topicRules[].default`  | If this topic is used for projects by default.                                                 |                              |
| `kafka.topicRules[].projects` | List of projects to use this topic for, e.g., `['dammam']`.                                    |                              |


### S3-compatible storage settings

| Name        | Description                             | Value                          |
| ----------- | --------------------------------------- | ------------------------------ |
| `s3.url`    | S3 endpoint URL.                        | `https://async-matrix-s3.host` |
| `s3.bucket` | S3 bucket name.                         | `samplebucket`                 |
| `s3.keyId`  | S3 access key for accessing the bucket. | `sampleid`                     |
| `s3.key`    | S3 secret key for accessing the bucket. | `samplekey`                    |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
