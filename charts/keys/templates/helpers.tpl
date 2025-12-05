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
  value: {{ .Values.featureFlags.enableAudit | quote }}
- name: KEYS_FEATURE_FLAGS_AUDIT_KAFKA
  value: {{ .Values.featureFlags.enableAuditKafka | quote }}
- name: KEYS_FEATURE_FLAGS_PUBLIC_API_SIGN
  value: {{ .Values.featureFlags.enablePublicAPISign | quote }}
- name: KEYS_FEATURE_FLAGS_SINGLE_PARTNER_MODE
  value: {{ .Values.api.oidc.enableSinglePartnerMode | quote }}
- name: KEYS_FEATURE_FLAGS_EXTERNAL_OIDC
  value: {{ .Values.api.oidc.enableExternalProvider | quote }}
- name: KEYS_FEATURE_FLAGS_OIDC
  value: {{ .Values.api.oidc.enabled | quote }}
- name: KEYS_FEATURE_FLAGS_STAT_API
  value: {{ .Values.statApi.enabled | quote }}
- name: KEYS_FEATURE_FLAGS_REDIS
  value: {{ .Values.redis.enabled | quote }}
- name: KEYS_FEATURE_FLAGS_STAT_REDIS
  {{- if (and .Values.featureFlags.enableStatRedis (not .Values.redis.enabled)) }}
    {{- fail "featureFlags.enableStatRedis requires redis.enabled to be true" }}
  {{- end }}
  value: {{ .Values.featureFlags.enableStatRedis | quote }}
- name: KEYS_FEATURE_FLAGS_SINGLE_VISIBILITY_MODE
  value: "true"
{{- end }}

{{- define "keys.env.api" -}}
- name: KEYS_LOG_LEVEL
  value: {{ .Values.api.logLevel | quote }}
{{- if .Values.featureFlags.enablePublicAPISign }}
- name: KEYS_SIGN_PRIVATE_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: signPrivateKey
{{- end }}
{{- if .Values.api.oidc.enabled }}
- name: KEYS_OIDC_ENDPOINT
  value: {{ required "A valid .Values.api.oidc.url required" .Values.api.oidc.url | quote }}
- name: KEYS_OIDC_CLIENT_TIMEOUT
  value: {{ .Values.api.oidc.timeout | quote }}
- name: KEYS_OIDC_CLIENT_RETRY_COUNT
  value: {{ .Values.api.oidc.retryCount | quote }}
- name: KEYS_OIDC_DEFAULT_PARTNER_ID
  value: {{ required "A valid .Values.api.oidc.defaultPartner.id required" .Values.api.oidc.defaultPartner.id | quote }}
- name: KEYS_OIDC_DEFAULT_PARTNER_NAME
  value: {{ required "A valid .Values.api.oidc.defaultPartner.name required" .Values.api.oidc.defaultPartner.name | quote }}
- name: KEYS_OIDC_DEFAULT_ROLE
  value: {{ required "A valid .Values.api.oidc.defaultPartner.role required" .Values.api.oidc.defaultPartner.role | quote }}
{{- end }}
{{- end }}

{{- define "keys.env.import" -}}
- name: KEYS_LOG_LEVEL
  value: {{ .Values.import.logLevel | quote }}
{{- end }}

{{- define "keys.env.migrate" -}}
- name: KEYS_LOG_LEVEL
  value: {{ .Values.migrate.logLevel | quote }}
{{- end }}

{{- define "keys.env.tasker" -}}
- name: KEYS_LOG_LEVEL
  value: {{ .Values.tasker.logLevel | quote }}
- name: KEYS_TASKER_DELAY
  value: {{ .Values.tasker.delay | quote }}
{{- end }}

{{- define "keys.env.dispatcher" -}}
- name: KEYS_LOG_LEVEL
  value: {{ .Values.dispatcher.logLevel | quote }}
- name: KEYS_AUDIT_EVENTS_SEND_INTERVAL
  value: {{ .Values.dispatcher.auditEvents.sendInterval | quote }}
- name: KEYS_AUDIT_EVENTS_BATCH_MAX_SIZE
  value: {{ .Values.dispatcher.auditEvents.batchMaxSize | quote }}
- name: KEYS_AUDIT_EVENTS_HOLD_DURATION
  value: {{ .Values.dispatcher.auditEvents.holdDuration | quote }}
{{- end }}

{{- define "keys.env.cleaner" -}}
- name: KEYS_LOG_LEVEL
  value: {{ .Values.dispatcher.cleaner.logLevel | quote }}
- name: KEYS_AUDIT_EVENTS_RETENTION_DURATION
  value: {{ .Values.dispatcher.cleaner.auditEvents.retentionDuration | quote }}
{{- end -}}

{{- define "keys.env.db" -}}
- name: KEYS_DB_RO_HOST
  value: {{ required "A valid .Values.postgres.ro.host required" .Values.postgres.ro.host | quote }}
- name: KEYS_DB_RO_PORT
  value: {{ .Values.postgres.ro.port | quote }}
- name: KEYS_DB_RO_NAME
  value: {{ required "A valid .Values.postgres.ro.name required" .Values.postgres.ro.name | quote }}
- name: KEYS_DB_RO_SCHEMA
  value: {{ .Values.postgres.ro.schema | quote }}
- name: KEYS_DB_RO_CONNECTION_TIMEOUT
  value: {{ .Values.postgres.ro.timeout | quote }}
- name: KEYS_DB_RO_USERNAME
  value: {{ required "A valid .Values.postgres.ro.username required" .Values.postgres.ro.username | quote }}
- name: KEYS_DB_RO_SSL_MODE
  value: {{ .Values.postgres.ro.tls.mode }}
{{- if has .Values.postgres.ro.tls.mode (list "verify-ca" "verify-full") }}
{{- if .Values.postgres.ro.tls.serverCA }}
- name: KEYS_DB_RO_SSL_SERVERCERT_PATH
  value: /etc/ssl/psql/psql-ro-server-ca.crt
{{- end }}
{{- if eq .Values.postgres.ro.tls.mode "verify-full" }}
{{- if .Values.postgres.ro.tls.clientKey }}
- name: KEYS_DB_RO_SSL_CLIENTKEY_PATH
  value: /etc/ssl/psql/psql-ro-client.key
{{- end }}
{{- if .Values.postgres.ro.tls.clientCert }}
- name: KEYS_DB_RO_SSL_CLIENTCERT_PATH
  value: /etc/ssl/psql/psql-ro-client.crt
{{- end }}
{{- end }}
{{- end }}
- name: KEYS_DB_RW_HOST
  value: {{ required "A valid .Values.postgres.rw.host required" .Values.postgres.rw.host | quote }}
- name: KEYS_DB_RW_PORT
  value: {{ .Values.postgres.rw.port | quote }}
- name: KEYS_DB_RW_CONNECTION_TIMEOUT
  value: {{ .Values.postgres.rw.timeout | quote }}
- name: KEYS_DB_RW_NAME
  value: {{ required "A valid .Values.postgres.rw.name required" .Values.postgres.rw.name | quote }}
- name: KEYS_DB_RW_SCHEMA
  value: {{ .Values.postgres.rw.schema | quote }}
- name: KEYS_DB_RW_USERNAME
  value: {{ required "A valid .Values.postgres.rw.username required" .Values.postgres.rw.username | quote }}
- name: KEYS_DB_RW_SSL_MODE
  value: {{ .Values.postgres.rw.tls.mode }}
{{- if has .Values.postgres.rw.tls.mode (list "verify-ca" "verify-full") }}
{{- if .Values.postgres.rw.tls.serverCA }}
- name: KEYS_DB_RW_SSL_SERVERCERT_PATH
  value: /etc/ssl/psql/psql-rw-server-ca.crt
{{- end }}
{{- if eq .Values.postgres.rw.tls.mode "verify-full" }}
{{- if .Values.postgres.rw.tls.clientKey }}
- name: KEYS_DB_RW_SSL_CLIENTKEY_PATH
  value: /etc/ssl/psql/psql-rw-client.key
{{- end }}
{{- if .Values.postgres.rw.tls.clientCert }}
- name: KEYS_DB_RW_SSL_CLIENTCERT_PATH
  value: /etc/ssl/psql/psql-rw-client.crt
{{- end }}
{{- end }}
{{- end }}
{{- end }}

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
{{- end }}

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
{{- end }}

{{- define "keys.env.redis" -}}

- name: KEYS_REDIS_HOST
  value: {{ .Values.redis.host | quote }}
- name: KEYS_REDIS_DB
  value: {{ .Values.redis.db | quote }}
- name: KEYS_REDIS_PORT
  value: {{ .Values.redis.port | quote }}
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
  value: {{ .Values.api.adminSessionTTL | quote }}
- name: KEYS_LDAP_HOST
  value: {{ .Values.ldap.host | quote }}
- name: KEYS_LDAP_PORT
  value: {{ .Values.ldap.port | quote }}
- name: KEYS_LDAP_USE_STARTTLS
  value: {{ .Values.ldap.useStartTLS | quote }}
- name: KEYS_LDAP_USE_LDAPS
  value: {{ .Values.ldap.useLDAPS | quote }}
- name: KEYS_LDAP_SKIP_SERVER_CERTIFICATE_VERIFY
  value: {{ .Values.ldap.skipServerCertificateVerify | quote }}
- name: KEYS_LDAP_SERVER_NAME
  value: {{ .Values.ldap.serverName | quote }}
- name: KEYS_LDAP_CLIENT_CERTIFICATE_PATH
  value: {{ .Values.ldap.clientCertificatePath | quote }}
- name: KEYS_LDAP_CLIENT_KEY_PATH
  value: {{ .Values.ldap.clientKeyPath | quote }}
- name: KEYS_LDAP_ROOT_CERTIFICATE_AUTHORITIES_PATH
  value: {{ .Values.ldap.rootCertificateAuthoritiesPath | quote }}
- name: KEYS_LDAP_BIND_DN
  value: {{ .Values.ldap.bind.dn | quote }}
- name: KEYS_LDAP_BIND_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.secret.deploys.name" . }}
      key: ldapBindPassword
- name: KEYS_LDAP_SEARCH_BASE_DN
  value: {{ .Values.ldap.search.baseDN | quote }}
- name: KEYS_LDAP_SEARCH_FILTER
  value: {{ .Values.ldap.search.filter | quote }}
{{- end }}

{{- define "keys.env.stat-api"}}
{{- if .Values.statApi.enabled }}
- name: KEYS_STATAPI_ENDPOINT
  value: {{  required "A valid .Values.statApi.url entry required" .Values.statApi.url | quote }}
- name: KEYS_STATAPI_STATAPI_TIMEOUT
  value: {{ .Values.statApi.timeout | quote }}
- name: KEYS_STATAPI_RETRY_COUNT
  value: {{ .Values.statApi.retryCount | quote }}
{{- end }}
{{- end }}

{{- define "keys.env.admin" -}}
- name: APP_HOST
  value: {{ .Values.admin.host | quote }}
- name: API_URL
{{- if .Values.admin.apiOverride }}
  value: {{ .Values.admin.apiOverride | quote }}
{{- else }}
  value: "http://{{ include "keys.api.name" . }}"
{{- end }}
- name: BADGE_TITLE
  value: {{ .Values.admin.badge.title | quote }}
- name: BADGE_TITLE_COLOR
  value: {{ .Values.admin.badge.titleColor | quote }}
- name: BADGE_BACKGROUND_COLOR
  value: {{ .Values.admin.badge.backgroundColor | quote }}
{{- end }}

{{- define "keys.env.counter" -}}
- name: KEYS_LOG_LEVEL
  value: "{{ .Values.counter.logLevel }}"
- name: KEYS_COUNTER_BUFFER_SIZE
  value: "{{ .Values.counter.buffer.size }}"
- name: KEYS_COUNTER_BUFFER_DELAY
  value: "{{ .Values.counter.buffer.delay }}"
- name: KEYS_COUNTER_BUFFER_SPLIT_FACTOR
  value: "{{ .Values.counter.buffer.splitFactor }}"
- name: KEYS_COUNTER_PRELOADER_REFRESH_TICK
  value: "{{ .Values.counter.preloader.refreshTick }}"
- name: KEYS_COUNTER_UPDATE_STATUS_QUERY_TIMEOUT
  value: "{{ .Values.counter.updateStatusQueryTimeout }}"
{{- if .Values.counter.parallelismFactor }}
- name: KEYS_COUNTER_PARALLELISM_FACTOR
  value: "{{ .Values.counter.parallelismFactor }}"
{{- end }}
- name: KEYS_COUNTER_EVENT_PARSER_WORKERS
  value: "{{ .Values.counter.workers.eventParser }}"
- name: KEYS_COUNTER_EVENT_FILTERER_WORKERS
  value: "{{ .Values.counter.workers.eventFilterer }}"
- name: KEYS_COUNTER_EVENT_METRIC_GATHERER_WORKERS
  value: "{{ .Values.counter.workers.eventMetricGatherer }}"
- name: KEYS_COUNTER_EVENT_EVENT_CONVERTER_WORKERS
  value: "{{ .Values.counter.workers.eventConverter }}"
- name: KEYS_COUNTER_INCREMENT_FILTERER_WORKERS
  value: "{{ .Values.counter.workers.incrementFilterer }}"
- name: KEYS_COUNTER_INCREMENT_SAVER_WORKERS
  value: "{{ .Values.counter.workers.incrementSaver }}"
- name: KEYS_KAFKA_MAIN_BROKERS
  value: "{{ required "A valid .Values.kafka.bootstrapServers entry required" .Values.kafka.bootstrapServers }}"
- name: KEYS_KAFKA_MAIN_GROUP_ID
  value: "{{ required "A valid .Values.kafka.stats.groupId entry required" .Values.kafka.stats.groupId }}"
- name: KEYS_KAFKA_MAIN_CLIENT_ID
  value: "{{ .Values.kafka.stats.clientId }}"
- name: KEYS_KAFKA_MAIN_STATS_TOPIC
  value: "{{ required "A valid .Values.kafka.stats.topic entry required" .Values.kafka.stats.topic }}"
- name: KEYS_KAFKA_MAIN_FETCH_DEFAULT
  value: "{{ .Values.kafka.stats.fetchDefault }}"
- name: KEYS_KAFKA_MAIN_FETCH_MIN
  value: "{{ .Values.kafka.stats.fetchMin }}"
- name: KEYS_KAFKA_MAIN_FETCH_MAX
  value: "{{ .Values.kafka.stats.fetchMax }}"
- name: KEYS_KAFKA_MAIN_FETCH_MAX_WAIT_TIME
  value: "{{ .Values.kafka.stats.fetchMaxWaitTime }}"
- name: KEYS_KAFKA_MAIN_USERNAME
  value: "{{ .Values.kafka.username }}"
{{- if .Values.kafka.password }}
- name: KEYS_KAFKA_MAIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.name" . }}-kafka
      key: password
{{- end }}
- name: KEYS_REDIS_RETRIES
  value: "{{ .Values.counter.redis.retries }}"
- name: KEYS_REDIS_MIN_RETRY_BACKOFF
  value: "{{ .Values.counter.redis.minRetryBackoff }}"
- name: KEYS_REDIS_MAX_RETRY_BACKOFF
  value: "{{ .Values.counter.redis.maxRetryBackoff }}"
- name: KEYS_REDIS_DIAL_TIMEOUT
  value: "{{ .Values.counter.redis.dialTimeout }}"
- name: KEYS_REDIS_WRITE_TIMEOUT
  value: "{{ .Values.counter.redis.writeTimeout }}"
- name: KEYS_REDIS_READ_TIMEOUT
  value: "{{ .Values.counter.redis.readTimeout }}"
- name: KEYS_KAFKA_MAIN_SECURITY_PROTOCOL
  value: "{{ .Values.kafka.securityProtocol }}"
- name: KEYS_KAFKA_MAIN_SASL_MECHANISM
  value: "{{ .Values.kafka.saslMechanism }}"
{{- if has .Values.kafka.securityProtocol (list "SSL" "SASL_SSL") }}
- name: KEYS_KAFKA_MAIN_TLS_SKIP_SERVER_CERTIFICATE_VERIFY
  value: "{{ .Values.kafka.tls.skipServerCertificateVerify }}"
- name: KEYS_KAFKA_MAIN_TLS_CLIENT_CERTIFICATE_PATH
  value: "/etc/2gis/secret/kafka/client.crt"
- name: KEYS_KAFKA_MAIN_TLS_CLIENT_KEY_PATH
  value: "/etc/2gis/secret/kafka/client.key"
- name: KEYS_KAFKA_MAIN_TLS_CA_CERT_PATH
  value: "/etc/2gis/secret/kafka/ca.crt"
{{- end }}
{{- end }}

{{- define "keys.env.predef" -}}
{{- range $service, $key := .Values.predefined.service.keys }}
- name: KEYS_PREDEF_SERVICE_KEY_{{ $service | upper }}
  value: {{ $key }}
{{- end }}
{{- range $service, $key := .Values.predefined.service.aliases }}
- name: KEYS_PREDEF_SERVICE_ALIAS_{{ $service | upper }}
  value: {{ $key }}
{{- end }}
{{- end }}

{{- define "keys.env.dgctlStorage" -}}
- name: KEYS_S3_ENDPOINT
  value: {{ .Values.dgctlStorage.host | quote }}
- name: KEYS_S3_REGION
  value: {{ .Values.dgctlStorage.region | quote }}
- name: KEYS_S3_SECURE
  value: {{ .Values.dgctlStorage.secure | quote }}
- name: KEYS_S3_VERIFY_SSL
  value: {{ .Values.dgctlStorage.verifySsl | quote }}
- name: KEYS_S3_BUCKET
  value: {{ .Values.dgctlStorage.bucket | quote }}
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
  value: {{ required "A valid .Values.dgctlStorage.manifest entry required" .Values.dgctlStorage.manifest | quote }}
{{- end }}

{{- define "keys.env.kafka.audit" -}}
- name: KEYS_KAFKA_AUDIT_BROKERS
  value: {{ required "A valid .Values.kafka.bootstrapServers entry required" .Values.kafka.bootstrapServers | quote }}
- name: KEYS_KAFKA_AUDIT_USERNAME
  value: {{ .Values.kafka.username | quote }}
{{- if .Values.kafka.password }}
- name: KEYS_KAFKA_AUDIT_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "keys.name" . }}-kafka
      key: password
{{- end }}
- name: KEYS_KAFKA_AUDIT_SECURITY_PROTOCOL
  value: {{ .Values.kafka.securityProtocol | quote }}
- name: KEYS_KAFKA_AUDIT_SASL_MECHANISM
  value: {{ .Values.kafka.saslMechanism | quote }}
{{- if has .Values.kafka.securityProtocol (list "SSL" "SASL_SSL") }}
- name: KEYS_KAFKA_AUDIT_TLS_SKIP_SERVER_CERTIFICATE_VERIFY
  value: {{ .Values.kafka.tls.skipServerCertificateVerify | quote }}
- name: KEYS_KAFKA_AUDIT_TLS_CLIENT_CERTIFICATE_PATH
  value: "/etc/ssl/private/kafka-client.crt"
- name: KEYS_KAFKA_AUDIT_TLS_CLIENT_KEY_PATH
  value: "/etc/ssl/private/kafka-client.key"
- name: KEYS_KAFKA_AUDIT_TLS_CA_CERT_PATH
  value: "/etc/ssl/private/kafka-ca.crt"
{{- end }}
- name: KEYS_KAFKA_AUDIT_TOPIC
  value: {{ required "A valid .Values.kafka.audit.topic entry required" .Values.kafka.audit.topic | quote }}
- name: KEYS_KAFKA_AUDIT_PRODUCE_RETRY_COUNT
  value: {{ .Values.kafka.audit.produce.retryCount | quote }}
- name: KEYS_KAFKA_AUDIT_PRODUCE_IDEMPOTENT_WRITE
  value: {{ .Values.kafka.audit.produce.idempotentWrite | quote }}
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

{{- define "keys.psql.checks" -}}
{{- if has .Values.postgres.ro.tls.mode (list "verify-ca" "verify-full") }}
{{ $testVar := required "You should set .Values.postgres.ro.tls.serverCA for selected mode" .Values.postgres.ro.tls.serverCA }}
{{- end }}
{{- if eq .Values.postgres.ro.tls.mode "verify-full" }}
{{ $testVar := required "You should set .Values.postgres.ro.tls.clientCert for selected mode" .Values.postgres.ro.tls.clientCert }}
{{ $testVar := required "You should set .Values.postgres.ro.tls.clientKey for selected mode" .Values.postgres.ro.tls.clientKey }}
{{- end }}
{{- if has .Values.postgres.rw.tls.mode (list "verify-ca" "verify-full") }}
{{ $testVar := required "You should set .Values.postgres.rw.tls.serverCA for selected mode" .Values.postgres.rw.tls.serverCA }}
{{- end }}
{{- if eq .Values.postgres.rw.tls.mode "verify-full" }}
{{ $testVar := required "You should set .Values.postgres.rw.tls.clientCert for selected mode" .Values.postgres.rw.tls.clientCert }}
{{ $testVar := required "You should set .Values.postgres.rw.tls.clientKey for selected mode" .Values.postgres.rw.tls.clientKey }}
{{- end }}
{{- end -}}

{{- define "keys.psql.volumeMount" -}}
{{- if or
  (has .Values.postgres.ro.tls.mode (list "verify-ca" "verify-full"))
  (has .Values.postgres.rw.tls.mode (list "verify-ca" "verify-full"))
-}}
- name: tls
  mountPath: /etc/ssl/psql
{{- end }}
{{- end -}}

{{- define "keys.psql.volume" -}}
{{- if or
  (has .Values.postgres.ro.tls.mode (list "verify-ca" "verify-full"))
  (has .Values.postgres.rw.tls.mode (list "verify-ca" "verify-full"))
-}}
- name: tls-raw
  secret:
    secretName: {{ include "keys.name" . }}-tls
    items:
    {{- if has .Values.postgres.ro.tls.mode (list "verify-ca" "verify-full") }}
    {{- if .Values.postgres.ro.tls.serverCA }}
      - key: psql-ro-server-ca.crt
        path: psql-ro-server-ca.crt
    {{- end }}
    {{- if has .Values.postgres.ro.tls.mode (list "verify-full") }}
    {{- if .Values.postgres.ro.tls.clientKey }}
      - key: psql-ro-client.key
        path: psql-ro-client.key
    {{- end }}
    {{- if .Values.postgres.ro.tls.clientCert }}
      - key: psql-ro-client.crt
        path: psql-ro-client.crt
    {{- end }}
    {{- end }}
    {{- end }}
    {{- if has .Values.postgres.rw.tls.mode (list "verify-ca" "verify-full") }}
    {{- if .Values.postgres.rw.tls.serverCA }}
      - key: psql-rw-server-ca.crt
        path: psql-rw-server-ca.crt
    {{- end }}
    {{- if has .Values.postgres.rw.tls.mode (list "verify-full") }}
    {{- if .Values.postgres.rw.tls.clientKey }}
      - key: psql-rw-client.key
        path: psql-rw-client.key
    {{- end }}
    {{- if .Values.postgres.rw.tls.clientCert }}
      - key: psql-rw-client.crt
        path: psql-rw-client.crt
    {{- end }}
    {{- end }}
    {{- end }}
- name: tls
  emptyDir: {}
{{- end }}
{{- end -}}

{{- define "keys.tls.kafka.checks" -}}
{{- if has .Values.kafka.securityProtocol (list "SSL" "SASL_SSL") }}
{{ $testVar := required "You should set .Values.kafka.tls.serverCA for selected mode" .Values.kafka.tls.serverCA }}
{{ $testVar := required "You should set .Values.kafka.tls.clientCert for selected mode" .Values.kafka.tls.clientCert }}
{{ $testVar := required "You should set .Values.kafka.tls.clientKey for selected mode" .Values.kafka.tls.clientKey }}
{{- end }}
{{- end -}}

{{- define "keys.tls.kafka.volumeMount" -}}
{{- if has .Values.kafka.securityProtocol (list "SSL" "SASL_SSL") -}}
- name: tls-kafka
  mountPath: /etc/ssl/private
{{- end }}
{{- end -}}

{{- define "keys.tls.kafka.volume" -}}
{{- if has .Values.kafka.securityProtocol (list "SSL" "SASL_SSL") -}}
- name: tls-kafka-raw
  secret:
    secretName: {{ include "keys.name" . }}-kafka
    items:
    {{- if .Values.kafka.tls.serverCA }}
      - key: kafka-ca.crt
        path: kafka-ca.crt
    {{- end }}
    {{- if .Values.kafka.tls.clientKey }}
      - key: kafka-client.key
        path: kafka-client.key
    {{- end }}
    {{- if .Values.kafka.tls.clientCert }}
      - key: kafka-client.crt
        path: kafka-client.crt
    {{- end }}
- name: tls-kafka
  emptyDir: {}
{{- end }}
{{- end -}}

{{- define "keys.psql.initTLS" -}}
{{- if or
  (has .Values.postgres.ro.tls.mode (list "verify-ca" "verify-full"))
  (has .Values.postgres.rw.tls.mode (list "verify-ca" "verify-full"))
-}}
- name: copy-certs
  image: {{ .Values.dgctlDockerRegistry }}/{{ .Values.backend.image.repository }}:{{ .Values.backend.image.tag }}
  command:
    - /bin/sh
    - -c
    - |-
      cp /tls/* /etc/ssl/psql/
      chmod 0400 /etc/ssl/psql/psql-ro-client.key
      chmod 0400 /etc/ssl/psql/psql-rw-client.key
  resources:
    requests:
      cpu: 20m
      memory: 16Mi
    limits:
      cpu: 20m
      memory: 16Mi
  volumeMounts:
    - name: tls-raw
      mountPath: /tls
    - name: tls
      mountPath: /etc/ssl/psql
{{- end -}}
{{- end -}}

{{- define "keys.initTLS" -}}
{{- if or
    (has .Values.kafka.securityProtocol (list "SSL" "SASL_SSL"))
    (has .Values.postgres.ro.tls.mode (list "verify-ca" "verify-full"))
    (has .Values.postgres.rw.tls.mode (list "verify-ca" "verify-full"))
}}
- name: copy-certs
  image: {{ .Values.dgctlDockerRegistry }}/{{ .Values.backend.image.repository }}:{{ .Values.backend.image.tag }}
  command:
    - /bin/sh
    - -c
    - |-
      cp /tls/psql/* /etc/ssl/psql/ || true
      cp /tls/kafka/* /etc/ssl/private || true
      chmod 0400 /etc/ssl/psql/psql-ro-client.key || true
      chmod 0400 /etc/ssl/psql/psql-rw-client.key || true
      chmod 0400 /etc/ssl/private/kafka-client.key || true
  resources:
    requests:
      cpu: 20m
      memory: 16Mi
    limits:
      cpu: 20m
      memory: 16Mi
  volumeMounts:
  {{ if or
      (has .Values.postgres.ro.tls.mode (list "verify-ca" "verify-full"))
      (has .Values.postgres.rw.tls.mode (list "verify-ca" "verify-full"))
  }}
    - name: tls-raw
      mountPath: /tls/psql
    - name: tls
      mountPath: /etc/ssl/psql
  {{- end }}
  {{ if (has .Values.kafka.securityProtocol (list "SSL" "SASL_SSL")) }}
    - name: tls-kafka-raw
      mountPath: /tls/kafka
    - name: tls-kafka
      mountPath: /etc/ssl/private
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Manifest name
*/}}
{{- define "keys.manifestCode" -}}
{{- base .Values.dgctlStorage.manifest | trimSuffix ".json" }}
{{- end }}
