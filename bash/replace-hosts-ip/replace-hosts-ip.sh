#! /bin/bash

HOST=$1
IP=$2
sed -i "/$HOST/ s/.*/$IP\t$HOST/g" /etc/hosts
