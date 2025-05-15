{{- define "urlparts" -}}
  {{- $url := .Values.proxy.host }}
  {{- $defaultScheme := .Values.proxy.protocol }}
  {{- if contains "://" $url }}
    {{- $parts := regexSplit "://" $url -1 }}
    {{- $scheme := index $parts 0 }}
    {{- $host := index $parts 1 }}
    {{- dict "scheme" $scheme "host" $host | toYaml }}
  {{- else }}
    {{- dict "scheme" $defaultScheme "host" $url | toYaml }}
  {{- end }}
{{- end }}

{{- define "proxyParams" -}}
{{- $urlParts := include "urlparts" . | fromYaml }}
  {{- if .Values.proxy.upstreams }}
    proxy_pass         {{ $urlParts.scheme }}://backend;
    proxy_set_header   Host {{ required "A valid .Values.proxy.host required" $urlParts.host }};
  {{- else }}
    proxy_pass         {{ $urlParts.scheme }}://{{ required "A valid .Values.proxy.host required" $urlParts.host }};
  {{- end }}
  {{- if eq $urlParts.scheme "https" }}
    proxy_ssl_server_name on;
    proxy_ssl_name     {{ $urlParts.host }};
  {{- end }}
  {{- if and .Values.proxy.apiKey .Values.proxy.locationDG }}
    proxy_set_header   X-API-Key {{ .Values.proxy.apiKey }};
  {{- end }}
    proxy_set_header   Upgrade $http_upgrade;
    proxy_set_header   Connection keep-alive;
    proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header   X-Forwarded-Proto $scheme;
  {{- if .Values.proxy.cache.enabled }}
    proxy_cache trafficcache;
    proxy_cache_valid any {{ .Values.proxy.cache.age }};
    proxy_cache_bypass $http_upgrade;
  {{- end }}
{{- end }}

{{/*Location for proxy*/}}
{{- define "locationDG" -}}
{{/* 1. ECA endpoints*/}}
location = /eca/traffic/moses/speeds5.json {
  rewrite ^ /api/v1/services/navi/proxy/eca-index/traffic/moses/speeds5.json break;
  {{- include "proxyParams" . }}
}

location ~ ^/eca/speeds/calculator-prod\.k8s\.m9\.2gis\.io/ {
  rewrite ^/eca(/speeds/calculator-prod\.k8s\.m9\.2gis\.io/.*)$ /api/v1/services/navi/proxy/online-speeds$1 break;
  {{- include "proxyParams" . }}
}

{{/* 2. Forecast endpoints*/}}
location = /forecast/index.json {
  rewrite ^ /api/v1/services/navi/proxy/forecast-index/index.json break;
  {{- include "proxyParams" . }}
}

location ~ ^/forecast/([^/]+)/forecasted_speeds_v2\.zip$ {
  rewrite ^/forecast/(.*)$ /api/v1/services/navi/proxy/forecasted-speeds/$1 break;
  {{- include "proxyParams" . }}
}

{{/*3. Long forecast endpoints*/}}
location = /long-forecast/index.json {
  rewrite ^ /api/v1/services/navi/proxy/long-forecasted-speeds-index/long_forecast_data/index.json break;
  {{- include "proxyParams" . }}
}

location ~ ^/long-forecast/([^/]+)/forecasted_speeds_v2\.zip$ {
  rewrite ^/long-forecast/(.*)$ /api/v1/services/navi/proxy/long-forecasted-speeds/long_forecast_data/$1 break;
  {{- include "proxyParams" . }}
}

{{/*4. Navi-castle endpoints*/}}
location = /navi-castle/restrictions_index.json.zip {
  rewrite ^ /api/v1/services/navi/proxy/restrictions-index/restrictions_index.json.zip break;
  {{- include "proxyParams" . }}
}

location ~ ^/navi-castle/restrictions/([^/]+)/.*-restriction\.json$ {
  rewrite ^/navi-castle/restrictions/(.*)$ /api/v1/services/navi/proxy/restrictions/restrictions/$1 break;
  {{- include "proxyParams" . }}
}

{{/*5. navi-castle-cache endpoints*/}}
location = /navi-castle-cache/index.json.zip {
  rewrite ^ /api/v1/services/navi/proxy/restrictions-index/index.json.zip break;
  {{- include "proxyParams" . }}
}

location ~ ^/navi-castle-cache/eta_correction/ {
    rewrite ^/navi-castle-cache(/eta_correction/.*)$ /api/v1/services/navi/proxy/eta-correction$1 break;
    {{- include "proxyParams" . }}
}

location ~ ^/navi-castle-cache/smatrix/ {
  rewrite ^/navi-castle-cache(/smatrix/.*)$ /api/v1/services/navi/proxy/smatrix$1 break;
  {{- include "proxyParams" . }}
}

location ~ ^/navi-castle-cache/probability_matrix/ {
  rewrite ^/navi-castle-cache(/probability_matrix/.*)$ /api/v1/services/navi/proxy/probability-matrix$1 break;
  {{- include "proxyParams" . }}
}

location ~ ^/navi-castle-cache/turn_penalties/ {
  rewrite ^/navi-castle-cache(/turn_penalties/.*)$ /api/v1/services/navi/proxy/turn-penalties$1 break;
  {{- include "proxyParams" . }}
}

location = /navi-castle-cache/restricted_transport.json.zip {
  rewrite ^ /api/v1/services/navi/proxy/restricted-transport-index/restricted_transport.json.zip break;
  {{- include "proxyParams" . }}
}

location ~ ^/navi-castle-cache/restricted_transport/([^/]+)/restricted_transport_platforms\.csv$ {
  rewrite ^navi-castle-cache/restricted_transport/(.*)$ /api/v1/services/navi/proxy/restricted-transport-platforms/restricted_transport/$1 break;
  {{- include "proxyParams" . }}
}

location ~ ^/navi-castle-cache/restricted_transport/([^/]+)/restricted_transport_routes\.csv$ {
  rewrite ^/navi-castle-cache/restricted_transport/(.*)$ /api/v1/services/navi/proxy/restricted-transport-routes/restricted_transport/$1 break;
  {{- include "proxyParams" . }}
}
location = /eta/eta-predictions/index.json {
  rewrite ^ /api/v1/services/navi/proxy/eta-predictions-index/index.json break;
  {{- include "proxyParams" . }}
}
location ~ ^/eta/eta-predictions/eta-predictor-([0-9])\.eta-predictor/([^/]+)/eta_prediction\.zip$ {
  rewrite ^/eta/eta-predictions/(.*)$ /api/v1/services/navi/proxy/eta-predictions/eta-predictions/$1 break;
  {{- include "proxyParams" . }}
}
{{- end }}
