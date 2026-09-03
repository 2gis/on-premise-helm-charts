{{- define "ingress" -}}
{{- if .isEnabled -}}
enabled: true
className: nginx
hosts:
- host: {{ .name }}.{{ .Values.global.domain }}
  paths:
  - path: /
    pathType: Prefix
tls:
- hosts:
  - {{ .name }}.{{ .Values.global.domain }}
  secretName: {{ .Values.global.tlsSecret }}
{{- else -}}
enabled: false
className: nginx
hosts:
- host: {{ .name }}.{{ .Values.global.domain }}
  paths:
  - path: /
    pathType: Prefix
tls: []
{{- end -}}
{{- end -}}

{{- define "ingress2" }}
{{ . | toYaml }}
{{- end }}
