#!/bin/bash
######################
##PRODUCTION UPDATER##
## produpdate.sh    ##
######################

PKGS=$2


SERVER_ARRAY=( mysql-lg1 mysql-lg2 mysql1demo mssql1demo mssql-lg1 mssql-lg2 idbneph01 idbneph02 web-db-node1 web-db-node2 web-db-node3 deskpro-prod1 deskpro-prod2 )

##function UPDATER {
for i in ${SERVER_ARRAY[@]}
do 
	echo UPDATING $i 
	ssh $i "sudo yum update ${PKGS} -y"
	ssh $i "freshclam"
done
exit 0
##}

##function INSTALLER {
##	for i in ${SERVER_ARRAY[@]}
##	do
##		echo Updating $i 
##		ssh  $i "sudo yum install ${PKGS} -y" 
##	done
## exit 0
## }

## function runcmd{
## 	for i in ${SERVER_ARRAY[@]}
##	do
##		echo Updating $i
##		ssh  $i "${PKGS}" 
## 	done
## exit 0
## }

## if [ $1 == "update"]; then
## 	UPDATER
## elif [ $1 == "install"]; then
## 	INSTALLER
## else
## 	runcmd
## fi 

## exit 0