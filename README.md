# 🐳 Inception

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![WordPress](https://img.shields.io/badge/WordPress-117AC9?style=for-the-badge&logo=wordpress&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white)

> **System Administration Project**
>
> This project involves setting up a small infrastructure of interconnected services using **Docker** and **Docker Compose**, following the strict rule of "one container per service".

---

## 🏗️ Architecture

The project configures three independent containers communicating through an internal network (`inception`):

1.  **NGINX** (TLS v1.3): The only entry point. It handles HTTPS security and redirects to WordPress.
2.  **WordPress** + **PHP-FPM**: The CMS installed and configured automatically, without its own web server (delegated to Nginx).
3.  **MariaDB**: The SQL database for WordPress, isolated in its own container.

All data persistence (database and web files) is managed via **Docker Volumes** stored locally.

---

## 🚀 Installation & Usage

### 1. Prerequisites
Ensure you have `Docker`, `Docker Compose`, and `Make` installed on your machine (or Virtual Machine).

### 2. Host Configuration
To access the site via the required domain, add the following line to your `/etc/hosts` file (requires `sudo`):

```bash
127.0.0.1   login.42.fr
```

### 3. Deployment

Clone the repository and launch the project with a single command:   

```bash
make build
```

Once up, access: https://login.42.fr

Note: Accept the browser's security warning (the SSL certificate is self-signed for this exercise).

## 🛠️ Useful Commands

The entire project lifecycle is managed via the `Makefile`:

| Command | Description |
| :--- | :--- |
| `make build` | Builds the images and starts the containers. |
| `make up` | Starts the containers (if they are already built). |
| `make down` | Stops and removes the containers. |
| `make stop` | Stops the containers without removing them. |
| `make start` | Starts stopped containers. |
| `make fclean` | **Total cleanup:** Removes containers, images, networks, and volumes (including local data in `/home/antonimo/data`). |
| `make help` | Displays all commands usage using makefile. |

---

## 📂 Project Structure

```text
.
├── Makefile            # Command automation
├── srcs
│   ├── docker-compose.yml
│   ├── .env            # Environment variables (Credentials, Domain)
│   └── requirements
│       ├── mariadb     # DB Configuration
│       ├── nginx       # Server & SSL Configuration
│       └── wordpress   # CMS & PHP Configuration
