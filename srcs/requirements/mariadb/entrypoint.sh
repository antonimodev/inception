#!/bin/sh
set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

echo "\nRunning mariadb . . .\n"

exec mysqld --user=mysql --datadir=/var/lib/mysql