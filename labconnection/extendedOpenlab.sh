#!/bin/bash
function get_process()
{
	echo "$(ps -eo pid,cmd | grep "openvpn lab-connection" | cut -s -d '.' -f1 | cut -d ' ' -f1)"
}

function create_conn()
{
	cd /root/Downloads/lab-connection/
	openvpn lab-connection.conf > oltmp &
	
	echo "waiting 10 seconds for connection to load"
	sleep 10
}

function check_conn()
{
	echo "$(cat oltmp | grep "Initialization Sequence Completed" | awk '{print $6 $7 $8}')"
}

function get_ipdata()
{
	echo $(ifconfig tap0 | grep "inet addr")
	
}

function get_subnet()
{
	range=$(ifconfig tap0 | grep "inet addr" | cut -d ":" -f2 | cut -d ' ' -f1 | cut -d '.' -f3)
	sn=$(($range+1))
	echo "$sn"
}

function get_avg_ping()
{
	echo "$(ping -c 6 192.168.$1.220 | grep "rtt" | cut -d "=" -f2| cut -d "/" -f2)"
}

function open_cp()
{
	
		$(iceweasel https://10.70.70.70/oscpanel/labcpanel.php?md=0c36752fb305d0ad97b2106b579519ae\&pid=178945\&servers=0)&
}

function open_rdp()
{
	rdesktop -u offsec -p Gmw700rsWKF 192.168.43.113 &
}

function init_sequence()
{
		echo ; echo "Connected succesfully" ; echo ; echo
		
		echo "ip data" ; echo
		get_ipdata
		
		subnet=$(get_subnet)
		echo ; echo		

		echo "generating ping statistics..."
		avg_ping_time= $(get_avg_ping $subnet)
		echo "average ping time : $avg_ping_time" ; echo 
		
		read -p "opening control panel in iceweasel. Revert the windows 7 machine at 192.168.43.113 if required. press any key to continue"
		open_cp
		read -p "and press any key when ready"

		echo "opening RDP to windows 7 machine at 192.168.43.113"
		open_rdp

}

# main process

clear
process=$(get_process)

if [ -z "$process" ]; then

	create_conn
	check=$(check_conn)
	
	if [ $check == "InitializationSequenceCompleted" ]; then
		init_sequence
	else 
		t2=$(get_process)
		if [ -z "$t2" ]; then
			echo " waiting another 10 seconds "
			sleep 10
			c2=$(check_conn)
			if [ $c2 == "InitializationSequenceCompleted" ]; then
				init_sequence
			else 
				echo "Connection failed"
			fi
		else 
			c3=$(check_conn)
			if [ $c3 == "InitializationSequenceCompleted" ]; then
				init_sequence
			else
				echo " unable to verify connection. closing exiting processes "
				$(./closelab.sh)
			fi	
		fi		
	fi
else
	echo "Connection already open and running with pid: " $process
	
fi



