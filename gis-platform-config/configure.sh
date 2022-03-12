#!/bin/bash

: ${GIS_PLATFORM_URL:=''}
: ${GIS_PLATFORM_USER:='superuser'}
: ${GIS_PLATFORM_PASS:=''}
: ${GIS_PLATFORM_TILES_API:=''}

if [[ -z $GIS_PLATFORM_PASS ]] || [[ -z $GIS_PLATFORM_USER ]] || [[ -z $GIS_PLATFORM_URL ]] || [[ -z $GIS_PLATFORM_TILES_API ]]; then
    echo -e "\n\nSet GIS_PLATFORM_TILES_API, GIS_PLATFORM_PASS, GIS_PLATFORM_USER and GIS_PLATFORM_URL\n" >&2
    exit 1
fi

tileserver_url="${GIS_PLATFORM_TILES_API%/}/tiles?x={2}&y={3}&z={1}&v=1.5&ts=online_sd_ar&layerType=nc"

cookie=$(mktemp evergis.cookie.XXXXX)
login=''
read -r -d '' login <<-EOF_LOGIN
{ "username":"$GIS_PLATFORM_USER", "password":"$GIS_PLATFORM_PASS" }
EOF_LOGIN

set -e
set -u

echo "Authorizing"
curl -s -S -b $cookie -c $cookie -XPOST -H 'Content-Type: application/json' -d "$login" "$GIS_PLATFORM_URL/sp/account/login"

if ! grep --silent -c refreshToken $cookie; then
    echo -e "\n\nFailed to get authorization cookie\n" >&2
    exit 1
fi

echo "Configuring RemoteTileService for 2GIS Basemap"
jq --arg url ${tileserver_url} '.urlFormat=$url' RemoteTileService.json | curl -s -S -b $cookie -c $cookie -XPOST -H 'Content-Type: application/json' -d @- "$GIS_PLATFORM_URL/sp/layers?type=RemoteTileService"
echo "Configuring RemoteTileService for 2GIS Traffic"
curl -s -S -b $cookie -c $cookie -XPOST -H 'Content-Type: application/json' -d @- "$GIS_PLATFORM_URL/sp/layers?type=RemoteTileService"
echo "Configuring LocalTileService for Satellite imagery"
curl -s -S -b $cookie -c $cookie -XPOST -H 'Content-Type: application/json' -d @LocalTileService.json "$GIS_PLATFORM_URL/sp/layers?type=LocalTileService"
echo "Configuring Map"
curl -s -S -b $cookie -c $cookie -XPOST -H 'Content-Type: application/json' -d @MapConfig.json "$GIS_PLATFORM_URL/sp/settings?urlPath=/map"
echo "Configuring Portal"
curl -s -S -b $cookie -c $cookie -XPOST -H 'Content-Type: application/json' -d @PortalConfig.json "$GIS_PLATFORM_URL/sp/settings?urlPath=/portal"
echo "Configuring Printing"
for template in print/*.cshtml; do
    echo "Uploading template: $template"
    curl -s -S -b $cookie -c $cookie -XPOST -H 'accept: */*' -H 'Content-Type: multipart/form-data' -F "template=@${template}" "$GIS_PLATFORM_URL/sp/print/templates?name=$template&rewrite=false"
done

rm $cookie
