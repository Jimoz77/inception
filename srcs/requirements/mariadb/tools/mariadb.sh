#!/bin/bash

# lancement de mariadb en background pour configurer 
service mariadb start

# mutex sur le lunch de mariadb
sleep 5

# crée la db si inex
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"

# crée le user si inex + mdp
mariadb -e "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';"

# donne a sys user tout les droit sur la db
mariadb -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';"

# changement mdp du root user mariadb
mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"

# application des changement
mariadb -e "FLUSH PRIVILEGES;"

#shutdown service en background lunch juste avant
mysqladmin -u root -p$DB_ROOT_PASSWORD shutdown


#lunch mariadb en foreground, docker s arrete si pid 1 se termine, mysql_safe permet de garder le conteneur online malgrés ca
exec mysqld_safe

