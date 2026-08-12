# dgctl через fs

Дока по сценарию с закрытым контуром без интернета. Нужен хост с интернетом и диском или копированием по сети.

Основная документация [2GIS CLI - dgctl](https://docs.2gis.com/on-premise-api-platform/overview/2gis-cli/overview)

## Обновление данных и образов сервисов

### Предварительные требования

Для запуска докер образов нужно:

- чтобы ваш пользователь был в группе docker (запускать docker без sudo)
- либо запускать через sudo

### Копируем образ dgctl на хост где нет интернета и будет запускаться restore

Смотрим локальные docker-образы

```sh
docker images
docker pull 2gis/dgctl:3
```

Сохраняем образ dgctl в архив

```sh
docker save -o dgctl_3.tar 2gis/dgctl:3
```

Копируем образ на хост где будет импорт данных (dgctl restore) `host_without_internet` или через flash-disk

```sh
scp dgctl_3.tar host_without_internet:/tmp
```

На хосте `host_without_internet` загружаем docker-образ

```sh
docker load -i /tmp/dgctl_3.tar
```

### Создаем необходимые директории

В той директории, откуда будете запускать скрипты, необходимо создать следующие директории под своим пользователем

```sh
mkdir dgctl-source
mkdir dgctl-source-license
mkdir values
```

### Редактируем конфигурационные файлы

Нужно заполнить кредами, прописать s3 и registry

`dgctl-config-fs.yaml` и `dgctl-config-s3.yaml`

### Запускаем dgctl pull

```sh
./dgctl-pull-fs.sh
```

Дожидаемся завершение выполнения скрипта

### Копируем данные на хост или на flash-disk

```sh
scp -r dgctl-source host_without_internet:/tmp/dgctl-source
```

### Запускаем dgctl restore

```sh
./dgctl-restore-fs.sh
```

Дожидаемся рестора данных

### Импорт данных из S3

Далее стандартная процедура обновления сервиса/данных через helmfile

Пример:

Меняем манифест на номер манифеста полученные с данными после выполнения `./dgctl-restore-fs.sh`

Для core сервисов:

```yaml
dgctlStorage:
  manifest: 'manifests/core/1715765468.json'
```

Для api-platform сервисов:

```yaml
dgctlStorage:
  manifest: 'manifests/api-platform/1715761412.json'
```

```sh
cd helmfile
helmfile -e training -f services/tiles.yaml apply
```

## Обновление лицензии

Подразумеваем что образ dgctl есть во всех контурах.

### 1 Скопируйте файлы для запроса лицензии из S3 в fs

Выполнять на хосте  закрытом контуре, где есть s3

```sh
./dgctl-license-1-prepare.sh
```

Содержимое /dgctl-source-license перенести на хост с интернетом

### 2 Запрос лицензий

Выполнять на хосте где есть интернет

```sh
./dgctl-license-2-request.sh
```

Содержимое /dgctl-source-license перенести на хост в закрытый контур

### 3 Скопируйте файл с лицензией из fs в S3

Выполнять на хосте в закрытом контуре, где есть s3

```sh
./dgctl-license-3-restore.sh
```
