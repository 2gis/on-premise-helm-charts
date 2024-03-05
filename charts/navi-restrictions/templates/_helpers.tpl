{{- define "navi-restrictions.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "navi-restrictions.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "navi-restrictions.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "navi-restrictions.selectorLabels" -}}
app.kubernetes.io/name: {{ include "navi-restrictions.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "navi-restrictions.labels" -}}
helm.sh/chart: {{ include "navi-restrictions.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "navi-restrictions.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "navi-restrictions.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

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

{{/*
Check for deprecated values
*/}}
{{- define "check.deprecated.values" -}}
{{- if not ("1.19.0" | get ((.Values.debug).disableDeprecationChecks | default dict) ) }}
{{- if .Values.api.api_key -}}{{ fail "[after 1.19.0] .Values.api.api_key is deprecated, use .Values.api.apiKey" }}{{- end }}
{{- if .Values.api.is_init_db -}}{{ fail "[after 1.19.0] .Values.api.is_init_db is deprecated, use .Values.api.isInitDb" }}{{- end }}
{{- if .Values.api.attractor_url -}}{{ fail "[after 1.19.0] .Values.api.attractor_url is deprecated, use .Values.api.attractorUrl" }}{{- end }}
{{- if .Values.cron.edges_url_template -}}{{ fail "[after 1.19.0] .Values.cron.edges_url_template is deprecated, use .Values.cron.edgesUrlTemplate" }}{{- end }}
{{- if .Values.cron.edge_attributes_url_template -}}{{ fail "[after 1.19.0] .Values.cron.edge_attributes_url_template is deprecated, use .Values.cron.edgeAttributesUrlTemplate" }}{{- end }}
{{- if .Values.cron.max_attributes_fetcher_rps -}}{{ fail "[after 1.19.0] .Values.cron.max_attributes_fetcher_rps is deprecated, use .Values.cron.maxAttributesFetcherRps" }}{{- end }}
{{- end }} {{/* 1.19.0 */}}
{{- end }}
