#!/bin/bash

# Скрипт для просмотра логов

SERVICE=${1:-all}

echo "📋 Просмотр логов: $SERVICE"
echo "=========================="
echo ""

if [ "$SERVICE" = "all" ]; then
    docker compose logs -f --tail=100
elif [ "$SERVICE" = "panel" ]; then
    docker compose logs -f --tail=100 panel
elif [ "$SERVICE" = "bot" ]; then
    docker compose logs -f --tail=100 bot
else
    echo "❌ Неизвестный сервис: $SERVICE"
    echo ""
    echo "Использование:"
    echo "  ./scripts/logs.sh [service]"
    echo ""
    echo "Доступные сервисы:"
    echo "  all    - все логи (по умолчанию)"
    echo "  panel  - логи панели"
    echo "  bot    - логи бота"
    exit 1
fi

