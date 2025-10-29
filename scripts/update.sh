#!/bin/bash

# Скрипт для обновления проекта

set -e

echo "🔄 Обновление timeout-deploy"
echo "============================="
echo ""

# Обновление главного репозитория
echo "📥 Обновление главного репозитория..."
git pull origin main || git pull origin master

# Обновление submodules
echo "📦 Обновление submodules..."
git submodule update --remote --merge

# Показать изменения
echo ""
echo "📋 Изменения в submodules:"
cd panel && git log --oneline -5 && cd ..
cd bot && git log --oneline -5 && cd ..

echo ""
echo "✅ Обновление завершено!"
echo ""
echo "Для применения изменений запустите:"
echo "  ./scripts/deploy.sh"

