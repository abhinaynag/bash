#!/bin/bash
filedir="/root/Desktop/scripts/active_recon/netscan/"
selection=""
iprange="localhost"
while true
do
	clear
	echo "Scanning Main Menu"
	echo "=================="
	echo "1. TCP Scan"
	echo "2. Network Sweep"
	echo "3. Scan for 1 perticular port"
	echo "4. Scan for top 20 intersting ports"
	echo "5. OS discovery"
	echo "6. Service enumaration"
	echo "r. Read output file"
	echo "q. Quit program"
	echo -e "\n"

	read -p "Enter selection: " selection	
	if [[ $selection -ge 1 && $selection -le 6 ]]; then
		read -p "Enter IP range: " iprange
	fi	
	case $selection in 
	1) nmap -sT $iprange -oG $filedir/results.txt
	;;
	2) nmap -sn $iprange -oG $filedir/results.txt
	;;
	3)
		read -p "Enter port to scan: " port		 
		nmap -p $port $iprange -oG $filedir/results.txt
	;;
	4) namp -sn -sS --top-ports-20 $iprange -oG $filedir/results.txt
	;;
	5) nmap -sn -O $iprange
	;;
	6) nmap -sV $iprange
	;;
	r) clear
	   echo -e "\n Output stored in $filedir/results.txt\n\n"
	   more $filedir/results.txt
	;;	
	q) exit
	;;
esac
read -p "Press enter to continue" restart
done
