{{- define "pro.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "pro.ui.name" -}}
{{ include "pro.name" . }}
{{- end }}

{{- define "pro.ui.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "pro.ui.labels" -}}
{{ include "pro.ui.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "pro.ui.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{- define "pro.ui.styles-importer.name" -}}
{{- $name := default .Values.stylesImporter.name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "pro.ui.service.annotations" -}}
{{- if .Values.ui.service.annotations }}
{{- include "pro.ui.tplvalues.render" (dict "value" .Values.ui.service.annotations "context" . ) }}
{{ end }}
{{- end -}}

{{- define "pro.ui.styles-importer.helm-hooks" -}}
"helm.sh/hook": pre-install,pre-upgrade
"helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
{{- end -}}
