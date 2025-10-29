#!/bin/bash

# Скрипт для деплоя timeout-deploy на VPS

set -e

echo "🚀 Деплой timeout-deploy"
echo "========================"
echo ""

# Проверка наличия .env
if [ ! -f .env ]; then
    echo "❌ Файл .env не найден!"
    echo "Создайте .env на основе .env.example:"
    echo "  cp .env.example .env"
    echo "  nano .env"
    exit 1
fi

echo "✅ Файл .env найден"

# Обновление submodules
echo "📦 Обновление submodules..."
git submodule update --init --recursive

# Остановка старых контейнеров
echo "🛑 Остановка старых контейнеров..."
docker compose down || true

# Сборка новых образов
echo "🔨 Сборка образов..."
docker compose build --no-cache

# Запуск контейнеров
echo "▶️  Запуск контейнеров..."
docker compose up -d

# Проверка статуса
echo "📊 Проверка статуса..."
sleep 5
docker compose ps

echo ""
echo "✅ Деплой завершен!"
echo ""
echo "Проверьте логи:"
echo "  docker compose logs -f"
echo ""
echo "Проверьте здоровье:"
echo "  docker compose ps"
echo ""
echo "Доступ к сервисам:"
echo "  Panel: http://localhost:3000"
echo "  Bot: работает через Telegram"

