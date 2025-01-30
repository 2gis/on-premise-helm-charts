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
{{- define "navi-vrp-solver.kafkaProperties" -}}
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
{{- define "navi-vrp-solver.kafkaPropertiesEnv" -}}
  {{- $ctx := . -}}
  {{- $kafkaProperties := get (fromYaml (include "navi-vrp-solver.kafkaProperties" $ctx)) "ret" -}}
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
