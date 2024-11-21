{{- define "stat-receiver-api.name" -}}
{{- printf "%s-api" .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "stat-receiver-streams.name" -}}
{{- printf "%s-streams" .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "stat-receiver-api.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ printf "%s-api" .Release.Name }}
{{- end }}

{{- define "stat-receiver-api.labels" -}}
{{ include "stat-receiver-api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "stat-receiver-streams.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ printf "%s-streams" .Release.Name }}
{{- end }}

{{- define "stat-receiver-streams.labels" -}}
{{ include "stat-receiver-streams.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "stat-receiver-secret.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ printf "%s-secret" .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
