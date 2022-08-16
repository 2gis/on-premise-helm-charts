# 2GIS Stat Receiver service

Use this Helm chart to deploy the Stat Receiver service, which is a part of 2GIS's [On-Premise solution](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

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
topicsPrefix: stat.env.
```

App may initialize required topics on startup (`initilizeTopics` setting) however in cases when topics settings are explicitly managed you may initialize it manually using provided settings (see `topics-config.md`).

Then, call the `helm install` command and specify the name of the created file:

```shell
helm repo add 2gis-on-premise https://2gis.github.io/on-premise-helm-charts
helm install stat-receiver 2gis-on-premise/stat-receiver -f values-stat-receiver.yaml
```

## Updating

To update the service after changing the settings or after updating the Docker image, call the `helm upgrade` command:

```bash
helm upgrade stat-receiver 2gis-on-premise/stat-receiver -f values-stat-receiver.yaml
```


## Values

### API service settings

| Name                     | Description                                                                                                                    | Value                              |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------- |
| `api`                    | **Common settings**                                                                                                            |                                    |
| `api.replicas`           | A replica count for the pod.                                                                                                   | `1`                                |
| `api.jvmXmx`             | Memory allocation options for JVM.                                                                                             | `-Xmx1500m`                        |
| `api.image`              | **Deployment settings**                                                                                                        |                                    |
| `api.image.repository`   | Repository                                                                                                                     | `2gis-on-premise/bss-receiver-api` |
| `api.image.tag`          | Tag                                                                                                                            | `1.1.4`                            |
| `api.image.pullPolicy`   | Pull Policy                                                                                                                    | `IfNotPresent`                     |
| `api.service`            | **Service settings**                                                                                                           |                                    |
| `api.service.type`       | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP`                        |
| `api.service.port`       | Port inside the container.                                                                                                     | `80`                               |
| `api.service.targetPort` | External port.                                                                                                                 | `8080`                             |


### Streams service settings

| Name                       | Description                        | Value                                  |
| -------------------------- | ---------------------------------- | -------------------------------------- |
| `streams`                  | **Common settings**                |                                        |
| `streams.replicas`         | A replica count for the pod.       | `1`                                    |
| `streams.jvmXmx`           | Memory allocation options for JVM. | `-Xmx2G -XX:+UseParallelGC`            |
| `streams.jmxPort`          | Port for JMX protocol.             | `9010`                                 |
| `streams.metricsPort`      | Port for metrics.                  | `8080`                                 |
| `streams.image`            | **Deployment settings**            |                                        |
| `streams.image.repository` | Repository                         | `2gis-on-premise/bss-receiver-streams` |
| `streams.image.tag`        | Tag                                | `1.1.4`                                |
| `streams.image.pullPolicy` | Pull Policy                        | `IfNotPresent`                         |


### Kafka service settings

| Name              | Description                                                                                                                                                                                          | Value |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `kafka.security`  | SASL configuration for Kafka clients (see [the documentation](https://kafka.apache.org/documentation/#security_sasl_config)).                                                                        | `{}`  |
| `kafka.sasl.jaas` | JAAS login context parameters for SASL connections in the format used by JAAS configuration files (see [the documentation](https://kafka.apache.org/documentation/#brokerconfigs_sasl.jaas.config)). | `{}`  |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name      | Description                                                                                                                                    | Value |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `ingress` | Configuration of the Ingress resource. Adapt it to your Ingress installation. <br/> Defaults to `{'hosts': [{'host': 'stat-receiver.host'}]}`. |       |


### Limits

| Name                                | Description                        | Value    |
| ----------------------------------- | ---------------------------------- | -------- |
| `api.resources`                     | **Limits for the API service**     |          |
| `api.resources.requests.cpu`        | A CPU request.                     | `0.5`    |
| `api.resources.requests.memory`     | A memory request.                  | `1500Mi` |
| `api.resources.limits.cpu`          | A CPU limit.                       | `1`      |
| `api.resources.limits.memory`       | A memory limit.                    | `1500Mi` |
| `streams.resources`                 | **Limits for the Streams service** |          |
| `streams.resources.requests.cpu`    | A CPU request.                     | `1`      |
| `streams.resources.requests.memory` | A memory request.                  | `4G`     |
| `streams.resources.limits.cpu`      | A CPU limit.                       | `2`      |
| `streams.resources.limits.memory`   | A memory limit.                    | `4G`     |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
