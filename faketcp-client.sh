#!/bin/bash

# /sdcard/5GTracker/Config/hostnames.csv

## check if server name given 
if [ "$1" ]; then
    filename=/sdcard/5GTracker/Config/hostnames.csv
    IP_ADDR=$(awk -F',' -v var="$1" '{ if ($1 == var) { print $2 } }' $filename)
    if [[ $IP_ADDR =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "connecting to server on: $IP_ADDR"
        sudo ./faketcp_arm -c -r $IP_ADDR:5201 --fix-gro --pkt-len 10 -a --raw-mode faketcp
    else
        echo "invalid ip address"
    fi
else
    echo "give server name as argument.."
fi