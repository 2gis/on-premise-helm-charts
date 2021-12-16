{{- define "tileserver.chart" -}}
{{ $.Chart.Name }}-{{ $.Chart.Version | replace "+" "_" }}
{{- end }}

{{- define "tileserver.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tileserver.name" . | quote}}
app.kubernetes.io/instance: {{ $.Release.Name | quote }}
{{- end }}

{{- define "tileserver.labels" -}}
{{ include "tileserver.selectorLabels" . }}
{{- if $.Chart.AppVersion }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ include "tileserver.chart" . | quote }}
{{- end }}

{{- define "tileserver.manifestCode" -}}
{{- base $.Values.manifestPath | trimSuffix ".json" }}
{{- end }}

{{- define "tileserver.name" -}}
{{- default $.Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tileserver.fullname" -}}
{{- if $.Values.fullnameOverride }}
{{- $.Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default $.Chart.Name $.Values.nameOverride }}
{{- printf "%s-%s" $.Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "importer.hook-annotations"}}
"helm.sh/hook": pre-install,pre-upgrade
{{- end}}

{{- define "importer.removable-hook-annotations"}}
{{- include "importer.hook-annotations" . }}
"helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
{{- end}}
