#!/bin/bash

# get local ip
LOCAL_IP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
if [[ $IP_ADDR =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # start server
    sudo ./rawtcp-udp/faketcp -s -l $LOCAL_IP:5201 --fix-gro --pkt-len 1420 -a --raw-mode faketcp
else
    echo "couldn't get the local ip"
fi