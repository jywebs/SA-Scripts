#!/bin/bash

############################
## Create Web Upload User ##
##  create_webuser.sh     ##
############################

function add_user {

#Generate Password
_PWD='openssl rand -hex 10'

grep $1 /etc/httpd/.htpasswd

if [ $? > 0 ], then
	#Create User
	htpasswd -b /etc/httpd/.htpasswd $1 ${_PWD}
	echo "user $1 created \
	Password set to ${_PWD} \
	Upload the file via sdt.scalearc.com"
else
	#update users password
	htpasswd -b /etc/httpd/.htpasswd $1 ${_PWD}
	echo "user exists \
	Password has been reset to ${_PWD} \
	Upload the file via sdt.scalearc.com"
fi
} #End Function

function usage {
	echo "create_webuser.sh <username>"
	exit 1
}

#MAIN
if [ $# -eq 0 ]
	then
	 usage
else
	add_user
fi

exit 0