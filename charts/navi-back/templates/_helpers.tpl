{{/*
Expand the name of the chart.
*/}}
{{- define "naviback.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "naviback.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "naviback.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "naviback.labels" -}}
helm.sh/chart: {{ include "naviback.chart" . }}
{{ include "naviback.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "naviback.selectorLabels" -}}
app.kubernetes.io/name: {{ include "naviback.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "naviback.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "naviback.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* vim: set filetype=mustache: */}}
{{/*
Renders a value that contains template.
Usage:
{{ include "tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{- define "config.carrouting" -}}
{{ print "\"simple_network_car\" : true, \"simple_network_pedestrian\": false,\"simple_network_taxi\" : false,\"simple_network_bicycle\" : false,\"simple_network_truck\" : false,\"attractor_car\" : true,\"attractor_pedestrian\": false,\"attractor_bicycle\": false,\"attractor_taxi\": false," }}
{{- end -}}

{{- define "config.taxi" -}}
{{ print  "\"simple_network_pedestrian\": false,\"simple_network_taxi\" : true,\"simple_network_bicycle\" : false,\"simple_network_truck\" : false,\"attractor_pedestrian\": false,\"attractor_bicycle\": false,\"attractor_taxi\": true," }}
{{- end -}}

{{- define "config.serversection" -}}
{{- if eq .Values.naviback.type "carrouting" -}}
   {{ include "config.carrouting" $ }}
{{- end -}}
{{- if eq .Values.naviback.type "taxi" -}}
   {{ include "config.taxi" $ }}
{{- end -}}
{{- end -}}