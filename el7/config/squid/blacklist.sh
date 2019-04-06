#!/bin/bash

# Université de Toulouse
HOST=ftp.ut-capitole.fr

# L'exécution du script est réservée à root
if [ `id -u` != 0 ]; then
  echo
  echo ":: Désolé, vous devez être root pour exécuter ce script."
  echo
  exit
fi

# Vérifier si l'hôte distant est joignable
ping -c 1 $HOST > /dev/null 2>&1 ||
  {
    echo
    echo ":: L'hôte distant n'est pas joignable."
    echo
    exit
  }

# Arrêter Squid
systemctl stop squid

# Récupérer les listes
cd /var/squidGuard
rsync -rv rsync://$HOST/blacklist .

# Définir les permissions
chown -R squid:squid dest

# Construire la base de données
echo ":: Construction de la base de données des sites..."
squidGuard -C all

# Rectifier les permissions
chown -R squid:squid /var/squidGuard
chown -R squid:squid /var/log/squidGuard

# Redémarrer Squid
systemctl start squid
