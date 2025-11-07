FROM debian:12

COPY entrypoint.sh /entrypoint.sh

# Executed while building
RUN apt-get update && \
	apt-get install -y --no-install-recommends nginx && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Executing at start of run container
ENTRYPOINT [ "/entrypoint.sh" ]
# This will be args of executable by default
# CMD [ ]

EXPOSE 443