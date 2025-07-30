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


{{/*
Get count of CPU from limits.
Usage:
{{ include "config.setCpuNumber" $ }}
*/}}
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
         {{- if eq .name $.context.Values.naviback.app_rule -}}
            {{- if (has $.routingValue .routing) -}}
               {{- $found = true -}}
            {{- end -}}
         {{- end -}}
      {{- end -}}
   {{- end -}}
   {{- ternary "true" "" $found -}}
{{- end -}}


{{/*
Check if routing section in rules only contains certain value
Usage:
{{ include "rules.inRoutingSectionOnly" ( dict "routingValue" "<value>" "context" $) }}
*/}}
{{- define "rules.inRoutingSectionOnly" -}}
   {{- /* if different value found */}}
   {{- $ctx := .context -}}
   {{- $sectionFound := false -}}
   {{- $matches := false -}}
   {{- if $ctx.Values.rules -}}
      {{- range $ctx.Values.rules -}}
         {{- if eq .name $ctx.Values.naviback.app_rule -}}
            {{- $sectionFound = true -}}
            {{- $matches = (.routing | uniq | join "," | eq "ctx") -}}
         {{- end -}}
      {{- end -}}
   {{- end -}}
   {{- and $matches $sectionFound | ternary "true" "false" -}}
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
         {{- if eq .name $.context.Values.naviback.app_rule -}}
            {{- if (has $.queriesValue .queries) -}}
               {{- $found = true -}}
            {{- end -}}
         {{- end -}}
      {{- end -}}
   {{- end -}}
   {{- ternary "true" "" $found -}}
{{- end -}}

{{/*
Get a string containing comma-separated list of all queries supported by app_rule
Usage:
{{ include "rules.getQueriesString" (dict "context" $) }}
*/}}
{{- define "rules.getQueriesString" }}
  {{- $result := "" }}
  {{- if $.context.Values.rules }}
    {{- range $.context.Values.rules }}
        {{- if eq .name $.context.Values.naviback.app_rule -}}
            {{- $result = (.queries | uniq | sortAlpha | join ",") }}
        {{- end }}
    {{- end }}
  {{- end }}
  {{- $result | quote -}}
{{- end }}

{{/*
Set simple_network_car parameter in server config section
Usage:
{{ include "config.setSimpleNetworkCar" $ }}
*/}}
{{- define "config.setSimpleNetworkCar" -}}
   {{-  ternary
      $.Values.naviback.simpleNetwork.car
      (or (include "rules.inRoutingSection" (dict "routingValue" "driving" "context" $))
      (include "rules.inQueriesSection" (dict "queriesValue" "map_matching" "context" $)))
      (hasKey $.Values.naviback.simpleNetwork "car")
   -}}
{{- end -}}


{{/*
Set simple_network_pedestrian parameter in server config section
Usage:
{{ include "config.setSimpleNetworkPedestrian" $ }}
*/}}
{{- define "config.setSimpleNetworkPedestrian" -}}
   {{-  ternary
      $.Values.naviback.simpleNetwork.pedestrian
      (or (include "rules.inRoutingSection" (dict "routingValue" "ctx" "context" $))
      (include "rules.inRoutingSection" (dict "routingValue" "public_transport" "context" $))
      (include "rules.inRoutingSection" (dict "routingValue" "pedestrian" "context" $)))
      (hasKey $.Values.naviback.simpleNetwork "pedestrian")
   -}}
{{- end -}}


{{/*
Set simple_network_taxi parameter in server config section
Usage:
{{ include "config.setSimpleNetworkTaxi" $ }}
*/}}
{{- define "config.setSimpleNetworkTaxi" -}}
   {{-  ternary
      $.Values.naviback.simpleNetwork.taxi
      (include "rules.inRoutingSection" (dict "routingValue" "taxi" "context" $))
      (hasKey $.Values.naviback.simpleNetwork "taxi")
   -}}
{{- end -}}


{{/*
Set simple_network_bicycle parameter in server config section
Usage:
{{ include "config.setSimpleNetworkBicycle" $ }}
*/}}
{{- define "config.setSimpleNetworkBicycle" -}}
   {{-  ternary
      $.Values.naviback.simpleNetwork.bicycle
      (or (include "rules.inRoutingSection" (dict "routingValue" "bicycle" "context" $))
      (include "rules.inRoutingSection" (dict "routingValue" "scooter" "context" $)))
      (or (hasKey $.Values.naviback.simpleNetwork "bicycle") (hasKey $.Values.naviback.simpleNetwork "scooter"))
   -}}
{{- end -}}


{{/*
Set simple_network_truck parameter in server config section
Usage:
{{ include "config.setSimpleNetworkTruck" $ }}
*/}}
{{- define "config.setSimpleNetworkTruck" -}}
   {{-  ternary
      $.Values.naviback.simpleNetwork.truck
      (include "rules.inRoutingSection" (dict "routingValue" "truck" "context" $))
      (hasKey $.Values.naviback.simpleNetwork "truck")
   -}}
{{- end -}}


{{/*
Set simple_network_emergency parameter in server config section
Usage:
{{ include "config.setSimpleNetworkEmergency" $ }}
*/}}
{{- define "config.setSimpleNetworkEmergency" -}}
   {{-  ternary
      $.Values.naviback.simpleNetwork.emergency
      (include "rules.inRoutingSection" (dict "routingValue" "emergency" "context" $))
      (hasKey $.Values.naviback.simpleNetwork "emergency")
   -}}
{{- end -}}


{{/*
Set simple_network_motorcycle parameter in server config section
Usage:
{{ include "config.setSimpleNetworkMotorcycle" $ }}
*/}}
{{- define "config.setSimpleNetworkMotorcycle" -}}
   {{-  ternary
      $.Values.naviback.simpleNetwork.motorcycle
      (include "rules.inRoutingSection" (dict "routingValue" "motorcycle" "context" $))
      (hasKey $.Values.naviback.simpleNetwork "motorcycle")
   -}}
{{- end -}}


{{/*
Set attractor_car parameter in server config section
Usage:
{{ include "config.setAttractorCar" $ }}

Sets value from naviback.attractor[] if specified,
`false` if transmitter.enabled (external attractor given),
or makes a guess from the routing list.
*/}}
{{- define "config.setAttractorCar" -}}
    {{-
        dig "car"
        (.Values.transmitter.enabled | ternary
            false
            (include "rules.inRoutingSection" (dict "routingValue" "driving" "context" .))
        )
        .Values.naviback.attractor
    -}}
{{- end -}}


{{/*
Set attractor_pedestrian parameter in server config section
Usage:
{{ include "config.setAttractorPedestrian" $ }}

Sets value from naviback.attractor[] if specified,
`false` if transmitter.enabled (external attractor given),
or makes a guess from the routing list.
*/}}
{{- define "config.setAttractorPedestrian" -}}
    {{-
        dig "pedestrian"
        (.Values.transmitter.enabled | ternary
            false
            (or (include "rules.inRoutingSection" (dict "routingValue" "ctx" "context" .))
                (include "rules.inRoutingSection" (dict "routingValue" "public_transport" "context" .))
                (include "rules.inRoutingSection" (dict "routingValue" "pedestrian" "context" .)))
        )
        .Values.naviback.attractor
    -}}
{{- end -}}


{{/*
Set attractor_taxi parameter in server config section
Usage:
{{ include "config.setAttractorTaxi" $ }}

Sets value from naviback.attractor[] if specified,
`false` if transmitter.enabled (external attractor given),
or makes a guess from the routing list.
*/}}
{{- define "config.setAttractorTaxi" -}}
    {{-
        dig "taxi"
        (.Values.transmitter.enabled | ternary
            false
            (include "rules.inRoutingSection" (dict "routingValue" "taxi" "context" .))
        )
        .Values.naviback.attractor
    -}}
{{- end -}}


{{/*
Set attractor_truck parameter in server config section
Usage:
{{ include "config.setAttractorTruck" $ }}

Sets value from naviback.attractor[] if specified,
`false` if transmitter.enabled (external attractor given),
or makes a guess from the routing list.
*/}}
{{- define "config.setAttractorTruck" -}}
    {{-
        dig "truck"
        (.Values.transmitter.enabled | ternary
            false
            (include "rules.inRoutingSection" (dict "routingValue" "truck" "context" .))
        )
        .Values.naviback.attractor
    -}}
{{- end -}}


{{/*
Set attractor_bicycle parameter in server config section
Usage:
{{ include "config.setAttractorBicycle" $ }}

Sets value from naviback.attractor[] if specified,
`false` if transmitter.enabled (external attractor given),
or makes a guess from the routing list.
*/}}
{{- define "config.setAttractorBicycle" -}}
    {{- $has_bicycle_or_scooter := (or (hasKey .Values.naviback.attractor "bicycle") (hasKey .Values.naviback.attractor "scooter")) -}}
    {{- $bicycle := .Values.naviback.attractor.bicycle | default false -}}
    {{- $scooter := .Values.naviback.attractor.scooter | default false -}}
    {{-
        $has_bicycle_or_scooter | ternary
            (or $bicycle $scooter)
            (.Values.transmitter.enabled | ternary
                false
                (or (include "rules.inRoutingSection" (dict "routingValue" "bicycle" "context" .))
                    (include "rules.inRoutingSection" (dict "routingValue" "scooter" "context" .))
                )
            )
    -}}
{{- end -}}


{{/*
Set attractor_motorcycle parameter in server config section
Usage:
{{ include "config.setAttractorMotorcycle" $ }}

Sets value from naviback.attractor[] if specified,
`false` if transmitter.enabled (external attractor given),
or makes a guess from the routing list.
*/}}
{{- define "config.setAttractorMotorcycle" -}}
    {{-
        dig "motorcycle"
        (.Values.transmitter.enabled | ternary
            false
            (include "rules.inRoutingSection" (dict "routingValue" "motorcycle" "context" .))
        )
        .Values.naviback.attractor
    -}}
{{- end -}}


{{/*
Set reduce_edges_optimization_flag to True if queries contains get_dist_matrix value
Usage:
{{ include "config.setReduceEdgesOptimizationFlag" $ }}
*/}}
{{- define "config.setReduceEdgesOptimizationFlag" -}}
   {{-  ternary
      $.Values.naviback.reduceEdgesOptimizationFlag
      (include "rules.inQueriesSection" (dict "queriesValue" "get_dist_matrix" "context" $))
      ($.Values.naviback.reduceEdgesOptimizationFlag | default false )
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

{{/*
Set ECA URL
Usage:
{{ include "config.setEcaUrl" $ }}
*/}}
{{- define "config.setEcaUrl" -}}
   {{- if .Values.naviback.ecaUrl -}}
   {{- printf .Values.naviback.ecaUrl -}}
   {{- else if .Values.naviback.ecaHost -}}
   {{- printf "http://%s" .Values.naviback.ecaHost -}}
   {{- end -}}
{{- end -}}

{{/*
Set long speed forecasts URL
Usage:
{{ include "config.setLongForecastUrl" $ }}
*/}}
{{- define "config.setLongForecastUrl" -}}
   {{- if .Values.naviback.longForecastUrl -}}
   {{- printf .Values.naviback.longForecastUrl -}}
   {{- end -}}
{{- end -}}

{{/*
Set speed forecasts URL
Usage:
{{ include "config.setForecastUrl" $ }}
*/}}
{{- define "config.setForecastUrl" -}}
   {{- if .Values.naviback.forecastUrl -}}
   {{- printf .Values.naviback.forecastUrl -}}
   {{ else if .Values.naviback.forecastHost -}}
   {{- printf "http://%s" .Values.naviback.forecastHost -}}
   {{- end -}}
{{- end -}}

{{/*
Set castle url
Usage:
{{ include "config.setCastleUrl" $ }}
*/}}
{{- define "config.setCastleUrl" -}}
   {{- if .Values.naviback.castleUrl -}}
   {{- printf .Values.naviback.castleUrl -}}
   {{- else if .Values.naviback.castleHost -}}
   {{- printf "http://%s" .Values.naviback.castleHost -}}
   {{- end -}}
{{- end -}}

{{/*
Set index name for castleProxy
Usage:
{{ include "config.setCastleProxyIndex" $ }}
*/}}
{{- define "config.setCastleProxyIndex" -}}
   {{- if .Values.naviback.castleUrlProxy -}}
   {{- print "proxy" -}}
   {{- else -}}
   {{- print "default" -}}
   {{- end -}}
{{- end -}}

{{/*
Set restriction url
If rtr enabled return naviback.rtr.url, else return naviback.castleUrl
Usage:
{{ include "config.setRestrictionUrl" $ }}
*/}}
{{- define "config.setRestrictionUrl" -}}
   {{- if .Values.naviback.rtr.enabled -}}
   {{- printf .Values.naviback.rtr.url -}}
   {{- else  -}}
   {{- printf (include "config.setCastleUrl" $) -}}
   {{- end -}}
{{- end -}}

{{/*
Set custom CAs mount path
Usage:
{{ include "custom.ca.mountPath" $ }}
*/}}
{{- define "custom.ca.mountPath" -}}
{{ .Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
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
Calculate maximum processing time
*/}}
{{- define "config.getMaxProcessTime" -}}
  {{- $result := (get .Values.naviback "maxProcessTime") | default 20}}
  {{- range $query, $timeout := .Values.naviback.queryTimeouts }}
    {{- if (eq "true" (include "rules.inQueriesSection" (dict "queriesValue" $query "context" $))) }}
        {{- $result = max $result $timeout }}
    {{- end }}
  {{- end }}
  {{- $result }}
{{- end }}
