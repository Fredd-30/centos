#!/bin/bash
#
# Sauvegarde automatique avec Rsnapshot. Ranger dans ~/bin, adapter les
# variables et lancer avec un cronjob. Exemple :
#
# 30 09 * * * /home/microlinux/bin/backup.sh

#HOSTNAME=$(hostname --fqdn)
#HOSTNAME=backup.microlinux.fr
SENDER="root@$HOSTNAME"
#RELAY="yatahongaga@gmail.com"
#RELAY="$SENDER"
ADMIN="info@microlinux.fr"

rsnapshot -v daily 2>&1 | \
  mail -s "Sauvegarde effectuée sur $HOSTNAME" \
  -r "$RELAY (root@$HOSTNAME)" \
  $ADMIN
