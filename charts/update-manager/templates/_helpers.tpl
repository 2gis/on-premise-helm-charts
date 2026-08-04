{{- define "update-manager.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "update-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "update-manager.labels" -}}
{{ include "update-manager.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ include "update-manager.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "update-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "update-manager.checksum" -}}
{{ (include (print $.Template.BasePath .path) $ | fromYaml).data | toYaml | sha256sum }}
{{- end }}

{{- define "update-manager.image" -}}
{{ required "Valid .Values.dgctlDockerRegistry required!" .Values.dgctlDockerRegistry }}/{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}
{{- end }}

{{- define "update-manager.migrate.name" -}}
{{ include "update-manager.name" . }}-migrate
{{- end }}

{{/*
PostgreSQL tls params
*/}}

{{- define "update-manager.psql.checks" -}}
{{- if has .Values.postgres.tls.mode (list "verify-ca" "verify-full") }}
{{ $testVar := required "You should set .Values.postgres.tls.serverCA for selected mode" .Values.postgres.tls.rootCert }}
{{- end }}
{{- if eq .Values.postgres.tls.mode "verify-full" }}
{{ $testVar := required "You should set .Values.postgres.tls.clientCert for selected mode" .Values.postgres.tls.cert }}
{{ $testVar = required "You should set .Values.postgres.tls.clientKey for selected mode" .Values.postgres.tls.key }}
{{- end }}
{{- end -}}

{{- define "update-manager.psql.params" -}}
- "sslmode={{ .Values.postgres.tls.mode }}"
{{- if has .Values.postgres.tls.mode (list "verify-ca" "verify-full") }}
- "sslrootcert=/etc/ssl/psql/psql-server-ca.crt"
{{- end }}
{{- if eq .Values.postgres.tls.mode "verify-full" }}
- "sslkey=/etc/ssl/psql/psql-client.key"
- "sslcert=/etc/ssl/psql/psql-client.crt"
{{- end }}
{{- end }}

{{- define "update-manager.psql.volumeMounts" -}}
{{- if has .Values.postgres.tls.mode (list "verify-ca" "verify-full") -}}
- name: tls
  mountPath: /etc/ssl/psql
{{- end }}
{{- end -}}

{{- define "update-manager.psql.volumes" -}}
{{- if has .Values.postgres.tls.mode (list "verify-ca" "verify-full") -}}
- name: tls-raw
  secret:
    secretName: {{ include "update-manager.name" . }}-psql-tls
    items:
    {{- if has .Values.postgres.tls.mode (list "verify-ca" "verify-full") }}
    {{- if .Values.postgres.tls.rootCert }}
      - key: psql-server-ca.crt
        path: psql-server-ca.crt
    {{- end }}
    {{- if has .Values.postgres.tls.mode (list "verify-full") }}
    {{- if .Values.postgres.tls.key }}
      - key: psql-client.key
        path: psql-client.key
    {{- end }}
    {{- if .Values.postgres.tls.cert }}
      - key: psql-client.crt
        path: psql-client.crt
    {{- end }}
    {{- end }}
    {{- end }}
- name: tls
  emptyDir: {}
{{- end }}
{{- end -}}

{{- define "update-manager.psql.initTLS" -}}
{{- if has .Values.postgres.tls.mode (list "verify-ca" "verify-full") -}}
- name: copy-certs
  image: {{ include "update-manager.image" . }}
  command:
    - /bin/sh
    - -c
    - |-
      cp /tls/* /etc/ssl/psql/
      chmod 0400 /etc/ssl/psql/psql-ro-client.key
      chmod 0400 /etc/ssl/psql/psql-rw-client.key
  resources:
    requests:
      cpu: 20m
      memory: 16Mi
    limits:
      cpu: 20m
      memory: 16Mi
  volumeMounts:
    - name: tls-raw
      mountPath: /tls
    - name: tls
      mountPath: /etc/ssl/psql
{{- end -}}
{{- end -}}

{{/*
DGCTL params
*/}}

{{- define "update-manager.dgctlImage" -}}
{{- if .Values.dgctlDockerRegistry }}
{{- print .Values.dgctlDockerRegistry "/" -}}
{{- end }}
{{- required "Valid .Values.api.dgctl.image.repository required!" .Values.api.dgctl.image.repository -}}
{{- if .Values.api.dgctl.image.tag }}
{{- print ":" .Values.api.dgctl.image.tag -}}
{{- end }}
{{- end }}

{{/*
Custom CA helpers
*/}}

{{- define "update-manager.ca.mountPath" -}}
{{ .Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}

{{- define "update-manager.ca.volumeMounts" -}}
{{- if .Values.customCAs.bundle -}}
- name: custom-ca
  mountPath: {{ include "update-manager.ca.mountPath" . }}/custom-ca.crt
  subPath: custom-ca.crt
  readOnly: true
{{- end -}}
{{- end -}}

{{- define "update-manager.ca.volumes" -}}
{{- if .Values.customCAs.bundle -}}
- name: custom-ca
  configMap:
    name: {{ include "update-manager.name" . }}-ca
{{- end -}}
{{- end -}}

{{- define "update-manager.ca.migrate.volumes" -}}
{{- if .Values.customCAs.bundle -}}
- name: custom-ca
  configMap:
    name: {{ include "update-manager.migrate.name" . }}-ca
{{- end -}}
{{- end -}}
