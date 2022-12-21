ifneq ($(APP_DIR),)
	APP_DIR := -v $(APP_DIR):/app
endif

default: help

.PHONY: help
help: ## Show help for all commands
	@echo
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: build 
build: ## Build my personally configured Neovim build in a Docker container
	@echo 'building neovim-dev:latest image...'
	@docker build -t nvim-dev:latest .

.PHONY: bash
bash: ## Jump into a shell to use and test Neovim (APP_DIR=/dir to mount host dir to /app)
	@echo 'jumping into a shell...'
	$(MAKE) build
	docker run \
	  $(APP_DIR) \
	  -v ~/volumes/nvim-data:/root/.local/share/nvim \
	  -it \
	  --entrypoint /bin/bash \
	  nvim-dev:latest
