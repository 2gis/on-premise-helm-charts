# 2GIS Catalog API service

Use this Helm chart to deploy Catalog API service, which is a part of 2GIS's [On-Premise Search services](https://docs.2gis.com/en/on-premise/search).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/search) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-catalog.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |


### Common settings

| Name               | Description                                                                                                                                          | Value |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `nodeSelector`     | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                  | `{}`  |
| `affinity`         | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                          | `{}`  |
| `tolerations`      | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                    | `[]`  |
| `podAnnotations`   | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)                                         | `{}`  |
| `podLabels`        | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                  | `{}`  |
| `imagePullSecrets` | Kubernetes secrets for [pulling the image from the registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/). | `[]`  |


### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                          | Value   |
| -------------------- | ---------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service.                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`     |


### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                              | Value |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`.                                                                                                                                                                                                                        | `""`  |
| `dgctlStorage.bucket`    | S3 bucket name.                                                                                                                                                                                                                                          | `""`  |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket.                                                                                                                                                                                                                  | `""`  |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket.                                                                                                                                                                                                                  | `""`  |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json`.<br> This file contains the description of pieces of data that the service requires to operate. | `""`  |


### API settings

| Name           | Description                     | Value |
| -------------- | ------------------------------- | ----- |
| `api.replicas` | Number of replicas of API pods. | `1`   |


### Deployment settings

| Name                   | Description | Value                         |
| ---------------------- | ----------- | ----------------------------- |
| `api.image.repository` | Repository  | `2gis-on-premise/catalog-api` |
| `api.image.tag`        | Tag         | `3.574.0`                     |
| `api.image.pullPolicy` | Pull Policy | `IfNotPresent`                |


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


### Limits

| Name                            | Description       | Value    |
| ------------------------------- | ----------------- | -------- |
| `api.resources.requests.cpu`    | A CPU request.    | `2`      |
| `api.resources.requests.memory` | A memory request. | `6000Mi` |
| `api.resources.limits.cpu`      | A CPU limit.      | `4`      |
| `api.resources.limits.memory`   | A memory limit.   | `6500Mi` |


### Service settings

| Name                      | Description                                                                                                                    | Value       |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `api.service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)               | `{}`        |
| `api.service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `api.service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `api.service.port`        | Service port.                                                                                                                  | `80`        |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                        | Description                            | Value              |
| --------------------------- | -------------------------------------- | ------------------ |
| `api.ingress.enabled`       | If Ingress is enabled for the service. | `false`            |
| `api.ingress.hosts[0].host` | Hostname for the Ingress service.      | `catalog-api.host` |


### Database settings

| Name              | Description               | Value           |
| ----------------- | ------------------------- | --------------- |
| `api.db.host`     | PostgreSQL rw/ro host.    | `postgres.host` |
| `api.db.port`     | PostgreSQL port.          | `5432`          |
| `api.db.name`     | PostgreSQL database name. | `catalog`       |
| `api.db.username` | PostgreSQL username.      | `postgres`      |
| `api.db.password` | PostgreSQL password.      | `secret`        |


### Search

| Name         | Description                                                                                                | Value                    |
| ------------ | ---------------------------------------------------------------------------------------------------------- | ------------------------ |
| `search.url` | URL of the Search service. This URL should be accessible from all the pods within your Kubernetes cluster. | `http://search-api.host` |


### Keys

| Name                          | Description                                                                                              | Value                   |
| ----------------------------- | -------------------------------------------------------------------------------------------------------- | ----------------------- |
| `keys.endpoint`               | URL of the Keys service. This URL should be accessible from all the pods within your Kubernetes cluster. | `https://keys-api.host` |
| `keys.requestTimeout`         | Timeout for requests to the Keys API.                                                                    | `5s`                    |
| `keys.serviceKeys.places`     | Places API key (if available).                                                                           | `""`                    |
| `keys.serviceKeys.geocoder`   | Geocoder API key (if available).                                                                         | `""`                    |
| `keys.serviceKeys.suggest`    | Suggest API key (if available).                                                                          | `""`                    |
| `keys.serviceKeys.categories` | Categories API key (if available).                                                                       | `""`                    |
| `keys.serviceKeys.regions`    | Regions API key (if available).                                                                          | `""`                    |


### Kubernetes Importer job settings

| Name                                         | Description                                                                                                                   | Value                              |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `importer`                                   | **Common settings**                                                                                                           |                                    |
| `importer.nodeSelector`                      | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).           | `{}`                               |
| `importer.workerNum`                         | Number of parallel import processes (workers).                                                                                | `3`                                |
| `importer.initialDelaySeconds`               | Number of seconds after the container has started before liveness or readiness probes are initiated.                          | `1`                                |
| `importer.retryAttempt`                      | The maximum number of retries download before stopping.                                                                       | `3`                                |
| `importer.retryTimeout`                      | Delay until the retry attempts.                                                                                               | `1s`                               |
| `importer.image`                             | **Deployment settings**                                                                                                       |                                    |
| `importer.image.repository`                  | Repository                                                                                                                    | `2gis-on-premise/catalog-importer` |
| `importer.image.tag`                         | Tag                                                                                                                           | `1.0.7`                            |
| `importer.image.pullPolicy`                  | Pull Policy                                                                                                                   | `IfNotPresent`                     |
| `importer.resources`                         | **Kubernetes [resource management settings](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)** |                                    |
| `importer.resources.requests.cpu`            | A CPU request.                                                                                                                | `256m`                             |
| `importer.resources.requests.memory`         | A memory request.                                                                                                             | `512Mi`                            |
| `importer.resources.limits.cpu`              | A CPU limit.                                                                                                                  | `2`                                |
| `importer.resources.limits.memory`           | A memory limit.                                                                                                               | `2048Mi`                           |
| `importer.db`                                | **Database settings**                                                                                                         |                                    |
| `importer.db.host`                           | PostgreSQL rw host.                                                                                                           | `postgres.host`                    |
| `importer.db.port`                           | PostgreSQL port.                                                                                                              | `5432`                             |
| `importer.db.name`                           | PostgreSQL database name.                                                                                                     | `catalog`                          |
| `importer.db.username`                       | PostgreSQL username with rw access.                                                                                           | `postgres`                         |
| `importer.db.password`                       | PostgreSQL password.                                                                                                          | `secret`                           |
| `importer.db.schemaSwitchEnabled`            | Automatic switch PostgreSQL schema on releases.                                                                               | `true`                             |
| `importer.persistentVolume`                  | **Persistent Volume settings**                                                                                                |                                    |
| `importer.persistentVolume.enabled`          | If [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) is enabled for the service.          | `false`                            |
| `importer.persistentVolume.accessModes`      | AccessModes.                                                                                                                  | `["ReadWriteOnce"]`                |
| `importer.persistentVolume.storageClass`     | StorageClass.                                                                                                                 | `topolvm-ext4`                     |
| `importer.persistentVolume.size`             | Volume size.                                                                                                                  | `50Gi`                             |
| `importer.cleaner`                           | **Cleaner scheme settings**                                                                                                   |                                    |
| `importer.cleaner.enabled`                   | If clean schemes is enabled for the service.                                                                                  | `true`                             |
| `importer.cleaner.versionLimit`              | Number of backup schemes.                                                                                                     | `2`                                |
| `importer.cleaner.resources`                 | **Kubernetes [resource management settings](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)** |                                    |
| `importer.cleaner.resources.requests.cpu`    | A CPU request.                                                                                                                | `50m`                              |
| `importer.cleaner.resources.requests.memory` | A memory request.                                                                                                             | `128Mi`                            |
| `importer.cleaner.resources.limits.cpu`      | A CPU limit.                                                                                                                  | `1000m`                            |
| `importer.cleaner.resources.limits.memory`   | A memory limit.                                                                                                               | `512Mi`                            |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
