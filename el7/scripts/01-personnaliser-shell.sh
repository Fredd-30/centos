#!/bin/bash
#
# 01-personnaliser-shell.sh
#
# Nicolas Kovacs, 2019
#
# Personnalisation du shell pour root et les utilisateurs

. source.sh

# Personnalisation du shell Bash pour root
echo
echo -e ":: Configuration du shell Bash pour l'administrateur... \c"
sleep $DELAY
cat $CWD/../config/bash/bashrc-root > /root/.bashrc
ok

# Personnalisation du shell Bash pour les utilisateurs
echo "::"
echo -e ":: Configuration du shell Bash pour les utilisateurs... \c"
sleep $DELAY
cat $CWD/../config/bash/bashrc-users > /etc/skel/.bashrc
if [ ! -z "$(ls -A /home)" ]; then
  for UTILISATEUR in $(ls /home); do
    if [ $UTILISATEUR != 'lost+found' ] ; then
      cat $CWD/../config/bash/bashrc-users > /home/$UTILISATEUR/.bashrc
      chown $UTILISATEUR:$UTILISATEUR /home/$UTILISATEUR/.bashrc
    fi
  done
fi
ok

# Quelques options pratiques pour Vim
echo "::"
echo -e ":: Configuration de Vim... \c"
sleep $DELAY
cat $CWD/../config/vim/vimrc > /etc/vimrc
ok

# Passer le système en anglais
echo "::"
echo -e ":: Passer le système en anglais... \c"
sleep $DELAY
localectl set-locale LANG=en_US.UTF8
ok

# Configuration de l'affichage de la console
if [ -f /boot/grub2/grub.cfg ]; then
  echo "::"
  echo -e ":: Configuration de l'affichage de la console... \c"
  sleep $DELAY
  sed -i -e 's/rhgb quiet/nomodeset quiet vga=791/g' /etc/default/grub
  grub2-mkconfig -o /boot/grub2/grub.cfg >> $LOG 2>&1
  ok
fi

echo

exit 0
