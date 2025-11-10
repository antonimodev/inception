COLOR = \033[38;5;208m
RESET = \033[0m

# Start all services in docker-compose
up:
	@docker compose -f ./srcs/docker-compose.yml up


# Start all servies and force rebuild containers
build:
	@docker compose -f ./srcs/docker-compose.yml up --build


# Stop and remove all containers defined in docker-compose
down:
	@docker compose -f ./srcs/docker-compose.yml down


# Same as "down" but also removes volumes (data persistence)
# Probably use "down-v:" as rule name
downv:
	@docker compose -f ./srcs/docker-compose.yml down -v

# Remove all containers and images
rm-all:
	@docker rm $$(docker ps -aq) 2>/dev/null || true
	@docker rmi $$(docker images -q) 2>/dev/null || true

show:
	@docker ps -a
	@docker images -a

help:
	@echo "$(COLOR)- up$(RESET): Start all services in docker-compose"
	@echo "$(COLOR)- build$(RESET): Start all services and force rebuild containers"
	@echo "$(COLOR)- down$(RESET): Stop and remove all containers defined in docker-compose"
	@echo "$(COLOR)- downv$(RESET): Same as 'down' but also removes volumes (data persistence)"
	@echo "$(COLOR)- rm-all$(RESET): Remove all containers and images"
	@echo "$(COLOR)- show$(RESET): Show all containers and images"
	@echo "$(COLOR)- help$(RESET): Show this help message"