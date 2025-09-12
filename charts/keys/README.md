# 2GIS API Keys service

Use this Helm chart to deploy API Keys service, which is a part of 2GIS's [On-Premise solution](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/keys) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-keys.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                       | Description                       | Value                          |
| -------------------------- | --------------------------------- | ------------------------------ |
| `imagePullSecrets`         | Kubernetes image pull secrets.    | `[]`                           |
| `imagePullPolicy`          | Pull policy.                      | `IfNotPresent`                 |
| `backend.image.repository` | Backend service image repository. | `2gis-on-premise/keys-backend` |
| `backend.image.tag`        | Backend service image tag.        | `1.132.0`                      |
| `admin.image.repository`   | Admin service image repository.   | `2gis-on-premise/keys-ui`      |
| `admin.image.tag`          | Admin service image tag.          | `1.4.0`                        |

### Flags for enabling/disabling certain features.

| Name                               | Description                                | Value   |
| ---------------------------------- | ------------------------------------------ | ------- |
| `featureFlags.enableAudit`         | Enable audit logging for sending to DB.    | `false` |
| `featureFlags.enableAuditKafka`    | Enable audit logging for sending to Kafka. | `false` |
| `featureFlags.enablePublicAPISign` | Enable signing responses in Public API.    | `false` |

### Admin service settings

| Name                                          | Description                                                                                                                                                                                              | Value           |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `admin.replicas`                              | A replica count for the pod.                                                                                                                                                                             | `1`             |
| `admin.revisionHistoryLimit`                  | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                                                           | `3`             |
| `admin.strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `admin.strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `admin.strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |
| `admin.host`                                  | Base URL for the admin web interface, ex: https://keys-ui.ingress.host                                                                                                                                   | `""`            |
| `admin.badge.title`                           | A name to describe an application installation.                                                                                                                                                          | `""`            |
| `admin.badge.titleColor`                      | A font color for admin.badge.title. Any css color value is valid, e.g. "#000".                                                                                                                           | `""`            |
| `admin.badge.backgroundColor`                 | A background color for admin.badge.title. Any css color value is valid, e.g. "#00F018".                                                                                                                  | `""`            |
| `admin.annotations`                           | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                | `{}`            |
| `admin.labels`                                | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                          | `{}`            |
| `admin.podAnnotations`                        | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                            | `{}`            |
| `admin.podLabels`                             | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                      | `{}`            |
| `admin.nodeSelector`                          | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                      | `{}`            |
| `admin.affinity`                              | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                                                              | `{}`            |
| `admin.tolerations`                           | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                                        | `[]`            |
| `admin.service.annotations`                   | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                        | `{}`            |
| `admin.service.labels`                        | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                  | `{}`            |
| `admin.service.type`                          | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                                                                           | `ClusterIP`     |
| `admin.service.port`                          | Service port.                                                                                                                                                                                            | `80`            |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                       | Description                               | Value                 |
| ------------------------------------------ | ----------------------------------------- | --------------------- |
| `admin.ingress.enabled`                    | If Ingress is enabled for the service.    | `false`               |
| `admin.ingress.className`                  | Name of the Ingress controller class.     | `nginx`               |
| `admin.ingress.hosts[0].host`              | Hostname for the Ingress service.         | `keys-ui.example.com` |
| `admin.ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                   |
| `admin.ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`              |
| `admin.ingress.tls`                        | TLS configuration                         | `[]`                  |

### API service settings

| Name                                        | Description                                                                                                                                                                                                                | Value           |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `api.adminUsers`                            | Usernames and passwords of admin users. Format: `username1:password1,username2:password2`.                                                                                                                                 | `""`            |
| `api.adminSessionTTL`                       | TTL of the admin users sessions. Duration string is a sequence of decimal numbers with optional fraction and unit suffix, like `100ms`, `2.3h` or `4h35m`. Valid time units are `ns`, `us` (or `µs`), `ms`, `s`, `m`, `h`. | `336h`          |
| `api.logLevel`                              | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.                                                                                                                                  | `warning`       |
| `api.signPrivateKey`                        | RSA-PSS 2048 private key (in PKCS#1 format) for signing responses in Public API.                                                                                                                                           | `""`            |
| `api.oidc.enable`                           | If OIDC authentication is enabled.                                                                                                                                                                                         | `false`         |
| `api.oidc.enableSinglePartnerMode`          | Enable single partner mode: all users are binded to the preconfigured partner (needed when external OIDC provider is used).                                                                                                | `false`         |
| `api.oidc.enableExternalProvider`           | Enable external oidc provider: do not have access to manage users.                                                                                                                                                         | `false`         |
| `api.oidc.url`                              | URL of the OIDC provider.                                                                                                                                                                                                  | `""`            |
| `api.oidc.retryCount`                       | Maximum number of retries for requests to OIDC provider.                                                                                                                                                                   | `3`             |
| `api.oidc.timeout`                          | Timeout for requests to OIDC provider.                                                                                                                                                                                     | `3s`            |
| `api.oidc.defaultPartner`                   | **Settings for single partner mode feature. Info specified here will be returned in responses from Auth API**                                                                                                              |                 |
| `api.oidc.defaultPartner.id`                | Default partner's Id.                                                                                                                                                                                                      | `""`            |
| `api.oidc.defaultPartner.name`              | Default partner's Name.                                                                                                                                                                                                    | `""`            |
| `api.oidc.defaultPartner.role`              | Role of the user in the default partner. Can be: 'user', 'admin'.                                                                                                                                                          | `""`            |
| `api.replicas`                              | A replica count for the pod.                                                                                                                                                                                               | `1`             |
| `api.revisionHistoryLimit`                  | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                                                                             | `3`             |
| `api.strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                                       | `RollingUpdate` |
| `api.strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment).                   | `0`             |
| `api.strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                                       | `1`             |
| `api.annotations`                           | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                                  | `{}`            |
| `api.labels`                                | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                                            | `{}`            |
| `api.podAnnotations`                        | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                              | `{}`            |
| `api.podLabels`                             | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                                        | `{}`            |
| `api.nodeSelector`                          | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                                        | `{}`            |
| `api.affinity`                              | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                                                                                | `{}`            |
| `api.tolerations`                           | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                                                          | `[]`            |
| `api.service.annotations`                   | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                          | `{}`            |
| `api.service.labels`                        | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                                    | `{}`            |
| `api.service.type`                          | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                                                                                             | `ClusterIP`     |
| `api.service.port`                          | Service port.                                                                                                                                                                                                              | `80`            |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                        | Description                            | Value           |
| --------------------------- | -------------------------------------- | --------------- |
| `api.ingress.enabled`       | If Ingress is enabled for the service. | `false`         |
| `api.ingress.hosts[0].host` | Hostname for the Ingress service.      | `keys-api.host` |

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

### Import service settings

| Name                  | Description                                                                                                         | Value     |
| --------------------- | ------------------------------------------------------------------------------------------------------------------- | --------- |
| `import.logLevel`     | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.                           | `warning` |
| `import.nodeSelector` | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector). | `{}`      |
| `import.tolerations`  | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.   | `[]`      |

### Migrate service settings

| Name                          | Description                                                                                                         | Value     |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------- | --------- |
| `migrate.logLevel`            | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.                           | `warning` |
| `migrate.initialDelaySeconds` | Delay in seconds at the service startup.                                                                            | `0`       |
| `migrate.nodeSelector`        | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector). | `{}`      |
| `migrate.tolerations`         | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.   | `[]`      |

### Tasker service settings

| Name                                           | Description                                                                                                                                                                                              | Value           |
| ---------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `tasker.logLevel`                              | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.                                                                                                                | `warning`       |
| `tasker.delay`                                 | Delay in seconds at the service startup.                                                                                                                                                                 | `30s`           |
| `tasker.revisionHistoryLimit`                  | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                                                           | `3`             |
| `tasker.strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `tasker.strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `tasker.strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |
| `tasker.annotations`                           | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                | `{}`            |
| `tasker.labels`                                | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                          | `{}`            |
| `tasker.podAnnotations`                        | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                            | `{}`            |
| `tasker.podLabels`                             | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                      | `{}`            |
| `tasker.nodeSelector`                          | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                      | `{}`            |
| `tasker.affinity`                              | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                                                              | `{}`            |
| `tasker.tolerations`                           | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                                        | `[]`            |

### Dispatcher settings

| Name                                                 | Description                                                                                                                                                                                              | Value           |
| ---------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `dispatcher.enabled`                                 | If dispatcher worker is deployed.                                                                                                                                                                        | `false`         |
| `dispatcher.logLevel`                                | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.                                                                                                                | `warning`       |
| `dispatcher.replicas`                                | A replica count for the pod.                                                                                                                                                                             | `1`             |
| `dispatcher.auditEvents.sendInterval`                | Send audit events interval                                                                                                                                                                               | `1m`            |
| `dispatcher.auditEvents.batchMaxSize`                | Max batch size when sending audit events                                                                                                                                                                 | `1000`          |
| `dispatcher.auditEvents.holdDuration`                | In case of an unsuccessful attempt to send messages, the service will not resend it for a given duration                                                                                                 | `10m`           |
| `dispatcher.strategy.type`                           | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `dispatcher.strategy.rollingUpdate.maxUnavailable`   | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `dispatcher.strategy.rollingUpdate.maxSurge`         | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |
| `dispatcher.annotations`                             | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                | `{}`            |
| `dispatcher.labels`                                  | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                          | `{}`            |
| `dispatcher.podAnnotations`                          | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                            | `{}`            |
| `dispatcher.podLabels`                               | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                      | `{}`            |
| `dispatcher.nodeSelector`                            | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                      | `{}`            |
| `dispatcher.affinity`                                | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                                                              | `{}`            |
| `dispatcher.tolerations`                             | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                                        | `[]`            |
| `dispatcher.cleaner`                                 | **Settings for cronjob that cleans sent messages from database**                                                                                                                                         |                 |
| `dispatcher.cleaner.logLevel`                        | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.                                                                                                                | `warning`       |
| `dispatcher.cleaner.auditEvents.retentionDuration`   | Retention period for successfully sent audit messages.                                                                                                                                                   | `4320h`         |
| `dispatcher.cleaner.cron.schedule`                   | Cron job schedule.                                                                                                                                                                                       | `0 1 * * *`     |
| `dispatcher.cleaner.cron.successfulJobsHistoryLimit` | Specifies the number of successful finished jobs to keep. See [jobs history limits](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#jobs-history-limits).                           | `3`             |
| `dispatcher.cleaner.cron.failedJobsHistoryLimit`     | Specifies the number of failed finished jobs to keep. See [jobs history limits](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#jobs-history-limits).                               | `3`             |
| `dispatcher.cleaner.cron.suspend`                    | You can suspend execution of Jobs for a CronJob, by setting the field to true. See [schedule suspension](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#schedule-suspension).      | `false`         |
| `dispatcher.cleaner.nodeSelector`                    | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                      | `{}`            |

### Counter settings

| Name                                  | Description                                                                                                                                                                                         | Value     |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| `counter.enabled`                     | Counter worker is enabled.                                                                                                                                                                          | `false`   |
| `counter.replicas`                    | A replica count for the pod.                                                                                                                                                                        | `1`       |
| `counter.resources.requests.cpu`      | A CPU request.                                                                                                                                                                                      | `20m`     |
| `counter.resources.requests.memory`   | A memory request.                                                                                                                                                                                   | `32Mi`    |
| `counter.resources.limits.cpu`        | A CPU limit.                                                                                                                                                                                        | `1000m`   |
| `counter.resources.limits.memory`     | A memory limit.                                                                                                                                                                                     | `512Mi`   |
| `counter.logLevel`                    | Log level for the worker. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.                                                                                                            | `warning` |
| `counter.preloader.refreshTick`       | Refresh interval for in-memory cache with keys limitations info. The smaller the interval, the faster the worker will know about changes in limitations.                                            | `1m`      |
| `counter.updateStatusQueryTimeout`    | Timeout for database queries to update key status.                                                                                                                                                  | `1s`      |
| `counter.buffer`                      | **Settings for in-memory buffer for statistics data.**                                                                                                                                              |           |
| `counter.buffer.size`                 | The maximum size of the buffer. When the limit is reached, the data from the buffer is transferred to Redis.                                                                                        | `1000`    |
| `counter.buffer.delay`                | The maximum interval between data transfer operations from the buffer to Redis.                                                                                                                     | `1s`      |
| `counter.buffer.splitFactor`          | The factor by which the buffer is divided into parts for parallel processing. The higher the value, the smaller the size of each part, but the more frequent the data transfer operations to Redis. | `2`       |
| `counter.parallelismFactor`           | Default value for calculating the number of workers. If set to 0, the default value will be equal to the Linux container CPU quota.                                                                 | `0`       |
| `counter.workers`                     | **Number of workers for each processing stage. If set to 0, `counter.parallelismFactor` will be used.**                                                                                             |           |
| `counter.workers.eventParser`         | Number of event parser workers.                                                                                                                                                                     | `0`       |
| `counter.workers.eventFilterer`       | Number of event filterer workers.                                                                                                                                                                   | `0`       |
| `counter.workers.eventMetricGatherer` | Number of event metric gatherer workers.                                                                                                                                                            | `0`       |
| `counter.workers.eventConverter`      | Number of event converter workers.                                                                                                                                                                  | `0`       |
| `counter.workers.incrementFilterer`   | Number of increment filterer workers.                                                                                                                                                               | `0`       |
| `counter.workers.incrementSaver`      | Number of increment saver workers.                                                                                                                                                                  | `0`       |
| `counter.redis`                       | **Redis settings**                                                                                                                                                                                  |           |
| `counter.redis.retries`               | Number of retries for Redis operations.                                                                                                                                                             | `5`       |
| `counter.redis.minRetryBackoff`       | Minimum backoff between each retry.                                                                                                                                                                 | `100ms`   |
| `counter.redis.maxRetryBackoff`       | Maximum backoff between each retry.                                                                                                                                                                 | `3s`      |
| `counter.redis.dialTimeout`           | Dial timeout for establishing new connections.                                                                                                                                                      | `3s`      |
| `counter.redis.writeTimeout`          | Write timeout for Redis commands.                                                                                                                                                                   | `10s`     |
| `counter.redis.readTimeout`           | Read timeout for Redis commands.                                                                                                                                                                    | `10s`     |
| `counter.annotations`                 | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                           | `{}`      |
| `counter.labels`                      | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                     | `{}`      |
| `counter.podAnnotations`              | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                       | `{}`      |
| `counter.podLabels`                   | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                 | `{}`      |
| `counter.nodeSelector`                | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                 | `{}`      |
| `counter.affinity`                    | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                                                         | `{}`      |
| `counter.tolerations`                 | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                                   | `{}`      |

### Redis settings

| Name             | Description                                                    | Value  |
| ---------------- | -------------------------------------------------------------- | ------ |
| `redis.host`     | Redis hostname or IP.                                          | `""`   |
| `redis.port`     | Redis port.                                                    | `6379` |
| `redis.db`       | Redis database number.                                         | `1`    |
| `redis.password` | Redis password. Empty string if no authentication is required. | `""`   |

### Database access settings

| Name                         | Description                                                                                                                                                                          | Value     |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------- |
| `postgres.ro`                | **Settings for the read-only access**                                                                                                                                                |           |
| `postgres.ro.host`           | PostgreSQL one or multiple hostnames or IPs separated by comma (e.g. 'host1,host2,10.0.0.1').  **Required**                                                                          | `""`      |
| `postgres.ro.port`           | PostgreSQL one or multiple ports (one for each host). Values must be separated by comma (e.g. '1234,4567,5432').                                                                     | `5432`    |
| `postgres.ro.timeout`        | PostgreSQL client connection timeout.                                                                                                                                                | `3s`      |
| `postgres.ro.name`           | PostgreSQL database name. **Required**                                                                                                                                               | `""`      |
| `postgres.ro.schema`         | PostgreSQL database schema. If not specified, schema from SEARCH_PATH will be used.                                                                                                  | `""`      |
| `postgres.ro.username`       | PostgreSQL username. **Required**                                                                                                                                                    | `""`      |
| `postgres.ro.password`       | PostgreSQL password. **Required**                                                                                                                                                    | `""`      |
| `postgres.ro.tls.mode`       | PostgreSQL ssl [connection mode](https://www.postgresql.org/docs/current/libpq-ssl.html#LIBPQ-SSL-PROTECTION). Available modes: `disable`, `require`, `verify-ca` and `verify-full`. | `disable` |
| `postgres.ro.tls.serverCA`   | PostgreSQL CA certificate for server CA verify. **Required for mode `verify-ca` or `verify-full`**.                                                                                  | `""`      |
| `postgres.ro.tls.clientCert` | client certificate. **Required for mode `verify-full`**.                                                                                                                             | `""`      |
| `postgres.ro.tls.clientKey`  | client private key. **Required for mode `verify-full`**.                                                                                                                             | `""`      |
| `postgres.rw`                | **Settings for the read-write access**                                                                                                                                               |           |
| `postgres.rw.host`           | PostgreSQL one or multiple hostnames or IPs separated by comma (e.g. 'host1,host2,host3').  **Required**                                                                             | `""`      |
| `postgres.rw.port`           | PostgreSQL one or multiple ports (one for each host). Values must be separated by comma (e.g. '1234,4567,5432').                                                                     | `5432`    |
| `postgres.rw.timeout`        | PostgreSQL client connection timeout.                                                                                                                                                | `3s`      |
| `postgres.rw.name`           | PostgreSQL database name. **Required**                                                                                                                                               | `""`      |
| `postgres.rw.schema`         | PostgreSQL database schema. If not specified, schema from SEARCH_PATH will be used.                                                                                                  | `""`      |
| `postgres.rw.username`       | PostgreSQL username. **Required**                                                                                                                                                    | `""`      |
| `postgres.rw.password`       | PostgreSQL password. **Required**                                                                                                                                                    | `""`      |
| `postgres.rw.tls.mode`       | PostgreSQL ssl [connection mode](https://www.postgresql.org/docs/current/libpq-ssl.html#LIBPQ-SSL-PROTECTION). Available modes: `disable`, `require`, `verify-ca` and `verify-full`. | `disable` |
| `postgres.rw.tls.serverCA`   | PostgreSQL CA certificate for server CA verify. **Required for mode `verify-ca` or `verify-full`**.                                                                                  | `""`      |
| `postgres.rw.tls.clientCert` | client certificate. **Required for mode `verify-full`**.                                                                                                                             | `""`      |
| `postgres.rw.tls.clientKey`  | client private key. **Required for mode `verify-full`**.                                                                                                                             | `""`      |

### Kafka settings

| Name                                    | Description                                                                                                                                                | Value       |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `kafka.bootstrapServers`                | Comma-separated list of host and port pairs that are the addresses of the Kafka brokers (e.g. 'localhost:9092,localhost:9093'). **Required**               | `""`        |
| `kafka.securityProtocol`                | Protocol used to communicate with brokers. Valid values are: PLAINTEXT, SSL, SASL_PLAINTEXT, SASL_SSL. Default: PLAINTEXT.                                 | `PLAINTEXT` |
| `kafka.saslMechanism`                   | Authentication mechanism when security_protocol is configured for SASL_PLAINTEXT or SASL_SSL. Valid values are: PLAIN, SCRAM-SHA-256, SCRAM-SHA-512.       | `PLAIN`     |
| `kafka.username`                        | Username for authorization (SASL).                                                                                                                         | `""`        |
| `kafka.password`                        | Password for authorization (SASL).                                                                                                                         | `""`        |
| `kafka.tls.skipServerCertificateVerify` | Controls whether a client verifies the server's certificate chain and host name.                                                                           | `false`     |
| `kafka.tls.serverCA`                    | Server's root certificate.                                                                                                                                 | `""`        |
| `kafka.tls.clientCert`                  | Client certificate.                                                                                                                                        | `""`        |
| `kafka.tls.clientKey`                   | Client key.                                                                                                                                                | `""`        |
| `kafka.stats`                           | **Settings for consuming key's usage statistics messages.**                                                                                                |             |
| `kafka.stats.topic`                     | Topic to consume stat messages from. **Required**                                                                                                          | `""`        |
| `kafka.stats.groupId`                   | Name of the consumer group to use. **Required**                                                                                                            | `""`        |
| `kafka.stats.clientId`                  | Client id. If empty hostname will be used.                                                                                                                 | `""`        |
| `kafka.stats.fetchDefault`              | Default fetch size. KB, MB, GB refers to 2^10, 2^20, 2^30 bytes respectively. Plain number refers to bytes.                                                | `1MB`       |
| `kafka.stats.fetchMin`                  | Minimum fetch size. KB, MB, GB refers to 2^10, 2^20, 2^30 bytes respectively. Plain number refers to bytes.                                                | `100KB`     |
| `kafka.stats.fetchMax`                  | Maximum fetch size. KB, MB, GB refers to 2^10, 2^20, 2^30 bytes respectively. Plain number refers to bytes. '0' means no limit.                            | `0`         |
| `kafka.stats.fetchMaxWaitTime`          | Maximum wait time for fetch response.                                                                                                                      | `250ms`     |
| `kafka.audit`                           | **Settings for sending audit messages.**                                                                                                                   |             |
| `kafka.audit.topic`                     | Topic to produce audit messages. **Required**                                                                                                              | `""`        |
| `kafka.audit.produce.retryCount`        | Number of retries to produce a message.                                                                                                                    | `5`         |
| `kafka.audit.produce.idempotentWrite`   | Flag to enable/disable [idempotent write](https://docs.confluent.io/platform/current/installation/configuration/producer-configs.html#enable-idempotence). | `true`      |

### LDAP connection settings

| Name                                  | Description                                        | Value                                      |
| ------------------------------------- | -------------------------------------------------- | ------------------------------------------ |
| `ldap.host`                           | LDAP host.                                         | `""`                                       |
| `ldap.port`                           | LDAP port.                                         | `3268`                                     |
| `ldap.useStartTLS`                    | If LDAP should use TLS.                            | `false`                                    |
| `ldap.useLDAPS`                       | Use LDAPS instead of LDAP.                         | `false`                                    |
| `ldap.skipServerCertificateVerify`    | Trust the server certificate without verification. | `false`                                    |
| `ldap.serverName`                     | Server name.                                       | `""`                                       |
| `ldap.clientCertificatePath`          | Path to client certificate for authentication.     | `""`                                       |
| `ldap.clientKeyPath`                  | Path to client key for authentication.             | `""`                                       |
| `ldap.rootCertificateAuthoritiesPath` | Path to the Root CA certificate.                   | `""`                                       |
| `ldap.bind`                           | **LDAP bind settings**                             |                                            |
| `ldap.bind.dn`                        | LDAP distinguished name.                           | `user`                                     |
| `ldap.bind.password`                  | LDAP password.                                     | `secret`                                   |
| `ldap.search`                         | **LDAP search settings**                           |                                            |
| `ldap.search.baseDN`                  | LDAP base distinguished name.                      | `dc=2gis`                                  |
| `ldap.search.filter`                  | LDAP search filter.                                | `(&(objectClass=user)(sAMAccountName=%s))` |

### Predefined keys

| Name                         | Description                     | Value |
| ---------------------------- | ------------------------------- | ----- |
| `predefined.service`         | Predefined service keys.        |       |
| `predefined.service.keys`    | Keys map as: service -> key.    | `{}`  |
| `predefined.service.aliases` | Aliases map as: service -> key. | `{}`  |

### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                              | Value   |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`. **Required**                                                                                                                                                                                                           | `""`    |
| `dgctlStorage.region`    | S3 region name.                                                                                                                                                                                                                                          | `""`    |
| `dgctlStorage.secure`    | Set to `true` if dgctlStorage.host must be accessed via https. **Required**                                                                                                                                                                              | `false` |
| `dgctlStorage.verifySsl` | Set to `false` if dgctlStorage.host must be accessed via https without certificate validation. **Required**                                                                                                                                              | `true`  |
| `dgctlStorage.bucket`    | S3 bucket name.                                                                                                                                                                                                                                          | `""`    |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket. **Required**                                                                                                                                                                                                     | `""`    |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket. **Required**                                                                                                                                                                                                     | `""`    |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json` <br> This file contains the description of pieces of data that the service requires to operate. | `""`    |

### Limits

| Name                                           | Description                           | Value   |
| ---------------------------------------------- | ------------------------------------- | ------- |
| `admin.resources`                              | **Limits for the Admin service**      |         |
| `admin.resources.requests.cpu`                 | A CPU request.                        | `300m`  |
| `admin.resources.requests.memory`              | A memory request.                     | `256Mi` |
| `admin.resources.limits.cpu`                   | A CPU limit.                          | `1`     |
| `admin.resources.limits.memory`                | A memory limit.                       | `384Mi` |
| `api.resources`                                | **Limits for the API service**        |         |
| `api.resources.requests.cpu`                   | A CPU request.                        | `50m`   |
| `api.resources.requests.memory`                | A memory request.                     | `128Mi` |
| `api.resources.limits.cpu`                     | A CPU limit.                          | `1`     |
| `api.resources.limits.memory`                  | A memory limit.                       | `256Mi` |
| `import.resources`                             | **Limits for the Import service**     |         |
| `import.resources.requests.cpu`                | A CPU request.                        | `10m`   |
| `import.resources.requests.memory`             | A memory request.                     | `32Mi`  |
| `import.resources.limits.cpu`                  | A CPU limit.                          | `100m`  |
| `import.resources.limits.memory`               | A memory limit.                       | `64Mi`  |
| `migrate.resources`                            | **Limits for the Migrate service**    |         |
| `migrate.resources.requests.cpu`               | A CPU request.                        | `10m`   |
| `migrate.resources.requests.memory`            | A memory request.                     | `32Mi`  |
| `migrate.resources.limits.cpu`                 | A CPU limit.                          | `100m`  |
| `migrate.resources.limits.memory`              | A memory limit.                       | `64Mi`  |
| `tasker.resources`                             | **Limits for the Tasker service**     |         |
| `tasker.resources.requests.cpu`                | A CPU request.                        | `10m`   |
| `tasker.resources.requests.memory`             | A memory request.                     | `32Mi`  |
| `tasker.resources.limits.cpu`                  | A CPU limit.                          | `100m`  |
| `tasker.resources.limits.memory`               | A memory limit.                       | `64Mi`  |
| `dispatcher.resources`                         | **Limits for the Dispatcher service** |         |
| `dispatcher.resources.requests.cpu`            | A CPU request.                        | `10m`   |
| `dispatcher.resources.requests.memory`         | A memory request.                     | `32Mi`  |
| `dispatcher.resources.limits.cpu`              | A CPU limit.                          | `100m`  |
| `dispatcher.resources.limits.memory`           | A memory limit.                       | `64Mi`  |
| `dispatcher.cleaner.resources`                 | **Limits for the Cleaner service**    |         |
| `dispatcher.cleaner.resources.requests.cpu`    | A CPU request.                        | `10m`   |
| `dispatcher.cleaner.resources.requests.memory` | A memory request.                     | `32Mi`  |
| `dispatcher.cleaner.resources.limits.cpu`      | A CPU limit.                          | `100m`  |
| `dispatcher.cleaner.resources.limits.memory`   | A memory limit.                       | `64Mi`  |
| `counter.resources`                            | **Limits for the Counter service**    |         |
| `counter.resources.requests.cpu`               | A CPU request.                        | `20m`   |
| `counter.resources.requests.memory`            | A memory request.                     | `32Mi`  |
| `counter.resources.limits.cpu`                 | A CPU limit.                          | `1000m` |
| `counter.resources.limits.memory`              | A memory limit.                       | `512Mi` |

### customCAs **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container.                                                                          | `""`  |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
