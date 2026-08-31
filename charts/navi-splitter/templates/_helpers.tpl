{{/*
Distinguishable main container name
Override generic-chart
*/}}
{{- define "generic-chart.containerName" -}}
{{- if .Values.dataGroup.enabled }}
{{- .Values.dataGroup.prefix }}-{{ .Chart.Name }}
{{- else }}
{{- .Chart.Name }}
{{- end }}
{{- end -}}

{{/*
Calculate envoy --concurrency value
*/}}
{{- define "envoy.get-concurrency" }}
    {{- if ne 0 (.Values.envoy.concurrency | int) }}
        {{- max 1 (.Values.envoy.concurrency | int) -}}
    {{- else if (.Values.envoy.resources.limits).cpu }}
        {{- max 1 (include "generic-chart.parse-resource-quantity" .Values.envoy.resources.limits.cpu | floor | int) }}
    {{- else }}
        {{- printf "1" -}}
    {{- end }}
{{- end }}

{{/*
Set clusterTimout for attractor cluster
Usage:
 {{ include "envoy.timeout" ( list .Values.envoy "attractor" "clusterTimeout") }}
 {{ include "envoy.timeout" ( list .Values.envoy "oneToMany" "clusterTimeout") }}
 {{ include "envoy.timeout" ( list .Values.envoy "attractor" "connectTimeout") }}
 {{ include "envoy.timeout" ( list .Values.envoy "oneToMany" "connectTimeout") }}
*/}}
{{- define "envoy.timeout" -}}
  {{- $root := index . 0 -}}
  {{- $cluster := index . 1 -}}
  {{- $param := index . 2 -}}
  {{- $envoy := $root | default dict -}}
  {{- $clusterValues := get $envoy $cluster | default dict -}}
  {{- get $clusterValues $param | default (get $envoy $param) -}}
{{- end -}}
