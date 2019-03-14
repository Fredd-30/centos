#!/bin/bash
#
# sqldump.sh
#
# Nicolas Kovacs, 2019
#
# Ce script effectue une sauvegarde de toutes les bases de données MySQL.
#
# Chaque base de données est sauvegardée en tant que fichier compressé
# backup-base-AAAAMMJJ.sql.gz en-dessous de $BACKUPDIR. Ensuite, toutes les
# bases sont sauvegardées en tant que backup-all-AAAAMMJJ.sql.gz.
#
# Copier ce script vers un endroit approprié comme /usr/local/sbin, éditer les
# paramètres de connexion et définir les droits rwx------ (chmod 0700). 
#
# On pourra définir une tâche automatique comme ceci :
#
# crontab -e
#
## Sauvegarde quotidienne des bases MySQL à 11h50
#50 11 * * * /usr/local/sbin/sqldump.sh 1> /dev/null

# Accès MySQL
MYSQLUSER="root"
MYSQLPASS="mysqlpass"

# Répertoire des sauvegardes
BACKUPDIR="/sqldump"

# Couleurs
BLUE="\033[01;34m"
GREEN="\033[01;32m"
NC="\033[00m"

# Pause entre les sauvegardes
DELAY=1

# Aujourd'hui = AAAAMMJJ
TIMESTAMP=$(date "+%Y%m%d")

# Bases de données

DBNAME[1]="base1"
DBUSER[1]="db1user"
DBPASS[1]="db1pass"

DBNAME[2]="base2"
DBUSER[2]="db2user"
DBPASS[2]="db2pass"

DBNAME[3]="base3"
DBUSER[3]="db3user"
DBPASS[3]="db3pass"

# Exécuter en tant que root
if [ $EUID -ne 0 ] ; then
  echo "::"
  echo ":: Vous devez être root pour effectuer ce script."
  echo "::"
  exit 1
fi

echo "::" 
echo ":: Lancement de la sauvegarde des bases MySQL."
echo "::" 
sleep $DELAY

# Tester si le répertoire des sauvegardes existe
if [ ! -d $BACKUPDIR ] ; then
  echo ":: Création du répertoire de sauvegarde."
  echo "::"
  sleep $DELAY
  mkdir -p -m 0750 $BACKUPDIR
fi

echo ":: Suppression des anciennes sauvegardes."
echo "::"
sleep $DELAY
rm -f $BACKUPDIR/*.sql
rm -f $BACKUPDIR/*.sql.gz

for (( DB=1 ; DB<=${#DBNAME[*]} ; DB++ )) ; do
  echo -e ":: Sauvegarde de la base [$BLUE${DBNAME[$DB]}$NC]."
  echo "::"
  sleep $DELAY
  mysqldump -u ${DBUSER[$DB]} -p${DBPASS[$DB]} ${DBNAME[$DB]} | \
            gzip -c > $BACKUPDIR/backup-${DBNAME[$DB]}-$TIMESTAMP.sql.gz
done

echo -e ":: Sauvegarde de toutes les bases."
echo "::"
sleep $DELAY
mysqldump -u $MYSQLUSER -p$MYSQLPASS --events --ignore-table=mysql.event \
  --all-databases | gzip -c > $BACKUPDIR/backup-all-$TIMESTAMP.sql.gz

echo -e ":: Définition des droits d'accès."
chmod 0640 $BACKUPDIR/*.sql*
echo "::"

echo -e ":: [${GREEN}OK${NC}]"
echo "::"

exit 0
