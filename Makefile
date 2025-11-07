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