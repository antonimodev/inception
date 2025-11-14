#!/bin/sh
set -e

# Configure PHP-FPM to LISTEN all interfaces
sed -i 's/listen = .*/listen = 0.0.0.0:9000/' /etc/php/8.2/fpm/pool.d/www.conf

# Execute with -F is like daemon off; in nginx
exec php-fpm8.2 -F
