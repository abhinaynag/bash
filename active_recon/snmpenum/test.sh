#!/bin/bash

for str in $(cat workingcs.txt); do
echo -e "$str\n=============="
	for target in $(cat targets.txt); do
		snmpwalk -c $str -v1 $target 1.3.6.1.4.1.77.1.2.25 >> tmp.txt
	done
done
