# 2GIS PRO API Service

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |


### Common settings

| Name                            | Description                                                                                                                                    | Value     |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| `appName`                       | Name of the service.                                                                                                                           | `pro-api` |
| `replicaCount`                  | A replica count for the pod.                                                                                                                   | `2`       |
| `imagePullSecrets`              | Kubernetes image pull secrets.                                                                                                                 | `[]`      |
| `nameOverride`                  | Base name to use in all the Kubernetes entities deployed by this chart.                                                                        | `""`      |
| `fullnameOverride`              | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                                    | `""`      |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                            | `{}`      |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                    | `{}`      |
| `priorityClassName`             | Kubernetes [pod priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/).                                   | `""`      |
| `terminationGracePeriodSeconds` | Kubernetes [termination grace period](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/).                              | `60`      |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                              | `[]`      |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                  | `{}`      |
| `podLabels`                     | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                            | `{}`      |
| `annotations`                   | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                      | `{}`      |
| `labels`                        | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                | `{}`      |
| `revisionHistoryLimit`          | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`       |


### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                              | Value                   |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`.                                                                                                                                                                                                                        | `""`                    |
| `dgctlStorage.bucket`    | S3 bucket name.                                                                                                                                                                                                                                          | `""`                    |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket.                                                                                                                                                                                                                  | `""`                    |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket.                                                                                                                                                                                                                  | `""`                    |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json`.<br> This file contains the description of pieces of data that the service requires to operate. | `manifests/latest.json` |


### Strategy settings

| Name                                    | Description                                                                                                                                                                                              | Value           |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |


### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)               | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | Tiles API service port.                                                                                                        | `80`        |


### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                    | Description                                                                                                  | Value   |
| ----------------------- | ------------------------------------------------------------------------------------------------------------ | ------- |
| `vpa.enabled`           | If VPA is enabled for the service.                                                                           | `false` |
| `vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start). | `Auto`  |
| `vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down.                                   | `400m`  |
| `vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down.                                         | `256M`  |
| `vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up.                                     | `1`     |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up.                                           | `1024M` |


### Deployment settings

| Name               | Description | Value                     |
| ------------------ | ----------- | ------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/pro-api` |
| `image.tag`        | Tag         | `0.2.8`                   |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`            |


### 2GIS PRO Storage configuration

| Name                      | Description                                                                                                                                                                                                                                              | Value                   |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `s3.host`                 | S3 endpoint. Format: `host:port`.                                                                                                                                                                                                                        | `""`                    |
| `s3.accessKey`            | S3 access key for accessing the bucket.                                                                                                                                                                                                                  | `""`                    |
| `s3.secretKey`            | S3 secret key for accessing the bucket.                                                                                                                                                                                                                  | `""`                    |
| `s3.manifest`             | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json`.<br> This file contains the description of pieces of data that the service requires to operate. | `manifests/latest.json` |
| `s3.assetDataBucket`      | S3 bucket with common assets, aggregations, and filters.                                                                                                                                                                                                 | `""`                    |
| `s3.layerDataBucket`      | S3 bucket with prepared layer data.                                                                                                                                                                                                                      | `""`                    |
| `s3.userAssetsDataBucket` | S3 bucket with user-created assets, aggregations, and filters                                                                                                                                                                                            | `""`                    |


### 2GIS PRO API configuration

| Name                 | Description                                                          | Value    |
| -------------------- | -------------------------------------------------------------------- | -------- |
| `api.serviceAccount` | Kubernetes service account                                           | `runner` |
| `api.tempPath`       | Path to directory used for temp data                                 | `/tmp`   |
| `api.allowAnyOrigin` | Cors policy: allow any origin to perform requests to pro-api service | `false`  |


### PostgreSQL settings

| Name                                | Description                                                                                                                | Value |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ----- |
| `postgres.connectionString`         | Connection string to the PostgreSQL database. Format: `Server=SERVER_URL;Database=DB_NAME;UID=USER_NAME;`                  | `""`  |
| `postgres.connectionStringReadonly` | Connection string to the readonly node of PostgreSQL database. Format: `Server=SERVER_URL;Database=DB_NAME;UID=USER_NAME;` | `""`  |
| `postgres.password`                 | User password to connect to the PostgreSQL database.                                                                       | `""`  |


### Keys Service settings

| Name         | Description                                                                 | Value |
| ------------ | --------------------------------------------------------------------------- | ----- |
| `keys.host`  | API URL of service for managing partners' keys to 2GIS services (keys.api). | `""`  |
| `keys.token` | keys.api access token.                                                      | `""`  |


### ElasticSearch settings

| Name                  | Description                                                                          | Value |
| --------------------- | ------------------------------------------------------------------------------------ | ----- |
| `elastic.host`        | ElasticSearch host address. Format: `http://{0}@HOST:PORT`                           | `""`  |
| `elastic.credentials` | User name and password to connect to the ElasticSearch. Format: `USER_NAME:PASSWORD` | `""`  |


### Catalog API settings

| Name           | Description                                                              | Value                     |
| -------------- | ------------------------------------------------------------------------ | ------------------------- |
| `catalog.host` | Host for [Catalog API](https://docs.2gis.com/en/on-premise/search).      | `http://catalog-api.host` |
| `catalog.key`  | Access key to [Catalog API](https://docs.2gis.com/en/on-premise/search). | `""`                      |


### Navigation API settings

| Name        | Description                                                                              | Value                   |
| ----------- | ---------------------------------------------------------------------------------------- | ----------------------- |
| `navi.host` | Host for [Navigation API](https://docs.2gis.com/en/on-premise/search).                   | `http://navi-back.host` |
| `navi.key`  | Access key to [Navigation API](https://docs.2gis.com/en/on-premise/navigation/overview). | `""`                    |


### 2GIS PRO API Job settings

| Name                       | Description                | Value                     |
| -------------------------- | -------------------------- | ------------------------- |
| `appAssetImporterName`     | Data Import job name.      | `pro-asset-importer`      |
| `appUserAssetImporterName` | User Data Import job name. | `pro-user-asset-importer` |


### Import job settings

| Name                                       | Description                                                                                                                                              | Value                          |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `assetImporter.repository`                 | Docker Repository Image.                                                                                                                                 | `2gis-on-premise/pro-importer` |
| `assetImporter.tag`                        | Docker image tag                                                                                                                                         | `0.2.8`                        |
| `assetImporter.schedule`                   | Import job schedule.                                                                                                                                     | `0 18 * * *`                   |
| `assetImporter.backoffLimit`               | The number of [retries](https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy) before considering a Job as failed.   | `2`                            |
| `assetImporter.successfulJobsHistoryLimit` | How many completed and failed jobs should be kept. See [docs](https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/#jobs-history-limits). | `3`                            |
| `assetImporter.maxParallelJobs`            | How many import jobs can be run simultaneously                                                                                                           | `4`                            |
| `assetImporter.enabled`                    | If assetImporter is enabled for the service.                                                                                                             | `true`                         |


### Limits

| Name                                      | Description                            | Value   |
| ----------------------------------------- | -------------------------------------- | ------- |
| `resources`                               | **Limits for the application service** |         |
| `resources.requests.cpu`                  | A CPU request.                         | `400m`  |
| `resources.requests.memory`               | A memory request.                      | `256M`  |
| `resources.limits.cpu`                    | A CPU limit.                           | `1`     |
| `resources.limits.memory`                 | A memory limit.                        | `1024M` |
| `assetImporter.resources`                 | **Limits for the import job**          |         |
| `assetImporter.resources.requests.cpu`    | A CPU request.                         | `700m`  |
| `assetImporter.resources.requests.memory` | A memory request.                      | `256M`  |
| `assetImporter.resources.limits.cpu`      | A CPU limit.                           | `1000m` |
| `assetImporter.resources.limits.memory`   | A memory limit.                        | `1024M` |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                    | Description                            | Value          |
| ----------------------- | -------------------------------------- | -------------- |
| `ingress.enabled`       | If Ingress is enabled for the service. | `false`        |
| `ingress.hosts[0].host` | Hostname for the Ingress service.      | `pro-api.host` |


## Installing

1. Create a configuration file values-api.yaml and fill in all the required parameters according to the docs above.
2. Then execute command:<br/>
`- helm upgrade "pro-api" --install --atomic --wait --wait-for-jobs --timeout 10m --values ./values-api.yaml`
3. Check installation by executing request<br/>
`https://2GIS_API_HOST/building/items?bounds=POLYGON%20%28%2854.605596%2024.429549%2C%2054.539606%2024.429549%2C%2054.539606%2024.413378%2C%2054.605596%2024.413378%2C%2054.605596%2024.429549%29%29`
<br/>The response must contain a list of elements in json format, response http code = 200

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
