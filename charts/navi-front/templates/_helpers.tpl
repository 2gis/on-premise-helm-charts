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
{{- $found := 0 }}
{{- $navigroup_set := default "0" $.Values.navigroup }}
{{- range $index, $service := (lookup "v1" "Service" $ns "").items -}}
    {{- if kindIs "map" $service.metadata.labels }}
        {{- if eq $navigroup_set "0" }}
                {{- if and (eq (get $service.metadata.labels "app.kubernetes.io/name") "navi-back") (eq (get $service.metadata.labels "navigroup") "") }}
                {{- if ( ne (get $service.metadata.labels "rule") "") }}
                    {{- $rule := get $service.metadata.labels "rule" }}
                    {{- printf "location /%s {" $rule }}
                    {{- printf "rewrite ^/%s(.*)$ $1 break;" $rule }}
                    {{- printf "add_header X-Region %s;" $service.metadata.name }}
                    {{- printf "proxy_pass http://%s$uri$is_args$args;" $service.metadata.name }}
                    {{- println "}" }}
                {{- end }}
                {{- end }}
        {{- else }}
            {{- if and (eq (get $service.metadata.labels "app.kubernetes.io/name") "navi-back") (eq (get $service.metadata.labels "navigroup") $.Values.navigroup ) }}
                {{- if ( ne (get $service.metadata.labels "rule") "") }}
                    {{- $rule := get $service.metadata.labels "rule" }}
                    {{- printf "location /%s {" $rule }}
                    {{- printf "rewrite ^/%s(.*)$ $1 break;" $rule }}
                    {{- printf "add_header X-Region %s;" $service.metadata.name }}
                    {{- printf "proxy_pass http://%s$uri$is_args$args;" $service.metadata.name }}
                    {{- println "}" }}
                {{- end }}
            {{- end }}
        {{- end }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Create upstreams for running navi-back in the namespace
*/}}
{{- define "front.getUpstreams" -}}
{{- $locations := list -}}
{{- $location := "mosesd" -}}
{{- $ns := print .Release.Namespace }}
{{- $found := 0 }}
{{- $navigroup_set := default "0" $.Values.navigroup }}
{{- range $index, $service := (lookup "v1" "Service" $ns "").items -}}
    {{- if kindIs "map" $service.metadata.labels }}
        {{- if eq $navigroup_set "0" }}
                {{- if and (eq (get $service.metadata.labels "app.kubernetes.io/name") "navi-back") (eq (get $service.metadata.labels "navigroup") "") }}
                    {{- $location = $service.metadata.name -}}
                    {{- printf "upstream %s {" $service.metadata.name }}
                    {{- printf "server %s;" $service.metadata.name }}
                    {{- println "}" }}
                {{- end }}
        {{- else }}
            {{- if and (eq (get $service.metadata.labels "app.kubernetes.io/name") "navi-back") (eq (get $service.metadata.labels "navigroup") $.Values.navigroup ) }}
                {{- $location = $service.metadata.name -}}
                {{- printf "upstream %s {" $service.metadata.name }}
                {{- printf "server %s;" $service.metadata.name }}
                {{- println "}" }}
            {{- end }}
        {{- end }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Create upstream of running navi-router in the namespace
*/}}
{{- define "front.getMrouterUpstream" -}}
{{- $location := "navi-router" -}}
{{- $ns := print .Release.Namespace -}}
{{- $found := 0 }}
{{- $navigroup_set := default "0" $.Values.navigroup }}
{{- range $index, $service := (lookup "v1" "Service" $ns "").items -}}
    {{- if kindIs "map" $service.metadata.labels }}
        {{- if eq $navigroup_set "0" }}
                {{- if and (eq (get $service.metadata.labels "app.kubernetes.io/name") "navi-router") (eq (get $service.metadata.labels "navigroup") "") }}
                    {{- $location = $service.metadata.name -}}
                    {{- print $location -}}
                {{- end }}
        {{- else }}
            {{- if and (eq (get $service.metadata.labels "app.kubernetes.io/name") "navi-router") (eq (get $service.metadata.labels "navigroup") $.Values.navigroup ) }}
                {{- $location = $service.metadata.name -}}
                {{- print $location -}}
            {{- end }}
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
