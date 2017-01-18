#!/bin/bash

IP=$(ifconfig eth0 | grep 'inet addr' | xargs | awk -F '[: ]' '{{print $3}}')
HOSTNAME=$(hostname)

echo -e '127.0.0.1 localhost' > /etc/hosts
echo -e $IP $HOSTNAME >> /etc/hosts
