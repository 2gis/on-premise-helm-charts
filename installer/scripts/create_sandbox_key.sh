#!/usr/bin/env bash
# Reads the API key created by the keys bootstrap Job and stores it for the
# sandbox environment.
# Called by the postsync hook in hooks/core/keys/sandbox.yaml.gotmpl.
#
# The bootstrap Job is responsible for creating the default partner,
# subscription, and API key. This script only copies the generated key from
# the Job logs to the environment values file.
#
# Environment variables:
#   OP_NAMESPACE     - Kubernetes namespace (default: sandbox)
#   OP_ENV_FILE      - path to environments/sandbox.yaml.gotmpl (fallback target)
#   OP_SECRETS_FILE  - path to environments/sandbox.secrets.yaml (preferred target;
#                      overrides env values at render time, may be sops-encrypted)
set -euo pipefail

NAMESPACE="${OP_NAMESPACE:-sandbox}"
ENV_FILE="${OP_ENV_FILE:-}"
SECRETS_FILE="${OP_SECRETS_FILE:-}"
JOB_NAME="${OP_JOB_NAME:-keys-bootstrap}"

# Target file to read/patch the key from:
# environments/<env>.secrets.yaml if present (it overrides env values), else
# the environments file.
TARGET=""
if [ -n "${SECRETS_FILE}" ] && [ -f "${SECRETS_FILE}" ]; then
  TARGET="${SECRETS_FILE}"
elif [ -n "${ENV_FILE}" ] && [ -f "${ENV_FILE}" ]; then
  TARGET="${ENV_FILE}"
fi

if [ -z "${TARGET}" ]; then
  echo "WARNING: key target file not found, skipping key synchronization"
  exit 0
fi

# sops-encrypted target: decrypt to a temp copy, re-encrypt on write-back.
# Temp file lives next to the target so that .sops.yaml rules apply on re-encrypt.
ENC=0
WORK=""
cleanup() { [ -n "${WORK}" ] && rm -f "${WORK}" >/dev/null 2>&1 || true; }
trap cleanup EXIT

WORK=$(mktemp "$(dirname "${TARGET}")/.sandbox-key-work-XXXXXX.yaml")
if grep -q '^sops:' "${TARGET}" 2>/dev/null; then
  ENC=1
  sops -d "${TARGET}" > "${WORK}"
else
  cp "${TARGET}" "${WORK}"
fi

echo "==> Reading API key from Job ${JOB_NAME}..."
kubectl -n "${NAMESPACE}" wait --for=condition=complete "job/${JOB_NAME}" --timeout=120s 2>/dev/null || true
JOB_LOGS=$(kubectl -n "${NAMESPACE}" logs "job/${JOB_NAME}" --all-containers=true 2>/dev/null || true)
API_KEY=$(printf '%s\n' "${JOB_LOGS}" \
  | grep -oE 'api_key=[0-9a-fA-F-]{36}' \
  | tail -1 \
  | cut -d= -f2 || true)

if [ -z "${API_KEY}" ]; then
  echo "WARNING: API key not found in Job ${JOB_NAME} logs, skipping key synchronization"
  exit 0
fi

echo "==> API key received: ${API_KEY:0:8}..."

CURRENT_KEY=$(grep -E "^[[:space:]]*- key: '[a-f0-9-]{36}'" "${WORK}" 2>/dev/null \
  | head -1 \
  | sed "s/.*'\(.*\)'.*/\1/" || true)
if [ -z "${CURRENT_KEY}" ]; then
  CURRENT_KEY=$(grep -E "^key: [a-f0-9-]{36}" "${WORK}" 2>/dev/null \
    | head -1 \
    | sed 's/^key: //' || true)
fi

if [ "${API_KEY}" = "${CURRENT_KEY}" ]; then
  echo "==> Key is already stored in ${TARGET}"
  exit 0
fi

echo "==> Patching key in ${TARGET}..."
sed -i \
  -e "s|^\([[:space:]]*- key: \).*|\1'${API_KEY}' # auto-generated|" \
  -e "s|^key: .*|key: '${API_KEY}'|" \
  "${WORK}"

if [ "${ENC}" = "1" ]; then
  # sops resolves .sops.yaml from CWD (not from the file path) - cd next to
  # the target so the walk-up finds the example/.sops.yaml rules.
  ( cd "$(dirname "${TARGET}")" && sops encrypt -i "${WORK}" )
  cat "${WORK}" > "${TARGET}"
else
  cp "${WORK}" "${TARGET}"
fi

echo "==> Key synchronized"
