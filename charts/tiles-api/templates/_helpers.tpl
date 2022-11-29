{{- define "tiles.chart" -}}
{{ $.Chart.Name }}-{{ $.Chart.Version | replace "+" "_" }}
{{- end }}

{{- define "tiles.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tiles.name" . | quote}}
app.kubernetes.io/instance: {{ $.Release.Name | quote }}
{{- end }}

{{- define "tiles.labels" -}}
{{ include "tiles.selectorLabels" . }}
{{- if $.Chart.AppVersion }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ include "tiles.chart" . | quote }}
{{- end }}

{{- define "tiles.manifestCode" -}}
{{- base $.Values.dgctlStorage.manifest | trimSuffix ".json" }}
{{- end }}

{{- define "tiles.name" -}}
{{- default $.Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tiles.fullname" -}}
{{- if $.Values.fullnameOverride }}
{{- $.Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "tiles.keyspace" -}}
{{- if $.Values.cassandra.keyspace }}
{{- $.Values.cassandra.keyspace }}
{{- else -}}
dgis_tileserver_{{ .Values.type }}_{{ required "Valid .Values.cassandra.environment required" .Values.cassandra.environment }}_{{ include "tiles.manifestCode" . }}
{{- end -}}
{{- end -}}

{{- define "importer.hook-annotations"}}
"helm.sh/hook": pre-install,pre-upgrade
{{- end}}

{{- define "importer.removable-hook-annotations"}}
{{- include "importer.hook-annotations" . }}
"helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
{{- end}}

{{- define "importer.serviceAccount" -}}
{{- if empty $.Values.importer.serviceAccountOverride }}
{{- include "tiles.fullname" . }}
{{- else }}
{{- $.Values.importer.serviceAccountOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
