{{- define "tiles.chart" -}}
{{ $.Chart.Name }}-{{ $.Chart.Version | replace "+" "_" }}
{{- end }}

{{- define "tiles.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tiles.name" . | quote}}
app.kubernetes.io/instance: {{ $.Release.Name | quote }}
{{- end }}

{{- define "tiles.labels" -}}
{{ include "tiles.selectorLabels" . }}
{{- if $.Chart.AppVersion }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ include "tiles.chart" . | quote }}
{{- end -}}

{{- define "tiles.api.label" -}}
app.kubernetes.io/component: api
{{- end -}}

{{- define "tiles.manifestCode" -}}
{{- base .Values.dgctlStorage.manifest | trimSuffix ".json" }}
{{- end }}

{{- define "tiles.name" -}}
{{- default $.Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tiles.fullname" -}}
{{- if $.Values.fullnameOverride }}
{{- $.Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "tiles.kind" -}}
{{- if .subtype }}
{{- .kind }}_{{ .subtype }}
{{- else }}
{{- .kind }}
{{- end }}
{{- end }}

{{- define "tiles.keyspace" -}}
{{- if .keyspace }}
{{- .keyspace }}
{{- else -}}
ts_{{ include "tiles.kind" $ | replace "-" "_"}}_{{ required "Valid .Values.cassandra.environment required" $.Values.cassandra.environment }}_{{ include "tiles.manifestCode" $ }}
{{- end -}}
{{- end -}}

{{- define "tiles.type" -}}
{{- if .subtype -}}
ald
{{- else if has .kind (list "web" "native" "native-v4-detailed" "native-v4-general" "native-v4-universe") -}}
vector
{{- else if eq .kind "raster" -}}
raster
{{- else if eq .kind "mapbox" -}}
mapbox
{{- end -}}
{{- end -}}

{{- define "tiles.checksum" -}}
{{ (include (print $.Template.BasePath .path) $ | fromYaml).data | toYaml | sha256sum }}
{{- end }}

{{- define "tiles.customCA.mountPath" -}}
{{ $.Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}

{{/* Importer */}}

{{- define "tiles.importer.label" -}}
app.kubernetes.io/component: importer
{{- end -}}

{{- define "importer.serviceName" -}}
{{- if eq . "web" -}}
tiles-api-vector
{{- else if eq . "raster" -}}
tiles-api-raster
{{- else if has . (list "native" "native-v4-detailed" "native-v4-general" "native-v4-universe") -}}
tiles-api-mobile-sdk
{{- else if eq . "mapbox" -}}
tiles-api-mapbox
{{- end -}}
{{- end -}}

{{- define "importer.types" -}}
{{- if .subtype -}}
- {{ .subtype }}
{{- else if has .kind (list "web" "native") -}}
- vtiles
- poiicons
{{- else if eq .kind "native-v4-detailed" -}}
- vtiles_v4_detailed
- poiicons_v4_detailed
{{- else if eq .kind "native-v4-general" -}}
- vtiles_v4_general
- poiicons_v4_general
{{- else if eq .kind "native-v4-universe" -}}
- vtiles_v4_universe
{{- else if eq .kind "raster" -}}
- tiles
{{- else if eq .kind "mapbox" -}}
- mapbox
{{- end -}}
{{- end -}}

{{- define "importer.hook-annotations" -}}
"helm.sh/hook": pre-install,pre-upgrade
{{- end -}}

{{- define "importer.removable-hook-annotations" -}}
{{- include "importer.hook-annotations" . }}
"helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
{{- end -}}

{{- define "importer.serviceAccount" -}}
{{- if empty $.Values.importer.serviceAccountOverride }}
{{- include "tiles.fullname" . }}
{{- else }}
{{- $.Values.importer.serviceAccountOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/* Cleaner */}}

{{- define "tiles.cleaner.label" -}}
app.kubernetes.io/component: cleaner
{{- end -}}

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

{{/* Tilegen */}}

{{- define "tiles.tilegen.label" -}}
app.kubernetes.io/component: tilegen
{{- end -}}

{{- define "tilegen.serviceAccount" -}}
{{- if empty $.Values.tilegen.serviceAccountOverride }}
{{- include "tiles.fullname" . }}
{{- else }}
{{- $.Values.tilegen.serviceAccountOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "tiles.tls.secretName" -}}
{{- if $.Values.cassandra.tls.existingSecret.name }}
{{- $.Values.cassandra.tls.existingSecret.name }}
{{- else }}
{{- include "tiles.fullname" . }}-tls
{{- end }}
{{- end }}

{{- define "tiles.tls.mountSecret" -}}
{{ or $.Values.cassandra.tls.deploySecret (not (empty $.Values.cassandra.tls.existingSecret.name)) }}
{{- end }}

{{/*
Expand native-v4 kind into two separate tilesets: native-v4-universe, native-v4-detailed and native-v4-general.
All other kinds are passed through unchanged.
Usage: range (include "tiles.expandedTypes" $ | fromYaml).list
*/}}
{{- define "tiles.expandedTypes" -}}
list:
  {{- range $.Values.types }}
  {{- if eq .kind "native-v4" }}
  - kind: "native-v4-detailed"
    name: {{ .name | default "" | quote }}
    subtype: {{ .subtype | default "" | quote }}
    keyspace: {{ .keyspace | default "" | quote }}
    importAndCleanerDisabled: {{ .importAndCleanerDisabled | default false }}
  - kind: "native-v4-general"
    name: {{ .name | default "" | quote }}
    subtype: {{ .subtype | default "" | quote }}
    keyspace: {{ .keyspace | default "" | quote }}
    importAndCleanerDisabled: {{ .importAndCleanerDisabled | default false }}
  - kind: "native-v4-universe"
    name: {{ .name | default "" | quote }}
    subtype: {{ .subtype | default "" | quote }}
    keyspace: {{ .keyspace | default "" | quote }}
    importAndCleanerDisabled: {{ .importAndCleanerDisabled | default false }}
  {{- else }}
  - kind: {{ .kind | quote }}
    name: {{ .name | default "" | quote }}
    subtype: {{ .subtype | default "" | quote }}
    keyspace: {{ .keyspace | default "" | quote }}
    importAndCleanerDisabled: {{ .importAndCleanerDisabled | default false }}
  {{- end }}
  {{- end }}
{{- end -}}
