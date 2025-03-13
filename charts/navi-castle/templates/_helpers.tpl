{{/*
Expand the name of the chart.
*/}}
{{- define "castle.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "castle.fullname" -}}
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
{{- define "castle.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "castle.labels" -}}
helm.sh/chart: {{ include "castle.chart" . }}
{{ include "castle.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "castle.selectorLabels" -}}
app.kubernetes.io/name: {{ include "castle.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "castle.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "castle.fullname" .) .Values.serviceAccount.name }}
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
Determine --service parameter for a specific cron job flavor
{{ include "castle.serviceParameter" ( dict "flavor" <a key one of .Values.cron.enabled.* > ) }}
*/}}
{{- define "castle.serviceParameter" -}}
{{- eq "restrictionImport" .flavor | ternary "import-restrictions" .flavor -}}
{{- end -}}


{{- /*
     Collect merged Kafka properties from these dictionaries:
       - kafka.properties: this is a simple key/value dictionary
       - kafka.fileProperties: this is a key/content dictionary given in values,
         content is sensitive and stored in Secret resource, they get
         mounted as files sonamed after key. While actual secret values are
         hidden this way, what actually goes here in environment properties is
         file names. This value substitution is implemented down here.
     */ -}}

{{- /* Merge .kafka.properties and .kafka.fileProperties dictionaries.

       Context:
         .kafka.properties
         .kafka.fileProperties
         .overrides.properties
         .overrides.fileProperties
         .mountpoint

       File properties values (file contents) replaced with keys (file names).
       File names prepended with the supposed directory from .mountpoint.
       overrides.* are merged with kafka.* accordingly.

       Returns {"ret": that-merged-dict}.
       Folding result in "ret" needed for marshalling.
     */ -}}
{{- define "castle.kafkaProperties" -}}
  {{- $ctx := . -}}
  {{- $kafkaProperties := dict -}}
  {{- $fileProperties := deepCopy $ctx.kafka.fileProperties | mustMerge (($ctx.overrides).fileProperties | default dict) -}}
  {{- range $key, $_ := $fileProperties -}}
    {{- $_ := set $kafkaProperties $key (printf "%s/%s" $ctx.mountpoint $key) -}}
  {{- end -}}
  {{- $regularProperties := deepCopy $ctx.kafka.properties | mustMerge (($ctx.overrides).properties | default dict) -}}
  {{- $kafkaProperties = deepCopy $regularProperties | mustMerge $kafkaProperties -}}
  {{- dict "ret" $kafkaProperties | toYaml }}
{{- end }}


{{- /* Translate properties into `env` construction as in containers:

       Context:
         .kafka.properties
         .kafka.fileProperties
         .kafka.sensitiveProperties
         .overrides.properties
         .overrides.fileProperties
         .overrides.sensitiveProperties
         .mountpoint
         .secretname
         .prefix

       .kafka.properties and .kafka.fileProperties merged with kafkaProperties (defined above)
       each entry translated into {"name":..., "value":...}
         where name is in form <PREFIX><PROPERTY_NAME>
         prefix is from .prefix
         property name with '.' replaced with '_' and in upper-case
         e.g.:
            prefix=PRODUCER_CONFIG_
            property-name=security.protocol
            result: PRODUCER_CONFIG_SECURITY_PROTOCOL
       merged with .sensitiveProperties where entries are in format:
         { "name": ...,
           "valueFrom": {
             "secretKeyRef": {
               "name": ...,
               "key": ...
             }
           }
         }
       where secretKeyRef.name is from .secretname
       overrides.* are merged with kafka.* accordingly.

       Resulting object folded in {"ret":...} for marshalling.
     */ -}}
{{- define "castle.kafkaPropertiesEnv" -}}
  {{- $ctx := . -}}
  {{- $kafkaProperties := get (fromYaml (include "castle.kafkaProperties" $ctx)) "ret" -}}
  {{- $env := list -}}
  {{- range $prop, $val := $kafkaProperties -}}
    {{- $env = append $env (dict
          "name" (print $ctx.prefix ($prop | upper | replace "." "_"))
          "value" $val
        ) -}}
  {{- end -}}
  {{- $sensitiveProperties := deepCopy $ctx.kafka.sensitiveProperties | mustMerge (($ctx.overrides).sensitiveProperties | default dict) -}}
  {{- range $prop, $val := $sensitiveProperties -}}
    {{- $env = append $env (dict
          "name" (print $ctx.prefix ($prop | upper | replace "." "_"))
          "valueFrom" (dict
            "secretKeyRef" (dict
              "name" $ctx.secretname
              "key" $prop
            )
          )
        ) -}}
  {{- end -}}
  {{- dict "ret" $env | toYaml }}
{{- end }}


{{- define "castle.kafkaPropertiesConfig" -}}
  {{- $ctx := . -}}
  {{- $kafkaProperties := get (fromYaml (include "castle.kafkaProperties" $ctx)) "ret" -}}
  {{- $sensitiveProperties := deepCopy $ctx.kafka.sensitiveProperties | mustMerge (($ctx.overrides).sensitiveProperties | default dict) -}}
  {{- range $prop, $val := $kafkaProperties -}}
  {{- printf "%s: '%s',\n" ($prop | replace "." "_") $val }}
  {{- end -}}
  {{- range $prop, $val := $sensitiveProperties -}}
  {{ printf "%s: '%s'," ($prop | replace "." "_") "from-env" }}
  {{- end -}}
{{- end }}

{{/*
Set custom CAs mount path
Usage:
{{ include "custom.ca.mountPath" $ }}
*/}}
{{- define "custom.ca.mountPath" -}}
{{ .Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}

{{/*
Manifest name
*/}}
{{- define "castle.manifestCode" -}}
{{- base $.Values.dgctlStorage.manifest | trimSuffix ".json" }}
{{- end }}
