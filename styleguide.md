# Описание общих принципов, которым нужно следовать при разработке helm чартов

# Написание README.md 
README.md формируется полуавтоматически: таблица с параметрами из values.yaml генерируется [readme-generator-for-helm](https://github.com/bitnami-labs/readme-generator-for-helm) от Bitnami, как ей пользоваться описано в [документе](https://docs.google.com/document/d/1iEPG8tcCYu9q5iZssTAPOd43xh8uCQhNXyXhFPUTir8/edit).

# Скрываем лишние переменные в README.md 
Делаем это через @skip переменные, которые константные или которые никогда не менются в типовом использовании сервиса

# Всегда добавляем общую секцию с Docker registry settings
* пример https://github.com/2gis/on-premise-helm-charts/pull/131/files#diff-16650db0a687f4e9f6e519cbf8703aaf4c02413fc6d8dfc80dee71fc622ba636R11

# K8s специфичные настройки

* Для каждого блока настроек всегда должна быть ссылка на официальную документацию (VPA, HPA, PDB, ...) 

* Для каждой настройки должен стоять дефолт, как его ставить:
  * с этой установкой сервис должен подняться в dev контуре
  * настройка должна быть типовой +- типого использования сервиса у любого партнера

* Одинаковые настройки назваем везде одинаково.
  * enable — когда опция включена / выключена. Дефолт: чаще всего false
    * Пример: serviceAccount.create → serviceAccount.enable
  * группы настроек тоже называем одинаково (сокращенно) 
    * autoscaling.enabled →  hpa.enabled
    * podDisruptionBudget.enabled → pdb.enabled
    * serviceAccount → sa
  * Ingress описывем только host и cсылку на официальную документацию

* Ресурсы всегда пишем с дефолтами, на которых сервис запуститься на dev контуре

* Пример неймингов для 
  * kafka - https://github.com/2gis/on-premise-helm-charts/pull/124/files#diff-439bd87592d0ae6027750dd8342d3e2bef43c01e3b68e5330049f0076eb23af6R140 
  * S3 - https://github.com/2gis/on-premise-helm-charts/pull/124/files#diff-439bd87592d0ae6027750dd8342d3e2bef43c01e3b68e5330049f0076eb23af6R162  

# Домены в переменных оформляем по шаблону 'http://{service-name}.host'
* Пример: restrictions_api_url: 'http://navi-restrictions.host'

