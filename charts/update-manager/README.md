# 2GIS Update Manager

Use this Helm chart to deploy Update Manager service, which is a part of
2GIS's [On-Premise solution](https://docs.2gis.com/en/on-premise/overview).

See the [documentation](https://docs.2gis.com/en/on-premise/TODO) to learn about:

- Architecture of the service.

- Installing the service.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name               | Description                    | Value                            |
| ------------------ | ------------------------------ | -------------------------------- |
| `imagePullSecrets` | Kubernetes image pull secrets. | `[]`                             |
| `imagePullPolicy`  | Pull policy.                   | `IfNotPresent`                   |
| `image.repository` | Service image repository.      | `2gis-on-premise/update-manager` |
| `image.tag`        | Service image tag.             | `1.0.0`                          |

### API service settings

| Name                                        | Description                                                                                                                                                                                              | Value                              |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `api.logLevel`                              | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.                                                                                                                | `warning`                          |
| `api.logFormat`                             | Log format for the service. Can be: `json, text`.                                                                                                                                                        | `json`                             |
| `api.oidc.url`                              | URL of the OIDC provider. **Required**                                                                                                                                                                   | `""`                               |
| `api.oidc.issuerUrl`                        | Allows discovery to work when the issuer_url reported by upstream is mismatched with the discovery URL.                                                                                                  | `""`                               |
| `api.dgctl.datagatewayURL`                  | URL of the DataGateway instance. **Required**                                                                                                                                                            | `https://datagateway.api.2gis.com` |
| `api.dgctl.apiKey`                          | API key for the DataGateway instance. **Required**                                                                                                                                                       | `""`                               |
| `api.dgctl.image.registry`                  | DGCTL image registry.                                                                                                                                                                                    | `""`                               |
| `api.dgctl.image.repository`                | DGCTL image repository. **Required**                                                                                                                                                                     | `2gis/dgctl`                       |
| `api.dgctl.image.tag`                       | DGCTL image tag.                                                                                                                                                                                         | `3`                                |
| `api.job.activeDeadline`                    | Active deadline fot the created jobs.                                                                                                                                                                    | `2h`                               |
| `api.job.backoffLimit`                      | Backoff limit for the created jobs.                                                                                                                                                                      | `3`                                |
| `api.job.syncInterval`                      | Interval for syncing jobs.                                                                                                                                                                               | `10s`                              |
| `api.manifest.syncInterval`                 | Interval for syncing manifests.                                                                                                                                                                          | `60s`                              |
| `api.helmTimeout`                           | Timeout for helm operations.                                                                                                                                                                             | `10m`                              |
| `api.rollbackHistoryLimit`                  | Installation history limit for rollback.                                                                                                                                                                 | `2`                                |
| `api.installVersionsLimit`                  | Number of install versions to show.                                                                                                                                                                      | `3`                                |
| `api.completedTaskOffset`                   | Duration to show completed tasks.                                                                                                                                                                        | `12h`                              |
| `api.manifestUpdateOffset`                  | Duration to show manifest updates.                                                                                                                                                                       | `8h`                               |
| `api.components`                            | List of installed Helm releases grouped by component name.                                                                                                                                               | `nil`                              |
| `api.replicas`                              | A replica count for the pod.                                                                                                                                                                             | `1`                                |
| `api.revisionHistoryLimit`                  | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                                                           | `3`                                |
| `api.strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate`                    |
| `api.strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`                                |
| `api.strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`                                |
| `api.annotations`                           | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                | `{}`                               |
| `api.labels`                                | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                          | `{}`                               |
| `api.podAnnotations`                        | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                            | `{}`                               |
| `api.podLabels`                             | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                      | `{}`                               |
| `api.nodeSelector`                          | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                      | `{}`                               |
| `api.affinity`                              | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                                                              | `{}`                               |
| `api.tolerations`                           | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                                        | `[]`                               |
| `api.service.annotations`                   | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                        | `{}`                               |
| `api.service.labels`                        | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                  | `{}`                               |
| `api.service.type`                          | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                                                                           | `ClusterIP`                        |
| `api.service.port`                          | Service port.                                                                                                                                                                                            | `80`                               |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                        | Description                            | Value                 |
| --------------------------- | -------------------------------------- | --------------------- |
| `api.ingress.enabled`       | If Ingress is enabled for the service. | `false`               |
| `api.ingress.hosts[0].host` | Hostname for the Ingress service.      | `update-manager.host` |

### Migrate job settings

| Name                          | Description                                                                                                         | Value |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------- | ----- |
| `migrate.initialDelaySeconds` | Delay in seconds at the service startup.                                                                            | `0`   |
| `migrate.nodeSelector`        | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector). | `{}`  |
| `migrate.tolerations`         | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.   | `[]`  |

### Database access settings

| Name                    | Description                                                                                                                                                                          | Value     |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------- |
| `postgres.host`         | PostgreSQL hostname or IP.  **Required**                                                                                                                                             | `""`      |
| `postgres.port`         | PostgreSQL port.                                                                                                                                                                     | `5432`    |
| `postgres.timeout`      | PostgreSQL client connection timeout.                                                                                                                                                | `3s`      |
| `postgres.name`         | PostgreSQL database name. **Required**                                                                                                                                               | `""`      |
| `postgres.username`     | PostgreSQL username. **Required**                                                                                                                                                    | `""`      |
| `postgres.password`     | PostgreSQL password. **Required**                                                                                                                                                    | `""`      |
| `postgres.tls.mode`     | PostgreSQL ssl [connection mode](https://www.postgresql.org/docs/current/libpq-ssl.html#LIBPQ-SSL-PROTECTION). Available modes: `disable`, `require`, `verify-ca` and `verify-full`. | `disable` |
| `postgres.tls.rootCert` | PostgreSQL CA certificate for server CA verify. **Required for mode `verify-ca` or `verify-full`**.                                                                                  | `""`      |
| `postgres.tls.cert`     | client certificate. **Required for mode `verify-full`**.                                                                                                                             | `""`      |
| `postgres.tls.key`      | client private key. **Required for mode `verify-full`**.                                                                                                                             | `""`      |

### Deployment Artifacts Storage settings

| Name                     | Description                                                                 | Value   |
| ------------------------ | --------------------------------------------------------------------------- | ------- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`. **Required**                              | `""`    |
| `dgctlStorage.region`    | S3 region name.                                                             | `""`    |
| `dgctlStorage.secure`    | Set to `true` if dgctlStorage.host must be accessed via https. **Required** | `false` |
| `dgctlStorage.bucket`    | S3 bucket name. **Required**                                                | `""`    |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket. **Required**                        | `""`    |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket. **Required**                        | `""`    |

### Limits

| Name                                | Description                    | Value   |
| ----------------------------------- | ------------------------------ | ------- |
| `api.resources`                     | **Limits for the API service** |         |
| `api.resources.requests.cpu`        | A CPU request.                 | `50m`   |
| `api.resources.requests.memory`     | A memory request.              | `128Mi` |
| `api.resources.limits.cpu`          | A CPU limit.                   | `1`     |
| `api.resources.limits.memory`       | A memory limit.                | `256Mi` |
| `migrate.resources`                 | **Limits for the Migrate job** |         |
| `migrate.resources.requests.cpu`    | A CPU request.                 | `10m`   |
| `migrate.resources.requests.memory` | A memory request.              | `32Mi`  |
| `migrate.resources.limits.cpu`      | A CPU limit.                   | `100m`  |
| `migrate.resources.limits.memory`   | A memory limit.                | `64Mi`  |

### customCAs **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container.                                                                          | `""`  |

## Maintainers

| Name | Email                 | Url                       |
|------|-----------------------|---------------------------|
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
