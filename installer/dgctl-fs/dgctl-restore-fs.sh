#!/bin/bash
# Выполнять на хосте в закрытом контуре, где есть s3

# Выгружает из папки ./dgctl-source образы сервисов в docker-registry, данные в s3
set -e

# Конфиг лежит в env-бандле (example/dgctl/): $1 > $HELMFILE_VALUES/dgctl/... > дефолт от репо-раскладки.
VALUES_PATH="${HELMFILE_VALUES:-$(cd "$(dirname "$0")/.." && pwd)/helmfile/example}"
CFG="${1:-$VALUES_PATH/dgctl/dgctl-config-s3.yaml}"
CFG=$(readlink -f "$CFG")
[ -f "$CFG" ] || { echo "ERROR: config not found: $CFG"; exit 1; }

# Runtime-артефакты живут рядом со скриптами (независимо от CWD).
DIR="$(cd "$(dirname "$0")" && pwd)"

if command -v sops >/dev/null 2>&1 && grep -q '^sops:' "$CFG" 2>/dev/null; then
  echo "==> Config is sops-encrypted, decrypting to a temporary file..."
  CFG_ORIG="${CFG}"
  CFG=$(mktemp /tmp/dgctl-config.XXXXXX.yaml)
  sops -d "$CFG_ORIG" > "$CFG"
  trap 'rm -f "$CFG"' EXIT
elif ! command -v sops >/dev/null 2>&1 && grep -q '^sops:' "$CFG" 2>/dev/null; then
  echo "ERROR: config is sops-encrypted but sops binary not found in PATH"
  exit 1
fi

docker run --rm \
    -v "$CFG":/dgctl-config.yaml \
    -v "$DIR/dgctl-source":/dgctl-source \
    -v "$DIR/values":/values \
    --user $(id -u):$(id -g) \
    2gis/dgctl:3 \
    restore --config=/dgctl-config.yaml --from-dir=/dgctl-source --apps-to-registry
