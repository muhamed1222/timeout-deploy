#!/bin/bash

# Скрипт проверки готовности к деплою

echo "🔍 Проверка готовности к деплою timeout-deploy"
echo "==============================================="
echo ""

READY=true

# Проверка .env файла
echo "📋 Проверка .env файла..."
if [ -f .env ]; then
    echo "  ✅ .env файл существует"
    
    # Проверка обязательных переменных
    REQUIRED_VARS=(
        "DATABASE_URL"
        "SUPABASE_URL"
        "SUPABASE_ANON_KEY"
        "SUPABASE_SERVICE_ROLE_KEY"
        "TELEGRAM_BOT_TOKEN"
        "TELEGRAM_BOT_USERNAME"
    )
    
    for var in "${REQUIRED_VARS[@]}"; do
        if grep -q "^$var=" .env; then
            echo "  ✅ $var установлен"
        else
            echo "  ❌ $var отсутствует"
            READY=false
        fi
    done
else
    echo "  ❌ .env файл не найден"
    echo "     Создайте: cp .env.example .env"
    READY=false
fi

echo ""

# Проверка submodules
echo "📦 Проверка submodules..."
if [ -f "panel/package.json" ] && [ -f "bot/package.json" ]; then
    echo "  ✅ Submodules инициализированы"
else
    echo "  ❌ Submodules не инициализированы"
    echo "     Запустите: git submodule update --init --recursive"
    READY=false
fi

echo ""

# Проверка Dockerfile
echo "🐳 Проверка Dockerfile..."
if [ -f "panel/Dockerfile" ]; then
    echo "  ✅ panel/Dockerfile существует"
else
    echo "  ❌ panel/Dockerfile отсутствует"
    READY=false
fi

if [ -f "bot/Dockerfile" ]; then
    echo "  ✅ bot/Dockerfile существует"
else
    echo "  ❌ bot/Dockerfile отсутствует"
    READY=false
fi

echo ""

# Проверка docker-compose.yml
echo "📄 Проверка docker-compose.yml..."
if [ -f "docker-compose.yml" ]; then
    echo "  ✅ docker-compose.yml существует"
else
    echo "  ❌ docker-compose.yml отсутствует"
    READY=false
fi

echo ""

# Проверка подключения к Supabase
echo "🔌 Проверка Supabase..."
if grep -q "SUPABASE_URL" .env 2>/dev/null; then
    SUPABASE_URL=$(grep "^SUPABASE_URL=" .env | cut -d '=' -f2)
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$SUPABASE_URL" 2>/dev/null)
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "307" ] || [ "$HTTP_CODE" = "301" ]; then
        echo "  ✅ Supabase доступен (HTTP $HTTP_CODE)"
    else
        echo "  ⚠️  Supabase вернул код: $HTTP_CODE"
    fi
fi

echo ""

# Проверка Telegram токена
echo "🤖 Проверка Telegram бота..."
if grep -q "TELEGRAM_BOT_TOKEN" .env 2>/dev/null; then
    BOT_TOKEN=$(grep "^TELEGRAM_BOT_TOKEN=" .env | cut -d '=' -f2)
    if [ ! -z "$BOT_TOKEN" ]; then
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://api.telegram.org/bot$BOT_TOKEN/getMe" 2>/dev/null)
        if [ "$HTTP_CODE" = "200" ]; then
            BOT_INFO=$(curl -s "https://api.telegram.org/bot$BOT_TOKEN/getMe" 2>/dev/null)
            BOT_USERNAME=$(echo $BOT_INFO | grep -o '"username":"[^"]*"' | cut -d'"' -f4)
            echo "  ✅ Telegram токен валиден (@$BOT_USERNAME)"
        else
            echo "  ❌ Telegram токен невалиден"
            READY=false
        fi
    fi
fi

echo ""
echo "================================================"
echo ""

if [ "$READY" = true ]; then
    echo "✅ ВСЁ ГОТОВО К ДЕПЛОЮ!"
    echo ""
    echo "📋 Следующие шаги:"
    echo ""
    echo "Локальный тест:"
    echo "  make deploy"
    echo ""
    echo "Деплой на Render.com:"
    echo "  Откройте DEPLOY_RENDER.md и следуйте инструкциям"
    echo ""
    echo "Деплой на VPS:"
    echo "  sudo ./scripts/setup-vps.sh"
    echo ""
else
    echo "❌ НЕ ГОТОВО К ДЕПЛОЮ"
    echo ""
    echo "Исправьте ошибки выше и запустите снова:"
    echo "  ./scripts/check-deploy-ready.sh"
    echo ""
fi

