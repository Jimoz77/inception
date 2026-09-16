#!/bin/bash

# Initialise la db si le montage bind masque les fichiers pré-installés par l'image
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de la base de données..."

	#changement des permissions du dossier créé par "sudo mkdir"
	chown -R mysql:mysql /var/lib/mysql

    mysql_install_db --user=mysql --datadir=/var/lib/mysql
	
	# lancement de mariadb en background pour configurer 
	service mariadb start

	# mutex sur le lunch de mariadb
	sleep 10

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

fi

#lunch mariadb en foreground, docker s arrete si pid 1 se termine, mysql_safe permet de garder le conteneur online malgrés ca
exec mysqld_safe

