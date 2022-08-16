{{- define "2gis-pro.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "2gis-pro.ui.name" -}}
{{ include "2gis-pro.name" . }}-ui
{{- end }}

{{- define "2gis-pro.ui.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-ui
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "2gis-pro.ui.labels" -}}
{{ include "2gis-pro.ui.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "2gis-pro.env.ui" -}}
- name: URBI_API_URL
  value: "{{ .Values.ui.URBI_API_URL }}"
- name: MAPGL_HOST
  value: "{{ .Values.ui.MAPGL_HOST }}"
- name: MAPGL_KEY
  value: "{{ .Values.ui.MAPGL_KEY }}"
- name: LOG_LEVEL
  value: "{{ .Values.ui.LOG_LEVEL }}"
- name: NODE_ENV
  value: "{{ .Values.ui.NODE_ENV }}"
{{- end }}
