#!/bin/bash

# ---------------------------
# Настройки 
# ---------------------------
EMAIL="admin@example.com"               # Кому отправлять письмо
ACCESS_LOG="/var/log/nginx/access.log"  # Путь к логу доступа
ERROR_LOG="/var/log/nginx/error.log"    # Путь к логу ошибок
ACCESS_POS="/tmp/log_report_access.pos" # Файл для хранения позиции access.log
ERROR_POS="/tmp/log_report_error.pos"   # Файл для хранения позиции error.log
LOCK_FILE="/var/run/log_report.lock"    # Файл блокировки

# ------------------------------------------
# Блокировка: не даём запустить вторую копию
# ------------------------------------------
exec 9>"$LOCK_FILE"
if ! flock -n 9; then
    echo "$(date): Скрипт уже выполняется, выходим." >> /tmp/log_report.log
    exit 1
fi

# ------------------------------------------
# Временные файлы
# ------------------------------------------
REPORT=$(mktemp)
NEW_ACCESS=$(mktemp)
NEW_ERROR=$(mktemp)

# -------------------------------------------------
# Функция: извлечь новые строки из лога
# Параметры: лог-файл, файл с позицией, выходной файл
# -------------------------------------------------
get_new_lines() {
    local logfile=$1
    local posfile=$2
    local outfile=$3

    # Если лог-файл не существует – выходим
    if [[ ! -f "$logfile" ]]; then
        return 1
    fi

    # Текущий размер лога
    local current_size=$(stat -c %s "$logfile" 2>/dev/null || echo 0)
    local prev_pos=0

    # Читаем сохранённую позицию (если есть)
    if [[ -f "$posfile" ]]; then
        prev_pos=$(cat "$posfile")
    fi

    # Если лог был урезан (ротация) – начинаем с начала
    if [[ $current_size -lt $prev_pos ]]; then
        prev_pos=0
    fi

    # Если появились новые байты – извлекаем их
    if [[ $current_size -gt $prev_pos ]]; then
        tail -c +$((prev_pos+1)) "$logfile" > "$outfile"
        echo "$current_size" > "$posfile"
    else
        # Новых данных нет – создаём пустой файл
        > "$outfile"
    fi
    return 0
}

# Извлекаем новые строки из обоих логов
get_new_lines "$ACCESS_LOG" "$ACCESS_POS" "$NEW_ACCESS"
get_new_lines "$ERROR_LOG"  "$ERROR_POS"  "$NEW_ERROR"

# ------------------------------------------
# Определяем временной диапазон для отчёта
# ------------------------------------------
if [[ -f "$ACCESS_POS" ]]; then
    # Время последнего запуска = время изменения pos-файла
    last_run_time=$(stat -c %Y "$ACCESS_POS")
else
    # Первый запуск – берём последний час
    last_run_time=$(( $(date +%s) - 3600 ))
fi
current_time=$(date +%s)

# ------------------------------------------
# Формируем тело письма
# ------------------------------------------
{
    echo "Отчёт по логам веб-сервера"
    echo "Период: $(date -d @$last_run_time) - $(date -d @$current_time)"
    echo "=========================================="

    # 1. Топ IP-адресов
    if [[ -s "$NEW_ACCESS" ]]; then
        echo "Топ IP-адресов (количество запросов):"
        awk '{print $1}' "$NEW_ACCESS" | sort | uniq -c | sort -nr | head -10
        echo ""

        # 2. Топ URL
        echo "Топ запрашиваемых URL (количество запросов):"
        # В combined-формате URL обычно седьмое поле (путь). Убираем кавычки.
        awk '{print $7}' "$NEW_ACCESS" | sed 's/"//g' | sort | uniq -c | sort -nr | head -10
        echo ""

        # 3. Коды HTTP-ответов
        echo "Коды HTTP-ответов (количество):"
        awk '{print $9}' "$NEW_ACCESS" | sort | uniq -c | sort -nr
        echo ""
    else
        echo "Нет новых записей в access.log за период."
        echo ""
    fi

    # 4. Ошибки веб-сервера / приложения
    if [[ -s "$NEW_ERROR" ]]; then
        echo "Ошибки веб-сервера/приложения (новые записи):"
        cat "$NEW_ERROR"
    else
        echo "Нет новых ошибок в error.log за период."
    fi
} >> "$REPORT"

# ------------------------------------------
# Отправляем письмо
# ------------------------------------------
if [[ -s "$REPORT" ]]; then
    mail -s "Отчёт по логам $(date +%Y-%m-%d-%H)" "$EMAIL" < "$REPORT"
fi

# ------------------------------------------
# Удаляем временные файлы
# ------------------------------------------
rm -f "$REPORT" "$NEW_ACCESS" "$NEW_ERROR"

# Блокировка автоматически снимется при выходе из скрипта
