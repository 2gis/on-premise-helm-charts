# Helm chart for MapGL service

To install this chart clone repo to any local folder and type:

```
helm install mapgl .
```

Optionally you can provide additional file with overrides, to customize chart:

```
helm install mapgl . -f /path/to/overrides.yaml
```

# Check

You can check service operation with this simple map example. 

```html
<html>
    <head>
        <title>MapGL Selfhosting</title>
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
        const map = window.map = new mapgl.Map('map', {
            key: 'your key',
            center: [55.31878, 25.23584],
                     
            style: 'http://mapgl.service.published.host/style/',
            zoom: 13,
        });
    </script>
</body>
</html>
```
