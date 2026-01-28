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

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name               | Description                                                                                                                                         | Value |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `url`              | URL for the GIS platform ex: https://gis-platform.ingress.host **Required**                                                                         | `""`  |
| `imagePullSecrets` | Kubernetes [secrets for pulling the image from the registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) | `[]`  |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                      |
| ------------------------------------ | ----------------------------------------- | -------------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                    |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`                    |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `gis-platform.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                        |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                   |
| `ingress.tls`                        | TLS configuration                         | `[]`                       |

### Docker registry settings

| Name                         | Description                         | Value                                 |
| ---------------------------- | ----------------------------------- | ------------------------------------- |
| `spcore.image.repository`    | SPCore service image repository.    | `2gis-on-premise/gis_platform_spcore` |
| `spcore.image.tag`           | SPCore service image tag.           | `2023.8.3-0`                          |
| `portal.image.repository`    | Portal service image repository.    | `2gis-on-premise/gis_platform_portal` |
| `portal.image.tag`           | Portal service image tag.           | `2023.8.3-0`                          |
| `zookeeper.image.repository` | ZooKeeper service image repository. | `2gis-on-premise/zookeeper`           |
| `zookeeper.image.tag`        | ZooKeeper service image tag.        | `3.7.0-debian-10-r265`                |

### SPCore service settings

| Name                                        | Description                                                                                         | Value               |
| ------------------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------- |
| `spcore.replicaCount`                       | A replica count for the pod.                                                                        | `1`                 |
| `spcore.service`                            | Service settings.                                                                                   | `{}`                |
| `spcore.debug`                              | If the debug mode is enabled.                                                                       | `false`             |
| `spcore.resetCluster`                       | If true, the cluster will be reset when applying this configuration.                                | `false`             |
| `spcore.updateDb`                           | If true, the database schema and data will be updated when applying this configuration.             | `true`              |
| `spcore.terminationGracePeriodSeconds`      | Wait for up to this amount of seconds for a running instance of the service to shut down.           | `60`                |
| `spcore.nodePort`                           | Port for communication between services cross the nodes in cluster mode                             | `5050`              |
| `spcore.appPort`                            | SPCore service HTTP port.                                                                           | `5051`              |
| `spcore.maxRenderTargets`                   | Maximum number of targets to render simultaneously.                                                 | `1000`              |
| `spcore.loglevel`                           | Log level.                                                                                          | `Info`              |
| `spcore.cors`                               | **CORS settings.**                                                                                  |                     |
| `spcore.cors.allowEveryone`                 | If true, requests from any origin will be allowed.                                                  | `false`             |
| `spcore.cors.origins`                       | List of allowed origins (if `allowEveryone` is false).                                              | `[]`                |
| `spcore.s3`                                 | **S3-compatible storage settings.**                                                                 |                     |
| `spcore.s3.accessKey`                       | S3 access key for accessing the bucket **Required**                                                 | `""`                |
| `spcore.s3.secretKey`                       | S3 secret key for accessing the bucket **Required**                                                 | `""`                |
| `spcore.s3.host`                            | S3 endpoint. Format: `host:port`. **Required**                                                      | `""`                |
| `spcore.s3.region`                          | S3 region.                                                                                          | `US`                |
| `spcore.s3.bucket`                          | S3 bucket name **Required**                                                                         | `""`                |
| `spcore.s3.sessionBucket`                   | S3 bucket name for temporary session files **Required**                                             | `""`                |
| `spcore.postgres`                           | **Database access settings.**                                                                       |                     |
| `spcore.postgres.host`                      | PostgreSQL host **Required**                                                                        | `""`                |
| `spcore.postgres.port`                      | PostgreSQL port.                                                                                    | `5432`              |
| `spcore.postgres.username`                  | PostgreSQL username **Required**                                                                    | `""`                |
| `spcore.postgres.password`                  | PostgreSQL password **Required**                                                                    | `""`                |
| `spcore.postgres.name`                      | PostgreSQL database name **Required**                                                               | `""`                |
| `spcore.postgres.poolsize`                  | PostgreSQL connection pool size.                                                                    | `25`                |
| `spcore.admin`                              | **Admin access settings.**                                                                          |                     |
| `spcore.admin.email`                        | Admin email **Required** Example: admin@example.com                                                 | `""`                |
| `spcore.admin.password`                     | Admin password **Required**                                                                         | `""`                |
| `spcore.jwt`                                | **JSON Web Token (JWT) settings.**                                                                  |                     |
| `spcore.jwt.tokenKey`                       | JWT default user token **Required**                                                                 | `""`                |
| `spcore.jwt.tokenAdmin`                     | JWT admin user token **Required**                                                                   | `""`                |
| `spcore.catalog`                            | **Catalog settings.**                                                                               |                     |
| `spcore.catalog.url`                        | Catalog service URL **Required** Example: `http://catalog-api`                                      | `""`                |
| `spcore.catalog.key`                        | Catalog access key **Required**                                                                     | `""`                |
| `spcore.catalog.type`                       | Additional geocoder filter                                                                          | `""`                |
| `spcore.catalog.regionId`                   | Additional geocoder filter                                                                          | `""`                |
| `spcore.navi`                               | **Navi settings.**                                                                                  |                     |
| `spcore.navi.url`                           | Navi service URL.                                                                                   | `http://navi-front` |
| `spcore.defaultLimits`                      | **Default limits.**                                                                                 |                     |
| `spcore.defaultLimits.tables`               | Maximum number of tables.                                                                           | `500`               |
| `spcore.defaultLimits.layers`               | Maximum number of layers.                                                                           | `500`               |
| `spcore.defaultLimits.projects`             | Maximum number of projects.                                                                         | `1000`              |
| `spcore.defaultLimits.features`             | Maximum number of features.                                                                         | `1000000`           |
| `spcore.startupProbe`                       | **Startup probe [settings](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/) .**   |                     |
| `spcore.startupProbe.initialDelaySeconds`   | Seconds before the first probe.                                                                     | `5`                 |
| `spcore.startupProbe.periodSeconds`         | Probing period.                                                                                     | `10`                |
| `spcore.startupProbe.failureThreshold`      | Probing failure threshold.                                                                          | `100`               |
| `spcore.readinessProbe`                     | **Readiness probe [settings](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/) .** |                     |
| `spcore.readinessProbe.initialDelaySeconds` | Seconds before the first probe.                                                                     | `5`                 |
| `spcore.readinessProbe.periodSeconds`       | Probing period.                                                                                     | `5`                 |
| `spcore.readinessProbe.failureThreshold`    | Probing failure threshold.                                                                          | `3`                 |

### Portal settings

| Name                                   | Description                                                                                                                                    | Value                                                                                |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `portal.replicaCount`                  | A replica count for the pod.                                                                                                                   | `1`                                                                                  |
| `portal.revisionHistoryLimit`          | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`                                                                                  |
| `portal.terminationGracePeriodSeconds` | Wait for up to this amount of seconds for a running instance of the service to shut down.                                                      | `60`                                                                                 |
| `portal.maxBodySize`                   | Maximum HTTP request body size.                                                                                                                | `100m`                                                                               |
| `portal.gzip.enabled`                  | If GZip compression should be enabled for the HTTP requests and responses.                                                                     | `true`                                                                               |
| `portal.service.type`                  | Kubernetes [Service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                 | `ClusterIP`                                                                          |
| `portal.service.port`                  | Service port.                                                                                                                                  | `80`                                                                                 |
| `portal.websocket.timeout`             | WebSocket timeout in seconds.                                                                                                                  | `604800`                                                                             |
| `portal.cache`                         | **Cache settings**                                                                                                                             |                                                                                      |
| `portal.cache.enabled`                 | If caching should be enabled for the Portal service.                                                                                           | `false`                                                                              |
| `portal.cache.size`                    | Maximum cache size.                                                                                                                            | `1G`                                                                                 |
| `portal.cache.valid`                   | Cache vailidity period.                                                                                                                        | `1m`                                                                                 |
| `portal.cache.regex`                   | Array of regexes to match the resources that should be cached.                                                                                 | `["^/sp/wms.*layers=admin.satellite_imagery&.*$","^/sp/wms.*layers=admin.2gis&.*$"]` |
| `portal.s3proxy`                       | **S3 storage proxy settings**                                                                                                                  |                                                                                      |
| `portal.s3proxy.enabled`               | If S3 proxy should be enabled.                                                                                                                 | `false`                                                                              |
| `portal.s3proxy.scheme`                | Protocol to use: `http` or `https`.                                                                                                            | `http`                                                                               |

### ZooKeeper settings

| Name                            | Description                                                                                                                             | Value   |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `zookeeper.replicaCount`        | A replica count for the pod.                                                                                                            | `3`     |
| `zookeeper.persistence.enabled` | If Kubernetes persistence volume should be enabled for ZooKeeper.                                                                       | `false` |
| `zookeeper.pdb`                 | **Kubernetes [pod disruption budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings** |         |
| `zookeeper.pdb.create`          | If PDB is enabled for the service.                                                                                                      | `true`  |
| `zookeeper.pdb.maxUnavailable`  | How many pods can be unavailable after the eviction.                                                                                    | `1`     |

### Limits

| Name                                  | Description                          | Value   |
| ------------------------------------- | ------------------------------------ | ------- |
| `spcore.resources`                    | **Limits for the SPCore service**    |         |
| `spcore.resources.requests.cpu`       | A CPU request.                       | `800m`  |
| `spcore.resources.requests.memory`    | A memory request.                    | `4Gi`   |
| `spcore.resources.limits.cpu`         | A CPU limit.                         | `800m`  |
| `spcore.resources.limits.memory`      | A memory limit.                      | `4Gi`   |
| `portal.resources`                    | **Limits for the Portal service**    |         |
| `portal.resources.requests.cpu`       | A CPU request.                       | `100m`  |
| `portal.resources.requests.memory`    | A memory request.                    | `512Mi` |
| `portal.resources.limits.cpu`         | A CPU limit.                         | `100m`  |
| `portal.resources.limits.memory`      | A memory limit.                      | `512Mi` |
| `zookeeper.resources`                 | **Limits for the ZooKeeper service** |         |
| `zookeeper.resources.requests.cpu`    | A CPU request.                       | `100m`  |
| `zookeeper.resources.requests.memory` | A memory request.                    | `512Mi` |
| `zookeeper.resources.limits.cpu`      | A CPU limit.                         | `200m`  |
| `zookeeper.resources.limits.memory`   | A memory limit.                      | `512Mi` |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
