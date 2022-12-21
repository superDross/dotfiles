# allows one to attach a local host directory to the /app dir within the container
ifneq ($(APP_DIR),)
	APP_DIR := -v $(APP_DIR):/app
endif

# create or use an existing persistent directory for nvim data
ifeq ($(NVIM_DATA_DIR),)
	NVIM_DATA_DIR := ~/volumes/nvim-data
endif

default: help

BLUE := \033[36m
WHITE := \033[0m

.PHONY: help
help: ## Show help for all commands
	@echo
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*##"; \
		printf "\nUsage:\n make $(BLUE)<target>$(WHITE)";\
		printf "\n\nVariables:\n";\
		printf "  $(BLUE)NVIM_DATA_DIR$(WHITE):\toverride host dir to use as nvim data persistent storage\n";\
		printf "  $(BLUE)APP_DIR$(WHITE):\t\thost directory to mount to /app"; \
		printf "\n\nTargets:\n"} \
		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  $(BLUE)%-10s$(WHITE) %s\n", $$1, $$2 }' \
		$(MAKEFILE_LIST)

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
	  -v $(NVIM_DATA_DIR):/root/.local/share/nvim \
	  -it \
	  --entrypoint /bin/bash \
	  nvim-dev:latest
