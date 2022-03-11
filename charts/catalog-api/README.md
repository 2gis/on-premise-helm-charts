# 2GIS Catalog API (Helm chart)

This repository contains a [Helm chart](https://helm.sh/docs/topics/charts/) for deploying the Catalog API service. This service is part of 2GIS On-Premise services, which allow you to deploy [2GIS products](https://dev.2gis.com/) on your own sites.

For more information on Catalog API, see the [service documentation](https://docs.2gis.com/en/on-premise/search).

To learn more about 2GIS On-Premise services, visit [docs.2gis.com](https://docs.2gis.com/en/on-premise/overview).

## Installing

Before installing Catalog API, make sure that you have a running PostgreSQL instance and a running [Search API](https://docs.2gis.com/en/on-premise/search) service.

To install the service create a YAML file that will contain:

- Registry URL of the service's Docker image
- PostgreSQL access parameters
- Search API URL
- API Keys service credentials

```yaml
# Docker image
api:
  image:
    repository: your-docker-hub/2gis/catalog-api
    tag: 1.0.0

# PostgreSQL access
db:
  host: localhost
  port: 5432
  name: catalog
  username: postgres
  password: secret

# Sapphire API
search:
  url: http://localhost:80

# API Keys service
keys:
  endpoint: https://keys-api.host
  serviceKeys:
    places: ""  # set if available in API Keys service
    geocoder: ""  # set if available in API Keys service
    suggest: ""  # set if available in API Keys service
    categories: ""  # set if available in API Keys service
    regions: ""  # set if available in API Keys service
```

Then, call the `helm install` command and specify the name of the created file:

```shell
helm repo add 2gis-on-premise https://2gis.github.io/on-premise-helm-charts
helm install catalog 2gis-on-premise/catalog-api -f values.yaml
```

## Updating

To update the service after changing the settings or after updating the Docker image, call the `helm upgrade` command:

```bash
helm upgrade catalog 2gis-on-premise/catalog-api -f values.yaml
```
