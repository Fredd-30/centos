#!/bin/bash
#
# 07-installer-kde.sh
#
# Nicolas Kovacs, 2019
#
# Installation de l'environnement de bureau KDE

. source.sh

# Installer le bureau KDE et les applications
echo 
echo -e ":: Installation du bureau KDE et des applications... \c"
KDE=$(egrep -v '(^\#)|(^\s+$)' $CWD/../config/pkglists/kde.txt)
yum -y install $KDE >> $LOG 2>&1
ok

# Installer Recoll
if ! rpm -q recoll 2>&1 > /dev/null ; then
  echo "::"
  echo -e ":: Installation de l'application Recoll... \c"
  yum -y localinstall $RECOLL/recoll-1.21.5-1.el7.centos.x86_64.rpm >> $LOG 2>&1
  ok
fi

# Installer Gtkcdlabel
if [ ! -f /usr/bin/gtkcdlabel.py ]; then
  echo "::"
  echo -e ":: Installation de l'application Gtkcdlabel... \c"
  cd /tmp
  wget -c --no-check-certificate $MICROLINUX/gtkcdlabel-1.15.tar.bz2 >> $LOG 2>&1
  tar xvjf gtkcdlabel-1.15.tar.bz2 -C / >> $LOG 2>&1
  rm -f gtkcdlabel-1.15.tar.bz2
  cd - >> $LOG 2>&1
  ok
fi

# Installer Normalize 
if [ ! -f /usr/local/bin/normalize ]; then
  echo "::"
  echo -e ":: Installation de l'outil de normalisation audio... \c"
  pushd /usr/src >> $LOG 2>&1
  wget -c --no-check-certificate $MICROLINUX/normalize-0.7.7.tar.gz >> $LOG 2>&1
  tar xvzf normalize-0.7.7.tar.gz >> $LOG 2>&1
  find normalize-0.7.7 -type d -exec chmod 0755 {} \;
  pushd normalize-0.7.7 >> $LOG 2>&1
  ./configure >> $LOG 2>&1
  make >> $LOG 2>&1
  make install >> $LOG 2>&1
  popd >> $LOG 2>&1
  rm -f normalize-0.7.7.tar.gz
  popd >> $LOG 2>&1
  ok
fi

# Installer les polices Apple
if [ ! -d /usr/share/fonts/apple-fonts ]; then
  cd /tmp
  rm -rf /usr/share/fonts/apple-fonts
  echo "::"
  echo -e ":: Installation des polices TrueType Apple... \c"
  wget -c --no-check-certificate $MICROLINUX/FontApple.tar.xz >> $LOG 2>&1
  mkdir /usr/share/fonts/apple-fonts
  tar xvf FontApple.tar.xz >> $LOG 2>&1
  mv Lucida*.ttf Monaco.ttf /usr/share/fonts/apple-fonts/
  fc-cache -f -v >> $LOG 2>&1
  rm -f FontApple.tar.xz
  cd - >> $LOG 2>&1
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
fi

# Installer la police Eurostile
if [ ! -d /usr/share/fonts/eurostile ]; then
  cd /tmp
  rm -rf /usr/share/fonts/eurostile
  echo "::"
  echo -e ":: Installation de la police TrueType Eurostile... \c"
  wget -c --no-check-certificate $MICROLINUX/Eurostile.zip >> $LOG 2>&1
  unzip Eurostile.zip -d /usr/share/fonts/ >> $LOG 2>&1
  mv /usr/share/fonts/Eurostile /usr/share/fonts/eurostile
  fc-cache -f -v >> $LOG 2>&1
  rm -f Eurostile.zip
  cd - >> $LOG 2>&1
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
fi

# Installer les fonds d'écran Microlinux
if [ ! -f /usr/share/backgrounds/.microlinux ]; then
  cd /tmp
  echo "::"
  echo -e ":: Installation des fonds d'écran Microlinux... \c"
  wget -c --no-check-certificate $MICROLINUX/microlinux-wallpapers.tar.gz >> $LOG 2>&1
  tar xvzf microlinux-wallpapers.tar.gz >> $LOG 2>&1
  cp -f microlinux-wallpapers/* /usr/share/backgrounds/ >> $LOG 2>&1
  touch /usr/share/backgrounds/.microlinux >> $LOG 2>&1
  rm -f microlinux-wallpapers.tar.gz
  cd - >> $LOG 2>&1
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
fi

echo

exit 0
