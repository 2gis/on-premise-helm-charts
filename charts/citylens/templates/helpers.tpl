{{/*
Expand the name of the chart.
*/}}
{{- define "citylens.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "citylens.api.name" -}}
{{ include "citylens.name" . }}-api
{{- end }}

{{- define "citylens.web.name" -}}
{{ include "citylens.name" . }}-web
{{- end }}

{{- define "citylens.camcom-sender.name" -}}
{{ include "citylens.name" . }}-camcom-sender
{{- end }}

{{- define "citylens.frames-saver.name" -}}
{{ include "citylens.name" . }}-frames-saver
{{- end }}

{{- define "citylens.predictions-saver.name" -}}
{{ include "citylens.name" . }}-predictions-saver
{{- end }}

{{- define "citylens.reporter-pro.name" -}}
{{ include "citylens.name" . }}-reporter-pro
{{- end }}

{{- define "citylens.track-metadata-saver.name" -}}
{{ include "citylens.name" . }}-track-metadata-saver
{{- end }}

{{- define "citylens.api.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.api.name" . }}
{{- end }}

{{- define "citylens.api.labels" -}}
{{ include "citylens.api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.web.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.web.name" . }}
{{- end }}

{{- define "citylens.web.labels" -}}
{{ include "citylens.web.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.camcom-sender.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.camcom-sender.name" . }}
{{- end }}

{{- define "citylens.camcom-sender.labels" -}}
{{ include "citylens.camcom-sender.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.frames-saver.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.frames-saver.name" . }}
{{- end }}

{{- define "citylens.frames-saver.labels" -}}
{{ include "citylens.frames-saver.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.predictions-saver.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.predictions-saver.name" . }}
{{- end }}

{{- define "citylens.predictions-saver.labels" -}}
{{ include "citylens.predictions-saver.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.reporter-pro.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.reporter-pro.name" . }}
{{- end }}

{{- define "citylens.reporter-pro.labels" -}}
{{ include "citylens.reporter-pro.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.track-metadata-saver.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.track-metadata-saver.name" . }}
{{- end }}

{{- define "citylens.track-metadata-saver.labels" -}}
{{ include "citylens.track-metadata-saver.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.migration.labels" -}}
app.kubernetes.io/name: {{ include "citylens.api.name" . }}
app.kubernetes.io/instance: {{ .Chart.Name }}-db-migration
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}


