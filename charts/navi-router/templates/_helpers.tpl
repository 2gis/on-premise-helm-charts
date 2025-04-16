{{/*
Renders a value or file that contains rules.
Usage:
{{ include "rules.renderRules" }}
*/}}
{{- define "rules.renderRules" -}}
    {{- $rules_file_content := .Files.Get "rules.conf" }}
    {{- if .Values.rules -}}
        {{- .Values.rules | toPrettyJson | nindent 6 }}
    {{- else if $rules_file_content  }}
        {{- .Files.Get "rules.conf" |  nindent 6}}
    {{- else }}
        {{- fail "Rules value is not set or rules file is empty" }}
    {{- end -}}
{{- end -}}

{{/*
Check for deprecated values
*/}}
{{- define "check.values" -}}
{{/* deprecations */}}
{{- if .Values.router.keyManagementService -}}{{ fail ".Values.router.keyManagementService renamed to .Values.keys" }}{{- end }}
{{- if .Values.keys.host -}}{{ fail ".Values.router.keys.host renamed to .Values.keys.url" }}{{- end }}
{{- if .Values.router.castleHost -}}{{ fail ".Values.router.castleHost renamed to .Values.router.castleUrl" }}{{- end }}
{{/* consistency checks */}}
{{- if and (.Values.requestsSignCheck).keys (not (.Values.requestsSignCheck).salt) }}
    {{- fail "`requestsSignCheck.keys` requires `requestsSignCheck.salt`" }}
{{- end }}
{{- if and  (.Values.requestsSignCheck).enabledKeys (not (.Values.requestsSignCheck).hashSalt) }}
    {{- fail "`requestsSignCheck.enabledKeys` requires `requestsSignCheck.hashSalt`" }}
{{- end }}
{{- end }}{{/* check.values */}}
