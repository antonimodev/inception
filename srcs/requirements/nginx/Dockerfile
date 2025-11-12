FROM debian:12

COPY entrypoint.sh /entrypoint.sh
COPY conf/ /conf/

# Executed while building
RUN chmod +x /entrypoint.sh && \
	apt-get update && \
	apt-get install -y --no-install-recommends nginx openssl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Executing at start of run container
ENTRYPOINT [ "/entrypoint.sh" ]

# This will be args of executable by default
# CMD [ ]

EXPOSE 443