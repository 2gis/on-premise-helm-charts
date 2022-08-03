#!/bin/bash

: ${GIS_PLATFORM_URL:=''}
: ${GIS_PLATFORM_PASS:=''}
: ${GIS_PLATFORM_TILES_API:=''}
: ${GIS_PLATFORM_TRAFFIC_API:=''}

#---------------

function usage() {
    echo "Usage ${0} <option>:"
    echo ""
    echo "-h    Show this help"
    echo "-g    Get configuration"
    echo "-d    Diff dumped config vs proposed config"
    echo "-c    Push configs to server"
    echo "-p    Patch existing layers (implies -c)"
    echo "-k    Ignore self-signed ssl certificate"
    echo ""
    echo "Required environment variables:"
    echo "- GIS_PLATFORM_URL"
    echo "- GIS_PLATFORM_PASS"
    echo "- GIS_PLATFORM_TILES_API"
    echo "- GIS_PLATFORM_TRAFFIC_API"
}

#---------------

function get_layer_config() {
    layer_name=$1
    $CURL -XGET "$GIS_PLATFORM_URL/sp/layers/$layer_name"
}

#---------------

function create_or_update_layer() {
    layer_type="$1"
    layer_data="$2"
    layer_name=$( jq --raw-output .name <<< $layer_data )

    if [[ $layer_name == $( get_layer_config $layer_name | jq --raw-output .name ) ]]; then
        if [[ $PATCH_LAYERS -eq 1 ]]; then
            echo "Updating $layer_name configuration"
            echo $layer_data | $CURL -XPATCH -H 'Content-Type: application/json' -d @- "$GIS_PLATFORM_URL/sp/layers/$layer_name?type=$layer_type" > /dev/null
        else
            echo "Layer $layer_name already exists, skipping"
        fi
    else
        echo "Configuring $layer_name $layer_type"
        echo $layer_data | $CURL -XPOST -H 'Content-Type: application/json' -d @- "$GIS_PLATFORM_URL/sp/layers?type=$layer_type"
    fi
}

#---------------

function configure() {
  if [[ "x1" == "x$( $CURL -XGET "$GIS_PLATFORM_URL/sp/account/user/list?filter=admin" | jq --raw-output .totalCount )" ]]; then
      echo "Admin user already exists, skipping"
  else
      echo "Creating admin user"
      $CURL -XPOST -H 'Content-Type: application/json' -d "$admin_account" "$GIS_PLATFORM_URL/sp/account/user"
      echo "Creating admin namespace"
      $CURL -XPOST -H 'Content-Type: application/json' -d'{}' "$GIS_PLATFORM_URL/sp/namespaces?userName=admin&adjustName=true"
      echo "Adding __superuser role to admin"
      $CURL -XPOST -H 'Content-Type: application/json' -d'{}' "$GIS_PLATFORM_URL/sp/account/user/admin/role/__superuser"
  fi

  echo "Logging as admin"
  $CURL -XPOST -H 'Content-Type: application/json' -d "$admin_login" "$GIS_PLATFORM_URL/sp/account/login"

  if ! grep -q -c refreshToken $cookie; then
      echo -e "\n\nFailed to get authorization cookie\n" >&2
      exit 1
  fi

  create_or_update_layer "RemoteTileService" "$(jq --arg url "${tiles_api_url}" '.urlFormat=$url' layer/2gis.json)"
  create_or_update_layer "RemoteTileService" "$(jq --arg url "${traffic_url}" '.urlFormat=$url' layer/2gis_traffic.json)"
  create_or_update_layer "LocalTileService" "$(cat layer/satellite_imagery.json)"

  echo "Configuring Map"
  $CURL -XPOST -H 'Content-Type: application/json' -d @configuration/MapConfig.json "$GIS_PLATFORM_URL/sp/settings?urlPath=/map"
  echo "Configuring Portal"
  $CURL -XPOST -H 'Content-Type: application/json' -d @configuration/PortalConfig.json "$GIS_PLATFORM_URL/sp/settings?urlPath=/portal"
  echo "Configuring Admin panel"
  $CURL -XPOST -H 'Content-Type: application/json' -d @configuration/AdminConfig.json "$GIS_PLATFORM_URL/sp/settings?urlPath=/admin"
  echo "Configuring map sharing"
  jq --arg url "${GIS_PLATFORM_URL#http*://}" '.connection.ws_url=$url+"/sp/ws/"' configuration/SharedConfig.json | $CURL -XPOST -H 'Content-Type: application/json' -d @- "$GIS_PLATFORM_URL/sp/settings?urlPath=/shared"

  layer_names=$(jq --slurp --compact-output '[ .[].name ]' layer/*.json)
  echo "Share all basemaps: $layer_names"
  $CURL -XPOST -H 'Content-Type: application/json-patch+json' -d "$layer_names" "$GIS_PLATFORM_URL/sp/resources/layers/shareAll"

  echo "Setting autoshared list for all basemaps"
  for layer in layer/*.json; do
      data=$(jq --compact-output '{name: .name, type: "layer"}' $layer)
      $CURL -XPOST -H 'Content-Type: application/json-patch+json' -d "$data" "$GIS_PLATFORM_URL/sp/autosharedList"
  done
}

#---------------

function dump_configuration {
    for layer in layer/*.json; do
        name=$(jq --raw-output .name $layer)
        echo "Fetching layer $name"
        get_layer_config $name | jq . > "$TMPDIR/layer_${name}.json"
    done
    for config in map portal admin shared; do
        echo "Fetching config: $config"
        $CURL -XGET "$GIS_PLATFORM_URL/sp/settings?urlPath=/$config" | jq . > "$TMPDIR/${config^}Config.json"
    done
    echo ""
    echo "Configs stored in $TMPDIR"
}

#---------------

function config_diff() {
#    dump_configuration
    for layer in layer/*.json; do
        name=$(jq --raw-output .name $layer)
        diff -urBb $layer $TMPDIR/layer_$name.json
    done
    for config in configuration/*.json; do
        diff -urBb $config $TMPDIR/$(basename $config)
    done
}

#---------------

HAS_OPT=0
CONFIGURE=0
DUMP_CONFIG=0
DIFF_CONFIG=0
PATCH_LAYERS=0
IGNORE_CERT=''

while getopts "gdphck" opt; do
    case "$opt" in
        "d") HAS_OPT=1 && DIFF_CONFIG=1 ;;
        "g") HAS_OPT=1 && DUMP_CONFIG=1 ;;
        "c") HAS_OPT=1 && CONFIGURE=1 ;;
        "p") HAS_OPT=1 && CONFIGURE=1 && PATCH_LAYERS=1 ;;
        "k") IGNORE_CERT='-k' ;;
        "h") usage && exit 0 ;;
        "?") usage && exit 1 ;;
    esac
done

if [[ $HAS_OPT -eq 0 ]]; then
    usage
    exit 0
fi

if [[ -z $GIS_PLATFORM_PASS ]] || [[ -z $GIS_PLATFORM_URL ]] || [[ -z $GIS_PLATFORM_TILES_API ]] || [[ -z $GIS_PLATFORM_TRAFFIC_API ]]; then
    echo -e "\n\nSet GIS_PLATFORM_TRAFFIC_API, GIS_PLATFORM_TILES_API, GIS_PLATFORM_PASS and GIS_PLATFORM_URL\n" >&2
    exit 1
fi

tiles_api_url="${GIS_PLATFORM_TILES_API%/}/tiles?x={2}&y={3}&z={1}&v=1.5&ts=online_sd_ar&layerType=nc"
traffic_url="${GIS_PLATFORM_TRAFFIC_API}/dammam/traffic/{1}/{2}/{3}/speed/0/?1640062200"

superuser_login=''
read -r -d '' superuser_login <<-EOF_SUPERUSER_LOGIN
{ "username":"superuser", "password":"$GIS_PLATFORM_PASS" }
EOF_SUPERUSER_LOGIN

read -r -d '' admin_account <<-EOF_ADMIN_ACC
{ "username": "admin", "password":"$GIS_PLATFORM_PASS", "email": "admin_user@example.com", "is_subscribed": false, "namespace": "admin" }
EOF_ADMIN_ACC

admin_login=''
read -r -d '' admin_login <<-EOF_ADMIN_LOGIN
{ "username":"admin", "password":"$GIS_PLATFORM_PASS" }
EOF_ADMIN_LOGIN

set -E
set -e
set -u

WORKDIR=$( cd $(dirname $0) ; pwd )
pushd "$WORKDIR" > /dev/null

TMPDIR="${WORKDIR}/_tmp/${GIS_PLATFORM_URL#http*://}"
mkdir -p "$TMPDIR"

cookie=$(mktemp "$WORKDIR/_tmp/gis-platform.cookie.XXXXXX")
trap "rm -f $cookie ; popd > /dev/null" EXIT

CURL="curl -s -S -b $cookie -c $cookie $IGNORE_CERT"

echo "Configuring $GIS_PLATFORM_URL"

echo "Authorizing"
$CURL -XPOST -H 'Content-Type: application/json' -d "$superuser_login" "$GIS_PLATFORM_URL/sp/account/login"

if ! grep -q refreshToken $cookie; then
    echo -e "\n\nFailed to get authorization cookie\n" >&2
    exit 1
fi

if [[ $DUMP_CONFIG -eq 1 ]]; then
    dump_configuration
fi

if [[ $DIFF_CONFIG -eq 1 ]]; then
    config_diff
fi

if [[ $CONFIGURE -eq 1 ]]; then
    configure
fi
