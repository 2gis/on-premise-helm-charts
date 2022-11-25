# 2GIS Pasportool licensing service

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

| Name               | Description                                                                                              | Value          |
| ------------------ | -------------------------------------------------------------------------------------------------------- | -------------- |
| `imagePullSecrets` | Kubernetes image pull secrets.                                                                           | `[]`           |
| `imagePullPolicy`  | Kubernetes image pull policy.                                                                            | `IfNotPresent` |
| `licensePath`      | License file path in storage.                                                                            | `""`           |
| `updatePeriod`     | Duration how often service should fetch new license from storage.                                        | `1h`           |
| `retryPeriod`      | Duration how often service should try to fetch license from storage if previous attempts were failing.   | `30s`          |
| `softBlockPeriod`  | Duration until the license expiration time when license service should respond with 'soft' block status. | `72h`          |


### Deployment Artifacts Storage settings

| Name                     | Description                             | Value |
| ------------------------ | --------------------------------------- | ----- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`.       | `""`  |
| `dgctlStorage.bucket`    | S3 bucket name.                         | `""`  |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket. | `""`  |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket. | `""`  |


### Pasportool service settings

| Name                                   | Description                                                                                                                   | Value                        |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `pasportool`                           | **Common settings**                                                                                                           |                              |
| `pasportool.annotations`               | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                     | `{}`                         |
| `pasportool.labels`                    | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                               | `{}`                         |
| `pasportool.podAnnotations`            | Kubernetes pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                 | `{}`                         |
| `pasportool.podLabels`                 | Kubernetes pod [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                           | `{}`                         |
| `pasportool.replicas`                  | A replica count for the pod.                                                                                                  | `1`                          |
| `pasportool.nodeSelector`              | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).       | `{}`                         |
| `pasportool.affinity`                  | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.   | `{}`                         |
| `pasportool.tolerations`               | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.         | `{}`                         |
| `pasportool.image`                     | **Docker image settings**                                                                                                     |                              |
| `pasportool.image.repository`          | Docker Repository.                                                                                                            | `2gis-on-premise/pasportool` |
| `pasportool.image.tag`                 | Docker image tag.                                                                                                             | `1.0.0`                      |
| `pasportool.resources`                 | **Kubernetes [resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) settings** |                              |
| `pasportool.resources.requests.cpu`    | A CPU request.                                                                                                                | `50m`                        |
| `pasportool.resources.requests.memory` | A memory request.                                                                                                             | `128Mi`                      |
| `pasportool.resources.limits.cpu`      | A CPU limit.                                                                                                                  | `1`                          |
| `pasportool.resources.limits.memory`   | A memory limit.                                                                                                               | `512Mi`                      |


### Kubernetes [service](https://kubernetes.io/docs/concepts/services-networking/service/) settings

| Name                             | Description                                                                                                                    | Value       |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `pasportool.service.port`        | Service port.                                                                                                                  | `80`        |
| `pasportool.service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `pasportool.service.annotations` | Kubernetes service [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `pasportool.service.labels`      | Kubernetes service [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |


### Kubernetes [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                               | Description                            | Value   |
| ---------------------------------- | -------------------------------------- | ------- |
| `pasportool.ingress.enabled`       | If ingress is enabled for the service. | `false` |
| `pasportool.ingress.hosts[0].host` | Hostname for the ingress service.      | `""`    |

