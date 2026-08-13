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
| `api.logFormat`                             | Log format for the service. Can be: `json`, `text`.                                                                                                                                                      | `json`                             |
| `api.oidc.url`                              | URL of the OIDC provider. **Required**                                                                                                                                                                   | `""`                               |
| `api.oidc.issuerUrl`                        | Allows discovery to work when the issuer_url reported by upstream is mismatched with the discovery URL.                                                                                                  | `""`                               |
| `api.datagateway.url`                       | URL of the DataGateway instance.                                                                                                                                                                         | `https://datagateway.api.2gis.com` |
| `api.datagateway.apiKey`                    | API key for the DataGateway instance. **Required**                                                                                                                                                       | `""`                               |
| `api.dgctl.image.registry`                  | DGCTL image registry.                                                                                                                                                                                    | `""`                               |
| `api.dgctl.image.repository`                | DGCTL image repository. **Required**                                                                                                                                                                     | `2gis/dgctl`                       |
| `api.dgctl.image.tag`                       | DGCTL image tag.                                                                                                                                                                                         | `3`                                |
| `api.dgctl.image.pullPolicy`                | Pull policy for the DGCTL image used in download jobs.                                                                                                                                                   | `IfNotPresent`                     |
| `api.job.activeDeadline`                    | Active deadline for the created jobs.                                                                                                                                                                    | `2h`                               |
| `api.job.backoffLimit`                      | Backoff limit for the created jobs.                                                                                                                                                                      | `3`                                |
| `api.job.syncInterval`                      | Interval for syncing jobs.                                                                                                                                                                               | `10s`                              |
| `api.job.startTimeout`                      | Timeout for a job pod to start before the task is marked failed.                                                                                                                                         | `5m`                               |
| `api.job.logHead`                           | Number of first lines of the job log taken unconditionally when trimming.                                                                                                                                | `10`                               |
| `api.job.logTail`                           | Number of last lines of the job log taken unconditionally when trimming.                                                                                                                                 | `50`                               |
| `api.job.logPattern`                        | Regexp used to filter the rest of the job log. Empty means no filtering.                                                                                                                                 | `""`                               |
| `api.manifest.syncInterval`                 | Interval for syncing manifests.                                                                                                                                                                          | `60s`                              |
| `api.helmTimeout`                           | Timeout for helm operations.                                                                                                                                                                             | `10m`                              |
| `api.rollbackHistoryLimit`                  | Installation history limit for rollback.                                                                                                                                                                 | `2`                                |
| `api.installVersionsLimit`                  | Number of install versions to show.                                                                                                                                                                      | `3`                                |
| `api.completedTaskOffset`                   | Duration to show completed tasks.                                                                                                                                                                        | `12h`                              |
| `api.manifestUpdateOffset`                  | Duration to show manifest updates.                                                                                                                                                                       | `8h`                               |
| `api.replicas`                              | A replica count for the pod.                                                                                                                                                                             | `1`                                |
| `api.revisionHistoryLimit`                  | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-back-to-a-previous-revision) a deployment).                                | `3`                                |
| `api.serviceAccountOverride`                | Override the service account name.                                                                                                                                                                       | `""`                               |
| `api.rulesOverride`                         | Override per-chart rules.                                                                                                                                                                                | `[]`                               |
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

### Managed helm releases settings

| Name                                                                       | Description                                                                                                                                         | Value                                                                               |
| -------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| `api.components.core`                                                      | (https://docs.2gis.com/en/on-premise-api-platform/core/releases) services helm releases.                                                            |                                                                                     |
| `api.components.core.version`                                              | Version of the `core` component services releases.                                                                                                  | `2.9.0`                                                                             |
| `api.components.core.charts.keys`                                          | `keys` chart settings for [API Keys service](https://docs.2gis.com/en/on-premise-api-platform/core/install/keys).                                   |                                                                                     |
| `api.components.core.charts.keys.enabled`                                  | Enable release management for the `keys` chart.                                                                                                     | `true`                                                                              |
| `api.components.core.charts.keys.refOverride`                              | Override the `keys` chart reference.                                                                                                                | `""`                                                                                |
| `api.components.core.charts.keys.releases[0].name`                         | Public name of the managed release to be shown in the UI. **Required if chart is enabled**                                                          | `""`                                                                                |
| `api.components.core.charts.keys.releases[0].releaseName`                  | Name of the managed release in the cluster. **Required if chart is enabled**                                                                        | `""`                                                                                |
| `api.components.core.charts.keys.releases[0].services`                     | List of DGCTL services attached to the release. Allowed values: "keys".                                                                             | `["keys"]`                                                                          |
| `api.components.api-platform`                                              | (https://docs.2gis.com/en/on-premise-api-platform/api-platform/releases) services releases.                                                         |                                                                                     |
| `api.components.api-platform.version`                                      | Version of the `api-platform` component services releases.                                                                                          | `2.56.0`                                                                            |
| `api.components.api-platform.charts.tiles-api`                             | `tiles-api` chart settings for [Maps API](https://docs.2gis.com/en/on-premise-api-platform/api-platform/install/maps).                              |                                                                                     |
| `api.components.api-platform.charts.tiles-api.enabled`                     | Enable release management for the `tiles-api` chart.                                                                                                | `false`                                                                             |
| `api.components.api-platform.charts.tiles-api.refOverride`                 | Override the `tiles-api` chart reference.                                                                                                           | `""`                                                                                |
| `api.components.api-platform.charts.tiles-api.releases[0].name`            | Public name of the managed release to be shown in the UI. **Required if chart is enabled**                                                          | `""`                                                                                |
| `api.components.api-platform.charts.tiles-api.releases[0].releaseName`     | Name of the managed release in the cluster. **Required if chart is enabled**                                                                        | `""`                                                                                |
| `api.components.api-platform.charts.tiles-api.releases[0].services`        | List of DGCTL services attached to the release. Allowed values: "tiles-api-mapbox", "tiles-api-mobile-sdk", "tiles-api-raster", "tiles-api-vector". | `["tiles-api-mapbox","tiles-api-mobile-sdk","tiles-api-raster","tiles-api-vector"]` |
| `api.components.api-platform.charts.search-api`                            | `search-api` chart settings for [Search API (search)](https://docs.2gis.com/en/on-premise-api-platform/api-platform/install/search).                |                                                                                     |
| `api.components.api-platform.charts.search-api.enabled`                    | Enable release management for the `search-api` chart.                                                                                               | `false`                                                                             |
| `api.components.api-platform.charts.search-api.refOverride`                | Override the `search-api` chart reference.                                                                                                          | `""`                                                                                |
| `api.components.api-platform.charts.search-api.releases[0].name`           | Public name of the managed release to be shown in the UI. **Required if chart is enabled**                                                          | `""`                                                                                |
| `api.components.api-platform.charts.search-api.releases[0].releaseName`    | Name of the managed release in the cluster. **Required if chart is enabled**                                                                        | `""`                                                                                |
| `api.components.api-platform.charts.search-api.releases[0].services`       | List of DGCTL services attached to the release. Allowed values: "search".                                                                           | `["search"]`                                                                        |
| `api.components.api-platform.charts.catalog-api`                           | `catalog-api` chart settings for [Search API (catalog)](https://docs.2gis.com/en/on-premise-api-platform/api-platform/install/search).              |                                                                                     |
| `api.components.api-platform.charts.catalog-api.enabled`                   | Enable release management for the `catalog-api` chart.                                                                                              | `false`                                                                             |
| `api.components.api-platform.charts.catalog-api.refOverride`               | Override the `catalog-api` chart reference.                                                                                                         | `""`                                                                                |
| `api.components.api-platform.charts.catalog-api.releases[0].name`          | Public name of the managed release to be shown in the UI. **Required if chart is enabled**                                                          | `""`                                                                                |
| `api.components.api-platform.charts.catalog-api.releases[0].releaseName`   | Name of the managed release in the cluster. **Required if chart is enabled**                                                                        | `""`                                                                                |
| `api.components.api-platform.charts.catalog-api.releases[0].services`      | List of DGCTL services attached to the release. Allowed values: "catalog".                                                                          | `["catalog"]`                                                                       |
| `api.components.api-platform.charts.search-api-v8`                         | `search-api-v8` chart settings for [Search API (new version)](https://docs.2gis.com/en/on-premise-api-platform/api-platform/install/search-v8).     |                                                                                     |
| `api.components.api-platform.charts.search-api-v8.enabled`                 | Enable release management for the `search-api-v8` chart.                                                                                            | `false`                                                                             |
| `api.components.api-platform.charts.search-api-v8.refOverride`             | Override the `search-api-v8` chart reference.                                                                                                       | `""`                                                                                |
| `api.components.api-platform.charts.search-api-v8.releases[0].name`        | Public name of the managed release to be shown in the UI. **Required if chart is enabled**                                                          | `""`                                                                                |
| `api.components.api-platform.charts.search-api-v8.releases[0].releaseName` | Name of the managed release in the cluster. **Required if chart is enabled**                                                                        | `""`                                                                                |
| `api.components.api-platform.charts.search-api-v8.releases[0].services`    | List of DGCTL services attached to the release. Allowed values: "search-api-v8".                                                                    | `["search-api-v8"]`                                                                 |
| `api.components.api-platform.charts.navi-castle`                           | `navi-castle` chart settings for [Navigation API](https://docs.2gis.com/en/on-premise-api-platform/api-platform/install/navigation).                |                                                                                     |
| `api.components.api-platform.charts.navi-castle.enabled`                   | Enable release management for the `navi-castle` chart.                                                                                              | `false`                                                                             |
| `api.components.api-platform.charts.navi-castle.refOverride`               | Override the `navi-castle` chart reference.                                                                                                         | `""`                                                                                |
| `api.components.api-platform.charts.navi-castle.releases[0].name`          | Public name of the managed release to be shown in the UI. **Required if chart is enabled**                                                          | `""`                                                                                |
| `api.components.api-platform.charts.navi-castle.releases[0].releaseName`   | Name of the managed release in the cluster. **Required if chart is enabled**                                                                        | `""`                                                                                |
| `api.components.api-platform.charts.navi-castle.releases[0].services`      | List of DGCTL services attached to the release. Allowed values: "navi".                                                                             | `["navi"]`                                                                          |
| `api.components.api-platform.charts.twins-api`                             | `twins-api` chart settings.                                                                                                                         |                                                                                     |
| `api.components.api-platform.charts.twins-api.enabled`                     | Enable release management for the `twins-api` chart.                                                                                                | `false`                                                                             |
| `api.components.api-platform.charts.twins-api.refOverride`                 | Override the `twins-api` chart reference.                                                                                                           | `""`                                                                                |
| `api.components.api-platform.charts.twins-api.releases[0].name`            | Public name of the managed release to be shown in the UI. **Required if chart is enabled**                                                          | `""`                                                                                |
| `api.components.api-platform.charts.twins-api.releases[0].releaseName`     | Name of the managed release in the cluster. **Required if chart is enabled**                                                                        | `""`                                                                                |
| `api.components.api-platform.charts.twins-api.releases[0].services`        | List of DGCTL services attached to the release. Allowed values: "twins".                                                                            | `["twins"]`                                                                         |
| `api.components.pro`                                                       | (https://docs.2gis.com/en/on-premise-pro/releases) services releases.                                                                               |                                                                                     |
| `api.components.pro.version`                                               | Version of the `pro` component services releases.                                                                                                   | `2.5.0`                                                                             |
| `api.components.pro.charts.pro-ui`                                         | `pro-ui` chart settings for [2GIS Pro (ui)](https://docs.2gis.com/en/on-premise-pro/install/installation).                                          |                                                                                     |
| `api.components.pro.charts.pro-ui.enabled`                                 | Enable release management for the `pro-ui` chart.                                                                                                   | `false`                                                                             |
| `api.components.pro.charts.pro-ui.refOverride`                             | Override the `pro-ui` chart reference.                                                                                                              | `""`                                                                                |
| `api.components.pro.charts.pro-ui.releases[0].name`                        | Public name of the managed release to be shown in the UI. **Required if chart is enabled**                                                          | `""`                                                                                |
| `api.components.pro.charts.pro-ui.releases[0].releaseName`                 | Name of the managed release in the cluster. **Required if chart is enabled**                                                                        | `""`                                                                                |
| `api.components.pro.charts.pro-ui.releases[0].services`                    | List of DGCTL services attached to the release. Allowed values: "pro-ui".                                                                           | `["pro-ui"]`                                                                        |
| `api.components.pro.charts.pro-api`                                        | `pro-api` chart settings for [2GIS Pro (api)](https://docs.2gis.com/en/on-premise-pro/install/installation).                                        |                                                                                     |
| `api.components.pro.charts.pro-api.enabled`                                | Enable release management for the `pro-api` chart.                                                                                                  | `false`                                                                             |
| `api.components.pro.charts.pro-api.refOverride`                            | Override the `pro-api` chart reference.                                                                                                             | `""`                                                                                |
| `api.components.pro.charts.pro-api.releases[0].name`                       | Public name of the managed release to be shown in the UI. **Required if chart is enabled**                                                          | `""`                                                                                |
| `api.components.pro.charts.pro-api.releases[0].releaseName`                | Name of the managed release in the cluster. **Required if chart is enabled**                                                                        | `""`                                                                                |
| `api.components.pro.charts.pro-api.releases[0].services`                   | List of DGCTL services attached to the release. Allowed values: "pro-api".                                                                          | `["pro"]`                                                                           |
| `api.components.citylens`                                                  | (https://docs.2gis.com/en/on-premise-citylens/releases) services releases.                                                                          |                                                                                     |
| `api.components.citylens.version`                                          | Version of the `citylens` component services releases.                                                                                              | `2.3.0`                                                                             |
| `api.components.citylens.charts.citylens`                                  | `citylens` chart settings for [CityLens](https://docs.2gis.com/en/on-premise-citylens/install/installation).                                        |                                                                                     |
| `api.components.citylens.charts.citylens.enabled`                          | Enable release management for the `citylens` chart.                                                                                                 | `false`                                                                             |
| `api.components.citylens.charts.citylens.refOverride`                      | Override the `citylens` chart reference.                                                                                                            | `""`                                                                                |
| `api.components.citylens.charts.citylens.releases[0].name`                 | Public name of the managed release to be shown in the UI. **Required if chart is enabled**                                                          | `""`                                                                                |
| `api.components.citylens.charts.citylens.releases[0].releaseName`          | Name of the managed release in the cluster. **Required if chart is enabled**                                                                        | `""`                                                                                |
| `api.components.citylens.charts.citylens.releases[0].services`             | List of DGCTL services attached to the release. Allowed values: "citylens".                                                                         | `["citylens"]`                                                                      |

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
