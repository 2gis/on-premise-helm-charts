{{ define "pasportool.chart" -}}
{{ $.Chart.Name }}-{{- $.Chart.Version | replace "+" "_" }}
{{- end }}

{{ define "pasportool.name" -}}
{{ $.Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{ define "pasportool.selectorLabels" -}}
app.kubernetes.io/name: {{ $.Chart.Name }}
app.kubernetes.io/instance: {{ $.Release.Name }}
{{- end }}

{{ define "pasportool.labels" -}}
{{ include "pasportool.selectorLabels" $ }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ $.Release.Service | quote }}
helm.sh/chart: {{ include "pasportool.chart" $ | quote }}
{{- end }}

{{ define "pasportool.required" -}}
required (printf "A valid %s entry is required" .m) .e
{{- end }}