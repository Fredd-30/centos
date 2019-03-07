#!/bin/bash
#
# 00-restaurer-profil.sh
#
# Nicolas Kovacs, 2019
#
# Ce script installe une configuration personnalisée du bureau KDE pour tous
# les utilisateurs du système.

if [ ! -d /etc/skel/.config ]; then
  echo
  echo ":: Les profils par défaut ne sont pas installés."
  echo
  exit 1
fi

echo

for UTILISATEUR in $(ls /home); do
  echo ":: Mise à jour du profil de l'utilisateur $UTILISATEUR."
  rm -rf /home/$UTILISATEUR/.config/
  cp -R /etc/skel/.config/ /home/$UTILISATEUR/
  chown -R $UTILISATEUR:$UTILISATEUR /home/$UTILISATEUR/.config
done

echo
exit 0
