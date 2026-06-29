#avant derniere version stable
FROM debian:bookworm

#mise a jour et installation de NGINX et OpenSSL pour generer les certif
RUN apt update -y && apt upgrade -y && \
    apt install -y nginx openssl

#création du dossier pour stocker les clé de sécurité
RUN mkdir -p /etc/nginx/ssl

#generation des certif auto-signé
#paramètre -x509 et -nodes pour créer un certificat qui n'a pas besoin de mot de passe lors du redémarrage
#paramètre -subj pour rempir automatiquement (pays, ville, organisation) et evité le blocage occasionné par la demande dans le terminal
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=CH/ST=VD/L=Lausanne/O=42/OU=42/CN=jiparcer.42.fr/UID=jiparcer"

#copy du fichier de config dans le dossier nginx
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

#expose le port pour les requete client
EXPOSE 443

#lancement de nginx en background mais en lui interdisant de se détacher en daemon, pour le forcer a rester en foreground donc PID 1
CMD ["nginx","-g", "deamon off;"]

