{{- define "api.selectorLabels" -}}
app.kubernetes.io/name: {{ $.Chart.Name }}
app.kubernetes.io/instance: {{ $.Release.Name }}
{{- end }}

{{- define "api.labels" -}}
{{ include "api.selectorLabels" . }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
{{- end }}

{{- define "tileserver.manifestCode" -}}
{{- base $.Values.manifestPath | trimSuffix ".json" }}
{{- end }}

{{- define "tileserver.name" -}}
{{- print "dgis-tileserver-" $.Values.tileserver.type "-" $.Release.Name }}
{{- end }}
