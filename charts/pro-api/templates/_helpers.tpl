{{- define "pro-api.name" -}}
{{- default .Values.appName .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pro-api.import-name" -}}
{{- default .Values.appImporterName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pro-api.userdata-import-name" -}}
{{- default .Values.appUserDataImporterName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pro-api.data-preparer-name" -}}
{{- default .Values.appDataPreparerName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pro-api.fullname" -}}
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

{{- define "pro-api.chart" -}}
{{- printf "%s-%s" .Values.appName .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pro-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pro-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "pro-api.labels" -}}
helm.sh/chart: {{ include "pro-api.chart" . }}
{{ include "pro-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
