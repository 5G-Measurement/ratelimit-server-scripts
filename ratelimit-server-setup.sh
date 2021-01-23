#!/bin/bash

## COMMANDS ON SERVER

# set the timezone
sudo timedatectl set-timezone America/Chicago

# install dependencies for experiments
sudo yum install -y wget
sudo yum install -y lsof
sudo yum install -y epel-release
sudo yum install -y gcc
sudo yum install -y screen
sudo yum install -y gcc-c++
sudo yum install -y make
sudo yum install -y libtool

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

# give permissions to execute
cd ratelimit-server-scripts
sudo chmod u+x iperf-short-server.sh
sudo chmod u+x iperf-long-server.sh
sudo chmod u+x ndt-server.sh
sudo chmod u+x faketcp-server.sh

# run iperf server
screen -S iperf -d -m ./iperf-short-server.sh
# screen -S iperf -d -m iperf3 -s -p 5201 -V