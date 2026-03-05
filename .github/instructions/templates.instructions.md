---
applyTo: "**/templates/**"
excludeAgent: ["coding-agent"]
---

# Rules for Helm template files

- Template files use `.yaml` extension for Kubernetes resources, `.tpl` for helper-only files
- Template file names use dashed notation: `my-config.yaml`, not `myConfig.yaml`
- Each Kubernetes resource must be in its own template file
- File name must reflect the resource kind: `deployment.yaml`, `service.yaml`, `configmap.yaml`
- All named templates (`{{- define ... }}`) must be namespaced with the chart name:
  ```yaml
  {{- define "navi-back.fullname" -}}   ← correct
  {{- define "fullname" -}}              ← incorrect, will collide across charts
  ```
- Template directives must have whitespace inside braces: `{{ .foo }}` not `{{.foo}}`
- Do not hardcode `namespace:` in template `metadata` — namespace is set by the caller via `--namespace`
- Do not use floating image tags (`latest`, `head`, `canary`); always use a fixed tag or SHA
- PodTemplate selectors must be explicitly declared in `selector.matchLabels`
- Use `generic-chart` library templates for standard resources (Deployment, Service, Ingress, HPA, VPA, PDB) instead of duplicating them
- Every chart must have a `templates/NOTES.txt` with post-install instructions. Recommended template:
  ```
  {{ .Chart.Name }} is installed by release "{{ .Release.Name }}" at "{{ .Release.Namespace }}" namespace

  You can check the status of the app using command

  kubectl get pods -n {{ .Release.Namespace}} -l app.kubernetes.io/name={{ include "<pod_name>.name" . }} -l app.kubernetes.io/instance={{ .Release.Name }}

  {{- if .Values.api.ingress.enabled }}
  You can check service using curl
  {{- range $host := .Values.api.ingress.hosts }}
    http{{ if $.Values.api.ingress.tls }}s{{ end }}://{{ $host.host }}/
  {{- end }}
  {{- else }}
  You should publish the service in your preferred way (ingress, balancer, etc).
  {{- end }}
  ```
- When `hpa.enabled: true`, the `replicas` field must be omitted from the Deployment spec
- Parameters marked `**Required**` (unconditionally) must use `required` in templates:
  ```yaml
  host: {{ required "Valid .Values.postgres.host required!" .Values.postgres.host }}
  ```
- Parameters marked `**Required** if <condition>` must use `required` **inside** the guard block, not bare:
  ```yaml
  {{- if eq .Values.authProvider.schema "Oidc" }}
  # correct — required fires only when the field is actually needed
  - name: OIDC_AUTHORITY
    value: {{ required "Valid .Values.authProvider.oidc.authority required when schema is Oidc!" .Values.authProvider.oidc.authority | quote }}
  {{- end }}
  ```
  Referencing the value bare inside the block (without `required`) means a user who sets `schema: Oidc` but forgets the field will get an empty env-var instead of a clear error.
- CronJobs must include `successfulJobsHistoryLimit` and `failedJobsHistoryLimit` (default `3`)
- ConfigMaps and Secrets must have checksum annotations to trigger pod restarts on config changes:
  ```yaml
  annotations:
    checksum/config: {{ (include (print $.Template.BasePath "/configmap.yaml") . | fromYaml).data | toYaml | sha256sum }}
    checksum/secret: {{ (include (print $.Template.BasePath "/secret.yaml") . | fromYaml).data | toYaml | sha256sum }}
  ```
- Services using DataGateway manifests must add the `manifest` label using the `<svc_name>.manifestCode` helper
- Add a deprecation notice in `NOTES.txt` for renamed/removed parameters instead of silently dropping them

## Standard labels

Every resource should carry these labels:

| Label | Value |
|-------|-------|
| `app.kubernetes.io/name` | `{{ template "<chart>.name" . }}` |
| `helm.sh/chart` | `{{ .Chart.Name }}-{{ .Chart.Version \| replace "+" "_" }}` |
| `app.kubernetes.io/managed-by` | `{{ .Release.Service }}` |
| `app.kubernetes.io/instance` | `{{ .Release.Name }}` |

Hooks must be set as annotations, not labels.
