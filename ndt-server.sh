#!/bin/bash

# Check if screen is running, if not, run this script inside a screen
if [ -z "$STY" ]; then
  exec screen -S ndt /bin/bash "$0"
fi

# Get hostname of machine
host="$HOSTNAME"

# Function to check if iperf3/ folder exist and create it if not
outputFolder()
{
	dir='ndtlogs/'
	if [[ ! -e $dir ]]; then
		mkdir $dir
		echo "Directory created: $dir"
	fi
}
outputFolder

# Function to prepare output file and folder
outputFile()
{
	# Get current time and date
	now=$(date '+%d-%m-%Y-%H:%M:%S')

	dash="_"
	outFileName="${dir}${host}${dash}${now}.txt"
}
outputFile

# Run ndt-server container
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
                -ndt7_addr_cleartext :8080 > "$outFileName"
