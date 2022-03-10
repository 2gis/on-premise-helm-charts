# 2GIS Tileserver

The repository contains a HTTP server for giving tiles data with import process

## Requirements

- Cassandra database

## Data importing

Data import starts before the main HTTP API is launched and is based on the mechanism of hooks

## Installing the Chart

To install the chart with the release name `testing`:

``` shell
helm repo add 2gis-on-premise https://2gis.github.io/on-premise-helm-charts
helm install testing 2gis-on-premise/tileserver --atomic --timeout=60m -f ./customvalues.yaml
```

## Upgrading

To upgrade the chart:

```shell
helm upgrade testing 2gis-on-premise/tileserver --atomic --timeout=60m -f ./customvalues.yaml
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.affinity | object | `{}` |  |
| api.annotations | object | `{}` |  |
| api.hpa.enabled | bool | `false` |  |
| api.hpa.maxReplicas | int | `1` |  |
| api.hpa.minReplicas | int | `1` |  |
| api.hpa.targetCPUUtilizationPercentage | int | `50` |  |
| api.image | string | `"on-premise/tiles-api"` | The path to the docker image. Must have a path to your private docker registry |
| api.imagePullSecrets | object | `{}` |  |
| api.ingress.className | string | `"nginx"` |  |
| api.ingress.enabled | bool | `false` |  |
| api.ingress.hosts[0].host | string | `"tileserver.loc"` |  |
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
| api.tag | string | `"v1.0.0"` | Tag with application version |
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
| importer.enabled | bool | `true` |  |
| importer.image | string | `"on-premise/tiles-api-importer"` | The path to the docker image. Must have a path to your private docker registry |
| importer.imagePullSecrets | object | `{}` |  |
| importer.nodeSelector | object | `{}` |  |
| importer.pullPolicy | string | `"IfNotPresent"` |  |
| importer.resources.limits.cpu | string | `"100m"` |  |
| importer.resources.limits.memory | string | `"256Mi"` |  |
| importer.resources.requests.cpu | string | `"50m"` |  |
| importer.resources.requests.memory | string | `"128Mi"` |  |
| importer.storage.accessKey | string | `"accessKey"` |  |
| importer.storage.bucket | string | `"backet"` |  |
| importer.storage.host | string | `"s3host.local"` |  |
| importer.storage.secretKey | string | `"secretKey"` |  |
| importer.tag | string | `"v1.0.0"` | Tag with application version |
| importer.tolerations | object | `{}` |  |
| importer.workerNum | int | `20` | Number of parallel import processes (spawned jobs) |
| importer.workerResources.limits.cpu | int | `2` |  |
| importer.workerResources.limits.memory | string | `"2048Mi"` |  |
| importer.workerResources.requests.cpu | string | `"256m"` |  |
| importer.workerResources.requests.memory | string | `"512Mi"` |  |
| importer.writerNum | int | `8` | Number of write processes per import process |
| manifestPath | string | `"manifests/1635402744.json"` | Path to the manifest in S3-like storage. The manifest is downloaded via the dgctl utility |
| name | string | `"tileserver"` |  |
| serviceName | string | `"tiles-api-webgl"` |  |
| type | string | `"web"` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | on-premise@2gis.com | https://github.com/2gis |
