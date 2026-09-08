#!/bin/bash
# Выполнять на хосте в закрытом контуре, где есть s3

# Скопируйте файл с лицензией из fs в S3:
docker run --rm \
    -v $(pwd)/dgctl-config-s3.yaml:/dgctl-config.yaml \
    -v $(pwd)/dgctl-source-license:/dgctl-source \
    --user $(id -u):$(id -g) \
    2gis/dgctl:3 \
    restore --config=/dgctl-config.yaml --from-dir /dgctl-source --only-license
