#!/bin/bash

set -e
set -u

RESET=false
UPDATE=false

while getopts "ru" opt; do
    case "$opt" in
        "r") RESET=true ;;
        "u") UPDATE=true ;;
    esac
done

envsubst < /app/SPCore.json.template > /app/SPCore.json

/usr/bin/dotnet SPCore.App.Public.dll --updateDb=$UPDATE --resetCluster=$RESET --continue=true
