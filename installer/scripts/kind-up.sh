#!/usr/bin/env bash
# Bootstrap sandbox-окружения kind (README «Sandbox-пример (kind)», шаг 2):
# кластер 2gis-on-premise + namespace sandbox + локальный HTTP-registry kind-registry:5000
# + доверие к нему в нодах (hosts.toml, containerd).
#
# Идемпотентен: повторный запуск ничего не пересоздаёт.
# Не трогает /etc/hosts — после запуска выполните installer/scripts/sandbox-hosts.sh.

set -euo pipefail

CLUSTER_NAME="2gis-on-premise"
KUBE_CONTEXT="kind-${CLUSTER_NAME}"
REGISTRY_NAME="kind-registry"
REGISTRY_PORT="5000"
NAMESPACE="sandbox"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for tool in kind docker kubectl; do
  command -v "$tool" >/dev/null 2>&1 || { echo "ERROR: $tool не найден в PATH" >&2; exit 1; }
done

echo "==> 1/4 Kind-кластер ${CLUSTER_NAME}"
if kind get clusters 2>/dev/null | grep -qx "${CLUSTER_NAME}"; then
  echo "    уже существует, пропускаю"
else
  kind create cluster --name "${CLUSTER_NAME}" --config "${SCRIPT_DIR}/kind-config.yaml"
fi

echo "==> 2/4 Namespace ${NAMESPACE}"
kubectl --context "${KUBE_CONTEXT}" create namespace "${NAMESPACE}" 2>/dev/null \
  && echo "    создан" || echo "    уже существует, пропускаю"

echo "==> 3/4 Registry ${REGISTRY_NAME}:${REGISTRY_PORT}"
if docker ps -a --format '{{.Names}}' | grep -qx "${REGISTRY_NAME}"; then
  docker start "${REGISTRY_NAME}" >/dev/null 2>&1 || true
  echo "    уже существует, пропускаю"
else
  docker run -d --name "${REGISTRY_NAME}" -p "${REGISTRY_PORT}:${REGISTRY_PORT}" --restart=always registry:3
fi
docker network connect kind "${REGISTRY_NAME}" 2>/dev/null || true

echo "==> 4/4 Доверие к HTTP-registry в нодах (hosts.toml)"
for node in $(kind get nodes --name "${CLUSTER_NAME}"); do
  if docker exec "${node}" test -f "/etc/containerd/certs.d/${REGISTRY_NAME}:${REGISTRY_PORT}/hosts.toml" 2>/dev/null; then
    echo "    ${node}: hosts.toml уже настроен"
  else
    docker exec "${node}" mkdir -p "/etc/containerd/certs.d/${REGISTRY_NAME}:${REGISTRY_PORT}"
    printf '[host."http://%s:%s"]\n' "${REGISTRY_NAME}" "${REGISTRY_PORT}" | \
      docker exec -i "${node}" cp /dev/stdin "/etc/containerd/certs.d/${REGISTRY_NAME}:${REGISTRY_PORT}/hosts.toml"
    docker exec "${node}" systemctl restart containerd
    echo "    ${node}: hosts.toml записан, containerd перезапущен"
  fi
done

echo
echo "Готово. Далее:"
echo "  - /etc/hosts: installer/scripts/sandbox-hosts.sh (см. README, шаги 4 и 7)"
echo "  - деплой infra: helmfile -e sandbox -f installer/helmfile/example/deploy/sandbox.yaml.gotmpl sync --selector group=infra"

