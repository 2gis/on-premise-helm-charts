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

{{- define "config.truck" -}}
{{ print  "\"simple_network_pedestrian\": false,\"simple_network_taxi\" : false,\"simple_network_bicycle\" : false,\"simple_network_truck\" : true,\"attractor_pedestrian\": false,\"attractor_bicycle\": false,\"attractor_taxi\": false," }}
{{- end -}}

{{- define "config.ctx" -}}
{{ print  "\"simple_network_pedestrian\": false,\"simple_network_taxi\" : false,\"simple_network_bicycle\" : false,\"simple_network_truck\" : false,\"attractor_pedestrian\": false,\"attractor_bicycle\": false,\"attractor_taxi\": false," }}
{{- end -}}

{{- define "config.pedestrian" -}}
{{ print  "\"simple_network_pedestrian\": true,\"simple_network_taxi\" : false,\"simple_network_bicycle\" : false,\"simple_network_truck\" : false,\"attractor_pedestrian\": true,\"attractor_bicycle\": false,\"attractor_taxi\": false," }}
{{- end -}}

{{- define "config.pairs" -}}
{{ print  "\"simple_network_car\" : true,\"simple_network_pedestrian\": true,\"simple_network_taxi\" : false,\"simple_network_bicycle\" : false,\"simple_network_truck\" : false,\"attractor_car\" : true,\"attractor_pedestrian\": true,\"attractor_bicycle\": false,\"attractor_taxi\": false," }}
{{- end -}}

{{- define "config.dm" -}}
{{ print  "\"simple_network_car\" : true,\"simple_network_pedestrian\": false,\"simple_network_taxi\" : false,\"simple_network_bicycle\" : false,\"simple_network_truck\" : false,\"attractor_car\" : true,\"attractor_pedestrian\": false,\"attractor_bicycle\": false,\"attractor_taxi\": false,\"reduce_edges_optimization_flag\": true," }}
{{- end -}}

{{- define "config.bicycle" -}}
{{ print  "\"simple_network_pedestrian\": false,\"simple_network_taxi\" : false,\"simple_network_bicycle\" : true,\"simple_network_truck\" : false,\"attractor_pedestrian\": false,\"attractor_bicycle\": true,\"attractor_taxi\": false," }}
{{- end -}}

{{- define "config.freeroam" -}}
{{ print  "\"simple_network_pedestrian\": false,\"simple_network_taxi\" : false,\"simple_network_bicycle\" : false,\"simple_network_truck\" : false,\"attractor_pedestrian\": false,\"attractor_bicycle\": false,\"attractor_taxi\": false,\"reduce_edges_optimization_flag\": false," }}
{{- end -}}

{{- define "config.serversection" -}}
{{- if eq .Values.naviback.type "carrouting" -}}
   {{ include "config.carrouting" $ }}
{{- end -}}
{{- if eq .Values.naviback.type "taxi" -}}
   {{ include "config.taxi" $ }}
{{- end -}}
{{- if eq .Values.naviback.type "truck" -}}
   {{ include "config.truck" $ }}
{{- end -}}
{{- if eq .Values.naviback.type "ctx" -}}
   {{ include "config.ctx" $ }}
{{- end -}}
{{- if eq .Values.naviback.type "schedule" -}}
   {{ include "config.ctx" $ }}
{{- end -}}
{{- if eq .Values.naviback.type "pedestrian" -}}
   {{ include "config.pedestrian" $ }}
{{- end -}}
{{- if eq .Values.naviback.type "dm" -}}
   {{ include "config.dm" $ }}
{{- end -}}
{{- if eq .Values.naviback.type "pairs" -}}
   {{ include "config.pairs" $ }}
{{- end }}
{{- if eq .Values.naviback.type "bicycle" -}}
   {{ include "config.bicycle" $ }}
{{- end -}}
{{- if eq .Values.naviback.type "freeroam" -}}
   {{ include "config.freeroam" $ }}
{{- end -}}
{{- end -}}

{{- define "config.setCpuNumber" }}
{{- $cpu_divider := 1 }}
{{- $num_threads := 0 }}
{{- $resources := regexSplit "m" (toString .Values.resources.limits.cpu) -1 }}
{{- if eq (len $resources) 2 }}
 {{- $cpu_divider = 1000 }} 
{{- end }}
{{- $cpu_value := index $resources 0 }}
{{- $num_threads = ceil (divf $cpu_value $cpu_divider) }} 
{{- print $num_threads }}
{{- end -}}

{{/*
Renders a value or file that contains rules.
Usage:
{{ include "rules.renderRules" }}
*/}}
{{- define "rules.renderRules" -}}
    {{- $rules_file_content := .Files.Get "rules.conf" }}
    {{- if .Values.rules -}}
        {{- .Values.rules | toPrettyJson | nindent 6 }}
    {{- else if $rules_file_content  }}
        {{- $rules_file_content |  nindent 6}}
    {{- else }}
        {{- fail "Rules value is not set or rules file is empty" }}
    {{- end -}}
{{- end -}}
