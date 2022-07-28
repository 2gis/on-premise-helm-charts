# Proxy Traffic Jams

The repository contains an HTTP server for proxying service traffic-jams

Данный сервис является честью сервисов 2GIS On-Premise. Служит для проксирования внешних HTTP запросов к данным сервиса пробок [2GIS products](https://dev.2gis.com/).

Для дополнительной информации используйте [docs.2gis.com](https://docs.2gis.com/en/on-premise/overview)

## Installing the Chart

To install the chart with the release name `testing`:

``` shell
helm repo add 2gis-on-premise https://2gis.github.io/on-premise-helm-charts
helm install testing 2gis-on-premise/traffic-proxy --atomic --timeout=60m -f ./values.yaml
```

## Upgrading

To upgrade the chart:

```shell
helm upgrade testing 2gis-on-premise/traffic-proxy --atomic --timeout=60m -f ./values.yaml
```
