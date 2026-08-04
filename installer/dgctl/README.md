Для корректной работы pull.sh и manifest_cleanup.sh требуется:

- иметь прямой доступ по ssh к хостам БД
- установить утилиту yq


```
wget https://github.com/mikefarah/yq/releases/download/v4.33.3/yq_linux_amd64 -O /usr/bin/yq
chmod +x /usr/bin/yq
```

Перед запуcком pull.sh актуализировать версии компонентов в конфиг файлах `dgctl-config-production.yaml` и `dgctl-config-staging.yaml` для получения корректных версий приложений
