---
applyTo: "**/values.yaml"
excludeAgent: ["coding-agent"]
---

# Rules for values.yaml

- All setting names use camelCase starting with a lowercase letter (`accessKey`, `dgctlDockerRegistry`)
- Every chart must have a `dgctlDockerRegistry` parameter in the "Docker Registry settings" section
- Mandatory settings (DB host, service URLs) must have an empty string default (`''`) and must be validated with `required` in templates:
  ```yaml
  host: {{ required "Valid .Values.postgres.host required!" .Values.postgres.host }}
  ```
- Optional settings must have sensible defaults suitable for a typical partner deployment
- Toggle parameters must be named `enabled` (not `create`, not `autoscaling.enabled` — use `hpa.enabled`)
- Enum parameters must list all valid values in the comment using backticks:
  ```yaml
  # @param logLevel Log level: `trace`, `debug`, `info`, `warning`, `error`, `fatal`.
  logLevel: error
  ```
- Empty string defaults use single quotes: `name: ''`
- Non-empty string defaults are written without quotes: `repository: 2gis-on-premise/navi-back`

## @param annotations for README generation

- `README.md` is auto-generated from `values.yaml` comments using `readme-generator-for-helm`
- Use `@param`, `@section`, `@skip`, `@extra` annotation tags
- Every Kubernetes-specific section header must link to official Kubernetes docs:
  ```yaml
  # @section Kubernetes [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) settings
  ```
- If `values.yaml` is changed, `README.md` must be regenerated (CI `check-readme.yaml` enforces this)
- Descriptions must not start with a link — square brackets at the start are parsed as a type declaration
- Parameters that never change for typical use must be marked with `@skip` to hide from README
- Do not duplicate `@param` declarations for the same key

## Standard external service naming

| Service | Expected keys |
|---------|--------------|
| PostgreSQL | `postgres.host`, `postgres.port`, `postgres.name`, `postgres.username`, `postgres.password`, `postgres.tls.enabled`, `postgres.tls.rootCert`, `postgres.tls.cert`, `postgres.tls.key`, `postgres.tls.mode` |
| Kafka | `kafka.groupId`, `kafka.bootstrapServers`, `kafka.securityProtocol`, `kafka.saslMechanism`, `kafka.username`, `kafka.password`, `kafka.tls.skipServerCertificateVerify`, `kafka.tls.serverCA`, `kafka.tls.clientCert`, `kafka.tls.clientKey` |
| S3 | `s3.host`, `s3.region`, `s3.secure`, `s3.verifySsl`, `s3.bucket`, `s3.accessKey`, `s3.secretKey` |
| Ingress | `ingress.enabled`, `ingress.host` |
| On-Premise services | group under service name, use `.url` for address, `.key` for auth token |

## Service URL format in @param descriptions

When documenting a URL parameter, include an `Ex:` hint that clarifies whether the URL is internal or external:

- Internal cluster address: `Ex: http://{service-name}.svc`
- External ingress address: `Ex: http(s)://{service-name}.ingress.host`
- Any location: `Ex: {service-name}.host`
- URL template: use `urlTemplate` as the key name, e.g. `urlTemplate: http://service-name.svc/{project}/{date_str}_{hour}.json`

```yaml
# @param search.url URL of the Search service. Ex: http://search-api.svc. This URL should be accessible from all the pods within your Kubernetes cluster
search:
  url: ''

# @param catalog.url URL of the Catalog service. Ex: http(s)://catalog-api.ingress.host
catalog:
  url: ''
  key: ''
```

## Image repository naming

- Image `repository` values must reuse the chart name:
  ```yaml
  # For chart "pro-api":
  repository: 2gis-on-premise/pro-api-importer   # correct
  repository: 2gis-on-premise/urbigeo-importer    # incorrect
  ```
- Use universal terms instead of 2GIS-internal abbreviations: not `bss`, but `stat`; not internal codenames, but generic service names

## Standard abbreviations

- `hpa` — HorizontalPodAutoscaler (not `autoscaling`, not `horizontalPodAutoscaler`)
- `vpa` — VerticalPodAutoscaler
- `pdb` — PodDisruptionBudget
- `serviceAccount` — ServiceAccount
- `importer` — data import jobs
- `logLevel` — log level: `trace`, `debug`, `info`, `warning`, `error`, `fatal`
- `logFormat` — log format: `json`, `plaintext`
