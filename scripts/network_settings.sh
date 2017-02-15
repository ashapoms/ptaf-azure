#!/bin/bash

#delete azcesd if exists
SEARCH=$(apt-cache search azure-security)
if [ -n "$SEARCH" ]; then
    apt-get purge -y azure-security
fi

HOSTNAME=$1
IP=$(ifconfig eth0 | grep 'inet addr' | xargs | awk -F '[: ]' '{{print $3}}')

echo -e $HOSTNAME > /etc/hostname
echo -e '127.0.0.1 localhost' > /etc/hosts
echo -e $IP $HOSTNAME >> /etc/hosts
/etc/init.d/hostname.sh
