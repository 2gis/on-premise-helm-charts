
{{- define "pro.env.ui" -}}
- name: NETWORK_TIMEOUT
  value: "{{ required "A valid .Values.ui.api.timeout" .Values.ui.api.timeout }}"
- name: SERVER_NETWORK_TIMEOUT
  value: "{{ required "A valid .Values.ui.api.serverTimeout" .Values.ui.api.serverTimeout }}"
- name: URBI_API_URL
  value: "{{ required "A valid .Values.ui.api.url entry required" .Values.ui.api.url }}"
- name: MAPGL_HOST
  value: "{{ required "A valid .Values.ui.mapgl.host entry required" .Values.ui.mapgl.host }}"
- name: MAPGL_SCRIPT_PATH
  value: "{{ .Values.ui.mapgl.scriptPath }}"
- name: MAPGL_KEY
  value: "{{ required "A valid .Values.ui.mapgl.key entry required" .Values.ui.mapgl.key }}"
- name: MAPGL_STYLE_URL
  value: "{{ .Values.ui.mapgl.styleUrl }}"
- name: MAPGL_STYLE_ICONS_URL
  value: "{{ .Values.ui.mapgl.styleIconsUrl }}"
- name: MAPGL_STYLE_FONTS_URL
  value: "{{ .Values.ui.mapgl.styleFontsUrl }}"
- name: MAPGL_STYLE_PREVIEW
  value: "{{ .Values.ui.mapgl.stylePreview }}"
- name: MAPGL_STYLE_MODELS_URL
  value: "{{ .Values.ui.mapgl.styleModelsUrl }}"
- name: LOG_LEVEL
  value: "{{ .Values.ui.logLevel }}"
- name: IS_ON_PREM
  value: "{{ .Values.ui.isOnPremise }}"
- name: SSO_AUTH
  value: "{{ required "A valid .Values.ui.auth.sso entry required" .Values.ui.auth.sso }}"
{{ if .Values.ui.auth.sso }}
  {{- if .Values.ui.auth.turnOffCertValidation -}}
- name: NODE_TLS_REJECT_UNAUTHORIZED
  value: "0"
  {{- end }}
- name: AUTH_SAFE_HOSTS
  value: "{{ required "A valid .Values.ui.auth.safeHosts entry required" .Values.ui.auth.safeHosts }}"
- name: AUTH_SECURE
  value: "{{ required "A valid .Values.ui.auth.secure entry required" .Values.ui.auth.secure }}"
- name: AUTH_CODE_URL
  value: "{{ required "A valid .Values.ui.auth.codeUrl entry required" .Values.ui.auth.codeUrl }}"
- name: AUTH_CLIENT_ID
  value: "{{ required "A valid .Values.ui.auth.clientId entry required" .Values.ui.auth.clientId }}"
- name: AUTH_CLIENT_SECRET
  value: "{{ required "A valid .Values.ui.auth.clientSecret entry required" .Values.ui.auth.clientSecret }}"
- name: O_AUTH_PROVIDER
  value: "{{ required "A valid .Values.ui.auth.oAuthProvider entry required" .Values.ui.auth.oAuthProvider }}"
- name: O_AUTH_SCOPES
  value: "{{ .Values.ui.auth.oAuthScopes }}"
{{- if eq .Values.ui.auth.oAuthProvider "openid" }}
- name: OPEN_ID_WELL_KNOWN_URL_LIST_URL
  value: "{{ required "A valid .Values.ui.auth.openIdWellKnownUrlListUrl entry required" .Values.ui.auth.openIdWellKnownUrlListUrl }}"
{{- else }}
- name: OPEN_ID_WELL_KNOWN_URL_LIST_URL
  value: ''
- name: AUTH_IDENTITY_PROVIDER_URL
  value: "{{ required "A valid .Values.ui.auth.identityProviderUrl entry required" .Values.ui.auth.identityProviderUrl }}"
- name: O_AUTH_API_URL
  value: "{{ required "A valid .Values.ui.auth.oAuthApiUrl entry required" .Values.ui.auth.oAuthApiUrl }}"
{{- end }}
{{- end }}
- name: APP_LOCALE
  value: "{{ .Values.ui.appLocale }}"
- name: APP_THEME
  value: "{{ .Values.ui.appTheme }}"
- name: AUTH_BRAND
  value: "{{ .Values.ui.auth.brand }}"
- name: APP_INITIAL_MAP_CENTER
  value: "{{ .Values.ui.appInitialMapCenter }}"
- name: SUPPORT_DOCUMENTATION_LINK
  value: "{{ .Values.ui.supportDocumentationLink }}"
- name: IMMERSIVE_MODELS
  value: {{ .Values.ui.immersiveModels | quote }}
- name: HOME
  value: "/tmp"
- name: SERVER_PORT
  value: "{{ .Values.containerPort }}"
- name: MAPBOX_STYLE_TOKEN
  value: "{{ .Values.ui.mapbox.styleToken }}"
- name: FEATURE_EXTERNAL_STYLE_MANAGER_IS_ENABLED
  value: "{{ .Values.ui.externalStyleManager.enabled }}"
- name: PUBLIC_S3_HOST
  value: "{{ .Values.ui.publicS3Url }}"
- name: PUBLIC_S3_URL
  value: "{{ .Values.ui.publicS3Url }}"
- name: S3_STYLES_BUCKET
  value: "{{ .Values.ui.styles.s3Bucket }}"
- name: STYLES_CONFIG_URL
  value: "{{ .Values.ui.styles.configUrl }}"
- name: S3_WHITE_LABEL_BUCKET
  value: "{{ .Values.ui.whiteLabel.s3Bucket }}"
- name: WHITE_LABEL_CONFIG_URL
  value: "{{ .Values.ui.whiteLabel.configUrl | default "/static/theme/urbi.json" }}"
- name: ZENITH_HOST
  value: "{{ .Values.ui.zenith.host }}"
- name: ZENITH_TILE_SET
  value: "{{ .Values.ui.zenith.tileSet }}"
- name: ZENITH_HAS_ADM_DIVS_LAYERS
  value: "{{ .Values.ui.zenith.hasAdmDivsLayers }}"
- name: ZENITH_PROTOCOL
  value: "{{ .Values.ui.zenith.protocol }}"
- name: ZENITH_SUBDOMAINS
  value: "{{ .Values.ui.zenith.subdomains }}"
- name: APP_VERSION
  value: "{{ .Values.image.tag }}"
{{- if .Values.ui.extraEnvVars }}
{{- range $key, $val := .Values.ui.extraEnvVars }}
- name: {{ $key }}
  value: {{ include "pro.ui.tplvalues.render" (dict "value" $val "context" $) | quote }}
{{- end -}}
{{- end }}
{{- end }}
