#!/bin/bash
process=$(ps -eo pid,cmd | grep "openvpn" | cut -s -d '-' -f1 | cut -d ' ' -f1)
if [ -z "$process" ]; then 
	$(read -p "session closed. press any key to exit")
else
	$(kill -9 $process)
	if [ $? == 0 ];then $(read -p "session closed sucessfully press any key to exit ");else $(read -p "try manually");fi
fi 

