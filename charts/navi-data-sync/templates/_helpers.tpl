{{/*
Create the name of the service account to use in a deletion hook
*/}}
{{- define "navi-data-sync.deleteHookServiceAccountName" -}}
{{- /* Service account lifecycle is unbound by the chart release. Avoid suffix make up. */}}
{{- if not (or .Values.serviceAccount.deleteHook.create .Values.serviceAccount.create) }}
  {{- .Values.serviceAccount.deleteHook.name |
        default (include "generic-chart.serviceAccountName" .) }}
{{- /* Avoid identical service account names if any one is bound by the chart release. */}}
{{- else }}
  {{- .Values.serviceAccount.deleteHook.name |
        default (print (include "generic-chart.serviceAccountName" .) "-delete-hook") }}
{{- end }}
{{- end }}

{{/*
CronJob names must fit 52 characters because Kubernetes appends an 11-character
suffix when creating Jobs from CronJobs.
*/}}
{{- define "navi-data-sync.cronjobName" -}}
{{- $fullname := include "generic-chart.fullname" . -}}
{{- if gt (len $fullname) 52 }}
  {{- $nameSuffix := printf "data-sync-%s" .Values.type }}
  {{- $namePrefixLength := sub 51 (len $nameSuffix) | int }}
  {{- $namePrefix := trimSuffix (printf "-%s" $nameSuffix) $fullname | trunc $namePrefixLength | trimSuffix "-" }}
  {{- printf "%s-%s" $namePrefix $nameSuffix }}
{{- else }}
  {{- $fullname }}
{{- end }}
{{- end }}

{{/*
Decodes a string encoded YAML structure or a list of them
*/}}
{{- define "navi-data-sync.mergeValuesStrings" -}}
{{- $valuesStrings := kindIs "slice" . | ternary . (list .) }}
{{- $mergedList := first $valuesStrings | default "" | fromYaml }}
{{- range (rest $valuesStrings) }}
{{- $mergedList := default "" . | fromYaml | mustMergeOverwrite $mergedList }}
{{- end }}{{- /* range */}}
{{ $mergedList | toYaml }}
{{- end }}

{{/*
Merges child values, returns the structure as a YAML text block
*/}}
{{- define "navi-data-sync.mergedChildValues" -}}
{{- $valuesString := include "navi-data-sync.mergeValuesStrings" .valuesString | fromYaml | default dict }}
{{- $values := .values | default dict }}
{{- /* Keep Helm precedence: inline child values override common valuesString layers. */}}
{{- mustMergeOverwrite $valuesString $values | toYaml }}
{{- end }}
