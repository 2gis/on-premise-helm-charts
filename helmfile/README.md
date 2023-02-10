### Скачать данные и загрузить в s3
Данные и образы скачиваем по инструкции https://docs.2gis.com/ru/on-premise/dgctl

Для ускорения можно использовать флаги --only-data и --service

Копируем директорию helmfile_falues на один уровень с on-premise-helm-charts:
..
helmfile_values
on-premise-helm-charts

либо переносим ее в удобное для нас место, прописав абсолютный путь до нее в переменную окружения HELMFILE_VALUES

Проходимся по файлам в директории helmfile_values и заполняем актуальными значениями

Выставляем нужные значения в base.yaml. 

Перед разворачиванием сервисов навигации должен быть задеплоен keys service

Пример команд для деплоя (в зависимости от того, где у нас располагаются helmfile_values, будет меняться путь до конфигов деплоя, ниже примеры для values расположенных на одном уровне с on-premise-helm-charts, команды запускаются из директории helmfile_values)
### Деплой castle
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-castle.yaml sync
```

### Деплой бэкенда Directions API авто
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=directions-car sync 
```

### Деплой бэкенда Directions API пешеходы
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=directions-pedestrian sync
```

### Деплой бэкенда Directions API велосипеды
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=directions-bicycle sync
```

### Деплой бэкенда Directions API такси
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=directions-taxi sync
```

### Деплой бэкенда Directions API грузовики
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=directions-truck sync
```

### Деплой бэкенда Pairs Directions API
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=pairs-directions sync
```

### Деплой бэкенда Public Transport
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=public-transport sync
```

### Деплой бэкенда Distance Matrix API (до 25х25)
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=distance-matrix sync
```

### Деплой бэкенда Distance Matrix API Async (более 25х25)
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=async sync
```

### Деплой фронтенда для Distance Matrix API Async (более 25х25)
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-async-matrix.yaml sync
```

### Деплой navi-router
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-router.yaml sync
```

### Деплой navi-front
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-front.yaml sync
```
