# 2GIS MapGL JS API (Helm chart)

This repository contains a [Helm chart](https://helm.sh/docs/topics/charts/) for deploying the MapGL JS API service. This service is part of 2GIS On-Premise services, which allow you to deploy [2GIS products](https://dev.2gis.com/) on your own sites.

For more information on MapGL JS API, see the [service documentation](https://docs.2gis.com/en/on-premise/map).

To learn more about 2GIS On-Premise services, visit [docs.2gis.com](https://docs.2gis.com/en/on-premise/overview).

## Installing

To install the service, clone this repository and create a YAML file with the registry URL of the service's Docker image.

```yaml
image:
  repository: your-docker-hub/2gis/mapgl-js-api
  tag: 1.0.0
```

Then, call the `helm install` command and specify the name of the created file:

```bash
helm install mapgl . -f settings.yaml
```

## Updating

To update the service after changing the settings or after updating the Docker image, call the `helm upgrade` command:

```bash
helm upgrade mapgl . -f settings.yaml
```

## Testing the deployment

To test that the service is working, you can create the following HTML file and open it in a browser. Replace the `mapgl.service.published.host` string with the URL of the published MapGL JS API service.

```html
<html>
    <head>
        <title>MapGL JS API. On-Premise</title>
        <style>
            #map {
                width: 100%;
                height: 100%;
            }
        </style>
    </head>

    <body>
        <div id="map"></div>
        <script src="http://mapgl.service.published.host/api.js"></script>
        <script>
            const map = new mapgl.Map('map', {
                key: 'your key',
                center: [55.31878, 25.23584],
                style: 'http://mapgl.service.published.host/style/',
                styleOptions: {
                    iconsPath: 'http://mapgl.service.published.host/style/images/',
                    fontsPath: 'http://mapgl.service.published.host/style/fonts/',
                },
                zoom: 13,
            });
        </script>
    </body>
</html>
```
