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
    proxy_set_header   X-API-Key {{ $.Values.proxy.apiKey }};
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
  rewrite ^ /api/v1/proxy/navi/eca-index/traffic/moses/speeds5.json break;
  {{- include "proxyParams" . }}
}

location ~ ^/eca/speeds/calculator-prod\.k8s\.m9\.2gis\.io/ {
  rewrite ^/eca(/speeds/calculator-prod\.k8s\.m9\.2gis\.io/.*)$ /api/v1/proxy/navi/online-speeds$1 break;
  {{- include "proxyParams" . }}
}

{{/* 2. Forecast endpoints*/}}
location = /forecast/index.json {
  rewrite ^ /api/v1/proxy/navi/forecast-index/index.json break;
  {{- include "proxyParams" . }}
}

location ~ ^/forecast/([^/]+)/forecasted_speeds_v2\.zip$ {
  rewrite ^/forecast/(.*)$ /api/v1/proxy/navi/forecasted-speeds/$1 break;
  {{- include "proxyParams" . }}
}

{{/*3. Long forecast endpoints*/}}
location = /long-forecast/index.json {
  rewrite ^ /api/v1/proxy/navi/long-forecasted-speeds-index/long_forecast_data/index.json break;
  {{- include "proxyParams" . }}
}

location ~ ^/long-forecast/([^/]+)/forecasted_speeds_v2\.zip$ {
  rewrite ^/long-forecast/(.*)$ /api/v1/proxy/navi/long-forecasted-speeds/long_forecast_data/$1 break;
  {{- include "proxyParams" . }}
}

{{/*4. Navi-castle endpoints*/}}
location = /navi-castle/restrictions_index.json.zip {
  rewrite ^ /api/v1/proxy/navi/navi-castle-index/restrictions_index.json.zip break;
  {{- include "proxyParams" . }}
}

location ~ ^/navi-castle/restrictions/([^/]+)/.*-restriction\.json$ {
  rewrite ^/navi-castle/restrictions/(.*)$ /api/v1/proxy/navi/restrictions/restrictions/$1 break;
  {{- include "proxyParams" . }}
}

{{/*5. navi-castle endpoints*/}}
location = /navi-castle/index.json.zip {
  rewrite ^ /api/v1/proxy/navi/navi-castle-index/index.json.zip break;
  {{- include "proxyParams" . }}
}

location ~ ^/navi-castle/eta_correction/ {
    rewrite ^/navi-castle(/eta_correction/.*)$ /api/v1/proxy/navi$1 break;
    proxy_pass http://localhost;
}

location ~ ^/navi-castle/smatrix/ {
  rewrite ^/navi-castle(/smatrix/.*)$ /api/v1/proxy/navi$1 break;
  {{- include "proxyParams" . }}
}

location ~ ^/navi-castle/probability_matrix/ {
  rewrite ^/navi-castle(/probability_matrix/.*)$ /api/v1/proxy/navi$1 break;
  {{- include "proxyParams" . }}
}

location ~ ^/navi-castle/turn_penalties/([^/]+)/([^/]+)\.zip$ {
  rewrite ^/navi-castle/turn_penalties/(.*)\.zip$ /api/v1/proxy/navi/turn_penalties/$1.json break;
  {{- include "proxyParams" . }}
}

location = /navi-castle/restricted_transport.json.zip {
  rewrite ^ /api/v1/proxy/navi/restricted_transport-index/restricted_transport.json.zip break;
  {{- include "proxyParams" . }}
}

location ~ ^/navi-castle/restricted_transport/([^/]+)/restricted_transport_platforms\.csv$ {
  rewrite ^/navi-castle/restricted_transport/(.*)$ /api/v1/proxy/navi/restricted_transport/$1 break;
  {{- include "proxyParams" . }}
}

location ~ ^/navi-castle/restricted_transport/([^/]+)/restricted_transport_routes\.csv$ {
  rewrite ^/navi-castle/restricted_transport/(.*)$ /api/v1/proxy/navi/restricted_transport/$1 break;
  {{- include "proxyParams" . }}
}
location = /eta/eta-predictions/index.json {
  rewrite ^ /api/v1/proxy/navi/eta-predictions-index/index.json break;
  {{- include "proxyParams" . }}
}
location ~ ^/eta/eta-predictions/eta-predictor-([0-9])\.eta-predictor/([^/]+)/eta_prediction\.zip$ {
  rewrite ^/eta/eta-predictions/(.*)$ /api/v1/proxy/eta-predictions/$1 break;
  {{- include "proxyParams" . }}
}
{{- end }}
