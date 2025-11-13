#!/bin/sh
set -e

# Execute with -F is like daemon off; in nginx
exec php-fpm8.2 -F
