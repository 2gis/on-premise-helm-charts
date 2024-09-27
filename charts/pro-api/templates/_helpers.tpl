{{- define "pro-api.name" -}}
{{- if .Values.api.pod.fullnameOverride -}}
{{- .Values.api.pod.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Values.api.pod.appName .Values.api.pod.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "pro-api.permissions-name" -}}
{{ include "pro-api.name" . }}-permissions
{{- end -}}

{{- define "pro-api.permissions-url" -}}
{{- if .Values.permissions.settings.host -}}
{{- .Values.permissions.settings.host -}}
{{- else -}}
{{- "http://" -}}
{{ include "pro-api.permissions-name" . }}
{{- end -}}
{{- end -}}

{{- define "pro-api.asset-importer-name" -}}
{{- $name := default .Values.assetImporter.appName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "pro-api.asset-preparer-name" -}}
{{- $name := default .Values.assetPreparer.appName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "pro-api.service-account-name" -}}
{{- if empty .Values.api.service.serviceAccountOverride }}
  {{- $name := default .Values.api.service.serviceAccount -}}
  {{- if contains $name .Release.Name -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- else -}}
  {{- .Values.api.service.serviceAccountOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "pro-api.chart" -}}
{{- printf "%s-%s" .Values.api.pod.appName .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pro-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pro-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "pro-api.permissionsSelectorLabels" -}}
app.kubernetes.io/name: {{ include "pro-api.permissions-name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-permissions
{{- end -}}

{{- define "pro-api.labels" -}}
helm.sh/chart: {{ include "pro-api.chart" . }}
{{ include "pro-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "pro-api.permissionLabels" -}}
helm.sh/chart: {{ include "pro-api.chart" . }}
{{ include "pro-api.permissionsSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
