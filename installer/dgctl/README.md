Для корректной работы pull.sh и manifest_cleanup.sh требуется:

- иметь прямой доступ по ssh к хостам БД
- установить утилиту yq


```
wget https://github.com/mikefarah/yq/releases/download/v4.33.3/yq_linux_amd64 -O /usr/bin/yq
chmod +x /usr/bin/yq
```

Перед запуском актуализируйте версии компонентов в конфиг-файле dgctl для получения корректных версий приложений.

`dgctl pull --generate-values` записывает сгенерированные значения (включая актуальный номер `manifest`)
в `installer/dgctl/auto_values/<component>/general.yaml` - эти файлы читает helmfile, вручную менять их не нужно.

Запуск:

```bash
${HELMFILE_BASE}/../dgctl/pull.sh dgctl-config-sandbox.yaml      # данные и образы
${HELMFILE_BASE}/../dgctl/pull.sh dgctl-config-sandbox.yaml -l   # только лицензия
```

Конфиг резолвится через `$HELMFILE_VALUES/dgctl/<имя>`.
