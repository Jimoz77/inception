*This project has been created as part of the 42 curriculum by jiparcer.*

## Description
Inception is a system administration project from the 42 curriculum. The goal is to broaden our knowledge of system administration by virtualizing several Docker images in a personal virtual machine. We set up a small infrastructure composed of different services (NGINX, WordPress, MariaDB) under specific rules, with each service running in a dedicated container.

## Instructions
1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd inception
   ```
2. **Setup Domain Name:**
   Ensure your local `/etc/hosts` points the domain name to localhost:
   `127.0.0.1 jiparcer.42.fr`
3. **Environment Variables:**
   Create or verify your `.env` file in the `srcs` directory with your database and WordPress credentials (see `DEV_DOC.md`).
4. **Execution:**
   To build and start the infrastructure:
   ```bash
   make
   ```
   To stop the infrastructure:
   ```bash
   make down
   ```
   To completely clean up (including volumes and data):
   ```bash
   make fclean
   ```

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [NGINX Official Documentation](https://nginx.org/en/docs/)
- [WordPress CLI Documentation](https://make.wordpress.org/cli/handbook/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)

**AI Usage:**
AI was used in this project primarily as a tutor to understand complex system administration concepts. It helped in breaking down the differences between various Docker networking modes and volumes, explaining best practices regarding PID 1 management in containers, and understanding TLS handshake processes. It also served as a tool for brainstorming the architecture of the infrastructure and clarifying the theoretical differences between virtual machines and containers.

## Project description
This project heavily relies on Docker and `docker-compose` to manage the infrastructure. By building custom images from the penultimate stable version of Debian (bullseye), we ensure that we have full control over the installation and configuration of our services. The main design choice is to use a 3-tier architecture (Web server, Application, Database) isolated in three different containers, communicating purely through an internal Docker network without exposing unnecessary ports to the host.

### Comparisons

**Virtual Machines vs Docker**
Virtual Machines virtualize hardware and require a full guest operating system for each instance, which makes them heavy and resource-intensive. Docker virtualizes the operating system layer, allowing containers to share the host's kernel. This makes Docker containers lightweight, fast to start, and highly portable.

**Secrets vs Environment Variables**
Environment variables are injected into the environment of the running process and are widely used to configure applications dynamically. However, they can sometimes be accidentally leaked in logs or process trees. Docker Secrets provide a more secure mechanism for handling sensitive data by mounting them as in-memory files within the container, preventing exposure through standard environment variables. While this project uses environment variables via a `.env` file for simplicity and as required by the subject, secrets are the recommended approach for true production security.

**Docker Network vs Host Network**
The host network driver removes network isolation between the container and the Docker host, meaning the container shares the host's networking namespace. A custom Docker Network (like the bridge network used here) creates an isolated, internal network for containers to communicate securely via DNS resolution using their container names, without exposing their traffic to the external host network or the outside world.

**Docker Volumes vs Bind Mounts**
Bind mounts depend on the directory structure and OS of the host machine, mounting an absolute host path directly into the container. Docker Volumes are managed entirely by Docker, providing better portability, easier backup, and independence from the host's file system structure. In this project, we use named Docker volumes configured with local drivers to persist data securely in `/home/jiparcer/data/`.
