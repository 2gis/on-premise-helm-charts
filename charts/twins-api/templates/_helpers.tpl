{{- define "twins.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "twins.api.name" -}}
{{ include "twins.name" . }}
{{- end }}

{{- define "twins.migrate.name" -}}
{{ include "twins.name" . }}-migrate
{{- end }}

{{- define "twins.importer.name" -}}
{{ include "twins.name" . }}-importer
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
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "twins.api.labels" -}}
{{ include "twins.api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "twins.migrate.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-migrate
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "twins.importer.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-importer
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "twins.manifestCode" -}}
{{- base .Values.dgctlStorage.manifest | trimSuffix ".json" }}
{{- end }}

{{- define "twins.env.loglevel" -}}
- name: TWINS_LOG_LEVEL
  value: "{{ .Values.api.logLevel }}"
{{- end }}

{{- define "twins.env.db" -}}
- name: TWINS_DB_RO_HOST
  value: "{{ required "A valid .Values.postgres.ro.host required" .Values.postgres.ro.host }}"
- name: TWINS_DB_RO_PORT
  value: "{{ .Values.postgres.ro.port }}"
- name: TWINS_DB_RO_NAME
  value: "{{ required "A valid .Values.postgres.ro.name required" .Values.postgres.ro.name }}"
{{- if .Values.importer.postgres.schemaSwitchEnabled }}
- name: TWINS_DB_RO_SCHEMA
  value: "{{ include "twins.manifestCode" . }}"
{{- else }}
- name: TWINS_DB_RO_SCHEMA
  value: "{{ .Values.postgres.ro.schema }}"
{{- end }}
- name: TWINS_DB_RO_CONNECTION_TIMEOUT
  value: "{{ .Values.postgres.ro.timeout }}"
- name: TWINS_DB_RO_CONNECTION_RETRY
  value: "{{ .Values.postgres.ro.retry }}"
- name: TWINS_DB_RO_USERNAME
  value: "{{ required "A valid .Values.postgres.ro.username required" .Values.postgres.ro.username }}"
- name: TWINS_DB_RW_HOST
  value: "{{ required "A valid .Values.postgres.rw.host required" .Values.postgres.rw.host }}"
- name: TWINS_DB_RW_PORT
  value: "{{ .Values.postgres.rw.port }}"
{{- if .Values.importer.postgres.schemaSwitchEnabled }}
- name: TWINS_DB_RW_SCHEMA
  value: "{{ include "twins.manifestCode" . }}"
{{- else }}
- name: TWINS_DB_RW_SCHEMA
  value: "{{ .Values.postgres.rw.schema }}"
{{- end }}
- name: TWINS_DB_RW_CONNECTION_TIMEOUT
  value: "{{ .Values.postgres.rw.timeout }}"
- name: TWINS_DB_RW_CONNECTION_RETRY
  value: "{{ .Values.postgres.rw.retry }}"
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
{{ include "twins.env.loglevel" . }}
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
{{ include "twins.env.loglevel" . }}
{{ include "twins.env.db.deploys" . }}
- name: TWINS_AUTH_ENDPOINT
  value: "{{ required "A valid .Values.api.keys.url required" .Values.api.keys.url }}"
- name: TWINS_AUTH_SERVICE_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "twins.secret.deploys.name" . }}
      key: keysToken
- name: TWINS_AUTH_CLIENT_TIMEOUT
  value: "{{ .Values.api.keys.requestTimeout }}"
{{- end }}

{{- define "twins.env.importer" -}}
{{ include "twins.env.db.jobs" . }}
- name: TWINS_IMPORTER_DB_SCHEMA_SWITCH_ENABLED
  value: "{{ .Values.importer.postgres.schemaSwitchEnabled }}"
- name: TWINS_S3_ENDPOINT
  value: "{{ .Values.dgctlStorage.host }}"
- name: TWINS_S3_REGION
  value: "{{ .Values.dgctlStorage.region }}"
- name: TWINS_S3_SECURE
  value: "{{ .Values.dgctlStorage.secure }}"
- name: TWINS_S3_VERIFY_SSL
  value: "{{ .Values.dgctlStorage.verifySsl }}"
- name: TWINS_S3_BUCKET
  value: "{{ .Values.dgctlStorage.bucket }}"
- name: TWINS_S3_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "twins.secret.jobs.name" . }}
      key: dgctlStorageAccessKey
- name: TWINS_S3_SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "twins.secret.jobs.name" . }}
      key: dgctlStorageSecretKey
- name: TWINS_IMPORTER_MANIFEST_PATH
  value: "{{ required "A valid .Values.dgctlStorage.manifest entry required" .Values.dgctlStorage.manifest }}"
- name: TWINS_IMPORTER_NUMBER_SCHEMA_BACKUPS
  value: "{{ .Values.importer.cleaner.versionLimit }}"
- name: TWINS_S3_RETRY_MAX_ATTEMPTS
  value: "{{ .Values.importer.retry.download.maxAttempts }}"
- name: TWINS_S3_RETRY_DELAY
  value: "{{ .Values.importer.retry.download.delay }}"
- name: TWINS_IMPORTER_PSQL_RETRY_MAX_ATTEMPTS
  value: "{{ .Values.importer.retry.execute.maxAttempts }}"
- name: TWINS_IMPORTER_PSQL_RETRY_DELAY
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

{{- define "twins.env.custom.ca.path" -}}
- name: SSL_CERT_DIR
  value: {{ include "twins.custom.ca.mountPath" . }}
{{- end }}

{{- define "twins.custom.ca.mountPath" -}}
{{ .Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}

{{- define "twins.custom.ca.volumeMounts" -}}
- name: custom-ca
  mountPath: {{ include "twins.custom.ca.mountPath" . }}/custom-ca.crt
  subPath: custom-ca.crt
  readOnly: true
{{- end -}}

{{- define "twins.custom.ca.jobs.volumes" -}}
- name: custom-ca
  configMap:
    name: {{ include "twins.configmap.jobs.name" . }}
{{- end -}}

{{- define "twins.custom.ca.deploys.volumes" -}}
- name: custom-ca
  configMap:
    name: {{ include "twins.configmap.deploys.name" . }}
{{- end -}}

{{- define "twins.configmap.jobs.name" -}}
{{ include "twins.name" . }}-configmap-jobs
{{- end -}}

{{- define "twins.configmap.deploys.name" -}}
{{ include "twins.name" . }}-configmap-deploys
{{- end -}}
