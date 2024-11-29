{{- define "keys.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "keys.api.name" -}}
{{ include "keys.name" . }}-api
{{- end }}

{{- define "keys.tasker.name" -}}
{{ include "keys.name" . }}-tasker
{{- end }}

{{- define "keys.dispatcher.name" -}}
{{ include "keys.name" . }}-dispatcher
{{- end }}

{{- define "keys.cleaner.name" -}}
{{ include "keys.name" . }}-cleaner
{{- end }}

{{- define "keys.counter.name" -}}
{{ include "keys.name" . }}-counter
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

{{- /*
Name for kafka main intermediate volume for copy secrets
*/ -}}

{{- define "keys.kafka-main-raw.name" -}}
{{- printf "%s-kafka-main-raw" (include "keys.name" .) -}}
{{- end }}

{{- /*
Name for kafka main secret and volume
*/ -}}

{{- define "keys.kafka-main.name" -}}
{{- printf "%s-kafka-main" (include "keys.name" .) -}}
{{- end }}

{{- /*
Name for kafka audit intermediate volume for copy secrets
*/ -}}

{{- define "keys.kafka-audit-raw.name" -}}
{{- printf "%s-kafka-audit-raw" (include "keys.name" .) -}}
{{- end }}

{{- /*
Name for kafka audit secret and volume
*/ -}}

{{- define "keys.kafka-audit.name" -}}
{{- printf "%s-kafka-audit" (include "keys.name" .) -}}
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

{{- define "keys.dispatcher.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-dispatcher
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "keys.dispatcher.labels" -}}
{{ include "keys.dispatcher.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "keys.cleaner.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-cleaner
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "keys.counter.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-counter
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "keys.counter.labels" -}}
{{ include "keys.counter.selectorLabels" . }}
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

{{- define "keys.env.featureFlags" -}}
- name: KEYS_FEATURE_FLAGS_AUDIT
  value: "{{ .Values.featureFlags.enableAudit }}"
- name: KEYS_FEATURE_FLAGS_PUBLIC_API_SIGN
  value: "{{ .Values.featureFlags.enablePublicAPISign }}"
{{- end }}

{{- define "keys.env.api" -}}
- name: KEYS_LOG_LEVEL
  value: "{{ .Values.api.logLevel }}"
{{- if .Values.featureFlags.enablePublicAPISign }}
- name: KEYS_SIGN_PRIVATE_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: signPrivateKey
{{- end }}
{{- end }}

{{- define "keys.env.import" -}}
- name: KEYS_LOG_LEVEL
  value: "{{ .Values.import.logLevel }}"
{{- end }}

{{- define "keys.env.migrate" -}}
- name: KEYS_LOG_LEVEL
  value: "{{ .Values.migrate.logLevel }}"
{{- end }}

{{- define "keys.env.tasker" -}}
- name: KEYS_LOG_LEVEL
  value: "{{ .Values.tasker.logLevel }}"
- name: KEYS_TASKER_DELAY
  value: "{{ .Values.tasker.delay }}"
{{- end }}

{{- define "keys.env.dispatcher" -}}
- name: KEYS_LOG_LEVEL
  value: "{{ .Values.dispatcher.logLevel }}"
- name: KEYS_AUDIT_EVENTS_SEND_INTERVAL
  value: "{{ .Values.dispatcher.auditEvents.sendInterval }}"
- name: KEYS_AUDIT_EVENTS_BATCH_MAX_SIZE
  value: "{{ .Values.dispatcher.auditEvents.batchMaxSize }}"
- name: KEYS_AUDIT_EVENTS_HOLD_DURATION
  value: "{{ .Values.dispatcher.auditEvents.holdDuration }}"
{{- end }}

{{- define "keys.env.cleaner" -}}
- name: KEYS_LOG_LEVEL
  value: "{{ .Values.dispatcher.cleaner.logLevel }}"
- name: KEYS_AUDIT_EVENTS_RETENTION_DURATION
  value: "{{ .Values.dispatcher.cleaner.auditEvents.retentionDuration }}"
{{- end -}}

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
{{- end -}}

{{- define "keys.env.db.deploys" -}}
{{- include "keys.env.db" . }}
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
{{- end -}}

{{- define "keys.env.db.jobs" -}}
{{- include "keys.env.db" . }}
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
{{- end -}}

{{- define "keys.env.redis" -}}
{{- if .Values.redis.useExternalRedis -}}
- name: KEYS_REDIS_HOST
  value: "{{ .Values.redis.host }}"
- name: KEYS_REDIS_DB
  value: "{{ .Values.redis.db }}"
{{- else -}}
- name: KEYS_REDIS_HOST
  value: "{{ include "keys.redis.name" . }}"
{{- end }}
- name: KEYS_REDIS_PORT
  value: "{{ .Values.redis.port }}"
{{- if .Values.redis.password }}
- name: KEYS_REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: redisPassword
{{- end -}}
{{- end -}}

{{- define "keys.env.auth" -}}
{{- if .Values.api.adminUsers -}}
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

{{- define "keys.env.counter" -}}
- name: KEYS_LOG_LEVEL
  value: "{{ .Values.counter.logLevel }}"
- name: KEYS_COUNTER_BUFFER_SIZE
  value: "{{ .Values.counter.buffer.size }}"
- name: KEYS_COUNTER_BUFFER_DELAY
  value: "{{ .Values.counter.buffer.delay }}"
- name: KEYS_COUNTER_PRELOADER_REFRESH_TICK
  value: "{{ .Values.counter.preloader.refreshTick }}"
- name: KEYS_COUNTER_UPDATE_STATUS_QUERY_TIMEOUT
  value: "{{ .Values.counter.updateStatusQueryTimeout }}"
- name: KEYS_KAFKA_MAIN_BROKERS
  value: "{{ .Values.kafka.main.brokers }}"
- name: KEYS_KAFKA_MAIN_CLIENT_PREFIX
  value: "{{ .Values.kafka.main.clientPrefix }}"
- name: KEYS_KAFKA_MAIN_CLIENT_ID
  value: "{{ .Values.kafka.main.clientId }}"
- name: KEYS_KAFKA_MAIN_STATS_TOPIC
  value: "{{ .Values.kafka.main.topics.stats }}"
- name: KEYS_KAFKA_MAIN_USERNAME
  value: "{{ .Values.kafka.main.username }}"
{{- if .Values.kafka.main.password }}
- name: KEYS_KAFKA_MAIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.kafka-main.name" . }}
      key: password
{{- end }}
- name: KEYS_REDIS_RETRIES
  value: "{{ .Values.counter.redis.retries }}"
- name: KEYS_REDIS_MIN_RETRY_BACKOFF
  value: "{{ .Values.counter.redis.minRetryBackoff }}"
- name: KEYS_REDIS_MAX_RETRY_BACKOFF
  value: "{{ .Values.counter.redis.maxRetryBackoff }}"
- name: KEYS_KAFKA_MAIN_SECURITY_PROTOCOL
  value: "{{ .Values.kafka.main.securityProtocol }}"
- name: KEYS_KAFKA_MAIN_SASL_MECHANISM
  value: "{{ .Values.kafka.main.SASLMechanism }}"
{{- $sslEnabled := include "kafka.ssl.enabled" (dict "global" $ "variation" "main") }}
{{- if $sslEnabled }}
- name: KEYS_KAFKA_MAIN_TLS_SKIP_SERVER_CERTIFICATE_VERIFY
  value: "{{ .Values.kafka.main.tls.skipServerCertificateVerify }}"
- name: KEYS_KAFKA_MAIN_TLS_CLIENT_CERTIFICATE_PATH
  value: "/etc/2gis/secret/kafka-main/client.crt"
- name: KEYS_KAFKA_MAIN_TLS_CLIENT_KEY_PATH
  value: "/etc/2gis/secret/kafka-main/client.key"
- name: KEYS_KAFKA_MAIN_TLS_CA_CERT_PATH
  value: "/etc/2gis/secret/kafka-main/ca.crt"
{{- end }}
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
- name: KEYS_S3_REGION
  value: "{{ .Values.dgctlStorage.region }}"
- name: KEYS_S3_SECURE
  value: "{{ .Values.dgctlStorage.secure }}"
- name: KEYS_S3_VERIFY_SSL
  value: "{{ .Values.dgctlStorage.verifySsl }}"
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

{{- define "keys.env.kafka.audit" -}}
- name: KEYS_KAFKA_AUDIT_BROKERS
  value: "{{ .Values.kafka.audit.bootstrapServers }}"
- name: KEYS_KAFKA_AUDIT_USERNAME
  value: "{{ .Values.kafka.audit.username }}"
{{- if .Values.kafka.audit.password }}
- name: KEYS_KAFKA_AUDIT_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.kafka-audit.name" . }}
      key: password
{{- end }}
- name: KEYS_KAFKA_AUDIT_SECURITY_PROTOCOL
  value: "{{ .Values.kafka.audit.securityProtocol }}"
- name: KEYS_KAFKA_AUDIT_SASL_MECHANISM
  value: "{{ .Values.kafka.audit.SASLMechanism }}"
{{- $sslEnabled := include "kafka.ssl.enabled" (dict "global" $ "variation" "audit") }}
{{- if $sslEnabled }}
- name: KEYS_KAFKA_AUDIT_TLS_SKIP_SERVER_CERTIFICATE_VERIFY
  value: "{{ .Values.kafka.audit.tls.skipServerCertificateVerify }}"
- name: KEYS_KAFKA_AUDIT_TLS_CLIENT_CERTIFICATE_PATH
  value: "/etc/2gis/secret/kafka-audit/client.crt"
- name: KEYS_KAFKA_AUDIT_TLS_CLIENT_KEY_PATH
  value: "/etc/2gis/secret/kafka-audit/client.key"
- name: KEYS_KAFKA_AUDIT_TLS_CA_CERT_PATH
  value: "/etc/2gis/secret/kafka-audit/ca.crt"
{{- end }}
- name: KEYS_KAFKA_AUDIT_TOPIC
  value: "{{ .Values.kafka.audit.topic }}"
- name: KEYS_KAFKA_AUDIT_PRODUCE_RETRY_COUNT
  value: "{{ .Values.kafka.audit.produce.retryCount }}"
- name: KEYS_KAFKA_AUDIT_PRODUCE_IDEMPOTENT_WRITE
  value: "{{ .Values.kafka.audit.produce.idempotentWrite }}"
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

{{- define "keys.env.custom.ca.path" -}}
- name: SSL_CERT_DIR
  value: {{ include "keys.custom.ca.mountPath" . }}
{{- end }}

{{- define "keys.custom.ca.mountPath" -}}
{{ .Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}

{{- define "keys.custom.ca.volumeMounts" -}}
- name: custom-ca
  mountPath: {{ include "keys.custom.ca.mountPath" . }}/custom-ca.crt
  subPath: custom-ca.crt
  readOnly: true
{{- end -}}

{{- define "keys.custom.ca.jobs.volumes" -}}
- name: custom-ca
  configMap:
    name: {{ include "keys.configmap.jobs.name" . }}
{{- end -}}

{{- define "keys.custom.ca.deploys.volumes" -}}
- name: custom-ca
  configMap:
    name: {{ include "keys.configmap.deploys.name" . }}
{{- end -}}

{{- define "keys.configmap.jobs.name" -}}
{{ include "keys.name" . }}-configmap-jobs
{{- end -}}

{{- define "keys.configmap.deploys.name" -}}
{{ include "keys.name" . }}-configmap-deploys
{{- end -}}

{{- define "kafka.ssl.enabled" }}
{{- $global := required "Global cursor is required in dict!" (get . "global") -}}
{{- $variation := required "Kafka variant is required in dict!" (get . "variation") -}}
{{- $securityProtocol := index $global.Values.kafka $variation "securityProtocol" -}}
{{- $isEnabled := or (eq $securityProtocol "SSL") (eq $securityProtocol "SASL_SSL") -}}
{{/* Converting bool to "thruthy" string cause "include" can only return string. */}}
{{- ternary "true" "" $isEnabled }}
{{- end -}}
