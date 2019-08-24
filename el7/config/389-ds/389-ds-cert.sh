#!/bin/bash
#
# 389-ds-cert.sh
#
# Nicolas Kovacs, 2019
#
# Créer un certificat SSL auto-signé pour 389 Directory Server.

HOST=$(hostname -s)

FQDN=$(hostname --fqdn)

openssl rand -out /tmp/noise.bin 4096

certutil -S -x -d /etc/dirsrv/slapd-${HOST} \
  -z /tmp/noise.bin \
  -n "server-cert" \
  -s "CN=${FQDN}" \
  -t "CT,C,C" \
  -m $RANDOM \
  -v 120 \
  --keyUsage digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment

echo

exit 0
