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
- name: KEYS_TASKER_DELAY
  value: "{{ .Values.tasker.delay }}"
{{- end }}

{{- define "keys.env.db" -}}
- name: KEYS_DB_RO_HOST
  value: "{{ required "A valid .Values.postgres.ro.host required" .Values.postgres.ro.host }}"
- name: KEYS_DB_RO_PORT
  value: "{{ .Values.postgres.ro.port }}"
- name: KEYS_DB_RO_NAME
  value: "{{ required "A valid .Values.postgres.ro.name required" .Values.postgres.ro.name }}"
- name: KEYS_DB_RO_SCHEMA
  value: "{{ .Values.postgres.ro.schema }}"
- name: KEYS_DB_RO_CONNECTION_TIMEOUT
  value: "{{ .Values.postgres.ro.timeout }}"
- name: KEYS_DB_RO_USERNAME
  value: "{{ required "A valid .Values.postgres.ro.username required" .Values.postgres.ro.username }}"
- name: KEYS_DB_RW_HOST
  value: "{{ required "A valid .Values.postgres.rw.host required" .Values.postgres.rw.host }}"
- name: KEYS_DB_RW_PORT
  value: "{{ .Values.postgres.rw.port }}"
- name: KEYS_DB_RW_CONNECTION_TIMEOUT
  value: "{{ .Values.postgres.rw.timeout }}"
- name: KEYS_DB_RW_NAME
  value: "{{ required "A valid .Values.postgres.rw.name required" .Values.postgres.rw.name }}"
- name: KEYS_DB_RW_SCHEMA
  value: "{{ .Values.postgres.rw.schema }}"
- name: KEYS_DB_RW_USERNAME
  value: "{{ required "A valid .Values.postgres.rw.username required" .Values.postgres.rw.username }}"
{{- end }}

{{- define "keys.env.db.deploys" -}}
{{ include "keys.env.db" . }}
- name: KEYS_DB_RO_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: dbROPassword
- name: KEYS_DB_RW_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: dbRWPassword
{{- end }}

{{- define "keys.env.db.jobs" -}}
{{ include "keys.env.db" . }}
- name: KEYS_DB_RO_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.jobs.name" . }}
      key: dbROPassword
- name: KEYS_DB_RW_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.jobs.name" . }}
      key: dbRWPassword
{{- end }}

{{- define "keys.env.redis" -}}
{{- if .Values.redis.useExternalRedis }}
- name: KEYS_REDIS_HOST
  value: "{{ .Values.redis.host }}"
- name: KEYS_REDIS_DB
  value: "{{ .Values.redis.db }}"
{{- else  }}
- name: KEYS_REDIS_HOST
  value: "{{ include "keys.redis.name" . }}"
{{- end  }}
- name: KEYS_REDIS_PORT
  value: "{{ .Values.redis.port }}"
{{- if .Values.redis.password }}
- name: KEYS_REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: redisPassword
{{- end }}
{{- end }}

{{- define "keys.env.auth" -}}
{{- if .Values.api.adminUsers }}
- name: KEYS_ADMIN_USERS
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: apiAdminUsers
{{- end }}
- name: KEYS_ADMIN_SESSION_TTL
  value: "{{ .Values.api.adminSessionTTL }}"
- name: KEYS_LDAP_HOST
  value: "{{ .Values.ldap.host }}"
- name: KEYS_LDAP_PORT
  value: "{{ .Values.ldap.port }}"
- name: KEYS_LDAP_USE_STARTTLS
  value: "{{ .Values.ldap.useStartTLS }}"
- name: KEYS_LDAP_USE_LDAPS
  value: "{{ .Values.ldap.useLDAPS }}"
- name: KEYS_LDAP_SKIP_SERVER_CERTIFICATE_VERIFY
  value: "{{ .Values.ldap.skipServerCertificateVerify }}"
- name: KEYS_LDAP_SERVER_NAME
  value: "{{ .Values.ldap.serverName }}"
- name: KEYS_LDAP_CLIENT_CERTIFICATE_PATH
  value: "{{ .Values.ldap.clientCertificatePath }}"
- name: KEYS_LDAP_CLIENT_KEY_PATH
  value: "{{ .Values.ldap.clientKeyPath }}"
- name: KEYS_LDAP_ROOT_CERTIFICATE_AUTHORITIES_PATH
  value: "{{ .Values.ldap.rootCertificateAuthoritiesPath }}"
- name: KEYS_LDAP_BIND_DN
  value: "{{ .Values.ldap.bind.dn }}"
- name: KEYS_LDAP_BIND_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: ldapBindPassword
- name: KEYS_LDAP_SEARCH_BASE_DN
  value: "{{ .Values.ldap.search.baseDN }}"
- name: KEYS_LDAP_SEARCH_FILTER
  value: "{{ .Values.ldap.search.filter }}"
{{- end }}

{{- define "keys.env.admin" -}}
- name: APP_HOST
  value: "{{ .Values.admin.host }}"
- name: API_URL
{{- if .Values.admin.apiOverride }}
  value: "{{ .Values.admin.apiOverride }}"
{{- else }}
  value: "http://{{ include "keys.api.name" . }}"
{{- end }}
- name: BADGE_TITLE
  value: "{{ .Values.admin.badge.title }}"
- name: BADGE_TITLE_COLOR
  value: "{{ .Values.admin.badge.titleColor }}"
- name: BADGE_BACKGROUND_COLOR
  value: "{{ .Values.admin.badge.backgroundColor }}"
{{- end }}

{{- define "keys.env.predef" -}}
{{ range $service, $key := .Values.predefined.service.keys }}
- name: KEYS_PREDEF_SERVICE_KEY_{{ $service | upper }}
  value: {{ $key }}
{{ end }}
{{ range $service, $key := .Values.predefined.service.aliases }}
- name: KEYS_PREDEF_SERVICE_ALIAS_{{ $service | upper }}
  value: {{ $key }}
{{ end }}
{{- end }}

{{- define "keys.env.dgctlStorage" -}}
- name: KEYS_S3_ENDPOINT
  value: "{{ .Values.dgctlStorage.host }}"
- name: KEYS_S3_BUCKET
  value: "{{ .Values.dgctlStorage.bucket }}"
- name: KEYS_S3_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.jobs.name" . }}
      key: dgctlStorageAccessKey
- name: KEYS_S3_SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.jobs.name" . }}
      key: dgctlStorageSecretKey
- name: KEYS_MANIFEST_PATH
  value: "{{ required "A valid .Values.dgctlStorage.manifest entry required" .Values.dgctlStorage.manifest }}"
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
