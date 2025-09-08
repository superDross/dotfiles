default: help

BLUE := \033[36m
WHITE := \033[0m

.PHONY: help
help: ## Show help for all commands
	@echo
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*##"; \
		printf "\nUsage:\n make $(BLUE)<target>$(WHITE)";\
		printf "\n\nRun Variables:\n";\
		printf "\n\nTargets:\n"} \
		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  $(BLUE)%-10s$(WHITE) %s\n", $$1, $$2 }' \
		$(MAKEFILE_LIST)

.PHONY: build 
build: ## Build my personally configured Neovim build in a Docker container
	@echo 'building nvim-dev:latest image...'
	@docker compose build

.PHONY: remove-image
remove-image: ## Remove the nvim image
	@echo 'deleting nvim-dev:latest image...'
	@docker image rm nvim-dev:latest

.PHONY: nvim
nvim: ## Jump into a shell to use and test Neovim
	@echo 'jumping into a neovim...'
	@docker compose run nvim-dev /bin/bash
