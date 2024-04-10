# generic-chart

Library Chart with common templates.

## Getting started

Add dependency to a subject chart:

```yml
dependencies:
  - name: generic-chart
    version: "*"
    repository: file://../generic-chart
```

Include templates as-is, e.g. VPA:

```go
{{- template "generic-chart.vpa.tpl" . }}
```

For other templates re-use named definitions as follows:

* wherever common things expected use named definitions from this library:

     ```go
     {{ include "generic-chart.fullname" . }}
     ```

  * release fullname: `generic-chart.fullname`
  * list of labels: `generic-chart.labels`
  * selectors: `generic-chart.selectorLabels`
  * service account: `generic-chart.serviceAccountName`
* common "functions":
  * pass text through template renderer: `tplvalues.render`

## Configuration

Below are supported parameters.

### Values

#### Common settings

| Name               | Description                                                                 | Value |
| ------------------ | --------------------------------------------------------------------------- | ----- |
| `nameOverride`     | Base name to use in all the Kubernetes entities deployed by this chart.     | `""`  |
| `fullnameOverride` | Base fullname to use in all the Kubernetes entities deployed by this chart. | `""`  |

#### Deployment settings

| Name                            | Description                                                                                                                          | Value |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ----- |
| `labels`                        | Custom labels to set to Deployment resource                                                                                          | `{}`  |
| `annotations`                   | Custom annotations to set to Deployment resource                                                                                     | `{}`  |
| `replicaCount`                  | A replica count for the pod                                                                                                          | `1`   |
| `revisionHistoryLimit`          | Number of replica sets to keep for deployment rollbacks                                                                              | `1`   |
| `strategy`                      | Deployment [strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy). Undergoes template rendering  | `{}`  |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)                         | `{}`  |
| `imagePullSecrets`              | Kubernetes image pull secrets                                                                                                        | `[]`  |
| `podSecurityContext`            | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)                        | `{}`  |
| `priorityClassName`             | Kubernetes [Pod Priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass) class name | `""`  |
| `terminationGracePeriodSeconds` | Maximum time allowed for graceful shutdown                                                                                           | `60`  |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)                   | `{}`  |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity)           | `{}`  |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings                     | `[]`  |

#### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                    | Description                                                                                                                                                         | Value   |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                           | If HPA is enabled for the service                                                                                                                                   | `false` |
| `hpa.minReplicas`                       | Lower limit for the number of replicas to which the autoscaler can scale down                                                                                       | `1`     |
| `hpa.maxReplicas`                       | Upper limit for the number of replicas to which the autoscaler can scale up                                                                                         | `100`   |
| `hpa.scaleDown`                         | Scale-down settings structure                                                                                                                                       | `{}`    |
| `hpa.scaleUp`                           | Scale-up settings structure                                                                                                                                         | `{}`    |
| `hpa.targetCPUUtilizationPercentage`    | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used       | `80`    |
| `hpa.targetMemoryUtilizationPercentage` | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used | `""`    |

#### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                    | Description                                                                                                 | Value   |
| ----------------------- | ----------------------------------------------------------------------------------------------------------- | ------- |
| `vpa.enabled`           | If VPA is enabled for the service                                                                           | `false` |
| `vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start) | `Auto`  |
| `vpa.containerName`     | Name of a container to measure utilization for                                                              | `""`    |
| `vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down                                   |         |
| `vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down                                         |         |
| `vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up                                     |         |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up                                           |         |

#### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                          | Value   |
| -------------------- | ---------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service.                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`     |

#### Service settings

| Name                  | Description                                                                                                                                    | Value       |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/). Undergoes template rendering           | `{}`        |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/). Undergoes template rendering | `{}`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                 | `ClusterIP` |
| `service.clusterIP`   | Controls Service cluster IP allocation. Cannot be changed after resource creation.                                                             | `""`        |
| `service.port`        | Service port.                                                                                                                                  | `80`        |

#### Service account settings

| Name                         | Description                                                                                                             | Value  |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                                                  | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account.                                                                              | `{}`   |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`   |
