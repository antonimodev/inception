#!/bin/sh
set -e				# Exit with code 1 if it fails

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/ssl/private/server.key \
		-out /etc/ssl/certs/server.crt \
		-subj "/C=ES/ST=Malaga/L=Malaga/O=42/CN=antonimo.42.fr"


cp /conf/nginx.conf /etc/nginx/nginx.conf
exec nginx