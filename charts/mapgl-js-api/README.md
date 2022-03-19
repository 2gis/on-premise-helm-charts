# 2GIS MapGL JS API (Helm chart)

This repository contains a [Helm chart](https://helm.sh/docs/topics/charts/) for deploying the MapGL JS API service. This service is part of 2GIS On-Premise services, which allow you to deploy [2GIS products](https://dev.2gis.com/) on your own sites.

For more information on MapGL JS API, see the [service documentation](https://docs.2gis.com/en/on-premise/map).

To learn more about 2GIS On-Premise services, visit [docs.2gis.com](https://docs.2gis.com/en/on-premise/overview).

## Installing the Chart

To install the chart, create a YAML file with the registry URL of the service's Docker image.

```yaml
dgctl_docker_registry: 'your-docker-hub-registry'
```

Then, add 2gis helm repository and call the `helm install` command and specify the name of the chart and the created file:

```bash
helm repo add 2gis-on-premise https://2gis.github.io/on-premise-helm-charts
helm install mapgl 2gis-on-premise/mapgl-js-api -f values.yaml
```

## Upgrading

To upgrade the chart after changing the values or after updating the Docker image, call the `helm upgrade` command:

```bash
helm upgrade mapgl 2gis-on-premise/mapgl-js-api -f values.yaml
```

## Testing the deployment

After deployment completes, service will be available at http(s)://MAPGL_HOST address. You can see there working map if MapGL JS API and Tiles API services were set up correctly. 