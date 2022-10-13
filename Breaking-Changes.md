# 2GIS On-Premise Breaking-Changes

## [1.4.4]

#### catalog-api
- Rename `api.db` to `api.postgres`
- Rename `importer.db` to `importer.postgres`

## [1.4.1]

#### navi-async-matrix
- Resources limits are not set by default.
- Mandatory dependency on API Keys service with a valid API key required.

#### navi-back
- Default values optimized for processing async-matrix.

## [1.3.3]

#### catalog-api
- Rename value db to api.db
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

#### keys
- For the HPA section, switched from `autoscaling/v2beta2` to `autoscaling/v2`

#### gis-platform
- REMOVED `.Values.spcore.s3.preview_bucket`. Move its contents to `.Values.spcore.s3.bucket`
- ADDED `.Values.spcore.s3.session_bucket`. Create it before updating

#### mapgl-js-api
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

#### navi-async-matrix
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

#### navi-back
- Rename `autoscaling` to `hpa`
- Rename `autoscaling.scaleUpWindowSeconds` to `hpa.scaleUpStabilizationWindowSeconds`
- Rename `autoscaling.scaleDownWindowsSeconds` to `hpa.scaleDownStabilizationWindowSeconds`
- Rename `podDisruptionBudget` to `pdb`
- Rename `podDisruptionBudget.create` to `pdb.enabled`

#### navi-castle
- Remove the `autoscaling` section

#### navi-front
- Rename `autoscaling` to `hpa`
- Rename `pdb.create` to `pdb.enabled`
- For the HPA section, switched from `autoscaling/v2beta2` to `autoscaling/v2`

#### navi-restrictions
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

#### navi-router
- Rename `autoscaling` to `hpa`
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v2beta2` to `autoscaling/v2`

#### search-api
- Rename `podDisruptionBudget` to `pdb`
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

#### tiles-api
- For the HPA section, switched from `autoscaling/v1` to `autoscaling/v2`

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
