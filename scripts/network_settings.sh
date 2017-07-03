#!/bin/bash

#delete azcesd if exists
SEARCH=$(apt-cache search azure-security)
if [ -n "$SEARCH" ]; then
    apt-get purge -y azure-security
fi

HASPLM_CONFIG=/etc/hasplm/hasplm.ini
HOSTNAME=$1

cat <<EOF > "${HASPLM_CONFIG}" 
[REMOTE]
broadcastsearch = 1
aggressive = 1
serversearchinterval = 30
serveraddr = ptaf-license.ptsecurity.com
EOF


/usr/local/bin/wsc -e <<EOF

host add 127.0.1.1 $HOSTNAME
hostname $HOSTNAME

if mode eth0 dhcp
if mode eth1 dhcp

if mark eth0
if mark eth1
if mark lo:0

feature set azure_byol true
integration_mode reverse_proxy

config commit
config sync

EOF
