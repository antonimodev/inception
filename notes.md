# Makefile
-


# Dockerfile
- Always start with line `FROM image:version`
- All `RUN` commands are executed while building
- `RUN` commands doesn't need `sudo` to execute commands, user is root by default
- Each `RUN` line adds an extra layer to build containers. More space is used but only rebuilds if a specific line changes
- `apt-get` more stable due works at low level
- `apt-get clean` removes all cached packages files from "archives" that store `.deb` by commands like `apt-get install` or `apt-get upgrade`
- `rm -rf /var/lib/apt/lists/*` removes all package list files (metadata) from "lists" (doesn't remove `.deb`)
- `EXPOSE` is optional, just for documentation


# Docker Compose
- [RULE] `container_name` and `image` are used to naming.
	IMPORTANT: `image` is used as name if `build` already exist and use docker compose up --build, otherwise it will try to download from `image` repository

- [COMMAND] `-f` flag to specify a particular compose file path


# CHECK

services:
  nginx:
    build: ./requirements/nginx
    image: nginx_img
    container_name: nginx_container
    restart: always
    ports:
      - "443:443"
    volumes:
      - wordpress_files:/var/www/html
    depends_on:
      - wordpress
    networks:
      - inception_network

  mariadb:
    build: ./requirements/mariadb
    image: mariadb_img
    container_name: mariadb_container
    restart: always
    volumes:
      - mariadb_data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - MYSQL_USER=${SQL_USER}
      - MYSQL_PASSWORD=${SQL_PASS}
    networks:
      - inception_network

  wordpress:
    build: ./requirements/wordpress
    image: wordpress_img
    container_name: wordpress_container
    restart: always
    volumes:
      - wordpress_files:/var/www/html
    depends_on:
      - mariadb
    environment:
      - WORDPRESS_DB_HOST=mariadb:3306
      - WORDPRESS_DB_NAME=${MYSQL_DATABASE}
      - WORDPRESS_DB_USER=${SQL_USER}
      - WORDPRESS_DB_PASSWORD=${SQL_PASS}
    networks:
      - inception_network

volumes:
  wordpress_files:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/antonimo/data/wordpress
  mariadb_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/antonimo/data/mariadb

networks:
  inception_network:
    driver: bridge

---

#!/bin/sh
set -e

# Configure php to listen port 9000
sed -i 's/listen = .*/listen = 0.0.0.0:9000/' /etc/php/8.2/fpm/pool.d/www.conf

# wait til mariadb works
echo "Waiting for MariaDB..."
while ! nc -z mariadb 3306; do
  sleep 1
done
echo "MariaDB is ready!"

# if does not exist wp-config.php, configure it
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Configuring WordPress..."
    
    # Crear wp-config.php
    cat > /var/www/html/wp-config.php <<EOF
<?php
define('DB_NAME', '${WORDPRESS_DB_NAME}');
define('DB_USER', '${WORDPRESS_DB_USER}');
define('DB_PASSWORD', '${WORDPRESS_DB_PASSWORD}');
define('DB_HOST', '${WORDPRESS_DB_HOST}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

\$table_prefix = 'wp_';

define('WP_DEBUG', false);

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
EOF
fi

# Adjust permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

exec php-fpm8.2 -F

---

# nginx conf (check it)

user www-data;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log;
daemon off;

events {
    worker_connections 768;
}

http {
    sendfile on;
    tcp_nopush on;
    types_hash_max_size 2048;
    server_tokens off;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ssl_protocols TLSv1.3;

    access_log /var/log/nginx/access.log;

    gzip on;
    gzip_http_version 1.1;
    gzip_comp_level 5;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    server {
        listen 443 ssl http2;
        server_name antonimo.42.fr www.antonimo.42.fr;

        ssl_certificate /etc/ssl/certs/server.crt;
        ssl_certificate_key /etc/ssl/private/server.key;

        root /var/www/html;
        index index.php index.html;

        location / {
            try_files $uri $uri/ /index.php?$args;
        }

        location ~ \.php$ {
            fastcgi_pass wordpress:9000;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }

        location ~ /\.ht {
            deny all;
        }
    }

    server {
        listen 80;
        server_name antonimo.42.fr www.antonimo.42.fr;
        return 301 https://$host$request_uri;
    }
}

---

# Mariadb entrypoint.sh (check it)

#!/bin/sh
set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Init mariadb
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"
    
    # Wait til mariadb is on
    for i in {30..0}; do
        if mysqladmin ping -u root --silent; then
            break
        fi
        sleep 1
    done
    
    # Create database
    mysql -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASS}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${SQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL
    
    # Stop mariaDB
    kill -s TERM "$pid"
    wait "$pid"
fi

exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0