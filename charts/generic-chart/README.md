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

## Test chart

Test chart based on generic-chart is located in resources.

Chart is tested using [pipeline](https://gitlab.2gis.ru/traffic/cicd-pipelines/-/blob/master/pipelines/single-chart.yml). See `.gitlab-ci.yml`.

## Values

### Common settings

| Name               | Description                                                                 | Value |
| ------------------ | --------------------------------------------------------------------------- | ----- |
| `nameOverride`     | Base name to use in all the Kubernetes entities deployed by this chart.     | `""`  |
| `fullnameOverride` | Base fullname to use in all the Kubernetes entities deployed by this chart. | `""`  |

### [Deployment](https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/) settings

| Name                            | Description                                                                                                                                  | Value   |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `labels`                        | Custom labels to set to Deployment resource                                                                                                  | `{}`    |
| `annotations`                   | Custom annotations to set to Deployment resource                                                                                             | `{}`    |
| `replicaCount`                  | A replica count for the pod                                                                                                                  | `1`     |
| `revisionHistoryLimit`          | Number of replica sets to keep for deployment rollbacks                                                                                      | `1`     |
| `strategy`                      | Deployment [strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy). Undergoes template rendering          | `{}`    |
| `podAnnotations`                | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)                                 | `{}`    |
| `imagePullSecrets`              | Kubernetes image pull secrets                                                                                                                | `[]`    |
| `podSecurityContext`            | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)                                | `{}`    |
| `priorityClassName`             | Kubernetes [Pod Priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass) class name         | `""`    |
| `terminationGracePeriodSeconds` | Maximum time allowed for graceful shutdown                                                                                                   | `60`    |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)                           | `{}`    |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity)                   | `{}`    |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings                             | `[]`    |
| `enableServiceLinks`            | Services injection into containers environment                                                                                               | `false` |
| `restartPolicy`                 | Kubernetes pod [restart policy](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy)                            | `""`    |
| `updateStrategy`                | Kubernetes StatefulSet [update strategy](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies)           | `{}`    |
| `volumeClaimTemplates`          | Kubernetes StatefulSet [volue claim template](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#volume-claim-templates) | `[]`    |

### Kubernetes [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) settings

| Name                                    | Description                                                                                                                                                         | Value   |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `hpa.enabled`                           | If HPA is enabled for the service                                                                                                                                   | `false` |
| `hpa.minReplicas`                       | Lower limit for the number of replicas to which the autoscaler can scale down                                                                                       | `1`     |
| `hpa.maxReplicas`                       | Upper limit for the number of replicas to which the autoscaler can scale up                                                                                         | `100`   |
| `hpa.scaleDown`                         | Scale-down settings structure                                                                                                                                       | `{}`    |
| `hpa.scaleUp`                           | Scale-up settings structure                                                                                                                                         | `{}`    |
| `hpa.targetCPUUtilizationPercentage`    | Target average CPU utilization (represented as a percentage of requested CPU) over all the pods; if not specified the default autoscaling policy will be used       | `80`    |
| `hpa.targetMemoryUtilizationPercentage` | Target average memory utilization (represented as a percentage of requested memory) over all the pods; if not specified the default autoscaling policy will be used | `""`    |

### Kubernetes [Vertical Pod Autoscaling](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md) settings

| Name                    | Description                                                                                                 | Value          |
| ----------------------- | ----------------------------------------------------------------------------------------------------------- | -------------- |
| `vpa.enabled`           | If VPA is enabled for the service                                                                           | `false`        |
| `vpa.updateMode`        | VPA [update mode](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#quick-start) | `Auto`         |
| `vpa.containerName`     | Name of a container to measure utilization for                                                              | `""`           |
| `vpa.controlledValues`  | Controlled values, one of: RequestsOnly or RequestsAndLimits                                                | `RequestsOnly` |
| `vpa.minAllowed.cpu`    | Lower limit for the number of CPUs to which the autoscaler can scale down                                   |                |
| `vpa.minAllowed.memory` | Lower limit for the RAM size to which the autoscaler can scale down                                         |                |
| `vpa.maxAllowed.cpu`    | Upper limit for the number of CPUs to which the autoscaler can scale up                                     |                |
| `vpa.maxAllowed.memory` | Upper limit for the RAM size to which the autoscaler can scale up                                           |                |

### Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

| Name                 | Description                                          | Value   |
| -------------------- | ---------------------------------------------------- | ------- |
| `pdb.enabled`        | If PDB is enabled for the service.                   | `false` |
| `pdb.minAvailable`   | How many pods must be available after the eviction.  | `""`    |
| `pdb.maxUnavailable` | How many pods can be unavailable after the eviction. | `1`     |

### [Service](https://kubernetes.io/docs/concepts/services-networking/service/) settings

| Name                  | Description                                                                                                                                    | Value       |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `service.labels`      | Kubernetes [service labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/). Undergoes template rendering           | `{}`        |
| `service.annotations` | Kubernetes [service annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/). Undergoes template rendering | `{}`        |
| `service.type`        | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).                 | `ClusterIP` |
| `service.clusterIP`   | Controls Service cluster IP allocation. Cannot be changed after resource creation.                                                             | `""`        |
| `service.port`        | Service port.                                                                                                                                  | `80`        |
| `service.nodePort`    | Node port if type NodePort.                                                                                                                    | `nil`       |

### Kubernetes [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) settings

| Name                                 | Description                               | Value                       |
| ------------------------------------ | ----------------------------------------- | --------------------------- |
| `ingress.enabled`                    | If Ingress is enabled for the service.    | `false`                     |
| `ingress.className`                  | Name of the Ingress controller class.     | `nginx`                     |
| `ingress.hosts[0].host`              | Hostname for the Ingress service.         | `generic-chart.example.com` |
| `ingress.hosts[0].paths[0].path`     | Path of the host for the Ingress service. | `/`                         |
| `ingress.hosts[0].paths[0].pathType` | Type of the path for the Ingress service. | `Prefix`                    |
| `ingress.tls`                        | TLS configuration                         | `[]`                        |

### [Service account](https://kubernetes.io/docs/concepts/security/service-accounts/) settings

| Name                         | Description                                                                                                             | Value  |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                                                  | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account.                                                                              | `{}`   |
| `serviceAccount.name`        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`   |

### [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) settings

| Name                                 | Description                                                     | Value   |
| ------------------------------------ | --------------------------------------------------------------- | ------- |
| `cronJob.suspend`                    | Suspend execution of Jobs.                                      | `false` |
| `cronJob.schedule`                   | Schedule follows the Cron syntax.                               | `""`    |
| `cronJob.startingDeadlineSeconds`    | Defines a deadline (in whole seconds) for starting the Job.     | `""`    |
| `cronJob.concurrencyPolicy`          | Concurrent executions of a Job that is created by this CronJob. | `""`    |
| `cronJob.successfulJobsHistoryLimit` | How many completed Jobs should be kept.                         | `""`    |
| `cronJob.failedJobsHistoryLimit`     | How many failed Jobs should be kept.                            | `""`    |

### [Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/) settings

| Name                          | Description                                                                                                       | Value |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----- |
| `job.activeDeadlineSeconds`   | Number of seconds active deadline.                                                                                | `""`  |
| `job.ttlSecondsAfterFinished` | A time-to-live mechanism to clean up old Jobs that have finished execution.                                       | `""`  |
| `job.backoffLimit`            | Number of retries before considering a Job as failed.                                                             | `""`  |
| `job.backoffLimitPerIndex`    | Maximal number of pod failures per index.                                                                         | `""`  |
| `job.podFailurePolicy`        | Pod failure policy.                                                                                               | `""`  |
| `job.completions`             | Number of successful pods for completion Job.                                                                     | `""`  |
| `job.completionMode`          | Completion mode (NonIndexed or Indexed).                                                                          | `""`  |
| `job.parallelism`             | Number of pods running at any instant.                                                                            | `""`  |
| `job.restartPolicy`           | Kubernetes pod [restart policy](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy) | `""`  |

### Network Policy configuration

| Name                                               | Description                                                  | Value   |
| -------------------------------------------------- | ------------------------------------------------------------ | ------- |
| `networkPolicy.ingress.enabled`                    | Enable creation of NetworkPolicy resources for ingress rules | `false` |
| `networkPolicy.ingress.explicitNamespacesSelector` | Explict namespace selector for default rule ingress          | `{}`    |
| `networkPolicy.ingress.additionalRules`            | Array of additional ingress rules                            | `[]`    |
| `networkPolicy.egress.enabled`                     | Enable creation of NetworkPolicy resources for egress rules  | `false` |
| `networkPolicy.egress.config`                      | Array of egress rules                                        | `[]`    |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
