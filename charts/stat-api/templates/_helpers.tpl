{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "stat-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "stat-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "stat-api.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a component-specific name by combining the fullname with a component suffix.
Usage: {{ include "stat-api.componentname" (dict "global" $ "component" "api") }}
*/}}
{{- define "stat-api.componentname" -}}
{{- $global := required "Global cursor is required in dict!" (get . "global") -}}
{{- $component := required "Component name is required in dict!" (get . "component") | trimPrefix "-" -}}
{{- $fullname := include "stat-api.fullname" $global -}}
{{- $suffix := printf "-%s" $component -}}
{{- if hasSuffix $suffix $fullname -}}
{{- $fullname -}}
{{- else -}}
{{- printf "%s%s" ($fullname | trunc (sub 62 (len $component) | int) | trimSuffix "-") $suffix | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels for all resources.
Usage: {{ include "stat-api.labels" (dict "global" $) }} or {{ include "stat-api.labels" (dict "global" $ "component" "api") }}
*/}}
{{- define "stat-api.labels" -}}
{{- $global := required "Global cursor is required in dict!" (get . "global") -}}
{{- $component := get . "component" -}}
{{- include "stat-api.selectorLabels" (dict "global" $global "component" $component) }}
helm.sh/chart: {{ include "stat-api.chart" $global }}
app.kubernetes.io/managed-by: {{ index $global "Release" "Service" }}
app.kubernetes.io/version: {{ $global.Chart.AppVersion | replace "+" "_" }}
app.kubernetes.io/part-of: {{ $global.Chart.Name }}
{{- end -}}

{{/*
Selector labels for matching pods to services.
Usage: {{ include "stat-api.selectorLabels" (dict "global" $) }} or {{ include "stat-api.selectorLabels" (dict "global" $ "component" "api") }}
*/}}
{{- define "stat-api.selectorLabels" -}}
{{- $global := required "Global cursor is required in dict!" (get . "global") -}}
{{- $component := get . "component" -}}
app.kubernetes.io/name: {{ include "stat-api.name" $global }}
app.kubernetes.io/instance: {{ index $global "Release" "Name" }}
{{- with $component }}
app.kubernetes.io/component: {{ . }}
{{- end }}
{{- end -}}

{{/*
Create the name of the service account to use.
*/}}
{{- define "stat-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "stat-api.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create image path from registry, repository, and tag.
Usage: {{ include "stat-api.image" (dict "global" $ "component" "api") }}
*/}}
{{- define "stat-api.image" -}}
{{- $global := required "A valid global must be provided" .global -}}
{{- $component := required "A valid component must be provided" .component -}}
{{ required "A valid .Values.dgctlDockerRegistry entry required" $global.Values.dgctlDockerRegistry }}/{{ index $global.Values $component "image" "repository" }}:{{ index $global.Values $component "image" "tag" }}
{{- end }}

{{/*
Validate ClickHouse TLS configuration.
*/}}
{{- define "stat-api.tls.clickhouse.checks" -}}
{{- if .Values.clickhouse.tls.enabled }}
{{- if and .Values.clickhouse.tls.clientCert (not .Values.clickhouse.tls.clientKey) }}
{{ required "You should set .Values.clickhouse.tls.clientKey when .Values.clickhouse.tls.clientCert is provided" .Values.clickhouse.tls.clientKey }}
{{- else if and .Values.clickhouse.tls.clientKey (not .Values.clickhouse.tls.clientCert) }}
{{ required "You should set .Values.clickhouse.tls.clientCert when .Values.clickhouse.tls.clientKey is provided" .Values.clickhouse.tls.clientCert }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Initialize ClickHouse TLS certificates in an init container.
Copies TLS certificates from mounted secrets to the container filesystem.
*/}}
{{- define "stat-api.clickhouse.initTLS" -}}
{{- if and
  .Values.clickhouse.tls.enabled
  (or
    .Values.clickhouse.tls.serverCA
    (and .Values.clickhouse.tls.clientCert .Values.clickhouse.tls.clientKey)
  ) -}}
- name: copy-certs
  image: "{{ include "stat-api.image" (dict "global" . "component" "api") }}"
  command:
    - /bin/sh
    - -c
    - |-
      {{- if .Values.clickhouse.tls.serverCA }}
      cp /clickhouse-tls/server-ca.crt /etc/ssl/clickhouse/
      {{- end }}
      {{- if and .Values.clickhouse.tls.clientCert .Values.clickhouse.tls.clientKey }}
      cp /clickhouse-tls/client.crt /etc/ssl/clickhouse/
      cp /clickhouse-tls/client.key /etc/ssl/clickhouse/
      chmod 0400 /etc/ssl/clickhouse/client.key
      {{- end }}
  resources:
    requests:
      cpu: 20m
      memory: 16Mi
    limits:
      cpu: 20m
      memory: 16Mi
  volumeMounts:
    - name: clickhouse-tls-raw
      mountPath: /clickhouse-tls
    - name: clickhouse-tls
      mountPath: /etc/ssl/clickhouse
{{- end -}}
{{- end -}}

{{/*
Volume mount for ClickHouse TLS certificates.
Mounts the TLS certificate directory in containers that need it.
*/}}
{{- define "stat-api.clickhouse.volumeMount" -}}
{{- if and
  .Values.clickhouse.tls.enabled
  (or
    .Values.clickhouse.tls.serverCA
    (and .Values.clickhouse.tls.clientCert .Values.clickhouse.tls.clientKey)
  ) -}}
- name: clickhouse-tls
  mountPath: /etc/ssl/clickhouse
{{- end }}
{{- end -}}

{{/*
Volume definition for ClickHouse TLS certificates.
Defines both the secret volume and empty directory for processed certificates.
*/}}
{{- define "stat-api.clickhouse.volume" -}}
{{- if and
  .Values.clickhouse.tls.enabled
  (or
    .Values.clickhouse.tls.serverCA
    (and .Values.clickhouse.tls.clientCert .Values.clickhouse.tls.clientKey)
  ) -}}
- name: clickhouse-tls-raw
  secret:
    secretName: {{ include "stat-api.componentname" (dict "global" $ "component" "clickhouse-tls") }}
    items:
      {{- if .Values.clickhouse.tls.serverCA }}
      - key: server-ca.crt
        path: server-ca.crt
      {{- end }}
      {{- if and .Values.clickhouse.tls.clientCert .Values.clickhouse.tls.clientKey }}
      - key: client.key
        path: client.key
      - key: client.crt
        path: client.crt
      {{- end }}
- name: clickhouse-tls
  emptyDir: {}
{{- end }}
{{- end -}}

{{/*
Environment variable for custom CA path.
*/}}
{{- define "stat-api.env.custom.ca.path" -}}
- name: SSL_CERT_DIR
  value: {{ include "stat-api.custom.ca.mountPath" . }}
{{- end }}

{{/*
Get the mount path for custom CA certificates.
Returns the custom path or default system path.
*/}}
{{- define "stat-api.custom.ca.mountPath" -}}
{{ .Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}

{{/*
Volume mount for custom CA certificates.
Mounts the custom CA bundle as a single file.
*/}}
{{- define "stat-api.custom.ca.volumeMounts" -}}
- name: custom-ca
  mountPath: {{ include "stat-api.custom.ca.mountPath" . }}/custom-ca.crt
  subPath: custom-ca.crt
  readOnly: true
{{- end -}}

{{/*
Volume definition for custom CA certificates.
*/}}
{{- define "stat-api.custom.ca.volumes" -}}
- name: custom-ca
  configMap:
    name: {{ include "stat-api.componentname" (dict "global" $ "component" "custom-ca") }}
{{- end -}}

{{/*
Environment variables for the API service.
*/}}
{{- define "stat-api.env.api" -}}
- name: STAT_CLICKHOUSE_CLIENT_NAME
  value: "{{ .Values.api.clickhouse.clientName }}"
- name: STAT_LOG_LEVEL
  value: "{{ .Values.api.logLevel }}"
{{- end }}

{{/*
Environment variables for the migrate job.
*/}}
{{- define "stat-api.env.migrate" -}}
- name: STAT_CLICKHOUSE_CLIENT_NAME
  value: "{{ .Values.migrate.clickhouse.clientName }}"
- name: STAT_LOG_LEVEL
  value: "{{ .Values.migrate.logLevel }}"
- name: STAT_KAFKA_TABLE_ENGINE_BROKERS
  value: "{{ .Values.migrate.kafkaTableEngine.brokers }}"
- name: STAT_KAFKA_TABLE_ENGINE_TOPIC
  value: "{{ .Values.migrate.kafkaTableEngine.topic }}"
- name: STAT_KAFKA_TABLE_ENGINE_GROUP_NAME
  value: "{{ .Values.migrate.kafkaTableEngine.group }}"
{{- end }}

{{/*
Environment variables for ClickHouse connection.
*/}}
{{- define "stat-api.env.clickhouse" -}}
- name: STAT_CLICKHOUSE_SERVERS
  value: {{ required "Valid .Values.clickhouse.servers required!" .Values.clickhouse.servers | quote }}
- name: STAT_CLICKHOUSE_CLUSTER
  value: "{{ .Values.clickhouse.cluster }}"
- name: STAT_CLICKHOUSE_DB
  value: {{ required "Valid .Values.clickhouse.database required!" .Values.clickhouse.database | quote }}
- name: STAT_CLICKHOUSE_USER
  value: {{ required "Valid .Values.clickhouse.username required!" .Values.clickhouse.username | quote }}
- name: STAT_CLICKHOUSE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "stat-api.componentname" (dict "global" $ "component" "clickhouse") }}
      key: password
- name: STAT_CLICKHOUSE_MAX_EXECUTION_TIME
  value: "{{ .Values.clickhouse.maxQueryExecutionTime }}"
- name: STAT_CLICKHOUSE_MAX_OPEN_CONNS
  value: "{{ .Values.clickhouse.maxOpenConnections }}"
- name: STAT_CLICKHOUSE_MAX_IDLE_CONNS
  value: "{{ .Values.clickhouse.maxIdleConnections }}"
- name: STAT_CLICKHOUSE_CONN_TIMEOUT
  value: "{{ .Values.clickhouse.connectionTimeout }}"
- name: STAT_CLICKHOUSE_CONN_MAX_LIFETIME
  value: "{{ .Values.clickhouse.connectionMaxLifetime }}"
- name: STAT_CLICKHOUSE_CONNECTION_OPEN_STRATEGY
  value: "{{ .Values.clickhouse.connectionOpenStrategy }}"
- name: STAT_CLICKHOUSE_PING_MAX_RETRIES
  value: "{{ .Values.clickhouse.pingMaxRetries }}"
- name: STAT_CLICKHOUSE_PING_RETRY_DELAY
  value: "{{ .Values.clickhouse.pingRetryDelay }}"
- name: STAT_CLICKHOUSE_TLS_ENABLED
  value: "{{ .Values.clickhouse.tls.enabled }}"
{{- if .Values.clickhouse.tls.enabled }}
{{- if and .Values.clickhouse.tls.clientCert .Values.clickhouse.tls.clientKey }}
- name: STAT_CLICKHOUSE_TLS_CLIENT_CERTIFICATE_PATH
  value: "/etc/ssl/clickhouse/client.crt"
- name: STAT_CLICKHOUSE_TLS_CLIENT_KEY_PATH
  value: "/etc/ssl/clickhouse/client.key"
{{- end }}
{{- if .Values.clickhouse.tls.serverCA }}
- name: STAT_CLICKHOUSE_TLS_CA_CERT_PATH
  value: "/etc/ssl/clickhouse/server-ca.crt"
{{- end }}
- name: STAT_CLICKHOUSE_TLS_SKIP_SERVER_CERTIFICATE_VERIFY
  value: "{{ .Values.clickhouse.tls.skipServerCertificateVerify }}"
{{- end }}
{{- end }}

{{/*
Return the target Kubernetes version.
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
Return the appropriate API version for Horizontal Pod Autoscaler.
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
