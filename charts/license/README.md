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
| `image.tag`        | Tag.         | `2.1.2`                   |
| `image.pullPolicy` | Pull Policy. | `IfNotPresent`            |

### License service application settings

| Name                      | Description                                                                                                                                                                                    | Value |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `license.type`            | License type. Should be auto generated with `dgctl pull --generate-values`.                                                                                                                    | `""`  |
| `license.updatePeriod`    | Duration how often service should fetch new license from storage. Duration format is any string supported by (time.ParseDuration)[https://pkg.go.dev/time#ParseDuration].                      | `1h`  |
| `license.retryPeriod`     | Duration how often service should try to fetch license from storage if previous attempts were failing.                                                                                         | `30s` |
| `license.softBlockPeriod` | Duration until the license expiration time when license service should respond with 'soft' block status. For this duration additional time units 'd' for days and 'w' for weeks are supported. | `2w`  |

### Service settings

| Name                  | Description                                                                                                                    | Value       |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). | `ClusterIP` |
| `service.statusPort`  | Service port for status page and api/v1 (HTTP).                                                                                | `80`        |
| `service.apiPort`     | Service port for api/v2 (HTTPS).                                                                                               | `443`       |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).              | `{}`        |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).                        | `{}`        |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                           | Description                               | Value                 |
| ------------------------------ | ----------------------------------------- | --------------------- |
| `ingress.className`            | Name of the Ingress controller class.     | `nginx`               |
| `ingress.enabled`              | If Ingress is enabled for the service.    | `true`                |
| `ingress.hosts.host`           | Hostname for the Ingress service.         | `license.example.com` |
| `ingress.hosts.paths.path`     | Path of the host for the Ingress service. | `/`                   |
| `ingress.hosts.paths.pathType` | Type of the path for the Ingress service. | `Prefix`              |
| `ingress.tls`                  | TLS configuration                         | `[]`                  |

### Limits

| Name                        | Description       | Value   |
| --------------------------- | ----------------- | ------- |
| `resources.requests.cpu`    | A CPU request.    | `500m`  |
| `resources.requests.memory` | A memory request. | `128Mi` |
| `resources.limits.cpu`      | A CPU limit.      | `1`     |
| `resources.limits.memory`   | A memory limit.   | `512Mi` |

### Persistence

| Name                              | Description                                                                                            | Value   |
| --------------------------------- | ------------------------------------------------------------------------------------------------------ | ------- |
| `persistence.type`                | Type of storage used for persistence, should be one of: 's3' - for S3 storage, 'fs' - for PVC storage. | `s3`    |
| `persistence.fs`                  | **PVC setting for the 'fs' persistence type**                                                          |         |
| `persistence.fs.storage`          | Storage size, should be at least 10Mi.                                                                 | `10Mi`  |
| `persistence.fs.storageClassName` | Storage class name.                                                                                    | `""`    |
| `persistence.s3`                  | **S3 setting for the 's3' persistence type**                                                           |         |
| `persistence.s3.host`             | S3 endpoint. Format: `host:port`.                                                                      | `""`    |
| `persistence.s3.secure`           | If S3 uses https.                                                                                      | `false` |
| `persistence.s3.bucket`           | S3 bucket name.                                                                                        | `""`    |
| `persistence.s3.root`             | Root directory in S3 bucket.                                                                           | `""`    |
| `persistence.s3.accessKey`        | S3 access key for accessing the bucket.                                                                | `""`    |
| `persistence.s3.secretKey`        | S3 secret key for accessing the bucket.                                                                | `""`    |

### TPM-related settings for license type 2

| Name                           | Description                                                                                                                                                               | Value   |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `tpm.securityContext`          | Main container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/). Should enable access to the host TPM device (/dev/tpmrm0). | `{}`    |
| `tpm.mountTPMDevice`           | If TPM device should be mounted to the main container. Required if no TPM device plugin is used. Additionally, requires privileged access for the main container.         | `false` |
| `tpm.pvcBind`                  | **Kubernetes PVC used to bind pod to the kubernetes node; not needed if FS persistence is used**                                                                          |         |
| `tpm.pvcBind.enable`           | If PVC should be used to bind pod to the kubernetes node.                                                                                                                 | `false` |
| `tpm.pvcBind.storageClassName` | Storage class name.                                                                                                                                                       | `""`    |
