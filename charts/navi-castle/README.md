# Castle Helm Chart
## Описание
Данный helm-чарт предназначен для установки экземпляра Castle в режиме statefulset, который будет хранить данные, необходмые для экземпляра Navigation. Также параллельно запускают CronJob'ы, которые обновляют данные, полученные с S3-хранлилища, на экземплярах Castle.


## Описание values
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| dgctlDockerRegistry | string | `""` | docker registry server name  |
| dgctlStorage.host | string | `""` | host:port of S3 server  |
| dgctlStorage.bucket | string | `""` | S3 bucket  |
| dgctlStorage.accessKey | string | `""` | S3 access key  |
| dgctlStorage.secretKey | string | `""` | S3 secret key |
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
| persistentVolume | object | `{}` | Persistent volume definition |
| persistentVolume.enabled | string | `"false"` | Enable or disable persistent volume claim |
| persistentVolume.accessModes | array | `[]` | Access modes for PV |
| persistentVolume.storageClass | string | `""` | Storage class for PV |
| persistentVolume.size | string | `""` | Size of PV |
| cron | object | `{}` | Cron job definition |
| cron.enabled.import | bool | `"false"` | If import cron job enabled (requires persistentVolume.enabled) |
| cron.enabled.restriction | bool | `"false"` | If restriction cron job enabled (requires persistentVolume.enabled) |
| cron.schedule.import | string | `""` | Schedule in cron format |
| cron.schedule.restriction | string | `""` | Schedule in cron format |
| cron.concurrencyPolicy | string | `""` | Concurrency policy |
| cron.successfulJobsHistoryLimit | string | `""` | Number of stored succeful jobs |







## Пример деплоя
1. Создать файл castle_values.conf со своими параметрами для подключения к S3-хранилищу
```
dgctlDockerRegistry: 'your-docker-hub-registry'
dgctlStorage:
  host: server_name:9000
  bucket: dgis
  accessKey: access_key
  secretKey: secret_key
  manifest: manifests/1644220485.json
 
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

persistentVolume:
  enabled: false
  accessModes:
    - ReadWriteOnce
  storageClass: ceph-csi-rbd
  size: 5Gi

cron:
  enabled:
    import: false
    restriction: false
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
