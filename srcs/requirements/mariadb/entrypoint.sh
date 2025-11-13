#!/bin/sh
set -e


mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# If this directory doesn't exist, create Database directory (contains tables, etc.)
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --datadir=var/lib/mysql
fi

exec mysqld --user=mysql --datadir=/var/lib/mysql