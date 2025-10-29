# GitHub Secrets для CI/CD

Добавьте следующие secrets в настройках GitHub репозитория:
**Settings** → **Secrets and variables** → **Actions** → **New repository secret**

## 🔑 Обязательные Secrets

### VPS Доступ
- `SSH_PRIVATE_KEY` - Приватный SSH ключ для подключения к VPS
  ```bash
  cat ~/.ssh/id_rsa
  ```

- `VPS_HOST` - IP адрес или домен VPS
  ```
  123.456.789.0
  или
  your-domain.com
  ```

- `VPS_USER` - Пользователь SSH
  ```
  root
  или
  ubuntu
  ```

- `DEPLOY_PATH` - Путь к проекту на VPS
  ```
  /home/user/timeout-deploy
  или
  /var/www/timeout-deploy
  ```

### GitHub (для submodules)
- `GH_PAT` - Personal Access Token с правами на чтение репозиториев
  1. GitHub → Settings → Developer settings → Personal access tokens
  2. Generate new token (classic)
  3. Выберите права: `repo` (Full control of private repositories)
  4. Скопируйте токен

### Уведомления (опционально)
- `SLACK_WEBHOOK` - Webhook URL для уведомлений в Slack
  ```
  https://hooks.slack.com/services/YOUR/WEBHOOK/URL
  ```

## 📋 Пример настройки SSH ключа

### На вашем компьютере:
```bash
# Генерируем новый SSH ключ (если нет)
ssh-keygen -t ed25519 -C "github-actions"

# Копируем публичный ключ
cat ~/.ssh/id_ed25519.pub
```

### На VPS:
```bash
# Добавляем публичный ключ в authorized_keys
echo "ваш-публичный-ключ" >> ~/.ssh/authorized_keys
```

### В GitHub:
```
Secret name: SSH_PRIVATE_KEY
Value: (содержимое ~/.ssh/id_ed25519)
```

## ✅ Проверка

После добавления всех secrets, GitHub Actions сможет:
1. Подключаться к VPS по SSH
2. Клонировать submodules
3. Деплоить проект автоматически

## 🚀 Автоматический деплой

После настройки secrets, каждый push в `main`/`master` ветку запустит автоматический деплой на VPS.

Проверить статус: **Actions** → **Deploy to VPS**

