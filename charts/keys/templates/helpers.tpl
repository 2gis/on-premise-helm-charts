{{- define "keys.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "keys.api.name" -}}
{{ include "keys.name" . }}-api
{{- end }}

{{- define "keys.tasker.name" -}}
{{ include "keys.name" . }}-tasker
{{- end }}

{{- define "keys.migrate.name" -}}
{{ include "keys.name" . }}-migrate
{{- end }}

{{- define "keys.import.name" -}}
{{ include "keys.name" . }}-import
{{- end }}

{{- define "keys.redis.name" -}}
{{ include "keys.name" . }}-redis
{{- end }}

{{- define "keys.admin.name" -}}
{{ include "keys.name" . }}-admin
{{- end }}

{{- define "keys.secret.deploys.name" -}}
{{ include "keys.name" . }}-deploys
{{- end }}

{{- define "keys.secret.jobs.name" -}}
{{ include "keys.name" . }}-jobs
{{- end }}

{{- define "keys.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "keys.labels" -}}
{{ include "keys.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "keys.api.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-api
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "keys.api.labels" -}}
{{ include "keys.api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "keys.migrate.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-migrate
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "keys.redis.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-redis
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "keys.redis.labels" -}}
{{ include "keys.redis.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "keys.tasker.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-tasker
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "keys.tasker.labels" -}}
{{ include "keys.tasker.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "keys.import.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-import
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "keys.admin.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-admin
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "keys.admin.labels" -}}
{{ include "keys.admin.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}


{{- define "keys.env.tasker" -}}
- name: ZUUL_TASKER_DELAY
  value: "{{ .Values.tasker.delay }}"
{{- end }}

{{- define "keys.env.db" -}}
- name: ZUUL_DB_RO_HOST
  value: "{{ .Values.db.ro.host }}"
- name: ZUUL_DB_RO_PORT
  value: "{{ .Values.db.ro.port }}"
- name: ZUUL_DB_RO_NAME
  value: "{{ .Values.db.ro.name }}"
- name: ZUUL_DB_RO_USERNAME
  value: "{{ .Values.db.ro.username }}"
- name: ZUUL_DB_RW_HOST
  value: "{{ .Values.db.rw.host }}"
- name: ZUUL_DB_RW_PORT
  value: "{{ .Values.db.rw.port }}"
- name: ZUUL_DB_RW_NAME
  value: "{{ .Values.db.rw.name }}"
- name: ZUUL_DB_RW_USERNAME
  value: "{{ .Values.db.rw.username }}"
{{- end }}

{{- define "keys.env.db.deploys" -}}
{{ include "keys.env.db" . }}
- name: ZUUL_DB_RO_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: dbROPassword
- name: ZUUL_DB_RW_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: dbRWPassword
{{- end }}

{{- define "keys.env.db.jobs" -}}
{{ include "keys.env.db" . }}
- name: ZUUL_DB_RO_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.jobs.name" . }}
      key: dbROPassword
- name: ZUUL_DB_RW_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.jobs.name" . }}
      key: dbRWPassword
{{- end }}

{{- define "keys.env.redis" -}}
{{- if .Values.redis.useExternalRedis }}
- name: ZUUL_REDIS_HOST
  value: "{{ include "keys.redis.host" . }}"
- name: ZUUL_REDIS_DB
  value: "{{ include "keys.redis.db" . }}"
{{- else  }}
- name: ZUUL_REDIS_HOST
  value: "{{ include "keys.redis.name" . }}"
{{- end  }}
- name: ZUUL_REDIS_PORT
  value: "{{ .Values.redis.port }}"
{{- if .Values.redis.password }}
- name: ZUUL_REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: redisPassword
{{- end }}
{{- end }}

{{- define "keys.env.auth" -}}
{{- if .Values.api.adminUsers }}
- name: ZUUL_ADMIN_USERS
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: apiAdminUsers
{{- end }}
- name: ZUUL_LDAP_HOST
  value: "{{ .Values.ldap.host }}"
- name: ZUUL_LDAP_PORT
  value: "{{ .Values.ldap.port }}"
- name: ZUUL_LDAP_USE_STARTTLS
  value: "{{ .Values.ldap.useStartTLS }}"
- name: ZUUL_LDAP_USE_LDAPS
  value: "{{ .Values.ldap.useLDAPS }}"
- name: ZUUL_LDAP_SKIP_SERVER_CERTIFICATE_VERIFY
  value: "{{ .Values.ldap.skipServerCertificateVerify }}"
- name: ZUUL_LDAP_SERVER_NAME
  value: "{{ .Values.ldap.serverName }}"
- name: ZUUL_LDAP_CLIENT_CERTIFICATE_PATH
  value: "{{ .Values.ldap.clientCertificatePath }}"
- name: ZUUL_LDAP_CLIENT_KEY_PATH
  value: "{{ .Values.ldap.clientKeyPath }}"
- name: ZUUL_LDAP_ROOT_CERTIFICATE_AUTHORITIES_PATH
  value: "{{ .Values.ldap.rootCertificateAuthoritiesPath }}"
- name: ZUUL_LDAP_BIND_DN
  value: "{{ .Values.ldap.bind.dn }}"
- name: ZUUL_LDAP_BIND_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: ldapBindPassword
- name: ZUUL_LDAP_SEARCH_BASE_DN
  value: "{{ .Values.ldap.search.baseDN }}"
- name: ZUUL_LDAP_SEARCH_FILTER
  value: "{{ .Values.ldap.search.filter }}"
{{- end }}

{{- define "keys.env.admin" -}}
- name: APP_HOST
  value: "{{ .Values.admin.appHost }}"
- name: API_URL
  value: "{{ .Values.admin.apiUrl }}"
{{- end }}
