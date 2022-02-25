{{- define "catalog.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}


{{- define "catalog.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "catalog.labels" -}}
{{ include "catalog.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}


{{- define "catalog.env.db" -}}
- name: CATALOG_DB_BRANCH_URL
  value: "jdbc:postgresql://{{ .Values.db.host }}:{{ .Values.db.port }}/{{ .Values.db.name }}"
- name: CATALOG_DB_BRANCH_LOGIN
  value: "{{ .Values.db.username }}"
- name: CATALOG_DB_BRANCH_PASS
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.name" . }}
      key: dbPassword

- name: CATALOG_DB_REGION_URL
  value: "jdbc:postgresql://{{ .Values.db.host }}:{{ .Values.db.port }}/{{ .Values.db.name }}"
- name: CATALOG_DB_REGION_LOGIN
  value: "{{ .Values.db.username }}"
- name: CATALOG_DB_REGION_PASS
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.name" . }}
      key: dbPassword

- name: CATALOG_DB_API_KEY_URL
  value: "jdbc:postgresql://{{ .Values.db.host }}:{{ .Values.db.port }}/{{ .Values.db.name }}"
- name: CATALOG_DB_API_KEY_LOGIN
  value: "{{ .Values.db.username }}"
- name: CATALOG_DB_API_KEY_PASS
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.name" . }}
      key: dbPassword

- name: CATALOG_DB_RUBRIC_URL
  value: "jdbc:postgresql://{{ .Values.db.host }}:{{ .Values.db.port }}/{{ .Values.db.name }}"
- name: CATALOG_DB_RUBRIC_LOGIN
  value: "{{ .Values.db.username }}"
- name: CATALOG_DB_RUBRIC_PASS
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.name" . }}
      key: dbPassword

- name: CATALOG_DB_ADDITIONAL_ATTRIBUTE_URL
  value: "jdbc:postgresql://{{ .Values.db.host }}:{{ .Values.db.port }}/{{ .Values.db.name }}"
- name: CATALOG_DB_ADDITIONAL_ATTRIBUTE_LOGIN
  value: "{{ .Values.db.username }}"
- name: CATALOG_DB_ADDITIONAL_ATTRIBUTE_PASS
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.name" . }}
      key: dbPassword
{{- end }}

{{- define "catalog.env.search" -}}
- name: CATALOG_SAPPHIRE_URL
  value: "{{ .Values.search.url }}"
{{- end }}
