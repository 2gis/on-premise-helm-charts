# Stat API Helm Chart

Use this Helm chart to deploy API Stat service, which is a part of 2GIS's [On-Premise solution](https://docs.2gis.com/en/on-premise/overview).

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                       | Description                    | Value                              |
| -------------------------- | ------------------------------ | ---------------------------------- |
| `imagePullSecrets`         | Kubernetes image pull secrets. | `[]`                               |
| `imagePullPolicy`          | Pull policy.                   | `IfNotPresent`                     |
| `api.image.repository`     | API service image repository.  | `2gis-on-premise/stat-api`         |
| `api.image.tag`            | API service image tag.         | `0.2.5`                            |
| `migrate.image.repository` | Migrate tool image repository. | `2gis-on-premise/stat-api-migrate` |
| `migrate.image.tag`        | Migrate tool image tag.        | `0.2.5`                            |

### Security settings

| Name                                       | Description                                                                                                                                                 | Value            |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `podSecurityContext.enabled`               | If the pod security context is enabled.                                                                                                                     | `false`          |
| `podSecurityContext.runAsNonRoot`          | If the containers of the chart are not allowed to run as the root user.                                                                                     | `true`           |
| `podSecurityContext.runAsUser`             | UID of a non-privileged user that exists in the images.                                                                                                     | `10001`          |
| `podSecurityContext.runAsGroup`            | GID of a non-privileged group that exists in the images.                                                                                                    | `10001`          |
| `podSecurityContext.fsGroup`               | GID applied to the mounted volumes.                                                                                                                         | `10001`          |
| `securityContext.enabled`                  | If the container security context is enabled.                                                                                                               | `false`          |
| `securityContext.privileged`               | If the containers are run in the privileged mode.                                                                                                           | `false`          |
| `securityContext.allowPrivilegeEscalation` | If a process of a container can gain more privileges than its parent process.                                                                               | `false`          |
| `securityContext.readOnlyRootFilesystem`   | If the root filesystem of the containers is read-only. See `writablePaths` for the directories the services still need to write to.                         | `true`           |
| `securityContext.runAsNonRoot`             | If the containers are not allowed to run as the root user.                                                                                                  | `true`           |
| `securityContext.runAsUser`                | UID of a non-privileged user that exists in the images.                                                                                                     | `10001`          |
| `securityContext.runAsGroup`               | GID of a non-privileged group that exists in the images.                                                                                                    | `10001`          |
| `securityContext.capabilities.drop`        | Linux capabilities to drop. All the capabilities are dropped by default.                                                                                    | `["ALL"]`        |
| `securityContext.seccompProfile.type`      | Type of the [seccomp](https://kubernetes.io/docs/tutorials/security/seccomp/) profile. Can be `RuntimeDefault`, `Localhost` or `Unconfined`.                | `RuntimeDefault` |
| `automountServiceAccountToken`             | If the ServiceAccount API token is mounted into the pods of the chart. The service does not use the Kubernetes API, so the token is not mounted by default. | `false`          |
| `enableServiceLinks`                       | If the information about the services of the namespace is injected into the pods as environment variables.                                                  | `false`          |
| `writablePaths`                            | Paths mounted as `emptyDir` volumes when `securityContext.readOnlyRootFilesystem` is enabled. Can be overridden per service, e.g. by `api.writablePaths`.   | `["/tmp"]`       |
| `volumeDefaultMode`                        | Permissions of the files mounted from the Secret and ConfigMap volumes. `256` is the decimal representation of `0400`.                                      | `256`            |

### Kubernetes [Service Account](https://kubernetes.io/docs/concepts/security/service-accounts/) settings

| Name                         | Description                                                                                                            | Value   |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created                                                                  | `false` |
| `serviceAccount.automount`   | Automatically mount a ServiceAccount's API credentials?                                                                | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account                                                                              | `{}`    |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template | `""`    |

### API service settings

| Name                                        | Description                                                                                                                                                                                              | Value           |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `api.logLevel`                              | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.                                                                                                                | `warning`       |
| `api.clickhouse.clientName`                 | Name that will be used in client requests to ClickHouse.                                                                                                                                                 | `stat-api`      |
| `api.replicas`                              | A replica count for the pod.                                                                                                                                                                             | `1`             |
| `api.revisionHistoryLimit`                  | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                                                           | `3`             |
| `api.strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `api.strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `api.strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |
| `api.annotations`                           | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                | `{}`            |
| `api.labels`                                | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                          | `{}`            |
| `api.podAnnotations`                        | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                            | `{}`            |
| `api.podLabels`                             | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                      | `{}`            |
| `api.podSecurityContext`                    | Pod-level [security settings](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) of the API service. Merged over the chart-wide `podSecurityContext`.                           | `{}`            |
| `api.securityContext`                       | Container-level [security settings](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) of the API service. Merged over the chart-wide `securityContext`.                        | `{}`            |
| `api.writablePaths`                         | Paths mounted as `emptyDir` volumes for the API service. Overrides the chart-wide `writablePaths`.                                                                                                       | `[]`            |
| `api.nodeSelector`                          | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                      | `{}`            |
| `api.affinity`                              | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                                                              | `{}`            |
| `api.tolerations`                           | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                                        | `[]`            |
| `api.service.annotations`                   | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                        | `{}`            |
| `api.service.labels`                        | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                  | `{}`            |
| `api.service.type`                          | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                                                                           | `ClusterIP`     |
| `api.service.port`                          | Service port.                                                                                                                                                                                            | `80`            |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                     | Description                                                                                                                                                | Value           |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `api.ingress.enabled`                    | If Ingress is enabled for the service.                                                                                                                     | `false`         |
| `api.ingress.className`                  | Name of the Ingress controller class.                                                                                                                      | `nginx`         |
| `api.ingress.annotations`                | Kubernetes [ingress annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                          | `{}`            |
| `api.ingress.sslPassthrough`             | If the TLS traffic is passed to the service without being decrypted by the Ingress controller. Only the passthrough mode is allowed for the TLS hostnames. | `true`          |
| `api.ingress.hosts[0].host`              | Hostname for the Ingress service. Wildcard hostnames are not allowed.                                                                                      | `stat-api.host` |
| `api.ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service.                                                                                                                  | `/`             |
| `api.ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service.                                                                                                                  | `Prefix`        |
| `api.ingress.tls`                        | TLS configuration. Generated from the hostnames above when `certManager.enabled` is set.                                                                   | `[]`            |

### Kubernetes [HTTPRoute](https://gateway-api.sigs.k8s.io/api-types/httproute/) settings

| Name                        | Description                                                                                                                                                                           | Value   |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `api.httpRoute.enabled`     | If HTTPRoute is enabled for the service.                                                                                                                                              | `false` |
| `api.httpRoute.hostnames`   | Array of [Hostnames](https://gateway-api.sigs.k8s.io/reference/spec/#hostname) for the HTTPRoute [spec](https://gateway-api.sigs.k8s.io/reference/spec/#httproutespec).               | `[]`    |
| `api.httpRoute.parentRefs`  | Array of [ParentReferences](https://gateway-api.sigs.k8s.io/reference/spec/#parentreference) for the HTTPRoute [spec](https://gateway-api.sigs.k8s.io/reference/spec/#httproutespec). | `[]`    |
| `api.httpRoute.annotations` | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) of the HTTPRoute.                                                            | `{}`    |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                          | Description                                                                                                                                                          | Value   |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `api.hpa.enabled`                             | If HPA is enabled for the service.                                                                                                                                   | `false` |
| `api.hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`     |
| `api.hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `2`     |
| `api.hpa.scaleDownStabilizationWindowSeconds` | Scale-down window.                                                                                                                                                   | `""`    |
| `api.hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window.                                                                                                                                                     | `""`    |
| `api.hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`    |
| `api.hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`    |

### Migrate tool settings

| Name                               | Description                                                                                                                                                                        | Value              |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------ |
| `migrate.logLevel`                 | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.                                                                                          | `info`             |
| `migrate.kafkaTableEngine.brokers` | Kafka brokers address list, separated by comma. ***Required value***.                                                                                                              | `""`               |
| `migrate.kafkaTableEngine.topic`   | Kafka topic with data from stat-receiver (e.g. -- `type.401``). ***Required value***.                                                                                              | `""`               |
| `migrate.kafkaTableEngine.group`   | Consumer group name. ***Required value***.                                                                                                                                         | `""`               |
| `migrate.clickhouse.clientName`    | Name that will be used in client requests to ClickHouse.                                                                                                                           | `stat-api-migrate` |
| `migrate.initialDelaySeconds`      | Delay in seconds at the service startup.                                                                                                                                           | `0`                |
| `migrate.nodeSelector`             | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                | `{}`               |
| `migrate.tolerations`              | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                  | `[]`               |
| `migrate.podAnnotations`           | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                      | `{}`               |
| `migrate.podSecurityContext`       | Pod-level [security settings](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) of the Migrate tool. Merged over the chart-wide `podSecurityContext`.    | `{}`               |
| `migrate.securityContext`          | Container-level [security settings](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) of the Migrate tool. Merged over the chart-wide `securityContext`. | `{}`               |
| `migrate.writablePaths`            | Paths mounted as `emptyDir` volumes for the Migrate tool. Overrides the chart-wide `writablePaths`.                                                                                | `[]`               |

### ClickHouse settings

| Name                                | Description                                                                                                                                                          | Value      |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| `clickhouse.servers`                | Comma-separated list of ClickHouse server addresses. Format: `host1:port1,host2:port2`.                                                                              | `""`       |
| `clickhouse.cluster`                | ClickHouse cluster name for distributed queries, migrations.                                                                                                         | `""`       |
| `clickhouse.database`               | ClickHouse database name to connect to.                                                                                                                              | `""`       |
| `clickhouse.username`               | ClickHouse username for authentication.                                                                                                                              | `""`       |
| `clickhouse.password`               | ClickHouse password for authentication.                                                                                                                              | `""`       |
| `clickhouse.maxQueryExecutionTime`  | Query [maximum execution time](https://clickhouse.com/docs/operations/settings/settings#max_execution_time) in seconds.                                              | `60`       |
| `clickhouse.maxOpenConnections`     | Maximum number of open connections to ClickHouse.                                                                                                                    | `10`       |
| `clickhouse.maxIdleConnections`     | Maximum number of idle connections in the pool.                                                                                                                      | `5`        |
| `clickhouse.connectionTimeout`      | Connection timeout duration (e.g., `10s`, `1m`).                                                                                                                     | `10s`      |
| `clickhouse.connectionMaxLifetime`  | Maximum lifetime of a connection (e.g., `1h`, `30m`).                                                                                                                | `1h`       |
| `clickhouse.connectionOpenStrategy` | Connection opening strategy configures algorithm with which it will be decided that server to use for a new connection. Can be: `in_order`, `round_robin`, `random`. | `in_order` |
| `clickhouse.connectionTimeout`      | Connection timeout duration (e.g., `10s`, `1m`).                                                                                                                     | `10s`      |
| `clickhouse.connectionMaxLifetime`  | Maximum lifetime of a connection (e.g., `1h`, `30m`).                                                                                                                | `1h`       |
| `clickhouse.connectionOpenStrategy` | Connection opening strategy for multiple servers. Can be: `in_order`, `round_robin`, `random`.                                                                       | `in_order` |
| `clickhouse.pingMaxRetries`         | Maximum number of ping retries during connection attempts.                                                                                                           | `5`        |
| `clickhouse.pingRetryDelay`         | Delay between ping retries (e.g., `3s`, `5s`).                                                                                                                       | `3s`       |

### ClickHouse TLS settings

| Name                                         | Description                                                                                                                            | Value   |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `clickhouse.tls.enabled`                     | Enable TLS/SSL connection to ClickHouse.                                                                                               | `false` |
| `clickhouse.tls.skipServerCertificateVerify` | Skip server certificate verification (insecure). When `true`, the client will not verify the server's certificate chain and host name. | `false` |
| `clickhouse.tls.serverCA`                    | ClickHouse server CA certificate in PEM format. If not provided, system root CAs will be used for server certificate verification.     | `""`    |
| `clickhouse.tls.clientCert`                  | ClickHouse client certificate in PEM format for mutual TLS authentication. **Required for mutual TLS**.                                | `""`    |
| `clickhouse.tls.clientKey`                   | ClickHouse client private key in PEM format for mutual TLS authentication. **Required for mutual TLS**.                                | `""`    |

### Limits

| Name                                | Description                     | Value   |
| ----------------------------------- | ------------------------------- | ------- |
| `api.resources`                     | **Limits for the API service**  |         |
| `api.resources.requests.cpu`        | A CPU request.                  | `50m`   |
| `api.resources.requests.memory`     | A memory request.               | `128Mi` |
| `api.resources.limits.cpu`          | A CPU limit.                    | `1`     |
| `api.resources.limits.memory`       | A memory limit.                 | `256Mi` |
| `migrate.resources`                 | **Limits for the Migrate tool** |         |
| `migrate.resources.requests.cpu`    | A CPU request.                  | `10m`   |
| `migrate.resources.requests.memory` | A memory request.               | `32Mi`  |
| `migrate.resources.limits.cpu`      | A CPU limit.                    | `100m`  |
| `migrate.resources.limits.memory`   | A memory limit.                 | `64Mi`  |

### customCAs **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container.                                                                          | `""`  |

### [cert-manager](https://cert-manager.io/docs/) settings

| Name                               | Description                                                                                                                                    | Value              |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------------ |
| `certManager.enabled`              | If cert-manager Certificate resources are created for the Ingress hostnames. Wildcard hostnames are not allowed.                               | `false`            |
| `certManager.issuer.name`          | Name of the issuer that signs the certificates.                                                                                                | `letsencrypt-prod` |
| `certManager.issuer.kind`          | Kind of the issuer. Can be `ClusterIssuer` or `Issuer`.                                                                                        | `ClusterIssuer`    |
| `certManager.issuer.group`         | API group of the issuer.                                                                                                                       | `cert-manager.io`  |
| `certManager.duration`             | Validity period of the certificates.                                                                                                           | `2160h`            |
| `certManager.renewBefore`          | Period before the expiration when the certificates are renewed.                                                                                | `360h`             |
| `certManager.privateKey.algorithm` | Private key algorithm. Can be `RSA`, `ECDSA` or `Ed25519`.                                                                                     | `RSA`              |
| `certManager.privateKey.size`      | Private key size.                                                                                                                              | `2048`             |
| `certManager.annotations`          | Annotations of the Certificate resources, ex: the `helm.sh/hook` settings that issue the certificates before the other resources are deployed. | `{}`               |

### Service Mesh settings

| Name                                                | Description                                                                                                                                                                      | Value                  |
| --------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `serviceMesh`                                       | **[Istio](https://istio.io/latest/docs/) settings that implement the zero trust security model: mTLS between the pods and the edge gateways deployed in the release namespace.** |                        |
| `serviceMesh.enabled`                               | If the Istio resources are created for the services of the chart. Requires Istio to be installed in the cluster.                                                                 | `false`                |
| `serviceMesh.sidecarInject`                         | If the Istio sidecar is injected into the pods. The sidecar is never injected into the Jobs of the chart.                                                                        | `true`                 |
| `serviceMesh.mtls.mode`                             | Mutual TLS mode for the pods of the chart. Can be `STRICT`, `PERMISSIVE` or `DISABLE`.                                                                                           | `STRICT`               |
| `serviceMesh.mtls.minProtocolVersion`               | Minimum TLS version accepted by the gateways. Can be `TLSV1_2` or `TLSV1_3`. The sidecar-to-sidecar minimum version is set by the mesh-wide Istio configuration.                 | `TLSV1_2`              |
| `serviceMesh.ingressGateway.enabled`                | If the ingress Gateway and the VirtualService that routes the incoming traffic to the service are created.                                                                       | `true`                 |
| `serviceMesh.ingressGateway.selector.istio`         | Label of the ingress gateway pods deployed in the release namespace.                                                                                                             | `ingressgateway`       |
| `serviceMesh.ingressGateway.serviceName`            | Name of the ingress gateway Service deployed in the release namespace. The Ingress resource of the chart sends the traffic to this Service.                                      | `istio-ingressgateway` |
| `serviceMesh.ingressGateway.port`                   | Port of the ingress gateway that serves the incoming traffic.                                                                                                                    | `443`                  |
| `serviceMesh.ingressGateway.tls.mode`               | TLS mode of the ingress gateway. `PASSTHROUGH` keeps the traffic encrypted up to the service, which is required by the passthrough-only policy.                                  | `PASSTHROUGH`          |
| `serviceMesh.ingressGateway.tls.credentialName`     | Name of the secret with the gateway certificate. Used by the `SIMPLE` and `MUTUAL` modes only.                                                                                   | `""`                   |
| `serviceMesh.egressGateway.enabled`                 | If the egress Gateway and the VirtualServices that route the outgoing traffic through it are created.                                                                            | `false`                |
| `serviceMesh.egressGateway.selector.istio`          | Label of the egress gateway pods deployed in the release namespace.                                                                                                              | `egressgateway`        |
| `serviceMesh.egressGateway.port`                    | Port of the egress gateway that serves the outgoing traffic.                                                                                                                     | `443`                  |
| `serviceMesh.egressGateway.hosts`                   | External hostnames whose traffic is routed through the egress gateway.                                                                                                           | `[]`                   |
| `serviceMesh.authorizationPolicy.enabled`           | If the AuthorizationPolicy that allows the traffic from the authorized sources only is created.                                                                                  | `true`                 |
| `serviceMesh.authorizationPolicy.allowedNamespaces` | Namespaces allowed to reach the services of the chart. The release namespace is always allowed.                                                                                  | `[]`                   |
| `serviceMesh.authorizationPolicy.allowedPrincipals` | Service account principals allowed to reach the services of the chart, ex: `cluster.local/ns/default/sa/client`.                                                                 | `[]`                   |
| `serviceMesh.jwt.enabled`                           | If the incoming requests are authenticated by the JWT tokens on the gateway.                                                                                                     | `false`                |
| `serviceMesh.jwt.issuer`                            | Issuer of the accepted JWT tokens.                                                                                                                                               | `""`                   |
| `serviceMesh.jwt.jwksUri`                           | URL of the JSON Web Key Set of the issuer.                                                                                                                                       | `""`                   |
| `serviceMesh.jwt.audiences`                         | Audiences of the accepted JWT tokens.                                                                                                                                            | `[]`                   |
| `serviceMesh.jwt.forwardOriginalToken`              | If the original token is forwarded to the service.                                                                                                                               | `true`                 |
| `serviceMesh.externalAuth.enabled`                  | If the requests are authorized by an external authorization provider.                                                                                                            | `false`                |
| `serviceMesh.externalAuth.provider`                 | Name of the `extensionProviders` entry defined in the Istio mesh configuration.                                                                                                  | `""`                   |
| `serviceMesh.externalAuth.rules`                    | Rules that define the requests sent to the external authorization provider. All the requests are sent by default.                                                                | `[]`                   |

### Kubernetes [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) settings

| Name                                      | Description                                                                                                                                                                                           | Value   |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                   | If the NetworkPolicy resources are created. A deny-all policy is applied to the pods of the chart, and the traffic is allowed for the sources listed below only.                                      | `false` |
| `networkPolicy.allowedNamespaces`         | Names of the namespaces allowed to reach the services of the chart. The release namespace is always allowed.                                                                                          | `[]`    |
| `networkPolicy.allowedNamespaceSelectors` | Additional [namespace selectors](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors) of the allowed sources.                                 | `[]`    |
| `networkPolicy.dnsPorts[0]`               | Port used to resolve DNS names. The egress traffic to this port is always allowed.                                                                                                                    | `53`    |
| `networkPolicy.egressRules`               | Additional [egress rules](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors), ex: the rules that allow the traffic to ClickHouse and Kafka. | `[]`    |
| `networkPolicy.ingressRules`              | Additional [ingress rules](https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors).                                                              | `[]`    |
