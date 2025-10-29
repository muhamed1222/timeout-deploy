#!/bin/bash

# Скрипт для очистки Docker ресурсов

echo "🧹 Очистка Docker ресурсов"
echo "=========================="
echo ""

read -p "Вы уверены? Это удалит все контейнеры, образы и volumes! (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "❌ Отменено"
    exit 0
fi

echo ""
echo "🛑 Остановка контейнеров..."
docker compose down -v

echo ""
echo "🗑️  Удаление образов..."
docker rmi timeout-deploy-panel timeout-deploy-bot 2>/dev/null || echo "Образы уже удалены"

echo ""
echo "🧽 Очистка неиспользуемых ресурсов..."
docker system prune -f

echo ""
echo "✅ Очистка завершена!"
echo ""
echo "Для повторного запуска используйте:"
echo "  ./scripts/deploy.sh"

