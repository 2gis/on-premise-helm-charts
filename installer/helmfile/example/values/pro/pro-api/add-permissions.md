
# `add-permissions.sh`

## 📌 Описание
Скрипт `add-permissions.sh` предназначен для отправки запроса к API, добавляя разрешения для указанного пользователя.

## 📂 Файлы в проекте

- `add-permissions.sh` – основной Bash-скрипт
- `add-permissions.json` – JSON-файл с перечнем разрешений
- `add-permissions.md` – инструкция по использованию

---

## 🚀 Как использовать

### 1️⃣ Подготовьте файл `add-permissions.json`
Этот файл содержит список разрешений в формате JSON. Пример:

```json
[
    {
        "resource_type": "project",
        "resource": "1234",
        "permission": "read"
    },
    {
        "resource_type": "file",
        "resource": "5678",
        "permission": "write"
    }
]
```

### 2️⃣ Убедитесь, что у скрипта есть права на выполнение

Перед запуском проверьте, что `add-permissions.sh` является исполняемым файлом:
```bash
ls -l add-permissions.sh
```
Если в начале строки нет `x` (например, `-rw-r--r--`), дайте права на исполнение:
```bash
chmod +x add-permissions.sh
```

### 3️⃣ Запустите скрипт
Передайте `user_id` в качестве аргумента:

```bash
./add-permissions.sh <user_id>
```

🔹 **Пример:**
```bash
./add-permissions.sh 123456
```
Где `123456` – ID пользователя, которому будут применены разрешения.

### 4️⃣ Скрипт выполняет следующие действия:
✅ Проверяет, указан ли `user_id`.

✅ Проверяет наличие файла `add-permissions.json`.

✅ Формирует JSON-запрос с `user_id` и разрешениями.

✅ Отправляет `PUT`-запрос на API.

✅ Выводит результат выполнения.

---

## 🛠 Конфигурация

**Переменные внутри скрипта** (редактируйте перед запуском):
```bash
API_ENDPOINT="https://api.example.com" # Замените на ваш API URL
API_TOKEN="your_api_token"            # Укажите ваш API-токен
```

---

## 🔄 Пример успешного выполнения

```plaintext
Generated JSON:
{
  "org_account_id": "123456",
  "user_id": "123456",
  "permissions": [
    {
      "resource_type": "project",
      "resource": "1234",
      "permission": "read"
    },
    {
      "resource_type": "file",
      "resource": "5678",
      "permission": "write"
    }
  ]
}
Request sent successfully. Response:
{"status":"success","message":"Permissions applied successfully"}
Script execution completed.
```

---

## ⚠ Возможные ошибки и их решения

| Ошибка | Возможная причина | Решение |
|--------|------------------|---------|
| `Usage: ./add-permissions.sh <user_id>` | Не указан `user_id` при запуске. | Добавьте `user_id` в команду. |
| `Error: Permissions file add-permissions.json not found!` | Отсутствует файл `add-permissions.json`. | Убедитесь, что файл существует в рабочей директории. |
| `Error: command not found: curl` | `curl` не установлен в системе. | Установите `curl`: `sudo apt install curl` (Debian/Ubuntu) или `sudo yum install curl` (RHEL/CentOS). |
| `Error sending request.` | Неверный `API_TOKEN`, `API_ENDPOINT` или формат JSON. | Проверьте API-токен, URL и JSON. |

---

## 📌 Дополнительная информация

- Скрипт использует `curl` для отправки API-запроса.
- Обработаны базовые ошибки, включая отсутствие файла или параметров.
- JSON-структура динамически формируется в коде.

---

💡 **Совет**
Если вам нужно отправить другой набор разрешений, просто измените `add-permissions.json` перед запуском.
