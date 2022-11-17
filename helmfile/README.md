### Скачать данные и загрузить в s3
Данные и образы скачиваем по инструкции https://docs.2gis.com/ru/on-premise/dgctl

Для ускорения можно использовать флаги --only-data и --service

В values/dgctl.yaml указываем адрес реджистри, а который были залиты данные, адрес с3, бакет и ключи доступа

Проходимся по файлам в директории values и актуальными значениями

Выставляем нужные значения в base.yaml. По дефолту подтянутся данные по всем проектам, для проверки деплоя можно выставить значение customProjectNavi: true в файле base.yaml, если деплой пройдет успешно - выставить false и повторить развертывание бэкенда

Перед разворачиванием сервисов навигации должен быть задеплоен keys service


### Деплой castle
```
helmfile -f deploy/navi-castle.yaml sync
```

### Деплой бэкенда Directions API авто
```
API=directions-car helmfile -f deploy/navi-back-custom.yaml sync 
```

### Деплой бэкенда Directions API пешеходы
```
API=directions-pedestrian helmfile -f deploy/navi-back-custom.yaml sync 
```

### Деплой бэкенда Directions API велосипеды
```
API=directions-bicycle helmfile -f deploy/navi-back-custom.yaml sync 
```

### Деплой бэкенда Directions API такси
```
API=directions-taxi helmfile -f deploy/navi-back-custom.yaml sync 
```

### Деплой бэкенда Directions API грузовики
```
API=directions-truck helmfile -f deploy/navi-back-custom.yaml sync
```

### Деплой бэкенда Pairs Directions API
```
API=pairs-directions helmfile -f deploy/navi-back-custom.yaml sync
```

### Деплой бэкенда Public Transport
```
API=public-transport helmfile -f deploy/navi-back-custom.yaml sync
```

### Деплой бэкенда Distance Matrix API (до 25х25)
```
API=distance-matrix helmfile -f deploy/navi-back-custom.yaml sync
```

### Деплой бэкенда Distance Matrix API Async (более 25х25)
```
helmfile -f deploy/navi-back-async.yaml sync
```

### Деплой фронтенда для Distance Matrix API Async (более 25х25)
```
helmfile -f deploy/navi-async-matrix.yaml sync
```

### Деплой navi-router
```
helmfile -f deploy/navi-router.yaml sync
```

### Деплой navi-front
```
helmfile -f deploy/navi-front.yaml sync
```
