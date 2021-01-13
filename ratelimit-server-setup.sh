#!/bin/bash

## COMMANDS ON SERVER

# set the timezone
sudo timedatectl set-timezone America/Chicago

# install dependencies for experiments
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

# Change socket buffer sizes
sudo sysctl -w net.core.rmem_default=31457280
sudo sysctl -w net.core.rmem_max=536870912
sudo sysctl -w net.core.wmem_default=31457280
sudo sysctl -w net.core.wmem_max=536870912
sudo sysctl -w net.ipv4.tcp_rmem='8192 16777216 536870912'
sudo sysctl -w net.ipv4.tcp_wmem='8192 16777216 536870912'
sudo sysctl -w net.ipv4.tcp_mem='786432 1048576 26777216'
sudo sysctl -w net.ipv4.udp_mem='65536 131072 262144'
sudo sysctl -w net.ipv4.udp_rmem_min=16384
sudo sysctl -w net.ipv4.udp_wmem_min=16384
