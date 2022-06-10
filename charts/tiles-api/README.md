# 2GIS Tiles API service

Use this Helm chart to deploy Tiles API service, which is a part of 2GIS's [On-Premise Maps services](https://docs.2gis.com/en/on-premise/map).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/map) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-tiles.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

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
| api.image.pullPolicy | string | `"IfNotPresent"` |  |
| api.image.repository | string | `"2gis-on-premise/tiles-api"` |  |
| api.image.tag | string | `"v4.19.2"` |  |
| api.imagePullSecrets | list | `[]` |  |
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
| cassandra.environment | string | `""` | Environment name (prod, stage, etc) allows creating multiple environments on a single cassandra cluster |
| cassandra.hosts | list | `[]` | List of available Cassandra database nodes |
| cassandra.replicaFactor | int | `3` | Replication factor for Cassandra |
| dgctlDockerRegistry | string | `""` |  |
| dgctlStorage.accessKey | string | `""` |  |
| dgctlStorage.bucket | string | `""` |  |
| dgctlStorage.host | string | `""` |  |
| dgctlStorage.manifest | string | `""` |  |
| dgctlStorage.secretKey | string | `""` |  |
| importer.enabled | bool | `true` |  |
| importer.image.pullPolicy | string | `"IfNotPresent"` |  |
| importer.image.repository | string | `"2gis-on-premise/tiles-api-importer"` |  |
| importer.image.tag | string | `"v4.19.2"` |  |
| importer.imagePullSecrets | list | `[]` |  |
| importer.nodeSelector | object | `{}` |  |
| importer.resources.limits.cpu | string | `"100m"` |  |
| importer.resources.limits.memory | string | `"256Mi"` |  |
| importer.resources.requests.cpu | string | `"50m"` |  |
| importer.resources.requests.memory | string | `"128Mi"` |  |
| importer.tolerations | object | `{}` |  |
| importer.workerNum | int | `6` | Number of parallel import processes (spawned jobs) |
| importer.workerResources.limits.cpu | int | `2` |  |
| importer.workerResources.limits.memory | string | `"2048Mi"` |  |
| importer.workerResources.requests.cpu | string | `"256m"` |  |
| importer.workerResources.requests.memory | string | `"512Mi"` |  |
| importer.writerNum | int | `8` | Number of write processes per import process |
| name | string | `"tiles-api"` |  |
| proxy.access.enabled | bool | `false` | Flag to enable verification access key |
| proxy.access.host | string | `"http://keys-api.localhost"` | Host for Keys API service |
| proxy.access.syncPeriod | string | `"2m"` |  |
| proxy.access.token | string | `""` | Service key for Keys API |
| proxy.containerPort | int | `5000` |  |
| proxy.image.pullPolicy | string | `"IfNotPresent"` |  |
| proxy.image.repository | string | `"2gis-on-premise/tiles-api-proxy"` |  |
| proxy.image.tag | string | `"v4.19.2"` |  |
| proxy.resources.limits.cpu | int | `1` |  |
| proxy.resources.limits.memory | string | `"512Mi"` |  |
| proxy.resources.requests.cpu | string | `"50m"` |  |
| proxy.resources.requests.memory | string | `"128Mi"` |  |
| proxy.timeout | string | `"5s"` |  |
| serviceName | string | `"tiles-api-webgl"` |  |
| type | string | `"web"` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
