# source.sh
#
# Opérations communes à tous les scripts de ce répertoire

# Exécuter en tant que root
if [ $EUID -ne 0 ] ; then
  echo "::"
  echo ":: Vous devez être root pour exécuter ce script."
  echo "::"
  exit 1
fi

# Répertoire courant
CWD=$(pwd)

# Interrompre en cas d'erreur
set -e

# Téléchargement
ELREPO="http://mirrors.ircam.fr/pub/elrepo/elrepo/el7/x86_64/RPMS/"
MICROLINUX="https://www.microlinux.fr/download"
NUX="http://li.nux.ro/download/nux/dextop/el7/x86_64"
RECOLL="https://www.lesbonscomptes.com/recoll/downloads/centos71"
ORACLE="https://www.virtualbox.org/download"

# Couleurs
VERT="\033[01;32m"
GRIS="\033[00m"

# Pause entre les opérations
DELAY=1

# Afficher [OK] en cas de succès
function ok () {
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
}

# Journal
LOG=/tmp/$(basename "$0" .sh).log

# Nettoyer le fichier journal
echo > $LOG

