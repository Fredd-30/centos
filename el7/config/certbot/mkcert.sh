#!/bin/bash
#
# mkcert.sh
#
# Nicolas Kovacs, 2019
#
# Créer ou renouveler un certificat SSL/TLS Let's Encrypt

# Créer le groupe certs avec le GID 240
if ! grep -q "^certs:" /etc/group ; then
  groupadd -g 240 certs
  echo ":: Ajout du groupe certs."
  sleep 3
fi

# Arrêter le serveur Apache
if ps ax | grep -v grep | grep httpd > /dev/null ; then
  echo ":: Arrêt du serveur Apache."
  systemctl stop httpd 1 > /dev/null 2>&1
  sleep 5
fi

# Générer ou renouveler un certificat SSL/TLS
certbot certonly \
  --non-interactive \
  --email info@microlinux.fr \
  --preferred-challenges http \
  --standalone \
  --agree-tos \
  --renew-by-default \
  --webroot-path /var/www/default \
  -d sd-123456.dedibox.fr \
  --webroot-path /var/www/slackbox-site \
  -d slackbox.fr -d www.slackbox.fr \
  --webroot-path /var/www/slackbox-mail \
  -d mail.slackbox.fr \
  --webroot-path /var/www/unixbox-site \
  -d www.unixbox.fr -d unixbox.fr \
  --webroot-path /var/www/unixbox-mail \
  -d mail.unixbox.fr 

# Définir les permissions
echo ":: Définition des permissions."
chgrp -R certs /etc/letsencrypt
chmod -R g=rx /etc/letsencrypt

# Démarrer Apache
echo ":: Démarrage du serveur Apache."
systemctl start httpd

