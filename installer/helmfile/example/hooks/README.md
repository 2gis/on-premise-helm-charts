В директории `hooks/` можно создать папку по имени сервиса и определить для него дополнительные хуки списком

Имя файла должно соответствовать форме `<env_name>.yaml.gotmpl`

Например, `hooks/core/keys/staging.yaml.gotmpl` со следующим содержимым:

```
- events: [presync]
    showlogs: true
    command: "echo"
    args:
    - "START"
```
