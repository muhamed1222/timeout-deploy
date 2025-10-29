# 🚀 TimeOut Deploy - Точка входа

> **Полная инфраструктура для деплоя системы учета рабочего времени**

---

## 📚 С чего начать?

### 🆕 Новичок в проекте?
👉 Начните с [QUICKSTART.md](./QUICKSTART.md) - запуск за 5 минут

### 💻 Опытный разработчик?
👉 Смотрите [COMPLETE_GUIDE.md](./COMPLETE_GUIDE.md) - полное руководство

### 📖 Нужна основная информация?
👉 Читайте [README.md](./README.md) - детальная документация

### 🎯 Хотите сразу код?
👉 Откройте [DEPLOYMENT_CODE.md](./DEPLOYMENT_CODE.md) - весь код для копирования

### ✅ Узнать что включено?
👉 См. [SUMMARY.md](./SUMMARY.md) - полный список возможностей

---

## ⚡ Быстрые команды

```bash
# Показать все доступные команды
make help

# Первый запуск
make install

# Деплой
make deploy

# Просмотр логов
make logs

# Проверка здоровья
make health
```

---

## 📂 Структура документации

```
📚 Документация
├── 🚀 INDEX.md (этот файл) ← Вы здесь
├── 📖 README.md - Основная документация
├── ⚡ QUICKSTART.md - Быстрый старт
├── 🎓 COMPLETE_GUIDE.md - Полное руководство
├── 💻 DEPLOYMENT_CODE.md - Весь код
└── ✅ SUMMARY.md - Список возможностей
```

---

## 🎯 Выберите свой путь

### 🏠 Локальная разработка
```bash
1. cp .env.example .env
2. Заполните .env
3. make dev-up
```
📖 Подробности: [QUICKSTART.md](./QUICKSTART.md#локальный-запуск)

### 🌍 Деплой на VPS
```bash
1. sudo ./scripts/setup-vps.sh
2. git clone && cd timeout-deploy
3. cp .env.example .env
4. make deploy
5. sudo ./scripts/setup-nginx.sh
```
📖 Подробности: [COMPLETE_GUIDE.md](./COMPLETE_GUIDE.md#деплой-на-vps)

### 🤖 Автоматический CI/CD
```bash
1. Настройте GitHub Secrets
2. Push в main/master
3. Готово! Автодеплой работает
```
📖 Подробности: [.github/SECRETS.md](./.github/SECRETS.md)

---

## 🛠️ Основные компоненты

| Компонент | Описание | Порт | Документация |
|-----------|----------|------|--------------|
| **Panel** | Веб-панель управления | 3000 | [panel/README.md](./panel/README.md) |
| **Bot** | Telegram бот | 8080 | [bot/README.md](./bot/README.md) |
| **Nginx** | Reverse proxy + SSL | 80/443 | [nginx/timeout.conf](./nginx/timeout.conf) |
| **Docker** | Контейнеризация | - | [docker-compose.yml](./docker-compose.yml) |

---

## 🎬 Видео туториалы (если есть)

- [ ] Локальная установка
- [ ] Деплой на VPS
- [ ] Настройка CI/CD
- [ ] Мониторинг и обслуживание

---

## 🆘 Нужна помощь?

1. **Документация**
   - Прочитайте [README.md](./README.md)
   - Проверьте [COMPLETE_GUIDE.md](./COMPLETE_GUIDE.md)

2. **Troubleshooting**
   - [COMPLETE_GUIDE.md#troubleshooting](./COMPLETE_GUIDE.md#-troubleshooting)
   - Запустите `make health`
   - Проверьте `make logs`

3. **Скрипты**
   - `./scripts/health-check.sh` - диагностика
   - `./scripts/logs.sh` - просмотр логов
   - `make help` - все команды

---

## ✨ Особенности

- ✅ **Docker Compose** - простое управление
- ✅ **Makefile** - 15+ готовых команд
- ✅ **CI/CD** - GitHub Actions
- ✅ **Auto SSL** - Let's Encrypt
- ✅ **Health checks** - автоконтроль
- ✅ **Nginx** - production ready
- ✅ **Scripts** - автоматизация всего

---

## 🎓 Обучение

### Уровень 1: Новичок
1. [QUICKSTART.md](./QUICKSTART.md)
2. Запустите `make help`
3. Попробуйте `make deploy`

### Уровень 2: Разработчик
1. [README.md](./README.md)
2. Изучите [docker-compose.yml](./docker-compose.yml)
3. Настройте dev окружение

### Уровень 3: DevOps
1. [COMPLETE_GUIDE.md](./COMPLETE_GUIDE.md)
2. Настройте CI/CD
3. Разверните на VPS

---

## 📊 Быстрая статистика

- **Файлов**: 25+
- **Скриптов**: 7
- **Команд Make**: 15+
- **Workflows**: 2
- **Документов**: 6
- **Строк кода**: 2000+

---

## 🔗 Быстрые ссылки

| Категория | Ссылки |
|-----------|--------|
| **Документация** | [README](./README.md) · [Guide](./COMPLETE_GUIDE.md) · [Quick](./QUICKSTART.md) |
| **Конфигурация** | [Docker](./docker-compose.yml) · [Makefile](./Makefile) · [Nginx](./nginx/timeout.conf) |
| **Скрипты** | [Deploy](./scripts/deploy.sh) · [Update](./scripts/update.sh) · [Health](./scripts/health-check.sh) |
| **CI/CD** | [Deploy workflow](./.github/workflows/deploy.yml) · [Secrets](./.github/SECRETS.md) |

---

## 🎯 Следующий шаг

<div align="center">

### 👇 Выберите что вам нужно 👇

[📖 Прочитать документацию](./README.md) · 
[⚡ Быстрый старт](./QUICKSTART.md) · 
[🚀 Деплой сейчас](./COMPLETE_GUIDE.md#деплой-на-vps)

</div>

---

<div align="center">

**Создано с ❤️ для упрощения деплоя TimeOut**

[GitHub](https://github.com/muhamed1222) · 
[Документация](./README.md) · 
[Поддержка](./COMPLETE_GUIDE.md#поддержка)

</div>

