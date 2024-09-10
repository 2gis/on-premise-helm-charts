# 2GIS Citylens service

Use this Helm chart to deploy Citylens services, which is a part of 2GIS's [On-Premise recognitions services]().

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation]() to learn about:

- Architecture of the service.

- Installing the service.

  When filling in the keys for `values.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                                         | Value |
|-----------------------|-----------------------------------------------------------------------------------------------------|-------|
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port` **Required** | `""`  |

### Common settings

| Name                            | Description                                                                                                                                      | Value                 |
|---------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------|
| `appName`                       | Name of the service.                                                                                                                             | `citylens-routes-api` |
| `environment`                   | Environment                                                                                                                                      | `""`                  |
| `imagePullSecrets`              | Kubernetes image pull secrets.                                                                                                                   | `[]`                  |
| `nameOverride`                  | Base name to use in all the Kubernetes entities deployed by this chart.                                                                          | `""`                  |
| `fullnameOverride`              | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                                      | `""`                  |
| `priorityClassName`             | Kubernetes [pod priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/).                                     | `""`                  |
| `terminationGracePeriodSeconds` | Kubernetes [termination grace period](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/). Should be at least 300 seconds | `300`                 |

### Strategy settings

| Name                                    | Description                                                                                                                                                                                              | Value           |
|-----------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |

### Citylens routes API service settings

### Image settings

| Name                   | Description  | Value                          |
|------------------------|--------------|--------------------------------|
| `api.image.repository` | Repository.  | `2gis-on-premise/citylens-api` |
| `api.image.tag`        | Tag.         | `1.12.0`                       |
| `api.image.pullPolicy` | Pull Policy. | `IfNotPresent`                 |

### Resources settings

| Name                            | Description                                                                                                                                    | Value   |
|---------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|---------|
| `api.replicaCount`              | A replica count for the pod.                                                                                                                   | `4`     |
| `api.revisionHistoryLimit`      | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`     |
| `api.resources.requests.cpu`    | A CPU request.                                                                                                                                 | `1000m` |
| `api.resources.requests.memory` | A memory request.                                                                                                                              | `1Gi`   |
| `api.resources.limits.cpu`      | A CPU limit.                                                                                                                                   | `2000m` |
| `api.resources.limits.memory`   | A memory limit.                                                                                                                                | `2Gi`   |

### Service settings

| Name                            | Description                                                                                                                    | Value       |
|---------------------------------|--------------------------------------------------------------------------------------------------------------------------------|-------------|
| `api.service.type`              | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `api.service.port`              | Service port.                                                                                                                  | `80`        |
| `api.service.targetPort`        | Service target port.                                                                                                           | `8000`      |
| `api.service.metricsTargetPort` | Service prometheus metrics target port. Metrics are available on /healthz/metrics endpoint.                                    | `8001`      |
| `api.service.annotations`       | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `api.service.labels`            | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                                                  | Description                                                                                                           | Value                                                 |
|-----------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------|
| `api.ingress.enabled`                                                 | If Ingress is enabled for the service.                                                                                | `false`                                               |
| `api.ingress.className`                                               | Resource that contains additional configuration including the name of the controller that should implement the class. | `""`                                                  |
| `api.ingress.annotations.nginx.ingress.kubernetes.io/proxy-body-size` | Proxy-body-size parameter (default 1MB).                                                                              | `{"nginx.ingress.kubernetes.io/proxy-body-size":"0"}` |
| `api.ingress.hosts[0].host`                                           | Hostname for the Ingress service. Ex.: 'citylens.api'.                                                                | `citylens-routes-api.host`                            |
| `api.ingress.tls`                                                     | Tls settings for https.                                                                                               | `[]`                                                  |

### Metadata settings

| Name                 | Description                                                                                                                 | Value |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------|-------|
| `api.annotations`    | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`  |
| `api.labels`         | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`  |
| `api.podAnnotations` | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`  |
| `api.podLabels`      | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`  |
| `api.nodeSelector`   | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).     | `{}`  |
| `api.tolerations`    | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.       | `{}`  |
| `api.affinity`       | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings. | `{}`  |

### Api configuration settings

| Name                  | Description                                                                                                                                             | Value    |
|-----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| `api.serviceAccount`  | Kubernetes service account                                                                                                                              | `runner` |
| `api.tempPath`        | Path to directory used for temp data                                                                                                                    | `/tmp`   |
| `api.allowAnyOrigin`  | Cors policy: allow any origin to perform requests to pro-api service                                                                                    | `false`  |
| `api.logging`         | Logging settings                                                                                                                                        |          |
| `api.logging.format`  | Log message format, possible options: 'default' - compact json, 'renderedCompactJson' - rendered json format, 'simple' - plain text                     | `simple` |
| `api.logging.targets` | Collection of logging targets divided by comma. Currently only 'console' and 'database' are supported. Console is used by default (no need to specify). | `""`     |

### Citylens routes worker service settings

### Image settings

| Name                      | Description  | Value                          |
|---------------------------|--------------|--------------------------------|
| `worker.image.repository` | Repository.  | `2gis-on-premise/citylens-api` |
| `worker.image.tag`        | Tag.         | `1.12.0`                       |
| `worker.image.pullPolicy` | Pull Policy. | `IfNotPresent`                 |

### Resources settings

| Name                               | Description                                                                                                                                    | Value   |
|------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|---------|
| `worker.replicaCount`              | A replica count for the pod.                                                                                                                   | `4`     |
| `worker.revisionHistoryLimit`      | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`     |
| `worker.resources.requests.cpu`    | A CPU request.                                                                                                                                 | `1000m` |
| `worker.resources.requests.memory` | A memory request.                                                                                                                              | `1Gi`   |
| `worker.resources.limits.cpu`      | A CPU limit.                                                                                                                                   | `2000m` |
| `worker.resources.limits.memory`   | A memory limit.                                                                                                                                | `2Gi`   |

### Service settings

| Name                               | Description                                                                                                                    | Value       |
|------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|-------------|
| `worker.service.type`              | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `worker.service.port`              | Service port.                                                                                                                  | `80`        |
| `worker.service.targetPort`        | Service target port.                                                                                                           | `8000`      |
| `worker.service.metricsTargetPort` | Service prometheus metrics target port. Metrics are available on /healthz/metrics endpoint.                                    | `8001`      |
| `worker.service.annotations`       | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `worker.service.labels`            | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                                                     | Description                                                                                                           | Value                                                 |
|--------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------|
| `worker.ingress.enabled`                                                 | If Ingress is enabled for the service.                                                                                | `false`                                               |
| `worker.ingress.className`                                               | Resource that contains additional configuration including the name of the controller that should implement the class. | `""`                                                  |
| `worker.ingress.annotations.nginx.ingress.kubernetes.io/proxy-body-size` | Proxy-body-size parameter (default 1MB).                                                                              | `{"nginx.ingress.kubernetes.io/proxy-body-size":"0"}` |
| `worker.ingress.hosts[0].host`                                           | Hostname for the Ingress service. Ex.: 'citylens.api'.                                                                | `citylens-worker-service.host`                        |
| `worker.ingress.tls`                                                     | Tls settings for https.                                                                                               | `[]`                                                  |

### Metadata settings

| Name                    | Description                                                                                                                 | Value |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------|-------|
| `worker.annotations`    | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`  |
| `worker.labels`         | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`  |
| `worker.podAnnotations` | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`  |
| `worker.podLabels`      | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`  |
| `worker.nodeSelector`   | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).     | `{}`  |
| `worker.tolerations`    | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.       | `{}`  |
| `worker.affinity`       | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings. | `{}`  |

### Worker configuration settings

| Name                     | Description                                                                                                                                            | Value    |
|--------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| `worker.serviceAccount`  | Kubernetes service account                                                                                                                             | `runner` |
| `worker.tempPath`        | Path to directory used for temp data                                                                                                                   | `/tmp`   |
| `worker.logging`         | Logging settings                                                                                                                                       | `""`     |
| `worker.logging.format`  | Log message format, possible options: 'default' - compact json, 'renderedCompactJson' - rendered json format, 'simple' - plain text                    | `simple` |
| `worker.logging.targets` | Collection of logging targets divided by comma. Currently only 'console' and 'database' are supported. Console is used by default (no need to specify) | `""`     |

### Worker Kafka Bus settings

| Name                                                    | Description                                     | Value |
|---------------------------------------------------------|-------------------------------------------------|-------|
| `worker.busConfig.brokers`                              | A list of brokers for the bus configuration     | `[]`  |
| `worker.busConfigsecurityInformation.saslUsername`      | The username for SASL authentication            | `""`  |
| `worker.busConfig.securityInformation.saslPassword`     | The password for SASL authentication            | `""`  |
| `worker.busConfig.securityInformation.saslMechanism`    | The mechanism for SASL authentication           | `""`  |
| `worker.busConfig.securityInformation.securityProtocol` | The security protocol for the bus configuration | `""`  |
| `worker.busConfig.consumers.appEvents`                  | App events for the consumers                    | `""`  |
| `worker.busConfig.consumers.appEvents.topic`            | The topic for the app events                    | `""`  |
| `worker.busConfig.consumers.appEvents.groupId`          | The group ID for the app events                 | `""`  |
| `worker.busConfig.consumers.appEvents.bufferSize`       | The buffer size for the app events              | `100` |
| `worker.busConfig.consumers.appEvents.workersCount`     | The workers count for the app events            | `10`  |

### Postgres **Database settings**

| Name                                | Description                                                  | Value |
|-------------------------------------|--------------------------------------------------------------|-------|
| `postgres.connectionString`         | PostgreSQL connection string. **Required**                   | `""`  |
| `postgres.connectionStringReadonly` | PostgreSQL connection string to read only node. **Required** | `""`  |
| `postgres.password`                 | PostgreSQL password. **Required**                            | `""`  |
| `postgres.userName`                 | PostgreSQL username with rw access. **Required**             | `""`  |
| `postgres.appName`                  | PostgreSQL appname. **Required**                             | `""`  |

### Hangfire settings

| Name                                 | Description                                      | Value |
|--------------------------------------|--------------------------------------------------|-------|
| `hangfire.database.connectionString` | PostgreSQL connection string. **Required**       | `""`  |
| `hangfire.database.password`         | PostgreSQL password. **Required**                | `""`  |
| `hangfire.database.userName`         | PostgreSQL username with rw access. **Required** | `""`  |
| `hangfire.database.appName`          | PostgreSQL appname. **Required**                 | `""`  |