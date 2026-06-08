# 2GIS Static Maps service

Use this Helm chart to deploy Static Maps service, which is a part of 2GIS's [On-Premise Maps services](https://docs.2gis.com/en/on-premise/map).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

See the [documentation](https://docs.2gis.com/en/on-premise/map) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-staticmaps.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                 | Description                                                                                                                                         | Value |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `nameOverride`       | Base name to use in all the Kubernetes entities deployed by this chart.                                                                             | `""`  |
| `fullnameOverride`   | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                                         | `""`  |
| `annotations`        | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                           | `{}`  |
| `labels`             | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                     | `{}`  |
| `podAnnotations`     | Kubernetes pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                       | `{}`  |
| `podLabels`          | Kubernetes pod [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                 | `{}`  |
| `podSecurityContext` | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)                                       | `{}`  |
| `nodeSelector`       | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                             | `{}`  |
| `tolerations`        | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                               | `[]`  |
| `affinity`           | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                         | `{}`  |
| `imagePullSecrets`   | Kubernetes [secrets for pulling the image from the registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) | `[]`  |

### API settings

| Name                   | Description                                                                                                                                    | Value |
| ---------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `replicas`             | Number of replicas of API pods                                                                                                                 | `1`   |
| `revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`   |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                      | Description                                                                                                                                                         | Value   |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                             | If HPA is enabled for the service                                                                                                                                   | `false` |
| `hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down                                                                                       | `1`     |
| `hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up                                                                                         | `2`     |
| `hpa.scaleDownStabilizationWindowSeconds` | Scale-down window                                                                                                                                                   | `""`    |
| `hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window                                                                                                                                                     | `""`    |
| `hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used       | `80`    |
| `hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used | `""`    |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                         | Value   |
| -------------------- | --------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction | `1`     |

### Strategy settings

| Name                                    | Description                                                                                                                                                                                              | Value           |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |

### Deployment settings

| Name               | Description  | Value                        |
| ------------------ | ------------ | ---------------------------- |
| `image.repository` | Repository.  | `2gis-on-premise/staticmaps` |
| `image.tag`        | Tag.         | `1.0.0`                      |
| `image.pullPolicy` | Pull Policy. | `IfNotPresent`               |

### Service settings

| Name                  | Description                                                                                                                   | Value       |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)                        | `{}`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) | `ClusterIP` |
| `service.port`        | Service port                                                                                                                  | `8080`      |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                    |
| ------------------------------------ | ----------------------------------------- | ------------------------ |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                  |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`                  |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `staticmaps.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                      |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                 |
| `ingress.tls`                        | TLS configuration                         | `[]`                     |

### Limits

| Name                        | Description       | Value   |
| --------------------------- | ----------------- | ------- |
| `resources.requests.cpu`    | A CPU request.    | `400m`  |
| `resources.requests.memory` | A memory request. | `128Mi` |
| `resources.limits.cpu`      | A CPU limit.      | `700m`  |
| `resources.limits.memory`   | A memory limit.   | `256Mi` |

### StaticMaps service application settings

| Name                       | Description                                                                                        | Value                                        |
| -------------------------- | -------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| `app.log.level`            | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`, `panic`. | `info`                                       |
| `app.log.format`           | Log format for the service. Can be: `text`, `json`.                                                | `json`                                       |
| `app.attributionDir`       | Path to the directory with attribution files.                                                      | `/usr/share/staticmaps/pictures/attribution` |
| `app.markers`              | **Markers settings**                                                                               |                                              |
| `app.markers.localDir`     | Path to the directory with local markers.                                                          | `/usr/share/staticmaps/pictures/markers`     |
| `app.markers.fetchTimeout` | Timeout for fetching markers from external sources.                                                | `3s`                                         |
| `app.markers.cacheDir`     | Path to the directory for caching markers.                                                         | `/cache`                                     |
| `app.markers.cacheExpire`  | Duration for which cached markers are considered valid.                                            | `2h`                                         |
| `app.access`               | **API Keys service access settings**                                                               |                                              |
| `app.access.enabled`       | If access to the [API Keys service](https://docs.2gis.com/en/on-premise/keys) is enabled.          | `false`                                      |
| `app.access.stat`          | **Statistics receiver settings**                                                                   |                                              |
| `app.access.stat.enabled`  | If statistics receiver is enabled.                                                                 | `false`                                      |
| `app.access.stat.url`      | Statistics receiver endpoint url, ex: http(s)://host:port/path. **Required**                       | `""`                                         |

### Tiles service settings

| Name                   | Description                                                                 | Value |
| ---------------------- | --------------------------------------------------------------------------- | ----- |
| `tiles.url`            | URL of the Tiles API service, ex: http://tiles-service-api.svc **Required** | `""`  |
| `tiles.key`            | Tiles access key **Required**                                               | `""`  |
| `tiles.requestTimeout` | Timeout for requests to the Tiles API.                                      | `5s`  |

### Keys service settings

| Name              | Description                                                               | Value |
| ----------------- | ------------------------------------------------------------------------- | ----- |
| `keys.url`        | URL of the Keys API service, ex: http://keys-service-api.svc **Required** | `""`  |
| `keys.token`      | Keys service API key **Required**                                         | `""`  |
| `keys.syncPeriod` | Duration how often static maps API should try to update keys data.        | `5m`  |

### License service settings

| Name                  | Description                                                                                        | Value |
| --------------------- | -------------------------------------------------------------------------------------------------- | ----- |
| `license.url`         | Address of the License service. Ex: https://license.svc **Required**                               | `""`  |
| `license.retryPeriod` | Duration how often static maps API should try to update license status if it is failing to get it. | `30s` |

### **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container.                                                                          | `""`  |
