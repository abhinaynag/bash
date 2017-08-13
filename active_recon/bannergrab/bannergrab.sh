#!/bin/bash
sloc="/usr/share/nmap/scripts/"
$filedir="/root/Desktop/scripts/active_recon/bannergrab"
flag=false;
while getopts ":f:" opt; do
	case $opt in
    f)
	for ip in $(cat $OPTARG); do
		echo $ip		
		nmap --script=$sloc/banner.nse,$sloc/smb-os-discovery.nse -oG $filedir/results.txt --append-output $ip&	
		flag=true	
	done
    ;;
    \?)
    	echo "Invalid option: -$OPTARG" >&2
     	exit 1
    ;;
    :)
    	echo "Option -$OPTARG requires an argument." >&2
    	exit 1
    ;;
  esac
done
if [ $flag = false ]; then
	subnet=$1
	if [ -z $subnet ]; then
		read -p "Enter host / subnet: " subnet
	fi
	nmap --script=$sloc/banner.nse,$sloc/smb-os-discovery.nse -oG $filedir/results.txt $subnet
fi





