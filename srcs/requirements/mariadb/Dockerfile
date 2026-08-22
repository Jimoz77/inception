#pour l avant-derniere version stable de debian demande de le sbjct
FROM debian:bullseye

#mise a jour de paquets + installation de mariaDB
RUN apt update -y && apt upgrade -y && \
    apt install mariadb-server -y

#copy du fichier de config dans le conteneur
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

#copy le script d initialisation
COPY tools/mariadb.sh /mariadb.sh

#donne le bon droit au script
RUN chmod +x /mariadb.sh

#exposition du port pour la communication des conteneur
EXPOSE 3306

#pour executer le script au demarage du conteneur
ENTRYPOINT ["/mariadb.sh"]
