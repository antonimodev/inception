#!/bin/sh
set -e

# BASIC FOR MARIADB

## If this directory doesn't exist, create Database directory (contains tables, priviledges, etc.)
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --datadir=var/lib/mysql
fi

# Start MariaDB server in the background

# --skip-networking to avoid connection issues during the setup
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
pid="$!"

# Wait until MariaDB is ready to accept connections
for i in $(seq 30); do
	if mysqladmin ping -u root --silent; then
		break
	fi
	sleep 1
done

# Create database and user for WordPress with priviledges and allow it to connect from anywhere by '%'
mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -u root -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASS}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${SQL_USER}'@'%';"
mysql -u root -e "FLUSH PRIVILEGES;"

kill "$pid"
wait "$pid"

exec mysqld --user=mysql --datadir=/var/lib/mysql