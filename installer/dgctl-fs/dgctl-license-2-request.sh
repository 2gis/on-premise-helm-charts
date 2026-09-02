#!/bin/bash
# Выполнять на хосте где есть интернет
# Содержимое ./dgctl-source-license перенести на хост в закрытый контур

# Запрос лицензий
docker run --rm \
    -v $(pwd)/dgctl-config-fs.yaml:/dgctl-config.yaml \
    -v $(pwd)/dgctl-source-license:/dgctl-source \
    --user $(id -u):$(id -g) \
    2gis/dgctl:3 \
    license --config=/dgctl-config.yaml
