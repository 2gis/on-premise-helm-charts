# 2GIS Tileserver API

The repository contains a HTTP server for giving tiles data.

## Requirements

- Cassandra database

## Deploy

Deploy the chart with the release name `api-release`:

``` shell
helm upgrade --install api-release ./tileserver-api
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| manifestPath | string | `"manifests/1635402744.json"` | Path to the manifest in S3-like storage. The manifest is downloaded via the dgctl utility |
| tileserver.api.affinity | object | `{}` |  |
| tileserver.api.hpa.enabled | bool | `false` |  |
| tileserver.api.hpa.maxReplicas | int | `1` |  |
| tileserver.api.hpa.minReplicas | int | `1` |  |
| tileserver.api.hpa.targetCPUUtilizationPercentage | int | `50` |  |
| tileserver.api.image | string | `"2gis/tileserver"` | The path to the docker image. Must have a path to your private docker registry |
| tileserver.api.ingress.className | string | `"nginx"` |  |
| tileserver.api.ingress.enabled | bool | `true` |  |
| tileserver.api.ingress.hosts[0].host | string | `"tileserver.loc"` |  |
| tileserver.api.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| tileserver.api.ingress.tls | list | `[]` |  |
| tileserver.api.nodeSelector | object | `{}` |  |
| tileserver.api.podDisruptionBudget.enabled | bool | `true` |  |
| tileserver.api.podDisruptionBudget.maxUnavailable | int | `1` |  |
| tileserver.api.pullPolicy | string | `"IfNotPresent"` |  |
| tileserver.api.replicaCount | int | `3` |  |
| tileserver.api.resources | object | `{}` |  |
| tileserver.api.revisionHistory | int | `1` |  |
| tileserver.api.service.annotations | object | `{}` |  |
| tileserver.api.service.labels | object | `{}` |  |
| tileserver.api.service.port | int | `80` |  |
| tileserver.api.service.type | string | `"ClusterIP"` |  |
| tileserver.api.tag | string | `"v1.0.0"` | Tag with application version |
| tileserver.api.terminationGracePeriodSeconds | int | `10` |  |
| tileserver.api.vpa.enabled | bool | `false` |  |
| tileserver.api.vpa.maxAllowed.cpu | int | `1` |  |
| tileserver.api.vpa.maxAllowed.memory | string | `"512Mi"` |  |
| tileserver.api.vpa.minAllowed.memory | string | `"128Mi"` |  |
| tileserver.api.vpa.updateMode | string | `"Auto"` |  |
| tileserver.type | string | `"web"` | The type of data being uploaded. Can have one of the values: web, native, raster |

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | selfhosting@2gis.com | https://github.com/2gis |
