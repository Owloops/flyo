.DEFAULT_GOAL := help

region ?= otp

validate_app = $(if $(app),,$(error Usage: make $@ app=<app> [environment=<env>] [region=<region>]))

.PHONY: help doctor create deploy status logs destroy matrix

help: ## Show usage and commands
	@printf "FlyApps - Self-hosted applications for Fly.io\n\n"
	@printf "Usage: make <command> app=<app> [environment=<env>] [region=<region>]\n\n"
	@printf "Commands:\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'
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
	@if ! command -v fly >/dev/null 2>&1; then echo "Error: fly CLI not found in PATH"; exit 1; fi
	@if ! command -v jq >/dev/null 2>&1; then echo "Error: jq not found in PATH"; exit 1; fi
	@if ! command -v make >/dev/null 2>&1; then echo "Error: make not found in PATH"; exit 1; fi
	@echo "OK: fly CLI found ($(shell fly version | head -1))"
	@if ! fly auth whoami >/dev/null 2>&1; then echo "Error: Not authenticated with Fly.io - run 'fly auth login'"; exit 1; fi
	@echo "OK: Fly.io authenticated as $(shell fly auth whoami)"
	@echo "OK: jq found ($(shell jq --version))"
	@echo "OK: Apps directory apps/ ($(shell find apps -name "fly.toml" 2>/dev/null | wc -l | tr -d ' ') apps found)"
	@echo "All prerequisites satisfied!"

create: ## Create new app on Fly.io
	$(call validate_app)
	@cd apps/$(app) && \
	if fly status --app $(app)$(if $(environment),-$(environment),) >/dev/null 2>&1; then \
		echo "App $(app)$(if $(environment),-$(environment),) already exists, skipping creation..."; \
	else \
		echo "Creating Fly app $(app)$(if $(environment),-$(environment),)..." && \
		fly apps create $(app)$(if $(environment),-$(environment),) && \
		echo "App $(app)$(if $(environment),-$(environment),) created successfully"; \
	fi

deploy: create ## Deploy app with services
	$(call validate_app)
	@echo "Deploying $(app)$(if $(environment),-$(environment),) to $(region)..."
	@cd apps/$(app) && \
		echo "Deploying main application..." && \
		fly deploy --app $(app)$(if $(environment),-$(environment),) --primary-region $(region) && \
		if [ -f "fly.mongod.toml" ]; then \
			echo "Deploying MongoDB service..." && \
			if ! fly status --app $(app)$(if $(environment),-$(environment),)-mongo >/dev/null 2>&1; then \
				fly apps create $(app)$(if $(environment),-$(environment),)-mongo; \
			fi && \
			fly deploy -c fly.mongod.toml --app $(app)$(if $(environment),-$(environment),)-mongo --primary-region $(region); \
		fi && \
		if [ -f "fly.redis.toml" ]; then \
			echo "Deploying Redis service..." && \
			if ! fly status --app $(app)$(if $(environment),-$(environment),)-redis >/dev/null 2>&1; then \
				fly apps create $(app)$(if $(environment),-$(environment),)-redis; \
			fi && \
			fly deploy -c fly.redis.toml --app $(app)$(if $(environment),-$(environment),)-redis --primary-region $(region); \
		fi
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
	find apps -name "fly.toml" 2>/dev/null | sed 's|apps/||;s|/fly.toml||' | sort | jq -R -s -c 'split("\n")[:-1]'; \
	else \
		echo "$(apps)" | tr ',' '\n' | jq -R -s -c 'split("\n")[:-1]'; \
	fi
