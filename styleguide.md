# Описание общих принципов, которым нужно следовать при разработке helm чартов

# Следуем официальным [Best Practices](https://helm.sh/docs/chart_best_practices/templates/#structure-of-templates) написания helm чартов

# Написание README.md 
README.md формируется полуавтоматически: таблица с параметрами из values.yaml генерируется [readme-generator-for-helm](https://github.com/bitnami-labs/readme-generator-for-helm) от Bitnami, как ей пользоваться описано в [документе](https://docs.google.com/document/d/1iEPG8tcCYu9q5iZssTAPOd43xh8uCQhNXyXhFPUTir8/edit).

# Скрываем лишние переменные в README.md 
Делаем это через @skip переменные, которые константные или которые никогда не менются в типовом использовании сервиса

# Всегда добавляем общую секцию с Docker registry settings
* пример https://github.com/2gis/on-premise-helm-charts/pull/131/files#diff-16650db0a687f4e9f6e519cbf8703aaf4c02413fc6d8dfc80dee71fc622ba636R11

# В переменных, где предполагается конечный список значений, всегда его явно перечисляем, дефолт уровня ошибка / критичная ошибка
* Пример: LOG_LEVEL - error, warn, info, debug. Default - error

# K8s специфичные настройки

* Для каждого блока настроек всегда должна быть ссылка на официальную документацию (VPA, HPA, PDB, ...) 

* Для каждой настройки должен стоять дефолт, как его ставить:
  * описание делать через @extra
  * с этой установкой сервис должен подняться в dev контуре
  * настройка должна подходить для типового использования сервиса у партнера
  * исключение составляет настройка, которая критично повлияет на сервис, при не правильном указании, для такой ставим визуальную отметку **required** : 
     * например, суффикс в касандре для Tiles API. Если выставить дефолт, то клиент про него не узнает, или забудет и в конечном итоге себе что-нибудь сломает, т.к. суффикс служит защитой от перетирания кейсейсов, когда бой и тест используют одну касандру.

* Одинаковые настройки называем везде одинаково.
  * enabled — когда опция включена / выключена. Дефолт: чаще всего false
    * Пример: serviceAccount.create → serviceAccount.enabled
  * группы настроек тоже называем одинаково (сокращенно) 
    * autoscaling.enabled →  hpa.enabled
    * verticalscaling.enabled → vpa.enabled
    * podDisruptionBudget.enabled → pdb.enabled
    * Исключения:
      * serviceAccount не сокращаем как и в [официальной репе helm](https://github.com/helm/helm/blob/main/pkg/chartutil/create.go#L122)
      * ingress не сокращаем, описывем только enabled, host и cсылку на официальную документацию

* Ресурсы всегда пишем с дефолтами, на которых сервис запустится на dev контуре
* Блоки настроек именуем одноименно для с сервисом:
  * postgres
  * s3
  * kafka
  * redis
  * zookeeper
  * ...
  * catalog
  * keys 
  * ...
  
* Пример неймингов для 
  * kafka - https://github.com/2gis/on-premise-helm-charts/pull/124/files#diff-439bd87592d0ae6027750dd8342d3e2bef43c01e3b68e5330049f0076eb23af6R140 
  * S3 - https://github.com/2gis/on-premise-helm-charts/pull/124/files#diff-439bd87592d0ae6027750dd8342d3e2bef43c01e3b68e5330049f0076eb23af6R162  
  * postgres — ?

# ToDo. Примеры типовых шаблонов yaml
* helpers.tpl —  
* ingress.yaml —
* service.yaml  — 
* vpa.yaml  — 
* hpa.yaml — 
* pdb.yaml — 
* serviceaccount.yaml - 
* configmap.yaml — 
* deployment.yaml — 
* job.yaml — 
* secret.yaml —
* statefulset.yaml — 

# Домены в переменных оформляем по шаблону 'http://{service-name}.host'
  * restrictions_api_url: 'http://navi-restrictions.host'
  * postgres.host: postgres.host 
