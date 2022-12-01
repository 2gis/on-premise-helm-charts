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
| `backend.image.tag`        | Backend service image tag.        | `1.39.0`                       |
| `admin.image.repository`   | Admin service image repository.   | `2gis-on-premise/keys-ui`      |
| `admin.image.tag`          | Admin service image tag.          | `0.3.0`                        |
| `redis.image.repository`   | Redis image repository.           | `2gis-on-premise/keys-redis`   |
| `redis.image.tag`          | Redis image tag.                  | `6.2.6-alpine3.15`             |


### Admin service settings

| Name                        | Description                                                                                                                    | Value       |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `admin.replicas`            | A replica count for the pod.                                                                                                   | `1`         |
| `admin.host`                | Base URL for the admin web interface, ex: https://keys-ui.ingress.host                                                         | `""`        |
| `admin.annotations`         | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                      | `{}`        |
| `admin.labels`              | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                | `{}`        |
| `admin.podAnnotations`      | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                  | `{}`        |
| `admin.podLabels`           | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                            | `{}`        |
| `admin.nodeSelector`        | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).            | `{}`        |
| `admin.affinity`            | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).    | `{}`        |
| `admin.tolerations`         | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.              | `{}`        |
| `admin.service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `admin.service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `admin.service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `admin.service.port`        | Service port.                                                                                                                  | `80`        |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                          | Description                            | Value          |
| ----------------------------- | -------------------------------------- | -------------- |
| `admin.ingress.enabled`       | If Ingress is enabled for the service. | `false`        |
| `admin.ingress.hosts[0].host` | Hostname for the Ingress service.      | `keys-ui.host` |


### API service settings

| Name                      | Description                                                                                                                    | Value       |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `api.adminUsers`          | Usernames and passwords of admin users. Format: `username1:password1,username2:password2`.                                     | `""`        |
| `api.replicas`            | A replica count for the pod.                                                                                                   | `1`         |
| `api.annotations`         | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                      | `{}`        |
| `api.labels`              | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                | `{}`        |
| `api.podAnnotations`      | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                  | `{}`        |
| `api.podLabels`           | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                            | `{}`        |
| `api.nodeSelector`        | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).            | `{}`        |
| `api.affinity`            | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).    | `{}`        |
| `api.tolerations`         | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.              | `{}`        |
| `api.service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `api.service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `api.service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `api.service.port`        | Service port.                                                                                                                  | `80`        |


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

| Name                  | Description                                                                                                         | Value |
| --------------------- | ------------------------------------------------------------------------------------------------------------------- | ----- |
| `import.nodeSelector` | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector). | `{}`  |


### Migrate service settings

| Name                          | Description                                                                                                         | Value |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------- | ----- |
| `migrate.initialDelaySeconds` | Delay in seconds at the service startup.                                                                            | `0`   |
| `migrate.nodeSelector`        | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector). | `{}`  |


### Tasker service settings

| Name                    | Description                                                                                                                 | Value |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `tasker.delay`          | Delay in seconds at the service startup.                                                                                    | `30s` |
| `tasker.annotations`    | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`  |
| `tasker.labels`         | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`  |
| `tasker.podAnnotations` | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`  |
| `tasker.podLabels`      | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                         | `{}`  |
| `tasker.nodeSelector`   | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).         | `{}`  |
| `tasker.affinity`       | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). | `{}`  |
| `tasker.tolerations`    | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.           | `{}`  |


### Redis settings

| Name                     | Description                                                                                                                 | Value             |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| `redis.port`             | HTTP port for Redis to listen.                                                                                              | `6379`            |
| `redis.configPath`       | Path to Redis configuration file.                                                                                           | `/opt/redis.conf` |
| `redis.password`         | Redis password. Empty string if no authentication is required.                                                              | `""`              |
| `redis.useExternalRedis` | If true, external Redis server will be used.                                                                                | `false`           |
| `redis.host`             | External Redis hostname or IP.                                                                                              | `""`              |
| `redis.db`               | External Redis database number.                                                                                             | `1`               |
| `redis.annotations`      | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`              |
| `redis.labels`           | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`              |
| `redis.podAnnotations`   | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`              |
| `redis.podLabels`        | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                         | `{}`              |
| `redis.nodeSelector`     | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).         | `{}`              |
| `redis.affinity`         | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). | `{}`              |
| `redis.tolerations`      | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.           | `{}`              |


### Database access settings

| Name                   | Description                             | Value  |
| ---------------------- | --------------------------------------- | ------ |
| `postgres.ro`          | **Settings for the read-only access**   |        |
| `postgres.ro.host`     | PostgreSQL hostname or IP. **Required** | `""`   |
| `postgres.ro.port`     | PostgreSQL port.                        | `5432` |
| `postgres.ro.name`     | PostgreSQL database name. **Required**  | `""`   |
| `postgres.ro.username` | PostgreSQL username. **Required**       | `""`   |
| `postgres.ro.password` | PostgreSQL password. **Required**       | `""`   |
| `postgres.rw`          | **Settings for the read-write access**  |        |
| `postgres.rw.host`     | PostgreSQL hostname or IP. **Required** | `""`   |
| `postgres.rw.port`     | PostgreSQL port.                        | `5432` |
| `postgres.rw.name`     | PostgreSQL database name. **Required**  | `""`   |
| `postgres.rw.username` | PostgreSQL username. **Required**       | `""`   |
| `postgres.rw.password` | PostgreSQL password. **Required**       | `""`   |


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


### Limits

| Name                                | Description                        | Value   |
| ----------------------------------- | ---------------------------------- | ------- |
| `admin.resources`                   | **Limits for the Admin service**   |         |
| `admin.resources.requests.cpu`      | A CPU request.                     | `300m`  |
| `admin.resources.requests.memory`   | A memory request.                  | `256Mi` |
| `admin.resources.limits.cpu`        | A CPU limit.                       | `1`     |
| `admin.resources.limits.memory`     | A memory limit.                    | `384Mi` |
| `api.resources`                     | **Limits for the API service**     |         |
| `api.resources.requests.cpu`        | A CPU request.                     | `50m`   |
| `api.resources.requests.memory`     | A memory request.                  | `128Mi` |
| `api.resources.limits.cpu`          | A CPU limit.                       | `1`     |
| `api.resources.limits.memory`       | A memory limit.                    | `256Mi` |
| `import.resources`                  | **Limits for the Import service**  |         |
| `import.resources.requests.cpu`     | A CPU request.                     | `10m`   |
| `import.resources.requests.memory`  | A memory request.                  | `32Mi`  |
| `import.resources.limits.cpu`       | A CPU limit.                       | `100m`  |
| `import.resources.limits.memory`    | A memory limit.                    | `64Mi`  |
| `migrate.resources`                 | **Limits for the Migrate service** |         |
| `migrate.resources.requests.cpu`    | A CPU request.                     | `10m`   |
| `migrate.resources.requests.memory` | A memory request.                  | `32Mi`  |
| `migrate.resources.limits.cpu`      | A CPU limit.                       | `100m`  |
| `migrate.resources.limits.memory`   | A memory limit.                    | `64Mi`  |
| `tasker.resources`                  | **Limits for the Tasker service**  |         |
| `tasker.resources.requests.cpu`     | A CPU request.                     | `10m`   |
| `tasker.resources.requests.memory`  | A memory request.                  | `32Mi`  |
| `tasker.resources.limits.cpu`       | A CPU limit.                       | `100m`  |
| `tasker.resources.limits.memory`    | A memory limit.                    | `64Mi`  |
| `redis.resources`                   | **Limits for Redis**               |         |
| `redis.resources.requests.cpu`      | A CPU request.                     | `50m`   |
| `redis.resources.requests.memory`   | A memory request.                  | `32Mi`  |
| `redis.resources.limits.cpu`        | A CPU limit.                       | `1`     |
| `redis.resources.limits.memory`     | A memory limit.                    | `256Mi` |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
