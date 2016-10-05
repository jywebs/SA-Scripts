#!/bin/bash
#/opt/idb/support/start_tunnel.sh

#user EXP DATE
exp_date=$1

function usage {

	echo "/opt/idb/support/start_tunnel.sh <expiration>
	example: /opt/idb/support/start_tunnel.sh 2014/02/28"

}#end usage

function add_user {

	#Generate password
	usr_pwd=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c8`

	#Generate Random Username
	usr_name=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c8`
	
	#create user
	useradd  ${usr_name} -e ${exp_date}
	
	echo ${usr_pwd} | passwd ${usr_name} --stdin
	
	echo "User ${usr_name} added"
	echo "Users password = ${usr_pwd}"
	echo "Please provide ScaleArc Support the login details for your current tunnel"
	echo "User Will expire ${exp_date}"
	
} #END add_user

function create_tunnel {
	
	#genport
	port=$(( 60000+( $(od -An -N2 -i /dev/random) )%(1023+1) ))
	bash /opt/idb/support/gen_tunnel $port
	if [ $? < 0 ]
	then
		port=$(( 60000+( $(od -An -N2 -i /dev/random) )%(1023+1) ))
		bash /opt/idb/support/gen_tunnel $port
	fi
		

}#end create_tunnel

if [ $# -eq 0 ] 
then
	usage
fi
	
#Start
add_user
create_tunnel

exit 0