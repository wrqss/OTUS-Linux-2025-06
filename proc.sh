#!/bin/bash

# Перебираем все числовые директории в /proc (каждая соответствует PID)
for pid_dir in /proc/[0-9]*; do
    # Извлекаем PID из имени директории
    pid=$(basename "$pid_dir")
    
    # Пропускаем нечисловые директории (на случай если regex не сработал)
    [[ "$pid" =~ ^[0-9]+$ ]] || continue
    
    # Читаем данные из /proc/[pid]/status
    if [[ -f "$pid_dir/status" ]]; then
        # Получаем имя процесса
        name=$(grep -w 'Name' "$pid_dir/status" | awk '{print $2}' || echo "UNKNOWN")
        
        # Получаем статус процесса (один символ)
        state=$(grep -w 'State' "$pid_dir/status" | awk '{print $2}' | cut -c1 || echo "?")
    else
        continue
    fi
    
    # Читаем команду из /proc/[pid]/cmdline
    cmdline=$(cat "$pid_dir/cmdline" 2>/dev/null | tr '\0' ' ' | sed 's/ $//')
    
    # Если cmdline пустой, используем имя процесса
    [[ -z "$cmdline" ]] && cmdline="[$name]"
    
    # Выводим в формате: PID STAT COMMAND
    printf "%5s %1s    %s\n" "$pid" "$state" "$cmdline"
done
