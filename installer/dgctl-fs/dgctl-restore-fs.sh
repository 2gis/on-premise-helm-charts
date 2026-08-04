#!/bin/bash
# Выполнять на хосте в закрытом контуре, где есть s3

# Выгружает из папки ./dgctl-source образы сервисов в docker-registry, данные в s3
docker run --rm \
    -v $(pwd)/dgctl-config-s3.yaml:/dgctl-config.yaml \
    -v $(pwd)/dgctl-source:/dgctl-source \
    -v $(pwd)/values:/values \
    --user $(id -u):$(id -g) \
    2gis/dgctl:3 \
    restore --config=/dgctl-config.yaml --from-dir=/dgctl-source --apps-to-registry
