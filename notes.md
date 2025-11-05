# Makefile
-


# Dockerfile
- Always start with line `FROM image:version`
- `RUN` commands doesn't need `sudo` to execute commands, user is root by default
- `apt-get` works at low level
- `apt-get clean` removes all cached packages files from "archives" that store `.deb` by commands like `apt-get install` or `apt-get upgrade`
- `rm -rf /var/lib/apt/lists/*` removes all package list files (metadata) from "lists" (doesn't remove `.deb`)
- `EXPOSE` is optional, just for documentation


# Docker Compose
- Execute command with `-f` flag to indicate an specific filepath