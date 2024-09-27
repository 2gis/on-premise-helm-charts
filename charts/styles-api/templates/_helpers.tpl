{{- define "styles.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "styles.api.name" -}}
{{ include "styles.name" . }}
{{- end }}

{{- define "styles.worker.name" -}}
{{ include "styles.name" . }}-worker
{{- end }}

{{- define "styles.migrate.name" -}}
{{ include "styles.name" . }}-migrate
{{- end }}

{{- define "styles.secret.deploys.name" -}}
{{ include "styles.name" . }}-secret-deploys
{{- end }}

{{- define "styles.secret.jobs.name" -}}
{{ include "styles.name" . }}-secret-jobs
{{- end }}

{{- define "styles.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "styles.labels" -}}
{{ include "styles.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "styles.api.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "styles.api.labels" -}}
{{ include "styles.api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "styles.worker.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-worker
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "styles.worker.labels" -}}
{{ include "styles.worker.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "styles.migrate.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-migrate
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "styles.env.loglevel" -}}
- name: MGS_LOG_LEVEL
  value: "{{ .Values.log.level }}"
{{- end }}

{{- define "styles.env.db" -}}
- name: MGS_DB_HOST
  value: "{{ required "A valid .Values.postgres.host required" .Values.postgres.host }}"
- name: MGS_DB_PORT
  value: "{{ .Values.postgres.port }}"
- name: MGS_DB_NAME
  value: "{{ required "A valid .Values.postgres.name required" .Values.postgres.name }}"
- name: MGS_DB_SCHEMA
  value: "{{ .Values.postgres.schema }}"
- name: MGS_DB_CONNECTION_TIMEOUT
  value: "{{ .Values.postgres.timeout }}"
- name: MGS_DB_CONNECTION_RETRY
  value: "{{ .Values.postgres.retry }}"
- name: MGS_DB_USERNAME
  value: "{{ required "A valid .Values.postgres.ro.username required" .Values.postgres.username }}"
{{- end}}

{{- define "styles.env.db.deploys" -}}
{{ include "styles.env.db" . }}
- name: MGS_DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "styles.secret.deploys.name" . }}
      key: dbPassword
{{- end }}

{{- define "styles.env.db.jobs" -}}
{{ include "styles.env.db" . }}
- name: MGS_DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "styles.secret.jobs.name" . }}
      key: dbPassword
{{- end }}

{{- define "styles.env.s3" -}}
- name: MGS_S3_ENDPOINT
  value: "{{ required "A valid .Values.s3.host required" .Values.s3.host }}"
- name: MGS_S3_BUCKET
  value: "{{ .Values.s3.bucket }}"
- name: MGS_S3_PUBLIC_DOMAIN
  value: "{{ .Values.s3.publicDomain }}"
- name: MGS_S3_CONNECT_TIMEOUT
  value: "{{ .Values.s3.connectTimeout }}"
- name: MGS_S3_REQUEST_TIMEOUT
  value: "{{ .Values.s3.requestTimeout }}"
- name: MGS_S3_RESPONSE_TIMEOUT
  value: "{{ .Values.s3.responseTimeout }}"
{{- end}}

{{- define "styles.env.s3.deploys" -}}
{{ include "styles.env.s3" . }}
- name: MGS_S3_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "styles.secret.deploys.name" . }}
      key: s3AccessKey
- name: MGS_S3_SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "styles.secret.deploys.name" . }}
      key: s3SecretKey
{{- end }}

{{- define "styles.env.api" -}}
{{ include "styles.env.loglevel" . }}
{{ include "styles.env.db.deploys" . }}
{{ include "styles.env.s3.deploys" . }}
{{- end }}

{{- define "styles.env.worker" -}}
{{ include "styles.env.loglevel" . }}
{{ include "styles.env.db.deploys" . }}
{{ include "styles.env.s3.deploys" . }}
{{- end }}

{{- define "styles.env.migrate" -}}
{{ include "styles.env.loglevel" . }}
{{ include "styles.env.db.jobs" . }}
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

{{- define "styles.env.custom.ca.path" -}}
- name: SSL_CERT_DIR
  value: {{ include "styles.custom.ca.mountPath" . }}
{{- end }}

{{- define "styles.custom.ca.mountPath" -}}
{{ .Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}

{{- define "styles.custom.ca.volumeMounts" -}}
- name: custom-ca
  mountPath: {{ include "styles.custom.ca.mountPath" . }}/custom-ca.crt
  subPath: custom-ca.crt
  readOnly: true
{{- end -}}

{{- define "styles.custom.ca.jobs.volumes" -}}
- name: custom-ca
  configMap:
    name: {{ include "styles.configmap.jobs.name" . }}
{{- end -}}

{{- define "styles.custom.ca.deploys.volumes" -}}
- name: custom-ca
  configMap:
    name: {{ include "styles.configmap.deploys.name" . }}
{{- end -}}

{{- define "styles.configmap.jobs.name" -}}
{{ include "styles.name" . }}-configmap-jobs
{{- end -}}

{{- define "styles.configmap.deploys.name" -}}
{{ include "styles.name" . }}-configmap-deploys
{{- end -}}
