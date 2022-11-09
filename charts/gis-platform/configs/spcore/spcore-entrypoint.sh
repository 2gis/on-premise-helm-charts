#!/bin/bash

set -e
set -u

RESET=false
UPDATE=false
CONTINUE=false
SYNC=false

while getopts "rucs" opt; do
    case "$opt" in
        "r") RESET=true ;;
        "u") UPDATE=true ;;
        "c") CONTINUE=true ;;
        "s") SYNC=true ;;
    esac
done

envsubst < /app/SPCore.json.template > /app/SPCore.json

if [[ "$SYNC" == "true" ]]; then
    echo SYNCING PARAMETERS: start
    /usr/bin/dotnet SPCore.App.Public.dll --syncParameters=true
    echo SYNCING PARAMETERS: done
fi

exec /usr/bin/dotnet SPCore.App.Public.dll --updateDb=$UPDATE --resetCluster=$RESET --continue=$CONTINUE
