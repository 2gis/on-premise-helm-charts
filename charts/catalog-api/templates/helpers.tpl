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


{{- define "catalog.env.db" -}}
- name: CATALOG_DB_SCHEMA
  value: "{{ include "catalog.manifestCode" . }},extensions"
- name: CATALOG_DB_BRANCH_URL
  value: "jdbc:postgresql://{{ .Values.api.postgres.host }}:{{ .Values.api.postgres.port }}/{{ .Values.api.postgres.name }}"
- name: CATALOG_DB_BRANCH_LOGIN
  value: "{{ .Values.api.postgres.username }}"
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

{{- define "catalog.env.search" -}}
- name: CATALOG_SAPPHIRE_URL
  value: "{{ .Values.search.url }}"
{{- end }}

{{- define "catalog.env.keys" -}}
- name: CATALOG_KEYS_ENABLED
  value: "true"
- name: CATALOG_KEYS_ENDPOINT
  value: "{{ .Values.keys.endpoint }}"
- name: CATALOG_KEYS_REQUEST_TIMEOUT
  value: "{{ .Values.keys.requestTimeout }}"
- name: CATALOG_KEYS_SERVICE_CATALOG_KEY
  value: ""
{{- if .Values.keys.serviceKeys.places }}
- name: CATALOG_KEYS_SERVICE_PLACES_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.deploys.name" . }}
      key: keysServicePlaces
{{- end }}
{{- if .Values.keys.serviceKeys.geocoder }}
- name: CATALOG_KEYS_SERVICE_GEOCODER_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.deploys.name" . }}
      key: keysServiceGeocoder
{{- end }}
{{- if .Values.keys.serviceKeys.suggest }}
- name: CATALOG_KEYS_SERVICE_SUGGEST_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.deploys.name" . }}
      key: keysServiceSuggest
{{- end }}
{{- if .Values.keys.serviceKeys.categories }}
- name: CATALOG_KEYS_SERVICE_CATEGORIES_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.deploys.name" . }}
      key: keysServiceCategories
{{- end }}
{{- if .Values.keys.serviceKeys.regions }}
- name: CATALOG_KEYS_SERVICE_REGIONS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "catalog.secret.deploys.name" . }}
      key: keysServiceRegions
{{- end }}
{{- end }}

{{- define "catalog.env.importer" -}}
- name: IMPORTER_DB_CATALOG_SCHEMA
  value: "{{ include "catalog.manifestCode" . }}"
- name: IMPORTER_DB_CATALOG_SCHEMA_SWITCH_ENABLED
  value: "{{ .Values.importer.postgres.schemaSwitchEnabled }}"
- name: IMPORTER_DB_CATALOG_HOST
  value: "{{ .Values.importer.postgres.host }}"
- name: IMPORTER_DB_CATALOG_PORT
  value: "{{ .Values.importer.postgres.port }}"
- name: IMPORTER_DB_CATALOG_NAME
  value: "{{ .Values.importer.postgres.name }}"
- name: IMPORTER_DB_CATALOG_USERNAME
  value: "{{ .Values.importer.postgres.username }}"
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
  value: "{{ .Values.dgctlStorage.manifest }}"
- name: IMPORTER_WORKER_POOL_SIZE
  value: "{{ .Values.importer.workerNum }}"
- name: IMPORTER_NUMBER_SCHEMA_BACKUPS
  value: "{{ .Values.importer.cleaner.versionLimit }}"
{{- end }}
