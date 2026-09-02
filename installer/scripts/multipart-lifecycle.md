## Управление S3 хранилищем

### Lifecycle политики

#### Очистка незавершенных multipart загрузок

**Проблема:** При прерванных multipart загрузках части файлов остаются
в хранилище и занимают место, но не видны в обычном листинге.

**Решение:** Настройка lifecycle политики для автоматической очистки.

**Проверка незавершенных загрузок:**

```bash
./check_s3_multipart_uploads.sh
```

**Пример политики** представлен в файле [s3-lifecycle-multipart.xml](./s3-lifecycle-multipart.xml)

Для применения политики для выбранного бакета выполните

```sh
s3cmd setlifecycle s3-lifecycle-multipart.xml s3://on-premise-demo
```

Проверить, что значение применилось можно выполнив команду

```sh
s3cmd getlifecycle s3://on-premise-demo
```

Удалить политику с бакета можно командой

```sh
s3cmd dellifecycle s3://on-premise-demo
```
