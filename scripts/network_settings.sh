#!/bin/bash

#delete azcesd if exists
SEARCH=$(apt-cache search azure-security)
if [ -n "$SEARCH" ]; then
    apt-get purge -y azure-security
fi

HOSTNAME=$1

/usr/local/bin/wsc <<EOF
output automation

if alias lo 0
if set lo:0 inet_address 192.168.40.40
if set lo:0 inet_netmask 255.255.255.255

host add 192.168.40.40 $HOSTNAME
hostname $HOSTNAME

if mode eth0 dhcp
if mode eth1 dhcp

if mark lo:0
if mark eth0
if mark eth1

config commit
config sync

EOF
