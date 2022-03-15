#!/bin/bash

: ${GIS_PLATFORM_URL:=''}
: ${GIS_PLATFORM_PASS:=''}
: ${GIS_PLATFORM_TILES_API:=''}
: ${GIS_PLATFORM_TRAFFIC_API:=''}

if [[ -z $GIS_PLATFORM_PASS ]] || [[ -z $GIS_PLATFORM_URL ]] || [[ -z $GIS_PLATFORM_TILES_API ]] || [[ -z $GIS_PLATFORM_TRAFFIC_API ]]; then
    echo -e "\n\nSet GIS_PLATFORM_TRAFFIC_API, GIS_PLATFORM_TILES_API, GIS_PLATFORM_PASS and GIS_PLATFORM_URL\n" >&2
    exit 1
fi

tileserver_url="${GIS_PLATFORM_TILES_API%/}/tiles?x={2}&y={3}&z={1}&v=1.5&ts=online_sd_ar&layerType=nc"
traffic_url="${GIS_PLATFORM_TRAFFIC_API}/dammam/traffic/{1}/{2}/{3}/speed/0/?1640062200"

cookie=$(mktemp evergis.cookie.XXXXX)

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


set -e
set -u

echo "Authorizing"
$CURL -XPOST -H 'Content-Type: application/json' -d "$superuser_login" "$GIS_PLATFORM_URL/sp/account/login"

if ! grep --silent -c refreshToken $cookie; then
    echo -e "\n\nFailed to get authorization cookie\n" >&2
    exit 1
fi

echo "Creating admin user"
$CURL -XPOST -H 'Content-Type: application/json' -d "$admin_account" "$GIS_PLATFORM_URL/sp/account"
echo "Adding __superuser role to admin"
$CURL -XPOST -H 'Content-Type: application/json' -d'{}' "$GIS_PLATFORM_URL/sp/account/user/admin/role/__superuser"

echo "Logging as admin"
echo "Authorizing"
$CURL -XPOST -H 'Content-Type: application/json' -d "$admin_login" "$GIS_PLATFORM_URL/sp/account/login"

if ! grep --silent -c refreshToken $cookie; then
    echo -e "\n\nFailed to get authorization cookie\n" >&2
    exit 1
fi

echo "Configuring RemoteTileService for 2GIS Basemap"
jq --arg url "${tileserver_url}" '.urlFormat=$url' layer/tiles_api.json | $CURL -XPOST -H 'Content-Type: application/json' -d @- "$GIS_PLATFORM_URL/sp/layers?type=RemoteTileService"
echo "Configuring RemoteTileService for 2GIS Traffic"
jq --arg url "${traffic_url}" '.urlFormat=$url'  layer/tiles_traffic.json | $CURL -XPOST -H 'Content-Type: application/json' -d @- "$GIS_PLATFORM_URL/sp/layers?type=RemoteTileService"
echo "Configuring LocalTileService for Satellite imagery"
$CURL -XPOST -H 'Content-Type: application/json' -d @layer/s3_satellite.json "$GIS_PLATFORM_URL/sp/layers?type=LocalTileService"
echo "Configuring Map"
$CURL -XPOST -H 'Content-Type: application/json' -d @config/MapConfig.json "$GIS_PLATFORM_URL/sp/settings?urlPath=/map"
echo "Configuring Portal"
$CURL -XPOST -H 'Content-Type: application/json' -d @config/PortalConfig.json "$GIS_PLATFORM_URL/sp/settings?urlPath=/portal"
echo "Configuring map sharing"
jq --arg url "${GIS_PLATFORM_URL#http*://}" '.connection.ws_url=$url+"/sp/ws/"' config/SharedConfig.json | $CURL -XPOST -H 'Content-Type: application/json' -d @- "$GIS_PLATFORM_URL/sp/settings?urlPath=/shared"
echo "Configuring Printing"
for template in print/*.cshtml; do
    echo "Uploading template: $template"
    $CURL -XPOST -H 'accept: */*' -H 'Content-Type: multipart/form-data' -F "template=@${template}" "$GIS_PLATFORM_URL/sp/print/templates?name=$template&rewrite=false"
done

echo "Setting permissions"
for layer in layer/*json; do
    layer_name=$(jq --raw-output .name $layer)
    acl='{"data":[{"role":"__superuser","permissions":"read,write,configure"},{"role":"__admin","permissions":"read,write,configure"},{"role":"__public","permissions":"read"}]}'
    $CURL -XPOST -H 'Content-Type: application/json-patch+json' -d "$acl" "$GIS_PLATFORM_URL/sp/layers/$layer_name/permissions"

rm $cookie
