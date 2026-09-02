#!/bin/bash
# Выполнять на хосте где есть интернет
# Содержимое ./dgctl-source перенести на хост в закрытый контур

# Загружает образы сервисов и данные из datagateway в папку ./dgctl-source
docker run --rm \
    -v $(pwd)/dgctl-config-fs.yaml:/dgctl-config.yaml \
    -v $(pwd)/dgctl-source:/dgctl-source \
    -v $(pwd)/values:/values \
    --user $(id -u):$(id -g) \
    2gis/dgctl:3 \
    pull --config=/dgctl-config.yaml --generate-values
