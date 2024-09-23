# 2GIS MapGL JS API service

Use this Helm chart to deploy MapGL JS API service, which is a part of 2GIS's [On-Premise Maps services](https://docs.2gis.com/en/on-premise/map).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/map) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-mapgl.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                   | Description                                                                                                                                    | Value |
| ---------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `replicaCount`         | A replica count for the pod.                                                                                                                   | `1`   |
| `revisionHistoryLimit` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). | `3`   |
| `imagePullSecrets`     | Kubernetes image pull secrets.                                                                                                                 | `[]`  |
| `nameOverride`         | Base name to use in all the Kubernetes entities deployed by this chart.                                                                        | `""`  |
| `fullnameOverride`     | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                                    | `""`  |
| `nodeSelector`         | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                            | `{}`  |
| `affinity`             | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                    | `{}`  |
| `tolerations`          | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                              | `[]`  |
| `podAnnotations`       | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                  | `{}`  |
| `podLabels`            | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                            | `{}`  |

### Deployment settings

| Name               | Description | Value                   |
| ------------------ | ----------- | ----------------------- |
| `image.repository` | Repository  | `2gis-on-premise/mapgl` |
| `image.tag`        | Tag         | `1.51.0`                |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`          |

### Environment variables

| Name                            | Description                                                                                                               | Value                                                                                             |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `env.MAPGL_DEMO_KEY`            | token from 'keys-api' service. Defines access for map through MAPGL_HOST.                                                 | `""`                                                                                              |
| `env.MAPGL_HOST`                | URL for MapGL JS API service, e.g. 'https://mapgl-api.ingress.host'                                                       | `""`                                                                                              |
| `env.MAPGL_TILES_API`           | URL of the Tiles API service, e.g. 'https://tiles-api.ingress.host'                                                       | `""`                                                                                              |
| `env.MAPGL_TILESET`             | Tileset of the Tiles API service to use.                                                                                  | `web`                                                                                             |
| `env.MAPGL_IMMERSIVE_TILESET`   | Additional immersive tileset of the Tiles API service to use.                                                             | `web_immersive`                                                                                   |
| `env.MAPGL_TRAFFICSERVER`       | Domain name of the Traffic Proxy service, e.g. 'https://traffic-proxy.ingress.host'                                       | `https://traffic-proxy.ingress.host`                                                              |
| `env.MAPGL_FLOORSSERVER`        | URL of the Floors API service, e.g. 'https://floors-api.ingress.host'                                                     | `""`                                                                                              |
| `env.MAPGL_STYLESERVER`         | URL of the Styles API service, e.g. 'https://styles.ingress.host'                                                         | `""`                                                                                              |
| `env.MAPGL_ICONSPATH`           | URL of the icons directory, e.g. 'https://styles.ingress.host/styles/assets/icons'                                        | `""`                                                                                              |
| `env.MAPGL_MODELSPATH`          | URL of the models directory, e.g. 'https://styles.ingress.host/styles/assets/models'                                      | `""`                                                                                              |
| `env.MAPGL_KEYSERVER`           | URL of the API Keys service, e.g. 'https://keys-api.ingress.host/public/v1/keys/{keyID}/services/mapgl-js-api'            | `""`                                                                                              |
| `env.MAPGL_RTLPLUGIN`           | URL of the plugin for right-to-left languages support, e.g. 'https://mapgl-api.ingress.host/api/js/plugins/rtl-v1.0.0.js' | `""`                                                                                              |
| `env.MAPGL_RTLPLUGINHASH`       | SHA512 hash of the RTL plugin.                                                                                            | `sha512-YAPPEl+Atvsm/cMkrfWefmlQLAlKTGaqFjIkI6urAnDgam2uTVEVVnZZEhHCa91JjYYxa5yr4Ndb4Vl3NUovfA==` |
| `env.MAPGL_INVALID_KEY_MESSAGE` | Custom error message for invalid MapGL key.                                                                               | `Your MapGL key is invalid. Please contact support to get valid key.`                             |

### Strategy settings

| Name                                    | Description                                                                                                                                                                                              | Value           |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |

### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | Service port.                                                                                                                  | `80`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                      |
| ------------------------------------ | ----------------------------------------- | -------------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                    |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`                    |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `mapgl-js-api.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                        |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                   |
| `ingress.tls`                        | TLS configuration                         | `[]`                       |

### Limits

| Name                        | Description       | Value  |
| --------------------------- | ----------------- | ------ |
| `resources.requests.cpu`    | A CPU request.    | `30m`  |
| `resources.requests.memory` | A memory request. | `32M`  |
| `resources.limits.cpu`      | A CPU limit.      | `100m` |
| `resources.limits.memory`   | A memory limit.   | `64M`  |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                          | Value   |
| -------------------- | ---------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service.                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`     |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                      | Description                                                                                                                                                          | Value   |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                             | If HPA is enabled for the service.                                                                                                                                   | `false` |
| `hpa.minReplicas`                         | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`     |
| `hpa.maxReplicas`                         | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `2`     |
| `hpa.scaleDownStabilizationWindowSeconds` | Scale-down window.                                                                                                                                                   | `""`    |
| `hpa.scaleUpStabilizationWindowSeconds`   | Scale-up window.                                                                                                                                                     | `""`    |
| `hpa.targetCPUUtilizationPercentage`      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`    |
| `hpa.targetMemoryUtilizationPercentage`   | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`    |

### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                    | Description                                                                                                  | Value   |
| ----------------------- | ------------------------------------------------------------------------------------------------------------ | ------- |
| `vpa.enabled`           | If VPA is enabled for the service.                                                                           | `false` |
| `vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start). | `Auto`  |
| `vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down.                                   | `100m`  |
| `vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down.                                         | `100Mi` |
| `vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up.                                     | `200m`  |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up.                                           | `200Mi` |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
