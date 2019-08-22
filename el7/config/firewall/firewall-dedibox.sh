#!/bin/sh
#
# firewall-dedibox.sh

IPT=/usr/sbin/iptables
MOD=/usr/sbin/modprobe
SERVICE=/usr/sbin/service

# Internet
IFACE_INET=eth0

# Tout accepter
$IPT -t filter -P INPUT ACCEPT
$IPT -t filter -P FORWARD ACCEPT
$IPT -t filter -P OUTPUT ACCEPT
$IPT -t nat -P PREROUTING ACCEPT
$IPT -t nat -P POSTROUTING ACCEPT
$IPT -t nat -P OUTPUT ACCEPT
$IPT -t mangle -P PREROUTING ACCEPT
$IPT -t mangle -P INPUT ACCEPT
$IPT -t mangle -P FORWARD ACCEPT
$IPT -t mangle -P OUTPUT ACCEPT
$IPT -t mangle -P POSTROUTING ACCEPT

# Remettre les compteurs à zéro
$IPT -t filter -Z
$IPT -t nat -Z
$IPT -t mangle -Z

# Supprimer toutes les règles actives et les chaînes personnalisées
$IPT -t filter -F
$IPT -t filter -X
$IPT -t nat -F
$IPT -t nat -X
$IPT -t mangle -F
$IPT -t mangle -X

# Politique par défaut
$IPT -P INPUT DROP
$IPT -P FORWARD DROP
$IPT -P OUTPUT ACCEPT

# Faire confiance à nous-mêmes ;o)
$IPT -A INPUT -i lo -j ACCEPT

# Ping
$IPT -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
$IPT -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
$IPT -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT

# Connexions établies
$IPT -A INPUT -m state --state ESTABLISHED -j ACCEPT

# SSH illimité pour Microlinux
$IPT -A INPUT -p tcp -s 78.197.22.147 -i $IFACE_INET --dport 22 -j ACCEPT

# SSH limité
$IPT -A INPUT -p tcp -i $IFACE_INET --dport 22 -m state --state NEW \
  -m recent --set --name SSH
$IPT -A INPUT -p tcp -i $IFACE_INET --dport 22 -m state --state NEW \
  -m recent --update --seconds 300 --hitcount 2 --rttl --name SSH -j DROP
$IPT -A INPUT -p tcp -i $IFACE_INET --dport 22 -j ACCEPT

# Enregistrer les connexions refusées
$IPT -A INPUT -m limit --limit 2/min -j LOG \
  --log-prefix "+++ IPv4 packet rejected +++ "
$IPT -A INPUT -j DROP

# Enregistrer la configuration
$SERVICE iptables save
