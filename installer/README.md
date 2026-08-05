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

   Готовые скрипты для этого сценария (pull/restore данных и образа, обмен лицензией) находятся в `installer/dgctl-fs/`, пошаговая инструкция — в `installer/dgctl-fs/README.md`.

**Вспомогательные скрипты.** Для стандартного контура доступны дополнительные утилиты в `installer/dgctl/` (README: `installer/dgctl/README.md`):
- `pull.sh` — загрузка артефактов через `dgctl pull` (генерация values с ключом `-l` для запроса лицензии) и проверка свободного места на хостах БД;
- `manifest_cleanup.sh` — очистка старых manifest-файлов из S3 после обновления всех данных.

   Требования: SSH-доступ к хостам БД и утилита `yq`.

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

---

## Values для сервисов navi-back

### `services/api-platform/navi-back.yaml.gotmpl`

- По умолчанию все сервисы navi-back берут значения из файла `values/api-platform/navi-back/{{ $.Environment.Name }}.yaml`
- Чтобы параметризовать конкретный сервис, необходимо добавить values с именем `values/api-platform/navi-back/{{ $.Environment.Name }}-{{ $service.name }}.yaml`

### Асинхронный деплой (DMA — Distance Matrix Async)

Асинхронные сервисы управляются через тот же `services/api-platform/navi-back.yaml.gotmpl`.
Если присутствует файл `values/api-platform/navi-rules/{{ $.Environment.Name }}-rules-dma.yaml.gotmpl`,
для каждого rule из него автоматически создаётся пара navi-back + navi-attractor с Kafka-транспортом.

Параметры (топики Kafka, `navigroup`, `rules`) генерируются динамически из имени сервиса — отдельные dma-файлы values не нужны.

**navi-back** (async-релизы) берут values из:
- `values/api-platform/navi-back/{{ $.Environment.Name }}.yaml` — общие параметры (ресурсы и т.д.)
- `values/api-platform/navi-back/{{ $.Environment.Name }}-async.yaml` — настройки подключения к Kafka и S3

**navi-attractor** (async-релизы) берут values из:
- `values/api-platform/navi-attractor/{{ $.Environment.Name }}.yaml` — общие параметры (ресурсы и т.д.)
- `values/api-platform/navi-attractor/{{ $.Environment.Name }}-async.yaml` — настройки подключения к Kafka и S3

Настройки Kafka для сервиса navi-async-matrix задаются отдельно в `values/api-platform/navi-async-matrix/{{ $.Environment.Name }}.yaml`

---

## Конфигурация Traefik

### Структура

- `installer/helmfile/values/infra/traefik.yaml.gotmpl` — глобальные настройки по умолчанию (ports, deployment, providers, logs, metrics, middleware definitions)
- `installer/helmfile/example/values/infra/traefik/<env>.yaml.gotmpl` — переопределения для конкретного окружения (dashboard, trustedIPs, TLS certificates)

**Пример:** `installer/helmfile/example/values/infra/traefik/staging.yaml.gotmpl`

### Порядок загрузки values

В `installer/helmfile/services/infra/traefik.yaml.gotmpl`:

```yaml
values:
  - {{ .Values.basePath }}/values/infra/traefik.yaml.gotmpl
  - {{ .Values.valuesPath }}/values/infra/traefik/{{ .Environment.Name }}.yaml.gotmpl
```

1. **Дефолты** (`traefik.yaml.gotmpl`) — базовая конфигурация, middleware определения
2. **Environment-specific** (`<env>.yaml.gotmpl`) — переопределения с более высоким приоритетом

**Важно:** Helmfile делает shallow merge. Если в `<env>.yaml.gotmpl` указать `extraObjects`, он **полностью заменит** дефолтный `extraObjects`. Поэтому:
- Либо не указывайте `extraObjects` в environment файле (используются дефолты)
- Либо скопируйте **ВСЕ** middleware definitions из дефолтов и измените нужные

**Важно:** Middleware имена в `extraObjects` становятся Kubernetes CRD с префиксом namespace:

```
<name> → <namespace>-<name>@kubernetescrd
```

Пример: middleware `cors-headers` в namespace `partner` становится `partner-cors-headers@kubernetescrd`.

### Выбор IngressController

Установите `ingressController: traefik` или `ingressController: nginx` в файле окружения:

```yaml
# HELMFILE_VALUES/environments/<env>.yaml.gotmpl
environments:
  <env>:
    values:
    - ingressController: traefik
```

---

## Ingress аннотации

Поддержаны два типа `Ingress Controller`: `nginx` и `traefik`.
Выбор осуществляется через переопределение переменной `ingressController`.

Для управления аннотациями создан шаблон `installer/helmfile/values/ingressAnnotations.yaml.gotmpl`, который содержит:

- `cors` — настройки политик кросс-доменных запросов (Cross-Origin Resource Sharing)
- `proxy` — настройки проксирования (таймауты, лимиты тела запроса)
- `corsGet` — настройка, выделенная под s3 (где разрешён только `GET`)
- `vpn` — настройка, разрешающая доступ только из указанных IP-диапазонов

Для изменения состава навешиваемых аннотаций переопределите в шаблоне сервиса:

```yaml
{{- $annotations := pick .Values.ingressAnnotations.nginx "cors" "vpn" "proxy" -}}
```

Для `nginx` получим список аннотаций:
```
  annotations:
    nginx.ingress.kubernetes.io/cors-allow-credentials: "true"
    nginx.ingress.kubernetes.io/cors-allow-headers: DNT,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization,x-share-token,X-Company-Id
    nginx.ingress.kubernetes.io/cors-allow-methods: GET, PUT, POST, DELETE, PATCH, OPTIONS
    nginx.ingress.kubernetes.io/cors-allow-origin: '*'
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 100m
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "120"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "120"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "120"
    nginx.ingress.kubernetes.io/whitelist-source-range: 10.0.0.0/8
```

Для `traefik` получаем помержанную строку со списком необходимых `middlewares`, в том порядке, который указан для `pick`:

```yaml
  annotations:
    traefik.ingress.kubernetes.io/router.middlewares: partner-cors-headers@kubernetescrd,partner-buffering-limit@kubernetescrd,partner-allow-vpn-office@kubernetescrd
```

**Важно:**
- Имена middleware должны совпадать с теми, что определены в `extraObjects` вашего `infra/traefik/<env>.yaml.gotmpl`
- Middleware становится доступен как `<namespace>-<name>@kubernetescrd`

Для каждого сервиса можно выбрать нужный набор middleware через `pick`:

| Сервис | Middleware (traefik) | Назначение |
|---|---|---|
| `keys-admin` | `cors + proxy + vpn` | Полный доступ с VPN-ограничением |
| `platform` | `vpn` | Только VPN (публичный доступ не нужен) |
| `catalog` | `cors + proxy + vpn` | Полный доступ |
| `styles` | `cors + proxy` | CORS + proxy, без VPN |
| `tiles` | `cors` | Только CORS (минимальные настройки) |
| `pro-ui`, `pro-api` | `cors + proxy` | CORS + proxy, без VPN |
| `haproxy` | `corsGet` | Только GET для S3 |
