#!/bin/bash
#
# wordpress-update.sh
#
# Mise à jour automatique de toutes les installations Wordpress
#
# (c) Nicolas Kovacs <info@microlinux.fr>

# WP-CLI doit être installé
WP='/usr/local/bin/wp'

# Apache
HTUSER='apache'
HTGROUP='apache'

# Utilisateur normal
WPUSER='microlinux'
WPGROUP='microlinux'

# Racine du serveur Web
WPROOT='/var/www'

# Identifier les installations Wordpress 
WPDIRS=$(dirname $(find $WPROOT -type f -name 'wp-config.php'))

for WPDIR in $WPDIRS; do
  echo
  echo "---------- $WPDIR ----------"
  echo
  cd $WPDIR
  # Définir les permissions correctes
  chown -R $WPUSER:$WPGROUP $WPDIR
  find $WPDIR -type d -exec chmod 0755 {} \;
  find $WPDIR -type f -exec chmod 0644 {} \;
  chown -R $WPUSER:$HTGROUP $WPDIR/wp-content
  find $WPDIR/wp-content -type d -exec chmod 0775 {} \;
  find $WPDIR/wp-content -type f -exec chmod 0664 {} \;
  # Mettre à jour le moteur Wordpress
  su -c "$WP core update" $WPUSER
  # Mettre à jour les extensions
  su -c "$WP plugin update --all" $WPUSER
  # Mettre à jour les thèmes
  su -c "$WP theme update --all" $WPUSER
done

echo
 
exit 0
