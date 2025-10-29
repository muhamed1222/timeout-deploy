#!/bin/bash

# Скрипт для настройки Nginx на VPS

set -e

DOMAIN=${1:-your-domain.com}
EMAIL=${2:-admin@$DOMAIN}

echo "🌐 Настройка Nginx для timeout-deploy"
echo "===================================="
echo "Domain: $DOMAIN"
echo "Email: $EMAIL"
echo ""

# Проверка прав root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Запустите скрипт с правами root: sudo $0"
    exit 1
fi

# Установка Nginx
echo "📦 Установка Nginx..."
apt update
apt install -y nginx

# Установка Certbot
echo "🔐 Установка Certbot..."
apt install -y certbot python3-certbot-nginx

# Создание конфигурации
echo "📝 Создание конфигурации..."
cat > /etc/nginx/sites-available/timeout << EOF
# Upstream для панели
upstream timeout_panel {
    server 127.0.0.1:3000;
}

# HTTP server
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN www.$DOMAIN;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        proxy_pass http://timeout_panel;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

# Создание symlink
echo "🔗 Создание symlink..."
ln -sf /etc/nginx/sites-available/timeout /etc/nginx/sites-enabled/timeout

# Удаление default конфигурации
rm -f /etc/nginx/sites-enabled/default

# Проверка конфигурации
echo "✅ Проверка конфигурации..."
nginx -t

# Перезапуск Nginx
echo "🔄 Перезапуск Nginx..."
systemctl restart nginx
systemctl enable nginx

# Настройка SSL
echo "🔐 Настройка SSL сертификата..."
certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email $EMAIL --redirect

# Автообновление сертификатов
echo "⏰ Настройка автообновления сертификатов..."
systemctl enable certbot.timer
systemctl start certbot.timer

echo ""
echo "✅ Nginx настроен успешно!"
echo ""
echo "Проверьте:"
echo "  - https://$DOMAIN"
echo "  - Статус: systemctl status nginx"
echo "  - Логи: tail -f /var/log/nginx/timeout_*.log"

