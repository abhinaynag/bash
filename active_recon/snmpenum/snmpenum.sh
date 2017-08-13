#!/bin/bash
filedir="/root/Desktop/scripts/active_recon/snmpenum"
nmap -u -p 161 192.168.43.200-254 -oG $filedir/tmp.txt --append-output
grep -e "open" -e "filter" $filedir/tmp.txt | cut -d " " -f2 | sort -u > $filedir/targets.txt
onesixtyone -c $filedir/communitystrings.txt -i $filedir/targets.txt -o $filedir/onesixtyone.txt
cut -d '[' -f2 $filedir/onesixtyone.txt | cut -d ']' -f1 | sort -u > $filedir/workingcs.txt

for str in $(cat $filedir/workingcs.txt); do
echo -e "$str\n=============="
	for target in $(cat $filedir/targets.txt); do
		snmpwalk -c $str -v1 $target 1.3.6.1.4.1.77.1.2.25 | tee tmp.txt
	done
done
 

