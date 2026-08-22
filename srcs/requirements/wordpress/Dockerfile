#pour l avant-derniere version stable
FROM debian:bullseye

#installation de php-fpm + entensions MySQL pour PHP et wget/curl
RUN apt update -y && apt upgrade -y && \
    apt install -y php7.4-fpm php7.4-mysql mariadb-client curl wget

#creation du dossier qui accuillera le site + update des permission
RUN mkdir -p /var/www/html /run/php
RUN chown -R www-data:www-data /var/www/html

#copy de la config php personalisé
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

#copy de script d'initialisation
COPY tools/wordpress.sh /wordpress.sh
RUN chmod +x /wordpress.sh

EXPOSE 9000

#lancement du script au demarrage
ENTRYPOINT ["/wordpress.sh"]
