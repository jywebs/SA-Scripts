#!/bin/bash

_USR_=$1

function usage {

	echo "Usage: create_sftpuser.sh <username>"
	echo "Hint:"
	echo "The <username> cannot contain spaces"
	exit 1
	
} #END USAGE

function add_user {

	#Generate password
	usr_pwd=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c8`

	_PWD_=`pcrypt ${usr_pwd}`
	#create user
	useradd -d /ftpdata/${_USR_} -g sftponly -p ${_PWD_} ${_USR_}
	
	#remove ssh access
	usermod -s /bin/false ${_USR_}
	
	#Secure Directory
	chown root:root /ftpdata/${_USR_}
	chmod 0755 /ftpdata/${_USR_}

	#add upload directory
	mkdir /ftpdata/${_USR_}/upload
	chown ${_USR_} /ftpdata/${_USR_}/upload
	
	echo "User ${_USR_} added"
	echo "Users password = ${usr_pwd}"
	echo "usage: sftp ${_USR_}@upload.scalearc.com"
	echo "All files need to be uploaded to the upload directory"
	
	echo "${_USR_}:${usr_pwd}" >> ~/ftpusers
	exit 0
	
} #END add_user
# directory name must not contain spaces

#$string = ${_USR_}
#if [ "$string" == "${string//[\' ]/}" ]
#	then
#		echo "create_sftpuser error: <username> must not contain spaces: $string" 
#		usage
#		exit 0
#fi

# should also check for invalid characters and/or convert to lowercase including numbers and "_" and "-" then check length with original. If match then good translate.

# If directory exists, generate error and run usage() again.

if [[ -d /ftpdata/${_USR_} && $# -eq 1 ]]
	then
		echo "create_sftpuser error: Cannot create directory: /ftpdata/${_USR_} already exists"
		usage
		exit 0
fi

if [ $# -eq 1 ] 
	then
		add_user
	else 
		usage
fi

exit 0	
