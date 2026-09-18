{{- define "stat-receiver-api.name" -}}
{{- printf "%s-api" .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "stat-receiver-streams.name" -}}
{{- printf "%s-streams" .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "stat-receiver-api.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ printf "%s-api" .Release.Name }}
{{- end }}

{{- define "stat-receiver-api.labels" -}}
{{ include "stat-receiver-api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "stat-receiver-streams.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ printf "%s-streams" .Release.Name }}
{{- end }}

{{- define "stat-receiver-streams.labels" -}}
{{ include "stat-receiver-streams.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "stat-receiver-secret.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ printf "%s-secret" .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "stat-receiver-secret.checksum" -}}
{{- $data := dict }}
{{- if .Values.kafka.truststore.enabled }}
{{- $data = set $data (printf "truststore.%s" .Values.kafka.truststore.storeFieldName) .Values.kafka.truststore.storeData }}
{{- $data = set $data (printf "truststore.%s" .Values.kafka.truststore.storePasswordFieldName) (.Values.kafka.truststore.storePassword | b64enc) }}
{{- end }}
{{- if .Values.kafka.keystore.enabled }}
{{- $data = set $data (printf "keystore.%s" .Values.kafka.keystore.storeFieldName) .Values.kafka.keystore.storeData }}
{{- $data = set $data (printf "keystore.%s" .Values.kafka.keystore.storePasswordFieldName) (.Values.kafka.keystore.storePassword | b64enc) }}
{{- end }}
{{- if and .Values.kafka.sasl.enabled (eq (.Values.kafka.sasl.secretName | len) 0) }}
{{- $jaas := printf "%s required username=\"%s\" password=\"%s\";" .Values.kafka.sasl.jaasLoginModule (required "A valid .Values.kafka.sasl.username entry required" .Values.kafka.sasl.username) (required "A valid .Values.kafka.sasl.password entry required" .Values.kafka.sasl.password) }}
{{- $data = set $data (printf "sasl.%s" .Values.kafka.sasl.jaasFieldName) ($jaas | b64enc) }}
{{- end }}
{{- $data | toYaml | sha256sum }}
{{- end }}
