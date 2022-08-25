# 2GIS On-Premise Breaking-Changes

## [1.3.1]
#### gis-platform
- Remove the `zookeeper.pdb` section

#### navi-back
- Rename `autoscaling.scaleUpWindowSeconds` to `api.hpa.scaleUpStabilizationWindowSeconds`
- Rename `autoscaling.scaleDownWindowsSeconds` to `api.hpa.scaleDownStabilizationWindowSeconds`
- Rename `podDisruptionBudget.create` to `podDisruptionBudget.enabled`

#### navi-castle
- Remove the `autoscaling` section

#### navi-front
- Rename `pdb.create` to `pdb.enabled`

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
