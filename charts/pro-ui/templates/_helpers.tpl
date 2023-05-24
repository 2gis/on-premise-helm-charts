{{- define "pro.name" -}}
{{- .Release.Name | trunc 32 | trimSuffix "-" }}
{{- end }}

{{- define "pro.ui.name" -}}
{{ include "pro.name" . }}
{{- end }}

{{- define "pro.ui.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "pro.ui.labels" -}}
{{ include "pro.ui.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "pro.env.ui" -}}
- name: URBI_API_URL
  value: "{{ required "A valid .Values.ui.api.url entry required" .Values.ui.api.url }}"
- name: MAPGL_HOST
  value: "{{ required "A valid .Values.ui.mapgl.host entry required" .Values.ui.mapgl.host }}"
- name: MAPGL_KEY
  value: "{{ required "A valid .Values.ui.mapgl.key entry required" .Values.ui.mapgl.key }}"
- name: MAPGL_STYLE_URL
  value: "{{ .Values.ui.mapgl.styleUrl }}"
- name: MAPGL_STYLE_ICONS_URL
  value: "{{ .Values.ui.mapgl.styleIconsUrl }}"
- name: MAPGL_STYLE_FONTS_URL
  value: "{{ .Values.ui.mapgl.styleFontsUrl }}"
- name: LOG_LEVEL
  value: "{{ .Values.ui.logLevel }}"
- name: IS_ON_PREM
  value: "{{ .Values.ui.isOnPremise }}"
- name: SSO_AUTH
  value: "{{ .Values.ui.auth.sso }}"
- name: AUTH_SAFE_HOSTS
  value: "{{ .Values.ui.auth.safeHosts }}"
- name: AUTH_SECURE
  value: "{{ .Values.ui.auth.secure }}"
- name: AUTH_CODE_URL
  value: "{{ .Values.ui.auth.codeUrl }}"
- name: AUTH_CLIENT_ID
  value: "{{ .Values.ui.auth.clientId }}"
- name: AUTH_CLIENT_SECRET
  value: "{{ .Values.ui.auth.clientSecret }}"
- name: O_AUTH_PROVIDER
  value: "{{ .Values.ui.auth.oAuthProvider }}"
- name: AUTH_IDENTITY_PROVIDER_URL
  value: "{{ .Values.ui.auth.identityProviderUrl }}"
- name: O_AUTH_API_URL
  value: "{{ .Values.ui.auth.oAuthApiUrl }}"
- name: USER_DATA_API_URL
  value: "{{ .Values.ui.auth.userDataApiUrl }}"
- name: APP_LOCALE
  value: "{{ .Values.ui.appLocale }}"
- name: APP_THEME
  value: "{{ .Values.ui.appTheme }}"
- name: APP_INITIAL_MAP_CENTER
  value: "{{ .Values.ui.appInitialMapCenter }}"
- name: HOME
  value: "/tmp"
{{- end }}
