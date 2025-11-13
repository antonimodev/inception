FROM debian:12

COPY entrypoint.sh /entrypoint.sh

# When use tar with --strip-components=1 we remove the top-level dir,
# so all WordPress files are extracted directly into /var/www/html
RUN chmod +x /entrypoint.sh && \
	apt-get update && \
	apt-get install -y --no-install-recommends php-fpm php-mysql curl && \
	curl -O https://wordpress.org/latest.tar.gz && \
	tar -xzf latest.tar.gz -C /var/www/html --strip-components=1 && \
	rm latest.tar.gz && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 9000