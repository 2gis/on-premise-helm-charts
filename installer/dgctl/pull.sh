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
  echo "Usage: $0 <config_name.yaml>"
  exit 1
fi

#2gis/dgctl pull --config=/config.yaml --generate-values --apps-to-registry
#2gis/dgctl license --config=/config.yaml

set -e
VAL_DIR=auto_values
mkdir -p $VAL_DIR

if [ "$LICENSE" != "-l" ];then
docker run $env_flag --net=host --rm \
  -v `pwd`/$VAL_DIR:/values \
  -v `pwd`/$CFG:/config.yaml \
  -u `id -u`:`grep docker /etc/group | cut -d : -f 3` \
  2gis/dgctl:3 pull --config=/config.yaml --generate-values --apps-to-registry

else
docker run --pull=always $env_flag --net=host --rm \
  -v `pwd`/$VAL_DIR:/values \
  -v `pwd`/$CFG:/config.yaml \
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
    echo "No \"script.$section_name\" hosts in $CFG — skipping disk space check"
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
