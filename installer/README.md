# Развёртывание 2GIS On-Premise через helmfile

Установщик для развёртывания продуктов 2GIS On-Premise.

Официальная документация 2GIS: [docs.2gis.com](https://docs.2gis.com)

---

## Требования

- Kubernetes 1.21-1.35
- Helm 4.x
- Helmfile 1.1.0+
- kubectl
- (опционально) [sops](https://github.com/getsops/sops) 3.9+ и [helm-secrets](https://github.com/jkroepke/helm-secrets) - шифрование секретов (см. [Секреты](#секреты))
- S3-совместимое хранилище (MinIO, Ceph и др.)
- Docker registry с образами 2GIS
- Утилита [dgctl](https://hub.docker.com/r/2gis/dgctl) версии 3.6+ (для загрузки данных, образ `2gis/dgctl:3`)
- Лицензионный ключ 2GIS (оформляется через [форму на dev.2gis.ru](https://dev.2gis.ru/onpremise#form))

Подробнее: [System Requirements](https://docs.2gis.com/on-premise-api-platform/requirements)

---

## Внешние зависимости

Для работы сервисов требуются внешние зависимости: PostgreSQL, Kafka, Redis, S3, Keycloak,
Elasticsearch, ClickHouse, Cassandra.

Способы размещения внешних зависимостей:
- **Вынесенные** - на отдельных ВМ (рекомендуется для production-окружений)
- **Развёрнутые через helmfile** - встроенные чарты в `services/infra/` (для тестовых окружений)

Подробнее о требованиях и версиях: [System Requirements](https://docs.2gis.com/on-premise-api-platform/requirements).
Подготовка: [Preparation](https://docs.2gis.com/on-premise-api-platform/installation#preparation).

---

## Компоненты и версии

Версии компонентов задаются в `installer/helmfile/common.yaml.gotmpl`:

| Компонент | Переменная | Версия |
|-----------|-----------|--------|
| Core | `versionCore` | 2.11.1 |
| API Platform | `versionPlatform` | 2.58.0 |
| Pro | `versionPro` | 2.5.0 |
| Citylens | `versionCitylens` | 2.3.0 |

**Обязательные компоненты:** Core + API Platform

---

## Подготовка конфигурации

Установщик основан на [Helmfile](https://helmfile.readthedocs.io) - декларативной надстройке над Helm, описывающей набор сервисов, их values и порядок развёртывания.

В `installer/helmfile/example` находятся примеры окружений:
- `staging` - основной рабочий пример;
- `sandbox` - минимальный готовый к запуску (kubernetes-ready) пример для быстрого развёртывания, например в kind. Подробнее: [Sandbox-пример (kind)](#sandbox-пример-kind).

1. Скопируйте директорию `installer/helmfile/example` в удобное место:
   ```bash
   cp -r installer/helmfile/example /path/to/my-values
   ```
2. Установите переменные окружения:
   - `HELMFILE_VALUES` - путь к скопированным values (копия `example/`);
   - `HELMFILE_BASE` - путь к базовым шаблонам `installer/helmfile`.
   ```bash
   export HELMFILE_VALUES=/path/to/my-values
   export HELMFILE_BASE=/path/to/installer/helmfile
   ```

   > Дальнейшие инструкции предполагают, что эти переменные заданы.

   **Файлы окружений.** Один файл `$HELMFILE_VALUES/environments/<env>.yaml.gotmpl` = одно окружение -
   плоская карта значений (`kubeContext`, `domain`, `dgctlStorage`, `releasePrefix` и т.д.). Окружение
   выбирается флагом `-e <env>`; новое окружение добавляется созданием файла, без правок helmfile
   (список доступных - `ls $HELMFILE_VALUES/environments/`). Поддерживаются расширения `.yaml.gotmpl`
   (шаблонизируется: `env "CHART_LOCATION"` и т.п.) и `.yaml`. Файла окружения нет - `-e` завершится
   ошибкой с указанием ожидаемого пути.
   Секреты окружения - соседний файл `<env>.secrets.yaml` (helm-secrets/sops, опционален).

   **Общий слой окружений (опционально).** Файл `$HELMFILE_VALUES/environments/_common.yaml.gotmpl`
   подключается к каждому окружению ПЕРЕД его env-файлом: значения env-файла побеждают (deep-merge).
   Место для значений, одинаковых у всех окружений values-каталога (домен, registry, S3-креды,
   префиксы релизов/хостов). Секреты - соседний файл `_common.secrets.yaml` (sops, ниже
   приоритетом `<env>.secrets.yaml`). Файлы `_common` отсутствуют - слои просто не подключаются.

   **Дефолты инсталляции (опционально).** Файл `$HELMFILE_VALUES/values/{group}/{svc}/_common.yaml.gotmpl`
   подключается ко всем релизам сервиса перед env-файлом (при наличии). Порядок приоритетов для ключа
   (низкий → высокий): shared values инсталлятора → `_common.yaml.gotmpl` → `{env}.yaml.gotmpl` →
   `{env}.secrets.yaml`. В `_common` - только то, чего инсталлятор знать не может (хосты БД, креды S3/Kafka -
   удобно шаблонизировать через `.Environment.Name`); дублировать ключи, которые shared values уже задают
   осмысленно (resources, feature-flags), не следует - иначе обновления платформы не будут доходить до окружения.

3. Заполните все значения с комментарием `# TODO` в скопированных файлах. Секреты
   (пароли, токены, лицензионный ключ) - в `*.secrets.yaml` файлах. Перед деплоем эти файлы шифруются через sops;
   без шифрования - перенесите значения в открытый values и удалите secrets-файл.
   См. [Секреты](#секреты).
4. Заполните `dgctl-config-<env>.yaml` (файл уже есть в скопированной директории `$HELMFILE_VALUES/dgctl/`) и загрузите артефакты.

   Описание полей и пример конфигурации см. в документации: [Fetch Installation Artifacts](https://docs.2gis.com/on-premise-api-platform/installation#fetch-artifacts).

   **Примечание:** секции `pro` и `citylens` опциональны - если соответствующие компоненты не нужны, удалите их из конфига, чтобы не загружать лишние артефакты.

   **Важно:** версии в `dgctl-config-<env>.yaml`, `common.yaml.gotmpl` и при установке должны совпадать.

   **Загрузка скриптом (рекомендуется).** Готовый скрипт также проверяет свободное место на хостах БД (см. `installer/dgctl/README.md`):
   ```bash
   ${HELMFILE_BASE}/../dgctl/pull.sh dgctl-config-<env>.yaml
   ```

   **Загрузка вручную (docker run).** Обязательно монтируйте `-v $(pwd)/values:/values`, иначе сгенерированный `general.yaml` удаляется после запуска:
   ```bash
   docker run --rm \
     -v $(pwd)/dgctl-config.yaml:/dgctl-config.yaml \
     -v $(pwd)/values:/values \
     --user $(id -u):$(id -g) \
     2gis/dgctl:3 \
     pull --config=/dgctl-config.yaml --apps-to-registry --generate-values
   ```

   Оба способа записывают актуальные значения (включая номер манифеста) в `installer/dgctl/auto_values/<component>/general.yaml` - эти файлы потом читает helmfile.
   Подробнее: [Fetch Installation Artifacts](https://docs.2gis.com/on-premise-api-platform/installation#artifacts)

   > **Фиксация/переключение манифестов.** Манифесты всех pull'ов аккумулируются в бакете
   > (`manifests/<компонент>/<номер>.json`), а `auto_values` всегда читает последний. Чтобы
   > закрепить конкретный набор или откатиться, не трогая `auto_values`, задайте карту
   > пинов `dgctlManifests` в env-файле окружения (или в `_common.yaml.gotmpl`, если пины
   > общие):
   > ```yaml
   > # $HELMFILE_VALUES/environments/<env>.yaml.gotmpl - пин манифеста на каждый компонент
   > dgctlManifests:
   >   core: manifests/core/1789109441.json
   >   api-platform: manifests/api-platform/1789109441.json
   >   citylens: manifests/citylens/1789109441.json
   >   pro: manifests/pro/1789109441.json
   > ```
   > Числовое имя файла пинится в имена схем/кейспейсов/индексов БД - обновляйте осознанно.
   > Резолв центральный: `values/dgctl.yaml.gotmpl` сопоставляет релиз компоненту по имени
   > (keys, license → core; pro-api, pro-ui → pro; citylens* → citylens; остальное →
   > api-platform) и подставляет `dgctlStorage.manifest`. Env-values стоят позже auto_values
   > в списке `values:` релиза и перебивают его (helmfile merge: позже в списке = приоритет).

   **Изолированный контур.** Если хост не имеет одновременного доступа к публичной сети, реестру Docker и S3-хранилищу, используйте двуххостовую схему: загрузите артефакты через `dgctl pull` на хосте с доступом в интернет (с `storage.type: fs`), перенесите директорию на внутренний хост и выполните `dgctl restore`. Подробнее: [Fetch Installation Artifacts](https://docs.2gis.com/on-premise-api-platform/installation#fetch-artifacts).

   Готовые скрипты для этого сценария (pull/restore данных и образа, обмен лицензией) находятся в `installer/dgctl-fs/`, их конфиги - в `example/dgctl/`
   (`dgctl-config-fs.yaml` - хост с интернетом, `dgctl-config-s3.yaml` - закрытый контур); пошаговая инструкция - в `installer/dgctl-fs/README.md`.

**Вспомогательные скрипты.** Для стандартного контура доступны дополнительные утилиты в `installer/dgctl/` (README: `installer/dgctl/README.md`):
- `pull.sh` - загрузка артефактов через `dgctl pull` (генерация values с ключом `-l` для запроса лицензии) и проверка свободного места на хостах БД;
- `manifest_cleanup.sh` - очистка старых manifest-файлов из S3 после обновления всех данных.

   Требования: SSH-доступ к хостам БД и утилита `yq`.

5. Создайте секрет Kubernetes для доступа к реестру Docker (если реестр требует аутентификации):
   ```bash
   kubectl create secret docker-registry onpremise-registry-creds \
     --docker-server=docker.registry.example.com \
     --docker-username=registry \
     --docker-password=DOCKERregistryP@ssW0rd
   ```
   Укажите имя секрета в `imagePullSecrets` в values для каждого сервиса.

**Префикс имён релизов (миграция легаси-окружений).** По умолчанию релизы именуются без
префикса (`keys`, `catalog-api`). Для миграции легаси-окружений (in-place апгрейд существующих
релизов `{env}-{service}`) задайте в файле окружения или общем слое `_common.yaml.gotmpl`
`- releasePrefix: '{{ .Environment.Name }}-'`: релизы получатся `staging-keys`,
`staging-catalog-api` и т.д.

**Префикс ingress-хостов.** Аналогично, DNS-имена ingress строятся из `ingressHostPrefix`
(по умолчанию пусто): `{ingressHostPrefix}search-api.{{ domain }}`. Для легаси-схемы с префиксом
окружения (`staging-search-api.{{ domain }}`) задайте в файле окружения или `_common.yaml.gotmpl`
`- ingressHostPrefix: '{{ .Environment.Name }}-'`.

---

## Секреты

Для секретов выделен отдельный тип файлов - `*.secrets.yaml`. Открытые values-файлы
(`*.yaml.gotmpl`) содержат только конфигурацию. Файлы комбинируются под требования:

- **комбинация** (базовый вариант, так устроен `example/`) - конфигурация в
  `*.yaml.gotmpl`, секретные блоки целиком в `*.secrets.yaml`;
- **только открытые** - значения из secrets-файла переносятся в открытый values-файл,
  secrets-файл удаляется (шифрование не требуется);
- **только зашифрованные** - всё содержимое переносится в secrets-файл, открытый
  файл удаляется.

Чтобы добавить секреты сервису, создайте файл
`<HELMFILE_VALUES>/values/<группа>/<сервис>/<env>.secrets.yaml`:

```yaml
# <HELMFILE_VALUES>/values/api-platform/styles/sandbox.secrets.yaml
postgres:
  host: postgresql
  port: 5432
  username: styles
  password: styles_password
```

Подтипы файлов с секретами:

| Тип | Файл | Что содержит |
|---|---|---|
| Окружение | `<HELMFILE_VALUES>/environments/<env>.secrets.yaml` | секреты вне отдельных релизов (state-уровень, хуки): `dgctlStorage` - учётные данные S3, общие для всех сервисов; партнёрский `key`; `license.key` |
| Общий слой окружений | `<HELMFILE_VALUES>/environments/_common.secrets.yaml` | значения, одинаковые у всех окружений values-каталога (S3-креды `dgctlStorage`, лицензия); ниже приоритетом `<env>.secrets.yaml` |
| Сервис | `<HELMFILE_VALUES>/values/**/<env>.secrets.yaml` | блоки с учётными данными сервисов: PostgreSQL, Kafka, Redis, Cassandra, ClickHouse; сервисные токены keys |
| dgctl | `<HELMFILE_VALUES>/dgctl/dgctl-config-<env>.yaml` | лицензионный ключ, учётные данные S3 и registry |

### Шифрование

Расшифровка выполняется на лету плагином [helm-secrets](https://github.com/jkroepke/helm-secrets). Вариант без шифрования -
[Vault (vals)](#vault-vals).

### Sandbox (age)

1. Сгенерируйте age-ключ (публичный ключ выведется на экран):
   ```bash
   age-keygen -o ~/.config/sops/age/keys.txt
   ```
2. Укажите публичный ключ (`age1...`) в `.sops.yaml` (только в `example/` - конфиги вне
   `example/` не шифруются).
3. Зашифруйте все секретные файлы (правила `.sops.yaml` применятся автоматически):
   ```bash
   find $HELMFILE_VALUES -path '*sandbox*' -name '*.yaml' -exec sops --config $HELMFILE_VALUES/.sops.yaml -e -i {} \;
   ```
   > `sops -e -i` принимает один файл за раз - `-exec ... \;`, не `{} +`.
   > `--config` указывает путь к `.sops.yaml` явно - без него sops ищет конфиг
   > от текущей директории (это же правило использует create_sandbox_key.sh).
   > Шифруются только файлы под правилами `.sops.yaml`: sandbox-secrets
   > (`.*sandbox.*secrets\.yaml`), temp-файлы хука ключа (`.*sandbox-key-work.*`)
   > и dgctl-конфиги (`.*dgctl-config-.*`). Staging и остальные файлы sops
   > отклонит - добавьте правило, когда появится staging-бэкенд.
4. Деплой - helmfile расшифровывает на лету:
   ```bash
   helmfile -e sandbox -f $HELMFILE_VALUES/deploy/sandbox.yaml.gotmpl sync --selector group=infra
   ```

Повседневные операции: `sops <файл>` (редактирование с расшифровкой/зашифровкой), `sops -d <файл>` (просмотр).

Обратная расшифровка:

```bash
find $HELMFILE_VALUES -path '*sandbox*' -name '*.yaml' -exec sops --config $HELMFILE_VALUES/.sops.yaml -d -i {} \;
```

### Staging (любой бэкенд)

sops поддерживает [несколько бэкендов](https://github.com/getsops/sops#usage): age, GPG,
Vault Transit и др. Выбор - в правилах `.sops.yaml` (`age:`/`pgp:`/`hc_vault:`; о Vault
подробнее в разделе [Vault](#vault-vals) ниже).
Для миграции на другой бэкенд: `sops updatekeys -y <файл>` (приводит recipients к текущим правилам).

### Vault (vals)

Секреты можно брать из удалённых хранилищ (HashiCorp Vault, AWS Secrets Manager, Azure Key
Vault и др.) через [vals](https://github.com/helmfile/vals) - двумя способами; оба не требуют
ни шифрования sops, ни файлов `*.secrets.yaml`.

**Способ 1 - ссылки в обычных values-файлах (без плагина helm-secrets).** helmfile сам
разворачивает `ref+...`-ссылки при рендере values - пишите их прямо в `*.yaml.gotmpl`:

```yaml
# values/api-platform/styles/<env>.yaml.gotmpl
postgres:
  host: postgresql
  password: ref+vault://secret/2gis/styles#/db-password
```

```bash
export VAULT_ADDR=... VAULT_TOKEN=...   # должны быть заданы на момент деплоя
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=core
```

Файлы `*.secrets.yaml` (опциональные) в этом режиме просто удаляются.

**Способ 2 - ссылки в secrets-файлах (через helm-secrets).** Держите `ref+...` в
`*.secrets.yaml` (подключаются полем `secrets:`) и включите vals-бэкенд плагина:

```bash
export HELM_SECRETS_BACKEND=vals   # vals >= 0.22.0 в PATH; для Vault - VAULT_ADDR/VAULT_TOKEN
```

Файлы остаются открытыми и коммитятся как есть - значения подставляются в момент
`template`/`sync`/`apply`. Этап шифрования (sops, `.sops.yaml`, шаги 1-3 выше) не нужен.

---

## Развёртывание

> **Важно.** Перед установкой убедитесь, что все внешние зависимости развёрнуты и доступны
> (PostgreSQL, S3, Kafka, Redis, Elasticsearch, ClickHouse, Cassandra, Keycloak) либо развёрните группу `infra`
> встроенными чартами `services/infra/` (для тестовых окружений).

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

Состав группы `core`:

| Сервис | Описание | Инфраструктура | Сервисы |
|---|---|---|---|
| License | Управление лицензиями 2GIS | S3 | - |
| Keys | Управление API-ключами | PostgreSQL, S3, Redis (опц.), Kafka (опц.) | Keycloak (опц.) |
| Keycloak | Аутентификация пользователей (OIDC) | PostgreSQL | - |

Установите группу `core` (keys и keycloak не зависят от лицензии):

```bash
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=core
```

**Лицензия.** При первом запуске pod license не стартует - это ожидаемое поведение. Получите файл лицензии:

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

Проверьте статус лицензии: [License](https://docs.2gis.com/on-premise-api-platform/installation#check-license-status).

**API-ключи.** После установки добавьте администратора и создайте API-ключ. Следуйте документации: [Keys](https://docs.2gis.com/on-premise-api-platform/installation#fetch-service-keys).

**Keycloak.** Войдите в Keycloak admin console и перегенерируйте client secrets для каждого realm. Обновите их в env-specific values сервисов.

### 2. API-платформа

Состав группы `api-platform`:

| Сервис | Описание | Инфраструктура | Сервисы |
|---|---|---|---|
| Stat Receiver + Stat API | Сбор статистики вызовов API | ClickHouse, Kafka | - |
| Traffic Proxy | Прокси для API пробок | - | - |
| MapGL JS API | API картографических движков | - | Keys API, Traffic Proxy (опц.) |
| Tiles API | Тайловый сервер | S3, Cassandra | License, Keys API, Stat Receiver (опц.) |
| Static API | Статические изображения карт | - | Tiles API, License, Keys API (опц.) |
| Styles API | Управление стилями карт | PostgreSQL, S3 | - |
| Search API | Поиск мест, геокодирование, подсказки | S3 | - |
| Search API v8 (опционально) | Новая версия Search API | S3 | - |
| Raster JS API | Растровые карты (Leaflet) | - | Tiles API, Catalog API, Keys API |
| Catalog API | Каталог данных | PostgreSQL + PostGIS, S3 | License |
| Navi-Castle | Распределение данных для маршрутизации | S3, Kafka (опц.) | - |
| Navi-Back | Построение маршрутов | Kafka (опц.), S3 (опц.) | Navi-Castle, License, Traffic Proxy (опц.) |
| Navi-Attractor | Привязка точек к графику (генерируется из navi-rules) | Kafka (опц.), S3 (опц.) | Navi-Back |
| Navi-Splitter | Разделение маршрутов (генерируется из navi-rules) | - | Navi-Back |
| Navi-Router | Проксирование запросов навигации | - | Navi-Back, Keys API |
| Navi-Front | Frontend для API навигации | - | Navi-Router |
| Navi Async Matrix | Асинхронная матрица расстояний | PostgreSQL, Kafka, S3 | Navi-Castle, Keys API |
| Navi VRP Solver + VRP Task Manager | Решение задачи маршрутизации транспорта | PostgreSQL, Kafka, S3 | Navi-Castle, Navi-Front, Keys API |
| Navi Restrictions | Ограничения проезда | PostgreSQL | Navi-Castle, Navi-Back |
| Platform Manager | Веб-интерфейс управления платформой | - | Keycloak (OIDC), Keys API, License |

```bash
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=api-platform
```

Если все параметры настроены правильно, платформа установится с первого раза.

Проверьте работоспособность:

**API карт:**
- [MapGL JS API](https://docs.2gis.com/on-premise-api-platform/installation#test-mapgl-js-api)
- [Tiles API](https://docs.2gis.com/on-premise-api-platform/installation#test-tiles-api)
- [Static API](https://docs.2gis.com/on-premise-api-platform/installation#test-static-api)
- [Styles API](https://docs.2gis.com/on-premise-api-platform/installation#test-styles-api)

**API поиска:** [общая проверка](https://docs.2gis.com/on-premise-api-platform/installation#test-search)
- Places API
- Geocoder API
- Suggest API
- Categories API
- Regions API

**API навигации:**
- [Navi-Castle](https://docs.2gis.com/on-premise-api-platform/installation#test-navi-castle)
- [Navi-Back](https://docs.2gis.com/on-premise-api-platform/installation#test-navi-back)
- [Navi-Splitter](https://docs.2gis.com/on-premise-api-platform/installation#test-navi-splitter)
- [Navi-Router](https://docs.2gis.com/on-premise-api-platform/installation#test-navi-router)
- [Navi-Front](https://docs.2gis.com/on-premise-api-platform/installation#test-navi-front)
- [Distance Matrix Async API](https://docs.2gis.com/on-premise-api-platform/installation#test-distance-matrix-async-api)
- [Restrictions API](https://docs.2gis.com/on-premise-api-platform/installation#test-restrictions-api)
- [VRP Solver + VRP Task Manager (TSP API)](https://docs.2gis.com/api/navigation/tsp/overview)

**Сервис статистики:**
- [Stat Receiver](https://docs.2gis.com/on-premise-api-platform/installation#test-stat-collection-service)

**Другие сервисы:**
- [Traffic Proxy](https://docs.2gis.com/on-premise-api-platform/installation#test-traffic-proxy)
- [Менеджер Платформы](https://docs.2gis.com/on-premise-api-platform/installation#test-pm)

**Менеджер Платформы.** После установки настройте аутентификацию пользователей через Keycloak (OIDC). В Keycloak создайте client для Platform Manager и укажите client secret в env-specific values. Подробнее: [настройка аутентификации](https://docs.2gis.com/on-premise-api-platform/installation#install-pm).

**Мобильный SDK.** Мобильные SDK (iOS, Android, Flutter) являются клиентскими библиотеками и не развёртываются в Kubernetes. Для их подключения используйте `vendor-config.json` с адресами ваших On-Premise сервисов.

### 3. Pro (опционально)

Состав группы `pro`:

| Сервис | Описание | Инфраструктура | Сервисы |
|---|---|---|---|
| Pro API | Бэкенд 2ГИС Про (API, Permissions, Tasks) | PostgreSQL, S3, Elasticsearch, Kafka, Redis | Catalog API, Navi-Front, Search API, License, Keycloak (опц.) |
| Pro UI | Веб-интерфейс 2ГИС Про | S3 | Pro API, MapGL JS API |

```bash
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=pro
```

Настройка и проверка работоспособности:
- [Проверка](https://docs.2gis.com/on-premise-pro/install/installation#test)
- [Настройка аутентификации](https://docs.2gis.com/on-premise-pro/install/authentication)

### 4. Citylens (опционально)

Состав группы `citylens`:

| Сервис | Описание | Инфраструктура | Сервисы |
|---|---|---|---|
| CityLens API + Routes API | API Ситискан (съёмка, треки, планирование маршрутов) | PostgreSQL + PostGIS, S3, Kafka | MapGL JS API, Tiles API, Pro API, Navi-Front, Keys API, Keycloak (опц.) |
| CityLens Routes UI | Веб-интерфейс планирования маршрутов Ситискан | - | CityLens Routes API, Catalog API, MapGL JS API, Keycloak (OIDC) |

```bash
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=citylens
```

Настройка и проверка работоспособности:
- [Проверка](https://docs.2gis.com/on-premise-citylens/install/installation#test)
- [Настройка аутентификации](https://docs.2gis.com/on-premise-citylens/install/authentication)

---

## Sandbox-пример (kind)

`installer/helmfile/example/environments/sandbox.yaml.gotmpl` + `deploy/sandbox.yaml.gotmpl` - быстрый
kubernetes-ready пример API-платформы (infra + core + api-platform) для локального кластера `kind`.

> Образы infra (bitnami: PostgreSQL, Kafka, MinIO, Cassandra, ClickHouse, Elasticsearch) загружаются из
> публичного `docker.io`. Образы 2GIS (core, api-platform) - из локального registry `kind-registry:5000`,
> который заполняется через `dgctl pull --apps-to-registry`.
>
> В отличие от [production-сценария](https://docs.2gis.com/on-premise-api-platform/installation#configure-host-registry),
> где требуется HTTPS-registry с аутентификацией и `imagePullSecrets`, sandbox использует локальный
> HTTP-registry без аутентификации (доверие настраивается скриптом `installer/scripts/kind-up.sh`
> через `hosts.toml` в нодах).
>
> Официальная документация: [Installation](https://docs.2gis.com/on-premise-api-platform/installation).

### Требования

Общие - в начале README (Kubernetes, Helm, Helmfile, kubectl, sops, лицензионный ключ). Для sandbox дополнительно: Docker и локальный кластер [kind](https://kind.sigs.k8s.io/).

### Шаги развёртывания

Команды выполняются из корня репозитория. Переменные `HELMFILE_BASE`/`HELMFILE_VALUES`
не нужны: без них helmfile и скрипты используют дефолт - `installer/helmfile/example`.

1. **Заполните и зашифруйте секреты** - лицензионный ключ (`# sandbox-todo`) в
   `installer/helmfile/example/environments/sandbox.secrets.yaml` (`license.key`) и
   `installer/helmfile/example/dgctl/dgctl-config-sandbox.yaml` (`key`), затем зашифруйте
   файлы (см. [Секреты](#секреты)):
   ```bash
   find installer/helmfile/example -path '*sandbox*' -name '*.yaml' -exec sops --config installer/helmfile/example/.sops.yaml -e -i {} \;
   ```

2. **Kind-кластер + локальный registry** - идемпотентный скрипт (можно запускать повторно):
   ```bash
   installer/scripts/kind-up.sh
   ```
   Скрипт создаёт кластер `2gis-on-premise`, namespace `sandbox`, HTTP-registry `kind-registry:5000`
   и настраивает доверие к нему в каждой ноде через `hosts.toml`
   (см. [kind docs: local registry](https://kind.sigs.k8s.io/docs/user/local-registry/)).
   Порты 80/443 проброшены на хост (`extraPortMappings` в `installer/scripts/kind-config.yaml`).

3. **Развёртывание infra** (traefik, PostgreSQL, Kafka, MinIO, Redis, Cassandra, ClickHouse, Elasticsearch) -
   не требует лицензии, образы из публичного `docker.io`:
   ```bash
   helmfile -e sandbox -f installer/helmfile/example/deploy/sandbox.yaml.gotmpl sync \
     --selector group=infra
   ```
   > **Почему `sync`, а не `apply`?** `apply` запускает `helm diff`, который валидирует CRD
   > (traefik IngressRoute, Middleware) до их установки. При первом деплое используйте `sync`;
   > для последующих обновлений - `apply`.

4. **Загрузка образов и данных 2GIS** (требует лицензионный ключ, заполненный в шаге 1):
   1. Убедитесь, что в `/etc/hosts` есть запись для S3-хоста (`s3.<domain>`, IP - адрес хостовой
      машины) - через неё `dgctl pull` загружает данные в MinIO. Хост входит в готовый блок
      `*.sandbox`-хостов:
        ```bash
        installer/scripts/sandbox-hosts.sh   # выведет готовый блок *.sandbox-хостов
        # вставьте вывод в /etc/hosts вручную
        ```

        > Скрипт выводит также хосты опциональных сервисов, которых нет в sandbox
        > (citylens, pro, kibana и др.) - они резолвятся в traefik и отдадут 404; это не ошибка.
   2. Загрузите артефакты (конфиг - `installer/helmfile/example/dgctl/dgctl-config-sandbox.yaml`,
       результат - `installer/dgctl/auto_values/`):
       ```bash
       ./installer/dgctl/pull.sh dgctl-config-sandbox.yaml
       ```
       Скрипт пушит образы 2GIS в `kind-registry:5000` и генерирует `auto_values/` -
       номера манифестов последнего pull; это дефолт для сервисов, коммитится как актуальный.
       Подробнее: [Fetch Installation Artifacts](https://docs.2gis.com/on-premise-api-platform/installation#fetch-artifacts).

       > Про фиксацию/переключение манифестов (закрепить конкретный набор или откатиться) -
       > см. шаг 4 раздела [Подготовка конфигурации](#подготовка-конфигурации).

5. **Развёртывание core** (License, Keycloak, Keys) - образы из `kind-registry:5000`:
   ```bash
   helmfile -e sandbox -f installer/helmfile/example/deploy/sandbox.yaml.gotmpl sync \
     --selector group=core
   ```
   - Keycloak: realms импортируются автоматически через `keycloakConfigCli` (чарт - `charts/keycloak/realms/`);
   - Keys: API-ключ создаётся автоматически `postsync`-хуком (`installer/scripts/create_sandbox_key.sh`);
   - License: при первом запуске pod может не стартовать без валидной лицензии -
     [получите лицензию](https://docs.2gis.com/on-premise-api-platform/installation#get-license)
     и повторите деплой.

6. **Развёртывание API-платформы** (22 релиза: search, tiles, catalog, navi, styles, mapgl, …):
   ```bash
   helmfile -e sandbox -f installer/helmfile/example/deploy/sandbox.yaml.gotmpl apply \
     --selector group=api-platform \
     --diff-args --skip-schema-validation --args --skip-schema-validation
   ```

   > **`--skip-schema-validation`** нужен, потому что values-схемы api-platform-чартов не принимают
   > `dgctlDockerRegistry` в формате `host:port` (в sandbox - `kind-registry:5000`).

7. **Доступ** - сервисы доступны по hostname `*.sandbox` (например `http://search-api.sandbox`).
   Добавьте в `/etc/hosts` блок из `installer/scripts/sandbox-hosts.sh`
   (тот же шаг, что и в п. 4) или используйте `--resolve` в curl:
   ```bash
   curl --resolve search-api.sandbox:80:127.0.0.1 "http://search-api.sandbox/v2/search?q=cafe"   # → 200
   ```
   Проверка работоспособности - по спискам "Проверьте работоспособность" в разделах выше:
   [1. Базовые сервисы (Core)](#1-базовые-сервисы-core) и [2. API-платформа](#2-api-платформа).

Окружение предназначено для проверки конфигураций; для реальной установки используйте `staging`.

## Обновление

Обновление сервисов и данных выполняется в несколько шагов: определиться с версией, загрузить/обновить артефакты, применить их через helmfile.

### 1. Обновление версии сервисов

Вручную менять файлы вне директории `example/` не рекомендуется. Чтобы перейти на новую версию, используйте один из способов:

- **Поднять версию конкретного компонента для конкретного окружения** - задайте её в конфигурации окружения (директория `example/`); перед этим обязательно ознакомьтесь с изменениями версии (Breaking Changes);
- **Обновить installer целиком** - выполните `git pull` этого репозитория на целевую версию (тег) или `master`; версии компонентов обновятся автоматически.

Версия данных (манифест) обновляется автоматически на шаге 2 (`dgctl pull --generate-values`), вручную править её не нужно.

### 2. Загрузка актуальных артефактов (данных и образов)

Стандартный контур (с доступом к реестру/S3) выполняется готовым скриптом `installer/dgctl/pull.sh` (см. `installer/dgctl/README.md`):

```bash
${HELMFILE_BASE}/../dgctl/pull.sh dgctl-config-sandbox.yaml
```

Скрипт вызывает `dgctl pull --generate-values --apps-to-registry`: обновляет данные (новый `manifest`) и образы в реестре, записывает актуальные значения в `installer/dgctl/auto_values/<component>/general.yaml`.
Если выполнять команду вручную, обязательно монтируйте `-v $(pwd)/values:/values`, иначе сгенерированный `general.yaml` удаляется после запуска:

```bash
docker run --rm \
  -v $(pwd)/dgctl-config.yaml:/dgctl-config.yaml \
  -v $(pwd)/values:/values \
  --user $(id -u):$(id -g) \
  2gis/dgctl:3 \
  pull --config=/dgctl-config.yaml --apps-to-registry --generate-values
```

Проверить список манифестов можно `dgctl manifest list`; очистку старых манифестов выполняет `installer/dgctl/manifest_cleanup.sh`.
Подробнее о загрузке артефактов: [Fetch Installation Artifacts](https://docs.2gis.com/on-premise-api-platform/installation#fetch-artifacts).

Изолированный контур (без доступа к сети/реестру):

- используйте двуххостовую схему из `installer/dgctl-fs/` (`dgctl pull` на хосте с интернетом → перенос директории → `dgctl restore`);
- скопируйте сгенерированные `installer/dgctl-fs/values/<component>/general.yaml` в `installer/dgctl/auto_values/<component>/general.yaml` (номер манифеста там уже актуальный, вручную не правится; см. `installer/dgctl-fs/README.md`).

### 3. Применение обновлений через helmfile

`helmfile apply` идемпотентен: он применяет и устанавливает, и обновляет релизы. Достаточно повторно выполнить те же команды, что при установке, целиком или по группам/сервисам:

```bash
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=infra
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=core
helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl apply --selector group=api-platform
```

Подробнее о сценариях обновления сервисов и данных (через `helm`): [Updating services and datasets](https://docs.2gis.com/on-premise-api-platform/overview/lifecycle#update-services-and-datasets).

## Дополнительные возможности

**Хуки (presync / postsync).** Для каждого сервиса можно добавить helmfile-хуки,
которые выполняются до или после развёртывания. Это позволяет автоматизировать
ручные действия - создание топиков Kafka, генерацию токенов, импорт данных.

---

## Values для сервисов navi-back

### `services/api-platform/navi-back.yaml.gotmpl`

- По умолчанию все сервисы navi-back берут значения из файла `values/api-platform/navi-back/{{ $.Environment.Name }}.yaml`
- Чтобы параметризовать конкретный сервис, необходимо добавить values с именем `values/api-platform/navi-back/{{ $.Environment.Name }}-{{ $service.name }}.yaml`

### Асинхронный деплой (DMA - Distance Matrix Async)

Асинхронные сервисы управляются через тот же `services/api-platform/navi-back.yaml.gotmpl`.
Если присутствует файл `values/api-platform/navi-rules/{{ $.Environment.Name }}-rules-dma.yaml.gotmpl`,
для каждого rule из него автоматически создаётся пара navi-back + navi-attractor с Kafka-транспортом.

Параметры (топики Kafka, `navigroup`, `rules`) генерируются динамически из имени сервиса - отдельные dma-файлы values не нужны.

**navi-back** (async-релизы) берут values из:
- `values/api-platform/navi-back/{{ $.Environment.Name }}.yaml` - общие параметры (ресурсы и т.д.)
- `values/api-platform/navi-back/{{ $.Environment.Name }}-async.yaml` - настройки подключения к Kafka и S3

**navi-attractor** (async-релизы) берут values из:
- `values/api-platform/navi-attractor/{{ $.Environment.Name }}.yaml` - общие параметры (ресурсы и т.д.)
- `values/api-platform/navi-attractor/{{ $.Environment.Name }}-async.yaml` - настройки подключения к Kafka и S3

Настройки Kafka для сервиса navi-async-matrix задаются отдельно в `values/api-platform/navi-async-matrix/{{ $.Environment.Name }}.yaml`

---

## Конфигурация Traefik

### Структура

- `installer/helmfile/values/infra/traefik.yaml.gotmpl` - глобальные настройки по умолчанию (ports, deployment, providers, logs, metrics, middleware definitions)
- `installer/helmfile/example/values/infra/traefik/<env>.yaml.gotmpl` - переопределения для конкретного окружения (dashboard, trustedIPs, TLS certificates)

**Пример:** `installer/helmfile/example/values/infra/traefik/staging.yaml.gotmpl`

### Порядок загрузки values

В `installer/helmfile/services/infra/traefik.yaml.gotmpl`:

```yaml
values:
  - {{ .Values.basePath }}/values/infra/traefik.yaml.gotmpl
  - {{ .Values.valuesPath }}/values/infra/traefik/{{ .Environment.Name }}.yaml.gotmpl
```

1. **Дефолты** (`traefik.yaml.gotmpl`) - базовая конфигурация, middleware определения
2. **Environment-specific** (`<env>.yaml.gotmpl`) - переопределения с более высоким приоритетом

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
ingressController: traefik
```

---

## Ingress аннотации

Поддержаны два типа `Ingress Controller`: `nginx` и `traefik`.
Выбор осуществляется через переопределение переменной `ingressController`.

Для управления аннотациями создан шаблон `installer/helmfile/values/ingressAnnotations.yaml.gotmpl`, который содержит:

- `cors` - настройки политик кросс-доменных запросов (Cross-Origin Resource Sharing)
- `proxy` - настройки проксирования (таймауты, лимиты тела запроса)
- `corsGet` - настройка, выделенная под s3 (где разрешён только `GET`)
- `vpn` - настройка, разрешающая доступ только из указанных IP-диапазонов

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
