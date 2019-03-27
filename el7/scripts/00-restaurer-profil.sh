#!/bin/bash
#
# 00-restaurer-profil.sh
#
# Nicolas Kovacs, 2019
#
# Ce script installe une configuration personnalisée du bureau KDE pour tous
# les utilisateurs du système.

if [ ! -d /etc/skel/.kde ]; then
  echo
  echo ":: Les profils par défaut ne sont pas installés."
  echo
  exit 1
fi

echo

for UTILISATEUR in $(ls /home); do
  echo ":: Mise à jour du profil de l'utilisateur $UTILISATEUR."
  rm -rf /home/$UTILISATEUR/.kde/
  rm -rf /home/$UTILISATEUR/.local/
  rm -rf /home/$UTILISATEUR/.winff/
  rm -f /home/$UTILISATEUR/.gtkcdlabelrc
  cp -R /etc/skel/.kde/ /home/$UTILISATEUR/
  cp -R /etc/skel/.local/ /home/$UTILISATEUR/
  cp -R /etc/skel/.winff/ /home/$UTILISATEUR/
  cp /etc/skel/.gtkcdlabelrc /home/$UTILISATEUR/
  chown -R $UTILISATEUR:$UTILISATEUR /home/$UTILISATEUR/.kde
  chown -R $UTILISATEUR:$UTILISATEUR /home/$UTILISATEUR/.local
  chown -R $UTILISATEUR:$UTILISATEUR /home/$UTILISATEUR/.winff
  chown $UTILISATEUR:$UTILISATEUR /home/$UTILISATEUR/.gtkcdlabelrc
done

echo
exit 0
