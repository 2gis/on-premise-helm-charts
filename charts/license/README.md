# 2GIS License service

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

<!--- FIXME: add documentation with link --->
See the [documentation](https://docs.2gis.com/en/on-premise/) to learn about:

- Architecture of the service.

- Installing the service.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |


### Common settings

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `nameOverride`        | Base name to use in all the Kubernetes entities deployed by this chart.                                                     | `""`  |
| `fullnameOverride`    | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                 | `""`  |
| `annotations`         | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                   | `{}`  |
| `labels`              | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                             | `{}`  |
| `replicaCount`        | A replica count for the pod.                                                                                                | `1`   |
| `podAnnotations`      | Kubernetes pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).               | `{}`  |
| `podLabels`           | Kubernetes pod [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                         | `{}`  |
| `livenessProbeDelay`  | Initial delay for liveness probes.                                                                                          | `60`  |
| `readinessProbeDelay` | Initial delay for readiness probes.                                                                                         | `75`  |
| `nodeSelector`        | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).     | `{}`  |
| `tolerations`         | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.       | `[]`  |
| `affinity`            | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings. | `{}`  |
| `imagePullSecrets`    | Kubernetes image pull secrets.                                                                                              | `[]`  |


### Deployment settings

| Name               | Description  | Value                       |
| ------------------ | ------------ | --------------------------- |
| `image.repository` | Repository.  | `2gis-on-premise/navi-back` |
| `image.tag`        | Tag.         | `6.16.0`                    |
| `image.pullPolicy` | Pull Policy. | `IfNotPresent`              |


### License service application settings

| Name                      | Description                                                                                                                                                                                                                                         | Value |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `license.path`            | License file path in storage.                                                                                                                                                                                                                       | `""`  |
| `license.updatePeriod`    | Duration how often service should fetch new license from storage. Duration format is any string supported by (time.ParseDuration)[https://pkg.go.dev/time#ParseDuration] plus additionally 'd' for days and 'w' for weeks time units are supported. | `1h`  |
| `license.retryPeriod`     | Duration how often service should try to fetch license from storage if previous attempts were failing.                                                                                                                                              | `30s` |
| `license.softBlockPeriod` | Duration until the license expiration time when license service should respond with 'soft' block status.                                                                                                                                            | `2w`  |


### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port`        | Service port.                                                                                                                  | `80`        |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |


### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                    | Description                                                    | Value   |
| ----------------------- | -------------------------------------------------------------- | ------- |
| `ingress.enabled`       | If Ingress is enabled for the service.                         | `false` |
| `ingress.hosts[0].host` | Hostname for the Ingress service. Ex.: 'license.ingress.host'. | `""`    |


### Limits

| Name                        | Description       | Value   |
| --------------------------- | ----------------- | ------- |
| `resources.requests.cpu`    | A CPU request.    | `50m`   |
| `resources.requests.memory` | A memory request. | `128Mi` |
| `resources.limits.cpu`      | A CPU limit.      | `1`     |
| `resources.limits.memory`   | A memory limit.   | `512Mi` |


### Deployment Artifacts Storage settings

| Name                     | Description                             | Value |
| ------------------------ | --------------------------------------- | ----- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`.       | `""`  |
| `dgctlStorage.bucket`    | S3 bucket name.                         | `""`  |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket. | `""`  |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket. | `""`  |

