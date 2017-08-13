#!/bin/bash
sloc="/usr/share/nmap/scripts"
filedir="/root/Desktop/scripts/active_recon/smbenum/"
flag=false
rm $filedir/results.txt
touch $filedir/results.txt

while getopts ':b:n:d:g:p:s:S:u:n:e:f:h' opt; do
	case $opt in 	
	b) 
		nmap -p 139,445 -oG $filedir/results.txt $OPTARG	
		flag=true	
	;;
	n)
		nbtscan $OPTARG | tee -a $filedir/results.txt
		flag=true	
	;;
	d)
		nmap --script=$sloc/smb-enum-domains.nse -oG $filedir/results.txt --append-output $OPTARG
		flag=true	
	;;
	g)
		nmap --script=$sloc/smb-enum-groups.nse -oG $filedir/results.txt --append-output $OPTARG
		flag=true	
	;;
	p)
		nmap --script=$sloc/smb-enum-processes.nse -oG $filedir/results.txt --append-output $OPTARG
		flag=true	
	;;
	s)
		nmap --script=$sloc/smb-enum-sessions.nse -oG $filedir/results.txt --append-output $OPTARG
		flag=true	
	;;
	S)
		nmap --script=$sloc/smb-enum-shares.nse -oG $filedir/results.txt --append-output $OPTARG
		flag=true		
	;;
	u)
		nmap --script=$sloc/smb-enum-users.nse -oG $filedir/results.txt --append-output $OPTARG
		flag=true	
	;;
	r)
		rpcclient -U "" $OPTARG
		flag=true
	;;
	e)
		enum4linux -a $OPTARG | tee -a $filedir/results.txt 
		flag=true
	;;
	f)		
				
		if [ $(($# - $((OPTIND)))) -ge 1 ]; then
			echo -e "\nError! -f has to be the last option"
			exit 1
		fi		
		aloc=$((OPTIND-1))
		options=$@
		counter=0
		ipa=""
		nxtopt=""
		for i in ${options[@]}; do 
			if [ $counter -eq $aloc ]; then 
				nxtopt=${i}			
			fi		
			diff=$((counter - aloc))
			if [ $diff -eq 1 ] && [ -n nxtopt ]; then
				ipa=${i}
			fi
			((counter++))
		done
		if [ -z $nxtopt ]; then
			echo "Error! no action on input file specified"
			exit 1
		elif [ $nxtopt = "-h" ]; then 
			echo -e "Error! Require option which uses arguments in the input file\nUse the help option before -f"
			exit 1
		else 
			num=0
			case $nxtopt in 	
				b) 
					for num in $(cat $OPTARG); do					
						nmap -p 139,445 -oG $filedir/results.txt $num
					done
					flag=true	
				;;
				n)
					for num in $(cat $OPTARG); do					
						nbtscan $num | tee -a $filedir/results.txt
					done
					flag=true	
				;;
				d)
					for num in $(cat $OPTARG); do				
						nmap --script=$sloc/smb-enum-domains.nse -oG $filedir/results.txt --append-output $num
					done					
					flag=true	
				;;
				g)
					for num in $(cat $OPTARG); do				
						nmap --script=$sloc/smb-enum-groups.nse -oG $filedir/results.txt --append-output $num
					done					
					flag=true	
				;;
				p)
					for num in $(cat $OPTARG); do				
						nmap --script=$sloc/smb-enum-processes.nse -oG $filedir/results.txt --append-output $num
					done					
					flag=true	
				;;
				s)
					for num in $(cat $OPTARG); do				
						nmap --script=$sloc/smb-enum-sessions.nse -oG $filedir/results.txt --append-output $num
					done					
					flag=true	
				;;
				S)
					for num in $(cat $OPTARG); do				
						nmap --script=$sloc/smb-enum-shares.nse -oG $filedir/results.txt --append-output $num
					done					
					flag=true		
				;;
				u)
					for num in $(cat $OPTARG); do				
						nmap --script=$sloc/smb-enum-users.nse -oG $filedir/results.txt --append-output $num
					done					
					flag=true	
				;;
				r)
					for num in $(cat $OPTARG); do				
						rpcclient -U "" $num
					done					
					flag=true
				;;
				e)
					for num in $(cat $OPTARG); do				
						enum4linux -a $num | tee -a $filedir/results.txt 
					done					
					flag=true
				;;
				*)
					echo "Error! 2 arguments required use -h to access help"
					exit 1
				;;
			esac
		fi	
		flag=true
	;;
	h)
		echo " Master list of SMB Enum scripts"
		echo "================================"
		echo "-b. runs nmap port scan on ports 139 and 445 on host or subnet"  
		echo "-n. runs nbtscan on host or subnet"
		echo "-d. runs smb-enum-domains.nse script on host or subnet"
		echo "-g. runs smb-enum-groups.nse script on host or subnet"
		echo "-p. runs smb-enum-processes.nse script on host or subnet"
		echo "-s. runs smb-enum-sessions.nse script on host or subnet"
		echo "-S. runs smb-enum-shares.nse script on host or subnet"
		echo "-u. runs smb-enum-users.nse script on host or subnet"
		echo "-r. runs rpcclient with null username on host or subnet"
		echo "-e. runs enum4linux with all options on host or subnet"
		echo "-f. runs any of the above options with the addresses specified in the input file"
		echo "   Takes 2 arguments. First argument specifies the input file location"
		echo "   while the second argument specifies the option to run without the -"
		echo "   Note: -f has to be the last option specified"
		echo "-h. displays the help text"
		echo ""		
		flag=true	
	;;
	:)
    		echo "Option -$OPTARG requires an argument." >&2
    		exit 1
	;;
	\?)
    		echo "Invalid option: -$OPTARG" >&2
     		exit 1
    	;;
	esac
done

 
if [ $flag = false ]; then
	subnet=$1
	if [ -z $subnet ]; then read -p "Enter host / subnet: " subnet; fi
	echo -e " \n nbtscan results \n"
	echo -e "======================"
	nbtscan $subnet | tee -a $filedir/results.txt
fi

echo -e "\n Output stored in $filedir/results.txt file\n\n"
