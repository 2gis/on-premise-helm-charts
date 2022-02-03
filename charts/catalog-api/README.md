# 2GIS Catalog API (Helm chart)

This repository contains a [Helm chart](https://helm.sh/docs/topics/charts/) for deploying the Catalog API service. This service is part of 2GIS On-Premise services, which allow you to deploy [2GIS products](https://dev.2gis.com/) on your own sites.

For more information on Catalog API, see the [service documentation](https://docs.2gis.com/en/on-premise/search).

To learn more about 2GIS On-Premise services, visit [docs.2gis.com](https://docs.2gis.com/en/on-premise/overview).

## Installing

Before installing Catalog API, make sure that you have a running PostgreSQL instance and a running [Sapphire API](https://docs.2gis.com/en/on-premise/search) service.

To install the service, clone this repository and create a YAML file that will contain:

- Registry URL of the service's Docker image
- PostgreSQL access parameters
- Sapphire API URL

```yaml
# Docker image
api:
  image: your-docker-hub/2gis/catalog-api
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
```

Then, call the `helm install` command and specify the name of the created file:

```bash
helm install catalog . -f settings.yaml
```

## Updating

To update the service after changing the settings or after updating the Docker image, call the `helm upgrade` command:

```bash
helm upgrade catalog . -f settings.yaml
```
