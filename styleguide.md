# Styleguide

В этом документе описаны общие принципы, которым нужно следовать при разработке helm-чартов.

## Структура файлов

Мы следуем [официальным best practices для helm-чартов](https://helm.sh/docs/chart_best_practices/templates/#structure-of-templates).

## Генерация README.md

Файл `README.md` формируется полуавтоматически на основе комментариев в `values.yaml`. Для этого используется инструмент [`readme-generator-for-helm`](https://github.com/bitnami-labs/readme-generator-for-helm) от Bitnami. Подробнее об использовании генератора можно прочитать в [документе](https://docs.google.com/document/d/1iEPG8tcCYu9q5iZssTAPOd43xh8uCQhNXyXhFPUTir8/edit). Генератор можно запускать напрямую или с помощью [`Makefile`](Makefile).

Примечания:

- `dgctlDockerRegistry` и другие настройки, связанные с получением Docker-образов, объединяем в секцию под названием Docker registry settings.

  ```yaml
  # @param dgctlDockerRegistry Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`.
  # @param imagePullSecrets Kubernetes image pull secrets.
  # @param imagePullPolicy Pull policy.
  # @param ui.image.repository UI service image repository.
  # @param ui.image.tag UI service image tag.
  
  dgctlDockerRegistry: ""
  imagePullSecrets: []
  imagePullPolicy: IfNotPresent
  ```

- В переменных, где предполагается конечный список значений, всегда его явно перечисляем.

  ```yaml
  # @param LOG_LEVEL Log level: `error`, `warn`, `info` or `debug`.
  LOG_LEVEL: error
  ```

- Константы или переменные, которые никогда не менются при типовом использовании сервиса, следует скрывать из `README.md` при помощи тэга `@skip`.

## Именование настроек

- В заголовке каждого блока k8s-специфичных настроек необходимо ставить ссылку на соответствующий раздел официальной документации.

  ```yaml
  # @section Kubernetes [pod disruption budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings
  
  # @param podDisruptionBudget.enabled If PDB is enabled for the service.
  # @param podDisruptionBudget.maxUnavailable How many pods can be unavailable after the eviction.
  
  podDisruptionBudget:
    enabled: false
    maxUnavailable: 1
  ```

- Одинаковые настройки называем везде одинаково.
  
  Примеры:
 
  - Не `serviceAccount.create`, а `serviceAccount.enabled`.
  - [Примеры именования настроек Kafka](https://github.com/documentat-alibaev/on-premise-helm-charts/blob/1f7b7d269aec9c6e265c41da3718bfc9135125a1/charts/navi-back/values.yaml#L185).
  - [Примеры именования настроек S3](https://github.com/documentat-alibaev/on-premise-helm-charts/blob/1f7b7d269aec9c6e265c41da3718bfc9135125a1/charts/navi-back/values.yaml#L212).

- Группы настроек называем везде одинаково. Предпочтение отдаём сокращённым названиям.

  Примеры:

  - Не `autoscaling.enabled`, а ` hpa.enabled`.
  - Не `verticalscaling.enabled`, а `vpa.enabled`.
  - Не `podDisruptionBudget.enabled`, а `pdb.enabled`.

  Исключения:

  - `serviceAccount` не сокращаем, как и [в официальном репозитории helm](https://github.com/helm/helm/blob/main/pkg/chartutil/create.go#L122).
  - `ingress` не сокращаем.

- Блоки настроек именуем одноименно для с сервисом. Примеры: `postgres`, `s3`, `kafka`, `redis`, `zookeeper`, `catalog`, `keys`.

## Дефолтные значения

Для каждой настройки должно быть указано дефолтное значение. Дефолтное значение должно подходить для типового использования сервиса у партнёра, а также с ним сервис должен мочь подняться в dev-контуре.

Исключение составляют настройки, которые критично повлияют на сервис при не правильном указании. Для таких настроек ставим визуальную отметку **required**. Пример: суффикс в касандре для Tiles API. Если выставить дефолт, то клиент про него не узнает или забудет и в конечном итоге себе что-нибудь сломает, т.к. суффикс служит защитой от перетирания кейспейсов, когда бой и тест используют одну касандру.

Доменов сервисов по умолчанию устанавливаем согласно шаблону `http://{service-name}.host`. Например: `http://navi-restrictions.host`, `postgres.host`.
