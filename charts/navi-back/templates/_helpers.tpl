{{/*
Expand the name of the chart.
*/}}
{{- define "naviback.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "naviback.fullname" -}}
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
{{- define "naviback.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Distinguishable main container name
*/}}
{{- define "naviback.containerName" -}}
{{- if .Values.dataGroup.enabled }}
{{- .Values.dataGroup.prefix }}-{{ .Chart.Name }}
{{- else }}
{{- .Chart.Name }}
{{- end }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "naviback.labels" -}}
helm.sh/chart: {{ include "naviback.chart" . }}
{{ include "naviback.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "naviback.selectorLabels" -}}
app.kubernetes.io/name: {{ include "naviback.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "naviback.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "naviback.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
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
Set attractor_car parameter in server config section
Usage:
{{ include "config.setAttractorCar" $ }}

Sets value from naviback.attractor[] if specified,
`false` if transmitter.enabled (external attractor given),
or makes a guess from the routing list.
*/}}
{{- define "config.setAttractorCar" -}}
   {{- ternary
      .Values.naviback.attractor.car
      (.Values.transmitter.enabled | ternary false
          (include "rules.inRoutingSection" (dict "routingValue" "driving" "context" .)))
      (hasKey .Values.naviback.attractor "car")
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
   {{- ternary
      .Values.naviback.attractor.pedestrian
      (.Values.transmitter.enabled | ternary false
          (or (include "rules.inRoutingSection" (dict "routingValue" "ctx" "context" .))
              (include "rules.inRoutingSection" (dict "routingValue" "public_transport" "context" .))
              (include "rules.inRoutingSection" (dict "routingValue" "pedestrian" "context" .))))
      (hasKey .Values.naviback.attractor "pedestrian")
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
   {{- ternary
      .Values.naviback.attractor.taxi
      (.Values.transmitter.enabled | ternary false
          (include "rules.inRoutingSection" (dict "routingValue" "taxi" "context" .)))
      (hasKey .Values.naviback.attractor "taxi")
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
   {{- ternary
      .Values.naviback.attractor.truck
      (.Values.transmitter.enabled | ternary false
          (include "rules.inRoutingSection" (dict "routingValue" "truck" "context" .)))
      (hasKey .Values.naviback.attractor "truck")
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
   {{- ternary
      (or (.Values.naviback.attractor).bicycle (.Values.naviback.attractor).scooter)
      ( .Values.transmitter.enabled | ternary false
          (or (include "rules.inRoutingSection" (dict "routingValue" "bicycle" "context" .))
              (include "rules.inRoutingSection" (dict "routingValue" "scooter" "context" .))))
      (or (hasKey .Values.naviback.attractor "bicycle") (hasKey .Values.naviback.attractor "scooter"))
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
Set engine_update_period_sec value in config server section
For pedestrain and bicycle routing type this value will be set in 0
Usage:
{{ include "config.setEngineUpdatePeriod" $ }}
*/}}
{{- define "config.setEngineUpdatePeriod" -}}
   {{- if (or (include "config.setSimpleNetworkPedestrian" $) (include "config.setSimpleNetworkBicycle" $)) -}}
      {{- 0 | int -}}
   {{- end -}}
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
Set castle url
If use frozenData return local path
Usage:
{{ include "config.setCastleUrl" $ }}
*/}}
{{- define "config.setCastleUrl" -}}
   {{- if .Values.frozenData.enabled -}}
   {{- printf "file://{LOCAL_PATH}" -}}
   {{- else if .Values.naviback.castleUrl -}}
   {{- printf .Values.naviback.castleUrl -}}
   {{- else if .Values.naviback.castleHost -}}
   {{- printf "http://%s" .Values.naviback.castleHost -}}
   {{- end -}}
{{- end -}}
