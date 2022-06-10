{{- define "bss-receiver-api.name" -}}
{{- printf "%s-api" .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "bss-receiver-streams.name" -}}
{{- printf "%s-streams" .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "bss-receiver-api.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ printf "%s-api" .Release.Name }}
{{- end }}

{{- define "bss-receiver-api.labels" -}}
{{ include "bss-receiver-api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "bss-receiver-streams.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ printf "%s-streams" .Release.Name }}
{{- end }}

{{- define "bss-receiver-streams.labels" -}}
{{ include "bss-receiver-streams.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
