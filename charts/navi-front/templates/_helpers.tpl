{{/*
Expand the name of the chart.
*/}}
{{- define "front.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "front.fullname" -}}
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
{{- define "front.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "front.labels" -}}
helm.sh/chart: {{ include "front.chart" . }}
{{ include "front.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "front.selectorLabels" -}}
app.kubernetes.io/name: {{ include "front.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "front.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "front.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create locations for rules upstreams
*/}}
{{- define "front.getLocations" -}}
{{- $locations := list -}}
{{- $ns := print .Release.Namespace -}}
{{- range $index, $service := (lookup "v1" "Service" $ns "").items -}}
    {{- range $indexl, $label := $service.metadata.labels -}}
        {{- if eq $indexl "rule" -}}
            {{- $locations = append $locations $label -}}
            {{- printf "location /%s {" $label }}
            {{- printf "rewrite ^/%s(.*)$ $1 break;" $label }}
            {{- printf "add_header X-Region %s;" $service.metadata.name }}
            {{- printf "proxy_pass http://%s$uri$is_args$args;" $service.metadata.name }}
            {{- println "}" }}
        {{- end }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Create upstreams for running moses in the namespace
*/}}
{{- define "front.getUpstreams" -}}
{{- $locations := list -}}
{{- $ns := print .Release.Namespace }}
{{- range $index, $service := (lookup "v1" "Service" $ns "").items -}}
    {{- range $indexl, $label := $service.metadata.labels -}}
        {{- if eq $indexl "rule" -}}
            {{- $locations = append $locations $label -}}
            {{- printf "upstream %s {" $service.metadata.name }}
            {{- printf "server %s;" $service.metadata.name }}
            {{- println "}" }}
        {{- end }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Create upstreams for running moses in the namespace
*/}}
{{- define "front.getMrouterUpstream" -}}
{{- $location := "navi-router" -}}
{{- $ns := print .Release.Namespace -}}
{{- range $index, $service := (lookup "v1" "Service" $ns "").items -}}
    {{- range $indexl, $label := $service.metadata.labels -}}
        {{- if and (eq $indexl "app.kubernetes.io/name") (eq $label "navi-router")  -}}
            {{- $location = $service.metadata.name -}}
            {{- print $location -}}
        {{- end }}
    {{- end }}
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
