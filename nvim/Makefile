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
	@docker build -t nvim-dev:latest .

.PHONY: remove-image
remove-image: ## Remove the nvim image
	@echo 'deleting nvim-dev:latest image...'
	@docker image rm nvim-dev:latest

.PHONY: nvim
nvim: ## Jump into a shell to use and test Neovim
	@echo 'jumping into a neovim...'
	@docker run --rm -it \
		-e PIP_BREAK_SYSTEM_PACKAGES=1 \
		-v ~/bin/dotfiles/nvim:/root/.config/nvim \
		-v ~/dev:/app \
		-v ~/.virtualenvs:/Users/David.Ross/.virtualenvs \
		-v mason-data:/root/.local/share/nvim \
		--name nvim-dev nvim-dev:latest /bin/bash
