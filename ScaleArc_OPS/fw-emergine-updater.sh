#!/bin/bash

####################################
#	Emerging Threats IP UPDATER	   #
#	emg_threats_fwrules.sh		   #
####################################

FWREV_URL='http://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt'

#restart iptables to clean (base) state
/etc/init.d/iptables restart

#download emergingthreats
curl -k ${FWREV_URL} -o /tmp/emerging-Block-IPs.txt

#refresh fwlist.sh
echo "" > /tmp/fwlist.sh

#process fwlist
for ip in `awk '$1 !~ /#/ {print $1}' /tmp/emerging-Block-IPs.txt | grep -v '^$'`; 
	do echo "iptables -A INPUT -s $ip -j DROP" >> /tmp/fwlist.sh
done

bash /tmp/fwlist.sh

exit 1