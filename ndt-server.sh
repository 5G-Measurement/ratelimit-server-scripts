#!/bin/bash

## Run ndt-server container
cd
cd ndt-server
sudo docker run --network=bridge                \
                --publish 443:4443              \
                --publish 80:8080               \
                --volume `pwd`/certs:/certs:ro  \
                --volume `pwd`/datadir:/datadir \
                --read-only                     \
                --user `id -u`:`id -g`          \
                --cap-drop=all                  \
                ndt-server                      \
                -cert /certs/cert.pem           \
                -key /certs/key.pem             \
                -datadir /datadir               \
                -ndt7_addr :4443                \
                -ndt7_addr_cleartext :8080