# User Documentation

This document explains how to interact with the Inception infrastructure as an end user or administrator.

## Services Provided
Our stack provides a complete, containerized web application infrastructure:
- **NGINX:** Acts as the entrypoint and web server. It handles HTTPS requests securely using TLSv1.2/1.3 and serves the web content.
- **WordPress (PHP-FPM):** The core application engine. It manages the website's content and logic.
- **MariaDB:** The database backend that securely stores all of WordPress's data and user information.

## Locate and Manage Credentials (IMPORTANT)
**Note:** For security reasons, the `.env` file containing all credentials is NOT provided in the Git repository. 
You must create it manually in the `srcs/` folder before launching the project. (Refer to the `DEV_DOC.md` for the exact variables to include).

If you need to change passwords, database names, or user roles later, you can edit this `.env` file. Keep in mind that changes to `.env` require rebuilding the environment for some services to take effect (a total `make fclean` followed by `make` is recommended if modifying the database setup).

## Start and Stop the Project
The project uses a `Makefile` at the root to simplify operations.

- **To start the project:**
  Open a terminal at the root of the project and run:
  ```bash
  make
  ```
  This command will automatically create the necessary data folders on your host and launch the containers in the background.

- **To stop the project:**
  ```bash
  make down
  ```
  This gracefully stops all running services without deleting your data.

## Accessing the Website and Administration Panel
- **Website:** Open your web browser and navigate to `https://jiparcer.42.fr`. Note that since we use self-signed certificates, your browser may display a security warning. You can safely proceed.
- **Admin Panel:** Access the WordPress administration dashboard by navigating to `https://jiparcer.42.fr/wp-admin/`.

## Check Services Status
To ensure that all services are running correctly:
1. Run `docker ps` in your terminal. You should see three containers running (`nginx`, `wordpress`, `mariadb`) with `Up` status.
2. If a service is malfunctioning, you can view its logs by typing:
   ```bash
   docker logs <container_name>
   # example: docker logs nginx
   ```
