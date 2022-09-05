# Styleguide

В этом документе описаны общие принципы, которым нужно следовать при разработке helm-чартов.

## Структура файлов

Мы следуем [официальным best practices для helm-чартов](https://helm.sh/docs/chart_best_practices/conventions/).

## Генерация README.md

Файлы `README.md` формируются полуавтоматически. Для каждого чарта сначала необходимо создать файл `README.md` с общим описанием сервиса и пустым разделом «Values», а затем запустить инструмент [`readme-generator-for-helm`](https://github.com/bitnami-labs/readme-generator-for-helm) от Bitnami, чтобы автоматически заполнить раздел «Values» описаниями настроек на основе комментариев из `values.yaml`. Подробнее об использовании генератора можно прочитать в [документе](https://docs.google.com/document/d/1iEPG8tcCYu9q5iZssTAPOd43xh8uCQhNXyXhFPUTir8/edit).

Генератор можно запускать напрямую или с помощью [`Makefile`](Makefile), например:

```
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
  # @param LOG_LEVEL Log level: `error`, `warn`, `info` or `debug`.
  LOG_LEVEL: error
  ```

- Константы или переменные, которые никогда не меняются при типовом использовании сервиса, следует скрывать из `README.md` при помощи тэга `@skip`.
  
  Обратите внимание, что из-за особенностей генератора описание не может начинаться со ссылки (любая конструкция в квадратных скобках в начале описания будет принята за декларацию типа). Формулируйте описания настроек и секций так, чтобы ссылки были не в начале.

- Во всех случаях, где в значениях по умолчанию должен фигурировать какой-либо город, используем Москву.

## Именование настроек

- В названиях настроек используем camelCase. Названия начинаем с маленькой буквы. Например: `accessKey`, `dgctlDockerRegistry`.

- Одинаковые настройки называем везде одинаково.
  
  Примеры:
 
  - Не `serviceAccount.create`, а `serviceAccount.enabled`.
  - [Настройки Kafka](https://github.com/documentat-alibaev/on-premise-helm-charts/blob/1f7b7d269aec9c6e265c41da3718bfc9135125a1/charts/navi-back/values.yaml#L185).
  - Настройки S3: `host`, `bucket`, `accessKey`, `secretKey`.
  - Настройки PostgreSQL: `host`, `port`, `name`, `username`, `password`.
  - Настройки Ingress: `enabled`, `host`. Другие настройки Ingress не описываем.
  - horizontalPodAutoscaler - hpa
  - verticalPodAutoscaler - vpa
  - podDisruptionBudget - pdb
  - serviceAccount.yaml - serviceAccount

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

- Настройки, связанные с подключением к другим сервисам On-Premise, должны группироваться в блоки, названные в соответствии с сервисом. Адрес сервиса должен указываться в настройке `host`. Ключ для авторизации должен указываться в настройке `key`.

  Примеры:

  ```yaml
  keys:
    host: http://keys-api.host
    token: ''
    syncPeriod: 1m
  ```

  ```yaml
  catalog:
    host: http://catalog.host
    key: ''
  ```

  ```yaml
  navi:
    host: http://navi-back.host
    key: ''
  ```

## Дефолтные значения

Для каждой настройки должно быть указано дефолтное значение. Дефолтное значение должно подходить для типового использования сервиса у партнёра, а также с ним сервис должен мочь подняться в dev-контуре.

Исключение составляют настройки, которые критично повлияют на сервис при неправильном указании. Для таких настроек ставим визуальную отметку **required**. Пример: суффикс в касандре для Tiles API. Если выставить дефолт, то клиент про него не узнает или забудет и в конечном итоге себе что-нибудь сломает, т.к. суффикс служит защитой от перетирания кейспейсов, когда бой и тест используют одну касандру.

Для доменов и URL сервисов нужно использовать шаблон `http://{service-name}.host`. Например: `http://navi-restrictions.host`, `postgres.host`.

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
