{{/*
Expand the name of the chart.
*/}}
{{- define "search-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "search-api.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "search-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "search-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "search-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
search/blue-green: {{ .Values.bluegreen | quote }}
app: {{ .Release.Name }}
{{- if .Values.owner  }}
owner: {{ .Values.owner | quote }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "search-api.labels" -}}
helm.sh/chart: {{ include "search-api.chart" . }}
{{ include "search-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "search-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "search-api.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
customCAs
*/}}
{{- define "search-api.env.custom.ca.path" -}}
- name: SSL_CERT_FILE
  value: {{ include "search-api.custom.ca.mountPath" . }}/custom-ca.crt
{{- end }}

{{- define "search-api.custom.ca.mountPath" -}}
{{ .Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}

{{- define "search-api.custom.ca.volumeMounts" -}}
- name: custom-ca
  mountPath: {{ include "search-api.custom.ca.mountPath" . }}/custom-ca.crt
  subPath: custom-ca.crt
  readOnly: true
{{- end -}}

{{- define "search-api.custom.ca.deploys.volumes" -}}
- name: custom-ca
  configMap:
    name: {{ include "search-api.fullname" . }}
{{- end -}}

{{/*
Renders a value that contains template perhaps with scope if the scope is present.
https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_tplvalues.tpl
*/}}
{{- define "common.tplvalues.render" -}}
{{- $value := typeIs "string" .value | ternary .value (.value | toYaml) }}
{{- if contains "{{" (toJson .value) }}
  {{- if .scope }}
      {{- tpl (cat "{{- with $.RelativeScope -}}" $value "{{- end }}") (merge (dict "RelativeScope" .scope) .context) }}
  {{- else }}
    {{- tpl $value .context }}
  {{- end }}
{{- else }}
    {{- $value }}
{{- end -}}
{{- end -}}

{{/*
Manifest name
*/}}
{{- define "search-api.manifestCode" -}}
{{- base .Values.dgctlStorage.manifest | trimSuffix ".json" }}
{{- end }}
