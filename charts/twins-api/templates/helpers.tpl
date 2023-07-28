{{- define "twins.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "twins.api.name" -}}
{{ include "twins.name" . }}-api
{{- end }}

{{- define "twins.migrate.name" -}}
{{ include "twins.name" . }}-migrate
{{- end }}

{{- define "twins.secret.deploys.name" -}}
{{ include "twins.name" . }}-secret-deploys
{{- end }}

{{- define "twins.secret.jobs.name" -}}
{{ include "twins.name" . }}-secret-jobs
{{- end }}

{{- define "twins.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "twins.labels" -}}
{{ include "twins.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "twins.api.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-api
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "twins.api.labels" -}}
{{ include "twins.api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "keys.migrate.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-migrate
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "twins.env.db" -}}
- name: TWINS_DB_RO_HOST
  value: "{{ required "A valid .Values.postgres.ro.host required" .Values.postgres.ro.host }}"
- name: TWINS_DB_RO_PORT
  value: "{{ .Values.postgres.ro.port }}"
- name: TWINS_DB_RO_NAME
  value: "{{ required "A valid .Values.postgres.ro.name required" .Values.postgres.ro.name }}"
- name: TWINS_DB_RO_SCHEMA
  value: "{{ .Values.postgres.ro.schema }}"
- name: TWINS_DB_RO_CONNECTION_TIMEOUT
  value: "{{ .Values.postgres.ro.timeout }}"
- name: TWINS_DB_RO_USERNAME
  value: "{{ required "A valid .Values.postgres.ro.username required" .Values.postgres.ro.username }}"
- name: TWINS_DB_RW_HOST
  value: "{{ required "A valid .Values.postgres.rw.host required" .Values.postgres.rw.host }}"
- name: TWINS_DB_RW_PORT
  value: "{{ .Values.postgres.rw.port }}"
- name: TWINS_DB_RW_SCHEMA
  value: "{{ .Values.postgres.rw.schema }}"
- name: TWINS_DB_RW_CONNECTION_TIMEOUT
  value: "{{ .Values.postgres.rw.timeout }}"
- name: TWINS_DB_RW_NAME
  value: "{{ required "A valid .Values.postgres.rw.name required" .Values.postgres.rw.name }}"
- name: TWINS_DB_RW_USERNAME
  value: "{{ required "A valid .Values.postgres.rw.username required" .Values.postgres.rw.username }}"
{{- end}}

{{- define "twins.env.db.deploys" -}}
{{ include "twins.env.db" . }}
- name: TWINS_DB_RO_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "twins.secret.deploys.name" . }}
      key: dbROPassword
- name: TWINS_DB_RW_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "twins.secret.deploys.name" . }}
      key: dbRWPassword
{{- end }}

{{- define "twins.env.db.jobs" -}}
{{ include "twins.env.db" . }}
- name: TWINS_DB_RO_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "twins.secret.jobs.name" . }}
      key: dbROPassword
- name: TWINS_DB_RW_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "twins.secret.jobs.name" . }}
      key: dbRWPassword
{{- end }}

{{- define "twins.env.api"}}
{{ include "twins.env.db.deploys" . }}
- name: TWINS_AUTH_ENDPOINT
  value: "{{ required "A valid .Values.auth.endpoint required" .Values.auth.endpoint }}"
- name: TWINS_AUTH_SERVICE_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "twins.secret.deploys.name" . }}
      key: authServiceKey
- name: TWINS_AUTH_CLIENT_TIMEOUT
  value: "{{ .Values.auth.clientTimeout }}"
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
