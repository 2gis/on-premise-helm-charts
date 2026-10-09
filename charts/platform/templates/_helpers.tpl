{{- define "platform.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "platform.ui.name" -}}
{{ include "platform.name" . }}
{{- end }}

{{- define "platform.serviceAccountName" -}}
{{- if .Values.serviceAccount.enabled }}
{{- default (include "platform.name" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "platform.ui.secretName" -}}
{{ include "platform.name" . }}
{{- end }}

{{- define "platform.ui.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "platform.ui.labels" -}}
{{ include "platform.ui.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "platform.podSecurityContext" -}}
runAsNonRoot: true
runAsUser: {{ .Values.securityContext.runAsUser }}
runAsGroup: {{ .Values.securityContext.runAsGroup }}
fsGroup: {{ .Values.securityContext.fsGroup }}
seccompProfile:
  type: RuntimeDefault
{{- end }}

{{- define "platform.containerSecurityContext" -}}
runAsNonRoot: true
runAsUser: {{ .Values.securityContext.runAsUser }}
runAsGroup: {{ .Values.securityContext.runAsGroup }}
privileged: false
allowPrivilegeEscalation: false
readOnlyRootFilesystem: {{ .Values.securityContext.readOnlyRootFilesystem }}
capabilities:
  drop:
    - ALL
{{- end }}

{{- define "platform.tmp.volumeMount" -}}
- name: tmp
  mountPath: /tmp
{{- end }}

{{- define "platform.tmp.volume" -}}
- name: tmp
  emptyDir: {}
{{- end }}
