#!/bin/bash
filedir="/root/Desktop/scripts/active_recon/dnsenum/zone_transfer/"
dom=$1
if [ -z $dom ]; then 
	read -p "enter a domain name: " dom
fi
for ns in $(host -t ns $dom | cut -d  ' ' -f4); do
host -l $dom $ns | grep "has address" | tee -a $filedir/results.txt
done

