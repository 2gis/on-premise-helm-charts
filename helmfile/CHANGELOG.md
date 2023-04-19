# 2GIS On-Premise Helmfile Changelog

## [1.7.0]
#### navi-router - перемещена секция key_management_service
```
router:
  logLevel: Warning
  keyManagementService:
    enabled: true
    host: http://keys.api.example.com
    apis:
      directions: "DIRECTIONS_TOKEN"
      distance-matrix: "DISTANCE_MATRIX_TOKEN"
      pairs-directions: "PAIRS_DIRECTIONS_TOKEN"
      truck-directions: "TRUCK_DIRECTIONS_TOKEN"
      public-transport: "PUBLIC_TRANSPORT_TOKEN"
      isochrone: "ISOCHRONE_TOKEN"
      map-matching : "MAP_MATCHING_TOKEN"
      ppnot: "PPNOT_TOKEN"
      combo-routes: "COMBO_ROUTES_TOKEN"
      free-roam: "FREE_ROAM_TOKEN"

```
#### Добавлен деплой [grpc proxy](README.md) для ассинхронных матриц
