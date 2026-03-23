{{- define "search-api-v8.sentry.vars.common" -}}
{{ if .Values.onpremise -}}
sentry-enabled: false
{{- else -}}
sentry-enabled: {{ .Values.sentry.enabled }}
{{- end }}
sentry-environment: {{ .Values.sentry.environment | quote }}
sentry-dc: {{ .Values.sentry.dc | quote }}
sentry-traces-sample-rate: {{ .Values.sentry.tracesSampleRate }}
sentry-database-path: {{ .Values.sentry.databasePath | quote }}
sentry-handler-path: {{ .Values.sentry.handlerPath | quote }}
{{- end -}}
