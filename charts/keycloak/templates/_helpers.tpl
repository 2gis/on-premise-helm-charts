{{/*
Expand the name of the chart.
*/}}
{{- define "keycloak.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "keycloak.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "keycloak.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "keycloak.labels" -}}
helm.sh/chart: {{ include "keycloak.chart" . }}
{{ include "keycloak.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "keycloak.selectorLabels" -}}
app.kubernetes.io/name: {{ include "keycloak.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts.
*/}}
{{- define "keycloak.names.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "keycloak.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{- define "keycloak.serviceAccount" -}}
{{- if empty $.Values.serviceAccountOverride }}
{{- include "keycloak.fullname" . }}
{{- else }}
{{- $.Values.serviceAccountOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Return the path Keycloak is hosted on. This looks at httpRelativePath and returns it with a trailing slash. For example:
    / -> / (the default httpRelativePath)
    /auth -> /auth/ (trailing slash added)
    /custom/ -> /custom/ (unchanged)
*/}}
{{- define "keycloak.httpPath" -}}
{{ ternary .Values.httpRelativePath (printf "%s%s" .Values.httpRelativePath "/") (hasSuffix "/" .Values.httpRelativePath) }}
{{- end -}}

{{/*
Return the Keycloak configuration configmap
*/}}
{{- define "keycloak.configmapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-configuration" (include "keycloak.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "keycloak.createConfigmap" -}}
{{- if and .Values.configuration (not .Values.existingConfigmap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Keycloak initdb scripts configmap
*/}}
{{- define "keycloak.initdbScriptsCM" -}}
{{- if .Values.initdbScriptsConfigMap -}}
    {{- printf "%s" .Values.initdbScriptsConfigMap -}}
{{- else -}}
    {{- printf "%s-init-scripts" (include "keycloak.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing the Keycloak admin password
*/}}
{{- define "keycloak.secretName" -}}
{{- $secretName := .Values.auth.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s" (include "keycloak.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret key that contains the Keycloak admin password
*/}}
{{- define "keycloak.secretKey" -}}
{{- $secretName := .Values.auth.existingSecret -}}
{{- if and $secretName .Values.auth.passwordSecretKey -}}
    {{- printf "%s" .Values.auth.passwordSecretKey -}}
{{- else -}}
    {{- print "admin-password" -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing Keycloak HTTPS/TLS certificates
*/}}
{{- define "keycloak.tlsSecretName" -}}
{{- $secretName := .Values.tls.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "keycloak.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing Keycloak HTTPS/TLS keystore and truststore passwords
*/}}
{{- define "keycloak.tlsPasswordsSecretName" -}}
{{- $secretName := .Values.tls.passwordsSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-tls-passwords" (include "keycloak.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing Keycloak SPI TLS certificates
*/}}
{{- define "keycloak.spiPasswordsSecretName" -}}
{{- $secretName := .Values.spi.passwordsSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-spi-passwords" (include "keycloak.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS secret object should be created
*/}}
{{- define "keycloak.createTlsSecret" -}}
{{- if and .Values.tls.enabled .Values.tls.autoGenerated (not .Values.tls.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Reuses the value from an existing secret, otherwise sets its value to a default value.

Usage:
{{ include "common.secrets.lookup" (dict "secret" "secret-name" "key" "keyName" "defaultValue" .Values.myValue "context" $) }}

Params:
  - secret - String - Required - Name of the 'Secret' resource where the password is stored.
  - key - String - Required - Name of the key in the secret.
  - defaultValue - String - Required - The path to the validating value in the values.yaml, e.g: "mysql.password". Will pick first parameter with a defined value.
  - context - Context - Required - Parent context.

*/}}
{{- define "keycloak.secrets.lookup" -}}
{{- $value := "" -}}
{{- $defaultValue := required "\n'keycloak.secrets.lookup': Argument 'defaultValue' missing or empty" .defaultValue -}}
{{- $secretData := (lookup "v1" "Secret" (include "keycloak.names.namespace" .context) .secret).data -}}
{{- if and $secretData (hasKey $secretData .key) -}}
  {{- $value = index $secretData .key -}}
{{- else -}}
  {{- $value = $defaultValue | toString | b64enc -}}
{{- end -}}
{{- printf "%s" $value -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "keycloak.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "keycloak.validateValues.tls" .) -}}
{{- $messages := append $messages (include "keycloak.validateValues.production" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Keycloak - TLS enabled */}}
{{- define "keycloak.validateValues.tls" -}}
{{- if and .Values.tls.enabled (not .Values.tls.autoGenerated) (not .Values.tls.existingSecret) }}
keycloak: tls.enabled
    In order to enable TLS, you also need to provide
    an existing secret containing the Keystore and Truststore or
    enable auto-generated certificates.
{{- end -}}
{{- end -}}

{{/* Validate values of Keycloak - Production mode enabled */}}
{{- define "keycloak.validateValues.production" -}}
{{- if and .Values.production (not .Values.tls.enabled) (not (eq .Values.proxy "edge")) -}}
keycloak: production
    In order to enable Production mode, you also need to enable HTTPS/TLS
    using the value 'tls.enabled' and providing an existing secret containing the Keystore and Trustore.
{{- end -}}
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
