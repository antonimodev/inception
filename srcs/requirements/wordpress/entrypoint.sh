#!/bin/sh
set -e

# Configure PHP-FPM to LISTEN all interfaces
sed -i 's/listen = .*/listen = 0.0.0.0:9000/' /etc/php/8.2/fpm/pool.d/www.conf

if [ ! -f /var/www/html/wp-config.php ]; then
    cat > /var/www/html/wp-config.php <<- EOF
<?php
define( 'DB_NAME', '${WORDPRESS_DB_NAME}' );
define( 'DB_USER', '${WORDPRESS_DB_USER}' );
define( 'DB_PASSWORD', '${WORDPRESS_DB_PASSWORD}' );
define( 'DB_HOST', '${WORDPRESS_DB_HOST}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

\$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';

EOF
    chown www-data:www-data /var/www/html/wp-config.php
fi

# Execute with -F is like daemon off; in nginx
exec php-fpm8.2 -F
