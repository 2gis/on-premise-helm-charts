{{- define "citylens-ui.name" -}}
{{- .Release.Name }}
{{- end }}

{{- define "citylens-ui.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "citylens-ui.labels" -}}
{{ include "citylens-ui.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
