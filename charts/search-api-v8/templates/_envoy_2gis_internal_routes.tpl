{{- define "envoy.routesForCluster" -}}
- match:
    prefix: "/unisearch.proto.SearchService/"
    headers:
      - name: {{ .root.Values.ingressRouter.routeHeader | quote }}
        exact_match: {{ .cluster.exactMatch | quote }}
  route:
    cluster: {{ .name }}
    auto_host_rewrite: true
  request_headers_to_remove:
  - {{ .root.Values.ingressRouter.routeHeader }}
- match:
    prefix: "/v2/search"
    headers:
      - name: "x-router-target-cluster"
        exact_match: {{ .cluster.exactMatch | quote }}
  route:
    cluster: {{ printf "http-%s" .name }}
    auto_host_rewrite: true
  request_headers_to_remove:
  - x-router-target-cluster
{{- end -}}

{{- define "envoy.clusterBackendAB" -}}
- name: {{ .name }}
  connect_timeout: 1s
  type: STRICT_DNS
  dns_lookup_family: V4_ONLY
  dns_refresh_rate: 1s
  lb_policy: ROUND_ROBIN
  http2_protocol_options:
    connection_keepalive:
      interval: 15s
      timeout: 5s
  load_assignment:
    cluster_name: {{ .name }}
    endpoints:
      - lb_endpoints:
          - endpoint:
              address:
                socket_address:
                  port_value: {{ .cluster.port }}
                  address: {{ .cluster.address }}
- name: {{ printf "http-%s" .name }}
  connect_timeout: 1s
  type: STRICT_DNS
  dns_lookup_family: V4_ONLY
  dns_refresh_rate: 1s
  lb_policy: ROUND_ROBIN
  http_protocol_options: {}
  load_assignment:
    cluster_name: {{ printf "http-%s" .name }}
    endpoints:
      - lb_endpoints:
          - endpoint:
              address:
                socket_address:
                  port_value: {{ .root.Values.ingressRouter.ports.http }}
                  address: {{ .cluster.address }}
{{- end -}}
{{- define "envoy.clusterBackendCustom" -}}
- name: {{ .name }}
  connect_timeout: 1s
  type: STRICT_DNS
  dns_lookup_family: V4_ONLY
  dns_refresh_rate: 1s
  lb_policy: ROUND_ROBIN
  http2_protocol_options:
    connection_keepalive:
      interval: 15s
      timeout: 5s
  load_assignment:
    cluster_name: {{ .name }}
    endpoints:
      - lb_endpoints:
          - endpoint:
              address:
                socket_address:
                  port_value: {{ .cluster.port }}
                  address: {{ .cluster.address }}
- name: {{ printf "http-%s" .name }}
  connect_timeout: 1s
  type: STRICT_DNS
  dns_lookup_family: V4_ONLY
  dns_refresh_rate: 1s
  lb_policy: ROUND_ROBIN
  http_protocol_options: {}
  load_assignment:
    cluster_name: {{ printf "http-%s" .name }}
    endpoints:
      - lb_endpoints:
          - endpoint:
              address:
                socket_address:
                  port_value: 80
                  address: {{ .cluster.address }}
{{- end -}}
{{- define "envoy.clusterBackendSimple" -}}
- name: {{ .clusterName }}
  connect_timeout: 1s
  type: STRICT_DNS
  dns_lookup_family: V4_ONLY
  dns_refresh_rate: 1s
  lb_policy: ROUND_ROBIN
  http2_protocol_options:
    connection_keepalive:
      interval: 15s
      timeout: 5s
  load_assignment:
    cluster_name: {{ .clusterName }}
    endpoints:
      - lb_endpoints:
          - endpoint:
              address:
                socket_address:
                  port_value: {{ .port }}
                  address: {{ include "search-api-v8.fullname" .root }}-{{ .addressSuffix }}
{{- end -}}
{{- define "envoy.routeDebug" -}}
- match:
    prefix: {{ .prefix | quote }}
    headers:
      - name: {{ .headerName | quote }}
        exact_match: {{ .exactMatch | quote }}
  route:
    cluster: {{ .cluster }}
    auto_host_rewrite: true
{{- end -}}
