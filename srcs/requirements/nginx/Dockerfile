FROM debian:12

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN apt-get update && \
	apt-get install -y --no-install-recommends nginx && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# This will be executable
ENTRYPOINT [ "/entrypoint.sh" ]
# This will be args of executable by default
# CMD [ ]

EXPOSE 443
