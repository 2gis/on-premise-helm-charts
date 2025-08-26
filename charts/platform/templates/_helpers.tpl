{{- define "platform.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "platform.ui.name" -}}
{{ include "platform.name" . }}
{{- end }}

{{- define "platform.ui.secretName" -}}
{{ include "platform.name" . }}
{{- end }}

{{- define "platform.ui.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "platform.ui.labels" -}}
{{ include "platform.ui.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
date: "{{ now | unixEpoch }}"
{{- end }}
