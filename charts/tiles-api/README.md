# 2GIS Tiles API

The repository contains a HTTP server for giving tiles data with import process

## Requirements

- Cassandra database

## Data importing

Data import starts before the main HTTP API is launched and is based on the mechanism of hooks

## Installing the Chart

To install the chart with the release name `testing`:

``` shell
helm repo add 2gis-on-premise https://2gis.github.io/on-premise-helm-charts
helm install testing 2gis-on-premise/tiles-api --atomic --timeout=60m -f ./customvalues.yaml
```

## Upgrading

To upgrade the chart:

```shell
helm upgrade testing 2gis-on-premise/tiles-api --atomic --timeout=60m -f ./customvalues.yaml
```

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
| api.image.tag | string | `"v4.21.0"` |  |
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
| cassandra.credentials | object | `{"jmxPassword":"cassandra","jmxUser":"cassandra","password":"cassandra","user":"cassandra"}` | Credentials for Cassandra authentication |
| cassandra.credentials.jmxUser | string | `"cassandra"` | user / password for JMX queries (like calling nodetool) |
| cassandra.credentials.user | string | `"cassandra"` | user / password for CQL queries (read/write to database) |
| cassandra.environment | string | `""` | Environment name (prod, stage, etc) allows creating multiple environments on a single cassandra cluster |
| cassandra.hosts | list | `[]` | List of available Cassandra database nodes |
| cassandra.replicaFactor | int | `3` | Replication factor for Cassandra |
| dgctlDockerRegistry | string | `""` |  |
| dgctlStorage.accessKey | string | `""` |  |
| dgctlStorage.bucket | string | `""` |  |
| dgctlStorage.host | string | `""` |  |
| dgctlStorage.manifest | string | `""` |  |
| dgctlStorage.secretKey | string | `""` |  |
| importer.cleaner.enabled | bool | `false` | Enables cassandra previous tilesets cleaning before making new imports |
| importer.cleaner.limit | int | `3` | How many old tilesets leave untouched, minimum 1 |
| importer.cleaner.resources.limits.cpu | string | `"1000m"` |  |
| importer.cleaner.resources.limits.memory | string | `"512Mi"` |  |
| importer.cleaner.resources.requests.cpu | string | `"50m"` |  |
| importer.cleaner.resources.requests.memory | string | `"128Mi"` |  |
| importer.clearSnapshots | bool | `false` | In case of removing keyspace also remove its snapshots (using `nodetool clearsnapshot` over JMX) |
| importer.enabled | bool | `true` |  |
| importer.forceImport | bool | `false` | Delete existing keyspace and make imports if true, otherwise skip imports |
| importer.image.pullPolicy | string | `"IfNotPresent"` |  |
| importer.image.repository | string | `"2gis-on-premise/tiles-api-importer"` |  |
| importer.image.tag | string | `"v4.21.0"` |  |
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
| proxy.image.tag | string | `"v4.21.0"` |  |
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
