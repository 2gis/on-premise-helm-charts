{{/*
Set custom CAs mount path
Usage:
{{ include "custom.ca.mountPath" $ }}
*/}}
{{- define "custom.ca.mountPath" -}}
{{ .Values.customCAs.certsPath | default "/usr/local/share/ca-certificates" }}
{{- end -}}
