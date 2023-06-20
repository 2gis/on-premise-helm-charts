<!--- app-name: Keycloak -->

# Keycloak packaged

Keycloak is a high performance Java-based identity and access management solution. It lets developers add an authentication layer to their applications with minimum effort.

[Overview of Keycloak](https://www.keycloak.org/)

See the [documentation](https://docs.2gis.com/en/on-premise/keycloak) to learn about:

- Architecture of the service.

- Installing the service.

- Updating the service.

## Values

### Global parameters

| Name                  | Description                                  | Value |
| --------------------- | -------------------------------------------- | ----- |
| `global.storageClass` | Global StorageClass for Persistent Volume(s) | `""`  |

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common parameters

| Name                     | Description                                                                                                                                                            | Value          |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                                                                                                   | `""`           |
| `nameOverride`           | String to partially override common.names.fullname                                                                                                                     | `""`           |
| `fullnameOverride`       | String to fully override common.names.fullname                                                                                                                         | `""`           |
| `namespaceOverride`      | String to fully override common.names.namespace                                                                                                                        | `""`           |
| `enableServiceLinks`     | If set to false, disable Kubernetes [service links](https://kubernetes.io/docs/tutorials/services/connect-applications-service/#accessing-the-service) in the pod spec | `true`         |
| `dnsPolicy`              | DNS Policy for pod                                                                                                                                                     | `""`           |
| `dnsConfig`              | DNS Configuration pod                                                                                                                                                  | `{}`           |
| `extraDeploy`            | Array of extra objects to deploy with the release                                                                                                                      | `[]`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                                                                                | `false`        |
| `diagnosticMode.command` | Command to override all containers in the the statefulset                                                                                                              | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the the statefulset                                                                                                                 | `["infinity"]` |

### Keycloak parameters

| Name                             | Description                                                                                                                                                                                                           | Value                         |
| -------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| `image.repository`               | Keycloak image repository                                                                                                                                                                                             | `2gis-on-premise/keycloak`    |
| `image.tag`                      | Keycloak image tag (immutable tags are recommended)                                                                                                                                                                   | `21.1.1-debian-11-r4`         |
| `image.pullPolicy`               | Keycloak image pull policy                                                                                                                                                                                            | `IfNotPresent`                |
| `image.pullSecrets`              | Specify docker-registry secret names as an array                                                                                                                                                                      | `[]`                          |
| `image.debug`                    | Specify if debug logs should be enabled                                                                                                                                                                               | `false`                       |
| `auth.adminUser`                 | Keycloak administrator user                                                                                                                                                                                           | `user`                        |
| `auth.adminPassword`             | Keycloak administrator password for the new user                                                                                                                                                                      | `""`                          |
| `auth.existingSecret`            | Existing secret containing Keycloak admin password                                                                                                                                                                    | `""`                          |
| `auth.passwordSecretKey`         | Key where the Keycloak admin password is being stored inside the existing secret.                                                                                                                                     | `""`                          |
| `tls.enabled`                    | Enable [TLS encryption](https://github.com/bitnami/containers/tree/main/bitnami/keycloak#tls-encryption). Required for HTTPs traffic.                                                                                 | `true`                        |
| `tls.autoGenerated`              | Generate automatically self-signed TLS certificates. Currently only supports PEM certificates                                                                                                                         | `true`                        |
| `tls.existingSecret`             | Existing secret containing the TLS certificates per Keycloak replica                                                                                                                                                  | `""`                          |
| `tls.usePem`                     | Use PEM certificates as input instead of PKS12/JKS stores                                                                                                                                                             | `false`                       |
| `tls.truststoreFilename`         | Truststore filename inside the existing secret                                                                                                                                                                        | `keycloak.truststore.jks`     |
| `tls.keystoreFilename`           | Keystore filename inside the existing secret                                                                                                                                                                          | `keycloak.keystore.jks`       |
| `tls.keystorePassword`           | Password to access the keystore when it's password-protected                                                                                                                                                          | `""`                          |
| `tls.truststorePassword`         | Password to access the truststore when it's password-protected                                                                                                                                                        | `""`                          |
| `tls.passwordsSecret`            | Secret containing the Keystore and Truststore passwords.                                                                                                                                                              | `""`                          |
| `spi.existingSecret`             | Existing secret containing the Keycloak [truststore](https://www.keycloak.org/server/keycloak-truststore) for SPI connection over HTTPS/TLS                                                                           | `""`                          |
| `spi.truststorePassword`         | Password to access the truststore when it's password-protected                                                                                                                                                        | `""`                          |
| `spi.truststoreFilename`         | Truststore filename inside the existing secret                                                                                                                                                                        | `keycloak-spi.truststore.jks` |
| `spi.passwordsSecret`            | Secret containing the SPI Truststore passwords.                                                                                                                                                                       | `""`                          |
| `spi.hostnameVerificationPolicy` | Verify the hostname of the server’s certificate. Allowed values: "ANY", "WILDCARD", "STRICT".                                                                                                                         | `""`                          |
| `production`                     | Run Keycloak in production mode. TLS configuration is required except when using proxy=edge.                                                                                                                          | `true`                        |
| `proxy`                          | reverse [Proxy](https://www.keycloak.org/server/reverseproxy) mode edge, reencrypt, passthrough or none                                                                                                               | `passthrough`                 |
| `httpRelativePath`               | Set the [path](https://www.keycloak.org/migration/migrating-to-quarkus#_default_context_path_changed) relative to '/' for serving resources. Useful if you are migrating from older version which were using '/auth/' | `/`                           |
| `configuration`                  | Keycloak Configuration. Auto-generated based on other parameters when not specified                                                                                                                                   | `""`                          |
| `existingConfigmap`              | Name of existing ConfigMap with Keycloak configuration                                                                                                                                                                | `""`                          |
| `extraStartupArgs`               | Extra default startup args                                                                                                                                                                                            | `""`                          |
| `initdbScripts`                  | Dictionary of initdb scripts                                                                                                                                                                                          | `{}`                          |
| `initdbScriptsConfigMap`         | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                                                                                                                   | `""`                          |
| `command`                        | Override default container command (useful when using custom images)                                                                                                                                                  | `[]`                          |
| `args`                           | Override default container args (useful when using custom images)                                                                                                                                                     | `[]`                          |
| `extraEnvVars`                   | Extra environment variables to be set on Keycloak container                                                                                                                                                           | `[]`                          |
| `extraEnvVarsCM`                 | Name of existing ConfigMap containing extra env vars                                                                                                                                                                  | `""`                          |
| `extraEnvVarsSecret`             | Name of existing Secret containing extra env vars                                                                                                                                                                     | `""`                          |

### Keycloak statefulset parameters

| Name                                    | Description                                                                                                                                                            | Value           |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`                          | Number of Keycloak replicas to deploy                                                                                                                                  | `1`             |
| `containerPorts.http`                   | Keycloak HTTP container port                                                                                                                                           | `8080`          |
| `containerPorts.https`                  | Keycloak HTTPS container port                                                                                                                                          | `8443`          |
| `containerPorts.infinispan`             | Keycloak infinispan container port                                                                                                                                     | `7800`          |
| `extraContainerPorts`                   | Optionally specify extra list of additional port-mappings for Keycloak container                                                                                       | `[]`            |
| `podSecurityContext.enabled`            | Enabled Keycloak pods' [Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)               | `true`          |
| `podSecurityContext.fsGroup`            | Set Keycloak pod's Security Context fsGroup                                                                                                                            | `1001`          |
| `containerSecurityContext.enabled`      | Enabled Keycloak containers' [Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)   | `true`          |
| `containerSecurityContext.runAsUser`    | Set Keycloak container's Security Context runAsUser                                                                                                                    | `1001`          |
| `containerSecurityContext.runAsNonRoot` | Set Keycloak container's Security Context runAsNonRoot                                                                                                                 | `true`          |
| `resources.requests.cpu`                | A CPU request.                                                                                                                                                         | `2`             |
| `resources.requests.memory`             | A memory request.                                                                                                                                                      | `2000Mi`        |
| `resources.limits.cpu`                  | A CPU limit.                                                                                                                                                           | `4`             |
| `resources.limits.memory`               | A memory limit.                                                                                                                                                        | `4000Mi`        |
| `livenessProbe.enabled`                 | Enable [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes) on Keycloak containers  | `true`          |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                                                                | `300`           |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                                                                       | `1`             |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                                                                      | `5`             |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                                                                    | `3`             |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                                                                    | `1`             |
| `readinessProbe.enabled`                | Enable [readinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes) on Keycloak containers | `true`          |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                                                               | `30`            |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                                                                      | `10`            |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                                                                     | `1`             |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                                                                   | `3`             |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                                                                   | `1`             |
| `startupProbe.enabled`                  | Enable [startupProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes) on Keycloak containers   | `false`         |
| `startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                                                                 | `30`            |
| `startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                                                                        | `5`             |
| `startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                                                                       | `1`             |
| `startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                                                                     | `60`            |
| `startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                                                                     | `1`             |
| `customLivenessProbe`                   | Custom Liveness probes for Keycloak                                                                                                                                    | `{}`            |
| `customReadinessProbe`                  | Custom Rediness probes Keycloak                                                                                                                                        | `{}`            |
| `customStartupProbe`                    | Custom Startup probes for Keycloak                                                                                                                                     | `{}`            |
| `lifecycleHooks`                        | LifecycleHooks to set additional configuration at startup                                                                                                              | `{}`            |
| `hostAliases`                           | Deployment pod [host aliases](https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/)                                 | `[]`            |
| `podLabels`                             | Extra [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) for Keycloak pods                                                            | `{}`            |
| `podAnnotations`                        | Annotations for Keycloak pods                                                                                                                                          | `{}`            |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                    | `""`            |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                               | `soft`          |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                              | `""`            |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set.                                                                                                                 | `""`            |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                                                                                              | `[]`            |
| `affinity`                              | Affinity for pod assignment                                                                                                                                            | `{}`            |
| `imagePullSecrets`                      | Kubernetes image pull secrets.                                                                                                                                         | `[]`            |
| `nodeSelector`                          | Node labels for pod assignment                                                                                                                                         | `{}`            |
| `tolerations`                           | Tolerations for pod assignment                                                                                                                                         | `[]`            |
| `topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                               | `[]`            |
| `podManagementPolicy`                   | Pod management policy for the Keycloak statefulset                                                                                                                     | `Parallel`      |
| `priorityClassName`                     | Keycloak pods' [Priority Class Name](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/)                                                       | `""`            |
| `schedulerName`                         | Use an alternate [scheduler](https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/), e.g. "stork".                                        | `""`            |
| `terminationGracePeriodSeconds`         | Seconds Keycloak pod needs to [terminate](https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods) gracefully                                      | `""`            |
| `updateStrategy.type`                   | Keycloak statefulset strategy type                                                                                                                                     | `RollingUpdate` |
| `updateStrategy.rollingUpdate`          | Keycloak statefulset [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies) configuration parameters               | `{}`            |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for Keycloak pods                                                                                                  | `[]`            |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for Keycloak container(s)                                                                                     | `[]`            |
| `initContainers`                        | Add additional init containers to the Keycloak pods                                                                                                                    | `[]`            |
| `sidecars`                              | Add additional sidecar containers to the Keycloak pods                                                                                                                 | `[]`            |

### Exposure parameters

| Name                               | Description                                                                                                                                                    | Value       |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `service.type`                     | Kubernetes service type                                                                                                                                        | `ClusterIP` |
| `service.http.enabled`             | Enable http port on service                                                                                                                                    | `true`      |
| `service.ports.http`               | Keycloak service HTTP port                                                                                                                                     | `80`        |
| `service.ports.https`              | Keycloak service HTTPS port                                                                                                                                    | `443`       |
| `service.nodePorts`                | Specify the [nodePort](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport) values for the LoadBalancer and NodePort service types. | `{}`        |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                                               | `None`      |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                                                    | `{}`        |
| `service.clusterIP`                | Keycloak service clusterIP IP                                                                                                                                  | `""`        |
| `service.loadBalancerIP`           | loadBalancerIP for the SuiteCRM Service (optional, cloud specific)                                                                                             | `""`        |
| `service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                                                                                          | `[]`        |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                                                           | `Cluster`   |
| `service.annotations`              | Additional custom annotations for Keycloak service                                                                                                             | `{}`        |
| `service.extraPorts`               | Extra port to expose on Keycloak service                                                                                                                       | `[]`        |
| `service.extraHeadlessPorts`       | Extra ports to expose on Keycloak headless service                                                                                                             | `[]`        |
| `service.headless.annotations`     | Annotations for the headless service.                                                                                                                          | `{}`        |
| `service.headless.extraPorts`      | Extra ports to expose on Keycloak headless service                                                                                                             | `[]`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value           |
| ------------------------------------ | ----------------------------------------- | --------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`         |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `keycloak.host` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`             |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`        |
| `ingress.tls`                        | TLS configuration                         | `[]`            |

### [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) configuration

| Name                            | Description                                | Value   |
| ------------------------------- | ------------------------------------------ | ------- |
| `networkPolicy.enabled`         | Enable the default NetworkPolicy policy    | `false` |
| `networkPolicy.allowExternal`   | Don't require client label for connections | `true`  |
| `networkPolicy.additionalRules` | Additional NetworkPolicy rules             | `{}`    |

### serviceAccount parameter

| Name                     | Description                                                                | Value   |
| ------------------------ | -------------------------------------------------------------------------- | ------- |
| `serviceAccountOverride` | A custom service account. If not defined it will be created automatically. | `""`    |
| `rbac.create`            | Whether to create and use RBAC resources or not                            | `false` |
| `rbac.rules`             | Custom RBAC rules                                                          | `[]`    |

### Other parameters

| Name                 | Description                                                                                                        | Value   |
| -------------------- | ------------------------------------------------------------------------------------------------------------------ | ------- |
| `pdb.create`         | Enable/disable a [Pod Disruption Budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) creation | `true`  |
| `pdb.minAvailable`   | Minimum number/percentage of pods that should remain scheduled                                                     | `""`    |
| `pdb.maxUnavailable` | Maximum number/percentage of pods that may be made unavailable                                                     | `1`     |
| `hpa.enabled`        | Enable hpa for Keycloak                                                                                            | `false` |
| `hpa.minReplicas`    | Minimum number of Keycloak replicas                                                                                | `1`     |
| `hpa.maxReplicas`    | Maximum number of Keycloak replicas                                                                                | `11`    |
| `hpa.targetCPU`      | Target CPU utilization percentage                                                                                  | `""`    |
| `hpa.targetMemory`   | Target Memory utilization percentage                                                                               | `""`    |

### Metrics parameters

| Name                                       | Description                                                                                                                 | Value   |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------- | ------- |
| `metrics.enabled`                          | Enable exposing [Keycloak statistics](https://github.com/bitnami/containers/tree/main/bitnami/keycloak#enabling-statistics) | `false` |
| `metrics.service.ports.http`               | Metrics service HTTP port                                                                                                   | `8080`  |
| `metrics.service.annotations`              | Annotations for enabling prometheus to access the metrics endpoints                                                         | `{}`    |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                                                | `false` |
| `metrics.serviceMonitor.port`              | Metrics service HTTP port                                                                                                   | `http`  |
| `metrics.serviceMonitor.endpoints`         | The endpoint configuration of the ServiceMonitor. Path is mandatory. Interval, timeout and labellings can be overwritten.   | `[]`    |
| `metrics.serviceMonitor.path`              | Metrics service HTTP path. Deprecated: Use @param metrics.serviceMonitor.endpoints instead                                  | `""`    |
| `metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                                                                    | `""`    |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                                                                 | `30s`   |
| `metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                                                                         | `""`    |
| `metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus                                       | `{}`    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                                         | `{}`    |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                                          | `[]`    |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                                                   | `[]`    |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels                                                    | `false` |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.                                           | `""`    |
| `metrics.prometheusRule.enabled`           | Create PrometheusRule Resource for scraping metrics using PrometheusOperator                                                | `false` |
| `metrics.prometheusRule.namespace`         | Namespace which Prometheus is running in                                                                                    | `""`    |
| `metrics.prometheusRule.labels`            | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                       | `{}`    |
| `metrics.prometheusRule.groups`            | Groups, containing the alert rules.                                                                                         | `[]`    |

### keycloak-config-cli parameters

| Name                                                      | Description                                                                                                                               | Value                                 |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------- |
| `keycloakConfigCli.enabled`                               | Whether to enable [keycloak-config-cli](https://github.com/adorsys/keycloak-config-cli) job                                               | `true`                                |
| `keycloakConfigCli.image.repository`                      | keycloak-config-cli container image repository                                                                                            | `2gis-on-premise/keycloak-config-cli` |
| `keycloakConfigCli.image.tag`                             | keycloak-config-cli container image tag                                                                                                   | `5.6.1-debian-11-r18`                 |
| `keycloakConfigCli.image.pullPolicy`                      | keycloak-config-cli container [image pull policy](https://kubernetes.io/docs/user-guide/images/#pre-pulling-images)                       | `IfNotPresent`                        |
| `keycloakConfigCli.image.pullSecrets`                     | keycloak-config-cli container [image pull secrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) | `[]`                                  |
| `keycloakConfigCli.annotations`                           | Annotations for keycloak-config-cli job                                                                                                   | `{}`                                  |
| `keycloakConfigCli.command`                               | Command for running the container (set to default if not set). Use array form                                                             | `[]`                                  |
| `keycloakConfigCli.args`                                  | Args for running the container (set to default if not set). Use array form                                                                | `[]`                                  |
| `keycloakConfigCli.hostAliases`                           | Job pod host aliases                                                                                                                      | `[]`                                  |
| `keycloakConfigCli.resources.requests.cpu`                | A CPU request.                                                                                                                            | `500m`                                |
| `keycloakConfigCli.resources.requests.memory`             | A memory request.                                                                                                                         | `256M`                                |
| `keycloakConfigCli.resources.limits.cpu`                  | A CPU limit.                                                                                                                              | `1`                                   |
| `keycloakConfigCli.resources.limits.memory`               | A memory limit.                                                                                                                           | `512M`                                |
| `keycloakConfigCli.containerSecurityContext.enabled`      | Enabled keycloak-config-cli containers' Security Context                                                                                  | `true`                                |
| `keycloakConfigCli.containerSecurityContext.runAsUser`    | Set keycloak-config-cli container's Security Context runAsUser                                                                            | `1001`                                |
| `keycloakConfigCli.containerSecurityContext.runAsNonRoot` | Set keycloak-config-cli container's Security Context runAsNonRoot                                                                         | `true`                                |
| `keycloakConfigCli.podSecurityContext.enabled`            | Enabled keycloak-config-cli pods' Security Context                                                                                        | `true`                                |
| `keycloakConfigCli.podSecurityContext.fsGroup`            | Set keycloak-config-cli pod's Security Context fsGroup                                                                                    | `1001`                                |
| `keycloakConfigCli.backoffLimit`                          | Number of retries before considering a Job as failed                                                                                      | `1`                                   |
| `keycloakConfigCli.podLabels`                             | Pod extra labels                                                                                                                          | `{}`                                  |
| `keycloakConfigCli.podAnnotations`                        | Annotations for job pod                                                                                                                   | `{}`                                  |
| `keycloakConfigCli.extraEnvVars`                          | Additional environment variables to set                                                                                                   | `[]`                                  |
| `keycloakConfigCli.nodeSelector`                          | Node labels for pod assignment                                                                                                            | `{}`                                  |
| `keycloakConfigCli.podTolerations`                        | Tolerations for job pod assignment                                                                                                        | `[]`                                  |
| `keycloakConfigCli.extraEnvVarsCM`                        | ConfigMap with extra environment variables                                                                                                | `""`                                  |
| `keycloakConfigCli.extraEnvVarsSecret`                    | Secret with extra environment variables                                                                                                   | `""`                                  |
| `keycloakConfigCli.extraVolumes`                          | Extra volumes to add to the job                                                                                                           | `[]`                                  |
| `keycloakConfigCli.extraVolumeMounts`                     | Extra volume mounts to add to the container                                                                                               | `[]`                                  |
| `keycloakConfigCli.initContainers`                        | Add additional init containers to the Keycloak config cli pod                                                                             | `[]`                                  |
| `keycloakConfigCli.sidecars`                              | Add additional sidecar containers to the Keycloak config cli pod                                                                          | `[]`                                  |
| `keycloakConfigCli.cleanupAfterFinished.enabled`          | Enables Cleanup for Finished Jobs                                                                                                         | `false`                               |
| `keycloakConfigCli.cleanupAfterFinished.seconds`          | Sets the value of ttlSecondsAfterFinished                                                                                                 | `600`                                 |

### Database settings

| Name                | Description                                   | Value  |
| ------------------- | --------------------------------------------- | ------ |
| `postgres.host`     | PostgreSQL rw/ro hostname or IP. **Required** | `""`   |
| `postgres.port`     | PostgreSQL port                               | `5432` |
| `postgres.name`     | PostgreSQL database name. **Required**        | `""`   |
| `postgres.username` | PostgreSQL username. **Required**             | `""`   |
| `postgres.password` | PostgreSQL password. **Required**             | `""`   |

### Keycloak Cache parameters

| Name              | Description                                                                                                           | Value        |
| ----------------- | --------------------------------------------------------------------------------------------------------------------- | ------------ |
| `cache.enabled`   | Switch to enable or disable the keycloak distributed [cache](https://www.keycloak.org/server/caching) for kubernetes. | `true`       |
| `cache.stackName` | Set infinispan cache stack to use                                                                                     | `kubernetes` |
| `cache.stackFile` | Set infinispan cache stack filename to use                                                                            | `""`         |

### Keycloak Logging parameters

| Name                              | Description                                                                                                     | Value                             |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `logging.output`                  | Alternates between the default [log](https://www.keycloak.org/server/logging) output format or json format      | `default`                         |
| `logging.level`                   | Allowed values as documented: FATAL, ERROR, WARN, INFO, DEBUG, TRACE, ALL, OFF                                  | `INFO`                            |
| `keycloakThemes.image.repository` | keycloak-themes container image repository                                                                      | `2gis-on-premise/keycloak-themes` |
| `keycloakThemes.image.tag`        | keycloak-themes container image tag                                                                             | `0.0.8`                           |
| `keycloakThemes.image.pullPolicy` | keycloak-themes container [image pull policy](https://kubernetes.io/docs/user-guide/images/#pre-pulling-images) | `IfNotPresent`                    |

### Keycloak default user for access on-premise services

| Name                   | Description                                 | Value   |
| ---------------------- | ------------------------------------------- | ------- |
| `defaultUser.enabled`  | Switch to enable or disable the defaultUser | `false` |
| `defaultUser.name`     | User name                                   | `""`    |
| `defaultUser.email`    | User email                                  | `""`    |
| `defaultUser.password` | User password                               | `""`    |
