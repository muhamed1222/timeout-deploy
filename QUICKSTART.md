# ⚡ Quick Start Guide

## 🚀 Запуск за 5 минут

### 1. Клонирование и настройка

```bash
# Клонируйте репозиторий
git clone <your-repo-url> timeout-deploy
cd timeout-deploy

# Инициализируйте submodules
git submodule update --init --recursive
```

### 2. Создайте .env файл

```bash
cp .env.example .env
```

Отредактируйте `.env` с вашими реальными значениями:

```env
DATABASE_URL=postgresql://postgres.xxx:password@host:6543/postgres
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGc...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...
TELEGRAM_BOT_TOKEN=123456:ABC...
TELEGRAM_BOT_USERNAME=@your_bot
API_SECRET_KEY=secret_key_12345
SESSION_SECRET=random-secret-here
```

### 3. Запустите

```bash
docker compose up --build
```

✅ **Готово!** 

- Panel: http://localhost:3000
- Bot: работает через Telegram

---

## 🧪 Проверка работоспособности

### Проверка Panel

```bash
# Health check
curl http://localhost:3000/api/health

# Проверка API
curl http://localhost:3000/api/companies
```

### Проверка Bot

```bash
# Просмотр логов
docker compose logs bot

# Отправьте /start боту в Telegram
```

---

## 🛑 Остановка

```bash
# Остановить контейнеры
docker compose down

# Удалить все данные и volumes
docker compose down -v
```

---

## 📊 Полезные команды

```bash
# Просмотр логов в реальном времени
docker compose logs -f

# Перезапуск после изменений
docker compose restart

# Статус контейнеров
docker compose ps

# Зайти в контейнер
docker compose exec panel sh
docker compose exec bot sh
```

---

## 🔥 Горячие клавиши для разработки

```bash
# Быстрая пересборка и запуск
docker compose up --build -d && docker compose logs -f

# Обновить submodules и перезапустить
git submodule update --remote --merge && docker compose up --build -d

# Очистить всё и начать заново
docker compose down -v && docker system prune -f && docker compose up --build
```

---

## 📱 Настройка Telegram Webhook

Если используете бота через webhook (не polling):

```bash
# Установить webhook
curl -X POST "https://api.telegram.org/bot<YOUR_TOKEN>/setWebhook?url=https://your-domain.com/api/webhook"

# Проверить webhook
curl "https://api.telegram.org/bot<YOUR_TOKEN>/getWebhookInfo"

# Удалить webhook (для локальной разработки)
curl "https://api.telegram.org/bot<YOUR_TOKEN>/deleteWebhook"
```

---

## 🌍 Быстрый деплой на VPS

```bash
# На VPS
git clone <repo-url> timeout-deploy
cd timeout-deploy
git submodule update --init --recursive

# Настроить .env
cp .env.example .env
nano .env

# Запустить
docker compose up -d --build

# Проверить
docker compose ps
docker compose logs -f
```

---

## 💡 Советы

1. **Первый запуск может занять 5-10 минут** (сборка образов)
2. **Используйте `docker compose logs -f`** для отладки
3. **Проверяйте health checks**: `docker compose ps`
4. **Для VPS используйте Nginx** как reverse proxy
5. **Не забудьте настроить SSL** с Certbot

---

## ❓ Проблемы?

### Panel не запускается
```bash
docker compose logs panel
# Проверьте DATABASE_URL и SUPABASE_* переменные
```

### Bot не отвечает
```bash
docker compose logs bot
# Проверьте TELEGRAM_BOT_TOKEN
```

### Ошибка подключения
```bash
# Проверьте сеть
docker network ls
docker network inspect timeout-network
```

---

**Готово! Теперь у вас работает полная система TimeOut! 🎉**

