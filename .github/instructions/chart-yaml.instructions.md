---
applyTo: "**/Chart.yaml"
excludeAgent: ["coding-agent"]
---

# Rules for Chart.yaml

- `apiVersion` must be `v2`
- `type` must be `application` (except `generic-chart`, which is `library`)
- `appVersion` reflects the Docker image version (not the chart version)
- `dependencies` may include `generic-chart` with `repository: file://../generic-chart` — it is **optional**; many charts implement templates manually
- When bumping an existing chart, update `appVersion` if the Docker image tag changed
