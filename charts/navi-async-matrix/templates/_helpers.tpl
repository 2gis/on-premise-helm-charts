{{- define "navi-async-matrix.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "navi-async-matrix.fullname" -}}
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

{{- define "navi-async-matrix.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "navi-async-matrix.selectorLabels" -}}
app.kubernetes.io/name: {{ include "navi-async-matrix.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "navi-async-matrix.labels" -}}
helm.sh/chart: {{ include "navi-async-matrix.chart" . }}
{{ include "navi-async-matrix.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "navi-async-matrix.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "navi-async-matrix.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "navi-async-matrix.dbDsnParams" -}}
{{- if and .Values.db.sslRootCert .Values.db.sslCert .Values.db.sslKey .Values.db.sslMode }}
{{- printf "?sslcert=/etc/2gis/secret/psql/client.crt&sslkey=/etc/2gis/secret/psql/client.key&sslrootcert=/etc/2gis/secret/psql/ca.crt&sslmode=%s"
               .Values.db.sslMode -}}
{{- end }}
{{- end }}


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
         .mountpoint

       File properties values (file contents) replaced with keys (file names).
       File names prepended with the supposed directory from .mountpoint.
       Returns {"ret": that-merged-dict}.
       Folding result in "ret" needed for marshalling.
     */ -}}
{{- define "navi-async-matrix.kafkaProperties" -}}
  {{- $ctx := . -}}
  {{- $kafkaProperties := dict -}}
  {{- range $key, $_ := $ctx.kafka.fileProperties -}}
    {{- $_ := set $kafkaProperties $key (printf "%s/%s" $ctx.mountpoint $key) -}}
  {{- end -}}
  {{- $kafkaProperties = mustMerge $kafkaProperties $ctx.kafka.properties -}}
  {{- dict "ret" $kafkaProperties | toYaml }}
{{- end }}

{{- /* Translate properties into `env` construction as in containers:

       Context:
         .kafka.properties
         .kafka.fileProperties
         .kafka.sensitiveProperties
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
       Resulting object folded in {"ret":...} for marshalling.
     */ -}}
{{- define "navi-async-matrix.kafkaPropertiesEnv" -}}
  {{- $ctx := . -}}
  {{- $kafkaProperties := get (fromYaml (include "navi-async-matrix.kafkaProperties" $ctx)) "ret" -}}
  {{- $env := list -}}
  {{- range $prop, $val := $kafkaProperties -}}
    {{- $env = append $env (dict
          "name" (print $ctx.prefix ($prop | upper | replace "." "_"))
          "value" $val
        ) -}}
  {{- end -}}
  {{- range $prop, $val := $ctx.kafka.sensitiveProperties -}}
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

{{- /* Encodes to "invalid" JSON representing comma separated list entries.

       Context:
         .ret - list to encode

       Example:
         .ret=[1, 2, 3]
         result: "1, 2, 3,"
     */ -}}
{{- define "navi-async-matrix.partialListToJson" -}}
  {{- range .ret }}
    {{- . | mustToPrettyJson }},
    {{- println }}
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

{{- /*
Name for psql intermediate volume for copy secrets and change permissions
*/ -}}

{{- define "navi-async-matrix.fullname-psql-raw" -}}
{{- printf "%s-psql-raw" (include "navi-async-matrix.fullname" .) -}}
{{- end }}

{{- /*
Name for psql secret and volume
*/ -}}

{{- define "navi-async-matrix.fullname-psql" -}}
{{- printf "%s-psql" (include "navi-async-matrix.fullname" .) -}}
{{- end }}
