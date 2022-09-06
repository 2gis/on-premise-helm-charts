{{- define "pro.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "pro.ui.name" -}}
{{ include "pro.name" . }}-ui
{{- end }}

{{- define "pro.ui.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-ui
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "pro.ui.labels" -}}
{{ include "pro.ui.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "pro.env.ui" -}}
- name: URBI_API_URL
  value: "{{ .Values.ui.api.host }}"
- name: MAPGL_HOST
  value: "{{ .Values.ui.mapgl.host }}"
- name: MAPGL_KEY
  value: "{{ .Values.ui.mapgl.key }}"
- name: LOG_LEVEL
  value: "{{ .Values.ui.logLevel }}"
- name: IS_ON_PREM
  value: "{{ .Values.ui.isOnPremise }}"
{{- end }}
