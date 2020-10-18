#!/bin/bash

# Variable that holds the log directory, defaults to /var/log
logDirectory="/var/log/simplenetworkcheck.log"

# Variable that holds the fail2ban log directory
f2bLog="/var/log/fail2ban.log"

# Matches any IP address that is given in the output of the command 'ip a'
# It is stored in the ipa variable and then called later for formatting
ipa=$(ip a | awk 'match($0,/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}/,x) {print x[0]}')

# Matches any mac addresses in the output of ip a and stores it in the macaddr variable
macaddr=$(ip a | awk 'match($0,/\w\w:\w\w:\w\w\:\w\w:\w\w\:\w\w/,x) {print x[0]}')

# The commands that are used to retrieve the network info are stored in the function called main_commands()
main_commands() {
	# Prints the date and sends the output to the log
	printf "\n=====%s=====\n" "`date +%m/%d/%Y' '%T`" | tee -a $logDirectory

	# Prints the IP addresses that were stored in the $ipa variable 
	printf "IP ADDRESSES:\n%s\n" "$ipa"

	# Prints mac addresses from the output of 'ip a'
	printf "\nMAC ADDRESSES:\n%s\n" "$macaddr"

	# Checks to see if the fail2ban logs are in the right place, reads from log if it is, continues if it is not
	if [ -f "$f2bLog" ];
		then
			# Gets ban/unban actions as well as IP addresses asociated with it using grep and regex
			fail=$(cat /var/log/fail2ban.log | grep -E "[Bb]an [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
			# Prints fail2ban actions and ip addresses to the terminal and also appends it to the log file
			echo -e "\nFAIL2BAN LOG ACTIONS:" | tee -a $logDirectory
			echo -e "$fail\n" | tee -a $logDirectory
		else
			echo -e "\nFAIL2BAN LOGS NOT FOUND\n"
	fi
	
	# Conditional that checks for positive output from the ping command
	echo -e "\nPinging 8.8.8.8 to test internet connectivity..."
	if ping -w 2 -c 2 8.8.8.8 | grep -E "[1-9] received";
		then
			echo -e "\nINTERNET CONNECTION: TRUE"
		else
			echo -e "\nINTERNET CONNECTION: FALSE"
	fi

	# Uses ss to check system for open ports, prints to log and prints to terminal 
	echo -e "\nOPEN PORTS:" | tee -a $logDirectory
	ss -tupl | grep LISTEN | tee -a $logDirectory

	# Uses dig to check system for DNS info such as normal servers and root servers, prints to terminal and log 
	echo -e "\nDNS INFO:" | tee -a $logDirectory
	dig | tee -a $logDirectory

}


# This set of if statements checks if the user has passed the script a directory for the log to be created in 
# or if it has been run in root in which case the default directory can be used
if [ "$#" -ne 1 ] && [ "$EUID" -gt 0 ]
	then
		echo "Please specify a log file in command line or run as root"
elif [ "$#" -ne 1 ] && [ "$EUID" -eq 0 ]
	then
		echo "Saving in /var/log/networkcheck.log"
		main_commands
elif [ "$#" -ne 0 ]
	then
		logDirectory=$1
		echo "Saving in $1"
		main_commands
fi
