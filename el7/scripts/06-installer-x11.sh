#!/bin/bash
#
# 06-installer-x11.sh
#
# Nicolas Kovacs, 2019
#
# Installation du système X Window et du gestionnaire de fenêtres WindowMaker

. source.sh

# Adaptation des options de démarrage
echo 
echo -e ":: Adaptation des options de démarrage... \c"
sleep $DELAY
sed -i -e 's/nomodeset quiet vga=791/quiet/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg >> $LOG 2>&1
ok

# Installer X11
echo "::"
echo -e ":: Installation du système X Window... \c"
yum -y group install "X Window System" >> $LOG 2>&1
ok

# Installer WindowMaker
echo "::"
echo -e ":: Installation de WindowMaker... \c"
WMAKER=$(egrep -v '(^\#)|(^\s+$)' $CWD/../config/pkglists/windowmaker.txt)
yum -y install $WMAKER >> $LOG 2>&1
ok

# Configurer WindowMaker
echo "::"
echo -e ":: Configuration de WindowMaker... \c"
sleep $DELAY
cat $CWD/../config/xorg/xinitrc.windowmaker > /etc/skel/.xinitrc
cat $CWD/../config/xterm/Xresources > /etc/skel/.Xresources
if [ ! -z "$(ls -A /home)" ]; then
  for UTILISATEUR in $(ls /home); do
    cat $CWD/../config/xorg/xinitrc.windowmaker > /home/$UTILISATEUR/.xinitrc
    cat $CWD/../config/xterm/Xresources > /home/$UTILISATEUR/.Xresources
    chown $UTILISATEUR:$UTILISATEUR /home/$UTILISATEUR/.xinitrc
    chown $UTILISATEUR:$UTILISATEUR /home/$UTILISATEUR/.Xresources
  done
fi
ok

# Personnaliser GDM
if [ ! -f /etc/dconf/profile/gdm ]; then
  echo "::"
  echo -e ":: Personnalisation de GDM... \c"
  if [ ! -d /etc/dconf/db/gdm.d ] ; then
    mkdir /etc/dconf/db/gdm.d
  fi
  cat $CWD/../config/gdm/gdm > /etc/dconf/profile/gdm
  cat $CWD/../config/gdm/00-login-screen > /etc/dconf/db/gdm.d/00-login-screen
  cat $CWD/../config/gdm/01-logo > /etc/dconf/db/gdm.d/01-logo
  cp $CWD/../config/gdm/microlinux-logo.png /usr/share/pixmaps/ >> $LOG 2>&1
  dconf update
  ok
fi

# Configurer l'affichage en temps réel
echo "::"
echo -e ":: Configuration de l'affichage en temps réel... \c"
sleep $DELAY
cat $CWD/../config/sysctl.d/inotify.conf > /etc/sysctl.d/inotify.conf
ok

# Passer le système en français
echo "::"
echo -e ":: Passer le système en français... \c"
sleep $DELAY
localectl set-locale LANG=fr_FR.UTF8
ok

echo

exit 0
