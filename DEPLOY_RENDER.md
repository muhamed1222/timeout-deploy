# 🚀 Деплой на Render.com

## 📋 Подготовка

У вас уже есть:
- ✅ `.env` файл создан с реальными данными
- ✅ Submodules настроены
- ✅ Проект готов к деплою

---

## 🎯 План деплоя

1. **Panel** (Web Service) → https://timeout-panel.onrender.com
2. **Bot** (Background Worker) → Работает в фоне

---

## 📦 Шаг 1: Деплой Panel (Web Service)

### Через Render Dashboard:

1. **Откройте** [render.com](https://render.com) и войдите

2. **New → Web Service**

3. **Подключите репозиторий**:
   - Выберите: `timeout` (https://github.com/muhamed1222/timeout)
   - Или подключите GitHub аккаунт

4. **Настройки**:
   ```
   Name: timeout-panel
   Region: Frankfurt (EU Central)
   Branch: main
   Runtime: Docker
   ```

5. **Build Settings**:
   ```
   Dockerfile Path: Dockerfile
   Docker Context: .
   ```

6. **Instance Type**:
   ```
   Free или Starter ($7/month)
   ```

7. **Environment Variables** - Добавьте ВСЕ переменные:

   ```bash
   DATABASE_URL=postgresql://postgres.chkziqbxvdzwhlucfrza:S2ljE6NzGIAJAjtn@aws-1-eu-west-2.pooler.supabase.com:6543/postgres
   
   SUPABASE_URL=https://chkziqbxvdzwhlucfrza.supabase.co
   
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoa3ppcWJ4dmR6d2hsdWNmcnphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0MTA1NDcsImV4cCI6MjA3NDk4NjU0N30.PFjq7IZ81C5woCxoolferCZeFnkQ2xqVT96cBBR5Q94
   
   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoa3ppcWJ4dmR6d2hsdWNmcnphIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTQxMDU0NywiZXhwIjoyMDc0OTg2NTQ3fQ.wKTHzQiAa4kjNhtFmTR9lYy2LdFki-CoJQKJjmOw8E8
   
   SESSION_SECRET=your-random-secret-here-change-me
   
   NODE_ENV=production
   
   PORT=3000
   ```

8. **Нажмите "Create Web Service"**

9. **Дождитесь деплоя** (5-10 минут)

10. **Получите URL**: `https://timeout-panel-xxx.onrender.com`

---

## 🤖 Шаг 2: Деплой Bot (Background Worker)

### Через Render Dashboard:

1. **New → Background Worker**

2. **Подключите репозиторий**:
   - Выберите: `timeout-telegram-bot` (https://github.com/muhamed1222/timeout-telegram-bot)

3. **Настройки**:
   ```
   Name: timeout-bot
   Region: Frankfurt (EU Central)
   Branch: main
   Runtime: Docker
   ```

4. **Build Settings**:
   ```
   Dockerfile Path: Dockerfile
   Docker Context: .
   ```

5. **Instance Type**:
   ```
   Free или Starter ($7/month)
   ```

6. **Environment Variables** - Добавьте:

   ```bash
   # Telegram
   TELEGRAM_BOT_TOKEN=8472138192:AAGMrm0l1HrZIzZJYHQP46RK_SrHmauHZ3M
   TELEGRAM_BOT_USERNAME=@outworkru_bot
   
   # API (используйте URL панели от Шага 1!)
   API_BASE_URL=https://timeout-panel-xxx.onrender.com/api
   API_SECRET_KEY=secret_key_12345
   
   # Database
   DATABASE_URL=postgresql://postgres.chkziqbxvdzwhlucfrza:S2ljE6NzGIAJAjtn@aws-1-eu-west-2.pooler.supabase.com:6543/postgres
   
   # Supabase
   SUPABASE_URL=https://chkziqbxvdzwhlucfrza.supabase.co
   
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoa3ppcWJ4dmR6d2hsdWNmcnphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0MTA1NDcsImV4cCI6MjA3NDk4NjU0N30.PFjq7IZ81C5woCxoolferCZeFnkQ2xqVT96cBBR5Q94
   
   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoa3ppcWJ4dmR6d2hsdWNmcnphIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTQxMDU0NywiZXhwIjoyMDc0OTg2NTQ3fQ.wKTHzQiAa4kjNhtFmTR9lYy2LdFki-CoJQKJjmOw8E8
   
   # Environment
   NODE_ENV=production
   ```

7. **Нажмите "Create Background Worker"**

8. **Дождитесь деплоя**

---

## ✅ Шаг 3: Проверка

### Проверка Panel:

```bash
# Замените на ваш URL
curl https://timeout-panel-xxx.onrender.com/api/health
```

Должно вернуть: `{"status":"ok"}`

### Проверка Bot:

1. Откройте Telegram
2. Найдите `@outworkru_bot`
3. Отправьте `/start`
4. Бот должен ответить!

---

## 🔧 Шаг 4: Настройка Webhook (если нужно)

Если бот использует webhook вместо polling:

```bash
# Установите webhook
curl -X POST "https://api.telegram.org/bot8472138192:AAGMrm0l1HrZIzZJYHQP46RK_SrHmauHZ3M/setWebhook?url=https://timeout-panel-xxx.onrender.com/api/webhook"

# Проверьте webhook
curl "https://api.telegram.org/bot8472138192:AAGMrm0l1HrZIzZJYHQP46RK_SrHmauHZ3M/getWebhookInfo"
```

---

## 📊 Мониторинг

### Просмотр логов:

1. **Panel**:
   - Render Dashboard → timeout-panel → Logs

2. **Bot**:
   - Render Dashboard → timeout-bot → Logs

### Метрики:

- Render Dashboard → Metrics
- CPU, Memory, Network usage

---

## 🔄 Обновление деплоя

### Автоматическое:

Render автоматически деплоит при push в GitHub!

```bash
# В репозитории panel или bot
git add .
git commit -m "Update"
git push origin main
```

### Ручное:

Render Dashboard → Service → Manual Deploy → Deploy latest commit

---

## 💰 Стоимость

| Сервис | Plan | Цена |
|--------|------|------|
| Panel (Web Service) | Free | $0 |
| Bot (Background Worker) | Free | $0 |
| **Total** | | **$0** |

**Примечание**: Free план имеет ограничения:
- 750 часов/месяц
- Спящий режим после 15 минут неактивности
- Пробуждение занимает ~30 секунд

**Для production** рекомендуется Starter ($7/месяц каждый):
- Всегда активен
- Без ограничений
- Больше ресурсов

---

## 🐛 Troubleshooting

### Panel не запускается:

1. Проверьте логи в Render Dashboard
2. Убедитесь что все переменные окружения добавлены
3. Проверьте Dockerfile в репозитории panel

### Bot не отвечает:

1. Проверьте логи бота
2. Убедитесь что `API_BASE_URL` указывает на правильный URL панели
3. Проверьте `TELEGRAM_BOT_TOKEN`

### База данных недоступна:

1. Проверьте `DATABASE_URL`
2. Убедитесь что Supabase проект активен
3. Проверьте firewall правила в Supabase

---

## 🎯 Чеклист деплоя

- [ ] Panel задеплоен на Render
- [ ] Все переменные окружения добавлены для Panel
- [ ] Panel доступен по URL
- [ ] API работает (`/api/health` возвращает 200)
- [ ] Bot задеплоен на Render
- [ ] Все переменные окружения добавлены для Bot
- [ ] `API_BASE_URL` указывает на URL панели
- [ ] Bot отвечает в Telegram на `/start`
- [ ] Webhook настроен (если используется)
- [ ] Логи проверены на ошибки

---

## 🚀 Следующие шаги

1. **Добавьте домен** (опционально):
   - Render Dashboard → Panel → Settings → Custom Domain
   - Настройте DNS записи

2. **Настройте мониторинг**:
   - Добавьте UptimeRobot для проверки доступности
   - Настройте алерты

3. **Backup базы данных**:
   - Используйте Supabase backup функции
   - Или настройте pg_dump крон

---

## 📞 Поддержка

**Если что-то не работает:**

1. Проверьте логи в Render Dashboard
2. Убедитесь что все переменные окружения правильные
3. Проверьте доступность Supabase
4. Тестируйте API endpoints вручную

**Полезные команды:**

```bash
# Проверка API
curl https://your-panel-url.onrender.com/api/health

# Проверка webhook
curl https://api.telegram.org/bot<TOKEN>/getWebhookInfo

# Тест Supabase
curl https://chkziqbxvdzwhlucfrza.supabase.co
```

---

**✅ Готово! Ваш проект задеплоен на Render.com!** 🎉

