# Stat API Helm Chart

Use this Helm chart to deploy API Stat service, which is a part of 2GIS's [On-Premise solution](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                       | Description                    | Value                              |
| -------------------------- | ------------------------------ | ---------------------------------- |
| `imagePullSecrets`         | Kubernetes image pull secrets. | `[]`                               |
| `imagePullPolicy`          | Pull policy.                   | `IfNotPresent`                     |
| `api.image.repository`     | API service image repository.  | `2gis-on-premise/stat-api`         |
| `api.image.tag`            | API service image tag.         | `0.2.0`                            |
| `migrate.image.repository` | Migrate tool image repository. | `2gis-on-premise/stat-api-migrate` |
| `migrate.image.tag`        | Migrate tool image tag.        | `0.2.0`                            |

### Kubernetes [Service Account](https://kubernetes.io/docs/concepts/security/service-accounts/) settings

| Name                         | Description                                                                                                            | Value   |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created                                                                  | `false` |
| `serviceAccount.automount`   | Automatically mount a ServiceAccount's API credentials?                                                                | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account                                                                              | `{}`    |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template | `""`    |

### API service settings

| Name                                        | Description                                                                                                                                                                                              | Value           |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `api.logLevel`                              | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.                                                                                                                | `warning`       |
| `api.clickhouse.clientName`                 | Name that will be used in client requests to ClickHouse.                                                                                                                                                 | `stat-api`      |
| `api.replicas`                              | A replica count for the pod.                                                                                                                                                                             | `1`             |
| `api.revisionHistoryLimit`                  | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                                                           | `3`             |
| `api.strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `api.strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `api.strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |
| `api.annotations`                           | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                | `{}`            |
| `api.labels`                                | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                          | `{}`            |
| `api.podAnnotations`                        | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                            | `{}`            |
| `api.podLabels`                             | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                      | `{}`            |
| `api.nodeSelector`                          | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                      | `{}`            |
| `api.affinity`                              | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                                                              | `{}`            |
| `api.tolerations`                           | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                                        | `[]`            |
| `api.service.annotations`                   | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                        | `{}`            |
| `api.service.labels`                        | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                  | `{}`            |
| `api.service.type`                          | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                                                                           | `ClusterIP`     |
| `api.service.port`                          | Service port.                                                                                                                                                                                            | `80`            |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                     | Description                               | Value           |
| ---------------------------------------- | ----------------------------------------- | --------------- |
| `api.ingress.enabled`                    | If Ingress is enabled for the service.    | `false`         |
| `api.ingress.hosts[0].host`              | Hostname for the Ingress service.         | `stat-api.host` |
| `api.ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`             |
| `api.ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`        |
| `api.ingress.tls`                        | TLS configuration                         | `[]`            |

### Kubernetes [HTTPRoute](https://gateway-api.sigs.k8s.io/api-types/httproute/) settings

| Name                       | Description                                                                                                                                                                           | Value   |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `api.httpRoute.enabled`    | If HTTPRoute is enabled for the service.                                                                                                                                              | `false` |
| `api.httpRoute.hostnames`  | Array of [Hostnames](https://gateway-api.sigs.k8s.io/reference/spec/#hostname) for the HTTPRoute [spec](https://gateway-api.sigs.k8s.io/reference/spec/#httproutespec).               | `[]`    |
| `api.httpRoute.parentRefs` | Array of [ParentReferences](https://gateway-api.sigs.k8s.io/reference/spec/#parentreference) for the HTTPRoute [spec](https://gateway-api.sigs.k8s.io/reference/spec/#httproutespec). | `[]`    |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                          | Description                                                                                                                                                          | Value   |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `api.hpa.enabled`                             | If HPA is enabled for the service.                                                                                                                                   | `false` |
| `api.hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`     |
| `api.hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `2`     |
| `api.hpa.scaleDownStabilizationWindowSeconds` | Scale-down window.                                                                                                                                                   | `""`    |
| `api.hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window.                                                                                                                                                     | `""`    |
| `api.hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`    |
| `api.hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`    |

### Migrate tool settings

| Name                               | Description                                                                                                         | Value              |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------------------ |
| `migrate.logLevel`                 | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.                           | `info`             |
| `migrate.kafkaTableEngine.brokers` | Kafka brokers address list, separated by comma.                                                                     | `""`               |
| `migrate.kafkaTableEngine.topic`   | Kafka topic with data from stat-receiver (e.g. -- `type.401``).                                                     | `""`               |
| `migrate.kafkaTableEngine.group`   | Consumer group name.                                                                                                | `""`               |
| `migrate.clickhouse.clientName`    | Name that will be used in client requests to ClickHouse.                                                            | `stat-api-migrate` |
| `migrate.initialDelaySeconds`      | Delay in seconds at the service startup.                                                                            | `0`                |
| `migrate.nodeSelector`             | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector). | `{}`               |
| `migrate.tolerations`              | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.   | `[]`               |

### ClickHouse settings

| Name                                | Description                                                                                                                                                          | Value      |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| `clickhouse.servers`                | Comma-separated list of ClickHouse server addresses. Format: `host1:port1,host2:port2`.                                                                              | `""`       |
| `clickhouse.cluster`                | ClickHouse cluster name for distributed queries, migrations.                                                                                                         | `""`       |
| `clickhouse.database`               | ClickHouse database name to connect to.                                                                                                                              | `""`       |
| `clickhouse.username`               | ClickHouse username for authentication.                                                                                                                              | `""`       |
| `clickhouse.password`               | ClickHouse password for authentication.                                                                                                                              | `""`       |
| `clickhouse.maxQueryExecutionTime`  | Query [maximum execution time](https://clickhouse.com/docs/operations/settings/settings#max_execution_time) in seconds.                                              | `60`       |
| `clickhouse.maxOpenConnections`     | Maximum number of open connections to ClickHouse.                                                                                                                    | `10`       |
| `clickhouse.maxIdleConnections`     | Maximum number of idle connections in the pool.                                                                                                                      | `5`        |
| `clickhouse.connectionTimeout`      | Connection timeout duration (e.g., `10s`, `1m`).                                                                                                                     | `10s`      |
| `clickhouse.connectionMaxLifetime`  | Maximum lifetime of a connection (e.g., `1h`, `30m`).                                                                                                                | `1h`       |
| `clickhouse.connectionOpenStrategy` | Connection opening strategy configures algorithm with which it will be decided that server to use for a new connection. Can be: `in_order`, `round_robin`, `random`. | `in_order` |
| `clickhouse.connectionTimeout`      | Connection timeout duration (e.g., `10s`, `1m`).                                                                                                                     | `10s`      |
| `clickhouse.connectionMaxLifetime`  | Maximum lifetime of a connection (e.g., `1h`, `30m`).                                                                                                                | `1h`       |
| `clickhouse.connectionOpenStrategy` | Connection opening strategy for multiple servers. Can be: `in_order`, `round_robin`, `random`.                                                                       | `in_order` |
| `clickhouse.pingMaxRetries`         | Maximum number of ping retries during connection attempts.                                                                                                           | `5`        |
| `clickhouse.pingRetryDelay`         | Delay between ping retries (e.g., `3s`, `5s`).                                                                                                                       | `3s`       |

### ClickHouse TLS settings

| Name                                         | Description                                                                                                                            | Value   |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `clickhouse.tls.enabled`                     | Enable TLS/SSL connection to ClickHouse.                                                                                               | `false` |
| `clickhouse.tls.skipServerCertificateVerify` | Skip server certificate verification (insecure). When `true`, the client will not verify the server's certificate chain and host name. | `false` |
| `clickhouse.tls.serverCA`                    | ClickHouse server CA certificate in PEM format. If not provided, system root CAs will be used for server certificate verification.     | `""`    |
| `clickhouse.tls.clientCert`                  | ClickHouse client certificate in PEM format for mutual TLS authentication. **Required for mutual TLS**.                                | `""`    |
| `clickhouse.tls.clientKey`                   | ClickHouse client private key in PEM format for mutual TLS authentication. **Required for mutual TLS**.                                | `""`    |

### Limits

| Name                                | Description                     | Value   |
| ----------------------------------- | ------------------------------- | ------- |
| `api.resources`                     | **Limits for the API service**  |         |
| `api.resources.requests.cpu`        | A CPU request.                  | `50m`   |
| `api.resources.requests.memory`     | A memory request.               | `128Mi` |
| `api.resources.limits.cpu`          | A CPU limit.                    | `1`     |
| `api.resources.limits.memory`       | A memory limit.                 | `256Mi` |
| `migrate.resources`                 | **Limits for the Migrate tool** |         |
| `migrate.resources.requests.cpu`    | A CPU request.                  | `10m`   |
| `migrate.resources.requests.memory` | A memory request.               | `32Mi`  |
| `migrate.resources.limits.cpu`      | A CPU limit.                    | `100m`  |
| `migrate.resources.limits.memory`   | A memory limit.                 | `64Mi`  |

### customCAs **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container.                                                                          | `""`  |
