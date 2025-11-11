#!/bin/sh

# -g for general rules of nginx and use "daemon off" to avoid execute at background
cat /etc/nginx/nginx.conf
# nginx -g "daemon off;"

# Routes
# nginx.conf -> /etc/nginx/nginx.conf