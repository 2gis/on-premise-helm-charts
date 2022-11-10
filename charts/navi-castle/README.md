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
| `castle.image.tag`        | Navi-Castle service image tag.        | `1.0.6.1`                     |
| `nginx.image.repository`  | Navi-Front image repository.          | `2gis-on-premise/navi-front`  |
| `nginx.image.tag`         | Navi-Front image tag.                 | `1.21-ad06a0e0`               |


### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                              | Value |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`.                                                                                                                                                                                                                        | `""`  |
| `dgctlStorage.bucket`    | S3 bucket name.                                                                                                                                                                                                                                          | `""`  |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket.                                                                                                                                                                                                                  | `""`  |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket.                                                                                                                                                                                                                  | `""`  |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json`.<br> This file contains the description of pieces of data that the service requires to operate. | `""`  |


### Common settings

| Name                 | Description                                                                                                                 | Value |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `replicaCount`       | A replica count for the pod.                                                                                                | `1`   |
| `imagePullSecrets`   | Kubernetes image pull secrets.                                                                                              | `[]`  |
| `nameOverride`       | Base name to use in all the Kubernetes entities deployed by this chart.                                                     | `""`  |
| `fullnameOverride`   | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                 | `""`  |
| `podAnnotations`     | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`  |
| `podSecurityContext` | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).              | `{}`  |
| `securityContext`    | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                  | `{}`  |
| `nodeSelector`       | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).         | `{}`  |
| `tolerations`        | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.           | `[]`  |
| `affinity`           | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). | `{}`  |


### Service account settings

| Name                         | Description                                                                                                             | Value  |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                                                  | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account.                                                                              | `{}`   |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`   |


### Service settings

| Name           | Description                                                                                                                    | Value       |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.type` | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port` | Service port.                                                                                                                  | `80`        |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                    | Description                            | Value              |
| ----------------------- | -------------------------------------- | ------------------ |
| `ingress.enabled`       | If Ingress is enabled for the service. | `false`            |
| `ingress.hosts[0].host` | Hostname for the Ingress service.      | `navi-castle.host` |


### Limits

| Name                        | Description                      | Value |
| --------------------------- | -------------------------------- | ----- |
| `resources.requests.cpu`    | A CPU request, e.g., `100m`.     |       |
| `resources.requests.memory` | A memory request, e.g., `128Mi`. |       |
| `resources.limits.cpu`      | A CPU limit, e.g., `100m`.       |       |
| `resources.limits.memory`   | A memory limit, e.g., `128Mi`.   |       |


### Navi-Castle service settings

| Name                       | Description                          | Value                          |
| -------------------------- | ------------------------------------ | ------------------------------ |
| `castle.castleDataPath`    | Path to the data directory.          | `/opt/castle/data/`            |
| `castle.restrictions.host` | Restrictions API base URL.           | `http://restrictions-api.host` |
| `castle.restrictions.key`  | Restrictions API key.                | `""`                           |
| `castle.jobs`              | Number of parallel downloading jobs. | `1`                            |


### Navi-Front settings

| Name         | Description                                      | Value  |
| ------------ | ------------------------------------------------ | ------ |
| `nginx.port` | HTTP port on which Navi-Front will be listening. | `8080` |


### Cron settings

| Name                              | Description                                        | Value         |
| --------------------------------- | -------------------------------------------------- | ------------- |
| `cron.enabled.import`             | If the `import` cron job is enabled.               | `false`       |
| `cron.enabled.restriction`        | If the `restriction` cron job is enabled.          | `false`       |
| `cron.schedule.import`            | Cron job schedule for `import`.                    | `11 * * * *`  |
| `cron.schedule.restriction`       | Cron job schedule for `restriction`.               | `*/5 * * * *` |
| `cron.concurrencyPolicy`          | Cron job concurrency policy: `Allow` or `Forbid`.  | `Forbid`      |
| `cron.successfulJobsHistoryLimit` | How many completed and failed jobs should be kept. | `3`           |


### Kubernetes [Persistence Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) settings

| Name                            | Description                                                                           | Value               |
| ------------------------------- | ------------------------------------------------------------------------------------- | ------------------- |
| `persistentVolume.enabled`      | If Kubernetes persistence volume should be enabled for ZooKeeper.                     | `false`             |
| `persistentVolume.accessModes`  | Volume access mode.                                                                   | `["ReadWriteOnce"]` |
| `persistentVolume.storageClass` | Volume [storage class](https://kubernetes.io/docs/concepts/storage/storage-classes/). | `ceph-csi-rbd`      |
| `persistentVolume.size`         | Volume size.                                                                          | `5Gi`               |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
