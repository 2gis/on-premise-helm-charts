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
{{- base $.Values.dgctlStorage.manifest | trimSuffix ".json" }}
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

- name: CATALOG_DB_API_KEY_URL
  value: "jdbc:postgresql://{{ .Values.api.postgres.host }}:{{ .Values.api.postgres.port }}/{{ .Values.api.postgres.name }}"
- name: CATALOG_DB_API_KEY_LOGIN
  value: "{{ .Values.api.postgres.username }}"
- name: CATALOG_DB_API_KEY_PASS
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
- name: IMPORTER_S3_ENDPOINT
  value: "{{ .Values.dgctlStorage.host }}"
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
