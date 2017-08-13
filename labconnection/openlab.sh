#!/bin/bash

clear
process=$(ps -eo pid,cmd | grep "openvpn lab-connection" | cut -s -d '.' -f1 | cut -d ' ' -f1)

if [ -z "$process" ]; then

	cd /root/Downloads/lab-connection/
	openvpn lab-connection.conf > oltmp &
	
	echo "waiting 10 seconds for connection to load"
	sleep 10
	
	check=$(cat oltmp | grep "Initialization Sequence Completed" | awk '{print $6 $7 $8}')
	
	if [ $check == "InitializationSequenceCompleted" ]; then
		echo 
		echo "Connected succesfully"
		echo
		echo "ip data"
		echo $(ifconfig tap0 | grep "inet addr")
		range=$(ifconfig tap0 | grep "inet addr" | cut -d ":" -f2 | cut -d ' ' -f1 | cut -d '.' -f3)
		subnet=$(($range+1))
		echo		
		echo "generating ping statistics..."
		echo "average ping time : $(ping -c 6 192.168.$subnet.220 | grep "rtt" | cut -d "=" -f2| cut -d "/" -f2)"
		
		#echo "opening connection to windows 7 machine at 192.168.43.113"
		#rdesktop -u offsec -p Gmw700rsWKF 192.168.43.113 &
	else 
		echo "Connection failed"
	fi
else
	echo "Connection already open and running with pid: " $process
	
fi


