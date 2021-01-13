#!/bin/bash

## Install docker [ubuntu]
# sudo apt-get update
# sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo apt-key fingerprint 0EBFCD88
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# sudo apt-get update
# sudo apt-get install docker-ce docker-ce-cli containerd.io

## Install docker [centOS]
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker

## Setup ndt-7 server
git clone https://github.com/m-lab/ndt-server.git
cd ndt-server
install -d certs datadir
./gen_local_test_certs.bash
sudo docker build . -t ndt-server

## Load tcp bbr kernel module
sudo modprobe tcp_bbr
