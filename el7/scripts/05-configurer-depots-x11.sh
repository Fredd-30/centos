#!/bin/bash
#
# 05-configurer-depots-x11.sh
#
# Nicolas Kovacs, 2019
#
# Configuration des dépôts de paquets supplémentaires pour Yum

. source.sh

# Désactiver le dépôt [cr]
echo 
echo -e ":: Désactivation du dépôt de paquets CR... \c"
sleep $DELAY
sed -i -e 's/enabled=1/enabled=0/g' /etc/yum.repos.d/CentOS-CR.repo
ok

# Activer le dépôt [nux-dextop] avec une priorité de 10
if ! rpm -q nux-dextop-release 2>&1 > /dev/null ; then
  echo "::"
  echo -e ":: Configuration du dépôt de paquets Nux-Dextop... \c"
  yum -y localinstall \
    $NUX/nux-dextop-release-0-5.el7.nux.noarch.rpm >> $LOG 2>&1
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-nux.ro >> $LOG 2>&1
  cat $CWD/../config/yum/nux-dextop.repo > /etc/yum.repos.d/nux-dextop.repo
  ok
fi

# Activer le dépôt [adobe-linux-x86_64] avec une priorité de 10
if ! rpm -q adobe-release-x86_64 2>&1 > /dev/null ; then
  echo "::"
  echo -e ":: Configuration du dépôt de paquets Adobe... \c"
  yum -y localinstall $CWD/../config/yum/adobe-release-*.rpm >> $LOG 2>&1
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux >> $LOG 2>&1
  cat $CWD/../config/yum/adobe-linux-x86_64.repo > /etc/yum.repos.d/adobe-linux-x86_64.repo
  ok
fi

echo

exit 0
