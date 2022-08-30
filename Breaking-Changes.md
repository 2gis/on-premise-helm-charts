# 2GIS On-Premise Breaking-Changes

## [1.3.1]

#### catalog-api
- Rename `podDisruptionBudget` to `pdb`

#### gis-platform
- Remove the `zookeeper.pdb` section

#### mapgl-js-api
- Rename `podDisruptionBudget` to `pdb`

#### navi-async-matrix
- Rename `podDisruptionBudget` to `pdb`

#### navi-back
- Rename `autoscaling.scaleUpWindowSeconds` to `autoscaling.scaleUpStabilizationWindowSeconds`
- Rename `autoscaling.scaleDownWindowsSeconds` to `autoscaling.scaleDownStabilizationWindowSeconds`
- Rename `podDisruptionBudget` to `pdb`
- Rename `podDisruptionBudget.create` to `pdb.enabled`

#### navi-castle
- Remove the `autoscaling` section

#### navi-front
- Rename `pdb.create` to `pdb.enabled`

#### navi-restrictions
- Rename `podDisruptionBudget` to `pdb`

#### navi-router
- Rename `podDisruptionBudget` to `pdb`

#### search-api
- Rename `podDisruptionBudget` to `pdb`

#### traffic-proxy
- Rename `podDisruptionBudget` to `pdb`

---
## [1.0.4]
#### tiles-api
- `.Values.cassandra.environment` is required

---
## [0.2.2]
#### keys
- change value `api.apiUrl` from 'http://servicename/admin/v1' to 'http://servicename'

---
## [0.1.9]
#### Production Ready release
