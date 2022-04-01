# 2GIS Tiles API service

Use this Helm chart to deploy Tiles API service, which is a part of 2GIS's [On-Premise Maps services](https://docs.2gis.com/en/on-premise/map).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/map) to learn how to:

- Install the service.

    When filling in the keys for `values-tiles.yaml` configuration file, refer to the documentation and the list of keys below.

- Update the service.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.affinity | object | `{}` |  |
| api.annotations | object | `{}` |  |
| api.containerPort | int | `8000` |  |
| api.hpa.enabled | bool | `false` |  |
| api.hpa.maxReplicas | int | `1` |  |
| api.hpa.minReplicas | int | `1` |  |
| api.hpa.targetCPUUtilizationPercentage | int | `50` |  |
| api.image | string | `"2gis-on-premise/tiles-api"` | The path to the docker image. Must have a path to your private docker registry |
| api.imagePullSecrets | object | `{}` |  |
| api.ingress.className | string | `"nginx"` |  |
| api.ingress.enabled | bool | `false` |  |
| api.ingress.hosts[0].host | string | `"tiles-api.loc"` |  |
| api.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| api.ingress.tls | list | `[]` |  |
| api.labels | object | `{}` |  |
| api.nodeSelector | object | `{}` |  |
| api.pdb.enabled | bool | `true` |  |
| api.pdb.maxUnavailable | int | `1` |  |
| api.podAnnotations | object | `{}` |  |
| api.podLabels | object | `{}` |  |
| api.pullPolicy | string | `"IfNotPresent"` |  |
| api.replicaCount | int | `3` |  |
| api.resources.limits.cpu | int | `1` |  |
| api.resources.limits.memory | string | `"512Mi"` |  |
| api.resources.requests.cpu | string | `"50m"` |  |
| api.resources.requests.memory | string | `"128Mi"` |  |
| api.revisionHistory | int | `1` |  |
| api.service.annotations | object | `{}` |  |
| api.service.labels | object | `{}` |  |
| api.service.port | int | `80` |  |
| api.service.type | string | `"ClusterIP"` |  |
| api.strategy.rollingUpdate.maxSurge | int | `1` |  |
| api.strategy.rollingUpdate.maxUnavailable | int | `0` |  |
| api.tag | string | `"v4.19.2"` | Tag with application version |
| api.terminationGracePeriodSeconds | int | `30` |  |
| api.tolerations | object | `{}` |  |
| api.vpa.enabled | bool | `false` |  |
| api.vpa.maxAllowed.cpu | int | `1` |  |
| api.vpa.maxAllowed.memory | string | `"512Mi"` |  |
| api.vpa.minAllowed.memory | string | `"128Mi"` |  |
| api.vpa.updateMode | string | `"Auto"` |  |
| cassandra.consistencyLevelRead | string | `"LOCAL_QUORUM"` | Consistency level for database read queries. All possible values can be viewed by [link](https://docs.datastax.com/en/cassandra-oss/3.0/cassandra/dml/dmlConfigConsistency.html#Readconsistencylevels) |
| cassandra.consistencyLevelWrite | string | `"LOCAL_QUORUM"` | Consistency level for database write queries. All possible values can be viewed by [link](https://docs.datastax.com/en/cassandra-oss/3.0/cassandra/dml/dmlConfigConsistency.html#Writeconsistencylevels) |
| cassandra.credentials | object | `{"password":"cassandra","user":"cassandra"}` | Credentials for Cassandra authentication |
| cassandra.hosts | list | `[]` | List of available Cassandra database nodes |
| cassandra.replicaFactor | int | `3` | Replication factor for Cassandra |
| dgctlDockerRegistry | string | `""` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. |
| dgctlStorage | object |   | <h3>Deployment Artifacts Storage</h3> |
| dgctlStorage.accessKey | string | `""` | S3 access key for accessing the bucket. |
| dgctlStorage.bucket | string | `""` | S3 bucket name. |
| dgctlStorage.host | string | `""` | S3 endpoint. Format: `host:port`. |
| dgctlStorage.manifest | string | `""` | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2--Common_deployment_steps).  Format: `manifests/0000000000.json`. <br> This file contains the description of pieces of data that the service requires to operate. |
| dgctlStorage.secretKey | string | `""` | S3 secret key for accessing the bucket. |
| importer.enabled | bool | `true` |  |
| importer.image | string | `"2gis-on-premise/tiles-api-importer"` | The path to the docker image. Must have a path to your private docker registry |
| importer.imagePullSecrets | object | `{}` |  |
| importer.nodeSelector | object | `{}` |  |
| importer.pullPolicy | string | `"IfNotPresent"` |  |
| importer.resources.limits.cpu | string | `"100m"` |  |
| importer.resources.limits.memory | string | `"256Mi"` |  |
| importer.resources.requests.cpu | string | `"50m"` |  |
| importer.resources.requests.memory | string | `"128Mi"` |  |
| importer.tag | string | `"v4.19.2"` | Tag with application version |
| importer.tolerations | object | `{}` |  |
| importer.workerNum | int | `6` | Number of parallel import processes (spawned jobs) |
| importer.workerResources.limits.cpu | int | `2` |  |
| importer.workerResources.limits.memory | string | `"2048Mi"` |  |
| importer.workerResources.requests.cpu | string | `"256m"` |  |
| importer.workerResources.requests.memory | string | `"512Mi"` |  |
| importer.writerNum | int | `8` | Number of write processes per import process |
| name | string | `"tiles-api"` | Name of the deployment |
| proxy.access.enabled | bool | `false` | Flag to enable verification access key |
| proxy.access.host | string | `"http://keys-api.localhost"` | Host for Keys API service |
| proxy.access.syncPeriod | string | `"2m"` |  |
| proxy.access.token | string | `""` | Service key for Keys API |
| proxy.containerPort | int | `5000` |  |
| proxy.image | string | `"2gis-on-premise/tiles-api-proxy"` | The path to the docker image. Must have a path to your private docker registry |
| proxy.resources.limits.cpu | int | `1` |  |
| proxy.resources.limits.memory | string | `"512Mi"` |  |
| proxy.resources.requests.cpu | string | `"50m"` |  |
| proxy.resources.requests.memory | string | `"128Mi"` |  |
| proxy.tag | string | `"v4.19.2"` | Tag with application version |
| proxy.timeout | string | `"5s"` |  |
| serviceName | string | `"tiles-api-webgl"` | Name of the service. It depends on the [deployment configuration](https://docs.2gis.com/en/on-premise/map#nav-lvl1--Architecture): <ul><li>`tiles-api-webgl` for Tiles API with vector tiles support. </li><li>`tiles-api-raster` for Tiles API with raster tiles support.</li><ul> |
| type | string | `"web"` | Type of the [deployment configuration](https://docs.2gis.com/en/on-premise/map#nav-lvl1--Architecture): <ul><li>An empty string for Tiles API with vector tiles support.</li> <li>`raster` for Tiles API with raster tiles support.</li><ul> |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | on-premise@2gis.com | https://github.com/2gis |
