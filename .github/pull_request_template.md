# Pull Request description

## Changelog

- `Some changes` (A description of the changes proposed in the pull request.)

## Issues

- `Issue-123` (Link to related issue)

## Breaking changes

- If there are breaking changes, they need to be added to the file [Breaking-Changes](../Breaking-Changes.md)

## Check-list. Чек-лист код-ревью

- [ ] Запрос на слияние в develop.
- [ ] Есть описание к PR.
- [ ] Указаны блокирующие изменения. [Breaking-Changes](../Breaking-Changes.md)
- [ ] Соответствие кода принятому [стилю](../styleguide.md)
  - [ ] Описание настроек.
  - [ ] Именование настроек.
  - [ ] Дефолтные значения.
  - [ ] Стиль кода.
- [ ] Работоспособность. Разворачивается на своем окружении из ветки PR.
  - [ ] Тест API через тесты helmfile-хуков или коллекций Postman.
- [ ] Не осталось мусора от удаления каких-то параметров. Ищется поиском по проекту из ветки PR.
- [ ] Отработка линтера на чарт из ветки PR. Пример: `helm lint charts/search-api`
