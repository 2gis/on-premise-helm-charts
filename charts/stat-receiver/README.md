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

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |
| `imagePullSecrets`    | Kubernetes image pull secrets.                                                          | `[]`  |

### API service settings

| Name                            | Description                                                                                                                                    | Value                               |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `api`                           | **Common settings**                                                                                                                            |                                     |
| `api.replicas`                  | A replica count for the pod.                                                                                                                   | `1`                                 |
| `api.revisionHistoryLimit`      | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`                                 |
| `api.jvmXmx`                    | Memory allocation options for JVM.                                                                                                             | `-Xmx1500m`                         |
| `api.image`                     | **Deployment settings**                                                                                                                        |                                     |
| `api.image.repository`          | Repository                                                                                                                                     | `2gis-on-premise/stat-receiver-api` |
| `api.image.tag`                 | Tag                                                                                                                                            | `1.15.21`                           |
| `api.image.pullPolicy`          | Pull Policy                                                                                                                                    | `IfNotPresent`                      |
| `api.service`                   | **Service settings**                                                                                                                           |                                     |
| `api.service.type`              | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                 | `ClusterIP`                         |
| `api.service.port`              | Service port.                                                                                                                                  | `80`                                |
| `api.service.targetPort`        | Port inside the container.                                                                                                                     | `8080`                              |
| `api.resources`                 | **Limits for the API service**                                                                                                                 |                                     |
| `api.resources.requests.cpu`    | A CPU request.                                                                                                                                 | `500m`                              |
| `api.resources.requests.memory` | A memory request.                                                                                                                              | `1500Mi`                            |
| `api.resources.limits.cpu`      | A CPU limit.                                                                                                                                   | `1`                                 |
| `api.resources.limits.memory`   | A memory limit.                                                                                                                                | `1500Mi`                            |

### Streams service settings

| Name                                | Description                                                                                                                                    | Value                                   |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| `streams`                           | **Common settings**                                                                                                                            |                                         |
| `streams.replicas`                  | A replica count for the pod.                                                                                                                   | `1`                                     |
| `streams.revisionHistoryLimit`      | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`                                     |
| `streams.jvmXmx`                    | Memory allocation options for JVM.                                                                                                             | `-Xmx2G -XX:+UseParallelGC`             |
| `streams.jmxPort`                   | Port for JMX protocol.                                                                                                                         | `9010`                                  |
| `streams.metricsPort`               | Port for metrics.                                                                                                                              | `8081`                                  |
| `streams.storageSize`               | Size of ephemeral disk that holds temporary files                                                                                              | `500Mi`                                 |
| `streams.image`                     | **Deployment settings**                                                                                                                        |                                         |
| `streams.image.repository`          | Repository                                                                                                                                     | `2gis-on-premise/stat-receiver-streams` |
| `streams.image.tag`                 | Tag                                                                                                                                            | `1.15.21`                               |
| `streams.image.pullPolicy`          | Pull Policy                                                                                                                                    | `IfNotPresent`                          |
| `streams.resources`                 | **Limits for the Streams service**                                                                                                             |                                         |
| `streams.resources.requests.cpu`    | A CPU request.                                                                                                                                 | `1`                                     |
| `streams.resources.requests.memory` | A memory request.                                                                                                                              | `4Gi`                                   |
| `streams.resources.limits.cpu`      | A CPU limit.                                                                                                                                   | `2`                                     |
| `streams.resources.limits.memory`   | A memory limit.                                                                                                                                | `4Gi`                                   |

### Kafka service settings

| Name                                      | Description                                                                                                      | Value                                                     |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| `kafka.servers`                           | Kafka bootstrap connection string                                                                                | `""`                                                      |
| `kafka.securityProtocol`                  | Protocol used to communicate with brokers. Valid values are: `PLAINTEXT`, `SSL`, `SASL_PLAINTEXT`, `SASL_SSL`    | `PLAINTEXT`                                               |
| `kafka.truststore`                        | **Trust store configuration for SSL connections**                                                                |                                                           |
| `kafka.truststore.enabled`                |                                                                                                                  | `false`                                                   |
| `kafka.truststore.secretName`             | Kubernetes secret that holds trust store data                                                                    | `""`                                                      |
| `kafka.truststore.storeFieldName`         | Name of the secret's key that holds trust store file                                                             | `ca.p12`                                                  |
| `kafka.truststore.storePasswordFieldName` | Name of the secret's key that holds password to the trust store file                                             | `ca.password`                                             |
| `kafka.truststore.createSecret`           | Enable to manage trust store secret with helm                                                                    | `false`                                                   |
| `kafka.truststore.storeData`              | base64-encoded PKCS12 or JKS trust store file                                                                    | `""`                                                      |
| `kafka.truststore.storePassword`          | Password to trust store file                                                                                     | `""`                                                      |
| `kafka.keystore`                          | **Configuration for SSL authentication**                                                                         |                                                           |
| `kafka.keystore.enabled`                  |                                                                                                                  | `false`                                                   |
| `kafka.keystore.secretName`               | Kubernetes secret that holds key store data                                                                      | `""`                                                      |
| `kafka.keystore.storeFieldName`           | Name of the secret's key that holds key store file                                                               | `user.p12`                                                |
| `kafka.keystore.storePasswordFieldName`   | Name of the secret's key that holds password to the key store file                                               | `user.password`                                           |
| `kafka.keystore.createSecret`             | Enable to manage key store secret with helm                                                                      | `false`                                                   |
| `kafka.keystore.storeData`                | base64-encoded PKCS12 or JKS key store file                                                                      | `""`                                                      |
| `kafka.keystore.storePassword`            | Password to key store file                                                                                       | `""`                                                      |
| `kafka.sasl`                              | **Configuration for sasl authenthication**                                                                       |                                                           |
| `kafka.sasl.enabled`                      |                                                                                                                  | `true`                                                    |
| `kafka.sasl.secretName`                   | Existing Kubernetes secret that holds password data. If enmpty, a new secret will be created                     | `""`                                                      |
| `kafka.sasl.jaasFieldName`                | Name of the secret's key that holds JAAS configuration                                                           | `sasl.jaas.config`                                        |
| `kafka.sasl.jaasLoginModule`              | JAAS login module                                                                                                | `org.apache.kafka.common.security.scram.ScramLoginModule` |
| `kafka.sasl.username`                     | Username for kafka connection. Required when kafka.sasl.secretName is empty string                               | `""`                                                      |
| `kafka.sasl.password`                     | Password for kafka connection. Required when kafka.sasl.secretName is empty string                               | `""`                                                      |
| `kafka.sasl.mechanism`                    | SASL mechanism used for client connections. This may be any mechanism for which a security provider is available | `PLAIN`                                                   |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                       |
| ------------------------------------ | ----------------------------------------- | --------------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                     |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`                     |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `stat-receiver.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                         |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                    |
| `ingress.tls`                        | TLS configuration                         | `[]`                        |

### stat-receiver parameters

| Name                       | Description                                                 | Value   |
| -------------------------- | ----------------------------------------------------------- | ------- |
| `initializeTopics.enabled` | If true, topics will be created automatically.              | `false` |
| `topicsPrefix`             | Prefix for topics.                                          | `""`    |
| `logLevel`                 | Log level: `TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR`, `OFF` | `INFO`  |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
