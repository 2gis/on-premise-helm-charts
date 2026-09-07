#!/bin/bash
#
# Очистка от старых манифест-файлов в s3.
# Запускать только после обновления всех данных.
# Особенно касается search-api, который при запуске забирает данные из s3 по манифесту, с которым его запустили.

CFG=${1? "Не указан файл конфигурации dgctl"} # Файл конфигурации dgctl

KEEP_MANIFEST_COUNT=12 # Количесво манифестов оставить.

COMPONENTS=`yq e '.components | keys | .[]' "$CFG"`

function manifest_list(){
  echo "Выводим список манифестов"
  for component in $COMPONENTS; do
    echo "Манифесты $component"
    docker run --net=host --rm \
    -v `pwd`/$CFG:/config.yaml \
    -u `id -u`:`grep docker /etc/group | cut -d : -f 3` \
  2gis/dgctl:3 manifest list --config=/config.yaml --component $component
  done
}

function manifest_cleanup(){
  echo "Запускаем очистку. Останется $KEEP_MANIFEST_COUNT"
  for component in $COMPONENTS; do
    echo "Очистка $component"
    docker run --net=host --rm \
    -v `pwd`/$CFG:/config.yaml \
    -u `id -u`:`grep docker /etc/group | cut -d : -f 3` \
    2gis/dgctl:3 manifest cleanup --config=/config.yaml --component $component --keep-count $KEEP_MANIFEST_COUNT
  done
}

while true; do
    read -p "Вы действительно сделали dgctl pull и полный импорт данных? " answer
    case $answer in
        [Yy]* ) manifest_cleanup; break;;
        [Ll]* ) manifest_list; break;;
        [Nn]* ) echo "Выходим!"; exit;;
        * ) echo "Выберите между yes или no. List - список манифестов";;
    esac
done
