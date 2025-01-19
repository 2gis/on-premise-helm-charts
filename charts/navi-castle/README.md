# 2GIS Navi-Castle service

Use this Helm chart to deploy Navi-Castle service, which is a part of 2GIS's [On-Premise Navigation services](https://docs.2gis.com/en/on-premise/navigation).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/navigation) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-castle.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Deployment settings

| Name                      | Description                           | Value                         |
| ------------------------- | ------------------------------------- | ----------------------------- |
| `castle.image.repository` | Navi-Castle service image repository. | `2gis-on-premise/navi-castle` |
| `castle.image.pullPolicy` | Navi-Castle service pull policy.      | `IfNotPresent`                |
| `castle.image.tag`        | Navi-Castle service image tag.        | `1.9.8`                       |
| `nginx.image.repository`  | Navi-Front image repository.          | `2gis-on-premise/navi-front`  |
| `nginx.image.tag`         | Navi-Front image tag.                 | `1.25.2`                      |

### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                              | Value   |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`.                                                                                                                                                                                                                        | `""`    |
| `dgctlStorage.secure`    | If S3 uses https.                                                                                                                                                                                                                                        | `false` |
| `dgctlStorage.region`    | S3 region.                                                                                                                                                                                                                                               | `""`    |
| `dgctlStorage.bucket`    | S3 bucket name.                                                                                                                                                                                                                                          | `""`    |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket.                                                                                                                                                                                                                  | `""`    |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket.                                                                                                                                                                                                                  | `""`    |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json`.<br> This file contains the description of pieces of data that the service requires to operate. | `""`    |

### Common settings

| Name                            | Description                                                                                                                                                               | Value  |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `enableServiceLinks`            | Services injection into containers environment [Accessing the Service](https://kubernetes.io/docs/tutorials/services/connect-applications-service/#accessing-the-service) | `true` |
| `replicaCount`                  | A replica count for the pod.                                                                                                                                              | `1`    |
| `imagePullSecrets`              | Kubernetes image pull secrets.                                                                                                                                            | `[]`   |
| `nameOverride`                  | Base name to use in all the Kubernetes entities deployed by this chart.                                                                                                   | `""`   |
| `fullnameOverride`              | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                                                               | `""`   |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                             | `{}`   |
| `podSecurityContext`            | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                                                            | `{}`   |
| `securityContext`               | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                                                                | `{}`   |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                       | `{}`   |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                         | `[]`   |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                               | `{}`   |
| `terminationGracePeriodSeconds` | Maximum time allowed for graceful shutdown.                                                                                                                               | `60`   |

### Service account settings

| Name                         | Description                                                                                                             | Value   |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                                                  | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account.                                                                              | `{}`    |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |

### Service settings

| Name           | Description                                                                                                                    | Value       |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.type` | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port` | Service port.                                                                                                                  | `80`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                     |
| ------------------------------------ | ----------------------------------------- | ------------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                   |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`                   |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `navi-castle.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                       |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                  |
| `ingress.tls`                        | TLS configuration                         | `[]`                      |

### Limits

| Name                        | Description                                 | Value       |
| --------------------------- | ------------------------------------------- | ----------- |
| `resources`                 | Container resources requirements structure. | `{}`        |
| `resources.requests.cpu`    | CPU request, recommended value `100m`.      | `undefined` |
| `resources.requests.memory` | Memory request, recommended value `128Mi`.  | `undefined` |
| `resources.limits.cpu`      | CPU limit, recommended value `1000m`.       | `undefined` |
| `resources.limits.memory`   | Memory limit, recommended value `512Mi`.    | `undefined` |

### Navi-Castle service settings

| Name                                   | Description                                                                                                                                                            | Value                          |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `castle.castleDataPath`                | Path to the data directory.                                                                                                                                            | `/opt/castle/data/`            |
| `castle.excludeProjects`               | Array of project labels to exclude                                                                                                                                     | `[]`                           |
| `castle.restrictions`                  | Section ignored if castle.restriction.enabled=false                                                                                                                    |                                |
| `castle.restrictions.host`             | Restrictions API base URL.                                                                                                                                             | `http://restrictions-api.host` |
| `castle.restrictions.key`              | Restrictions API key.                                                                                                                                                  | `""`                           |
| `castle.jobs`                          | Number of parallel downloading jobs.                                                                                                                                   | `1`                            |
| `castle.logLevel`                      | Logging level, one of: DEBUG, INFO, WARNING, ERROR, CRITICAL.                                                                                                          | `INFO`                         |
| `castle.startupProbe`                  | Settings for startup probes                                                                                                                                            |                                |
| `castle.startupProbe.periodSeconds`    | Check period for startup probes.                                                                                                                                       | `5`                            |
| `castle.startupProbe.failureThreshold` | Threshold for startup probes.                                                                                                                                          | `180`                          |
| `castle.storePeriod`                   | Retention period for the corresponding data if enabled, ref. `cron`, `init` and `rtr` sections. Supported values: `day`, `month`, `week` or a specific number of days. |                                |
| `castle.storePeriod.import`            | Retention period for `import` job data, ref. `cron/init.enabled.import`                                                                                                | `month`                        |
| `castle.storePeriod.restriction`       | Retention period for `restriction` job data, ref. `cron/init.enabled.restriction`                                                                                      | `week`                         |
| `castle.storePeriod.restrictionImport` | Retention period for `restrictionImport` job data, ref. `cron/init.enabled.restrictionImport`                                                                          | `week`                         |
| `castle.storePeriod.rtr`               | Retention period for `rtr` data, ref. `rtr.enabled`                                                                                                                    | `week`                         |

### Navi-Front settings

| Name               | Description                                      | Value   |
| ------------------ | ------------------------------------------------ | ------- |
| `nginx.port`       | HTTP port on which Navi-Front will be listening. | `8080`  |
| `nginx.nodeHeader` | Enable header with node name (X-Node).           | `false` |

### Cron settings

| Name                              | Description                                                         | Value         |
| --------------------------------- | ------------------------------------------------------------------- | ------------- |
| `cron.enabled.import`             | If the `import` cron job is enabled.                                | `false`       |
| `cron.enabled.restriction`        | If restrictions API enabled, incompatible with `restrictionImport`. | `false`       |
| `cron.enabled.restrictionImport`  | If restrictions import enabled, incompatible with `restriction`.    | `false`       |
| `cron.schedule.import`            | Cron job schedule for `import`.                                     | `11 * * * *`  |
| `cron.schedule.restriction`       | Cron job schedule for `restriction`.                                | `*/5 * * * *` |
| `cron.schedule.restrictionImport` | Cron job schedule for `restrictionImport`.                          | `*/5 * * * *` |
| `cron.concurrencyPolicy`          | Cron job concurrency policy: `Allow` or `Forbid`.                   | `Forbid`      |
| `cron.successfulJobsHistoryLimit` | How many completed and failed jobs should be kept.                  | `3`           |
| `cron.prometheusPort`             | Container port for supercronic prometheus                           | `9476`        |

### Init settings

| Name                             | Description                                                                                                                       | Value   |
| -------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `init.enabled.import`            | If the `import` on init is enabled. Warning: if disable data not imported. Old data will be lost if not persistentVolume.enabled. | `true`  |
| `init.enabled.restriction`       | If restrictions API enabled, incompatible with `restrictionImport`.                                                               | `false` |
| `init.enabled.restrictionImport` | If restrictions import enabled, incompatible with `restriction`.                                                                  | `false` |

### Kubernetes [Persistence Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) settings

| Name                            | Description                                                                           | Value               |
| ------------------------------- | ------------------------------------------------------------------------------------- | ------------------- |
| `persistentVolume.enabled`      | If Kubernetes persistence volume should be enabled for Castle.                        | `false`             |
| `persistentVolume.accessModes`  | Volume access mode.                                                                   | `["ReadWriteOnce"]` |
| `persistentVolume.storageClass` | Volume [storage class](https://kubernetes.io/docs/concepts/storage/storage-classes/). | `ceph-csi-rbd`      |
| `persistentVolume.size`         | Volume size.                                                                          | `5Gi`               |
| `persistentVolume.type`         | Volume type `pvc` or `ephemeral`.                                                     | `pvc`               |

### RTR settings. Leave with defaults, FOR FUTURE RELEASE.

| Name                            | Description                                                                                                                   | Value                                           |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `rtr.enabled`                   | If the RTR is enabled.                                                                                                        | `false`                                         |
| `rtr.http.baseDir`              | Base dir on server.                                                                                                           | `export-restrictions-json`                      |
| `rtr.http.serverUrl`            | Server URL.                                                                                                                   | `""`                                            |
| `rtr.kafka.topic`               | Name of the topic.                                                                                                            | `""`                                            |
| `rtr.kafka.groupId`             | Kafka consumer group id.                                                                                                      | `castle-rtr`                                    |
| `rtr.kafka.properties`          | Properties as supported by kafka-python. Refer to inline comments for details.                                                |                                                 |
| `rtr.kafka.sensitiveProperties` | As rtr.kafka.properties, but kept in Secrets. Refer to inlines comments for details.                                          | `{}`                                            |
| `rtr.kafka.fileProperties`      | As rtr.kafka.properties, but kept in a file, which passed to application as a filename. Refer to inline comments for details. | `{}`                                            |
| `rtr.buildFtp.baseDir`          | Base dir on build ftp.                                                                                                        | `trafficedro`                                   |
| `rtr.buildFtp.login`            | Login on build ftp.                                                                                                           | `""`                                            |
| `rtr.buildFtp.password`         | Password on build ftp.                                                                                                        | `""`                                            |
| `rtr.buildFtp.serverUrl`        | URL build ftp.                                                                                                                | `""`                                            |
| `rtr.prometheus.baseDir`        | Base dir on premtheus.                                                                                                        | `api/private/Export/segmentGrid/freezeVersions` |
| `rtr.prometheus.serverUrl`      | URL premtheus.                                                                                                                | `""`                                            |
| `rtr.puzzle.baseDir`            | Base dir on puzzle.                                                                                                           | `api/segments-to-download?version=%version%`    |
| `rtr.puzzle.serverUrl`          | URL puzzle.                                                                                                                   | `""`                                            |
| `rtr.puzzleSegments.baseDir`    | Base dir on puzzle segments.                                                                                                  | `api/segments/%code%?version=%version%`         |
| `rtr.puzzleSegments.serverUrl`  | URL puzzle segments.                                                                                                          | `""`                                            |
| `rtr.webapi.baseDir`            | Base dir on webapi.                                                                                                           | `/2.0/region/list?fields=*&type=segment,region` |
| `rtr.webapi.serverUrl`          | URL webapi.                                                                                                                   | `""`                                            |

### customCAs **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container. If empty, the default value: "/usr/local/share/ca-certificates"          | `""`  |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
