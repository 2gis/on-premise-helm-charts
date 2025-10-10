{{/*
Expand the name of the chart.
*/}}
{{- define "big-search.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "big-search.fullname" -}}
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
{{- define "big-search.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "big-search.selectorLabels" -}}
app.kubernetes.io/name: {{ include "big-search.name" . }}
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
{{- define "big-search.labels" -}}
helm.sh/chart: {{ include "big-search.chart" . }}
{{ include "big-search.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "big-search.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "big-search.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
customCAs
*/}}
{{- define "big-search.env.custom.ca.path" -}}
- name: SSL_CERT_FILE
  value: {{ include "big-search.custom.ca.mountPath" . }}/custom-ca.crt
{{- end }}

{{- define "big-search.custom.ca.mountPath" -}}
{{ .Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}

{{- define "big-search.custom.ca.volumeMounts" -}}
- name: custom-ca
  mountPath: {{ include "big-search.custom.ca.mountPath" . }}/custom-ca.crt
  subPath: custom-ca.crt
  readOnly: true
{{- end -}}

{{- define "big-search.custom.ca.deploys.volumes" -}}
- name: custom-ca
  configMap:
    name: {{ include "big-search.fullname" . }}
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
{{- define "big-search.manifestCode" -}}
{{- base .Values.dgctlStorage.manifest | trimSuffix ".json" }}
{{- end }}
