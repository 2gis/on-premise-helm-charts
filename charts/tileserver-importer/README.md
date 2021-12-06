# 2GIS Tileserver importer

This repository contains the application for uploading map data divided by tiles.

It consists of a K8S Job that, by downloading data files, spawn child jobs to import and save them in the Cassandra database

## Requirements

- Cassandra database
- S3 compatible storage

## Deploy

Deploy the chart with the release name `importer-release`:

``` shell
helm upgrade --install importer-release ./tileserver-importer
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| manifestPath | string | `"manifests/1635402744.json"` | Path to the manifest in S3-like storage. The manifest is downloaded via the dgctl utility |
| tileserver.cassandra.consistencyLevelRead | string | `"ONE"` | Consistency level for database read queries |
| tileserver.cassandra.consistencyLevelWrite | string | `"ONE"` | Consistency level for database write queries |
| tileserver.cassandra.hosts | list | `[]` | List of available Cassandra database nodes |
| tileserver.cassandra.replicaFactor | int | `1` | Replication factor for Cassandra |
| tileserver.importer.image | string | `"2gis/selfimporter"` | The path to the docker image. Must have a path to your private docker registry |
| tileserver.importer.nodeSelector | object | `{}` |  |
| tileserver.importer.pullPolicy | string | `"IfNotPresent"` |  |
| tileserver.importer.storage.accessKey | string | `"accessKey"` |  |
| tileserver.importer.storage.bucket | string | `"backet"` |  |
| tileserver.importer.storage.host | string | `"s3host.local"` |  |
| tileserver.importer.storage.secretKey | string | `"secretKey"` |  |
| tileserver.importer.tag | string | `"v1.0.0"` | Tag with application version |
| tileserver.importer.workerNum | int | `10` | Number of parallel import processes (spawned jobs) |
| tileserver.importer.writerNum | int | `8` | Number of write processes per import process |
| tileserver.serviceName | string | `"tileserver-api"` | The ID of the service, it is used to search block in the manifest |
| tileserver.type | string | `"web"` | The type of data being uploaded. Can have one of the values: web, native, raster |

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | selfhosting@2gis.com | https://github.com/2gis |
