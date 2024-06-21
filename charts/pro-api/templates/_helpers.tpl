{{- define "pro-api.name" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Values.appName .Values.nameOverride -}}
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
{{- if .Values.permissionsApi.host -}}
{{- .Values.permissionsApi.host -}}
{{- else -}}
{{- "http://" -}}
{{ include "pro-api.permissions-name" . }}
{{- end -}}
{{- end -}}

{{- define "pro-api.asset-importer-name" -}}
{{- $name := default .Values.appAssetImporterName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "pro-api.user-asset-importer-name" -}}
{{- $name := default .Values.appUserAssetImporterName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "pro-api.asset-preparer-name" -}}
{{- $name := default .Values.appAssetPreparerName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

# _helpers.tpl
{{- define "pro-api.service-account-name" -}}
{{- if empty .Values.api.serviceAccountOverride }}
  {{- $name := default .Values.api.serviceAccount -}}
  {{- if contains $name .Release.Name -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- else -}}
  {{- .Values.api.serviceAccountOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "pro-api.chart" -}}
{{- printf "%s-%s" .Values.appName .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
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
