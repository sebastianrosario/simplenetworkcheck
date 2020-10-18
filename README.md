# simplenetworkcheck
Simplenetworkcheck is a shell script that checks default Linux networking settings like, IP, Mac Addresses, internet connectivity, open ports, and dns info. This script also optionally logs fail2ban ban/unban actions, that is to say if fail2ban is installed. It saves the log by default at var/log/simplenetworkcheck.log or a specified directory that is passed into the command line argument. The script runs these specific commands because all modern Linux machines has these commands pre-packaged (except for fail2ban which is made optional). I focused on simple yet useful things to keep in a log. 


Download the script, using the web or git, run chmod command to add executable permissions on it (chmod +x), and run it. 

## Examples


<b>./simplenetworkcheck.sh \~/Desktop/networkinfo.log</b>

The file location and name (<b>~/Desktop/networkinfo.log</b>) is passed to the script and the logDirectory variables changes to accomadate.

<b>sudo ./simplenetworkcheck.sh</b>

Since the script was run as sudo and no directory was specified, the script saves the log file to the default directory, <b>/var/log/simplenetworkcheck.log</b>
