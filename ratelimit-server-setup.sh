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

## Install docker and start it
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker

# clone raw tcp
git clone https://github.com/ahmadhassan997/rawtcp-udp.git

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
cd ~/ratelimit-server-scripts

## Setup ndt-7 server
git clone https://github.com/m-lab/ndt-server.git
cd ndt-server
install -d certs datadir
./gen_local_test_certs.bash
sudo docker build . -t ndt-server

## Load tcp bbr kernel module
sudo modprobe tcp_bbr

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

# give permissions to execute
chmod u+x iperf-server.sh
chmod u+x ndt-server.sh
chmod u+x faketcp-server.sh