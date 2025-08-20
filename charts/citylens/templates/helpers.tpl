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

{{- define "citylens.detections-localizer.name" -}}
{{ include "citylens.name" . }}-detections-localizer
{{- end }}

{{- define "citylens.lifecycle-controller.name" -}}
{{ include "citylens.name" . }}-lifecycle-controller
{{- end }}

{{- define "citylens.dashboard-batch-events.name" -}}
{{ include "citylens.name" . }}-dashboard-batch-events
{{- end }}

{{- define "citylens.jobs.proFilterUpdate.name" -}}
{{ include "citylens.name" . }}-profilters-job
{{- end }}

{{- define "citylens.jobs.predictorsSync.name" -}}
{{ include "citylens.name" . }}-predictorssync-job
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

{{- define "citylens.detections-localizer.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.detections-localizer.name" . }}
{{- end }}

{{- define "citylens.detections-localizer.labels" -}}
{{ include "citylens.detections-localizer.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.lifecycle-controller.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.lifecycle-controller.name" . }}
{{- end }}

{{- define "citylens.lifecycle-controller.labels" -}}
{{ include "citylens.lifecycle-controller.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.migration.labels" -}}
app.kubernetes.io/name: {{ include "citylens.api.name" . }}
app.kubernetes.io/instance: {{ .Chart.Name }}-db-migration
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.jobs.proFiltersUpdate.labels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.jobs.proFilterUpdate.name" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "citylens.jobs.predictorsSync.labels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "citylens.jobs.predictorsSync.name" . }}
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

{{- define "citylens.env.dsLibrariesNumThreads" -}}
1
{{- end }}

{{- define "citylens.env.dsLibrariesEnvs" -}}
- name: OMP_NUM_THREADS
  value: {{ include "citylens.env.dsLibrariesNumThreads" . | squote }}
- name: OPENBLAS_NUM_THREADS
  value: {{ include "citylens.env.dsLibrariesNumThreads" . | squote }}
- name: MKL_NUM_THREADS
  value: {{ include "citylens.env.dsLibrariesNumThreads" . | squote }}
- name: BLIS_NUM_THREADS
  value: {{ include "citylens.env.dsLibrariesNumThreads" . | squote }}
- name: VECLIB_MAXIMUM_THREADS
  value: {{ include "citylens.env.dsLibrariesNumThreads" . | squote }}
- name: NUMBA_NUM_THREADS
  value: {{ include "citylens.env.dsLibrariesNumThreads" . | squote }}
- name: NUMEXPR_NUM_THREADS
  value: {{ include "citylens.env.dsLibrariesNumThreads" . | squote }}
{{- end}}

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

{{/*
Citylens routes chart name
*/}}

{{- define "app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Citylens routes name defines
*/}}

{{- define "citylens.routes" -}}
{{ include "citylens.name" . }}-routes
{{- end -}}

{{- define "citylens.routes.api.name" -}}
{{ include "citylens.routes" . }}{{- printf "-%s-%s" "api" .Values.routes.environment | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "citylens.routes.worker.name" -}}
{{ include "citylens.routes" . }}{{- printf "-%s-%s" "worker" .Values.routes.environment | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "citylens.routes.realtimeDataApi.name" -}}
{{ include "citylens.routes" . }}{{- printf "-%s-%s" "realtime-data-api" .Values.routes.environment | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "citylens.routes.migration.name" -}}
{{ include "citylens.routes" . }}{{- printf "-%s-%s" "migration" .Values.routes.environment | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Citylens routes deployment labels
*/}}

{{- define "citylens.routes.api.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name | quote }}
app.kubernetes.io/instance: {{ include "citylens.routes.api.name" . | quote }}
{{- end -}}

{{- define "citylens.routes.worker.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name | quote }}
app.kubernetes.io/instance: {{ include "citylens.routes.worker.name" . | quote }}
{{- end -}}

{{- define "citylens.routes.realtimeDataApi.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name | quote }}
app.kubernetes.io/instance: {{ include "citylens.routes.realtimeDataApi.name" . | quote }}
{{- end -}}

{{- define "citylens.routes.api.labels" -}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "citylens.routes.api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end -}}

{{- define "citylens.routes.worker.labels" -}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "citylens.routes.worker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end -}}

{{- define "citylens.routes.realtimeDataApi.labels" -}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "citylens.routes.realtimeDataApi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end -}}

{{- define "citylens.routes.migration.labels" -}}
app.kubernetes.io/name: {{ .Release.Name | quote }}
app.kubernetes.io/instance: {{ include "citylens.routes.migration.name" . | quote }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end -}}

{{/*
Manifest name
*/}}
{{- define "citylens.manifestCode" -}}
{{- base .Values.dgctlStorage.manifest | trimSuffix ".json" }}
{{- end }}
