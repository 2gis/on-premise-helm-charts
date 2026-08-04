# Развёртывание 2GIS On-Premise через helmfile

Установщик для развёртывания продуктов 2GIS On-Premise.

Официальная документация 2GIS: [docs.2gis.com](https://docs.2gis.com)

---

## Требования

- Kubernetes 1.29+
- Helm 4.x
- Helmfile 1.1.0+
- kubectl
- S3-совместимое хранилище (MinIO, Ceph и др.)
- Docker registry с образами 2GIS
- Утилита dgctl (для загрузки данных)
- Лицензионный ключ 2GIS

Подробнее: [System Requirements](https://docs.2gis.com/on-premise-api-platform/requirements)

---

## Инфраструктура

Для работы сервисов требуется инфраструктура: PostgreSQL, Kafka, Redis, S3, Keycloak,
Elasticsearch, ClickHouse, Cassandra.

Инфраструктура может быть:
- **Внешней** — развёрнута на отдельных ВМ (рекомендуется для production-окружений)
- **Развёрнута через helmfile** — встроенные чарты в `services/infra/` (для тестовых окружений)

Подробнее: [Preparation](https://docs.2gis.com/on-premise-api-platform/preparation)

---

## Компоненты и версии

Версии компонентов задаются в `installer/helmfile/common.yaml.gotmpl`:

| Компонент | Версия |
|-----------|--------|
| Core | 2.9.0 |
| API Platform | 2.56.0 |
| Pro | 2.5.0 |
| Citylens | 2.3.0 |

**Обязательные компоненты:** Core + API Platform

---

## Подготовка конфигурации

1. Скопируйте директорию `installer/helmfile/example` в удобное место:
   ```bash
   cp -r installer/helmfile/example /path/to/my-values
   ```
2. Установите переменные окружения:
   ```bash
   export HELMFILE_VALUES=/path/to/my-values
   export HELMFILE_BASE=/path/to/installer/helmfile
   ```
3. Заполните все значения с комментарием `# TODO` в скопированных файлах.
4. Создайте `dgctl-config.yaml` и выполните загрузку артефактов:

   Пример конфигурации см. в документации: [Fetch Installation Artifacts](https://docs.2gis.com/on-premise-api-platform/preparation#fetch-artifacts).

   **Примечание:** в примере документации нет секций `pro` и `citylens`, так как они опциональны. Добавьте их при необходимости:
   ```yaml
   pro:
     version: 2.5.0
   citylens:
     version: 2.3.0
   ```
   **Важно:** версии в `dgctl-config.yaml`, `common.yaml.gotmpl` и при установке должны совпадать.

   Загрузите артефакты:
   ```bash
   docker run --rm \
     -v $(pwd)/dgctl-config.yaml:/dgctl-config.yaml \
     -v /var/run/docker.sock:/var/run/docker.sock \
     --user $(id -u):$(id -g) \
     2gis/dgctl:3 \
     pull --config=/dgctl-config.yaml --apps-to-registry --generate-values
   ```
   Подробнее: [Fetch Installation Artifacts](https://docs.2gis.com/on-premise-api-platform/preparation#artifacts)

   **Примечание:** для утилиты dgctl версии 3.6+ аргумент `-v /var/run/docker.sock:/var/run/docker.sock` не требуется.

   **Изолированный контур.** Если хост не имеет одновременного доступа к публичной сети, реестру Docker и S3-хранилищу, используйте двуххостовую схему: загрузите артефакты через `dgctl pull` на хосте с доступом в интернет (с `storage.type: fs`), перенесите директорию на внутренний хост и выполните `dgctl restore`. Подробнее: [Fetch Installation Artifacts](https://docs.2gis.com/on-premise-api-platform/preparation#fetch-artifacts).

5. Создайте секрет Kubernetes для доступа к реестру Docker (если реестр требует аутентификации):
   ```bash
   kubectl create secret docker-registry onpremise-registry-creds \
     --docker-server=docker.registry.example.com \
     --docker-username=registry \
     --docker-password=DOCKERregistryP@ssW0rd
   ```
   Укажите имя секрета в `imagePullSecrets` в values для каждого сервиса.

---

## Развёртывание

### Фильтрация по сервисам и группам

Каждый сервис помечен лейблами `service` и `group`. Это позволяет развернуть только нужные сервисы или группу:

```bash
# развернуть только license
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector service=license

# развернуть всю инфраструктуру
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=infra

# развернуть несколько сервисов
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector service=license --selector service=keys
```

Группы: `infra`, `core`, `pro`, `citylens`, `api-platform`.

### 1. Базовые сервисы (Core)

Сначала установите сервис лицензий:

```bash
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector service=license
```

**Лицензия.** При первом запуске pod license не стартует — это ожидаемое поведение. Получите файл лицензии:

```bash
docker run --rm \
  -v $(pwd)/dgctl-config.yaml:/dgctl-config.yaml \
  --user $(id -u):$(id -g) \
  2gis/dgctl:3 \
  license --config=/dgctl-config.yaml
```

После этого повторно запустите установку license:

```bash
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector service=license
```

Проверьте статус лицензии: [License](https://docs.2gis.com/on-premise-api-platform/core/install/license#check-license-status).

После успешной активации лицензии установите остальные компоненты Core (keys, keycloak):

```bash
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=core
```

**API-ключи.** После установки добавьте администратора и создайте API-ключ. Следуйте документации: [Keys](https://docs.2gis.com/on-premise-api-platform/core/install/keys#test).

**Keycloak.** Войдите в Keycloak admin console и перегенерируйте client secrets для каждого realm. Обновите их в env-specific values сервисов.

### 2. API-платформа

```bash
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=api-platform
```

Если все параметры настроены правильно, платформа установится с первого раза.

Состав группы `api-platform`:

| Сервис | Описание | Зависимости |
|---|---|---|
| Stat Receiver + Stat API | Сбор статистики вызовов API | ClickHouse |
| Traffic Proxy | Прокси для API пробок | — |
| MapGL JS API | API картографических движков | — |
| Tiles API | Тайловый сервер | S3 |
| Static API | Статические изображения карт | Tiles API |
| Styles API | Управление стилями карт | S3 |
| Search API | Поиск мест, геокодирование, подсказки | PostgreSQL, Elasticsearch |
| Search API v8 (опционально) | Новая версия Search API | PostgreSQL, Elasticsearch |
| Catalog API | Каталог данных | PostgreSQL + PostGIS |
| Navi-Castle | Валидация маршрутов | — |
| Navi-Back | Построение маршрутов | PostgreSQL |
| Navi-Attractor | Привязка точек к графику (генерируется из navi-rules) | Navi-Back |
| Navi-Splitter | Разделение маршрутов (генерируется из navi-rules) | Navi-Back |
| Navi-Router | Проксирование запросов навигации | Navi-Back |
| Navi-Front | Frontend для API навигации | Navi-Router |
| Navi Async Matrix | Асинхронная матрица расстояний | PostgreSQL |
| Navi VRP Solver + VRP Task Manager | Решение задачи маршрутизации транспорта | PostgreSQL |
| Navi Restrictions | Ограничения проезда | PostgreSQL |
| Platform Manager | Веб-интерфейс управления платформой | Keycloak (OIDC) |

Проверьте работоспособность:

**API карт:**
- [MapGL JS API](https://docs.2gis.com/on-premise-api-platform/api-platform/install/maps#test-mapgl-js-api)
- [Tiles API](https://docs.2gis.com/on-premise-api-platform/api-platform/install/maps#test-tiles-api)
- [Static API](https://docs.2gis.com/on-premise-api-platform/api-platform/install/maps#test-static-api)
- [Styles API](https://docs.2gis.com/on-premise-api-platform/api-platform/install/maps#test-styles-api)

**API поиска:** [общая проверка](https://docs.2gis.com/on-premise-api-platform/api-platform/install/search#test)
- Places API
- Geocoder API
- Suggest API
- Categories API
- Regions API

**API навигации:**
- [Navi-Castle](https://docs.2gis.com/on-premise-api-platform/api-platform/install/navigation#test-navi-castle)
- [Navi-Back](https://docs.2gis.com/on-premise-api-platform/api-platform/install/navigation#test-navi-back)
- [Navi-Splitter](https://docs.2gis.com/on-premise-api-platform/api-platform/install/navigation#test-navi-splitter)
- [Navi-Router](https://docs.2gis.com/on-premise-api-platform/api-platform/install/navigation#test-navi-router)
- [Navi-Front](https://docs.2gis.com/on-premise-api-platform/api-platform/install/navigation#test-navi-front)
- [Distance Matrix Async API](https://docs.2gis.com/on-premise-api-platform/api-platform/install/navigation#test-distance-matrix-async-api)
- [Restrictions API](https://docs.2gis.com/on-premise-api-platform/api-platform/install/navigation#test-restrictions-api)

**Сервис статистики:**
- [Stat Receiver](https://docs.2gis.com/on-premise-api-platform/api-platform/install/statreceiver#test)

**Другие сервисы:**
- [Traffic Proxy](https://docs.2gis.com/on-premise-api-platform/api-platform/install/trafficproxy#test)
- [Менеджер Платформы](https://docs.2gis.com/on-premise-api-platform/api-platform/install/platform#test)

**Менеджер Платформы.** После установки настройте аутентификацию пользователей через Keycloak (OIDC). В Keycloak создайте client для Platform Manager и укажите client secret в env-specific values. Подробнее: [настройка аутентификации](https://docs.2gis.com/on-premise-api-platform/api-platform/install/platform#test).

**Мобильный SDK.** Мобильные SDK (iOS, Android, Flutter) являются клиентскими библиотеками и не развёртываются в Kubernetes. Для их подключения используйте `vendor-config.json` с адресами ваших On-Premise сервисов.

### 3. Pro (опционально)

```bash
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=pro
```

Настройка и проверка работоспособности:
- [Проверка](https://docs.2gis.com/on-premise-pro/install/installation#test)
- [Настройка аутентификации](https://docs.2gis.com/on-premise-pro/install/authentication)

### 4. Citylens (опционально)

```bash
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=citylens
```

Настройка и проверка работоспособности:
- [Проверка](https://docs.2gis.com/on-premise-citylens/install/installation#test)
- [Настройка аутентификации](https://docs.2gis.com/on-premise-citylens/install/authentication)

---

## Дополнительные возможности

**Хуки (presync / postsync).** Для каждого сервиса можно добавить helmfile-хуки,
которые выполняются до или после развёртывания. Это позволяет автоматизировать
ручные действия — создание топиков Kafka, генерацию токенов, импорт данных.

**Ingress-аннотации.** Настройка CORS, прокси и ограничений доступа через
`ingressAnnotations` для Traefik или NGINX.