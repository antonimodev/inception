FROM debian:12

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
	apt-get update && \
	apt-get install -y --no-install-recommends mariadb-server && \
	mkdir -p /run/mysqld && \
	chown mysql:mysql /run/mysqld && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 3306
