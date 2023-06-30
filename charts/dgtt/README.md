# DGTT service

Use this Helm chart to deploy 2GIS's test tools

Values example for deploy:
```yaml
---
dgtt:
  config:
    env:
      testing:
        hosts:
          search-api: search-api.ingress.host
          catalog-api: catalog-api.ingress.host
        base-tests:
          search-api:
            - url: /v2/status
          catalog-api:
            - url: /2.0/region/list
```

## Values

### Docker Registry settings

| Name                  | Description                                                                            | Value |
| --------------------- | -------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | Docker Registry endpoint where On-Premise services' images reside. Format: `host:port` | `""`  |

### Common settings

| Name             | Description                                                                                                        | Value |
| ---------------- | ------------------------------------------------------------------------------------------------------------------ | ----- |
| `podAnnotations` | Kubernetes [pod annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)       | `{}`  |
| `podLabels`      | Kubernetes [pod labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)                 | `{}`  |
| `replicaCount`   | A replica count for the pod                                                                                        | `1`   |
| `nodeSelector`   | Kubernetes [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) | `{}`  |
| `affinity`       | Kubernetes [pod affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity)  | `{}`  |
| `tolerations`    | Kubernetes [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) settings   | `[]`  |

### Deployment settings

| Name                    | Description                                                                                   | Value                  |
| ----------------------- | --------------------------------------------------------------------------------------------- | ---------------------- |
| `dgtt.image.repository` | Repository                                                                                    | `2gis-on-premise/dgtt` |
| `dgtt.image.tag`        | Tag                                                                                           | `0.2.24-f76cd4232f`    |
| `dgtt.image.pullPolicy` | Image [pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) | `IfNotPresent`         |
| `dgtt.config`           | yaml config                                                                                   | `""`                   |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | <on-premise@2gis.com> | <https://github.com/2gis> |
