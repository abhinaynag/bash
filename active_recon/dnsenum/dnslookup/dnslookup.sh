#!/bin/bash
dom=$1
start=$2
end=$3
filedir="/root/Desktop/scripts/active_recon/dnsenum/dnslookup/"
if [ -z $dom ]; then read -p "Enter domain to scan: " dom ; fi
echo "Processing..." 
for i in $(cat $filedir/domain_types.txt); do
	host $i.$dom | grep "has address" | cut -d' ' -f1,4 | tee -a tmp
done
ip=$(cut -d' ' -f2 tmp | cut -d'.' -f1,2,3 | sort -u)
echo $ip	
if [ -z $start ]; then read -p "Enter the start of /24 range: " start ; fi
if [ -z $end ]; then read -p "Enter the end of /24 range: " end ; fi

for i in $(seq $start $end); do 
	host $ip.$i | grep $1 | cut -d' ' -f1,5 | tee -a $filedir/results.txt
done

echo "Results stored in $filedir/results.txt"	

