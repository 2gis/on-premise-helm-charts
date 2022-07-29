# 2GIS BSS Receiver (Helm chart)

This repository contains a [Helm chart](https://helm.sh/docs/topics/charts/) for deploying the BSS Receiver service. This service is part of 2GIS On-Premise services, which allow you to deploy [2GIS products](https://dev.2gis.com/) on your own sites.

## Installing

To install the service create a YAML file that will contain:

- Registry URL of the service's Docker image
- Kafka access parameters
- Kafka topics settings

```yaml

# Docker image
dgctlDockerRegistry: 'your-docker-hub-registry'

# Kafka access parameters
kafka:
  servers: "bootstrap_servers"

# Kafka topics settings
initializeTopics: true
topicsPrefix: bss.env.
```

App may initialize required topics on startup (`initilizeTopics` setting) however in cases when topics settings are explicitly managed you may initialize it manually using provided settings (see `topics-config.md`).

Then, call the `helm install` command and specify the name of the created file:

```shell
helm repo add 2gis-on-premise https://2gis.github.io/on-premise-helm-charts
helm install stat-receiver 2gis-on-premise/stat-receiver -f values.yaml
```

## Updating

To update the service after changing the settings or after updating the Docker image, call the `helm upgrade` command:

```bash
helm upgrade stat-receiver 2gis-on-premise/stat-receiver -f values.yaml
```
