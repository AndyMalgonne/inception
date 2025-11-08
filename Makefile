all: up

.PHONY: all up down stop start status

COMPOSE_FILE := ./srcs/docker-compose.yml
COMPOSE := docker compose -f $(COMPOSE_FILE)

up:
	@$(COMPOSE) down -v
	@$(COMPOSE) build --pull
	@$(COMPOSE) up -d --remove-orphans

down:
	@$(COMPOSE) down

stop:
	@$(COMPOSE) stop

start:
	@$(COMPOSE) start

status:
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"