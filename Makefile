# Start all services in docker-compose
up:
	@docker compose -f ./srcs/docker-compose.yml up

# Stop and remove all containers defined in docker-compose
down:
	@docker compose -f ./srcs/docker-compose.yml down

# Same as down but also removes volumes (data persistence)
# Probably use "down-v:" as rule name
del:
	@docker compose -f ./srcs/docker-compose.yml down -v