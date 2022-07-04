# 2GIS Restrictions Backend (Helm chart)

This repository contains a [Helm chart](https://helm.sh/docs/topics/charts/)
for deploying Restrictions Backend - part of 2GIS On-Premise services,
which allows one to deploy [2GIS products](https://dev.2gis.com/)
on one's own sites.

For more information on Restrictions Backend refer to the
[service documentation](https://confluence.2gis.ru/display/TRAFFIC/Restrictions+Service). (TODO: link to docs.2gis.com needed)

To learn more about 2GIS On-Premise services, visit
[docs.2gis.com](https://docs.2gis.com/en/on-premise/overview).

## Installing

Before installation, make sure that you have:

* PostgreSQL DB instance (with `plpgsql` enabled)
* [Attractor service](https://confluence.2gis.ru/display/TRAFFIC/Attractor+Service). (TODO: link to docs.2gis.com needed)
* Navi backend
* Castle service

To install Restrictions Backend, create a `values.yaml` file with
the following content:

* Registry URL of the service's Docker image
* PostgreSQL DB access parameters
* navi-back Attractor URL
* navi-back Edge URL
* Castle Restrictions URL
* API Key (any value kept in secret and matching on API, Syncer and Castle)

```yaml
# Docker image
dgctlDockerRegistry: 'your-docker-hub-registry'

# PostgreSQL access
db:
  host: example.com
  port: 5432
  name: restrictions
  username: postgres
  password: secret

api:
  # Attractor API
  attractor_url: 'http://navi-back/attract/1.0.0/global/'

cron:
  edges_url_template: 'http://castle-service/restrictions_json/{project}/{date_str}_{hour}.json'
  edge_attributes_url_template: 'http://navi-back/develop/edge?edge_id={edge_id}&offset=200&routing=carrouting'

# API Keys service
api_key: secret
```

Then, call the `helm install` command and specify the name of the created file:

```shell
helm repo add 2gis-on-premise https://2gis.github.io/on-premise-helm-charts
helm install navi-restrictions 2gis-on-premise/navi-restrictions -f values.yaml
```

## Updating

To update the service after changing the settings or after updating
the Docker image, call `helm upgrade` command:

```bash
helm upgrade navi-restrictions 2gis-on-premise/navi-restrictions -f values.yaml
```
