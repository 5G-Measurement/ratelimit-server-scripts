#!/bin/bash

## COMMANDS ON SERVER

# set the timezone
sudo timedatectl set-timezone America/Chicago

# install dependencies
sudo apt-get install -y build-essential
sudo apt-get install -y git
sudo apt-get install -y iftop
sudo apt-get install -y net-tools
sudo apt-get install -y iperf3

# set congestion control algorithm to cubic (for sanity)
sudo sysctl -w net.ipv4.tcp_congestion_control=cubic

# get faketcp binary
git clone https://github.com/ahmadhassan997/rawtcp-udp.git
