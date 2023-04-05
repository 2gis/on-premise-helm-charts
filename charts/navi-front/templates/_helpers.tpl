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
Create upstream nginx entry for found navi-back service
*/}}
{{- define "front.renderUpstream" -}}
    {{- $service := . -}}
    {{- $upstream := $service.metadata.name -}}
    {{- printf "upstream %s {\n" $upstream }}
    {{- printf "\tserver %s;\n" $upstream }}
    {{- println "}" }}
{{- end -}}

{{/*
Create location nginx entry for foun navi-back service
Render location only if rule is not empty string
*/}}
{{- define "front.renderLocation" -}}
    {{- $service := . -}}
    {{- $rule := get $service.metadata.labels "rule" }}
    {{- if (ne $rule "") -}}
        {{- printf "location /%s {\n" $rule }}
        {{- printf "\trewrite ^/%s(.*)$ $1 break;\n" $rule | indent 4 }}
        {{- printf "\tadd_header X-Region %s;\n" $service.metadata.name | indent 4 }}
        {{- printf "\tproxy_pass http://%s$uri$is_args$args;\n" $service.metadata.name | indent 4 }}
        {{- println "}" }}
    {{- end -}}
{{- end -}}

{{/*
Checking that the back service is valid
*/}}
{{- define "front.isValidBackService" -}}
    {{- $service := .service -}}
    {{- $is_valid := false -}}
    {{- $navigroup := default "" .context.Values.navigroup -}}
    {{/* Supported back implementations: navi-back, mock, splitter */}} 
    {{- if 
    and
    (has (get $service.metadata.labels "app.kubernetes.io/name") (list "navi-back" "mock" "splitter"))
    (eq (get $service.metadata.labels "navigroup") $navigroup) 
    (not (get $service.metadata.labels "behindSplitter"))
    -}}
        {{- $is_valid = true -}}
    {{- end -}}
    {{- ternary "true" "" $is_valid -}}
{{- end -}}

{{/*
Checking that the router service is valid
*/}}
{{- define "front.isValidRouterService" -}}
    {{- $service := .service -}}
    {{- $is_valid := false -}}
    {{- $navigroup := default "" .context.Values.navigroup -}}
    {{- if
    and
    (eq (get $service.metadata.labels "app.kubernetes.io/name") "navi-router")
    (eq (get $service.metadata.labels "navigroup") $navigroup) -}}
        {{- $is_valid = true -}}
    {{- end -}}
    {{- ternary "true" "" $is_valid -}}
{{- end -}}


{{/*
Create locations for rules upstreams
*/}}
{{- define "front.createLocations" -}}
{{- $ns := print .Release.Namespace -}}
{{- range $index, $service := (lookup "v1" "Service" $ns "").items -}}
    {{- if kindIs "map" $service.metadata.labels }}
        {{- if (include "front.isValidBackService" ( dict "service" $service "context" $)) }}
            {{- include "front.renderLocation" $service -}}
        {{- end }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Create upstreams for running navi-back instances in the namespace
*/}}
{{- define "front.createUpstreams" -}}
{{- $ns := print .Release.Namespace }}
{{- range $index, $service := (lookup "v1" "Service" $ns "").items -}}
    {{- if kindIs "map" $service.metadata.labels }}
        {{- if (include "front.isValidBackService" ( dict "service" $service "context" $)) }}
            {{- include "front.renderUpstream" $service }}
        {{- end }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Create upstreams for running navi-router in the namespace
*/}}
{{- define "front.createRouterUpstream" -}}
{{- $location := "router" -}}
{{- $ns := print .Release.Namespace -}}
{{- range $index, $service := (lookup "v1" "Service" $ns "").items -}}
    {{- if kindIs "map" $service.metadata.labels }}
        {{- if (include "front.isValidRouterService" ( dict "service" $service "context" $)) }}
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

{{/*
Return the target Kubernetes version
*/}}
{{- define "capabilities.kubeVersion" -}}
{{- if .Values.global }}
    {{- if .Values.global.kubeVersion }}
    {{- .Values.global.kubeVersion -}}
    {{- else }}
    {{- default .Capabilities.KubeVersion.Version .Values.kubeVersion -}}
    {{- end -}}
{{- else }}
{{- default .Capabilities.KubeVersion.Version .Values.kubeVersion -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for Horizontal Pod Autoscaler.
*/}}
{{- define "capabilities.hpa.apiVersion" -}}
{{- if semverCompare "<1.23-0" (include "capabilities.kubeVersion" .) -}}
{{- if .beta2 -}}
{{- print "autoscaling/v2beta2" -}}
{{- else -}}
{{- print "autoscaling/v2beta1" -}}
{{- end -}}
{{- else -}}
{{- print "autoscaling/v2" -}}
{{- end -}}
{{- end -}}
