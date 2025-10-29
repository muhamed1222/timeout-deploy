#!/bin/bash

# Скрипт для проверки здоровья сервисов

echo "🏥 Проверка здоровья timeout-deploy"
echo "===================================="
echo ""

# Проверка статуса контейнеров
echo "📊 Статус контейнеров:"
docker compose ps
echo ""

# Проверка health checks
echo "💚 Health Checks:"
echo "Panel:"
docker inspect timeout-panel --format='{{.State.Health.Status}}' 2>/dev/null || echo "  Контейнер не запущен"

echo "Bot:"
docker inspect timeout-bot --format='{{.State.Health.Status}}' 2>/dev/null || echo "  Контейнер не запущен"
echo ""

# Проверка API панели
echo "🌐 API панели (http://localhost:3000):"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/health 2>/dev/null)
if [ "$HTTP_CODE" = "200" ]; then
    echo "  ✅ Доступен (HTTP $HTTP_CODE)"
else
    echo "  ❌ Недоступен (HTTP $HTTP_CODE)"
fi
echo ""

# Использование ресурсов
echo "💾 Использование ресурсов:"
docker stats --no-stream timeout-panel timeout-bot 2>/dev/null || echo "  Контейнеры не запущены"
echo ""

# Проверка логов на ошибки
echo "🔍 Последние ошибки в логах:"
docker compose logs --tail=50 2>/dev/null | grep -i "error" | tail -5 || echo "  Ошибок не найдено"
echo ""

echo "✅ Проверка завершена"

