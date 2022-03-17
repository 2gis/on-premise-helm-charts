# Router Helm Chart
## Описание
Данный helm-чарт предназначен для установки экземпляра navi-router, который позволяет обслуживать запросы и отдавать правила, исходя из файла *rules.conf*

## Файл *rules.conf*
Является важнейшим файлом, описывающим правила и проекты, которые будут обслуживаться разворачиваемый экземпляр navi-router.   
Пример файла *rules.conf*:
```
[ 
  {
    "name": "dammam_cr",
    "router_projects": [
        "dammam"
    ],
    "moses_projects": [
        "dammam"
    ],
    "projects": [
        "dammam"
    ],
    "queries": [
        "routing"
    ],
    "routing": [
        "driving"
    ]
  }
]
```
В данном примере создается правило dammam_cr, содержащее регион Даммам с типом запроса "routing" и видом роутина "driving".  
При передаче запроса на navi-router сам сервис извлекает из переданных данных проект и отдает соответствующее правило - dammam, если точки маршрута находятся в Даммаме.  
## ***Внимание!!! Файл rules.conf необходимо подкладывать в директорию с helm-чартом***


## Описание values
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object or string | `{}` |  |
| annotations | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `50` |  |
| image | string | `"2gis/mosesd"` | The path to the docker image. Must have a path to your private docker registry |
| imagePullSecrets | object | `{}` |  |
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
| service.type | string | `"ClusterIP"` |  |
| strategy.rollingUpdate.maxSurge | int | `1` |  |
| strategy.rollingUpdate.maxUnavailable | int | `0` |  |
| tag | string | `"v1.0.0"` | Tag with application version |
| terminationGracePeriodSeconds | int | `60` |  |
| tolerations | object | `{}` |  |
| vpa.enabled | bool | `false` |  |
| vpa.maxAllowed.cpu | int | `1` |  |
| vpa.maxAllowed.memory | string | `"512Mi"` |  |
| vpa.minAllowed.memory | string | `"128Mi"` |  |
| router.app_castle_host | string | `""` | URL of castle server  |
| router.ftp_conn_string | string | `""` | FTP connection string to build server  |
| router.additional_sections | string | `""` | Additional sections of mosesd.conf file  |
| router.server_id | string | `"Chart release name"` | Server id sended to statistic server  |


## Пример деплоя
Деплой mosesd для региона Даммам
1. Создать файл rules.conf в директории с helm-чартом
```
[ 
  {
    "name": "dammam_cr",
    "router_projects": [
        "dammam"
    ],
    "moses_projects": [
        "dammam"
    ],
    "projects": [
        "dammam"
    ],
    "queries": [
        "routing"
    ],
    "routing": [
        "driving"
    ]
  }
]
```
2. Создать файл stage_values.yaml со следующим содержимым:
```
router:
  app_castle_host: stage-castle 
  additional_sections: |- 
    "kkey_management_service" :
    {
      "service_remote_address" : "https://keys.api.k8s.2gis.dev/service/v1/keys",
      "keys_refresh_interval_min" : 1,
      "keys_download_timeout_sec" : 10,
      "service_apis" :
      [
          {"type" : "directions", "token" : "5e34adec-7f4c-449e-bdd0-5a6c43690eac"},
          {"type" : "distance-matrix", "token" : "ce10377b-c610-48b2-8c56-90f9c0c282cf"},
          {"type" : "pairs-directions", "token" : "f2e3f996-438c-42eb-948e-4964d2691c3e"},
          {"type" : "truck-directions", "token" : "47d7857d-38da-482f-855f-b265934fc43f"},
          {"type" : "public-transport", "token" : "373a808b-25ca-4ee7-8f37-fc5fd1d40269"},
          {"type" : "isochrone", "token" : "0d0c1d63-7427-401a-b2ec-ad74f7a0ad13"},
          {"type" : "map-matching", "token" : "5fd44f87-fdac-4375-911b-1bf546620fde"}
      ]
    }
replicaCount: 2
resources": 
  limits: 
    cpu: "2000m"
    memory: "1024Mi"
  requests":
    cpu: "500m"
    memory": "128Mi"

image:
  repository: "docker-hub.2gis.ru/navi/moses-router"
  tag: "master-9a2134fb"

resources:
  limits:
    cpu: 2000m
    memory: 1024Mi
  requests:
    cpu: 500m
    memory: 128Mi
```
В данном примере отключено использование ключей, для прода нужно переименовать kkey_management_service в key_management_service и прописать корректные токены. Пример:
```
additional_sections: |- 
    "key_management_service" :
    {
      "service_remote_address" : "https://keys.api.k8s.2gis.dev/service/v1/keys",
      "keys_refresh_interval_min" : 1,
      "keys_download_timeout_sec" : 10,
      "service_apis" :
      [
          {"type" : "directions", "token" : "5e34adec-7f4c-449e-bdd0-5a6c43690eac"},
          {"type" : "distance-matrix", "token" : "ce10377b-c610-48b2-8c56-90f9c0c282cf"},
          {"type" : "pairs-directions", "token" : "f2e3f996-438c-42eb-948e-4964d2691c3e"},
          {"type" : "truck-directions", "token" : "47d7857d-38da-482f-855f-b265934fc43f"},
          {"type" : "public-transport", "token" : "373a808b-25ca-4ee7-8f37-fc5fd1d40269"},
          {"type" : "isochrone", "token" : "0d0c1d63-7427-401a-b2ec-ad74f7a0ad13"},
          {"type" : "map-matching", "token" : "5fd44f87-fdac-4375-911b-1bf546620fde"}
      ]
    }
```

3. Запусить установку helm-чарта
```
helm upgrade --install stage-router . -f stage_values.yaml
```
4. Отправить POST-запрос на pod(в примере через port forwarding kubernetes):
```
kubectl port-forward stage-router-6864944c7-vrpns 7777:8080
```

```
dammam_data.json:

{"locale":"en","point_a_name":"Source","point_b_name":"Target","points":[{"type":"pedo","x":50.061144,"y":26.409866},{"type":"pedo","x":50.044684,"y":26.377784}],"purpose":"autoSearch","type":"online5","viewport":{"topLeft":{"x":50.00440730970801,"y":26.41121847602915},"bottomRight":{"x":50.098948690292,"y":26.374867207538756},"zoom":14.50947229805369}}
```
Отправляем через curl например
```
curl -Lv http://localhost:7777/carrouting/6.0.0/global -d @dammam_data.json 
```

Ответ:
```
dammam_cr
```