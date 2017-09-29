#!/bin/bash

HOSTNAME=$1
LICENSE=$2

#delete azcesd if exists
if [ -n "$(apt-cache search azure-security)" ]; then
    apt-get purge -y azure-security
fi

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
user activate apic

config commit
config sync

EOF

chmod +x ./ptaf_api_settings.py
./ptaf_api_settings.py

/usr/local/bin/wsc -e <<EOF

user deactivate apic
config sync

EOF

if [ -n "${LICENSE}" ]; then
    curl -k "https://localhost:8443/license/get_config/?license_token=${LICENSE}"
fi