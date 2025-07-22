.DEFAULT_GOAL := help

region ?= otp

validate_app = $(if $(app),,$(error Usage: make $@ app=<app> [environment=<env>] [region=<region>]))

define get_app_env_args
$(if $(filter librechat,$(app)),\
	--env MONGO_URI="mongodb://$(app)$(if $(environment),-$(environment),)-mongo.internal:27017/LibreChat",\
	$(if $(filter searxng,$(app)),\
		--env SEARXNG_BASE_URL="https://$(app)$(if $(environment),-$(environment),).fly.dev/" \
		--env SEARXNG_REDIS_URL="redis://$(app)$(if $(environment),-$(environment),)-redis.internal:6379/0",\
	)\
)
endef

.PHONY: help doctor create deploy status logs destroy matrix

help: ## Show usage and commands
	@printf "FlyApps - Self-hosted applications for Fly.io\n\n"
	@printf "Usage: make <command> app=<app> [environment=<env>] [region=<region>]\n\n"
	@printf "Commands:\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'
	@printf "\nExamples:\n"
	@printf "  make doctor                                        # Check prerequisites first\n"
	@printf "  make deploy app=glance                             # Deploy with default region\n"
	@printf "  make deploy app=glance environment=staging         # Deploy staging environment\n"
	@printf "  make deploy app=librechat environment=prod region=fra # Deploy prod to specific region\n"
	@printf "  make status app=glance environment=staging         # Check app status\n"
	@printf "  make logs app=glance environment=staging           # View recent logs\n"
	@printf "  make matrix apps=all                               # List all available apps\n"

doctor: ## Check required tools and auth
	@echo "Checking prerequisites..."
	@if ! command -v fly >/dev/null 2>&1; then \
		echo "Error: fly CLI not found in PATH"; exit 1; \
	fi
	@if ! command -v jq >/dev/null 2>&1; then \
		echo "Error: jq not found in PATH"; exit 1; \
	fi
	@if ! command -v make >/dev/null 2>&1; then \
		echo "Error: make not found in PATH"; exit 1; \
	fi
	@echo "OK: fly CLI found ($(shell fly version | head -1))"
	@if ! fly auth whoami >/dev/null 2>&1; then \
		echo "Error: Not authenticated with Fly.io - run 'fly auth login'"; exit 1; \
	fi
	@echo "OK: Fly.io authenticated as $(shell fly auth whoami)"
	@echo "OK: jq found ($(shell jq --version))"
	@echo "OK: Apps directory apps/ ($(shell find apps -name "fly.toml" 2>/dev/null | wc -l | tr -d ' ') apps found)"
	@echo "All prerequisites satisfied!"

create: ## Create new app on Fly.io
	$(call validate_app)
	@$(MAKE) _create_app APP_NAME=$(app)$(if $(environment),-$(environment),) APP_DIR=apps/$(app)

deploy: create ## Deploy app with services
	$(call validate_app)
	@echo "Deploying $(app)$(if $(environment),-$(environment),) to $(region)..."
	@cd apps/$(app) && \
		echo "Deploying main application..." && \
		fly deploy \
			--app $(app)$(if $(environment),-$(environment),) \
			--primary-region $(region) \
			$(call get_app_env_args) && \
		$(MAKE) _deploy_services app=$(app) $(if $(environment),environment=$(environment),) region=$(region)
	@echo "Deployment complete for $(app)$(if $(environment),-$(environment),)"

status: ## Show app status
	$(call validate_app)
	@echo "Checking status for $(app)$(if $(environment),-$(environment),)..."
	@cd apps/$(app) && fly status --app $(app)$(if $(environment),-$(environment),)

logs: ## Show recent logs
	$(call validate_app)
	@echo "Fetching logs for $(app)$(if $(environment),-$(environment),)..."
	@cd apps/$(app) && fly logs --app $(app)$(if $(environment),-$(environment),) --no-tail

destroy: ## Delete app permanently
	$(call validate_app)
	@echo "WARNING: Destroying $(app)$(if $(environment),-$(environment),)..."
	@cd apps/$(app) && fly apps destroy $(app)$(if $(environment),-$(environment),) --yes
	@echo "App $(app)$(if $(environment),-$(environment),) destroyed successfully"

matrix: ## List apps as JSON
	@if [ "$(apps)" = "all" ] || [ -z "$(apps)" ]; then \
	find apps -name "fly.toml" 2>/dev/null | \
		sed 's|apps/||;s|/fly.toml||' | \
		sort | \
		jq -R -s -c 'split("\n")[:-1]'; \
	else \
		echo "$(apps)" | tr ',' '\n' | jq -R -s -c 'split("\n")[:-1]'; \
	fi

_create_app:
	@cd $(APP_DIR) && \
	if fly status --app $(APP_NAME) >/dev/null 2>&1; then \
		echo "App $(APP_NAME) already exists, skipping creation..."; \
	else \
		echo "Creating Fly app $(APP_NAME)..." && \
		fly apps create $(APP_NAME) && \
		echo "App $(APP_NAME) created successfully"; \
	fi

_deploy_services:
	@cd apps/$(app) && \
	if [ -f "fly.mongod.toml" ]; then \
		echo "Deploying MongoDB service..." && \
		$(MAKE) _create_app APP_NAME=$(app)$(if $(environment),-$(environment),)-mongo APP_DIR=apps/$(app) && \
		fly deploy -c fly.mongod.toml \
		--app $(app)$(if $(environment),-$(environment),)-mongo \
		--primary-region $(region); \
	fi && \
	if [ -f "fly.redis.toml" ]; then \
		echo "Deploying Redis service..." && \
		$(MAKE) _create_app APP_NAME=$(app)$(if $(environment),-$(environment),)-redis APP_DIR=apps/$(app) && \
		fly deploy -c fly.redis.toml \
		--app $(app)$(if $(environment),-$(environment),)-redis \
		--primary-region $(region); \
	fi
