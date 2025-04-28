{{- define "catalog.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "catalog.importer.name" -}}
{{ include "catalog.name" . }}-importer
{{- end }}

{{- define "catalog.secret.deploys.name" -}}
{{ include "catalog.name" . }}-deploys
{{- end }}

{{- define "catalog.secret.jobs.name" -}}
{{ include "catalog.name" . }}-jobs
{{- end }}

{{- /*
Name for psql intermediate volume for copy secrets and change permissions
*/ -}}

{{- define "catalog.name-psql-raw" -}}
{{- printf "%s-psql-raw" (include "catalog.name" .) -}}
{{- end }}

{{- /*
Name for psql secret and volume
*/ -}}

{{- define "catalog.name-psql" -}}
{{- printf "%s-psql" (include "catalog.name" .) -}}
{{- end }}

{{- /*
Name for psql intermediate volume for copy secrets and change permissions
*/ -}}

{{- define "catalog.importer.name-psql-raw" -}}
{{- printf "%s-psql-raw" (include "catalog.importer.name" .) -}}
{{- end }}

{{- /*
Name for psql secret and volume
*/ -}}

{{- define "catalog.importer.name-psql" -}}
{{- printf "%s-psql" (include "catalog.importer.name" .) -}}
{{- end }}

{{- define "catalog.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "catalog.labels" -}}
{{ include "catalog.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "catalog.importer.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-importer
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "catalog.manifestCode" -}}
{{- if .Values.importer.postgres.schemaSwitchEnabled }}
{{- base .Values.dgctlStorage.manifest | trimSuffix ".json" }}
{{- else -}}
onprem
{{- end }}
{{- end }}

{{- define "catalog.env.settings" -}}
- name: CATALOG_LOGBACK_LEVEL
  value: "{{ .Values.api.logLevel }}"
{{- end }}

{{- define "catalog.env.postgres" -}}
- name: CATALOG_DB_SCHEMA
  value: "{{ include "catalog.manifestCode" . }},{{ .Values.importer.postgres.schemaExtensions }}"
- name: CATALOG_DB_QUERY_TIMEOUT
  value: "{{ .Values.api.postgres.queryTimeout }}"
- name: CATALOG_DB_BRANCH_POOL_SIZE
  value: "{{ .Values.api.postgres.poolSize.api }}"
- name: CATALOG_DB_REGION_POOL_SIZE
  value: "{{ .Values.api.postgres.poolSize.preloaders.region }}"
- name: CATALOG_DB_RUBRIC_POOL_SIZE
  value: "{{ .Values.api.postgres.poolSize.preloaders.rubric }}"
- name: CATALOG_DB_ADDITIONAL_ATTRIBUTE_POOL_SIZE
  value: "{{ .Values.api.postgres.poolSize.preloaders.additionalAttribute }}"
- name: CATALOG_DB_BRANCH_URL
  value: "jdbc:postgresql://{{ required "A valid .Values.api.postgres.host entry required" .Values.api.postgres.host }}:{{ .Values.api.postgres.port }}/{{ required "A valid .Values.api.postgres.name entry required" .Values.api.postgres.name }}"
- name: CATALOG_DB_BRANCH_LOGIN
  value: "{{ required "A valid .Values.api.postgres.username entry required" .Values.api.postgres.username }}"
- name: CATALOG_DB_BRANCH_PASS
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.deploys.name" . }}
      key: apiDbPassword

- name: CATALOG_DB_REGION_URL
  value: "jdbc:postgresql://{{ .Values.api.postgres.host }}:{{ .Values.api.postgres.port }}/{{ .Values.api.postgres.name }}"
- name: CATALOG_DB_REGION_LOGIN
  value: "{{ .Values.api.postgres.username }}"
- name: CATALOG_DB_REGION_PASS
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.deploys.name" . }}
      key: apiDbPassword

- name: CATALOG_DB_RUBRIC_URL
  value: "jdbc:postgresql://{{ .Values.api.postgres.host }}:{{ .Values.api.postgres.port }}/{{ .Values.api.postgres.name }}"
- name: CATALOG_DB_RUBRIC_LOGIN
  value: "{{ .Values.api.postgres.username }}"
- name: CATALOG_DB_RUBRIC_PASS
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.deploys.name" . }}
      key: apiDbPassword

- name: CATALOG_DB_ADDITIONAL_ATTRIBUTE_URL
  value: "jdbc:postgresql://{{ .Values.api.postgres.host }}:{{ .Values.api.postgres.port }}/{{ .Values.api.postgres.name }}"
- name: CATALOG_DB_ADDITIONAL_ATTRIBUTE_LOGIN
  value: "{{ .Values.api.postgres.username }}"
- name: CATALOG_DB_ADDITIONAL_ATTRIBUTE_PASS
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.deploys.name" . }}
      key: apiDbPassword
- name: CATALOG_DB_SSL_ENABLED
  value: "{{ .Values.api.postgres.tls.enabled }}"
- name: CATALOG_DB_SSL_MODE
  value: "{{ .Values.api.postgres.tls.mode }}"
- name: CATALOG_DB_SSL_CLIENTCERT_PATH
  value: "/etc/2gis/secret/psql/client.crt"
- name: CATALOG_DB_SSL_CLIENTKEY_PATH
  value: "/etc/2gis/secret/psql/client.key"
- name: CATALOG_DB_SSL_SERVERCERT_PATH
  value: "/etc/2gis/secret/psql/ca.crt"
{{- end }}

{{- define "catalog.env.preloaders" -}}
- name: CATALOG_PRELOADERS_SETTINGS_AWAIT_TIMEOUT
  value: "{{ .Values.api.preloaders.awaitTimeout }}"
{{- end }}

{{- define "catalog.env.search" -}}
- name: CATALOG_SAPPHIRE_URL
  value: "{{ required "A valid .Values.search.url entry required" .Values.search.url }}"
- name: CATALOG_SAPPHIRE_CONNECTION_TIMEOUT
  value: "{{ .Values.search.connectTimeout }}"
- name: CATALOG_SAPPHIRE_MIN_CONNECTIONS
  value: "{{ .Values.search.minConnections }}"
- name: CATALOG_SAPPHIRE_MAX_CONNECTIONS
  value: "{{ .Values.search.maxConnections }}"
- name: CATALOG_SAPPHIRE_MAX_OPEN_REQUESTS
  value: "{{ .Values.search.maxOpenRequests }}"
{{- end }}

{{- define "catalog.env.keys" -}}
- name: CATALOG_KEYS_ENDPOINT
  value: "{{ required "A valid .Values.keys.url entry required" .Values.keys.url }}"
- name: CATALOG_KEYS_SERVICE_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.deploys.name" . }}
      key: keysServiceToken
- name: CATALOG_KEYS_CONNECTING_TIMEOUT
  value: "{{ .Values.keys.client.connectingTimeout }}"
- name: CATALOG_KEYS_IDLE_TIMEOUT
  value: "{{ .Values.keys.client.idleTimeout }}"
- name: CATALOG_KEYS_MAX_RETRIES
  value: "{{ .Values.keys.client.maxRetries }}"
- name: CATALOG_KEYS_MAX_CONNECTION_LIFETIME
  value: "{{ .Values.keys.client.maxConnectionLifetime }}"
- name: CATALOG_KEYS_BASE_CONNECTION_BACKOFF
  value: "{{ .Values.keys.client.baseConnectionBackoff }}"
- name: CATALOG_KEYS_MAX_CONNECTION_BACKOFF
  value: "{{ .Values.keys.client.maxConnectionBackoff }}"
- name: CATALOG_KEYS_RESPONSE_TIMEOUT
  value: "{{ .Values.keys.client.responseTimeout }}"
{{- end }}

{{- define "catalog.env.license" -}}
- name: CATALOG_PASPORTOOL_ENDPOINT
  value: "{{ required "A valid .Values.license.url entry required" .Values.license.url }}"
- name: CATALOG_PASPORTOOL_REQUEST_TIMEOUT
  value: "{{ .Values.license.requestTimeout }}"
{{- end }}

{{- define "catalog.env.stat" -}}
- name: CATALOG_BSS_ENDPOINT
  value: "{{ .Values.stat.url }}"
- name: CATALOG_BSS_REQUEST_ENABLED
  value: "{{ .Values.stat.request.enabled }}"
- name: CATALOG_BSS_REQUEST_BUFFER_LIFETIME
  value: "{{ .Values.stat.request.buffer.lifetime }}"
- name: CATALOG_BSS_REQUEST_BUFFER_SEND_TIMEOUT
  value: "{{ .Values.stat.request.buffer.sendTimeout }}"
- name: CATALOG_BSS_REQUEST_BUFFER_SEND_LIMIT
  value: "{{ .Values.stat.request.buffer.sendLimit }}"
- name: CATALOG_BSS_SEARCH_ENABLED
  value: "{{ .Values.stat.search.enabled }}"
- name: CATALOG_BSS_SEARCH_BUFFER_LIFETIME
  value: "{{ .Values.stat.search.buffer.lifetime }}"
- name: CATALOG_BSS_SEARCH_BUFFER_SEND_TIMEOUT
  value: "{{ .Values.stat.search.buffer.sendTimeout }}"
- name: CATALOG_BSS_SEARCH_BUFFER_SEND_LIMIT
  value: "{{ .Values.stat.search.buffer.sendLimit }}"
- name: CATALOG_BSS_CONNECTING_TIMEOUT
  value: "{{ .Values.stat.client.connectingTimeout }}"
- name: CATALOG_BSS_IDLE_TIMEOUT
  value: "{{ .Values.stat.client.Idle_timeout }}"
- name: CATALOG_BSS_MIN_CONNECTIONS
  value: "{{ .Values.stat.client.minConnections }}"
- name: CATALOG_BSS_MAX_CONNECTIONS
  value: "{{ .Values.stat.client.maxConnections }}"
- name: CATALOG_BSS_MAX_OPEN_REQUESTS
  value: "{{ .Values.stat.client.maxOpenRequests }}"
- name: CATALOG_BSS_MAX_RETRIES
  value: "{{ .Values.stat.client.maxRetries }}"
- name: CATALOG_BSS_CONNECTION_LIFETIME
  value: "{{ .Values.stat.client.maxConnectionLifetime }}"
- name: CATALOG_BSS_BASE_CONNECTION_BACKOFF
  value: "{{ .Values.stat.client.baseConnectionBackoff }}"
- name: CATALOG_BSS_MAX_CONNECTION_BACKOFF
  value: "{{ .Values.stat.client.maxConnectionBackoff }}"
- name: CATALOG_BSS_RESPONSE_TIMEOUT
  value: "{{ .Values.stat.client.responseTimeout }}"
- name: CATALOG_BSS_DISPATCHER_FIXED_POOL_SIZE
  value: "{{ .Values.stat.dispatcher.fixedPoolSize }}"
- name: CATALOG_BSS_DISPATCHER_THROUGHPUT
  value: "{{ .Values.stat.dispatcherThroughput }}"
{{- end }}

{{- define "catalog.env.importer" -}}
- name: IMPORTER_DB_CATALOG_SCHEMA
  value: "{{ include "catalog.manifestCode" . }}"
- name: IMPORTER_DB_CATALOG_SCHEMA_SWITCH_ENABLED
  value: "{{ .Values.importer.postgres.schemaSwitchEnabled }}"
- name: IMPORTER_DB_CATALOG_SCHEMA_EXTENSIONS
  value: "{{ .Values.importer.postgres.schemaExtensions }}"
- name: IMPORTER_DB_CATALOG_HOST
  value: "{{ required "A valid .Values.importer.postgres.host entry required" .Values.importer.postgres.host }}"
- name: IMPORTER_DB_CATALOG_PORT
  value: "{{ .Values.importer.postgres.port }}"
- name: IMPORTER_DB_CATALOG_NAME
  value: "{{ required "A valid .Values.importer.postgres.name entry required" .Values.importer.postgres.name }}"
- name: IMPORTER_DB_CATALOG_USERNAME
  value: "{{ required "A valid .Values.importer.postgres.username entry required" .Values.importer.postgres.username }}"
- name: IMPORTER_DB_CATALOG_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.jobs.name" . }}
      key: importerDbPassword
{{- if .Values.importer.postgres.tls.enabled }}
- name: IMPORTER_DB_CATALOG_SSL_MODE
  value: "{{ .Values.importer.postgres.tls.mode }}"
- name: IMPORTER_DB_CATALOG_SSL_CLIENTCERT_PATH
  value: "/etc/2gis/secret/psql/client.crt"
- name: IMPORTER_DB_CATALOG_SSL_CLIENTKEY_PATH
  value: "/etc/2gis/secret/psql/client.key"
- name: IMPORTER_DB_CATALOG_SSL_SERVERCERT_PATH
  value: "/etc/2gis/secret/psql/ca.crt"
{{- end }}
- name: IMPORTER_S3_ENDPOINT
  value: "{{ .Values.dgctlStorage.host }}"
- name: IMPORTER_S3_REGION
  value: "{{ .Values.dgctlStorage.region }}"
- name: IMPORTER_S3_SECURE
  value: "{{ .Values.dgctlStorage.secure }}"
- name: IMPORTER_S3_VERIFY_SSL
  value: "{{ .Values.dgctlStorage.verifySsl }}"
- name: IMPORTER_S3_BUCKET
  value: "{{ .Values.dgctlStorage.bucket }}"
- name: IMPORTER_S3_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.jobs.name" . }}
      key: dgctlStorageAccessKey
- name: IMPORTER_S3_SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.jobs.name" . }}
      key: dgctlStorageSecretKey
- name: IMPORTER_MANIFEST_PATH
  value: "{{ required "A valid .Values.dgctlStorage.manifest entry required" .Values.dgctlStorage.manifest }}"
- name: IMPORTER_WORKER_POOL_SIZE
  value: "{{ .Values.importer.workerNum }}"
- name: IMPORTER_NUMBER_SCHEMA_BACKUPS
  value: "{{ .Values.importer.cleaner.versionLimit }}"
- name: IMPORTER_S3_RETRY_MAX_ATTEMPTS
  value: "{{ .Values.importer.retry.download.maxAttempts }}"
- name: IMPORTER_S3_RETRY_DELAY
  value: "{{ .Values.importer.retry.download.delay }}"
- name: IMPORTER_PSQL_RETRY_MAX_ATTEMPTS
  value: "{{ .Values.importer.retry.execute.maxAttempts }}"
- name: IMPORTER_PSQL_RETRY_DELAY
  value: "{{ .Values.importer.retry.execute.delay }}"
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

{{- define "catalog.env.custom.ca.path" -}}
- name: SSL_CERT_DIR
  value: {{ include "catalog.custom.ca.mountPath" . }}
{{- end }}

{{- define "catalog.custom.ca.mountPath" -}}
{{ .Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}

{{- define "catalog.custom.ca.volumeMounts" -}}
- name: custom-ca
  mountPath: {{ include "catalog.custom.ca.mountPath" . }}/custom-ca.crt
  subPath: custom-ca.crt
  readOnly: true
{{- end -}}

{{- define "catalog.custom.ca.jobs.volumes" -}}
- name: custom-ca
  configMap:
    name: {{ include "catalog.configmap.jobs.name" . }}
{{- end -}}

{{- define "catalog.custom.ca.deploys.volumes" -}}
- name: custom-ca
  configMap:
    name: {{ include "catalog.configmap.deploys.name" . }}
{{- end -}}

{{- define "catalog.configmap.jobs.name" -}}
{{ include "catalog.name" . }}-configmap-jobs
{{- end -}}

{{- define "catalog.configmap.deploys.name" -}}
{{ include "catalog.name" . }}-configmap-deploys
{{- end -}}
