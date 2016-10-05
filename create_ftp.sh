#!/bin/bash
##
#create_ftp.sh
#usage customername
##

function USAGE {
	echo "create_ftp.sh customername"
	exit
}

function PASSGEN {
	PWD=`</dev/urandom tr -dc A=Za-z0-9 | head -c8`
}

if [ $# -eq 0 ] 
then
	USAGE
fi

#Start Main
grep $1 /etc/passwd
if [ $? = 0 ] 
then
	echo "user exists"
	exit 1
fi

PASSGEN

useradd -s /bin/bash -m -d /dropbox/$1 -c "$1" -g ftp -p `openssl passwd -1 ${PWD}` $1	

grep $1 /etc/password
if [ $? = 0 ] 
then
	echo "user successfully added"
	echo "User password is ${PWD}" 
else
	echo "error creating user"
	exit 1
fi

exit 0