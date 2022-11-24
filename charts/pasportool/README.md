# 2GIS Pasportool licensing service

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

<!--- FIXME: добавить документацию и ссылку на неё --->
See the [documentation](https://docs.2gis.com/en/on-premise/) to learn about:

- Architecture of the service.

- Installing the service.

- Updating the service.

## Values

### License settings

| Name                      | Description                                                                                              | Value |
| ------------------------- | -------------------------------------------------------------------------------------------------------- | ----- |
| `license`                 | **Common settings**                                                                                      |       |
| `license.path`            | License file path in storage.                                                                            | `""`  |
| `license.updatePeriod`    | Duration how often service should fetch new license from storage.                                        | `1h`  |
| `license.retryPeriod`     | Duration how often service should try to fetch license from storage if previous attempts were failing.   | `30s` |
| `license.softBlockPeriod` | Duration until the license expiration time when license service should respond with 'soft' block status. | `72h` |


### Storage settings

| Name                | Description                             | Value |
| ------------------- | --------------------------------------- | ----- |
| `storage`           | **Common settings**                     |       |
| `storage.host`      | S3 endpoint. Format: `host:port`.       | `""`  |
| `storage.bucket`    | S3 bucket name.                         | `""`  |
| `storage.accessKey` | S3 access key for accessing the bucket. | `""`  |
| `storage.secretKey` | S3 secret key for accessing the bucket. | `""`  |


### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |
| `imagePullSecrets`    | Kubernetes image pull secrets for the Docker Registry endpoint.                         | `[]`  |


### Kubernetes [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) settings

| Name                                   | Description                                                                                                                   | Value                        |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `deployment`                           | **Common settings**                                                                                                           |                              |
| `deployment.annotations`               | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                     | `{}`                         |
| `deployment.labels`                    | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                               | `{}`                         |
| `deployment.podAnnotations`            | Kubernetes pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                 | `{}`                         |
| `deployment.podLabels`                 | Kubernetes pod [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                           | `{}`                         |
| `deployment.replicas`                  | A replica count for the pod.                                                                                                  | `1`                          |
| `deployment.nodeSelector`              | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).       | `{}`                         |
| `deployment.affinity`                  | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.   | `{}`                         |
| `deployment.tolerations`               | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.         | `{}`                         |
| `deployment.image`                     | **Docker image settings**                                                                                                     |                              |
| `deployment.image.repository`          | Docker Repository.                                                                                                            | `2gis-on-premise/pasportool` |
| `deployment.image.tag`                 | Docker image tag.                                                                                                             | `1.0.0`                      |
| `deployment.image.pullPolicy`          | Kubernetes pull policy for the service's Docker image.                                                                        | `IfNotPresent`               |
| `deployment.resources`                 | **Kubernetes [resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) settings** |                              |
| `deployment.resources.requests.cpu`    | A CPU request.                                                                                                                | `50m`                        |
| `deployment.resources.requests.memory` | A memory request.                                                                                                             | `128Mi`                      |
| `deployment.resources.limits.cpu`      | A CPU limit.                                                                                                                  | `1`                          |
| `deployment.resources.limits.memory`   | A memory limit.                                                                                                               | `512Mi`                      |


### Kubernetes [service](https://kubernetes.io/docs/concepts/services-networking/service/) settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service`             | **Common settings**                                                                                                            |             |
| `service.port`        | Service port.                                                                                                                  | `80`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.annotations` | Kubernetes service [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes service [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |


### Kubernetes [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                    | Description                            | Value             |
| ----------------------- | -------------------------------------- | ----------------- |
| `ingress`               | **Common settings**                    |                   |
| `ingress.enabled`       | If ingress is enabled for the service. | `false`           |
| `ingress.hosts[0].host` | Hostname for the ingress service.      | `pasportool.host` |

