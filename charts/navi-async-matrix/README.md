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

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                            | Description                                                                                                                 | Value  |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ------ |
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
| `image.tag`        | Tag         | `1.16.0`                            |
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

| Name                        | Description       | Value |
| --------------------------- | ----------------- | ----- |
| `resources.requests.cpu`    | A CPU request.    |       |
| `resources.requests.memory` | A memory request. |       |
| `resources.limits.cpu`      | A CPU limit.      |       |
| `resources.limits.memory`   | A memory limit.   |       |

### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.enabled`     | If the service is enabled.                                                                                                     | `true`      |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | Service port.                                                                                                                  | `80`        |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                           |
| ------------------------------------ | ----------------------------------------- | ------------------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                         |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`                         |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `navi-async-matrix.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                             |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                        |
| `ingress.tls`                        | TLS configuration                         | `[]`                            |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                          | Value  |
| -------------------- | ---------------------------------------------------- | ------ |
| `pdb.enabled`        | If PDB is enabled for the service.                   | `true` |
| `pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`   |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`    |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                    | Description                                                                                                                                                          | Value   |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                           | If HPA is enabled for the service.                                                                                                                                   | `false` |
| `hpa.minReplicas`                       | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`     |
| `hpa.maxReplicas`                       | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `2`     |
| `hpa.targetCPUUtilizationPercentage`    | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`    |
| `hpa.targetMemoryUtilizationPercentage` | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`    |
| `hpa.behavior`                          | HPA Behavior                                                                                                                                                         | `{}`    |

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

| Name                                  | Description                                                                                                                   | Value                                      |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| `dm.port`                             | Distance Matrix Async API HTTP port.                                                                                          | `8000`                                     |
| `dm.configType`                       | Configuration type. Must always be `env`.                                                                                     | `env`                                      |
| `dm.logLevel`                         | Logging level, one of: DEBUG, INFO, WARNING, ERROR, CRITICAL.                                                                 | `INFO`                                     |
| `dm.workerCount`                      | Number of Distance Matrix Async workers.                                                                                      | `4`                                        |
| `dm.citiesUrl`                        | URL of the information about cities provided by the Navi-Castle service, ex: http://navi-castle.svc/cities.conf. **Required** | `""`                                       |
| `dm.citiesUpdatePeriod`               | Period (in seconds) between requesting data from `citiesUrl`.                                                                 | `3600`                                     |
| `dm.taskSplitSize`                    | Minimum size of matrix to get split in merger job.                                                                            | `5000`                                     |
| `dm.compositeTaskTimeoutSec`          | Timeout for executing split tasks.                                                                                            | `3600`                                     |
| `dm.merger.image.repository`          | Image repository for merger.                                                                                                  | `2gis-on-premise/navi-merger-async-matrix` |
| `dm.merger.image.tag`                 | Image tag for merger.                                                                                                         | `1.16.0`                                   |
| `dm.merger.replicaCount`              | A replica count for the arhiver.                                                                                              | `1`                                        |
| `dm.merger.resources.requests.cpu`    | Merger CPU request. 1CPU recommended.                                                                                         |                                            |
| `dm.merger.resources.requests.memory` | Merger memory request. 10Gi recommended.                                                                                      |                                            |
| `dm.merger.resources.limits.cpu`      | Merger CPU limit. 1CPU recommended.                                                                                           |                                            |
| `dm.merger.resources.limits.memory`   | Merger memory limit. 20Gi recommended.                                                                                        |                                            |

### Database settings

| Name                     | Description                                                                  | Value         |
| ------------------------ | ---------------------------------------------------------------------------- | ------------- |
| `db.host`                | PostgreSQL hostname or IP. **Required**                                      | `""`          |
| `db.port`                | PostgreSQL port.                                                             | `5432`        |
| `db.extraHosts`          | List of PostgreSQL extra hosts and ports. For more details, see values.yaml. | `[]`          |
| `db.name`                | PostgreSQL database name. **Required**                                       | `""`          |
| `db.user`                | PostgreSQL username. **Required**                                            | `""`          |
| `db.password`            | PostgreSQL password. **Required**                                            | `""`          |
| `db.schema`              | PostgreSQL schema.                                                           | `public`      |
| `db.tls.enabled`         | If tls connection to postgresql is enabled.                                  | `false`       |
| `db.tls.rootCert`        | Root certificate file.                                                       | `""`          |
| `db.tls.cert`            | Certificate of postgresql server.                                            | `""`          |
| `db.tls.key`             | Key of postgresql server.                                                    | `""`          |
| `db.tls.mode`            | Level of protection.                                                         | `verify-full` |
| `db.expirationSec`       | How many seconds to store results. (0 - disable)                             | `0`           |
| `db.expirationPeriodSec` | Period of checking the need to clear the results.                            | `86400`       |

### Multi-DC settings

| Name                                        | Description                                                                         | Value     |
| ------------------------------------------- | ----------------------------------------------------------------------------------- | --------- |
| `multiDc.enabled`                           | If multi-DC functionality enabled                                                   | `false`   |
| `multiDc.location`                          | Primary DC identifier. Arbitrary identifier, unique per DC installation.            | `default` |
| `multiDc.redirectHeader`                    | HTTP header to tell requests original from redirected. Set empty to skip the check. | `""`      |
| `multiDc.secondaryTopics.attractTopic`      | Name of `attractTopic` in secondary DC.                                             | `""`      |
| `multiDc.secondaryTopics.mergerStatusTopic` | Name of `mergerStatusTopic` in secondary DC.                                        | `""`      |
| `multiDc.secondaryTopics.oneToManyTopic`    | Name of `oneToManyTopic` in secondary DC.                                           | `""`      |

### Kafka settings

| Name                                          | Description                                                                                                               | Value                      |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `kafka.groupId`                               | Distance Matrix Async API group identifier.                                                                               | `navi_async_matrix`        |
| `kafka.cancelTopic`                           | Name of the topic for canceling or receiving information about finished tasks.                                            | `""`                       |
| `kafka.mergerGroupId`                         | Group identifier for merger tasks.                                                                                        | `navi_async_matrix_merger` |
| `kafka.mergerStatusTopic`                     | Name of the topic for status merger tasks.                                                                                | `""`                       |
| `kafka.mergerTaskTopic`                       | Name of the topic for merger tasks.                                                                                       | `""`                       |
| `kafka.attractTopic`                          | Name of the topic for for attract tasks results                                                                           | `""`                       |
| `kafka.oneToManyTopic`                        | Name of the topic for oneToMany tasks results                                                                             | `""`                       |
| `kafka.vrpStatusTopic`                        | Name of the topic for VRP service integration                                                                             | `""`                       |
| `kafka.properties`                            | Properties as supported by kafka-python. Refer to inline comments for details.                                            |                            |
| `kafka.sensitiveProperties`                   | As kafka.properties, but kept in Secrets. Refer to inlines comments for details.                                          | `{}`                       |
| `kafka.fileProperties`                        | As kafka.properties, but kept in a file, which passed to application as a filename. Refer to inline comments for details. | `{}`                       |
| `kafka.consumerOverrides.properties`          | Consumer specific properties as simple key-value pairs.                                                                   | `{}`                       |
| `kafka.consumerOverrides.sensitiveProperties` | Consumer specific properties mounted as secrets.                                                                          | `{}`                       |
| `kafka.consumerOverrides.fileProperties`      | Consumer specific properties mounted as regular files.                                                                    | `{}`                       |
| `kafka.producerOverrides.properties`          | Consumer specific properties as simple key-value pairs.                                                                   | `{}`                       |
| `kafka.producerOverrides.sensitiveProperties` | Consumer specific properties mounted as secrets.                                                                          | `{}`                       |
| `kafka.producerOverrides.fileProperties`      | Consumer specific properties mounted as regular files.                                                                    | `{}`                       |
| `kafka.taskTopicRules`                        | **Information about the topics that Distance Matrix Async API will use to send the requests.**                            |                            |
| `kafka.taskTopicRules[].topic`                | Name of the topic.                                                                                                        |                            |
| `kafka.taskTopicRules[].default`              | If this topic is used for projects by default.                                                                            |                            |
| `kafka.taskTopicRules[].type`                 | Routing type for tasks in the topic (`car`, `truck`), defaults to `car`                                                   |                            |
| `kafka.taskTopicRules[].projects`             | List of projects to use this topic for, e.g., `['moscow']`.                                                               |                            |
| `kafka.attractTopicRules`                     | ** Rules to map request type to topic for attract tasks **                                                                | `[]`                       |
| `kafka.attractTopicRules[0].topic`            | Name of the topic.                                                                                                        |                            |
| `kafka.attractTopicRules[0].default`          | If this topic is used for projects by default.                                                                            |                            |
| `kafka.attractTopicRules[0].type`             | Routing type for tasks in the topic (`car`, `truck`), defaults to `car`                                                   |                            |
| `kafka.attractTopicRules[0].projects`         | List of projects to use this topic for, e.g., `['moscow']`.                                                               |                            |

### S3-compatible storage settings

| Name                | Description                                                                                    | Value |
| ------------------- | ---------------------------------------------------------------------------------------------- | ----- |
| `s3.host`           | S3 endpoint URL, ex: http://async-matrix-s3.host. **Required**                                 | `""`  |
| `s3.bucket`         | S3 bucket name. **Required**                                                                   | `""`  |
| `s3.region`         | S3 region.                                                                                     | `""`  |
| `s3.accessKey`      | S3 access key for accessing the bucket. **Required**                                           | `""`  |
| `s3.secretKey`      | S3 secret key for accessing the bucket. **Required**                                           | `""`  |
| `s3.publicNetloc`   | Announce proxy URL for S3 results instead of s3.url if not empty. Must start with `http(s)://` | `nil` |
| `s3.expirationDays` | How many days to store results                                                                 | `14`  |

### API keys service

| Name              | Description                                                                    | Value |
| ----------------- | ------------------------------------------------------------------------------ | ----- |
| `keys.url`        | API keys service URL, ex: http://keys-api.svc/service/v1/keys. **Required**    | `""`  |
| `keys.token`      | API token to authorize at the service. Required if truck car routing in use.   | `""`  |
| `keys.truckToken` | Truck API token to authorize at the service. Required if truck routing in use. | `""`  |

### customCAs **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container. If empty, the default value: "/usr/local/share/ca-certificates"          | `""`  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
