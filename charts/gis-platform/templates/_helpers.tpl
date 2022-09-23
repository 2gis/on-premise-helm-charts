{{- define "gis-platform.secret" -}}
{{- if .Values.secretNameOverride -}}
{{- .Values.secretNameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- if contains .Chart.Name .Release.Name -}}
{{- .Release.Name }}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Chart.Name -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "gis-platform-portal.name" -}}
{{- default "portal" .Values.portal.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "gis-platform-portal.fullname" -}}
{{- if .Values.portal.fullnameOverride -}}
{{- .Values.portal.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "portal" .Values.portal.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "gis-platform-portal.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "gis-platform-portal.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gis-platform-portal.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "gis-platform-portal.labels" -}}
helm.sh/chart: {{ include "gis-platform-portal.chart" . }}
{{ include "gis-platform-portal.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "gis-platform-spcore.name" -}}
{{- default "spcore" .Values.spcore.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "gis-platform-spcore.fullname" -}}
{{- if .Values.spcore.fullnameOverride -}}
{{- .Values.spcore.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "spcore" .Values.spcore.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "gis-platform-spcore.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "gis-platform-spcore.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gis-platform-spcore.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "gis-platform-spcore.labels" -}}
helm.sh/chart: {{ include "gis-platform-spcore.chart" . }}
{{ include "gis-platform-spcore.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "gis-platform.zookeeper_connection_string" -}}
{{- printf "%s-zookeeper.%s.svc:2181" .Release.Name .Release.Namespace }}
{{- end -}}

{{- define "gis-platform.spcore.headless_service" -}}
{{ include "gis-platform-spcore.fullname" . }}-headless
{{- end -}}

{{- define "gis-platform.nginx_log_format" }}
'{'
     '"@timestamp":"$time_iso8601"'
    ',"remote_addr":"$remote_addr"'
    ',"http_status":"$status"'
    ',"request_uri":"$request_uri"'
    ',"request_method":"$request_method"'
    ',"bytes_sent":"$bytes_sent"'
    ',"request_time":"$request_time"'
    ',"request_completion":"$request_completion"'
    ',"cache_status":"$upstream_cache_status"'
    ',"user_agent":"$http_user_agent"'
    ',"referer":"$http_referer"'
    ',"x-forwarded-for":"$http_x_forwarded_for"'
    ',"upstream_addr":"$upstream_addr"'
    ',"upstream_connect_time":"$upstream_connect_time"'
    ',"upstream_response_time":"$upstream_response_time"'
    ',"upstream_response_length":"$upstream_response_length"'
'}';
{{- end }}

{{- define "gis-platform-spcore.run_args" -}}
    {{- $reset     := default false .Values.spcore.reset_cluster   -}}
    {{- $update_db := default true  .Values.spcore.update_db       -}}
    {{- $continue  := default true  .Values.spcore.continue        -}}
    {{- $sync      := default false .Values.spcore.sync_parameters -}}
    {{-
        printf "\"-%s%s%s%s\""
            (ternary "r" "" $reset)
            (ternary "u" "" $update_db)
            (ternary "c" "" $continue)
            (ternary "s" "" $sync)
    -}}
{{- end -}}
