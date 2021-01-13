#!/bin/bash

#author: Rostand
#date: December 21, 2019
#
#modified: January 11, 2021
#NOTE: If NOT in a screen session, this script will start a screen session and run this code in that screen
#
#Description:
#	--> If port is specified
#		Check if iperf3.9 is install. Exit if not installed
#		++ If port is NOT available
#			1. #TODO: Check and kill all other Detached screen sessions
#			2. Check and ask user for action to kill iperf3 running on specified port
#			3. Start iperf3 server session on specified port
#		++ If port is available
#			1. #TODO: Check and kill all other Detached screen sessions
#			2. Start iperf3 server session on specified port
#	--> If port is NOT specified
#		++ If default port 5201 is NOT available
#			1. #TODO: Check and kill all other Detached screen sessions
#			2. Check and ask user for action to kill iperf3 running on default port 5201
#			3. Start iperf3 server session on default port 5201
#		++ If default port is available
#			1. #TODO: Check and kill all other Detached screen sessions
#			2. Start iperf3 server session on default port port
#RUN:
#	1. chmod u+x {}
#	2. ./{}

# Function to check if port is open
isPortOpen()
{
	if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null ; then
		running='yes'
	else
		running='no'
	fi
}


# Function to kill port
killPort()
{
	pid=$(lsof -i:$1 -t)
	kill -9 $pid
}


# Function to check if iperf3/ folder exist and create it if not
outputFolder()
{
	dir='iperf3logs/'
	if [[ ! -e $dir ]]; then
		mkdir $dir
		echo "Directory created: $dir"
	fi
}


# Function to check if iperf3.9 is installed
isIperfInstall()
{
	if ! [ -x "$(type -P iperf3)" ]; then
		echo "ERROR: script requires iperf3.9"
		echo "Please install iperf3.9"
		exit 1
	fi
}


# echo port number is "$port"
# Function to prepare output file and folder
outputFile()
{
	# Get current time and date
	now=$(date '+%d-%m-%Y-%H:%M:%S')

	# Prepare output folder
	outputFolder

	dash="_"
	outFileName="${dir}${host}${dash}${now}.json"
}

# Check if iperf3.9 is installed
isIperfInstall

# Get hostname of machine
host="$HOSTNAME"

# Prepare outputFile/Folder
outputFile


echo Output File "$outFileName"

#echo "============================================"
#echo "this works"
#echo "============================================"


# Check if port is specified and act accordingly
if [ "$1" ]; then
	
	# Check if default port 5201 is open and run iperf, else close it and run
	echo "checking if port # $1 is open"
	isPortOpen $1
	if [ "$running" =  yes ]; then
		#TODO: 1. check and kill all other detached screen sessions	
		
		#2. Ask the user what to do with open port 
		echo "----------------> Port # $1 is currently being used <----------------"
		read -p "Close this port and start iperf server listener on this port. 'Y' or 'N': " input
	
		# Error checking for user input
		while [[ $input =~ ^[+-]?[0-9]+$ ]] || [[ $input =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] || [ ${#input} -ge 2 ] ; do
			echo "************ Invalid input, please enter (Y/N) ************"
			read -p "Close this port and start iperf server listener on this port. 'Y' or 'N': " input
		done
		
		# User entered valid input ---> continue
		if [ "$input" = y ] || [ "$input" = Y ]; then
			# Closing iperf running on specified port number
			killPort $1
			
			# Running iperf normally
			echo "Running iperf3 on $1"	
      			sudo /usr/local/bin/iperf3 -s -p "$1" -i 1 -J --logfile "$outFileName" 2> /dev/null
      			wait
		elif [ "$input" = n ] || [ "$input" = N ]; then
			echo "exiting..."	
			echo "~~~~~~~~~~~~~~~~ Close the port and re-run or specify different port number ~~~~~~~~~~~~~~~"
			exit 1
		fi
	elif [ "$running" = no ]; then
		# Running iperf normally on specified port number
		echo "Running iperf3 on $1"	
    		sudo /usr/local/bin/iperf3 -s -p "$1" -i 1 -J --logfile "$outFileName" 2> /dev/null
    		wait
	fi
else
	# Check if default port 5201 is open and run iperf, else close it and run
	echo "checking if default port '#' 5201 is open"
	isPortOpen 5201
	if [ "$running" = no ]; then
		echo "Running iperf3 on default port 5201"
    		sudo /usr/local/bin/iperf3 -s -i 1 -J --logfile "$outFileName" 2> /dev/null
    		wait
	elif [ "$running" = yes ]; then
		
		#2. Ask the user what to do with open port 
		echo "----------------> Port # 5201 is currently being used <----------------"
		read -p "Close this port and start iperf server listener on this port. 'Y' or 'N': " input
		
		# Error checking for user input
		while [[ $input =~ ^[+-]?[0-9]+$ ]] || [[ $input =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] || [ ${#input} -ge 2 ] ; do
			echo "************ Invalid input, please enter (Y/N) ************"
			read -p "Close this port and start iperf server listener on this port. 'Y' or 'N': " input
		done

		# User entered valid input ---> continue
		if [ "$input" = y ] || [ "$input" = Y ]; then
			# Closing iperf running on defaul port number
			killPort 5201
			
			# Running iperf normally
			echo "Running iperf3 on default port number 5201"	
      			sudo /usr/local/bin/iperf3 -s -p 5201 -i 1 -J --logfile "$outFileName" 2> /dev/null
      			wait
		elif [ "$input" = n ] || [ "$input" = N ]; then
			echo "exiting..."	
			echo "~~~~~~~~~~~~~~~~ Close the port and re-run or specify different port number ~~~~~~~~~~~~~~~"
			exit 1
		fi
	fi
fi

