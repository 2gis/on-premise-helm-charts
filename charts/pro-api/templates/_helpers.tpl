{{- define "pro-api.name" -}}
{{- if .Values.api.pod.fullnameOverride -}}
{{- .Values.api.pod.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Values.api.appName .Values.api.pod.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "pro-api.permissions-name" -}}
{{ include "pro-api.name" . }}-permissions
{{- end -}}

{{- define "pro-api.tasks-name" -}}
{{ include "pro-api.name" . }}-tasks
{{- end -}}

{{- define "pro-api.permissions-url" -}}
{{- if .Values.permissions.settings.host -}}
{{- .Values.permissions.settings.host -}}
{{- else -}}
{{- "http://" -}}
{{ include "pro-api.permissions-name" . }}
{{- end -}}
{{- end -}}

{{- define "pro-api.asset-importer-name" -}}
{{- $name := default .Values.assetImporter.appName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "pro-api.asset-preparer-name" -}}
{{- $name := default .Values.assetPreparer.appName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "pro-api.service-account-name" -}}
{{- if empty .Values.api.service.serviceAccountOverride }}
  {{- $name := default .Values.api.service.serviceAccount -}}
  {{- if contains $name .Release.Name -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- else -}}
  {{- .Values.api.service.serviceAccountOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "pro-api.chart" -}}
{{- printf "%s-%s" .Values.api.appName .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pro-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pro-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "pro-api.permissionsSelectorLabels" -}}
app.kubernetes.io/name: {{ include "pro-api.permissions-name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}-permissions
{{- end -}}

{{- define "pro-api.tasksApiSelectorLabels" -}}
app.kubernetes.io/name: {{ include "pro-api.tasks-name" . }}-api
app.kubernetes.io/instance: {{ .Release.Name }}-tasks-api
{{- end -}}

{{- define "pro-api.tasksWorkerSelectorLabels" -}}
app.kubernetes.io/name: {{ include "pro-api.tasks-name" . }}-worker
app.kubernetes.io/instance: {{ .Release.Name }}-tasks-worker
{{- end -}}

{{- define "pro-api.labels" -}}
helm.sh/chart: {{ include "pro-api.chart" . }}
{{ include "pro-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "pro-api.permissionLabels" -}}
helm.sh/chart: {{ include "pro-api.chart" . }}
{{ include "pro-api.permissionsSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "pro-api.tasksApiLabels" -}}
helm.sh/chart: {{ include "pro-api.chart" . }}
{{ include "pro-api.tasksApiSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "pro-api.tasksWorkerLabels" -}}
helm.sh/chart: {{ include "pro-api.chart" . }}
{{ include "pro-api.tasksWorkerSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "pro-api.connectionString" -}}
{{-  printf "Server=%s;Port=%d;Database=%s;UID=%s;Pooling=True;Minimum Pool Size=%d;Maximum Pool Size=%d;Timeout=%d;Connection Idle Lifetime=30;KeepAlive=5;"
	(.Values.postgres.api.rw.host | required "A valid .Values.postgres.api.rw.host entry required!")
	(.Values.postgres.api.rw.port | required "A valid .Values.postgres.api.rw.port entry required!" | int)
	(.Values.postgres.api.rw.name | required "A valid .Values.postgres.api.rw.name entry required!")
	(.Values.postgres.api.rw.username | required "A valid .Values.postgres.api.rw.username entry required!")
	((.Values.postgres.api.rw.poolSize).min | int | default 1)
	((.Values.postgres.api.rw.poolSize).max | int | default 10)
	(.Values.postgres.api.rw.timeout | int | default 15)
-}}
{{- end -}}

{{- define "pro-api.connectionStringReadOnly" -}}
{{- if .Values.postgres.api.ro -}}
{{- printf "Server=%s;Port=%d;Database=%s;UID=%s;Pooling=True;Minimum Pool Size=%d;Maximum Pool Size=%d;Timeout=%d;Connection Idle Lifetime=30;KeepAlive=5;"
	(.Values.postgres.api.ro.host | required "A valid .Values.postgres.api.ro.host entry required!")
	(.Values.postgres.api.ro.port | required "A valid .Values.postgres.api.ro.port entry required!" | int)
	(.Values.postgres.api.ro.name | required "A valid .Values.postgres.api.ro.name entry required!")
	(.Values.postgres.api.ro.username | required "A valid .Values.postgres.api.ro.username entry required!")
	((.Values.postgres.api.ro.poolSize).min | int | default 1)
	((.Values.postgres.api.ro.poolSize).max | int | default 10)
	(.Values.postgres.api.ro.timeout | int | default 15)
-}}
{{- else -}}
{{ print "" }}
{{- end -}}
{{- end -}}

{{- define "pro-permissions-api.connectionString" -}}
{{-  printf "Server=%s;Port=%d;Database=%s;UID=%s;Pooling=True;Minimum Pool Size=%d;Maximum Pool Size=%d;Timeout=%d;Connection Idle Lifetime=30;KeepAlive=5;"
	(.Values.postgres.permissions.rw.host | required "A valid .Values.postgres.permissions.rw.host entry required!")
	(.Values.postgres.permissions.rw.port | required "A valid .Values.postgres.permissions.rw.port entry required!" | int)
	(.Values.postgres.permissions.rw.name | required "A valid .Values.postgres.permissions.rw.name entry required!")
	(.Values.postgres.permissions.rw.username | required "A valid .Values.postgres.permissions.rw.username entry required!")
	((.Values.postgres.permissions.rw.poolSize).min | int | default 1)
	((.Values.postgres.permissions.rw.poolSize).max | int | default 10)
	(.Values.postgres.permissions.rw.timeout | int | default 15)
-}}
{{- end -}}

{{- define "pro-permissions-api.connectionStringReadOnly" -}}
{{- if .Values.postgres.permissions.ro -}}
{{- printf "Server=%s;Port=%d;Database=%s;UID=%s;Pooling=True;Minimum Pool Size=%d;Maximum Pool Size=%d;Timeout=%d;Connection Idle Lifetime=30;KeepAlive=5;"
	(.Values.postgres.permissions.ro.host | required "A valid .Values.postgres.permissions.ro.host entry required!")
	(.Values.postgres.permissions.ro.port | required "A valid .Values.postgres.permissions.ro.port entry required!" | int)
	(.Values.postgres.permissions.ro.name | required "A valid .Values.postgres.permissions.ro.name entry required!")
	(.Values.postgres.permissions.ro.username | required "A valid .Values.postgres.permissions.ro.username entry required!")
	((.Values.postgres.permissions.ro.poolSize).min | int | default 1)
	((.Values.postgres.permissions.ro.poolSize).max | int | default 10)
	(.Values.postgres.permissions.ro.timeout | int | default 15)
-}}
{{- else -}}
{{ print "" }}
{{- end -}}
{{- end -}}

{{- define "pro-tasks.connectionString" -}}
{{- if .Values.tasks.settings.enabled -}}
{{- printf "Server=%s;Port=%d;Database=%s;UID=%s;Pooling=True;Minimum Pool Size=%d;Maximum Pool Size=%d;Timeout=%d;Connection Idle Lifetime=30;KeepAlive=5;"
	(.Values.postgres.tasks.rw.host | required "A valid .Values.postgres.tasks.rw.host entry required!")
	(.Values.postgres.tasks.rw.port | required "A valid .Values.postgres.tasks.rw.port entry required!" | int)
	(.Values.postgres.tasks.rw.name | required "A valid .Values.postgres.tasks.rw.name entry required!")
	(.Values.postgres.tasks.rw.username | required "A valid .Values.postgres.tasks.rw.username entry required!")
	((.Values.postgres.tasks.rw.poolSize).min | int | default 1)
	((.Values.postgres.tasks.rw.poolSize).max | int | default 5)
	(.Values.postgres.tasks.rw.timeout | int | default 15)
-}}
{{- else -}}
{{ print "" }}
{{- end -}}
{{- end -}}

{{/*
Manifest name
*/}}
{{- define "pro-api.manifestCode" -}}
{{- base .Values.dgctlStorage.manifest | trimSuffix ".json" }}
{{- end }}
