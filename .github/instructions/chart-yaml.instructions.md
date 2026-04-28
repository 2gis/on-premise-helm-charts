---
applyTo: "**/Chart.yaml"
excludeAgent: ["coding-agent"]
---

# Rules for Chart.yaml

- `apiVersion` must be `v2`
- `type` must be `application` (except `generic-chart`, which is `library`)
- `appVersion` reflects the Docker image version
