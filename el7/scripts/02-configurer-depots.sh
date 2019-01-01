#!/bin/bash
#
# 02-configurer-depots.sh
#
# Nicolas Kovacs, 2019
#
# Configuration des dépôts de paquets pour Yum

. source.sh

# Activer les dépôts [base], [updates] et [extras] avec une priorité de 1
echo 
echo -e ":: Configuration des dépôts de paquets officiels... \c"
sleep $DELAY
cat $CWD/../config/yum/CentOS-Base.repo > /etc/yum.repos.d/CentOS-Base.repo
sed -i -e 's/installonly_limit=5/installonly_limit=2/g' /etc/yum.conf
ok

# Activer le dépôt [cr] avec une priorité de 1
echo "::"
echo -e ":: Configuration du dépôt de paquets CR... \c"
sleep $DELAY
cat $CWD/../config/yum/CentOS-CR.repo > /etc/yum.repos.d/CentOS-CR.repo
ok

# Activer la gestion des Delta RPM
if ! rpm -q deltarpm 2>&1 > /dev/null ; then
  echo "::"
  echo -e ":: Activer la gestion des Delta RPM... \c"
  yum -y install deltarpm >> $LOG 2>&1
  ok
fi

# Mise à jour initiale
echo "::"
echo -e ":: Mise à jour initiale du système... \c"
yum -y update >> $LOG 2>&1
ok

# Installer le plugin Yum-Priorities
if ! rpm -q yum-plugin-priorities 2>&1 > /dev/null ; then
  echo "::"
  echo -e ":: Installation du plugin Yum-Priorities... \c"
  yum -y install yum-plugin-priorities >> $LOG 2>&1
  ok
fi

# Activer le dépôt [epel] avec une priorité de 10
if ! rpm -q epel-release 2>&1 > /dev/null ; then
  echo "::"
  echo -e ":: Configuration du dépôt de paquets EPEL... \c"
  rpm --import http://mirrors.ircam.fr/pub/fedora/epel/RPM-GPG-KEY-EPEL-7 >> $LOG 2>&1
  yum -y install epel-release >> $LOG 2>&1
  cat $CWD/../config/yum/epel.repo > /etc/yum.repos.d/epel.repo
  cat $CWD/../config/yum/epel-testing.repo > /etc/yum.repos.d/epel-testing.repo
  ok
fi

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

# Configurer les dépôts [elrepo], [elrepo-kernel] etc. sans les activer
if ! rpm -q elrepo-release 2>&1 > /dev/null ; then
  echo "::"
  echo -e ":: Configuration du dépôt de paquets ELRepo... \c"
  rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org >> $LOG 2>&1
  yum -y localinstall \
    $ELREPO/elrepo-release-7.0-3.el7.elrepo.noarch.rpm >> $LOG 2>&1
  cat $CWD/../config/yum/elrepo.repo > /etc/yum.repos.d/elrepo.repo
  ok
fi

# Configurer le dépôt [lynis] avec une priorité de 5
if [ ! -f /etc/yum.repos.d/lynis.repo ]; then
  echo "::"
  echo -e ":: Configuration du dépôt de paquets Lynis... \c"
  sleep $DELAY
  rpm --import https://packages.cisofy.com/keys/cisofy-software-rpms-public.key >> $LOG 2>&1
  cat $CWD/../config/yum/lynis.repo > /etc/yum.repos.d/lynis.repo
  ok
fi

echo

exit 0
