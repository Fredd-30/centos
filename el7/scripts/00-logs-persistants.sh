#!/bin/bash
#
# 00-logs-persistants.sh
#
# Nicolas Kovacs, 2019
#
# Ce script rend les journaux du système persistants.

. source.sh

# Logs persistants
if [ ! -d /etc/systemd/journald.conf.d ]; then
  echo
  echo -e ":: Activation des logs persistants... \c"
  sleep $DELAY
  mkdir /etc/systemd/journald.conf.d
  cat $CWD/../config/journald/custom.conf > \
    /etc/systemd/journald.conf.d/custom.conf
  ok
fi

echo

exit 0
