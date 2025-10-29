#!/bin/bash

# Полная настройка VPS для timeout-deploy
# Запуск: sudo bash setup-vps.sh

set -e

echo "🚀 Настройка VPS для timeout-deploy"
echo "===================================="
echo ""

# Проверка прав root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Запустите скрипт с правами root: sudo $0"
    exit 1
fi

# Обновление системы
echo "📦 Обновление системы..."
apt update && apt upgrade -y

# Установка необходимых пакетов
echo "📦 Установка базовых пакетов..."
apt install -y \
    git \
    curl \
    wget \
    nano \
    htop \
    ufw \
    fail2ban \
    unzip

# Установка Docker
echo "🐳 Установка Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    
    # Добавление текущего пользователя в группу docker
    if [ ! -z "$SUDO_USER" ]; then
        usermod -aG docker $SUDO_USER
    fi
else
    echo "  Docker уже установлен"
fi

# Установка Docker Compose
echo "📦 Установка Docker Compose..."
if ! command -v docker compose &> /dev/null; then
    apt install -y docker-compose-plugin
else
    echo "  Docker Compose уже установлен"
fi

# Настройка Firewall
echo "🔥 Настройка Firewall..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp   # HTTP
ufw allow 443/tcp  # HTTPS
ufw --force enable

# Настройка Fail2Ban
echo "🛡️  Настройка Fail2Ban..."
systemctl enable fail2ban
systemctl start fail2ban

# Создание директории для проекта
echo "📁 Создание директории проекта..."
PROJECT_DIR="/var/www/timeout-deploy"
mkdir -p $PROJECT_DIR

# Клонирование проекта (нужно будет заменить URL)
echo "📥 Клонирование проекта..."
read -p "Введите URL Git репозитория: " GIT_URL
if [ ! -z "$GIT_URL" ]; then
    cd /var/www
    git clone $GIT_URL timeout-deploy
    cd timeout-deploy
    git submodule update --init --recursive
    
    # Создание .env
    if [ ! -f .env ]; then
        cp .env.example .env
        echo "⚠️  Создан .env файл в $PROJECT_DIR/.env"
        echo "   Отредактируйте его перед запуском!"
    fi
fi

# Настройка автоматических обновлений безопасности
echo "🔒 Настройка автоматических обновлений..."
apt install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades

# Оптимизация для Docker
echo "⚙️  Оптимизация системы..."
cat >> /etc/sysctl.conf << EOF

# Docker optimization
vm.max_map_count=262144
fs.file-max=65535
net.core.somaxconn=1024
EOF
sysctl -p

# Создание swap если его нет
echo "💾 Проверка swap..."
if [ $(swapon --show | wc -l) -eq 0 ]; then
    echo "Создание swap файла 2GB..."
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# Установка мониторинга (опционально)
echo "📊 Установка мониторинга..."
apt install -y nethogs iotop

echo ""
echo "✅ VPS настроен успешно!"
echo ""
echo "📋 Следующие шаги:"
echo "1. Отредактируйте $PROJECT_DIR/.env"
echo "2. cd $PROJECT_DIR"
echo "3. docker compose up -d --build"
echo "4. Настройте Nginx: sudo bash scripts/setup-nginx.sh your-domain.com"
echo ""
echo "🔧 Полезные команды:"
echo "  docker compose ps           - статус контейнеров"
echo "  docker compose logs -f      - просмотр логов"
echo "  systemctl status docker     - статус Docker"
echo "  ufw status                  - статус Firewall"
echo ""
echo "⚠️  Не забудьте перезайти в систему для применения изменений группы docker"

