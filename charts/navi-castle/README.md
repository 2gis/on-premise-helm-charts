# Castle Helm Chart
## Описание
Данный helm-чарт предназначен для установки экземпляра Castle в режиме statefulset, который будет хранить данные, необходмые для экземпляра Navigation. Также параллельно запускают CronJob'ы, которые обновляют данные, полученные с S3-хранлилища, на экземплярах Castle.


## Описание values
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object or string | `{}` |  |
| annotations | object | `{}` |  |
| ingress.className | string | `"nginx"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.tls | list | `[]` |  |
| labels | object | `{}` |  |
| nodeSelector | object | `{}` |  |
| podDisruptionBudget.enabled | bool | `false` |  |
| podDisruptionBudget.maxUnavailable | int | `1` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| pullPolicy | string | `"IfNotPresent"` |  |
| replicaCount | int | `1` |  |
| resources | object | {} |  |
| resources.limits.cpu | int | `1` |  |
| resources.limits.memory | string | `"512Mi"` |  |
| resources.requests.cpu | string | `"50m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| revisionHistory | int | `1` |  |
| service.annotations | object | `{}` |  |
| service.labels | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"None"` |  |
| tolerations | object | `{}` |  |
| castle.image | object | `{}` | Castle image  |
| castle.image.repository | string | `2gis/castle` | Image name  |
| castle.image.tag | string | `''` | Image tag  |
| castle.castle_data_path | string | `/opt/castle` | Store path for castle data  |
| caslte.s3_server | string | `""` | URL of S3 server  |
| caslte.s3_bucket | string | `""` | S3 bucket  |
| castle.s3_login | string | `""` | S3 login  |
| castle.s3_password | string | `""` | S3 password |
| persistentVolume | object | `{}` | Persistent volume definition |
| persistentVolume.enabled | string | `"false"` | Enable or disable persistent volume claim |
| persistentVolume.accessModes | array | `[]` | Access modes for PV |
| persistentVolume.storageClass | string | `""` | Storage class for PV |
| persistentVolume.size | string | `""` | Size of PV |
| cron | object | `{}` | Cron job definition |
| cron.enabled | string | `"false"` | Enable or disable cron | 
| cron.schedule | string | `""` | Schedule in cron format |
| cron.concurrencyPolicy | string | `""` | Concurrency policy |
| cron.concurrencyPolicy | string | `""` | Concurrency policy |
| cron.successfulJobsHistoryLimit | string | `""` | Number of stored succeful jobs |






## Пример деплоя
1. Создать файл castle_values.conf со своими параметрами для подключения к S3-хранилищу
```
dgctl_docker_registry: 'your-docker-hub-registry'
 
replicaCount: 2

resources:
  limits:
    cpu: 1000m
    memory: 512Mi
  requests:
    cpu: 500m
    memory: 128Mi

castle:
  castle_data_path: '/opt/castle/data/'
  s3_server: "server:9000"
  s3_bucket: 'routing'
  s3_login: 'admin'
  s3_password: 'admin'

persistentVolume:
  enabled: false
  accessModes:
    - ReadWriteOnce
  storageClass: ceph-csi-rbd
  size: 5Gi

cron:
  enabled: false
  schedule: "*/10 * * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 3
```

2. Запусить установку helm-чарта
```
helm upgrade --install stage-castle . -f castle_values.yaml
```
3. Проверить работоспособность можно следующим способом:
Прокинуть порт через kubectl 

```
kubectl port-forward stage-castle-0 7777:8080
```
Отправить GET-запрос, в ответ должен появиться список файлов

```
curl -Lv http://localhost:7777/


<html>
<head><title>Index of /</title></head>
<body>
<h1>Index of /</h1><hr><pre><a href="../">../</a>
<a href="lost%2Bfound/">lost+found/</a>                                        09-Mar-2022 13:33                   -
<a href="packages/">packages/</a>                                          09-Mar-2022 13:33                   -
<a href="index.json">index.json</a>                                         09-Mar-2022 13:33                 634
<a href="index.json.zip">index.json.zip</a>                                     09-Mar-2022 13:33                 357
</pre><hr></body>
</html>
```