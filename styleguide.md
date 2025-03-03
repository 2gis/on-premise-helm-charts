# Styleguide

В этом документе описаны общие принципы, которым нужно следовать при разработке helm-чартов.

## Структура файлов

Мы следуем [официальным best practices для helm-чартов](https://helm.sh/docs/chart_best_practices/conventions/).

## Генерация README.md

Файлы `README.md` формируются полуавтоматически. Для каждого чарта сначала необходимо создать файл `README.md` с общим описанием сервиса и пустым разделом «Values», а затем запустить инструмент [`readme-generator-for-helm`](https://github.com/bitnami-labs/readme-generator-for-helm) от Bitnami, чтобы автоматически заполнить раздел «Values» описаниями настроек на основе комментариев из `values.yaml`. Подробнее об использовании генератора можно прочитать в [документе](https://docs.google.com/document/d/1iEPG8tcCYu9q5iZssTAPOd43xh8uCQhNXyXhFPUTir8/edit).

Генератор можно запускать напрямую или с помощью [`Makefile`](Makefile) (лучше это делать на linux. На windows были замечены проблемы с лишними пустыми строками при генерации README.md), например:

```sh
make prepare
make charts/navi-back
```

## Описание настроек

- В каждом чарте должна быть секция под названием «Docker registry settings». В ней должны быть описаны `dgctlDockerRegistry` и другие настройки, связанные с получением Docker-образов.

  ```yaml
  # @param dgctlDockerRegistry Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`.
  # @param imagePullSecrets Kubernetes image pull secrets.
  # @param imagePullPolicy Pull policy.
  # @param ui.image.repository UI service image repository.
  # @param ui.image.tag UI service image tag.

  dgctlDockerRegistry: ''
  imagePullSecrets: []
  imagePullPolicy: IfNotPresent
  ```

- В заголовке каждого блока k8s-специфичных настроек необходимо ставить ссылку на соответствующий раздел официальной документации.

  ```yaml
  # @section Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings

  # @param pdb.enabled If PDB is enabled for the service.
  # @param pdb.maxUnavailable How many pods can be unavailable after the eviction.

  pdb:
    enabled: false
    maxUnavailable: 1
  ```

- В переменных, где предполагается конечный список значений, всегда его явно перечисляем.

  ```yaml
  # @param logLevel Log level: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.
  logLevel: error
  ```

- Константы или переменные, которые никогда не меняются при типовом использовании сервиса, следует скрывать из `README.md` при помощи тэга `@skip`.

  Обратите внимание, что из-за особенностей генератора описание не может начинаться со ссылки (любая конструкция в квадратных скобках в начале описания будет принята за декларацию типа). Формулируйте описания настроек и секций так, чтобы ссылки были не в начале.

- Во всех случаях, где в значениях по умолчанию должен фигурировать какой-либо город, используем Москву.

- В случае, если в чарте присутствует `CronJob`, необходимо добавить параметры `successfulJobsHistoryLimit` и `failedJobsHistoryLimit` с дефолтными значениями например 3-3.

  ```yaml
  # @param cron.successfulJobsHistoryLimit How many completed jobs should be kept. See [jobs history limits](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#jobs-history-limits).
  # @param cron.failedJobsHistoryLimit How many failed jobs should be kept. See [jobs history limits](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#jobs-history-limits).
  cron:
    successfulJobsHistoryLimit: 3
    failedJobsHistoryLimit: 3
  ```

## Именование настроек

- В названиях настроек используем camelCase. Названия начинаем с маленькой буквы. Например: `accessKey`, `dgctlDockerRegistry`.

- Одинаковые настройки называем везде одинаково.

  Примеры:

  - Не `serviceAccount.create`, а `serviceAccount.enabled`.
  - Настройки Kafka:

  ```yaml
  kafka:
    groupId: example_group
    bootstrapServers: ''
    securityProtocol: PLAINTEXT # тут не нужно оставлять хардкодом, нужно иметь возможность в несколько разных протоколов
    saslMechanism: PLAIN
    username: ''
    password: ''
    tls:
      skipServerCertificateVerify: false
      serverCA: ''
      clientCert: ''
      clientKey: ''
  ```

  - Настройки S3: `host`, `region`, `secure`, `verifySsl`, `bucket`, `accessKey`, `secretKey`.

  ```yaml
  s3:
    host: ''
    region: ''
    secure: false
    verifySsl: true
    bucket: ''
    accessKey: ''
    secretKey: ''
  ```

  - Настройки PostgreSQL: `host`, `port`, `name`, `username`, `password`, `tls`.

  ```yaml
  postgres:
    host: ''
    port: 5432
    name: ''
    username: ''
    password: ''
    tls:
      enabled: false
      rootCert: ''
      cert: ''
      key: ''
      mode: verify-full
  ```

  - Настройки Ingress: `enabled`, `host`. Другие настройки Ingress не описываем.
  - horizontalPodAutoscaler - hpa
  - verticalPodAutoscaler - vpa
  - podDisruptionBudget - pdb
  - serviceAccount.yaml - serviceAccount
  - Настройки логгирования:
    - logLevel: `trace`, `debug`, `info`, `warning`, `error`, `fatal`
    - logFormat: `json`, `plaintext`

- Группы настроек называем везде одинаково. Предпочтение отдаём не сокращённым, а полным названиям. По возможности используем [официальные названия](https://github.com/helm/helm/blob/main/pkg/releaseutil/kind_sorter.go#L72).
  - Исключения: hpa, vpa, pdb

- Настройки, отвечающие за включение или отключение какой-то функции, должны называться `enabled`.

  Примеры:

  - Не `autoscaling.enabled`, а ` hpa.enabled`.
  - Не `verticalscaling.enabled`, а `vpa.enabled`.
  - Не `podDisruptionBudget.enabled`, а `pdb.enabled`.

- Команды для импорта данных должны называться `importer`. Пример: [настройка `importer` в MapGL JS API](https://github.com/2gis/on-premise-helm-charts/blob/master/charts/tiles-api/values.yaml#L258).

- Если блок настроек связан с определенным сервисом или типом хранилища, это должно быть отражено в его названии. Например: не `storage`, а `postgres` или `s3`.

  При этом вместо терминов, специфичных для 2GIS, должны использоваться более универсальные термины. Например: не `bss`, а `stat`.

- В именах и значениях настроек должны переиспользоваться те же имена, которые используются в названиях чартов.

  Пример для чарта `pro-api`: не `repository: 2gis-on-premise/urbigeo-importer`, а `repository: 2gis-on-premise/pro-api-importer`.

- Настройки, связанные с подключением к другим сервисам On-Premise, должны группироваться в блоки, названные
в соответствии с сервисом. Адрес сервиса должен указываться в настройке `url`.
Ключ для авторизации должен указываться в настройке `key`. Приложение, желательно, должно уметь обрабатывать url
в виде hostname, scheme://hostname, scheme://hostname:port. Если url является шаблоном, то это можно отразить в названии,
например `urlTemplate: http://service-name.svc/{project}/{date_str}_{hour}.json`

Примеры:

  ```yaml
  keys:
    url: http://keys-api.svc
    token: ''
    syncPeriod: 1m
  ```

  ```yaml
  catalog:
    url: http://catalog-api.ingress.host
    key: ''
  ```

  ```yaml
  navi:
    urlTemplate: http://restrictions.svc/{project}/{date_str}_{hour}.json
  ```

## Дефолтные значения

Для каждой обязательной настройки **не должно** быть дефолтного значения (адрес базы, адрес сервиса ключей),
а в шаблоне настройка должна проверятся через required функцию. Пример:

```yaml
--- values.yaml
dgctlStorage:
  host: ''

--- deployment.yaml
host: {{ required "Valid .Values.dgctlStorage.host required!" .Values.dgctlStorage.host }}

```

Сюда же входят настройки, которые критично повлияют на сервис при неправильном указании.
Пример: суффикс в касандре для Tiles API. Если выставить дефолт, то клиент про него не узнает или забудет и в
конечном итоге себе что-нибудь сломает, т.к. суффикс служит защитой от перетирания кейспейсов,
когда бой и тест используют одну касандру.

Для всех таких настроек ставим визуальную отметку **required**.

Для каждой необязательной настройки **должно** быть указано дефолтное значение.
Дефолтное значение должно подходить для типового использования сервиса у партнёра,
а также с ним сервис должен мочь подняться в dev-контуре (например порт postgres, величина таймаута).

Поскольку в разных случаях нужно использовать урлы к сервисам либо внутри k8s, либо снаружи (ingess),
то этот факт нужно отразить в документации параметра. Например, нужно использовать один из шаблонов:
- `http://{service-name}.svc` или `{service-name}.svc` - если нужен внутренний адрес сервиса
- `http(s)://{service-name}.ingress.host` - если нужен внешний адрес сервиса
- `{service-name}.host` - если сервис может находится где угодно

Примеры:

```yaml
# @param search.url URL of the Search service. Ex: http://search-api.svc. This URL should be accessible from all the pods within your Kubernetes cluster
search:
  url: ''

# @param env.MAPGL_TILES_API. Ex: http(s)://tiles-api.ingress.host. Domain name of the Tiles API service.
env:
  MAPGL_TILES_API: ''

# @param db.host. PostgreSQL host. Ex: pg-cluster.host
db:
  host: ''
```

## Стиль кода

- Непустые строковые значения пишем без кавычек.

  ```yaml
  repository: 2gis-on-premise/navi-back
  ```

- Пустые строки указываем с использованием одинарных кавычек.

  ```yaml
  name: ''
  ```

## Примеры типовых шаблонов yaml

TODO

- helpers.tpl
- ingress.yaml
- service.yaml
- vpa.yaml
- hpa.yaml
- pdb.yaml
- serviceAccount.yaml
- configmap.yaml
- deployment.yaml
- job.yaml
- secret.yaml
- statefulset.yaml
