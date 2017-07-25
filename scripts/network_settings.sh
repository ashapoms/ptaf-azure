#!/bin/bash

HASPLM_CONFIG=/etc/hasplm/hasplm.ini
HOSTNAME=$1
MONGOD_CONFIG=/etc/mongod.conf

#delete azcesd if exists
if [ -n "$(apt-cache search azure-security)" ]; then
    apt-get purge -y azure-security
fi


sed -i "s/bind_ip = kickstat,127.0.0.1/bind_ip = ${HOSTNAME},127.0.0.1/g" "${MONGOD_CONFIG}"
monit -I restart mongod


cat <<EOF > "${HASPLM_CONFIG}" 
[REMOTE]
broadcastsearch = 1
aggressive = 1
serversearchinterval = 30
serveraddr = ptaf-license.ptsecurity.com
EOF

service aksusbd restart

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

echo 'db.gateways.update({"active": false}, {$set:{"active": true})' \
    | mongo waf -u root -p $(wsc -c "password list") --authenticationDatabase admin
