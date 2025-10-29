# TimeOut - Deployment Setup 🚀

Объединенный проект для развертывания системы учета рабочего времени **TimeOut**, включающий панель управления и Telegram-бота.

## 📦 Структура проекта

```
timeout-deploy/
├── panel/                  # Панель управления (Vite + Express)
│   ├── Dockerfile
│   └── .dockerignore
├── bot/                    # Telegram бот (Node.js + Telegraf)
│   ├── Dockerfile
│   └── .dockerignore
├── docker-compose.yml      # Оркестрация контейнеров
├── .env.example           # Пример переменных окружения
└── README.md
```

## 🎯 Сервисы

- **Panel** - Веб-панель управления (порт 3000)
- **Bot** - Telegram-бот для сотрудников (порт 8080)

Оба сервиса подключены к общей сети `timeout-network`.

---

## 🚀 Быстрый старт

### Предварительные требования

- Docker 20.10+
- Docker Compose 2.0+
- Git

### 1. Клонирование репозитория

```bash
git clone <your-repo-url> timeout-deploy
cd timeout-deploy

# Инициализация submodules
git submodule update --init --recursive
```

### 2. Настройка переменных окружения

Создайте файл `.env` на основе `.env.example`:

```bash
cp .env.example .env
```

Отредактируйте `.env` и заполните необходимые значения:

```env
# Database
DATABASE_URL=postgresql://postgres.xxx:password@aws-1-eu-west-2.pooler.supabase.com:6543/postgres

# Supabase
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Telegram
TELEGRAM_BOT_TOKEN=8472138192:AAGMrm0l1HrZIzZJYHQP46RK_SrHmauHZ3M
TELEGRAM_BOT_USERNAME=@outworkru_bot

# API
API_SECRET_KEY=secret_key_12345

# Session
SESSION_SECRET=your-strong-random-secret-here
```

### 3. Запуск проекта

```bash
# Сборка и запуск всех контейнеров
docker compose up --build

# Или в фоновом режиме
docker compose up -d --build
```

### 4. Проверка работоспособности

```bash
# Проверить статус контейнеров
docker compose ps

# Просмотр логов
docker compose logs -f

# Просмотр логов конкретного сервиса
docker compose logs -f panel
docker compose logs -f bot
```

**Доступ к сервисам:**

- Панель управления: http://localhost:3000
- Telegram бот: работает через webhook

---

## 🛠 Команды для разработки

```bash
# Остановить все контейнеры
docker compose down

# Остановить и удалить volumes
docker compose down -v

# Пересобрать конкретный сервис
docker compose build panel
docker compose build bot

# Перезапустить сервис без пересборки
docker compose restart panel

# Выполнить команду в контейнере
docker compose exec panel sh
docker compose exec bot sh

# Просмотр логов в реальном времени
docker compose logs -f --tail=100
```

---

## 🌍 Деплой на VPS

### Вариант 1: Docker Compose на VPS

1. **Подключитесь к VPS**

```bash
ssh user@your-vps-ip
```

2. **Установите Docker и Docker Compose**

```bash
# Обновите систему
sudo apt update && sudo apt upgrade -y

# Установите Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Установите Docker Compose
sudo apt install docker-compose-plugin -y

# Добавьте пользователя в группу docker
sudo usermod -aG docker $USER
```

3. **Клонируйте проект**

```bash
git clone <your-repo-url> timeout-deploy
cd timeout-deploy
git submodule update --init --recursive
```

4. **Настройте переменные окружения**

```bash
cp .env.example .env
nano .env  # Заполните реальные значения
```

5. **Запустите проект**

```bash
docker compose up -d --build
```

6. **Настройте Nginx (опционально)**

Создайте конфигурацию Nginx для проксирования:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

7. **Настройте SSL с Certbot**

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your-domain.com
```

---

## ☁️ Деплой на Render.com

### Panel (Web Service)

1. Создайте новый **Web Service** на [render.com](https://render.com)
2. Подключите репозиторий `timeout` (panel)
3. Настройте:
   - **Environment**: Docker
   - **Dockerfile Path**: `Dockerfile`
   - **Port**: 3000
4. Добавьте переменные окружения из `.env`
5. Deploy!

### Bot (Background Worker)

1. Создайте новый **Background Worker** на Render
2. Подключите репозиторий `timeout-telegram-bot`
3. Настройте:
   - **Environment**: Docker
   - **Dockerfile Path**: `Dockerfile`
4. Добавьте переменные окружения:
   - `TELEGRAM_BOT_TOKEN`
   - `API_BASE_URL` (URL панели с Render)
   - `SUPABASE_*` переменные
5. Deploy!

---

## 🔧 Обновление submodules

```bash
# Обновить все submodules до последних версий
git submodule update --remote --merge

# Обновить конкретный submodule
git submodule update --remote panel
git submodule update --remote bot

# Закоммитить изменения
git add .
git commit -m "Update submodules"
git push
```

---

## 📊 Мониторинг

### Проверка здоровья контейнеров

```bash
# Статус health checks
docker compose ps

# Детальная информация
docker inspect timeout-panel --format='{{.State.Health.Status}}'
docker inspect timeout-bot --format='{{.State.Health.Status}}'
```

### Логи

```bash
# Все логи
docker compose logs

# Последние 100 строк
docker compose logs --tail=100

# В реальном времени
docker compose logs -f

# Конкретный сервис
docker compose logs -f panel
```

---

## 🐛 Troubleshooting

### Контейнер не запускается

```bash
# Проверьте логи
docker compose logs panel

# Проверьте переменные окружения
docker compose config
```

### Ошибка подключения к базе данных

```bash
# Проверьте DATABASE_URL
echo $DATABASE_URL

# Проверьте доступность базы из контейнера
docker compose exec panel sh -c "nc -zv your-db-host 5432"
```

### Telegram бот не отвечает

```bash
# Проверьте логи бота
docker compose logs -f bot

# Проверьте webhook
curl https://api.telegram.org/bot<YOUR_TOKEN>/getWebhookInfo
```

### Пересоздать контейнеры

```bash
# Полная пересборка
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

---

## 📝 Переменные окружения

| Переменная | Описание | Обязательная |
|-----------|----------|--------------|
| `DATABASE_URL` | URL подключения к PostgreSQL | ✅ |
| `SUPABASE_URL` | URL проекта Supabase | ✅ |
| `SUPABASE_ANON_KEY` | Anon ключ Supabase | ✅ |
| `SUPABASE_SERVICE_ROLE_KEY` | Service role ключ Supabase | ✅ |
| `TELEGRAM_BOT_TOKEN` | Токен Telegram бота | ✅ |
| `TELEGRAM_BOT_USERNAME` | Username бота | ✅ |
| `API_BASE_URL` | URL API панели | ✅ |
| `API_SECRET_KEY` | Секретный ключ для API | ✅ |
| `SESSION_SECRET` | Секрет для сессий | ✅ |
| `NODE_ENV` | Окружение (production/development) | ❌ |

---

## 📚 Дополнительная информация

- [Docker документация](https://docs.docker.com/)
- [Docker Compose документация](https://docs.docker.com/compose/)
- [Render.com документация](https://render.com/docs)
- [Supabase документация](https://supabase.com/docs)

---

## 🤝 Поддержка

Если возникли вопросы или проблемы:

1. Проверьте [Troubleshooting](#-troubleshooting)
2. Посмотрите логи: `docker compose logs -f`
3. Создайте Issue в репозитории

---

## 📄 Лицензия

MIT

---

**Создано с ❤️ для упрощения деплоя TimeOut**

