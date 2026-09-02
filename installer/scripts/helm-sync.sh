#!/bin/bash

# ## 1. Скачивание чартов для переноса в закрытый контур:
# # На машине с доступом к интернету
# ./helm-sync.sh --download

# # Создать архив для переноса
# ./helm-sync.sh --pack

# # Скопировать созданный архив на носитель

# ## 2. Загрузка чартов в закрытом контуре:
# # В закрытом контуре: извлечь архив
# ./helm-sync.sh --extract helm-charts-20231215-140530.tar.gz

# # Проверить статус
# ./helm-sync.sh --status

# # Загрузить чарты в приватный registry
# ./helm-sync.sh --upload

# ## 3. Прямая синхронизация (если есть доступ к обоим registry):
# ./helm-sync.sh --sync

# ## 4. Дополнительные команды:
# # Показать конфигурацию
# ./helm-sync.sh --config

# # Показать статус
# ./helm-sync.sh --status

# # Очистить локальные данные
# ./helm-sync.sh --clean

## Структура файлов:
# .
# ├── helm-sync.sh              # Основной скрипт
# ├── charts-index.txt          # Индекс скачанных чартов
# ├── helm-charts/              # Директория с чартами
# │   ├── chart1-1.0.0.tgz
# │   ├── chart2-2.1.0.tgz
# │   └── ...
# └── helm-charts-YYYYMMDD-HHMMSS.tar.gz  # Архив для переноса


# Конфигурация
DEFAULT_SOURCE_REGISTRY="# TODO internal source registry"
ONPREMISE_CHART_VERSION="1.40.0"
TARGET_REGISTRY="your-private-registry.local"  # Замените на ваш приватный registry
TARGET_REGISTRY_USER="helm-sync-user"           # Замените на ваше имя пользователя (оставьте пустым для anonymous)
TARGET_REGISTRY_PASS=""                        # Замените на ваш пароль (оставьте пустым для anonymous)

# Директории для offline режима
CHARTS_DIR="./helm-charts"                     # Директория для хранения скачанных чартов
CHARTS_INDEX_FILE="charts-index.txt"           # Файл с индексом чартов

# Список чартов, их версий и источников
# Формат: ["chart_name"]="version|source_registry"
# Если source_registry не указан, используется DEFAULT_SOURCE_REGISTRY
# Собираем ls installer/helmfile/services/*.yaml | grep -v -E "navi-back|navi-attr|navi-async"| xargs cat | sed 's/{{ *//g; s/ *}}//g' | yq '.releases[] | .name + " | " + .version + " | " + .chart'
declare -A CHARTS=(
    # ["chart1"]="1.0.0|ghcr.io/2gis/charts"
    # ["chart2"]="2.1.0|registry.k8s.io/charts"
    # ["chart3"]="1.5.2"  # Будет использован DEFAULT_SOURCE_REGISTRY
    # ["chart4"]="3.0.0|harbor.company.com/charts"
    # Добавьте нужные чарты, их версии и источники
    ["catalog-api"]="${ONPREMISE_CHART_VERSION}"
    ["keys"]="${ONPREMISE_CHART_VERSION}"
    ["license"]="${ONPREMISE_CHART_VERSION}"
    ["mapgl-js-api"]="${ONPREMISE_CHART_VERSION}"
    ["navi-castle"]="${ONPREMISE_CHART_VERSION}"
    ["navi-front"]="${ONPREMISE_CHART_VERSION}"
    ["navi-restrictions"]="${ONPREMISE_CHART_VERSION}"
    ["navi-router"]="${ONPREMISE_CHART_VERSION}"
    ["navi-back"]="${ONPREMISE_CHART_VERSION}"
    ["navi-attractor"]="${ONPREMISE_CHART_VERSION}"
    ["navi-vrp-task-manager"]="${ONPREMISE_CHART_VERSION}"
    ["navi-vrp-solver"]="${ONPREMISE_CHART_VERSION}"
    ["platform"]="${ONPREMISE_CHART_VERSION}"
    ["pro-api"]="${ONPREMISE_CHART_VERSION}"
    ["pro-ui"]="${ONPREMISE_CHART_VERSION}"
    ["search-api"]="${ONPREMISE_CHART_VERSION}"
    ["styles-api"]="${ONPREMISE_CHART_VERSION}"
    ["tiles-api"]="${ONPREMISE_CHART_VERSION}"
    ["traffic-proxy"]="${ONPREMISE_CHART_VERSION}"
    ["keycloak"]="${ONPREMISE_CHART_VERSION}"
    ["manifest-cleaner"]="0.0.3"
    ["pgbackup"]="0.0.8"
    ["prometheus"]="1.4.10|# TODO internal registry"
    ["kibana"]="11.5.2|# TODO internal registry"
    ["redis"]="18.6.1|# TODO internal registry"
    ["haproxy"]="2.1.8|# TODO internal registry"
    ["grafana"]="8.11.3|# TODO internal registry"
)

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для логирования
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Проверка наличия необходимых утилит
check_requirements() {
    local mode=$1

    log "Проверка наличия необходимых утилит для режима: $mode..."

    if ! command -v helm &> /dev/null; then
        error "Helm не найден. Установите Helm для продолжения."
        exit 1
    fi

    if [[ "$mode" == "upload" ]] || [[ "$mode" == "sync" ]]; then
        if ! command -v docker &> /dev/null; then
            error "Docker не найден. Установите Docker для продолжения."
            exit 1
        fi
    fi

    log "Все необходимые утилиты найдены."
}

# Аутентификация в приватном registry
authenticate_registry() {
    log "Аутентификация в приватном registry..."

    # Проверяем, нужна ли аутентификация
    if [ -z "$TARGET_REGISTRY_USER" ] && [ -z "$TARGET_REGISTRY_PASS" ]; then
        log "Аутентификация не требуется (anonymous доступ)"
        return 0
    fi

    # Аутентификация с паролем
    if [ -n "$TARGET_REGISTRY_PASS" ]; then
        echo "$TARGET_REGISTRY_PASS" | helm registry login "$TARGET_REGISTRY" --username "$TARGET_REGISTRY_USER" --password-stdin

        if [ $? -ne 0 ]; then
            error "Ошибка аутентификации в приватном registry с паролем"
            exit 1
        fi

        log "Успешная аутентификация в приватном registry с паролем"
        return 0
    fi

    # Аутентификация без пароля (используем существующие credentials)
    if [ -n "$TARGET_REGISTRY_USER" ]; then
        # Проверяем, есть ли уже сохраненные credentials
        if helm registry login "$TARGET_REGISTRY" --username "$TARGET_REGISTRY_USER" --password-stdin <<< ""; then
            log "Используются существующие credentials для $TARGET_REGISTRY_USER"
        else
            # Пытаемся использовать Docker credentials
            log "Пытаемся использовать Docker credentials..."
            if docker login "$TARGET_REGISTRY" --username "$TARGET_REGISTRY_USER" --password-stdin <<< ""; then
                log "Успешная аутентификация через Docker credentials"
            else
                warn "Не удалось аутентифицироваться. Продолжаем без аутентификации."
            fi
        fi
    else
        log "Продолжаем без аутентификации"
    fi
}

# Парсинг информации о чарте
parse_chart_info() {
    local chart_info=$1
    local chart_name=$2

    if [[ "$chart_info" == *"|"* ]]; then
        # Есть кастомный source registry
        echo "${chart_info#*|}" # Возвращаем часть после |
    else
        # Используем дефолтный source registry
        echo "$DEFAULT_SOURCE_REGISTRY"
    fi
}

# Получение версии чарта
get_chart_version() {
    local chart_info=$1

    if [[ "$chart_info" == *"|"* ]]; then
        # Есть кастомный source registry, возвращаем версию (часть до |)
        echo "${chart_info%|*}"
    else
        # Только версия
        echo "$chart_info"
    fi
}

# Аутентификация в source registry при необходимости
authenticate_source_registry() {
    local source_registry=$1

    # Список публичных registries, которые не требуют аутентификации
    local public_registries=("ghcr.io" "registry.k8s.io" "docker.io" "quay.io")

    local registry_host=$(echo "$source_registry" | cut -d'/' -f1)

    # Проверяем, является ли registry публичным
    for public_reg in "${public_registries[@]}"; do
        if [[ "$registry_host" == "$public_reg" ]]; then
            return 0  # Не нужна аутентификация
        fi
    done

    # Для приватных registries пытаемся использовать существующие credentials
    log "Проверка аутентификации для $source_registry..."

    # Пытаемся использовать существующие Docker credentials
    if docker info &> /dev/null; then
        log "Используются существующие Docker credentials для $source_registry"
    else
        warn "Возможно потребуется аутентификация для $source_registry"
    fi
}

# Функция для скачивания чарта
download_chart() {
    local chart_name=$1
    local chart_info=$2

    local chart_version=$(get_chart_version "$chart_info")
    local source_registry=$(parse_chart_info "$chart_info" "$chart_name")

    log "Скачивание чарта: $chart_name:$chart_version"
    log "Источник: oci://$source_registry"

    # Аутентификация в source registry если необходимо
    authenticate_source_registry "$source_registry"

    # Сохраняем текущую директорию
    local current_dir=$(pwd)

    # Создаем директорию для чартов если её нет
    mkdir -p "$CHARTS_DIR"

    # Скачиваем чарт
    log "Скачивание чарта $chart_name:$chart_version из $source_registry..."

    # Переходим в директорию для чартов
    cd "$CHARTS_DIR"

    helm pull "oci://$source_registry/$chart_name" --version "$chart_version"

    if [ $? -ne 0 ]; then
        error "Ошибка скачивания чарта $chart_name:$chart_version"
        cd "$current_dir"  # Возвращаемся в исходную директорию
        return 1
    fi

    # Проверяем, что файл скачался
    local chart_file="${chart_name}-${chart_version}.tgz"
    if [ ! -f "$chart_file" ]; then
        error "Файл чарта не найден: $chart_file"
        cd "$current_dir"  # Возвращаемся в исходную директорию
        return 1
    fi

    # Возвращаемся в исходную директорию
    cd "$current_dir"

    # Записываем информацию о чарте в индекс
    echo "$chart_name|$chart_version|$source_registry|$chart_file" >> "$CHARTS_INDEX_FILE"

    log "Чарт $chart_name:$chart_version успешно скачан"
    return 0
}

# Функция для загрузки чарта из локального файла
upload_chart() {
    local chart_name=$1
    local chart_version=$2
    local chart_file=$3

    log "Загрузка чарта: $chart_name:$chart_version"
    log "Файл: $chart_file"
    log "Назначение: oci://$TARGET_REGISTRY"

    # Проверяем существование файла
    if [ ! -f "$CHARTS_DIR/$chart_file" ]; then
        error "Файл чарта не найден: $CHARTS_DIR/$chart_file"
        return 1
    fi

    # Отправляем чарт в приватный registry
    log "Отправка чарта $chart_name:$chart_version в $TARGET_REGISTRY..."
    helm push "$CHARTS_DIR/$chart_file" "oci://$TARGET_REGISTRY"

    if [ $? -eq 0 ]; then
        log "Чарт $chart_name:$chart_version успешно отправлен в приватный registry"
        return 0
    else
        error "Ошибка отправки чарта $chart_name:$chart_version в приватный registry"
        return 1
    fi
}

# Функция для обычной синхронизации (download + upload)
process_chart() {
    local chart_name=$1
    local chart_info=$2

    local chart_version=$(get_chart_version "$chart_info")
    local source_registry=$(parse_chart_info "$chart_info" "$chart_name")

    log "Обработка чарта: $chart_name:$chart_version"
    log "Источник: oci://$source_registry"
    log "Назначение: oci://$TARGET_REGISTRY"

    # Аутентификация в source registry если необходимо
    authenticate_source_registry "$source_registry"

    # Создаем временную директорию для чарта
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    # Скачиваем чарт из источника
    log "Скачивание чарта $chart_name:$chart_version из $source_registry..."
    helm pull "oci://$source_registry/$chart_name" --version "$chart_version"

    if [ $? -ne 0 ]; then
        error "Ошибка скачивания чарта $chart_name:$chart_version"
        rm -rf "$temp_dir"
        return 1
    fi

    # Находим скачанный файл
    local chart_file=$(ls ${chart_name}-${chart_version}.tgz 2>/dev/null)

    if [ -z "$chart_file" ]; then
        error "Не найден файл чарта $chart_name:$chart_version"
        rm -rf "$temp_dir"
        return 1
    fi

    # Отправляем чарт в приватный registry
    log "Отправка чарта $chart_name:$chart_version в $TARGET_REGISTRY..."
    helm push "$chart_file" "oci://$TARGET_REGISTRY"

    if [ $? -eq 0 ]; then
        log "Чарт $chart_name:$chart_version успешно отправлен в приватный registry"
    else
        error "Ошибка отправки чарта $chart_name:$chart_version в приватный registry"
        rm -rf "$temp_dir"
        return 1
    fi

    # Очищаем временную директорию
    rm -rf "$temp_dir"

    return 0
}

# Показать конфигурацию
show_config() {
    log "=== Конфигурация ==="
    log "Дефолтный источник: $DEFAULT_SOURCE_REGISTRY"
    log "Приватный registry: $TARGET_REGISTRY"
    log "Пользователь: ${TARGET_REGISTRY_USER:-'anonymous'}"
    log "Директория чартов: $CHARTS_DIR"
    log "Файл индекса: $CHARTS_INDEX_FILE"
    log "Количество чартов: ${#CHARTS[@]}"
    echo

    log "=== Список чартов ==="
    for chart_name in "${!CHARTS[@]}"; do
        local chart_info="${CHARTS[$chart_name]}"
        local chart_version=$(get_chart_version "$chart_info")
        local source_registry=$(parse_chart_info "$chart_info" "$chart_name")
        log "  $chart_name:$chart_version <- $source_registry"
    done
    echo
}

# Создать архив с чартами
create_archive() {
    log "Создание архива с чартами..."

    if [ ! -d "$CHARTS_DIR" ]; then
        error "Директория с чартами не найдена: $CHARTS_DIR"
        exit 1
    fi

    if [ ! -f "$CHARTS_INDEX_FILE" ]; then
        error "Файл индекса не найден: $CHARTS_INDEX_FILE"
        exit 1
    fi

    local archive_name="helm-charts-$(date +%Y%m%d-%H%M%S).tar.gz"

    tar -czf "$archive_name" "$CHARTS_DIR" "$CHARTS_INDEX_FILE"

    if [ $? -eq 0 ]; then
        log "Архив создан: $archive_name"
        log "Размер архива: $(du -h "$archive_name" | cut -f1)"
        log "Содержимое:"
        tar -tzf "$archive_name"
    else
        error "Ошибка создания архива"
        exit 1
    fi
}

# Извлечь архив с чартами
extract_archive() {
    local archive_file=$1

    if [ -z "$archive_file" ]; then
        error "Не указан файл архива"
        exit 1
    fi

    if [ ! -f "$archive_file" ]; then
        error "Файл архива не найден: $archive_file"
        exit 1
    fi

    log "Извлечение архива: $archive_file"

    tar -xzf "$archive_file"

    if [ $? -eq 0 ]; then
        log "Архив успешно извлечен"
        if [ -f "$CHARTS_INDEX_FILE" ]; then
            log "Найден файл индекса: $CHARTS_INDEX_FILE"
            log "Количество чартов в архиве: $(wc -l < "$CHARTS_INDEX_FILE")"
        fi
    else
        error "Ошибка извлечения архива"
        exit 1
    fi
}

# Режим только скачивания
download_mode() {
    log "=== Режим скачивания чартов ==="

    check_requirements "download"

    # Очищаем старый индекс
    > "$CHARTS_INDEX_FILE"

    local success_count=0
    local error_count=0

    # Скачиваем каждый чарт
    for chart_name in "${!CHARTS[@]}"; do
        chart_info="${CHARTS[$chart_name]}"

        if download_chart "$chart_name" "$chart_info"; then
            ((success_count++))
        else
            ((error_count++))
        fi

        echo "---"
    done

    # Выводим статистику
    log "Скачивание завершено!"
    log "Успешно скачано: $success_count чартов"
    log "Сохранено в директории: $CHARTS_DIR"
    log "Индекс чартов: $CHARTS_INDEX_FILE"

    if [ $error_count -gt 0 ]; then
        warn "Ошибки при скачивании: $error_count чартов"
    else
        log "Все чарты успешно скачаны!"
    fi

    # Предлагаем создать архив
    echo
    info "Для переноса в закрытый контур выполните:"
    info "  $0 --pack"
    info "Затем перенесите созданный архив и выполните:"
    info "  $0 --extract <archive-name>"
    info "  $0 --upload"
}

# Режим только загрузки
upload_mode() {
    log "=== Режим загрузки чартов в registry ==="

    check_requirements "upload"
    authenticate_registry

    # Проверяем наличие файла индекса
    if [ ! -f "$CHARTS_INDEX_FILE" ]; then
        error "Файл индекса не найден: $CHARTS_INDEX_FILE"
        error "Сначала скачайте чарты или извлеките архив"
        exit 1
    fi

    # Проверяем наличие директории с чартами
    if [ ! -d "$CHARTS_DIR" ]; then
        error "Директория с чартами не найдена: $CHARTS_DIR"
        exit 1
    fi

    local success_count=0
    local error_count=0

    # Читаем индекс и загружаем чарты
    while IFS='|' read -r chart_name chart_version source_registry chart_file; do
        if [ -n "$chart_name" ] && [ -n "$chart_version" ] && [ -n "$chart_file" ]; then
            log "Обработка: $chart_name:$chart_version (файл: $chart_file)"

            if upload_chart "$chart_name" "$chart_version" "$chart_file"; then
                ((success_count++))
            else
                ((error_count++))
            fi

            echo "---"
        fi
    done < "$CHARTS_INDEX_FILE"

    # Выводим статистику
    log "Загрузка завершена!"
    log "Успешно загружено: $success_count чартов"

    if [ $error_count -gt 0 ]; then
        warn "Ошибки при загрузке: $error_count чартов"
        exit 1
    else
        log "Все чарты успешно загружены в registry!"
    fi
}

# Режим обычной синхронизации
sync_mode() {
    log "=== Режим синхронизации чартов ==="

    check_requirements "sync"
    authenticate_registry

    local success_count=0
    local error_count=0

    # Обрабатываем каждый чарт
    for chart_name in "${!CHARTS[@]}"; do
        chart_info="${CHARTS[$chart_name]}"

        if process_chart "$chart_name" "$chart_info"; then
            ((success_count++))
        else
            ((error_count++))
        fi

        echo "---"
    done

    # Выводим статистику
    log "Синхронизация завершена!"
    log "Успешно обработано: $success_count чартов"

    if [ $error_count -gt 0 ]; then
        warn "Ошибки при обработке: $error_count чартов"
        exit 1
    else
        log "Все чарты успешно синхронизированы!"
    fi
}

# Показать помощь
show_help() {
    cat << 'EOF'
Helm Charts Sync Tool

Использование: $0 [РЕЖИМ] [ОПЦИИ]

РЕЖИМЫ:
  --download    Скачать чарты локально (для переноса в закрытый контур)
  --upload      Загрузить локальные чарты в registry
  --sync        Синхронизировать чарты напрямую (скачать + загрузить)
  --pack        Создать архив со скачанными чартами
  --extract     Извлечь архив с чартами
  --config      Показать конфигурацию
  --help        Показать эту помощь
  --clean       Очистка локальных данных

ПРИМЕРЫ:
  # Скачать чарты для переноса в закрытый контур
  $0 --download

  # Создать архив для переноса
  $0 --pack

  # В закрытом контуре: извлечь архив
  $0 --extract helm-charts-20231215-140530.tar.gz

  # В закрытом контуре: загрузить чарты в registry
  $0 --upload

  # Прямая синхронизация (требует доступ к обоим registry)
  $0 --sync

ДИРЕКТОРИИ:
  ./helm-charts - директория для хранения чартов
  charts-index.txt - файл индекса чартов

КОНФИГУРАЦИЯ:
  Отредактируйте переменные в начале скрипта:
  - DEFAULT_SOURCE_REGISTRY
  - TARGET_REGISTRY
  - TARGET_REGISTRY_USER
  - TARGET_REGISTRY_PASS
  - CHARTS (массив чартов)

EOF
}

# Показать статус
show_status() {
    log "=== Статус ==="

    if [ -d "$CHARTS_DIR" ]; then
        local charts_count=$(ls -1 "$CHARTS_DIR"/*.tgz 2>/dev/null | wc -l)
        log "Скачанных чартов: $charts_count"
        log "Директория: $CHARTS_DIR"

        if [ $charts_count -gt 0 ]; then
            log "Размер директории: $(du -sh "$CHARTS_DIR" | cut -f1)"
        fi
    else
        log "Директория с чартами не найдена: $CHARTS_DIR"
    fi

    if [ -f "$CHARTS_INDEX_FILE" ]; then
        local index_count=$(wc -l < "$CHARTS_INDEX_FILE")
        log "Записей в индексе: $index_count"
        log "Файл индекса: $CHARTS_INDEX_FILE"
    else
        log "Файл индекса не найден: $CHARTS_INDEX_FILE"
    fi

    echo
    log "Архивы в текущей директории:"
    ls -la helm-charts-*.tar.gz 2>/dev/null || log "Архивы не найдены"
}

# Очистить локальные данные
clean_local() {
    log "Очистка локальных данных..."

    if [ -d "$CHARTS_DIR" ]; then
        rm -rf "$CHARTS_DIR"
        log "Удалена директория: $CHARTS_DIR"
    fi

    if [ -f "$CHARTS_INDEX_FILE" ]; then
        rm -f "$CHARTS_INDEX_FILE"
        log "Удален файл индекса: $CHARTS_INDEX_FILE"
    fi

    log "Очистка завершена"
}

# Основная функция обработки аргументов
main() {
    case "${1:-}" in
        --download)
            download_mode
            ;;
        --upload)
            upload_mode
            ;;
        --sync)
            sync_mode
            ;;
        --pack)
            create_archive
            ;;
        --extract)
            extract_archive "$2"
            ;;
        --config)
            show_config
            ;;
        --status)
            show_status
            ;;
        --clean)
            clean_local
            ;;
        --help|-h)
            show_help
            ;;
        *)
            if [ -n "$1" ]; then
                error "Неизвестный режим: $1"
                echo
            fi
            show_help
            exit 1
            ;;
    esac
}

# Запуск скрипта
main "$@"
