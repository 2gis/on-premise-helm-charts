# 2GIS MapsAPI 2.0 (Raster Map) service

Use this Helm chart to deploy MapsAPI 2.0 service (Leaflet-based raster map), which is a part of 2GIS's [On-Premise Maps services](https://docs.2gis.com/en/on-premise/map).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:** This chart deploys the **raster** map (MapsAPI 2.0, based on Leaflet). For the **WebGL** map (MapGL JS API), see the [mapgl-js-api](../mapgl-js-api) chart.

See the [documentation](https://docs.2gis.com/en/on-premise/map) to learn about:

- Architecture of the service.

- Installing the service.

    When filling in the keys for `values-raster-js-api.yaml` configuration file, refer to the documentation and the list of keys below.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name                            | Description                                                                                                                                                               | Value  |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `enableServiceLinks`            | Services injection into containers environment [Accessing the Service](https://kubernetes.io/docs/tutorials/services/connect-applications-service/#accessing-the-service) | `true` |
| `replicaCount`                  | A replica count for the pod.                                                                                                                                              | `1`    |
| `revisionHistoryLimit`          | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment).                            | `3`    |
| `terminationGracePeriodSeconds` | Kubernetes [termination grace period](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/)                                                          | `30`   |
| `imagePullSecrets`              | Kubernetes image pull secrets.                                                                                                                                            | `[]`   |
| `nameOverride`                  | Base name to use in all the Kubernetes entities deployed by this chart.                                                                                                   | `""`   |
| `fullnameOverride`              | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                                                               | `""`   |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                       | `{}`   |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                               | `{}`   |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                         | `[]`   |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                             | `{}`   |
| `podLabels`                     | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                       | `{}`   |
| `podSecurityContext`            | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                                                            | `{}`   |
| `securityContext`               | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                                                                | `{}`   |
| `labels`                        | Custom labels to set to Deployment resource.                                                                                                                              | `{}`   |
| `annotations`                   | Custom annotations to set to Deployment resource.                                                                                                                         | `{}`   |
| `priorityClassName`             | Kubernetes [Pod Priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass) class name.                                     | `""`   |
| `initContainers`                | Add additional init containers.                                                                                                                                           | `[]`   |
| `sidecars`                      | Add additional sidecar containers.                                                                                                                                        | `[]`   |

### Deployment settings

| Name               | Description | Value                           |
| ------------------ | ----------- | ------------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/raster-js-api` |
| `image.tag`        | Tag         | `4.1.0`                         |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`                  |

### API settings

| Name                            | Description                                                                                                                               | Value    |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| `api.publicHost`                | **required** Host on which the service will be available, e.g. 'maps-raster.ingress.host'.                                                | `""`     |
| `api.protocol`                  | Protocol to use: `http:`, `https:`.                                                                                                       | `https:` |
| `api.tileServerUrl`             | URL of the tile server, e.g. 'https://tiles-api.ingress.host'.                                                                            | `""`     |
| `api.trafficTileServerUrl`      | URL of the traffic tiles server, e.g. 'https://traffic-tiles-api.ingress.host'.                                                           | `""`     |
| `api.trafficTimestampServerUrl` | URL of the traffic timestamps server, e.g. 'https://traffic-score.ingress.host'.                                                          | `""`     |
| `api.trafficScoreServerUrl`     | URL of the traffic scores server, e.g. 'https://traffic-score.ingress.host'.                                                              | `""`     |
| `api.webApiServerUrl`           | URL of the Catalog API service, e.g. 'https://catalog-api.ingress.host'.                                                                  | `""`     |
| `api.webApiKey`                 | API key for the Catalog API service. Stored in a Kubernetes Secret and mounted into the container via `secretKeyRef`.                     | `""`     |
| `api.key`                       | Optional API key that will be included in tile requests. Stored in a Kubernetes Secret and mounted into the container via `secretKeyRef`. | `""`     |
| `api.keyServerUrl`              | Keys-api service URL, e.g. 'https://keys-api.ingress.host/public/v1/keys/'                                                                | `""`     |

### Strategy settings

| Name                                    | Description                                                                                                                                                                                              | Value           |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `strategy.type`                         | Type of Kubernetes deployment. Can be `Recreate` or `RollingUpdate`.                                                                                                                                     | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). | `0`             |
| `strategy.rollingUpdate.maxSurge`       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process.                     | `1`             |

### Service account settings

| Name                         | Description                                                                                                             | Value   |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                                                  | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account.                                                                              | `{}`    |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |

### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | Service port.                                                                                                                  | `80`        |
| `service.clusterIP`   | Controls Service cluster IP allocation. Cannot be changed after resource creation.                                             | `""`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                       |
| ------------------------------------ | ----------------------------------------- | --------------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                     |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`                     |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `raster-js-api.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                         |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                    |
| `ingress.tls`                        | TLS configuration                         | `[]`                        |

### [HTTPRoute](https://gateway-api.sigs.k8s.io/api-types/httproute/) configuration

| Name                   | Description                                         | Value   |
| ---------------------- | --------------------------------------------------- | ------- |
| `httpRoute.enabled`    | If HTTPRoute is enabled for the service.            | `false` |
| `httpRoute.hostnames`  | List of hostnames served by route.                  | `[]`    |
| `httpRoute.parentRefs` | List of parent references (gateways) for HTTPRoute. |         |

### Limits

| Name                        | Description       | Value   |
| --------------------------- | ----------------- | ------- |
| `resources.requests.cpu`    | A CPU request.    | `50m`   |
| `resources.requests.memory` | A memory request. | `64Mi`  |
| `resources.limits.cpu`      | A CPU limit.      | `200m`  |
| `resources.limits.memory`   | A memory limit.   | `192Mi` |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                    | Description                                                                                                                                                          | Value   |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                           | If HPA is enabled for the service.                                                                                                                                   | `false` |
| `hpa.minReplicas`                       | Lower limit for the number of replicas to which the autoscaler can scale down.                                                                                       | `1`     |
| `hpa.maxReplicas`                       | Upper limit for the number of replicas to which the autoscaler can scale up.                                                                                         | `2`     |
| `hpa.scaleDown`                         | Scale-down settings structure.                                                                                                                                       | `{}`    |
| `hpa.scaleUp`                           | Scale-up settings structure.                                                                                                                                         | `{}`    |
| `hpa.targetCPUUtilizationPercentage`    | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used.       | `80`    |
| `hpa.targetMemoryUtilizationPercentage` | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used. | `""`    |

### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                    | Description                                                                                                  | Value          |
| ----------------------- | ------------------------------------------------------------------------------------------------------------ | -------------- |
| `vpa.enabled`           | If VPA is enabled for the service.                                                                           | `false`        |
| `vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start). | `Auto`         |
| `vpa.controlledValues`  | Controlled values, one of: RequestsOnly or RequestsAndLimits.                                                | `RequestsOnly` |
| `vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down.                                   |                |
| `vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down.                                         |                |
| `vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up.                                     |                |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up.                                           |                |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                          | Value   |
| -------------------- | ---------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service.                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`     |

### customCAs **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container. If empty, the default value: "/usr/local/share/ca-certificates"          | `""`  |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
