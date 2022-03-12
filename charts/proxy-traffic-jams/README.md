# Proxy Traffic Jams

The repository contains an HTTP server for proxying service traffic-jams

## Installing the Chart

To install the chart with the release name `testing`:

``` shell
helm repo add 2gis-on-premise https://2gis.github.io/on-premise-helm-charts
helm install testing 2gis-on-premise/proxy-traffic-jams --atomic --timeout=60m -f ./values.yaml
```

## Upgrading

To upgrade the chart:

```shell
helm upgrade testing 2gis-on-premise/proxy-traffic-jams --atomic --timeout=60m -f ./values.yaml
```
