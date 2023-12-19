{{/*
Expand the name of the chart.
*/}}
{{- define "license.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "license.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := include "license.name" $ }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "license.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "license.labels" -}}
helm.sh/chart: {{ include "license.chart" . }}
{{ include "license.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "license.selectorLabels" -}}
app.kubernetes.io/name: {{ include "license.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
License type
*/}}
{{- define "license.type" -}}
{{ required "A valid $.Values.license.type from DGCTL-generated values is required" .Values.license.type | int }}
{{- end }}

{{/*
StatefulSet replicas count
*/}}
{{- define "license.replicaCount" -}}
{{- if eq (include "license.type" .) "1" -}}
1
{{- else if eq (include "license.type" .) "2" -}}
2
{{- end }}
{{- end }}

{{/*
Service account name
*/}}
{{- define "license.serviceAccount" -}}
{{- if empty $.Values.serviceAccountOverride }}
{{- include "license.fullname" . }}
{{- else }}
{{- $.Values.serviceAccountOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Checksum for configmap or secret
*/}}
{{- define "license.checksum" -}}
{{ (include (print $.Template.BasePath .path) $ | fromYaml).data | toYaml | sha256sum }}
{{- end }}

{{/*
Converts duration (1h2m3s) to integer seconds, accepts { duration: <duration> }
*/}}
{{- define "license.durationToSeconds" -}}
{{- $now := now -}}
{{- $add := $now | dateModify .duration -}}
{{ sub ($add | unixEpoch) ($now | unixEpoch) }}
{{- end -}}

{{/*
Mount directory for custom CA
*/}}
{{- define "license.customCA.mountPath" -}}
{{ $.Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}
