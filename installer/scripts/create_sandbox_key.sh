#!/usr/bin/env bash
# Creates an API key in the keys service for the sandbox environment.
# Called by the postsync hook in hooks/core/keys/sandbox.yaml.gotmpl.
#
# Environment variables:
#   OP_NAMESPACE  — Kubernetes namespace (default: sandbox)
#   OP_DOMAIN     — sandbox domain (default: sandbox)
#   OP_ENV_FILE   — path to environments/sandbox.yaml.gotmpl (for patching the generated key)
set -euo pipefail

NAMESPACE="${OP_NAMESPACE:-sandbox}"
DOMAIN="${OP_DOMAIN:-sandbox}"
ENV_FILE="${OP_ENV_FILE:-}"

KEYS_HOST="keys-api.${DOMAIN}"
KEYS_API_URL="http://${KEYS_HOST}"
# kind: traefik listens on hostPort 80, so --resolve maps the ingress host to 127.0.0.1
CURL_RESOLVE="--resolve ${KEYS_HOST}:80:127.0.0.1"

echo "==> Waiting for keys-api pod to be ready..."
kubectl -n "${NAMESPACE}" wait --for=condition=ready pod -l "app.kubernetes.io/name=keys-api" --timeout=120s 2>/dev/null || {
  echo "WARNING: keys-api pod not ready, skipping key creation"
  exit 0
}

POD=$(kubectl -n "${NAMESPACE}" get pod -l "app.kubernetes.io/name=keys-api" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
if [ -z "$POD" ]; then
  echo "WARNING: keys-api pod not found, skipping key creation"
  exit 0
fi

echo "==> Creating admin user via keysctl..."
kubectl -n "${NAMESPACE}" exec -i "${POD}" -- keysctl users add admin "Sandbox Admin" 2>/dev/null || {
  echo "==> Admin user already exists or keysctl unavailable, continuing..."
}

echo "==> Authenticating to keys API..."
AUTH_RESPONSE=$(curl -sf ${CURL_RESOLVE} -X POST \
  "${KEYS_API_URL}/admin/v1/auth" \
  -H "accept: application/json" \
  -H "X-Brand: 2gis" \
  -H "Content-Type: application/json" \
  -d '{"login": "admin", "password": "on-premise"}' 2>/dev/null) || {
  echo "WARNING: failed to authenticate to keys API, skipping key creation"
  exit 0
}

KEYS_API_TOKEN=$(echo "$AUTH_RESPONSE" | jq -r '.result.token' 2>/dev/null)
if [ -z "$KEYS_API_TOKEN" ] || [ "$KEYS_API_TOKEN" = "null" ]; then
  echo "WARNING: failed to get auth token, skipping key creation"
  exit 0
fi
echo "==> Auth token received"

PARTNER_JSON=$(cat <<EOF
{
  "name": "Sandbox Partner",
  "country": "Россия",
  "city": "Москва",
  "website": "https://2gis.ru",
  "contact": {
    "name": "Sandbox Admin",
    "email": "sandbox@example.com",
    "phone": "+70000000000",
    "position": "Administrator"
  },
  "manager_username": "admin"
}
EOF
)

echo "==> Creating partner..."
PARTNER_RESPONSE=$(curl -sf ${CURL_RESOLVE} -X POST \
  "${KEYS_API_URL}/admin/v1/partners" \
  -H "accept: application/json" \
  -H "X-Brand: 2gis" \
  -H "X-Auth-Token: ${KEYS_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "${PARTNER_JSON}")

PARTNER_ID=$(echo "$PARTNER_RESPONSE" | jq -r '.result.id // .id' 2>/dev/null)
if [ -z "$PARTNER_ID" ] || [ "$PARTNER_ID" = "null" ]; then
  echo "==> Using default partner_id=1"
  PARTNER_ID=1
fi
echo "==> partner_id: ${PARTNER_ID}"

SUBSCRIPTION_JSON=$(cat <<EOF
{
  "partner_id": ${PARTNER_ID},
  "start_date": "2025-01-01",
  "period": "infinity",
  "mode": "prod",
  "services": [
    {"code": "mapgl-js-api"},
    {"code": "categories-api"},
    {"code": "directions-api"},
    {"code": "isochrone-api"},
    {"code": "twins-api"},
    {"code": "geocoder-api"},
    {"code": "regions-api"},
    {"code": "tiles-api"},
    {"code": "places-api"},
    {"code": "suggest-api"},
    {"code": "markers-api"},
    {"code": "tiles-raster-api"},
    {"code": "distance-matrix-api"},
    {"code": "freeroam-api"},
    {"code": "map-matching-api"},
    {"code": "pairs-directions-api"},
    {"code": "public-transport-api"},
    {"code": "route-planner-api"},
    {"code": "routing-api"},
    {"code": "tsp-api"},
    {"code": "truck-directions-api"},
    {"code": "truck-distance-matrix-api"},
    {"code": "static-api"}
  ]
}
EOF
)

echo "==> Creating subscription..."
curl -sf ${CURL_RESOLVE} -X POST \
  "${KEYS_API_URL}/admin/v1/subscriptions" \
  -H "accept: application/json" \
  -H "X-Brand: 2gis" \
  -H "X-Auth-Token: ${KEYS_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "${SUBSCRIPTION_JSON}" | jq . 2>/dev/null || true

echo "==> Fetching demo key..."
DEMO_KEY=$(curl -sf ${CURL_RESOLVE} -X GET \
  "${KEYS_API_URL}/admin/v1/keys" \
  -H "accept: application/json" \
  -H "X-Brand: 2gis" \
  -H "X-Auth-Token: ${KEYS_API_TOKEN}" | jq -r '.result.items[0].key' 2>/dev/null)

if [ -z "$DEMO_KEY" ] || [ "$DEMO_KEY" = "null" ]; then
  echo "WARNING: failed to get demo key"
  exit 0
fi
echo "==> Demo key: ${DEMO_KEY:0:8}..."

echo "==> Demo key (full): ${DEMO_KEY}"

if [ -n "$ENV_FILE" ] && [ -f "$ENV_FILE" ]; then
  echo "==> Patching key in ${ENV_FILE}..."
  sed -i "s|^\(    - key: \).*|\1'${DEMO_KEY}' # auto-generated|" "${ENV_FILE}"
  echo "==> Key patched"
else
  echo "==> ENV_FILE not set or not found, skipping patch"
fi

echo "==> Done."
