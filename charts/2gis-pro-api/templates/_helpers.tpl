{{- define "urbi-pro.name" -}}
{{- default .Values.appName .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "urbi-pro.import-name" -}}
{{- default .Values.appImporterName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "urbi-pro.data-preparer-name" -}}
{{- default .Values.appDataPreparerName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "urbi-pro.fullname" -}}
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

{{- define "urbi-pro.chart" -}}
{{- printf "%s-%s" .Values.appName .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "urbi-pro.selectorLabels" -}}
app.kubernetes.io/name: {{ include "urbi-pro.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "urbi-pro.labels" -}}
helm.sh/chart: {{ include "urbi-pro.chart" . }}
{{ include "urbi-pro.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
