{{/*
Distinguishable main container name
Override generic-chart
TODO: rewrite https://github.com/helm/helm/issues/11291
*/}}
{{- define "generic-chart.containerName" -}}
{{- if .Values.dataGroup.enabled }}
{{- .Values.dataGroup.prefix }}-{{ .Chart.Name }}
{{- else }}
{{- .Chart.Name }}
{{- end }}
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
    {{- $rules := list -}}
    {{- if ( and .Values.rules (kindIs "slice" .Values.rules )) -}}
        {{- $rules = .Values.rules -}}
    {{- end -}}
      {{ $rules | toPrettyJson | nindent 6 -}}
{{- end -}}


{{/*
Check if value exists in rule routing section
Usage:
{{ include "rules.inRoutingSection" ( dict "routingValue" "<value>" "context" $) }}
*/}}
{{- define "rules.inRoutingSection" -}}
   {{- $found := false -}}
   {{- if $.context.Values.rules -}}
      {{- range $.context.Values.rules -}}
         {{- if eq .name $.context.Values.attractor.app_rule -}}
            {{- if (has $.routingValue .routing) -}}
               {{- $found = true -}}
            {{- end -}}
         {{- end -}}
      {{- end -}}
   {{- end -}}
   {{- ternary "true" "" $found -}}
{{- end -}}


{{/*
Check if value exists in rule queries section
Usage:
{{ include "rules.inQueriesSection" ( dict "queriesValue" "<value>" "context" $) }}
*/}}
{{- define "rules.inQueriesSection" -}}
   {{- $found := false -}}
   {{- if $.context.Values.rules -}}
      {{- range $.context.Values.rules -}}
         {{- if eq .name $.context.Values.attractor.app_rule -}}
            {{- if (has $.queriesValue .queries) -}}
               {{- $found = true -}}
            {{- end -}}
         {{- end -}}
      {{- end -}}
   {{- end -}}
   {{- ternary "true" "" $found -}}
{{- end -}}


{{/*
Set attractor_car parameter in server config section
Usage:
{{ include "config.setAttractorCar" $ }}
*/}}
{{- define "config.setAttractorCar" -}}
   {{-  ternary
      $.Values.attractor.attractor.car
      (include "rules.inRoutingSection" (dict "routingValue" "driving" "context" $))
      (hasKey $.Values.attractor.attractor "car")
   -}}
{{- end -}}


{{/*
Set attractor_pedestrian parameter in server config section
Usage:
{{ include "config.setAttractorPedestrian" $ }}
*/}}
{{- define "config.setAttractorPedestrian" -}}
   {{-  ternary
      $.Values.attractor.attractor.pedestrian
      (or (include "rules.inRoutingSection" (dict "routingValue" "ctx" "context" $))
      (include "rules.inRoutingSection" (dict "routingValue" "public_transport" "context" $))
      (include "rules.inRoutingSection" (dict "routingValue" "pedestrian" "context" $)))
      (hasKey $.Values.attractor.attractor "pedestrian")
   -}}
{{- end -}}


{{/*
Set attractor_taxi parameter in server config section
Usage:
{{ include "config.setAttractorTaxi" $ }}
*/}}
{{- define "config.setAttractorTaxi" -}}
   {{-  ternary
      $.Values.attractor.attractor.taxi
      (include "rules.inRoutingSection" (dict "routingValue" "taxi" "context" $))
      (hasKey $.Values.attractor.attractor "taxi")
   -}}
{{- end -}}


{{/*
Set attractor_truck parameter in server config section
Usage:
{{ include "config.setAttractorTruck" $ }}
*/}}
{{- define "config.setAttractorTruck" -}}
   {{-  ternary
      $.Values.attractor.attractor.truck
      (include "rules.inRoutingSection" (dict "routingValue" "truck" "context" $))
      (hasKey $.Values.attractor.attractor "truck")
   -}}
{{- end -}}


{{/*
Set attractor_bicycle parameter in server config section
Usage:
{{ include "config.setAttractorBicycle" $ }}
*/}}
{{- define "config.setAttractorBicycle" -}}
   {{-  ternary
      $.Values.attractor.attractor.bicycle
      (or (include "rules.inRoutingSection" (dict "routingValue" "bicycle" "context" $))
      (include "rules.inRoutingSection" (dict "routingValue" "scooter" "context" $)))
      (or (hasKey $.Values.attractor.attractor "bicycle") (hasKey $.Values.attractor.attractor "scooter"))
   -}}
{{- end -}}


{{/*
Set attractor_motorcycle parameter in server config section
Usage:
{{ include "config.setAttractorMotorcycle" $ }}
*/}}
{{- define "config.setAttractorMotorcycle" -}}
   {{-  ternary
      $.Values.attractor.attractor.motorcycle
      (include "rules.inRoutingSection" (dict "routingValue" "motorcycle" "context" $))
      (hasKey $.Values.attractor.attractor "motorcycle")
   -}}
{{- end -}}


{{/*
Set attractor_emergency parameter in server config section
Usage:
{{ include "config.setAttractorEmergency" $ }}
*/}}
{{- define "config.setAttractorEmergency" -}}
   {{-  ternary
      $.Values.attractor.attractor.emergency
      (include "rules.inRoutingSection" (dict "routingValue" "emergency" "context" $))
      (hasKey $.Values.attractor.attractor "emergency")
   -}}
{{- end -}}


{{/*
Check if instance is running in truck mode
Usage:
{{ include "config.isTruck" $ }}
*/}}
{{- define "config.isTruck" -}}
   {{- $is_enabled_routing := ( eq "true" (include "rules.inRoutingSection" (dict "routingValue" "truck" "context" $))) -}}
   {{- ternary "true" "" $is_enabled_routing -}}
{{- end -}}


{{/*
Check if instance is running in ctx mode
Usage:
{{ include "config.isCTX" $ }}
*/}}
{{- define "config.isCTX" -}}
   {{- $is_enabled_routing := ( or (eq "true" (include "rules.inRoutingSection" (dict "routingValue" "ctx" "context" $))) (eq "true" (include "rules.inRoutingSection" (dict "routingValue" "public_transport" "context" $)))) -}}
   {{- $is_enabled_query := ( or (eq "true" (include "rules.inQueriesSection" (dict "queriesValue" "ctx" "context" $))) (eq "true" (include "rules.inQueriesSection" (dict "queriesValue" "public_transport" "context" $)))) -}}
   {{- ternary "true" "" (or $is_enabled_routing $is_enabled_query) -}}
{{- end -}}


{{/*
Check if instance is running in taxi mode
Usage:
{{ include "config.isTaxi" $ }}
*/}}
{{- define "config.isTaxi" -}}
   {{- $is_enabled_routing := ( eq "true" (include "rules.inRoutingSection" (dict "routingValue" "taxi" "context" $))) -}}
   {{- ternary "true" "" $is_enabled_routing -}}
{{- end -}}

{{/*
Check if map matching is enabled
Usage:
{{ include "config.isMapMatching" $ }}
*/}}
{{- define "config.isMapMatching" -}}
   {{- include "rules.inQueriesSection" (dict "queriesValue" "map_matching" "context" $) -}}
{{- end -}}

{{/* vim: set filetype=mustache: */}}

{{/*
Set castle url
Usage:
{{ include "config.setCastleUrl" $ }}
*/}}
{{- define "config.setCastleUrl" -}}
   {{- if .Values.attractor.castleUrl -}}
   {{- printf .Values.attractor.castleUrl -}}
   {{- else if .Values.attractor.app_castle_host -}}
   {{- printf "http://%s" .Values.attractor.app_castle_host -}}
   {{- end -}}
{{- end -}}

{{/*
Set restriction url
If rtr enabled return attractor.rtr.url, else return attractor.castleUrl
Usage:
{{ include "config.setRestrictionUrl" $ }}
*/}}
{{- define "config.setRestrictionUrl" -}}
   {{- if .Values.attractor.rtr.enabled -}}
   {{- printf .Values.attractor.rtr.url -}}
   {{- else  -}}
   {{- printf (include "config.setCastleUrl" $) -}}
   {{- end -}}
{{- end -}}
