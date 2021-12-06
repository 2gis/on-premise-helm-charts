{{- define "tileserver.manifestCode" -}}
{{- base .Values.manifestPath | trimSuffix ".json" }}
{{- end }}

{{- define "tileserver.name" -}}
{{- print "dgis-tileserver-" .Values.tileserver.type "-" .Release.Name }}
{{- end }}

{{- define "importer.labels" -}}
app.kubernetes.io/import-uid: {{ include "tileserver.manifestCode" . | quote }}
{{- end }}
