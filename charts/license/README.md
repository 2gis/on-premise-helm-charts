# 2GIS License service

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/architecture/services/license) to learn about:

- Architecture of the service.

- Installing the service.

- Updating the service.

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Deployment Artifacts Storage settings

| Name                     | Description                             | Value   |
| ------------------------ | --------------------------------------- | ------- |
| `dgctlStorage.host`      | S3 endpoint. Format: `host:port`.       | `""`    |
| `dgctlStorage.secure`    | If S3 uses https.                       | `false` |
| `dgctlStorage.region`    | S3 region.                              | `""`    |
| `dgctlStorage.bucket`    | S3 bucket name.                         | `""`    |
| `dgctlStorage.accessKey` | S3 access key for accessing the bucket. | `""`    |
| `dgctlStorage.secretKey` | S3 secret key for accessing the bucket. | `""`    |

### Common settings

| Name                     | Description                                                                                                                                                                                                                                   | Value |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `nameOverride`           | Base name to use in all the Kubernetes entities deployed by this chart.                                                                                                                                                                       | `""`  |
| `fullnameOverride`       | Base fullname to use in all the Kubernetes entities deployed by this chart.                                                                                                                                                                   | `""`  |
| `annotations`            | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                                                     | `{}`  |
| `labels`                 | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                                                               | `{}`  |
| `podAnnotations`         | Kubernetes pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).                                                                                                                                 | `{}`  |
| `podLabels`              | Kubernetes pod [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                                                                                                                                           | `{}`  |
| `serviceAccountOverride` | Kubernetes pod [service account](https://kubernetes.io/docs/concepts/security/service-accounts/). Should include rule for watching pods in current namespace. If not defined it will be created automatically. Not needed for license type 1. | `""`  |
| `nodeSelector`           | Kubernetes pod [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).                                                                                                                       | `{}`  |
| `tolerations`            | Kubernetes pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings.                                                                                                                         | `[]`  |
| `affinity`               | Kubernetes pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) settings.                                                                                                                   | `{}`  |
| `imagePullSecrets`       | Kubernetes image pull secrets.                                                                                                                                                                                                                | `[]`  |

### StatefulSet settings

| Name               | Description  | Value                     |
| ------------------ | ------------ | ------------------------- |
| `image.repository` | Repository.  | `2gis-on-premise/license` |
| `image.tag`        | Tag.         | `2.4.0`                   |
| `image.pullPolicy` | Pull Policy. | `IfNotPresent`            |

### License service application settings

| Name                      | Description                                                                                                                                                                                                    | Value  |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `license.type`            | License type. Should be auto generated with `dgctl pull --generate-values`.                                                                                                                                    | `""`   |
| `license.retryPeriod`     | Duration how often service should try to fetch license from storage if previous attempts were failing. Duration format is any string supported by (time.ParseDuration)[https://pkg.go.dev/time#ParseDuration]. | `30s`  |
| `license.softBlockPeriod` | Duration until the license expiration time when license service should respond with 'soft' block status. For this duration additional time units 'd' for days and 'w' for weeks are supported.                 | `2w`   |
| `license.log.level`       | Log level for the service. Can be: `trace`, `debug`, `info`, `warning`, `error`, `fatal`, `panic`.                                                                                                             | `info` |
| `license.log.format`      | Log format for the service. Can be: `text`, `json`.                                                                                                                                                            | `text` |

### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.statusPort`  | Service port for status page and api/v1 (HTTP).                                                                                | `80`        |
| `service.apiPort`     | Service port for api/v2 (HTTPS).                                                                                               | `443`       |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                 |
| ------------------------------------ | ----------------------------------------- | --------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`               |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`               |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `license.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                   |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`              |
| `ingress.tls`                        | TLS configuration                         | `[]`                  |

### Limits

| Name                        | Description       | Value   |
| --------------------------- | ----------------- | ------- |
| `resources.requests.cpu`    | A CPU request.    | `500m`  |
| `resources.requests.memory` | A memory request. | `128Mi` |
| `resources.limits.cpu`      | A CPU limit.      | `1`     |
| `resources.limits.memory`   | A memory limit.   | `512Mi` |

### Persistence settings

| Name                    | Description                             | Value   |
| ----------------------- | --------------------------------------- | ------- |
| `persistence.host`      | S3 endpoint. Format: `host:port`.       | `""`    |
| `persistence.secure`    | If S3 uses https.                       | `false` |
| `persistence.region`    | S3 region.                              | `""`    |
| `persistence.bucket`    | S3 bucket name.                         | `""`    |
| `persistence.root`      | Root directory in S3 bucket.            | `""`    |
| `persistence.accessKey` | S3 access key for accessing the bucket. | `""`    |
| `persistence.secretKey` | S3 secret key for accessing the bucket. | `""`    |

### TPM-related settings for license type 2

| Name                           | Description                                                                                                                                     | Value   |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `tpm.mountTPMDevice`           | If TPM device should be mounted to the main container. Required if no TPM device plugin is used. Adds privileged access for the main container. | `false` |
| `tpm.pvcBind`                  | **Kubernetes PVC used to bind pod to the kubernetes node**                                                                                      |         |
| `tpm.pvcBind.enable`           | If PVC should be used to bind pod to the kubernetes node.                                                                                       | `false` |
| `tpm.pvcBind.storageClassName` | Storage class name.                                                                                                                             | `""`    |

### **Custom Certificate Authority**

| Name                  | Description                                                                                                                 | Value |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customCAs.bundle`    | Custom CA [text representation of the X.509 PEM public-key certificate](https://www.rfc-editor.org/rfc/rfc7468#section-5.1) | `""`  |
| `customCAs.certsPath` | Custom CA bundle mount directory in the container.                                                                          | `""`  |
