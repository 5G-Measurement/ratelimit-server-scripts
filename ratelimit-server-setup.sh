#!/bin/bash

## COMMANDS ON SERVER

# set the timezone
sudo timedatectl set-timezone America/Chicago

# install dependencies for experiments
sudo yum install -y nano
sudo yum install -y gcc
sudo yum install -y python
sudo yum install -y screen
sudo yum install -y git
sudo yum install -y libtool
sudo yum install -y make
sudo rum install -y gcc-c++

# install iperf3.9
mkdir scratch
cd scratch/
wget https://github.com/esnet/iperf/archive/3.9.tar.gz
tar -xvf 3.9.tar.gz 
cd iperf-3.9/
sudo ./bootstrap.sh 
sudo ./configure 
sudo make
sudo make install
cd ~

# set congestion control algorithm to cubic (for sanity)
sudo sysctl -w net.ipv4.tcp_congestion_control=cubic

# get faketcp binary
git clone https://github.com/ahmadhassan997/rawtcp-udp.git
