{{- define "citylens.name" -}}
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

{{- define "api.name" -}}
{{ include "citylens.name" . }}
{{- end -}}

{{- define "worker-service.name" -}}
{{ include "citylens.name" . }}-worker
{{- end -}}

{{- define "migration.name" -}}
{{ include "citylens.name" . }}-migration
{{- end -}}

{{- define "migration.secret.name" -}}
{{ include "migration.name" . }}-secret
{{- end -}}

{{- define "app.chart" -}}
{{- printf "%s-%s" .Values.appName .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "worker-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "worker-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-worker
{{- end -}}

{{- define "api.labels" -}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "worker-service.labels" -}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "worker-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "migration.labels" -}}
app.kubernetes.io/name: {{ include "migration.name" . }}
app.kubernetes.io/instance: {{ .Chart.Name }}-db-migration
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}