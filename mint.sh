#!/bin/bash

# Проверка аргументов
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <ticker> <loops> <priorfee> <to>"
    exit 1
fi

TICKER=$1
LOOPS=$2
PRIORFEE=$3
TO=$4
PRIV_KEYS_FILE="privkeys.txt"

# Проверка наличия файла с приватными ключами
if [ ! -f "$PRIV_KEYS_FILE" ]; then
    echo "Error: File '$PRIV_KEYS_FILE' not found."
    exit 1
fi

# Чтение файла построчно
while IFS= read -r PRIV_KEY; do
    # Убираем возможные лишние пробелы и символы новой строки
    PRIV_KEY=$(echo "$PRIV_KEY" | sed 's/[[:space:]]*$//;s/^[[:space:]]*//')

    # Пропуск пустых строк
    if [ -n "$PRIV_KEY" ]; then
        echo "Running command for privKey: $PRIV_KEY"
        
        # Запуск команды в фоновом режиме с проверкой ошибок
        bun run mint.ts --privKey "$PRIV_KEY" --logLevel DEBUG --loops "$LOOPS" --ticker "$TICKER" --priorityFee "$PRIORFEE" --to "$TO" &
    fi
done < "$PRIV_KEYS_FILE"

# Ожидание завершения всех фоновых процессов
wait