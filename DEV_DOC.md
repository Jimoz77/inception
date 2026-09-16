# Developer Documentation

This document outlines the technical details and procedures required to set up, build, and manage the Inception environment.

## Setting Up the Environment from Scratch

### Prerequisites
1. **Docker & Docker Compose:** Ensure that Docker and Docker Compose (v2) are installed on your system.
2. **Domain Mapping:** Modify your host's `/etc/hosts` file to resolve the local IP to the project domain name:
   ```text
   127.0.0.1 jiparcer.42.fr
   ```

### Configuration and Secrets (Mandatory Step)
For security reasons, credentials are not stored in the Git repository. You **must** create a `.env` file manually before building the project.

1. Navigate to the `srcs/` directory.
2. Create a `.env` file and populate it with the required variables. Example:
   ```env
   DOMAIN_NAME=jiparcer.42.fr
   
   # Database settings
   DB_NAME=wordpress_db
   DB_USER=jiparcer
   DB_PASSWORD=your_password
   DB_ROOT_PASSWORD=your_root_password
   
   # WordPress settings
   WP_TITLE=Inception
   WP_ADMIN_USER=the_boss
   WP_ADMIN_PASSWORD=admin_password
   WP_ADMIN_EMAIL=admin@42.fr
   WP_USER=johndoe
   WP_USER_PASSWORD=user_password
   WP_USER_EMAIL=user@42.fr
   ```
*Warning: Do not commit the `.env` file to version control. It must be ignored via `.gitignore`.*

## Building and Launching the Project
The root `Makefile` automates the build process via Docker Compose.

- `make up` or `make`: Creates host directories for volumes (`/home/jiparcer/data/...`) and runs `docker compose -f srcs/docker-compose.yml up -d --build`.
- `make clean`: Stops the containers and prunes the Docker system.
- `make fclean`: Fully stops containers, removes all unused images, removes Docker volumes, and forcibly deletes the `/home/jiparcer/data` directory on the host to provide a completely clean slate.

## Container and Volume Management Commands
- **List running containers:** `docker ps`
- **List all containers (including stopped):** `docker ps -a`
- **Execute a command inside a running container (e.g., open a shell):**
  ```bash
  docker exec -it mariadb bash
  ```
- **List volumes:** `docker volume ls`
- **Inspect a specific volume:** `docker volume inspect srcs_db_data`

## Data Persistence
The project requires persistent data storage that survives container restarts and rebuilds.
- **Where is data stored?** 
  Data is stored on the host machine in `/home/jiparcer/data/`.
  - Database files: `/home/jiparcer/data/mariadb`
  - Website files: `/home/jiparcer/data/wordpress`
- **How it persists:** 
  We use Docker *named volumes* (`db_data` and `wp_data`). In `docker-compose.yml`, these volumes are configured with the `local` driver and `bind` options pointing to the host directories. This ensures that the data is managed via the Docker volume API but is safely persisted in the designated physical location on the host. When containers crash or are destroyed, the named volume configuration allows new containers to re-attach to the existing data seamlessly.
