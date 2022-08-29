# 2GIS PRO API Service

## Chart values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |


### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                              | Value                   |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`.                                                                                                                                                                                                                        | `""`                    |
| `dgctlStorage.bucket`    | S3 bucket name.                                                                                                                                                                                                                                          | `""`                    |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket.                                                                                                                                                                                                                  | `""`                    |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket.                                                                                                                                                                                                                  | `""`                    |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json`.<br> This file contains the description of pieces of data that the service requires to operate. | `manifests/latest.json` |


### 2GIS PRO API common settings

| Name                                    | Description                                                                                                                                                                                              | Value                     |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `appName`                               | Name of the service.                                                                                                                                                                                     | `pro-api`                 |
| `replicaCount`                          | A replica count for the pod.                                                                                                                                                                             | `2`                       |
| `revisionHistoryLimit`                  | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                                                           | `3`                       |
| `annotations`                           | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                | `{}`                      |
| `labels`                                | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                          | `{}`                      |
| `podAnnotations`                        | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                            | `{}`                      |
| `podLabels`                             | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                      | `{}`                      |
| `imagePullSecrets`                      | Kubernetes image pull secrets.                                                                                                                                                                           | `[]`                      |
| `affinity`                              | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                                                              | `{}`                      |
| `nodeSelector`                          | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                      | `{}`                      |
| `tolerations`                           | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                                        | `[]`                      |
| `priorityClassName`                     | Kubernetes [priorityClassName](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/) settings.                                                                               | `""`                      |
| `terminationGracePeriodSeconds`         | Duration in seconds the PRO-API service pod needs to terminate gracefully.                                                                                                                               | `60`                      |
| `strategy`                              | **Service's update strategy settings**                                                                                                                                                                   |                           |
| `strategy.rollingUpdate`                | **Service's Rolling Update strategy settings**                                                                                                                                                           |                           |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`                       |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`                       |
| `service`                               | **Kubernetes [service settings](https://kubernetes.io/docs/concepts/services-networking/service/) to expose the service**                                                                                |                           |
| `service.port`                          | 2GIS PRO API service port.                                                                                                                                                                               | `80`                      |
| `service.type`                          | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                                                                           | `ClusterIP`               |
| `service.annotations`                   | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                        | `{}`                      |
| `service.labels`                        | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                  | `{}`                      |
| `resources`                             | **Kubernetes [resource management settings](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)**                                                                            |                           |
| `resources.requests.cpu`                | A CPU request.                                                                                                                                                                                           | `400m`                    |
| `resources.requests.memory`             | A memory request.                                                                                                                                                                                        | `256M`                    |
| `resources.limits.cpu`                  | A CPU limit.                                                                                                                                                                                             | `1`                       |
| `resources.limits.memory`               | A memory limit.                                                                                                                                                                                          | `1024M`                   |
| `vpa`                                   | **Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings**                                                               |                           |
| `vpa.enabled`                           | If VPA is enabled for the service.                                                                                                                                                                       | `false`                   |
| `vpa.updateMode`                        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start).                                                                                             | `Auto`                    |
| `vpa.minAllowed.cpu`                    | Lower limit for the number of CPUs to which the autoscaler can scale down.                                                                                                                               | `400m`                    |
| `vpa.minAllowed.memory`                 | Lower limit for the RAM size to which the autoscaler can scale down.                                                                                                                                     | `256M`                    |
| `vpa.maxAllowed.cpu`                    | Upper limit for the number of CPUs to which the autoscaler can scale up.                                                                                                                                 | `1`                       |
| `vpa.maxAllowed.memory`                 | Upper limit for the RAM size to which the autoscaler can scale up.                                                                                                                                       | `1024M`                   |
| `image`                                 | **Docker image settings**                                                                                                                                                                                |                           |
| `image.repository`                      | Docker Repository.                                                                                                                                                                                       | `2gis-on-premise/pro-api` |
| `image.tag`                             | Docker image tag                                                                                                                                                                                         | `0.5.0`                   |
| `image.pullPolicy`                      | Kubernetes pull policy for the service's Docker image.                                                                                                                                                   | `IfNotPresent`            |


### 2GIS PRO Storage configuration

| Name                      | Description                                                   | Value |
| ------------------------- | ------------------------------------------------------------- | ----- |
| `s3.layerDataBucket`      | S3 bucket with prepared layer data.                           | `""`  |
| `s3.userAssetsDataBucket` | S3 bucket with user-created assets, aggregations, and filters | `""`  |


### 2GIS PRO API configuration

| Name                        | Description                                                                                                       | Value                   |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `api.tempPath`              | Path to directory used for temp data                                                                              | `/tmp`                  |
| `api.host`                  | pro-api host address                                                                                              | `""`                    |
| `api.allowAnyOrigin`        | Cors policy: allow any origin to perform requests to pro-api service                                              | `false`                 |
| `postgres`                  | **PostgreSql settings**                                                                                           |                         |
| `postgres.connectionString` | Connection string to the PostgreSql database. Format: `Server=SERVER_URL;Database=DB_NAME;UID=USER_NAME;Pwd={0};` | `""`                    |
| `postgres.password`         | User password to connect to the PostgreSql database.                                                              | `""`                    |
| `elastic`                   | **ElasticSearch settings**                                                                                        |                         |
| `elastic.host`              | ElasticSearch host address. Format: `https://{0}@HOST:PORT`                                                       | `""`                    |
| `elastic.credentials`       | User name and password to connect to the ElasticSearch. Format: `USER_NAME:PASSWORD`                              | `""`                    |
| `catalog`                   | **Catalog API settings**                                                                                          |                         |
| `catalog.host`              | Host for [Catalog API](https://docs.2gis.com/en/on-premise/search).                                               | `http://catalog.host`   |
| `catalog.key`               | Access key to [Catalog API](https://docs.2gis.com/en/on-premise/search).                                          | `""`                    |
| `navi`                      | **Navigation API settings**                                                                                       |                         |
| `navi.host`                 | Host for [Navigation API](https://docs.2gis.com/en/on-premise/search).                                            | `http://navi-back.host` |
| `navi.key`                  | Access key to [Navigation API](https://docs.2gis.com/en/on-premise/navigation/overview).                          | `""`                    |


### 2GIS PRO API Job settings

| Name                                   | Description                                                                                                                                            | Value                          |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------ |
| `appImporterName`                      | Data Import job name.                                                                                                                                  | `pro-importer`                 |
| `appUserDataImporterName`              | User Data Import job name.                                                                                                                             | `pro-userdata-importer`        |
| `importJob`                            | **Import job settings**                                                                                                                                |                                |
| `importJob.schedule`                   | Import job start schedule                                                                                                                              | `0 18 * * *`                   |
| `importJob.backoffLimit`               | The number of [retries](https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy) before considering a Job as failed. | `2`                            |
| `importJob.successfulJobsHistoryLimit` | How many completed jobs should be kept. See [docs](https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/#jobs-history-limits).          | `3`                            |
| `importJob.repository`                 | Docker Repository Image.                                                                                                                               | `2gis-on-premise/pro-importer` |
| `importJob.tag`                        | Docker image tag                                                                                                                                       | `0.5.0`                        |
| `importJob.serviceAccount`             | Kubernetes service account                                                                                                                             | `runner`                       |
| `importJob.resources`                  | **Kubernetes [resource management settings](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)**                          |                                |
| `importJob.resources.requests.cpu`     | A CPU request.                                                                                                                                         | `700m`                         |
| `importJob.resources.requests.memory`  | A memory request.                                                                                                                                      | `256M`                         |
| `importJob.resources.limits.cpu`       | A CPU limit.                                                                                                                                           | `1000m`                        |
| `importJob.resources.limits.memory`    | A memory limit.                                                                                                                                        | `1024M`                        |
| `importJob.maxParallelJobs`            | How many import jobs can be run simultaneously                                                                                                         | `4`                            |


## Installing

1. Create a configuration file values-api.yaml and fill in all the required parameters according to the docs above.
2. Then execute command:<br/>
`- helm upgrade "2gis-pro-api" --install --atomic --wait --wait-for-jobs --timeout 10m --values ./values-api.yaml`
3. Check installation by executing request<br/>
`https://2GIS_API_HOST/building/items?bounds=POLYGON%20%28%2854.605596%2024.429549%2C%2054.539606%2024.429549%2C%2054.539606%2024.413378%2C%2054.605596%2024.413378%2C%2054.605596%2024.429549%29%29`
<br/>The response must contain a list of elements in json format, response http code = 200

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |