# 2GIS Floors API service

Use this Helm chart to deploy Floors API service, which is a part of 2GIS's [On-Premise Maps services](https://docs.2gis.com/en/on-premise/map).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Deployment settings

| Name                      | Description                      | Value                           |
| ------------------------- | -------------------------------- | ------------------------------- |
| `nodejs.image.repository` | Floors backend image repository. | `2gis-on-premise/floors-nodejs` |
| `nodejs.image.pullPolicy` | Floors backend pull policy.      | `IfNotPresent`                  |
| `nodejs.image.tag`        | Floors backend image tag.        | `1.1.0`                         |
| `nginx.image.repository`  | Floors nginx image repository.   | `2gis-on-premise/nginx`         |
| `nginx.image.pullPolicy`  | Floors nginx pull policy.        | `IfNotPresent`                  |
| `nginx.image.tag`         | Floors nginx image tag.          | `1.25.5`                        |

### Deployment Artifacts Storage settings

| Name                     | Description                                                                                                                                                                                                                                              | Value |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`.                                                                                                                                                                                                                        | `""`  |
| `dgctlStorage.bucket`    | S3 bucket name.                                                                                                                                                                                                                                          | `""`  |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket.                                                                                                                                                                                                                  | `""`  |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket.                                                                                                                                                                                                                  | `""`  |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2@paramCommon_deployment_steps). Format: `manifests/0000000000.json`.<br> This file contains the description of pieces of data that the service requires to operate. | `""`  |

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
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                             | `{}`   |
| `podSecurityContext`            | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                                                            | `{}`   |
| `securityContext`               | Kubernetes [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                                                                | `{}`   |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                       | `{}`   |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                         | `[]`   |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).                                               | `{}`   |

### Service account settings

| Name                         | Description                                                                                                             | Value   |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                                                  | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account.                                                                              | `{}`    |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |

### Service settings

| Name           | Description                                                                                                                    | Value       |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.type` | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.port` | Service port.                                                                                                                  | `80`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                |
| ------------------------------------ | ----------------------------------------- | -------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`              |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`              |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `floors.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                  |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`             |
| `ingress.tls`                        | TLS configuration                         | `[]`                 |

### Limits

| Name                              | Description                      | Value |
| --------------------------------- | -------------------------------- | ----- |
| `resources.requests.cpu`          | A CPU request, e.g., `100m`.     |       |
| `resources.requests.memory`       | A memory request, e.g., `128Mi`. |       |
| `resources.limits.cpu`            | A CPU limit, e.g., `100m`.       |       |
| `resources.limits.memory`         | A memory limit, e.g., `128Mi`.   |       |
| `nginx.resources.requests.cpu`    | A CPU request, e.g., `100m`.     |       |
| `nginx.resources.requests.memory` | A memory request, e.g., `128Mi`. |       |
| `nginx.resources.limits.cpu`      | A CPU limit, e.g., `100m`.       |       |
| `nginx.resources.limits.memory`   | A memory limit, e.g., `128Mi`.   |       |

### Floors backend settings


### Floors nginx settings

| Name             | Description                                      | Value  |
| ---------------- | ------------------------------------------------ | ------ |
| `nginx.httpPort` | HTTP port on which Floors API will be listening. | `8080` |

### Floors API data import settings

| Name                               | Description                      | Value                             |
| ---------------------------------- | -------------------------------- | --------------------------------- |
| `import.image.repository`          | Import task image repository.    | `2gis-on-premise/floors-importer` |
| `import.image.tag`                 | Import task image tag.           | `1.1.0`                           |
| `import.image.pullPolicy`          | Import task pull policy.         | `IfNotPresent`                    |
| `import.resources.requests.cpu`    | A CPU request, e.g., `100m`.     |                                   |
| `import.resources.requests.memory` | A memory request, e.g., `128Mi`. |                                   |
| `import.resources.limits.cpu`      | A CPU limit, e.g., `100m`.       |                                   |
| `import.resources.limits.memory`   | A memory limit, e.g., `128Mi`.   |                                   |

### **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container.                                                                          | `""`  |
