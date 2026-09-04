#!/usr/bin/env bash
# Выводит записи для /etc/hosts, чтобы `*.sandbox`-хосты (ingress, S3, keycloak и т.д.)
# указывали на хост, где развёрнут kind-кластер.
#
# Инженер запускает скрипт руками и переносит вывод в /etc/hosts на своей машине:
#   installer/scripts/sandbox-hosts.sh
#   sudo  sh -c 'installer/scripts/sandbox-hosts.sh >> /etc/hosts'   # как вариант
#
# Целевой IP — адрес хостовой машины (тот, с которого видны порты 80/443 кластера).
# По умолчанию определяется автоматически: IP живого интерфейса, через который идёт
# маршрут по умолчанию (default route). Переопределяется переменной SANDBOX_HOST_IP
# или первым аргументом:
#   SANDBOX_HOST_IP=192.168.1.10 installer/scripts/sandbox-hosts.sh
#   installer/scripts/sandbox-hosts.sh 192.168.1.10

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
COMMON="${REPO_ROOT}/installer/helmfile/common.yaml.gotmpl"
DOMAIN="${SANDBOX_DOMAIN:-sandbox}"

detect_host_ip() {
  # IP интерфейса, на который указывает default route
  local iface=""
  iface="$(ip route get 8.8.8.8 2>/dev/null | awk '/8.8.8.8/ {print $5; exit}')"
  if [ -z "${iface}" ]; then
    iface="$(ip route show default 2>/dev/null | awk '/default/ {print $5; exit}')"
  fi
  if [ -n "${iface}" ]; then
    ip -4 addr show dev "${iface}" 2>/dev/null | awk -v i="${iface}" '
      /inet / {print $2; exit}' | cut -d/ -f1
  fi
}

DHOST_IP="${1:-}"

if [ -n "${DHOST_IP}" ]; then
  HOST_IP="${DHOST_IP}"
elif [ -n "${SANDBOX_HOST_IP:-}" ]; then
  HOST_IP="${SANDBOX_HOST_IP}"
else
  HOST_IP="$(detect_host_ip || true)"
  if [ -z "${HOST_IP}" ]; then
    echo "WARNING: не удалось определить IP хоста по default route, использую 127.0.0.1" >&2
    HOST_IP="127.0.0.1"
  fi
fi

if [ ! -f "${COMMON}" ]; then
  echo "ERROR: не найден ${COMMON}" >&2
  exit 1
fi

# Домены из helmfile (ingress) + служебные хосты (S3)
HOSTS=$(grep -oE "^ *(- )?[a-zA-Z0-9]+Ingress: [a-z0-9-]+\.\{\{ \.Values\.domain \}\}" "${COMMON}" \
  | sed -E "s/^ *(- )?[a-zA-Z0-9]+Ingress: //; s/\{\{ \.Values\.domain \}\}/${DOMAIN}/" | sort -u)
HOSTS="${HOSTS}
s3.${DOMAIN}"

echo "# --- sandbox (${DOMAIN}) --- ${BASH_SOURCE[0]##*/}: IP хоста = ${HOST_IP}"
echo "${HOSTS}" | awk -v ip="${HOST_IP}" '{printf "%s\t%s\n", ip, $1}'
echo "# --- end sandbox ---"
