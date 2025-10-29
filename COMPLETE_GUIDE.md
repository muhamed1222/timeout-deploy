# 🎯 Полное руководство по timeout-deploy

## 📦 Что включено

### 🏗️ Структура проекта
```
timeout-deploy/
├── panel/                      # Git submodule - панель управления
├── bot/                        # Git submodule - Telegram бот
├── scripts/                    # Утилиты для управления
│   ├── deploy.sh              # Автоматический деплой
│   ├── update.sh              # Обновление проекта
│   ├── logs.sh                # Просмотр логов
│   ├── health-check.sh        # Проверка здоровья
│   ├── cleanup.sh             # Очистка ресурсов
│   ├── setup-vps.sh           # Настройка VPS с нуля
│   └── setup-nginx.sh         # Настройка Nginx
├── nginx/                      # Конфигурации Nginx
├── .github/workflows/          # CI/CD с GitHub Actions
├── docker-compose.yml          # Production конфигурация
├── docker-compose.dev.yml      # Development конфигурация
├── Makefile                    # Команды для управления
└── README.md                   # Основная документация
```

---

## 🚀 Быстрый старт (3 команды)

```bash
# 1. Клонирование
git clone <repo-url> timeout-deploy && cd timeout-deploy
git submodule update --init --recursive

# 2. Настройка
cp .env.example .env
# Отредактируйте .env файл!

# 3. Запуск
make deploy
```

---

## 📖 Подробные инструкции

### Вариант 1: Использование Make (Рекомендуется)

```bash
# Показать все команды
make help

# Первоначальная установка
make install

# Деплой
make deploy

# Просмотр логов
make logs

# Проверка здоровья
make health

# Обновление
make update

# Очистка
make clean
```

### Вариант 2: Использование скриптов

```bash
# Деплой
./scripts/deploy.sh

# Обновление
./scripts/update.sh

# Логи
./scripts/logs.sh [all|panel|bot]

# Проверка здоровья
./scripts/health-check.sh

# Очистка
./scripts/cleanup.sh
```

### Вариант 3: Docker Compose напрямую

```bash
# Запуск
docker compose up -d --build

# Остановка
docker compose down

# Логи
docker compose logs -f

# Статус
docker compose ps
```

---

## 🌍 Деплой на VPS (полная настройка)

### Шаг 1: Подготовка VPS

```bash
# Подключение к VPS
ssh user@your-vps-ip

# Запуск автоматической настройки (только первый раз)
wget https://raw.githubusercontent.com/your-repo/timeout-deploy/main/scripts/setup-vps.sh
sudo bash setup-vps.sh
```

Скрипт автоматически:
- ✅ Обновит систему
- ✅ Установит Docker и Docker Compose
- ✅ Настроит Firewall (UFW)
- ✅ Установит Fail2Ban
- ✅ Создаст swap
- ✅ Оптимизирует систему

### Шаг 2: Клонирование проекта

```bash
cd /var/www
git clone <your-repo-url> timeout-deploy
cd timeout-deploy
git submodule update --init --recursive
```

### Шаг 3: Настройка переменных

```bash
cp .env.example .env
nano .env
# Заполните все переменные!
```

### Шаг 4: Запуск

```bash
make deploy
# или
./scripts/deploy.sh
```

### Шаг 5: Настройка Nginx + SSL

```bash
sudo ./scripts/setup-nginx.sh your-domain.com admin@your-domain.com
```

Скрипт автоматически:
- ✅ Установит Nginx
- ✅ Создаст конфигурацию
- ✅ Установит Certbot
- ✅ Настроит SSL сертификат
- ✅ Настроит автообновление сертификата

---

## 🔄 CI/CD с GitHub Actions

### Настройка автоматического деплоя

1. **Добавьте GitHub Secrets** (см. `.github/SECRETS.md`):
   - `SSH_PRIVATE_KEY` - SSH ключ для VPS
   - `VPS_HOST` - IP адрес VPS
   - `VPS_USER` - SSH пользователь
   - `DEPLOY_PATH` - путь к проекту на VPS
   - `GH_PAT` - Personal Access Token для submodules

2. **Автоматический деплой**:
   - Каждый push в `main`/`master` → автодеплой
   - Pull request → тестовая сборка Docker образов

3. **Ручной деплой**:
   - GitHub → Actions → Deploy to VPS → Run workflow

---

## 🧪 Режим разработки

```bash
# Запуск в dev режиме
make dev-up

# Или
docker compose -f docker-compose.dev.yml up

# Особенности dev режима:
# - Hot reload для обоих сервисов
# - Volumes для live изменений
# - Development порты (3000, 5173, 8080)
```

---

## 📊 Мониторинг и управление

### Проверка статуса

```bash
# Через Make
make health
make ps

# Через Docker
docker compose ps
docker stats

# Через скрипт
./scripts/health-check.sh
```

### Просмотр логов

```bash
# Все логи
make logs

# Логи панели
make logs-panel

# Логи бота
make logs-bot

# Или через скрипт
./scripts/logs.sh panel
```

### Доступ к контейнерам

```bash
# Зайти в panel
make shell-panel

# Зайти в bot
make shell-bot
```

---

## 🔧 Обслуживание

### Обновление проекта

```bash
# Автоматическое обновление
make update

# Или пошагово:
git pull
git submodule update --remote --merge
make deploy
```

### Бэкап

```bash
# Бэкап .env
make backup-env

# Ручной бэкап
cp .env .env.backup.$(date +%Y%m%d)
```

### Очистка

```bash
# Полная очистка
make clean

# Или через скрипт
./scripts/cleanup.sh
```

---

## 🐛 Troubleshooting

### Контейнеры не запускаются

```bash
# Проверьте логи
docker compose logs panel
docker compose logs bot

# Проверьте конфигурацию
docker compose config

# Пересоздайте контейнеры
make clean
make deploy
```

### Проблемы с базой данных

```bash
# Проверьте переменные
grep DATABASE_URL .env

# Тест подключения
docker compose exec panel sh -c "nc -zv your-db-host 5432"
```

### Telegram бот не отвечает

```bash
# Логи бота
make logs-bot

# Проверьте токен
grep TELEGRAM_BOT_TOKEN .env

# Проверьте webhook
curl https://api.telegram.org/bot<TOKEN>/getWebhookInfo
```

### Nginx не работает

```bash
# Проверьте статус
systemctl status nginx

# Проверьте конфигурацию
nginx -t

# Логи
tail -f /var/log/nginx/timeout_error.log
```

---

## 📚 Полезные команды

### Управление Docker

```bash
# Пересборка без кеша
docker compose build --no-cache

# Рестарт сервиса
docker compose restart panel

# Удалить неиспользуемые образы
docker system prune -af
```

### Системные команды

```bash
# Использование диска
df -h

# Использование памяти
free -h

# Процессы Docker
ps aux | grep docker

# Мониторинг сети
nethogs
```

---

## 🔐 Безопасность

### Рекомендации

1. **Смените SESSION_SECRET** в `.env`
2. **Используйте сильные пароли** для БД
3. **Настройте Firewall** (UFW уже настроен скриптом)
4. **Используйте SSL** (Certbot настроен автоматически)
5. **Регулярно обновляйте** систему и Docker образы
6. **Проверяйте логи** на подозрительную активность

### Обновление системы

```bash
# На VPS
sudo apt update && sudo apt upgrade -y
sudo reboot
```

---

## 📈 Масштабирование

### Горизонтальное масштабирование

```yaml
# В docker-compose.yml
services:
  panel:
    deploy:
      replicas: 3  # 3 экземпляра
```

### Вертикальное масштабирование

```yaml
# Ограничение ресурсов
services:
  panel:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
```

---

## 📞 Поддержка

### Документация
- [README.md](./README.md) - Основная документация
- [QUICKSTART.md](./QUICKSTART.md) - Быстрый старт
- [DEPLOYMENT_CODE.md](./DEPLOYMENT_CODE.md) - Весь код
- Этот файл - Полное руководство

### Помощь
1. Проверьте [Troubleshooting](#-troubleshooting)
2. Посмотрите логи: `make logs`
3. Создайте Issue в GitHub

---

## ✅ Чеклист деплоя

- [ ] VPS подготовлен (Docker, Nginx, SSL)
- [ ] Проект клонирован с submodules
- [ ] `.env` файл создан и заполнен
- [ ] Docker compose работает: `make deploy`
- [ ] Panel доступен на порту 3000
- [ ] Bot работает в Telegram
- [ ] Nginx настроен и работает
- [ ] SSL сертификат установлен
- [ ] GitHub Actions настроены (если используете)
- [ ] Мониторинг работает
- [ ] Backup настроен

---

**🎉 Готово! Ваш проект полностью настроен и работает!**

Для получения помощи: `make help`

