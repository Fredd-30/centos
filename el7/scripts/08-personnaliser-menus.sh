#!/bin/bash
# 
# 08-personnaliser-menus.sh
#
# Nicolas Kovacs, 2019
#
# Personnaliser les entrées de menu du bureau KDE

CWD=$(pwd)
ENTRIESDIR=$CWD/../config/menus
ENTRIES=`ls $ENTRIESDIR`
MENUDIRS="/usr/share/applications\
          /usr/share/applications/kde4"

echo

for MENUDIR in $MENUDIRS; do
  for ENTRY in $ENTRIES; do
    if [ -r $MENUDIR/$ENTRY ]; then
      echo ":: Configuration de l'entrée de menu $ENTRY."
      cat $ENTRIESDIR/$ENTRY > $MENUDIR/$ENTRY
    fi
  done
done

# L'entrée de menu pour OpenJDK est une cible mouvante
OPENJDK=$(find /usr/share/applications -name 'java*openjdk*.desktop')
if [ ! -z "$OPENJDK" ]; then
  if ! grep -q "NoDisplay" "$OPENJDK" ; then
    echo "NoDisplay=true" >> $OPENJDK
    echo ":: Configuration de l'entrée de menu $(basename $OPENJDK)."
  fi
fi

echo 

exit 0

