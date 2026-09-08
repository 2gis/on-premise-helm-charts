#!/bin/bash
# Выполнять на хосте  закрытом контуре, где есть s3
# Содержимое ./dgctl-source-license перенести на хост с интернетом

# Скопируйте файлы для запроса лицензии из S3 в fs:
docker run --rm \
    -v $(pwd)/dgctl-config-s3.yaml:/dgctl-config.yaml \
    -v $(pwd)/dgctl-source-license:/dgctl-source \
    --user $(id -u):$(id -g) \
    2gis/dgctl:3 \
    save --config=/dgctl-config.yaml --to-dir /dgctl-source --only-license

# Проверьте наличие всех необходимых файлов для запроса лицензии:
docker run --rm \
    -v $(pwd)/dgctl-config-s3.yaml:/dgctl-config.yaml \
    -v $(pwd)/dgctl-source-license:/dgctl-source \
    --user $(id -u):$(id -g) \
    2gis/dgctl:3 \
    license --config=/dgctl-config.yaml --dry-run
