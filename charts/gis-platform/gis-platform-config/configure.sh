#!/bin/bash

: ${GIS_PLATFORM_URL:=''}
: ${GIS_PLATFORM_PASS:=''}
: ${GIS_PLATFORM_TILES_API:=''}
: ${GIS_PLATFORM_TRAFFIC_API:=''}

function create_or_update_layer() {
    layer_type="$1"
    layer_data="$2"
    layer_name=$( jq --raw-output .name <<< $layer_data )

    if [[ -z $( $CURL -XGET "$GIS_PLATFORM_URL/sp/layers/$layer_name" | jq --raw-output .name ) ]]; then
        echo "Configuring $layer_name $layer_type"
        echo $layer_data | $CURL -XPOST -H 'Content-Type: application/json' -d @- "$GIS_PLATFORM_URL/sp/layers?type=$layer_type"
    else
        echo "Updating $layer_name configuration"
        echo $layer_data | $CURL -XPATCH -H 'Content-Type: application/json' -d @- "$GIS_PLATFORM_URL/sp/layers/$layer_name?type=$layer_type" > /dev/null
    fi
}

if [[ -z $GIS_PLATFORM_PASS ]] || [[ -z $GIS_PLATFORM_URL ]] || [[ -z $GIS_PLATFORM_TILES_API ]] || [[ -z $GIS_PLATFORM_TRAFFIC_API ]]; then
    echo -e "\n\nSet GIS_PLATFORM_TRAFFIC_API, GIS_PLATFORM_TILES_API, GIS_PLATFORM_PASS and GIS_PLATFORM_URL\n" >&2
    exit 1
fi

tiles_api_url="${GIS_PLATFORM_TILES_API%/}/tiles?x={2}&y={3}&z={1}&v=1.5&ts=online_sd_ar&layerType=nc"
traffic_url="${GIS_PLATFORM_TRAFFIC_API}/dammam/traffic/{1}/{2}/{3}/speed/0/?1640062200"

cookie=$(mktemp gis-platform.cookie.XXXXX)

trap "rm -f $cookie" EXIT

CURL="curl -s -S -b $cookie -c $cookie"

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

echo "Configuring $GIS_PLATFORM_URL"

echo "Authorizing"
$CURL -XPOST -H 'Content-Type: application/json' -d "$superuser_login" "$GIS_PLATFORM_URL/sp/account/login"

if ! grep --silent -c refreshToken $cookie; then
    echo -e "\n\nFailed to get authorization cookie\n" >&2
    exit 1
fi

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

if ! grep --silent -c refreshToken $cookie; then
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
