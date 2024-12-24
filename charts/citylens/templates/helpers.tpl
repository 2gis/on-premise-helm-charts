{{/*
Expand the name of the chart.
*/}}
{{- define "citylens.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "citylens.api.name" -}}
{{ include "citylens.name" . }}-api
{{- end }}

{{- define "citylens.web.name" -}}
{{ include "citylens.name" . }}-web
{{- end }}

{{- define "citylens.camcom-sender.name" -}}
{{ include "citylens.name" . }}-camcom-sender
{{- end }}

{{- define "citylens.frames-saver.name" -}}
{{ include "citylens.name" . }}-frames-saver
{{- end }}

{{- define "citylens.logs-saver.name" -}}
{{ include "citylens.name" . }}-logs-saver
{{- end }}

{{- define "citylens.map-matcher.name" -}}
{{ include "citylens.name" . }}-map-matcher
{{- end }}

{{- define "citylens.predictions-saver.name" -}}
{{ include "citylens.name" . }}-predictions-saver
{{- end }}

{{- define "citylens.reporter-pro.name" -}}
{{ include "citylens.name" . }}-reporter-pro
{{- end }}

{{- define "citylens.reporter-pro-tracks.name" -}}
{{ include "citylens.name" . }}-reporter-pro-tracks
{{- end }}

{{- define "citylens.secret.import.name" -}}
{{ include "citylens.name" . }}-import-secret
{{- end }}

{{- define "citylens.track-metadata-saver.name" -}}
{{ include "citylens.name" . }}-track-metadata-saver
{{- end }}

{{- define "citylens.track-reloader.name" -}}
{{ include "citylens.name" . }}-track-reloader
{{- end }}

{{- define "citylens.workers.name" -}}
{{ include "citylens.name" . }}-workers
{{- end }}

{{- define "citylens.dashboard-batch-events.name" -}}
{{ include "citylens.name" . }}-dashboard-batch-events
{{- end }}

{{- define "citylens.configmap.labels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.api.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.api.name" . }}
{{- end }}

{{- define "citylens.api.labels" -}}
{{ include "citylens.api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.web.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.web.name" . }}
{{- end }}

{{- define "citylens.web.labels" -}}
{{ include "citylens.web.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.camcom-sender.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.camcom-sender.name" . }}
{{- end }}

{{- define "citylens.camcom-sender.labels" -}}
{{ include "citylens.camcom-sender.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.frames-saver.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.frames-saver.name" . }}
{{- end }}

{{- define "citylens.frames-saver.labels" -}}
{{ include "citylens.frames-saver.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.logs-saver.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.logs-saver.name" . }}
{{- end }}

{{- define "citylens.logs-saver.labels" -}}
{{ include "citylens.logs-saver.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.map-matcher.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.map-matcher.name" . }}
{{- end }}

{{- define "citylens.map-matcher.labels" -}}
{{ include "citylens.map-matcher.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.predictions-saver.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.predictions-saver.name" . }}
{{- end }}

{{- define "citylens.predictions-saver.labels" -}}
{{ include "citylens.predictions-saver.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.reporter-pro.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.reporter-pro.name" . }}
{{- end }}

{{- define "citylens.reporter-pro-tracks.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.reporter-pro-tracks.name" . }}
{{- end }}

{{- define "citylens.track-reloader.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.track-reloader.name" . }}
{{- end }}

{{- define "citylens.track-reloader.labels" -}}
{{ include "citylens.track-reloader.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.dashboard-batch-events.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.dashboard-batch-events.name" . }}
{{- end }}

{{- define "citylens.dashboard-batch-events.labels" -}}
{{ include "citylens.dashboard-batch-events.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.reporter-pro.labels" -}}
{{ include "citylens.reporter-pro.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.reporter-pro-tracks.labels" -}}
{{ include "citylens.reporter-pro-tracks.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.track-metadata-saver.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.track-metadata-saver.name" . }}
{{- end }}

{{- define "citylens.track-metadata-saver.labels" -}}
{{ include "citylens.track-metadata-saver.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.migration.labels" -}}
app.kubernetes.io/name: {{ include "citylens.api.name" . }}
app.kubernetes.io/instance: {{ .Chart.Name }}-db-migration
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.env.importer" -}}
- name: DGCTL_S3_ENDPOINT
  value: "http{{ if .Values.dgctlStorage.secure }}s{{ end }}://{{ required "A valid Values.dgctlStorage.host entry required" .Values.dgctlStorage.host }}"
- name: DGCTL_S3_VERIFY_SSL
  value: "{{ required "A valid Values.dgctlStorage.verifySsl entry required" .Values.dgctlStorage.verifySsl }}"
- name: DGCTL_S3_BUCKET
  value: "{{ .Values.dgctlStorage.bucket }}"
- name: DGCTL_S3_REGION_NAME
  value: "{{ .Values.dgctlStorage.region }}"
- name: DGCTL_S3_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "citylens.secret.import.name" . }}
      key: dgctlStorageAccessKey
- name: DGCTL_S3_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "citylens.secret.import.name" . }}
      key: dgctlStorageSecretKey
- name: DGCTL_MANIFEST_PATH
  value: "{{ required "A valid .Values.dgctlStorage.manifest entry required" .Values.dgctlStorage.manifest }}"
- name: DGCTL_MANIFEST_APP_NAME
  value: "citylens"
- name: DGCTL_MANIFEST_DATA_TYPE
  value: "data_migration"
{{- end }}

{{/*
Checksum for configmap or secret
*/}}
{{- define "citylens.checksum" -}}
{{ (include (print $.Template.BasePath .path) $ | fromYaml).data | toYaml | sha256sum }}
{{- end }}

{{/*
Mount directory for custom CA
*/}}
{{- define "citylens.customCA.mountPath" -}}
{{ $.Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}

{{/*
Postgres DSN variations
*/}}
{{- define "citylens.pgDSN" -}}
{{- with .Values.postgres -}}
postgresql://{{ required "A valid .Values.postgres.username entry required" .username }}:{{ required "A valid .Values.postgres.password entry required" .password }}@{{ required "A valid .Values.postgres.host entry required" .host }}:{{ required "A valid .Values.postgres.port entry required" .port }}/{{ required "A valid .Values.postgres.database entry required" .database }}
{{- end -}}
{{- end -}}

{{- define "citylens.pgDSN.asyncpg" -}}
{{ include "citylens.pgDSN" . | replace "postgresql://" "postgresql+asyncpg://" }}
{{- end -}}

{{/*
S3 key templates for frames & frames crops
*/}}
{{- define "citylens.s3_constants.frame_key_template" -}}
{track_uuid}/{frame_timestamp_ms}.jpg
{{- end -}}

{{- define "citylens.s3_constants.crop_frame_key_template" -}}
{track_uuid}/{frame_timestamp_ms}_{theta}.jpg
{{- end -}}
