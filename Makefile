.PHONY: help build up down restart logs clean deploy update health dev

# Переменные
COMPOSE_FILE = docker-compose.yml
COMPOSE_DEV = docker-compose.dev.yml

help: ## Показать справку
	@echo "TimeOut Deploy - Управление проектом"
	@echo "===================================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Production команды
build: ## Собрать Docker образы
	docker compose -f $(COMPOSE_FILE) build

up: ## Запустить контейнеры
	docker compose -f $(COMPOSE_FILE) up -d

down: ## Остановить контейнеры
	docker compose -f $(COMPOSE_FILE) down

restart: ## Перезапустить контейнеры
	docker compose -f $(COMPOSE_FILE) restart

logs: ## Показать логи
	docker compose -f $(COMPOSE_FILE) logs -f --tail=100

logs-panel: ## Показать логи панели
	docker compose -f $(COMPOSE_FILE) logs -f --tail=100 panel

logs-bot: ## Показать логи бота
	docker compose -f $(COMPOSE_FILE) logs -f --tail=100 bot

ps: ## Показать статус контейнеров
	docker compose -f $(COMPOSE_FILE) ps

# Development команды
dev-build: ## Собрать образы для разработки
	docker compose -f $(COMPOSE_DEV) build

dev-up: ## Запустить в режиме разработки
	docker compose -f $(COMPOSE_DEV) up

dev-down: ## Остановить dev контейнеры
	docker compose -f $(COMPOSE_DEV) down

# Управление
clean: ## Очистить все ресурсы
	docker compose -f $(COMPOSE_FILE) down -v
	docker system prune -f

deploy: ## Полный деплой (остановка + сборка + запуск)
	@echo "🚀 Деплой..."
	docker compose -f $(COMPOSE_FILE) down
	docker compose -f $(COMPOSE_FILE) build --no-cache
	docker compose -f $(COMPOSE_FILE) up -d
	@echo "✅ Деплой завершен!"
	docker compose -f $(COMPOSE_FILE) ps

update: ## Обновить submodules и передеплоить
	@echo "🔄 Обновление..."
	git pull origin main || git pull origin master
	git submodule update --remote --merge
	$(MAKE) deploy

health: ## Проверить здоровье сервисов
	@echo "🏥 Проверка здоровья..."
	@echo "Panel:"
	@docker inspect timeout-panel --format='{{.State.Health.Status}}' 2>/dev/null || echo "Не запущен"
	@echo "Bot:"
	@docker inspect timeout-bot --format='{{.State.Health.Status}}' 2>/dev/null || echo "Не запущен"
	@echo ""
	@docker compose -f $(COMPOSE_FILE) ps

# Установка
install: ## Первоначальная установка
	@echo "📦 Установка..."
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "⚠️  Создан .env файл. Заполните его реальными значениями!"; \
	fi
	git submodule update --init --recursive
	@echo "✅ Установка завершена!"
	@echo "Отредактируйте .env и запустите: make deploy"

# Тестирование
test-config: ## Проверить конфигурацию docker-compose
	docker compose -f $(COMPOSE_FILE) config

test-build: ## Тестовая сборка без запуска
	docker compose -f $(COMPOSE_FILE) build

# Утилиты
shell-panel: ## Войти в контейнер панели
	docker compose -f $(COMPOSE_FILE) exec panel sh

shell-bot: ## Войти в контейнер бота
	docker compose -f $(COMPOSE_FILE) exec bot sh

stats: ## Показать использование ресурсов
	docker stats --no-stream timeout-panel timeout-bot

backup-env: ## Бэкап .env файла
	@cp .env .env.backup.$(shell date +%Y%m%d_%H%M%S)
	@echo "✅ Бэкап создан: .env.backup.$(shell date +%Y%m%d_%H%M%S)"

