# 2GIS Tiles API service

Use this Helm chart to deploy Tiles API service, which is a part of 2GIS's [On-Premise Maps services](https://docs.2gis.com/en/on-premise/map).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/map) to learn how to:

- Install the service.

    When filling in the keys for `values-tiles.yaml` configuration file, refer to the documentation and the list of keys below.

- Update the service.

## Values

| Key                                                       | Type          | Default value | Description   |
|-----------------------------------------------------------|---------------|---------------|---------------|
| <h3>**Tiles API deployment configuration**</h3>                      |
| name                                                      | string        | `"tiles-api"` | Name of the deployment |
| serviceName                                               | string        | `"tiles-api-webgl"`       | Name of the service. It depends on the [deployment configuration](https://docs.2gis.com/en/on-premise/map#nav-lvl1--Architecture): <ul><li>`tiles-api-webgl` for Tiles API with vector tiles support.</li><li>`tiles-api-raster` for Tiles API with raster tiles support.</li><ul> |
| type                                                      | string        | `""`                      | Type of the [deployment configuration](https://docs.2gis.com/en/on-premise/map#nav-lvl1--Architecture): <ul><li>An empty string for Tiles API with vector tiles support.</li><li>`raster` for Tiles API with raster tiles support.</li><ul> | |
| <h3>**Docker Registry**</h3>                                                                                                                          |
| dgctlDockerRegistry                                       | string        | `""`                      | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`.   |
| <h3>**Deployment Artifacts Storage**</h3>                                                                                                                                                     |
| dgctlStorage.host                                         | string        | `""`                      | S3 endpoint. Format: `host:port`. |
| dgctlStorage.bucket                                       | string        | `""`                      | S3 bucket name. |
| dgctlStorage.accessKey                                    | string        | `""`                      | S3 access key for accessing the bucket. |
| dgctlStorage.secretKey                                    | string        | `""`                      | S3 secret key for accessing the bucket. |
| dgctlStorage.manifest                                     | string        | `""`                      | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2--Common_deployment_steps). Format: `manifests/0000000000.json`.<br>This file contains the description of pieces of data that the service requires to operate. |
| <h3>**Apache Cassandra Data Storage**</h3>                                                                                                                                                    |
| cassandra.consistencyLevelRead                            | string        | `"LOCAL_QUORUM"`          | [Write consistency level](https://docs.datastax.com/en/cassandra-oss/3.0/cassandra/dml/dmlConfigConsistency.html#Readconsistencylevels).|
| cassandra.consistencyLevelWrite                           | string        | `"LOCAL_QUORUM"`          | [Read consistency level](https://docs.datastax.com/en/cassandra-oss/3.0/cassandra/dml/dmlConfigConsistency.html#Writeconsistencylevels) |
| cassandra.credentials                                     | object        | `{"password":"cassandra","user":"cassandra"}` | Credentials for accessing Apache Cassandra. |
| cassandra.hosts                                           | list          | `[]`                      | An array of the one of more IP adresses or hostnames of the Apache Cassandra installation. |
| cassandra.replicaFactor                                   | int           | `3`                       | Apache Cassandra [replication factor](https://docs.datastax.com/en/cassandra-oss/3.0/cassandra/architecture/archDataDistributeReplication.html). |
| <h3>**Tiles API service**</h3>                                                                                                                                     |
| **api.hpa**                                               |           |    | Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings.                         |
| api.hpa.enabled                                           | bool          | `false`                   | If HPA is enabled for the service. |
| api.hpa.maxReplicas                                       | int           | `1`                       | Upper limit for the number of replicas to which the autoscaler can scale up |
| api.hpa.minReplicas                                       | int           | `1`                       | Lower limit for the number of replicas to which the autoscaler can scale down |
| api.hpa.targetCPUUtilizationPercentage                    | int           | `50`                      | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used. |
| **api.vpa**                                               |         |      | Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings. |
| api.vpa.enabled                                           | bool          | `false`                   | If VPA is enabled for the service.  |
| api.vpa.maxAllowed.cpu                                    | int           | `1`                       | Upper limit for the number of CPUs to which the autoscaler can scale up |
| api.vpa.maxAllowed.memory                                 | string        | `"512Mi"`                 | Upper limit for the RAM size to which the autoscaler can scale up |
| api.vpa.minAllowed.memory                                 | string        | `"128Mi"`                 | Upper limit for the RAM size to which the autoscaler can scale down |
| api.vpa.updateMode                                        | string        | `"Auto"`                  | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start) |
| **api.ingress**                                           |      |         | Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings. |
| api.ingress.enabled                                       | bool          | `false`                   | If Ingress is enabled for the service. |
| api.ingress.className                                     | string        | `"nginx"`                 | Name of the `IngressClass` cluster resource. The associated `IngressClass` defines which controller will implement the Ingress resource. |
| api.ingress.hosts[0].host                                 | string        | `"tiles-api.loc"`         | Fully qualified domain name of the Tiles API service. |
| api.ingress.hosts[0].paths[0].path                        | string        | `"/"`                     | Path to associate the Tiles API service with. |
| api.ingress.tls                                           | list          | `[]`                      | [TLS settings](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls) for Ingress. |
| **api.pdb**                                               |      |         | Kubernetes [pod diruption budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings. |
| api.pdb.enabled                                           | bool          | `true`                    | If PDB is enabled for the service. |
| api.pdb.maxUnavailable                                    | int           | `1`                       | How many pods must always be available, even during a disruption. |
| **api.resources**                                        |     |          | Kubernetes [resource management settings](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for the Tiles API service pod. |
| api.resources.limits.cpu                                  | int           | `1`                       | A CPU limit. |
| api.resources.limits.memory                               | string        | `"512Mi"`                 | A memory limit. |
| api.resources.requests.cpu                                | string        | `"50m"`                   | A CPU request. |
| api.resources.requests.memory                             | string        | `"128Mi"`                 | A memory request. |
| **api.service**                                           |      |         | Kubernetes [service settings](https://kubernetes.io/docs/concepts/services-networking/service/) to expose the Tiles API service. |
| api.service.annotations                                   | object        | `{}`                      | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).  |
| api.service.labels                                        | object        | `{}`                      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/). |
| api.service.port                                          | int           | `80`                      | Tiles API service port. |
| api.service.type                                          | string        | `"ClusterIP"`             | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). |
| **Miscellaneous settings**          |               |                | Other settings.              |
| api.labels                                                | object        | `{}`                      | Kubernetes [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/). |
| api.affinity                                              | object        | `{}`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). |
| api.annotations                                           | object        | `{}`                      | Kubernetes [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/). |
| api.nodeSelector                                          | object        | `{}`                      | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector). |
| api.containerPort                                         | int           | `8000`                    | Tiles API container port. |
| api.image                                                 | string        | `"on-premise/tiles-api"`  | The path to the Docker image. This image must exist in the Docker Registry, specified in the `dgctlDockerRegsitry` key. |
| api.imagePullSecrets                                      | object        | `{}`                      | A list of references to secrets to use for [pulling any images from the Docker Registry](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod), specified in the `dgctlDockerRegsitry` key. |
| api.podAnnotations                                        | object        | `{}`                      | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/). |
| api.podLabels                                             | object        | `{}`                      | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/). |
| api.pullPolicy                                            | string        | `"IfNotPresent"`          | Kubernetes [image pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) for pulling the services' images. |
| api.replicaCount                                          | int           | `3`                       | A replica count for the pod. |
| api.revisionHistory                                       | int           | `1` | Revision history limit (used for [rolling back](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) a deployment). |
| api.strategy.rollingUpdate.maxSurge                       | int           | `1`                       | Maximum number of pods that can be created over the desired number of pods when doing [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment). |
| api.strategy.rollingUpdate.maxUnavailable                 | int           | `0`                       | Maximum number of pods that can be unavailable during the [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment) process. |
| api.tag                                                   | string        | `"v4.19.0"`               | Tag with Tiles API service version. |
| api.terminationGracePeriodSeconds                         | int           | `30`                      | Duration in seconds the Tiles API service pod needs to terminate gracefully. |
| api.tolerations                                           | object        | `{}`                      | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings. |
| <h3>**Kubernetes Importer job**                                                                                      |
| **importer.resources**</h3> |                                  |               | Kubernetes [resource management settings](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for the Importer job.
| importer.resources.limits.cpu                             | string        | `"100m"`                  | A CPU limit. |
| importer.resources.limits.memory                          | string        | `"256Mi"`                 | A memory limit. |
| importer.resources.requests.cpu                           | string        | `"50m"`                   | A CPU request. |
| importer.resources.requests.memory                        | string        | `"128Mi"`                 | A memory request. |
| **Worker settings**                                       |    |           | [Workers settings](https://kubernetes.io/docs/concepts/workloads/controllers/job/) for the Importer job. |
| importer.workerNum                                        | int           | `6`                       | Number of parallel import processes (spawned jobs) |
| importer.workerResources.limits.cpu                       | int           | `2`                       | A CPU limit. |
| importer.workerResources.limits.memory                    | string        | `"2048Mi"`                | A memory limit. |
| importer.workerResources.requests.cpu                     | string        | `"256m"`                  | A CPU request. |
| importer.workerResources.requests.memory                  | string        | `"512Mi"`                 | A memory request. |
| importer.writerNum                                        | int           | `8`                       | Number of writer processes per import process |
| **Miscellaneous settings**                                |               |               | Other settings.               |
| importer.enabled                                          | bool          | `true`                    | If Importer job is enabled. |
| importer.image                                            | string        | `"on-premise/tiles-api-importer"` | The path to the Docker image. This image must exist in the Docker Registry, specified in the `dgctlDockerRegsitry` key. |
| importer.imagePullSecrets                                 | object        | `{}`                      | A list of references to secrets to use for [pulling any images from the Docker Registry](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod), specified in the `dgctlDockerRegsitry` key. |
| importer.nodeSelector                                     | object        | `{}`                      | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector). |
| importer.pullPolicy                                       | string        | `"IfNotPresent"`          | Kubernetes [image pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) for pulling the services' images. |
| importer.tag                                              | string        | `"v4.19.0"`               | Tag with Importer job version. |
| importer.tolerations                                      | object        | `{}`                      | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings. |
| <h3>**Proxy to access the API Keys service**</h3>                                                                          |
| **proxy.resources**                                       |      |         | Kubernetes [resource management settings](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for the proxy. |
| proxy.resources.limits.cpu                                | int           | `1`                       | A CPU limit. |
| proxy.resources.limits.memory                             | string        | `"512Mi"`                 | A memory limit. |
| proxy.resources.requests.cpu                              | string        | `"50m"`                   | A CPU request. |
| proxy.resources.requests.memory                           | string        | `"128Mi"`                 | A memory request. |
| **Miscellaneous settings**                                |               |                  | Other settings.            |
| proxy.access.enabled                                      | bool          | `false`                           | If access to the [API Keys service](https://docs.2gis.com/en/on-premise/keys) is enabled. |
| proxy.access.host                                         | string        | `"http://keys-api.localhost"`     | API Keys endpoint hostname. |
| proxy.access.token                                        | string        | `""`                              | [Service key](https://docs.2gis.com/en/on-premise/keys#nav-lvl1--Fetching_the_service_API_keys) for accessing Keys API. |
| proxy.containerPort                                       | int           | `5000`                            | Proxy container port. |
| proxy.image                                               | string        | `"on-premise/tiles-api-proxy"`    | The path to the Docker image. This image must exist in the Docker Registry, specified in the `dgctlDockerRegsitry` key. |
| proxy.tag                                                 | string        | `"v4.19.0"`                       | Tag with proxy version. |
| proxy.timeout                                             | string        | `"5s"`                            | Proxy timeout, in seconds. |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | on-premise@2gis.com | https://github.com/2gis |
