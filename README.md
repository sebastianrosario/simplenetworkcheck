# simplenetworkcheck
Simplenetworkcheck is a shell script that checks default Linux networking settings like, IP, Mac Addresses and internet connectivity.
This script also logs fail2ban ban/unban actions, open ports, and dns info at var/log/networkcheck.log or a specified directory that is passed into the command line argument.

---Examples---


<b>./simplenetworkcheck.sh \~/Desktop/networkinfo.log</b>

The file location and name (<b>~/Desktop/networkinfo.log</b>) is passed to the script and the logDirectory variables changes to accomadate.

<b>sudo ./simplenetworkcheck.sh</b>

Since the script was run as sudo and no directory was specified, the script saves the log file to the default directory, <b>/var/log/simplenetworkcheck.log</b>
