#!/bin/bash
#set -x

if [ -n "$DATAGATEWAY_API_ENDPOINT" ]; then
  env_flag="-e=DATAGATEWAY_API_ENDPOINT=$DATAGATEWAY_API_ENDPOINT"
else
  env_flag=""
fi

CFG=${1}
LICENSE=$2
if [ -z "$CFG" ];then
  echo "Usage: $0 <config_name.yaml> [-l]"
  exit 1
fi
# Config is env-bundle data: try $1 as given, then $HELMFILE_VALUES/dgctl/<name>
# (bundle default: $PWD/installer/helmfile/example, same contract as helmfile).
VALUES_DIR="${HELMFILE_VALUES:-$(pwd)/installer/helmfile/example}"
if [ ! -f "$CFG" ]; then
  CFG="$VALUES_DIR/dgctl/$(basename "$CFG")"
fi
CFG=$(readlink -f "$CFG")
[ -f "$CFG" ] || { echo "ERROR: config not found: $1 (tried as given and \$HELMFILE_VALUES/dgctl/)"; exit 1; }

#2gis/dgctl pull --config=/config.yaml --generate-values --apps-to-registry
#2gis/dgctl license --config=/config.yaml

set -e
# Platform side for generated values: HELMFILE_BASE wins; default - next to the
# script itself, so pull.sh runs from any directory (no repo-root assumption).
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
BASE_PATH="${HELMFILE_BASE:-$SCRIPT_DIR/../helmfile}"
VAL_DIR="$BASE_PATH/../dgctl/auto_values"
mkdir -p "$VAL_DIR"

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

if [ "$LICENSE" != "-l" ];then
docker run $env_flag --net=host --rm \
  -v "$VAL_DIR":/values \
  -v "$CFG":/config.yaml \
  -u `id -u`:`grep docker /etc/group | cut -d : -f 3` \
  2gis/dgctl:3 pull --config=/config.yaml --generate-values --apps-to-registry

else
docker run --pull=always $env_flag --net=host --rm \
  -v "$VAL_DIR":/values \
  -v "$CFG":/config.yaml \
  -u `id -u`:`grep docker /etc/group | cut -d : -f 3` \
  2gis/dgctl:3 license --config=/config.yaml --version 2
fi

echo ""
echo ""

format_df_output() {
    local df_output="$1"
    local host="$2"
    echo "$df_output" | awk 'NR==2 {printf "%s used %s of free space: %s from %s\n", host, $5, $4, $2}' host="$host"
}


checking_hosts() {
  local section_name="$1"
  local hosts

  hosts=$(yq -r ".script.${section_name}[]?" "$CFG" 2>/dev/null)

  if [[ -z "$hosts" || "$hosts" == "null" ]]; then
    echo "No \"script.$section_name\" hosts in $CFG - skipping disk space check"
    return 0
  fi

  echo "Processing $section_name hosts..."

  for host in $hosts; do
      df_output=$(ssh "$host" "df -h /" 2>/dev/null)
      if [[ $? -ne 0 ]]; then
          echo "Failed to connect to $host. Skipping..."
          continue
      fi
      format_df_output "$df_output" "$host"
  done

}

checking_hosts "postgres"
echo ""
checking_hosts "cassandra"
