LOGIN = jiparcer
DATA_PATH = /home/$(LOGIN)/data

all: up

# Construit et lance les conteneurs en arrière-plan
up: setup
	docker compose -f srcs/docker-compose.yml up -d --build

# Arrête les conteneurs
down:
	docker compose -f srcs/docker-compose.yml down

# Crée les dossiers nécessaires sur la machine hôte pour les volumes
setup:
	sudo mkdir -p $(DATA_PATH)/wordpress
	sudo mkdir -p $(DATA_PATH)/mariadb

# Nettoie les conteneurs, les images inutilisées et les réseaux
clean: down
	docker system prune -af

# Nettoyage total : supprime aussi les volumes de données et le dossier local
fclean: clean
	sudo rm -rf $(DATA_PATH)
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true

# Relance tout de zéro
re: fclean all

.PHONY: all up down setup clean fclean re
