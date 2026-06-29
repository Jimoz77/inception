#!/bin/bash

#aller de le dossier lié au volume
cd /var/www/html

#telecharger WP-CLI pour installer wordpress en cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

#on attends pour etre sur que mariadb soit lancé
sleep 10

#si le fichier wp-config.php est inex, alors wordpress pas encore installé

if[ ! -e wp-config.php ]; then
	echo "Installation de WordPress..."

	#telechargement des fichier de base de wordpress
	wp core download --allow-root
	
	#creation du fichier config pour se co a mariadb
	wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbost=mariadb --allow-root
	#installation de wordpress + creation de l admin
	wp core install --url=$DOMAIN_NAME --title=WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_EMAIL --alow-root

	#creation du 2eme user demandé dans sbjct
	wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PASSWORD --allow-root
	
	echo"WordPress est installé et configuré !"
else
	echo"WordPress est déjà installé"
fi

#donne les bon droit au dossier web
chown -R www-data:www-data /var/www/html

#comme pour mariadb on lance PHP-FPM en foreground (PID 1) avec exec
# -F force PHP-FPM a rester en foreground
exec /usr/sbin/php-fpm8.2 -F

