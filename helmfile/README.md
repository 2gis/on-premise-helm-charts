#### Содержание
[Подготовка](#prepare)  
[Деплой castle](#castle)  
[Деплой бэкенда Directions API авто](#directions-car)  
[Деплой бэкенда Directions API пешеходы](#directions-pedestrian)  
[Деплой бэкенда Directions API велосипеды](#directions-bicycle)  
[Деплой бэкенда Directions API такси](#directions-taxi)  
[Деплой бэкенда Directions API грузовики](#directions-truck)  
[Деплой бэкенда Pairs Directions API](#pairs-directions)  
[Деплой бэкенда Public Transport](#public-transport)  
[Деплой бэкенда Distance Matrix API (до 25х25)](#distance-matrix)  
[Деплой бэкенда Distance Matrix API Async (более 25х25)](#async) 
[Деплой бэкенда Distance Matrix API Public Transport (до 10х10)](#distance-matrix-ctx) 
[Деплой GRPC-proxy для Distance Matrix API Async (более 25х25)](#grpc)  
[Деплой фронтенда для Distance Matrix API Async (более 25х25)](#async-front)  
[Деплой splitter для Distance Matrix API Public Transport (до 10х10)](#splitter)
[Деплой navi-router](#navi-router)  
[Деплой navi-front](#navi-front)  

<a name="prepare"><h3>Подготовка</h3></a>
Скачать данные и загрузить в s3
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

<a name="castle"><h3>Деплой castle</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-castle.yaml sync
```

<a name="directions-car"><h3>Деплой бэкенда Directions API авто</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=directions-car sync 
```

<a name="directions-pedestrian"><h3>Деплой бэкенда Directions API пешеходы</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=directions-pedestrian sync
```

<a name="directions-bicycle"><h3>Деплой бэкенда Directions API велосипеды</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=directions-bicycle sync
```

<a name="directions-taxi"><h3>Деплой бэкенда Directions API такси</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=directions-taxi sync
```

<a name="directions-truck"><h3>Деплой бэкенда Directions API грузовики</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=directions-truck sync
```

<a name="pairs-directions"><h3>Деплой бэкенда Pairs Directions API</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=pairs-directions sync
```

<a name="public-transport"><h3>Деплой бэкенда Public Transport</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=public-transport sync
```

<a name="distance-matrix"><h3>Деплой бэкенда Distance Matrix API (до 25х25)</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=distance-matrix sync
```

<a name="async"><h3>Деплой бэкенда Distance Matrix API Async (более 25х25)</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=async sync
```

<a name="distance-matrix-ctx"><h3>Деплой бэкенда Distance Matrix API Public Transport (до 10х10)</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-back-custom.yaml -l service=distance-matrix-ctx sync
```

<a name="async-front"><h3>Деплой фронтенда для Distance Matrix API Async (более 25х25)</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-async-matrix.yaml sync
```

<a name="grpc"><h3>Деплой GRPC-proxy для Distance Matrix API Async (более 25х25)</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-async-grpc.yaml sync
```

<a name="splitter"><h3>Деплой splitter для Distance Matrix API Public Transport (до 10х10)</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-splitter.yaml sync
```

<a name="navi-router"><h3>Деплой navi-router</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-router.yaml sync
```

<a name="navi-front"><h3>Деплой navi-front</h3></a>
```
helmfile -e test -f ../on-premise-helm-charts/helmfile/deploy/navi/navi-front.yaml sync
```
