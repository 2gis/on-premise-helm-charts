{{- define "gefest.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "gefest.ui.name" -}}
{{ include "gefest.name" . }}
{{- end }}

{{- define "gefest.ui.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "gefest.ui.labels" -}}
{{ include "gefest.ui.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
date: "{{ now | unixEpoch }}"
{{- end }}
