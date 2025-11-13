COLOR = \033[38;5;208m
RESET = \033[0m


# Start all servies and force rebuild containers
build:
	@docker compose -f ./srcs/docker-compose.yml up --build


# Start all services in docker-compose
up:
	@docker compose -f ./srcs/docker-compose.yml -p inception up


# Stop and remove all containers defined in docker-compose
down:
	@docker compose -f ./srcs/docker-compose.yml down


# Same as "down" but also removes volumes (data persistence)
downv:
	@docker compose -f ./srcs/docker-compose.yml down -v


# Start an existent container
start:
	@docker compose -f ./srcs/docker-compose.yml start


# Stop current container running
stop:
	@docker compose -f ./srcs/docker-compose.yml stop


# Remove all containers and images
rm-all:
	@docker rm $$(docker ps -aq) 2>/dev/null || true
	@docker rmi $$(docker images -q) 2>/dev/null || true


# Show all containers and images
show:
	@docker ps -a
	@docker images -a


nginx:
	@docker build -t nginx_img -f ./srcs/requirements/nginx/Dockerfile ./srcs/requirements/nginx
	@docker rm -f nginx_container 2>/dev/null || true
	@docker run --name nginx_container nginx_img


db:
	@docker build -t mariadb_img -f ./srcs/requirements/mariadb/Dockerfile ./srcs/requirements/mariadb
	@docker rm -f mariadb_container 2>/dev/null || true
	@docker run --name mariadb_container mariadb_img


wp:
	@docker build -t wordpress_img -f ./srcs/requirements/wordpress/Dockerfile ./srcs/requirements/wordpress
	@docker rm -f wordpress_container 2>/dev/null || true
	@docker run --name wordpress_container wordpress_img


# Show all commands
help:
	@echo "$(COLOR)- up$(RESET): Start all services in docker-compose"
	@echo "$(COLOR)- build$(RESET): Start all services and force rebuild containers"
	@echo "$(COLOR)- down$(RESET): Stop and remove all containers defined in docker-compose"
	@echo "$(COLOR)- downv$(RESET): Same as 'down' but also removes volumes (data persistence)"
	@echo "$(COLOR)- start$(RESET): Start an existent container"
	@echo "$(COLOR)- stop$(RESET): Stop current container running"
	@echo "$(COLOR)- rm-all$(RESET): Remove all containers and images"
	@echo "$(COLOR)- show$(RESET): Show all containers and images"
	@echo "$(COLOR)- nginx$(RESET): Build and run nginx container"
	@echo "$(COLOR)- db$(RESET): Build and run mariadb container"
	@echo "$(COLOR)- wp$(RESET): Build and run wordpress container"
	@echo "$(COLOR)- help$(RESET): Show this help message"