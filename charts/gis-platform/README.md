# 2GIS GIS Platform service

Use this Helm chart to deploy the GIS Platform service, which is a part of 2GIS's [On-Premise solution](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/gis-platform) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-gis-platform.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Common settings

| Name                | Description                         | Value               |
| ------------------- | ----------------------------------- | ------------------- |
| `external_hostname` | Service hostname.                   | `gis-platform.host` |
| `external_proto`    | Protocol to use: `http` or `https`. | `https`             |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                  | Description                                                                                                              | Value   |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------- |
| `ingress.enabled`     | If Ingress is enabled for the service.                                                                                   | `false` |
| `ingress.className`   | Ingress class name.                                                                                                      | `nginx` |
| `ingress.annotations` | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                | `{}`    |
| `ingress.hosts`       | List of hosts. Must be a list, where each item has `host` property. <br/> Defaults to `[{'host': 'gis-platform.host'}]`. |         |
| `ingress.tls`         | TLS settings.                                                                                                            | `[]`    |


### Docker registry settings

| Name                         | Description                         | Value                                 |
| ---------------------------- | ----------------------------------- | ------------------------------------- |
| `spcore.image.repository`    | SPCore service image repository.    | `2gis-on-premise/gis_platform_spcore` |
| `spcore.image.tag`           | SPCore service image tag.           | `2022-06-10`                          |
| `portal.image.repository`    | Portal service image repository.    | `2gis-on-premise/gis_platform_portal` |
| `portal.image.tag`           | Portal service image tag.           | `2022-06-10`                          |
| `zookeeper.image.repository` | ZooKeeper service image repository. | `2gis-on-premise/zookeeper`           |
| `zookeeper.image.tag`        | ZooKeeper service image tag.        | `3.7.0-debian-10-r265`                |


### SPCore service settings

| Name                                        | Description                                                                               | Value                      |
| ------------------------------------------- | ----------------------------------------------------------------------------------------- | -------------------------- |
| `spcore.replicaCount`                       | A replica count for the pod.                                                              | `1`                        |
| `spcore.service`                            | Service settings.                                                                         | `{}`                       |
| `spcore.debug_mode`                         | If the debug mode is enabled.                                                             | `false`                    |
| `spcore.reset_cluster`                      | If true, the cluster will be reset when applying this configuration.                      | `false`                    |
| `spcore.update_db`                          | If true, the database schema and data will be updated when applying this configuration.   | `true`                     |
| `spcore.terminationGracePeriodSeconds`      | Wait for up to this amount of seconds for a running instance of the service to shut down. | `60`                       |
| `spcore.cloud_port`                         | Cloud port.                                                                               | `5050`                     |
| `spcore.http_port`                          | SPCore service HTTP port.                                                                 | `5051`                     |
| `spcore.maxRenderTargets`                   | Maximum number of targets to render simultaneously.                                       | `1000`                     |
| `spcore.loglevel`                           | Log level.                                                                                | `Info`                     |
| `spcore.cors`                               | **CORS settings.**                                                                        |                            |
| `spcore.cors.allow_everyone`                | If true, requests from any origin will be allowed.                                        | `false`                    |
| `spcore.cors.origins`                       | List of allowed origins (if `allow_everyone` is false).                                   | `[]`                       |
| `spcore.s3`                                 | **S3-compatible storage settings.**                                                       |                            |
| `spcore.s3.access_key`                      | S3 access key for accessing the bucket.                                                   | `""`                       |
| `spcore.s3.secret_key`                      | S3 secret key for accessing the bucket.                                                   | `""`                       |
| `spcore.s3.host`                            | S3 endpoint. Format: `host:port`.                                                         | `s3.host`                  |
| `spcore.s3.region`                          | S3 region.                                                                                | `US`                       |
| `spcore.s3.bucket`                          | S3 bucket name.                                                                           | `spstatic`                 |
| `spcore.s3.preview_bucket`                  | S3 bucket name for preview.                                                               | `sppreview`                |
| `spcore.pg`                                 | **Database access settings.**                                                             |                            |
| `spcore.pg.host`                            | PostgreSQL host.                                                                          | `postgres.host`            |
| `spcore.pg.port`                            | PostgreSQL port.                                                                          | `5432`                     |
| `spcore.pg.user`                            | PostgreSQL username.                                                                      | `gisadmin`                 |
| `spcore.pg.password`                        | PostgreSQL password.                                                                      | `dbpass`                   |
| `spcore.pg.dbname`                          | PostgreSQL database name.                                                                 | `gis-platform`             |
| `spcore.pg.poolsize`                        | PostgreSQL connection pool size.                                                          | `25`                       |
| `spcore.admin`                              | **Admin access settings.**                                                                |                            |
| `spcore.admin.email`                        | Admin email                                                                               | `admin@example.com`        |
| `spcore.admin.password`                     | Admin password                                                                            | `123456`                   |
| `spcore.jwt`                                | **JSON Web Token (JWT) settings.**                                                        |                            |
| `spcore.jwt.token_key`                      | JWT default user token.                                                                   | `supersecrettoken`         |
| `spcore.jwt.token_admin`                    | JWT admin user token.                                                                     | `supersecrettoken`         |
| `spcore.catalog`                            | **Catalog settings.**                                                                     |                            |
| `spcore.catalog.url`                        | Catalog service URL.                                                                      | `https://catalog-api.host` |
| `spcore.catalog.key`                        | Catalog access key.                                                                       | `""`                       |
| `spcore.navi`                               | **Navi settings.**                                                                        |                            |
| `spcore.navi.url`                           | Navi service URL.                                                                         | `https://catalog-api.host` |
| `spcore.defaultLimits`                      | **Default limits.**                                                                       |                            |
| `spcore.defaultLimits.tables`               | Maximum number of tables.                                                                 | `500`                      |
| `spcore.defaultLimits.layers`               | Maximum number of layers.                                                                 | `500`                      |
| `spcore.defaultLimits.projects`             | Maximum number of projects.                                                               | `1000`                     |
| `spcore.defaultLimits.features`             | Maximum number of features.                                                               | `1000000`                  |
| `spcore.startupProbe`                       | **Startup probe settings.**                                                               |                            |
| `spcore.startupProbe.initialDelaySeconds`   | Seconds before the first probe.                                                           | `5`                        |
| `spcore.startupProbe.periodSeconds`         | Probing period.                                                                           | `10`                       |
| `spcore.startupProbe.failureThreshold`      | Probing failure threshold.                                                                | `30`                       |
| `spcore.readinessProbe`                     | **Readiness probe settings.**                                                             |                            |
| `spcore.readinessProbe.initialDelaySeconds` | Seconds before the first probe.                                                           | `5`                        |
| `spcore.readinessProbe.periodSeconds`       | Probing period.                                                                           | `5`                        |
| `spcore.readinessProbe.failureThreshold`    | Probing failure threshold.                                                                | `3`                        |


### Portal settings

| Name                                   | Description                                                                                                                    | Value                                                                                |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------ |
| `portal.replicaCount`                  | A replica count for the pod.                                                                                                   | `1`                                                                                  |
| `portal.terminationGracePeriodSeconds` | Wait for up to this amount of seconds for a running instance of the service to shut down.                                      | `60`                                                                                 |
| `portal.max_body_size`                 | Maximum HTTP request body size.                                                                                                | `100m`                                                                               |
| `portal.gzip_enabled`                  | If GZip compression should be enabled for the HTTP requests and responses.                                                     | `true`                                                                               |
| `portal.service.type`                  | Kubernetes [Service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP`                                                                          |
| `portal.service.port`                  | Service port.                                                                                                                  | `80`                                                                                 |
| `portal.websocket.timeout`             | WebSocket timeout in seconds.                                                                                                  | `604800`                                                                             |
| `portal.cache`                         | **Cache settings**                                                                                                             |                                                                                      |
| `portal.cache.enabled`                 | If caching should be enabled for the Portal service.                                                                           | `false`                                                                              |
| `portal.cache.size`                    | Maximum cache size.                                                                                                            | `1G`                                                                                 |
| `portal.cache.valid`                   | Cache vailidity period.                                                                                                        | `1m`                                                                                 |
| `portal.cache.regex`                   | Array of regexes to match the resources that should be cached.                                                                 | `["^/sp/wms.*layers=admin.satellite_imagery&.*$","^/sp/wms.*layers=admin.2gis&.*$"]` |
| `portal.s3proxy`                       | **S3 storage proxy settings**                                                                                                  |                                                                                      |
| `portal.s3proxy.enabled`               | If S3 proxy should be enabled.                                                                                                 | `false`                                                                              |
| `portal.s3proxy.scheme`                | Protocol to use: `http` or `https`.                                                                                            | `http`                                                                               |


### ZooKeeper settings

| Name                            | Description                                                                                                                             | Value   |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `zookeeper.replicaCount`        | A replica count for the pod.                                                                                                            | `3`     |
| `zookeeper.persistence.enabled` | If Kubernetes persistence volume should be enabled for ZooKeeper.                                                                       | `false` |
| `zookeeper.pdb`                 | **Kubernetes [pod disruption budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings** |         |
| `zookeeper.pdb.create`          | If PDB is enabled for the service.                                                                                                      | `true`  |
| `zookeeper.pdb.maxUnavailable`  | How many pods can be unavailable after the eviction.                                                                                    | `1`     |


### Limits

| Name                                  | Description                          | Value    |
| ------------------------------------- | ------------------------------------ | -------- |
| `spcore.resources`                    | **Limits for the SPCore service**    |          |
| `spcore.resources.requests.cpu`       | A CPU request.                       | `800m`   |
| `spcore.resources.requests.memory`    | A memory request.                    | `4096Mi` |
| `spcore.resources.limits.cpu`         | A CPU limit.                         | `800m`   |
| `spcore.resources.limits.memory`      | A memory limit.                      | `4096Mi` |
| `portal.resources`                    | **Limits for the Portal service**    |          |
| `portal.resources.requests.cpu`       | A CPU request.                       | `100m`   |
| `portal.resources.requests.memory`    | A memory request.                    | `512Mi`  |
| `portal.resources.limits.cpu`         | A CPU limit.                         | `100m`   |
| `portal.resources.limits.memory`      | A memory limit.                      | `512Mi`  |
| `zookeeper.resources`                 | **Limits for the ZooKeeper service** |          |
| `zookeeper.resources.requests.cpu`    | A CPU request.                       | `100m`   |
| `zookeeper.resources.requests.memory` | A memory request.                    | `512Mi`  |
| `zookeeper.resources.limits.cpu`      | A CPU limit.                         | `200m`   |
| `zookeeper.resources.limits.memory`   | A memory limit.                      | `512Mi`  |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
