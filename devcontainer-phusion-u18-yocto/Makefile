# Makefile

################################################################################
# util-makefile
####

SHELL := /bin/bash
# The directory of this file
DIR := $(shell echo $(shell cd "$(shell  dirname "${BASH_SOURCE[0]}" )" && pwd ))
# -user string Username or UID (format: <name|uid>[:<group|gid>])

.PHONY: help confirm

# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Show Makefile help message
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

confirm:
	@( read -p "Are you sure? [y/N]: " sure && case "$$sure" in [yY]) true;; *) false;; esac )

.DEFAULT_GOAL := help
####
# util-makefile
################################################################################

################################################################################
# docker-compose-makefile
#
# References:
# - https://github.com/krom/docker-compose-makefile
####

# constants
DOCKER_COMPOSE := docker-compose
DOCKER_COMPOSE_FILE := $(DIR)/docker-compose.yml

C_SINGLE_DEFAULT=main
USER_NAME=user

BUILDER_UID := $(shell id -u)
BUILDER_GID := $(shell id -g)
export BUILDER_UID BUILDER_GID

# arguments
c :=
u := --user '$(BUILDER_UID):$(BUILDER_GID)'
c_single := $(if $(c),$(c),$(C_SINGLE_DEFAULT))

#
# https://github.com/krom/docker-compose-makefile
#
.PHONY: up start stop restart status restart logs

up: ## Start all or c=<name> containers in foreground
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up $(c)

start: ## Start all or c=<name> containers in background
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) start $(c)
# @$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up $(c) -d # TODO: up or start?

stop: ## Stop all or c=<name> containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) stop $(c)

status: ## Show status of containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) ps

restart: ## Restart all or c=<name> containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) stop $(c)
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up $(c) -d

logs: ## Show logs for all or c=<name> containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) logs --tail=100 -f $(c)

#
# docker-compose passthrough targets
#

.PHONY: build
build: ## Build or rebuild all services or c=<name> service
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) build

.PHONY: rm
rm: ## Remove stopped containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) rm

.PHONY: rmf
rmf: ## Remove running containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) rm

.PHONY: config
config: ## Validate and view the Compose file
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) config

#
# docker-compose custom targets
#

.PHONY: console
console: ## Start bash login shell in new container
	docker-compose run \
		--entrypoint '/bin/bash' \
		--workdir "/home/$(USER_NAME)/" \
		$(u) \
		$(c_single) \
		-l

.PHONY: enter
enter: ## Start bash login shell in existing container
	docker-compose exec \
		$(u) \
		$(c_single) \
		'/bin/bash' -l

.PHONY: login
login: ## Start bash login shell in existing container
	docker-compose exec \
		$(u) \
		$(c_single) \
		'/bin/bash' -l

.PHONY: root_console
root_console: ## Start bash login shell as root in new container
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) run \
		--entrypoint '/bin/bash' \
		--workdir '/root'/ \
		$(c_single) \
		-l

# NOTE: --workdir Setting workdir for exec is not supported in API < 1.35 (1.25)
.PHONY: root_enter
root_enter: ## Start bash login shell as root in existing container
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) exec \
		$(c_single) \
		'/bin/bash' -l

# docker-compose aliases

ps: status ## Show status of containers
remove: rm ## Remove stopped containers

####
# docker-compose-makefile
################################################################################


#
# aliases
#
