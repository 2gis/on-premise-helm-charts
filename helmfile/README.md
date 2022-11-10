### Скачать данные и загрузить в s3
Данные и образы скачиваем по инструкции https://docs.2gis.com/ru/on-premise/dgctl

Для ускорения можно использовать флаги --only-data и --service

В values/dgctl.yaml указываем адрес реджистри, а который были залиты данные, адрес с3, бакет и ключи доступа

Проходимся по файлам в директории values и актуальными значениями

Выставляем нужные значения в base.yaml


### Деплой castle
```
helmfile -f deploy/navi-castle.yaml sync
```
После успешного деплоя запрос /index.json должен вернуть список загруженных проектов


### Подготовка для деплоя асинхронных матриц
- В s3 создаем бакет
- В postgres создаем базу
- В kafka создаем 3 топика
- Деплоим keys service 

### Деплой бэкенда для асинхронных матриц

По дефолту подтянутся данные по всем проектам, для проверки деплоя можно выставить значение customProjectNavi: true в файле base.yaml, если деплой пройдет успешно - выставить false и повторить развертывание бэкенда
```
helmfile -f deploy/navi-back-async.yaml sync
```

### Деплой апи для асинхронных матриц
```
helmfile -f deploy/navi-async-matrix.yaml sync
```

### Деплой бэкенда Directions API авто
```
API=directions_car helmfile -f deploy/navi-back-custom.yaml sync 
```

### Деплой бэкенда Directions API пешеходы
```
API=directions_ped helmfile -f deploy/navi-back-custom.yaml sync 
```

### Деплой бэкенда Directions API велосипеды
```
API=directions_bic helmfile -f deploy/navi-back-custom.yaml sync 
```

### Деплой бэкенда Directions API такси
```
API=directions_taxi helmfile -f deploy/navi-back-custom.yaml sync 
```

### Деплой бэкенда Distance Matrix API (до 25х25)
```
API=distance_matrix helmfile -f deploy/navi-back-custom.yaml sync
```

### Деплой бэкенда Public Transport
```
API=public_transport helmfile -f deploy/navi-back-custom.yaml sync
```

### Деплой бэкенда Pairs Directions API
```
API=pairs helmfile -f deploy/navi-back-custom.yaml sync
```

### Деплой бэкенда Truck Directions API
```
API=truck helmfile -f deploy/navi-back-custom.yaml sync
```
### Деплой navi-router
```
helmfile -f deploy/navi-router.yaml sync
```

### Деплой navi-front
```
helmfile -f deploy/navi-front.yaml sync
```
