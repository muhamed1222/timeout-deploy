# 📦 Итоговый код для деплоя

## Структура проекта

```
timeout-deploy/
├── panel/                     # Git submodule
│   ├── Dockerfile
│   └── .dockerignore
├── bot/                       # Git submodule
│   ├── Dockerfile
│   └── .dockerignore
├── docker-compose.yml
├── .env.example
├── .gitignore
├── README.md
├── QUICKSTART.md
└── DEPLOYMENT_CODE.md (этот файл)
```

---

## 📄 Файлы конфигурации

### 1. `docker-compose.yml`

```yaml
version: '3.8'

services:
  # Панель управления (Vite + Express)
  panel:
    build:
      context: ./panel
      dockerfile: Dockerfile
    container_name: timeout-panel
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - PORT=3000
      - DATABASE_URL=${DATABASE_URL}
      - SUPABASE_URL=${SUPABASE_URL}
      - SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}
      - SUPABASE_SERVICE_ROLE_KEY=${SUPABASE_SERVICE_ROLE_KEY}
      - SESSION_SECRET=${SESSION_SECRET:-your-secret-key-change-in-production}
    networks:
      - timeout-network
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:3000/api/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    depends_on:
      - bot

  # Telegram бот
  bot:
    build:
      context: ./bot
      dockerfile: Dockerfile
    container_name: timeout-bot
    restart: unless-stopped
    ports:
      - "8080:8080"
    environment:
      - NODE_ENV=production
      - TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
      - TELEGRAM_BOT_USERNAME=${TELEGRAM_BOT_USERNAME}
      - API_BASE_URL=${API_BASE_URL:-http://panel:3000/api}
      - API_SECRET_KEY=${API_SECRET_KEY:-secret_key_12345}
      - DATABASE_URL=${DATABASE_URL}
      - SUPABASE_URL=${SUPABASE_URL}
      - SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}
      - SUPABASE_SERVICE_ROLE_KEY=${SUPABASE_SERVICE_ROLE_KEY}
    networks:
      - timeout-network
    healthcheck:
      test: ["CMD-SHELL", "ps aux | grep -v grep | grep node || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 20s

networks:
  timeout-network:
    driver: bridge
    name: timeout-network
```

---

### 2. `panel/Dockerfile`

```dockerfile
# Multi-stage build для панели управления (Vite + Express)
FROM node:18-alpine AS builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package files
COPY package*.json ./

# Устанавливаем зависимости
RUN npm ci --legacy-peer-deps

# Копируем исходный код
COPY . .

# Собираем приложение
RUN npm run build

# Production stage
FROM node:18-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package files
COPY package*.json ./

# Устанавливаем только production зависимости
RUN npm ci --only=production --legacy-peer-deps

# Копируем собранное приложение из builder
COPY --from=builder /app/dist ./dist

# Устанавливаем переменные окружения
ENV NODE_ENV=production
ENV PORT=3000

# Открываем порт
EXPOSE 3000

# Запускаем приложение
CMD ["npm", "start"]
```

---

### 3. `panel/.dockerignore`

```
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.env.local
.env.*.local
dist
.vite
.cache
logs
*.log
.DS_Store
coverage
.nyc_output
.husky
.vscode
.idea
*.swp
*.swo
*~
playwright-report
test-results
```

---

### 4. `bot/Dockerfile`

```dockerfile
# Multi-stage build для Telegram бота
FROM node:18-alpine AS builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package files
COPY package*.json ./

# Устанавливаем зависимости
RUN npm ci

# Копируем исходный код
COPY . .

# Собираем TypeScript
RUN npm run build

# Production stage
FROM node:18-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package files
COPY package*.json ./

# Устанавливаем только production зависимости
RUN npm ci --only=production

# Копируем собранное приложение из builder
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/src ./src

# Устанавливаем переменные окружения
ENV NODE_ENV=production

# Открываем порт (для health checks если нужно)
EXPOSE 8080

# Запускаем бота
CMD ["node", "dist/index.js"]
```

---

### 5. `bot/.dockerignore`

```
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.env.local
.env.*.local
dist
logs
*.log
.DS_Store
.vscode
.idea
*.swp
*.swo
*~
.vercel
api
scripts
public
```

---

### 6. `.env.example`

```env
# Database Configuration
DATABASE_URL=postgresql://user:password@host:5432/database

# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# Telegram Bot Configuration
TELEGRAM_BOT_TOKEN=123456789:ABCdefGHIjklMNOpqrsTUVwxyz
TELEGRAM_BOT_USERNAME=@your_bot_username

# API Configuration
API_BASE_URL=http://localhost:3000/api
API_SECRET_KEY=your-secret-api-key

# Session Secret (for panel)
SESSION_SECRET=your-session-secret-change-in-production

# Environment
NODE_ENV=production
```

---

### 7. `.gitignore`

```
# Environment variables
.env
.env.local
.env.*.local

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# OS
.DS_Store
*.swp
*.swo
*~

# Editor
.vscode
.idea
*.sublime-project
*.sublime-workspace

# Docker
docker-compose.override.yml

# Node
node_modules/
```

---

## 🚀 Команды для запуска

### Локальный запуск

```bash
# 1. Клонирование
git clone <repo-url> timeout-deploy
cd timeout-deploy
git submodule update --init --recursive

# 2. Настройка
cp .env.example .env
# Заполните .env файл

# 3. Запуск
docker compose up --build

# Или в фоновом режиме
docker compose up -d --build
```

### Деплой на VPS

```bash
# На сервере
git clone <repo-url> timeout-deploy
cd timeout-deploy
git submodule update --init --recursive

# Настройка
cp .env.example .env
nano .env

# Запуск
docker compose up -d --build

# Проверка
docker compose ps
docker compose logs -f
```

### Деплой на Render.com

#### Panel (Web Service)
- Repository: `timeout`
- Environment: Docker
- Dockerfile: `Dockerfile`
- Port: 3000

#### Bot (Background Worker)
- Repository: `timeout-telegram-bot`
- Environment: Docker
- Dockerfile: `Dockerfile`

---

## ✅ Checklist перед деплоем

- [ ] Submodules инициализированы
- [ ] Файл `.env` создан и заполнен
- [ ] Docker и Docker Compose установлены
- [ ] Порты 3000 и 8080 свободны
- [ ] Supabase база данных настроена
- [ ] Telegram бот токен получен
- [ ] Проверено локально с `docker compose up`
- [ ] Логи проверены на ошибки

---

## 🔍 Проверка работоспособности

```bash
# Статус контейнеров
docker compose ps

# Health checks
docker inspect timeout-panel --format='{{.State.Health.Status}}'
docker inspect timeout-bot --format='{{.State.Health.Status}}'

# Логи
docker compose logs -f

# API проверка
curl http://localhost:3000/api/health

# Telegram bot
# Отправьте /start в боте
```

---

## 📚 Документация

- [README.md](./README.md) - Полная документация
- [QUICKSTART.md](./QUICKSTART.md) - Быстрый старт
- Этот файл - Весь код для копирования

---

**Все готово для деплоя! 🚀**

