# Makefile
-


# Dockerfile
- Always start with line `FROM image:version`
- All `RUN` commands are executed while building
- `RUN` commands doesn't need `sudo` to execute commands, user is root by default
- Each `RUN` line adds an extra layer to build containers. More space is used but only rebuilds if a specific line changes
- `apt-get` more stable due works at low level
- `apt-get clean` removes all cached packages files from "archives" that store `.deb` by commands like `apt-get install` or `apt-get upgrade`
- `rm -rf /var/lib/apt/lists/*` removes all package list files (metadata) from "lists" (doesn't remove `.deb`)
- `EXPOSE` is optional, just for documentation


# Docker Compose
- [RULE] `container_name` and `image` are used to naming.
	IMPORTANT: `image` is used as name if `build` already exist and use docker compose up --build, otherwise it will try to download from `image` repository

- [COMMAND] `-f` flag to specify a particular compose file path