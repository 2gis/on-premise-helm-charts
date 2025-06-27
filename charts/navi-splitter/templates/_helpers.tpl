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
