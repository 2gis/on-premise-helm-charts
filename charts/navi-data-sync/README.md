# NaviDataSync Helm Chart

## Описание
Чарт устанавливает экземпляр приложения NaviDataSync, который управляет группой
сервисов navi-back и navi-attractor, синхронизируемых по данным между собой.

Темплейты и релизные параметры дочерних чартов сохраняются в ConfigMap и используются
при установке и обновлении управляемой группы.

Установка управляемой группы производится синхронной при установке чарта NaviDataSync в
`post-install`, `post-upgrade` или `post-rollback` хуках.

Удаление управляемой группы производится синхронно при удалении чарта NaviDataSync тоже
Helm хуком, но при этом возможные ошибки не влияют на успешность удаления чарта.

Используемый service account должен иметь права на управление ресурсами Kubernetes в
своём неймспейсе.

Горизонтальное масштабирование NaviDataSync не реализовано. Чарт гарантирует
исключительную работу единственного экземпляра с заданной группой при
использовании стандартного функционала `helm`.
При попытке параллельного запуска на одной группе в одном неймспейсе
результат непредсказуем.

Директория `resources/` используется для хранения тех файлов, к которым
необходим доступ рендеру темплейта:

- темплейты дочерних чартов в виде `tar.gz` пакетов (стандартный формат `helm package`)
- релизные параметры дочерних чартов, т.е. их `values.yaml`

Также передача содержимого этих файлов предусмотрена через параметры
запуска `helm`, в таком случае файлы в `resources/` не подкладываются.

Изначально `resources/` содержит используемые при тестировании значения. Необязательны.

## Установка

Поместить `helm package` для `navi-back` и `navi-attractor` в `resources/` с именами:
`navi-back.tgz` и `navi-attractor.tgz` соответственно.

Поместить релизные значения для них в `resources/` с именами:
`navi-back.values.yaml` и `navi-attractor.values.yaml` соответственно.

Они должны быть согласованы по списку проектов, имени группы (`dataGroup.prefix`) и
используемым протоколам взаимодействия (GRPC или WebSockets).
Имя сервиса атрактора будет передано в `navi-back` автоматически.

Для примера используется `dataGroup.prefix=test_group`:

```
helm upgrade --install test-navi-data-sync . --set dataGroup.prefix=test_group --wait-for-jobs --timeout 60m
```

## Values

### Docker Registry settings

| Name                  | Description                                                                             | Value |
| --------------------- | --------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`. | `""`  |

### Common settings

| Name               | Description                                                                 | Value |
| ------------------ | --------------------------------------------------------------------------- | ----- |
| `nameOverride`     | Base name to use in all the Kubernetes entities deployed by this chart.     | `""`  |
| `fullnameOverride` | Base fullname to use in all the Kubernetes entities deployed by this chart. | `""`  |

### Service account settings

| Name                               | Description                                                                                                             | Value   |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`            | Specifies whether a service account should be created.                                                                  | `false` |
| `serviceAccount.annotations`       | Annotations to add to the service account.                                                                              | `{}`    |
| `serviceAccount.name`              | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |
| `serviceAccount.deleteHook.create` | If SA for delete hook should be created.                                                                                | `false` |
| `serviceAccount.deleteHook.name`   | SA name for delete hook. Auto generated based on main SA if empty.                                                      | `""`    |

### RBAC settings

| Name                     | Description                                                | Value   |
| ------------------------ | ---------------------------------------------------------- | ------- |
| `rbac.create`            | Specifies whether a role and roleBinding should be created | `false` |
| `rbac.annotations`       | Annotations to add the role and roleBinding                | `{}`    |
| `rbac.labels`            | Role and RoleBinding additional labels                     | `{}`    |
| `rbac.deleteHook.create` | If create RBAC for deleteHook                              | `false` |

### Container image settings

| Name               | Description | Value                            |
| ------------------ | ----------- | -------------------------------- |
| `image.repository` | Repository  | `2gis-on-premise/navi-data-sync` |
| `image.tag`        | Tag         | `""`                             |
| `image.pullPolicy` | Pull Policy | `IfNotPresent`                   |

### Deployment settings

| Name                            | Description                                                                                                                          | Value  |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------ |
| `annotations`                   | Custom annotations to set to Deployment resource                                                                                     | `{}`   |
| `labels`                        | Custom labels to set to Deployment resource                                                                                          | `{}`   |
| `podAnnotations`                | Custom annotations to set to Pod resource                                                                                            | `{}`   |
| `podLabels`                     | Custom annotations to set to Pod resource                                                                                            | `{}`   |
| `imagePullSecrets`              | Kubernetes image pull secrets                                                                                                        | `[]`   |
| `affinity`                      | Kubernetes pod [affinity settings](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity)           | `{}`   |
| `nodeSelector`                  | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)                   | `{}`   |
| `tolerations`                   | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings                     | `[]`   |
| `priorityClassName`             | Kubernetes [Pod Priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass) class name | `""`   |
| `podSecurityContext`            | Kubernetes [pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)                        | `{}`   |
| `securityContext`               | Security context for containers                                                                                                      | `{}`   |
| `terminationGracePeriodSeconds` | Maximum time allowed for graceful shutdown                                                                                           | `120`  |
| `helmMaxHistory`                | Maximum number of child Helm releases kept in history                                                                                | `10`   |
| `helmTimeout`                   | Timeout for Helm operations                                                                                                          | `40m`  |
| `activeDeadlineSeconds`         | Maximum allowed jobs duration                                                                                                        | `4800` |
| `backoffLimit`                  | Number of retries for each job until failing the execution                                                                           | `6`    |

### Schedule settings

| Name                         | Description                                                      | Value          |
| ---------------------------- | ---------------------------------------------------------------- | -------------- |
| `randomSchedule.enabled`     | If randomization of cron schedule and NaviDataSync start enabled | `true`         |
| `randomSchedule.maxDelaySec` | Maximum jobs delay. Set 0 for no delay                           | `300`          |
| `randomSchedule.specific`    | Specific schedule used when randomSchedule.enabled=false         | `*/10 * * * *` |

### Limits

| Name                        | Description                                 | Value       |
| --------------------------- | ------------------------------------------- | ----------- |
| `resources`                 | Container resources requirements structure. | `{}`        |
| `resources.requests.cpu`    | CPU request, recommended value `1000m`.     | `undefined` |
| `resources.requests.memory` | Memory request, recommended value `2Gi`.    | `undefined` |
| `resources.limits.cpu`      | CPU limit, recommended value `3000m`.       | `undefined` |
| `resources.limits.memory`   | Memory limit, recommended value `8Gi`.      | `undefined` |

### Instance settings

| Name               | Description                                                                                                      | Value         |
| ------------------ | ---------------------------------------------------------------------------------------------------------------- | ------------- |
| `dataGroup.prefix` | common prefix for the group used for identifiers                                                                 | `sampleGroup` |
| `navigroup`        | Navigation group identifier                                                                                      | `""`          |
| `type`             | Deployment mode: `back` (navi-back) or `attr` (attractor)                                                        | `back`        |
| `castleUrl`        | URL of Navi-Castle service. <br> This URL should be accessible from all the pods within your Kubernetes cluster. | `""`          |
| `citiesPb3Conf`    | If true, Attractor and Back use protobuf3 Cities config                                                          | `false`       |
| `projects`         | List of projects to refresh data for. Leave empty for all available projects on Castle.                          | `[]`          |
| `routing`          | List of routing types to refresh data for. Leave empty for all available ones.                                   | `[]`          |
| `fixedTimestamp`   | Fixed timestamp to use instead of querying Castle for the latest.                                                | `""`          |

### Metrics settings

| Name              | Description                          | Value         |
| ----------------- | ------------------------------------ | ------------- |
| `metrics.enabled` | If pushing metrics from Jobs enabled | `false`       |
| `metrics.gateway` | URL to metrics push gateway          | `example.com` |
| `metrics.labels`  | Additional labels for metrics        | `{}`          |

### Navi Attractor sub-chart settings

| Name                                  | Description                                                                                | Value                          |
| ------------------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------ |
| `naviAttractor.releaseName`           | Helm release name for the child                                                            | `navi-attr`                    |
| `naviAttractor.values`                | Helm installation values for the child                                                     | `undefined`                    |
| `naviAttractor.values.image`          | Image for the child deployment                                                             | `undefined`                    |
| `naviAttractor.valuesString`          | Array of value files supplied with --set-file                                              | `""`                           |
| `naviAttractor.templateFilename`      | Child chart package filename. `templateContentBase64` takes precedence if set.             | `resources/navi-attractor.tgz` |
| `naviAttractor.templateContentBase64` | Child chart tar.gz package Base64 encoded. If set,takes precedence over `templateFilename` | `""`                           |

### Navi Backend sub-chart settings

| Name                             | Description                                                                                | Value                     |
| -------------------------------- | ------------------------------------------------------------------------------------------ | ------------------------- |
| `naviBack.releaseName`           | Helm release name for the child                                                            | `navi-back`               |
| `naviBack.values`                | Helm installation values for the child                                                     | `undefined`               |
| `naviBack.values.image`          | Image for the child deployment                                                             | `undefined`               |
| `naviBack.valuesString`          | Array of value files supplied with --set-file                                              | `""`                      |
| `naviBack.templateFilename`      | Child chart package filename. `templateContentBase64` takes precedence if set.             | `resources/navi-back.tgz` |
| `naviBack.templateContentBase64` | Child chart tar.gz package Base64 encoded. If set,takes precedence over `templateFilename` | `""`                      |

### SNS data source

| Name                   | Description                                                       | Value     |
| ---------------------- | ----------------------------------------------------------------- | --------- |
| `sns.enabled`          | If SNS provides data instead of Castle, `castleUrl` refers to SNS | `false`   |
| `sns.rulesId.projects` | Projects list identifier segment in SNS path                      | `""`      |
| `sns.rulesId.routing`  | Routing list identifier segment in SNS path                       | `""`      |
| `sns.rulesId.prefix`   | Arbitrary prefix to be added to SNS paths                         | `default` |

### Metadata settings

| Name          | Description                                                                                                  | Value |
| ------------- | ------------------------------------------------------------------------------------------------------------ | ----- |
| `blobVersion` | Blob version string. When set, init container is disabled and this value is passed directly to NaviDataSync. | `""`  |


| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
