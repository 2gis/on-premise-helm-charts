# Mosesd Helm Chart
## Описание
Данный helm-чарт предназначен для установки экземпляра Navi-front, на который приходят запросы от конечных пользователей.


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
| front.port | int | `8080` | Default front port  |
| locationsBlock | string | `""` | Additional locations block |
| carroutingLocation | string | `""` | Custom carrouting location |
| serverBlock | string | `""` | Additional server block |

## Пример деплоя
Деплой navi-front для региона Даммам
1. Создать файл front_values.yaml со следующим содержимым

```
dgctl_docker_registry: 'your-docker-hub-registry'
affinity: "nodeAffinity:\n  preferredDuringSchedulingIgnoredDuringExecution:\n  - preference:\n      matchExpressions:\n      - key: cpu\n        operator: In\n        values:\n        - slow\n    weight: 50\n  - preference:\n      matchExpressions:\n      - key: role\n        operator: In\n        values:\n        - worker\n    weight: 20\n  requiredDuringSchedulingIgnoredDuringExecution: \n    nodeSelectorTerms:\n    - matchExpressions:\n      - key: role\n        operator: In\n        values:\n        - worker\npodAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n  - labelSelector:\n      matchExpressions:\n      - key: app.kubernetes.io/instance\n        operator: In\n        values:\n        - {{ .Release.Name }}\n    topologyKey: kubernetes.io/hostname\n"
autoscaling:
  enabled: "true"
  maxReplicas: 6
  minReplicas: 2
  scaleDownWindowsSeconds: 600
  scaleUpWindowSeconds: 300
  targetCPUUtilizationPercentage: 90
replicaCount: 2
resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi

```
3. Запусить установку helm-чарта
```
helm upgrade --install stage-front . -f front_values.yaml
```
4. Отправить POST-запрос на pod(в примере через port forwarding kubernetes):
```
kubectl port-forward navi-front-6864944c7-vrpns 7777:8080
```

```
dammam_data.json:

{
  "alternative": 1,
  "locale": "ru",
  "type": "online5",
  "points": [
    {
      "start": true,
      "type": "pedo",
      "x": 49.970111885708704,
      "y": 26.367186990734787
    },
    {
      "start": false,
      "type": "pedo",
      "x": 49.97414586032357,
      "y": 26.349498271824444
    }
  ]
}
```
Отправляем через curl например
```
curl -Lv http://localhost:7777/carrouting/6.0.0/global -d @dammam_data.json 
```

Примерный вариант ответ:
```
{"query":{"alternative":1,"locale":"ru","points":[{"start":true,"type":"pedo","x":49.9701118857087,"y":26.36718699073479},{"start":false,"type":"pedo","x":49.97414586032357,"y":26.34949827182444}],"type":"online5"},"result":[{"algorithm":"с учётом пробок","begin_pedestrian_path":{"geometry":{"selection":"LINESTRING(49.970111 26.367186, 49.969877 26.366992)"}},"end_pedestrian_path":{"geometry":{"selection":"LINESTRING(49.974169 26.349147, 49.974145 26.349498)"}},"id":"12468691725164358306","maneuvers":[{"comment":"start","icon":"start","id":"15752507858131033692","outcoming_path":{"distance":4244,"duration":526,"geometry":[{"color":"fast","length":906,"selection":"LINESTRING(49.969877 26.366992, 49.969751 26.367194, 49.969321 26.367882, 49.969165 26.368132, 49.969137 26.368176, 49.969051 26.368314, 49.968550 26.369113, 49.968271 26.369561, 49.968240 26.369610, 49.968205 26.369669, 49.968016 26.369987, 49.967851 26.370263, 49.967806 26.370288, 49.967733 26.370270, 49.967652 26.370229, 49.967586 26.370195, 49.967085 26.369946, 49.966267 26.369539, 49.966134 26.369473, 49.966083 26.369448, 49.965673 26.369244, 49.964621 26.368719, 49.964371 26.368602)"},{"color":"normal","length":32,"selection":"LINESTRING(49.964371 26.368602, 49.964298 26.368599, 49.964214 26.368606, 49.964174 26.368579, 49.964185 26.368504)"},{"color":"fast","length":3796,"selection":"LINESTRING(49.964185 26.368504, 49.964226 26.368371, 49.964282 26.368187, 49.964329 26.368037, 49.964409 26.367777, 49.965037 26.365744, 49.965478 26.364314, 49.965505 26.364229, 49.965524 26.364167, 49.965653 26.363748, 49.965794 26.363294, 49.965815 26.363224, 49.965836 26.363157, 49.966188 26.362020, 49.966786 26.360087, 49.966871 26.359815, 49.966886 26.359766, 49.966937 26.359601, 49.967059 26.359206, 49.967094 26.359091, 49.967113 26.359023, 49.967135 26.358942, 49.967154 26.358872, 49.967269 26.358471, 49.967902 26.356264, 49.968192 26.355256, 49.968208 26.355200, 49.968233 26.355112, 49.968385 26.354581, 49.968496 26.354192, 49.968512 26.354136, 49.968534 26.354059, 49.968747 26.353313, 49.968985 26.352483, 49.969012 26.352386, 49.969028 26.352327, 49.969045 26.352267, 49.969059 26.352213, 49.969198 26.351695, 49.969495 26.350583, 49.969554 26.350365, 49.969570 26.350303, 49.969589 26.350233, 49.969605 26.350172, 49.969731 26.349728, 49.970287 26.347765, 49.970496 26.347040, 49.970525 26.347016, 49.970568 26.347019, 49.970595 26.347046, 49.970562 26.347207, 49.970178 26.348657, 49.969894 26.349727, 49.969877 26.349817, 49.969869 26.349906, 49.969867 26.349996, 49.969873 26.350067, 49.969888 26.350125, 49.969913 26.350175, 49.969946 26.350220, 49.969979 26.350263, 49.970015 26.350302, 49.970055 26.350339, 49.970127 26.350373, 49.970308 26.350399, 49.970569 26.350417, 49.970749 26.350426, 49.970942 26.350428, 49.971604 26.350425, 49.971873 26.350424, 49.971934 26.350424, 49.972011 26.350423, 49.972158 26.350422, 49.972396 26.350418, 49.972607 26.350415, 49.972726 26.350416, 49.973121 26.350429, 49.973492 26.350442, 49.973553 26.350431, 49.973601 26.350397, 49.973635 26.350347, 49.973649 26.350298, 49.973651 26.350046, 49.973651 26.349610, 49.973659 26.349495, 49.973694 26.349350, 49.973765 26.349175, 49.973912 26.349103, 49.974169 26.349147)"}],"names":["ثابت بن عامر"]},"outcoming_path_comment":"4 км прямо","type":"begin"},{"comment":"finish","icon":"finish","id":"11075479511331149799","outcoming_path_comment":"Вы на месте!","type":"end"}],"reliability":1.0,"route_id":"stage-dammam-navi-back.m9/carrouting/1646895715.440","total_distance":4244,"total_duration":526,"type":"carrouting","ui_total_distance":{"unit":"км","value":"4"},"ui_total_duration":"8 мин","waypoints":[{"original_point":{"lat":26.36699277781026,"lon":49.96987769491413},"projected_point":{"lat":26.36699277781026,"lon":49.96987769491413},"transit":false},{"original_point":{"lat":26.34914713757108,"lon":49.97416957584707},"projected_point":{"lat":26.34914713757108,"lon":49.97416957584707},"transit":false}]},{"algorithm":"с учётом пробок","begin_pedestrian_path":{"geometry":{"selection":"LINESTRING(49.970111 26.367186, 49.969877 26.366992)"}},"end_pedestrian_path":{"geometry":{"selection":"LINESTRING(49.974169 26.349147, 49.974145 26.349498)"}},"id":"7081533061045648773","maneuvers":[{"comment":"start","icon":"start","id":"757335516116947881","outcoming_path":{"distance":4452,"duration":605,"geometry":[{"color":"fast","length":2351,"selection":"LINESTRING(49.969877 26.366992, 49.969748 26.367199, 49.969313 26.367894, 49.969164 26.368133, 49.969136 26.368178, 49.969037 26.368336, 49.968517 26.369166, 49.968267 26.369567, 49.968238 26.369613, 49.968197 26.369682, 49.967990 26.370031, 49.967845 26.370271, 49.967799 26.370288, 49.967724 26.370264, 49.967669 26.370217, 49.967669 26.370168, 49.967844 26.369898, 49.968040 26.369596, 49.968076 26.369540, 49.968114 26.369480, 49.968688 26.368566, 49.969598 26.367114, 49.969716 26.366925, 49.969745 26.366880, 49.969933 26.366581, 49.970343 26.365926, 49.970429 26.365788, 49.970458 26.365743, 49.970771 26.365244, 49.971796 26.363610, 49.972068 26.363176, 49.972096 26.363130, 49.972160 26.363029, 49.972400 26.362646, 49.972505 26.362478, 49.972561 26.362389, 49.972647 26.362251, 49.972721 26.362134, 49.972763 26.362063, 49.972766 26.362017, 49.972643 26.361941, 49.971367 26.361293, 49.970366 26.360786, 49.970289 26.360746, 49.970185 26.360692, 49.968839 26.359995, 49.967357 26.359226)"},{"color":"normal","length":25,"selection":"LINESTRING(49.967357 26.359226, 49.967223 26.359155, 49.967168 26.359117)"},{"color":"fast","length":2587,"selection":"LINESTRING(49.967168 26.359117, 49.967127 26.359067, 49.967122 26.358997, 49.967142 26.358916, 49.967161 26.358849, 49.967447 26.357849, 49.968086 26.355625, 49.968198 26.355232, 49.968213 26.355182, 49.968273 26.354970, 49.968452 26.354345, 49.968504 26.354165, 49.968518 26.354115, 49.968587 26.353874, 49.968889 26.352819, 49.969005 26.352413, 49.969020 26.352360, 49.969036 26.352299, 49.969052 26.352240, 49.969091 26.352096, 49.969366 26.351067, 49.969544 26.350400, 49.969562 26.350334, 49.969580 26.350265, 49.969598 26.350197, 49.969630 26.350085, 49.970032 26.348668, 49.970465 26.347141, 49.970510 26.347023, 49.970550 26.347014, 49.970588 26.347033, 49.970594 26.347078, 49.970363 26.347956, 49.969942 26.349548, 49.969880 26.349792, 49.969871 26.349873, 49.969867 26.349968, 49.969870 26.350046, 49.969882 26.350108, 49.969905 26.350161, 49.969936 26.350207, 49.969970 26.350251, 49.970005 26.350292, 49.970044 26.350330, 49.970101 26.350365, 49.970253 26.350393, 49.970510 26.350414, 49.970720 26.350425, 49.970866 26.350428, 49.971469 26.350425, 49.971858 26.350424, 49.971921 26.350424, 49.971995 26.350423, 49.972127 26.350422, 49.972357 26.350418, 49.972584 26.350415, 49.972707 26.350415, 49.973053 26.350427, 49.973475 26.350441, 49.973547 26.350433, 49.973597 26.350401, 49.973633 26.350351, 49.973649 26.350302, 49.973651 26.350075, 49.973651 26.349622, 49.973658 26.349499, 49.973692 26.349355, 49.973763 26.349177, 49.973909 26.349103, 49.974169 26.349147)"}],"names":["شارع أروى بنت ربيعة الشرق"]},"outcoming_path_comment":"4 км прямо","type":"begin"},{"comment":"finish","icon":"finish","id":"11075479511331149799","outcoming_path_comment":"Вы на месте!","type":"end"}],"reliability":1.0,"route_id":"stage-dammam-navi-back.m9/carrouting/1646895715.442","total_distance":4452,"total_duration":605,"type":"carrouting","ui_total_distance":{"unit":"км","value":"4"},"ui_total_duration":"10 мин","waypoints":[{"original_point":{"lat":26.36699277781026,"lon":49.96987769491413},"projected_point":{"lat":26.36699277781026,"lon":49.96987769491413},"transit":false},{"original_point":{"lat":26.34914713757108,"lon":49.97416957584707},"projected_point":{"lat":26.34914713757108,"lon":49.97416957584707},"transit":false}]}],"type":"result"}
```