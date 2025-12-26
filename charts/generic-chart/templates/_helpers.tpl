{{/*
Expand the name of the chart.
*/}}
{{- define "generic-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "generic-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
    {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else if .Values.nameOverride }}
    {{- printf "%s-%s" .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
    {{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "generic-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "generic-chart.labels" -}}
helm.sh/chart: {{ include "generic-chart.chart" . }}
{{ include "generic-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "generic-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "generic-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "generic-chart.serviceAccountName" -}}
{{- if (.Values.serviceAccount).create }}
    {{- default (include "generic-chart.fullname" .) (.Values.serviceAccount).name }}
{{- else }}
    {{- default "default" (.Values.serviceAccount).name }}
{{- end }}
{{- end }}

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
Container name resolution (backward-compatible)
Priority:
  1) .Values.containerNameOverride
  2) .Values.vpa.containerName
  3) "<chart>-<release>"
*/}}
{{- define "generic-chart.containerName" -}}
{{- if .Values.containerNameOverride -}}
  {{- include "tplvalues.render" (dict "value" .Values.containerNameOverride "context" .) -}}
{{- else if (.Values.vpa).containerName -}}
  {{- include "tplvalues.render" (dict "value" .Values.vpa.containerName "context" .) -}}
{{- else -}}
  {{- printf "%s" (.Chart.Name | replace "_" "-") -}}
{{- end -}}
{{- end }}

{{/*
VPA-specific container name
Priority:
  1) .Values.vpa.containerNameOverride
  2) include "generic-chart.containerName"
Backwards compatibility: legacy .Values.vpa.containerName is honored via generic-chart.containerName.
*/}}
{{- define "generic-chart.vpaContainerName" -}}
{{- if (.Values.vpa).containerNameOverride -}}
  {{- include "tplvalues.render" (dict "value" .Values.vpa.containerNameOverride "context" .) -}}
{{- else -}}
  {{- include "generic-chart.containerName" . -}}
{{- end -}}
{{- end -}}

{{- /*
generic-chart.merge will merge two YAML templates and output the result.
(originates from The Common Helm Helper Chart)

This takes an array of three values:
- the top context
- the template name of the overrides (destination)
- the template name of the base (source)
*/}}
{{- define "generic-chart.merge" -}}
  {{- $top := first . -}}
  {{- $overrides := fromYaml (include (index . 1) $top) | default (dict ) -}}
  {{- $tpl := fromYaml (include (index . 2) $top) | default (dict ) -}}
  {{- toYaml (merge $overrides $tpl) -}}
{{- end -}}

{{/*
Return the target Kubernetes version
*/}}
{{- define "generic-chart.capabilities.kubeVersion" -}}
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
{{- define "generic-chart.capabilities.hpa.apiVersion" -}}
  {{- if semverCompare "<1.23-0" (include "generic-chart.capabilities.kubeVersion" .) -}}
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
Return the appropriate type for Horizontal Pod Autoscaler.
*/}}
{{- define "generic-chart.capabilities.hpa.type" -}}
  {{- if semverCompare "<1.27-0" (include "generic-chart.capabilities.kubeVersion" .) -}}
type: Resource
resource:
  {{- else -}}
type: ContainerResource
containerResource:
  container: {{ include "generic-chart.containerName" . }}
  {{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for cronjob.
*/}}
{{- define "generic-chart.capabilities.cronjob.apiVersion" -}}
{{- if semverCompare "<1.21-0" (include "generic-chart.capabilities.kubeVersion" .) -}}
{{- print "batch/v1beta1" -}}
{{- else -}}
{{- print "batch/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the suffix from .suffix.
*/}}
{{- define "generic-chart.getSuffix" -}}
{{- if .suffix -}}
  {{- $suffix := include "tplvalues.render" (dict
                                      "value" .suffix
                                      "context" .ctx) }}
  {{- printf "-%s" (toString $suffix) -}}
{{- end -}}
{{- end -}}

{{/*
Convert k8s resource string to float
Based on https://github.com/helm/helm/issues/11376#issuecomment-1256831105
*/}}

{{- define "generic-chart.parse-resource-quantity" -}}
    {{- $value := . -}}
    {{- $unit := 1.0 -}}
    {{- if typeIs "string" . -}}
        {{- $base2 := dict "Ki" 0x1p10 "Mi" 0x1p20 "Gi" 0x1p30 "Ti" 0x1p40 "Pi" 0x1p50 "Ei" 0x1p60 -}}
        {{- $base10 := dict "m" 1e-3 "k" 1e3 "M" 1e6 "G" 1e9 "T" 1e12 "P" 1e15 "E" 1e18 -}}
        {{- range $suffix, $mult := merge $base2 $base10 -}}
            {{- if hasSuffix $suffix $value -}}
                {{- $value = trimSuffix $suffix $value -}}
                {{- $unit = $mult -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
    {{- mulf (float64 $value) $unit -}}
{{- end -}}

{{/*
Retrieve secrets from k8s.

Usage:
{{ include "generic-chart.secrets_lookup" (dict
    "secret" "secretName"
    "key" "keyName"
    "context" $)
}}

Params:
  - secret - String - Required - Name of the 'Secret' resource where the secret data is stored.
  - key - String - Required - Name of the key in the secret.
  - context - Context - Required - Parent context.
*/}}

{{- define "generic-chart.secrets-lookup" -}}
{{- $secretData := "" }}
{{- $secret := (lookup "v1" "Secret" .context.Release.Namespace .secret) }}
{{- if $secret }}
  {{- if index $secret.data .key }}
  {{- $secretData = index $secret.data .key }}
  {{- end -}}
{{- end -}}
{{- printf "%s" $secretData -}}
{{- end -}}
