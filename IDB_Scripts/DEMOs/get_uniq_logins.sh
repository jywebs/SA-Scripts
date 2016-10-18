#!/bin/bash

######################################
##		get_demo_logs.sh			##
######################################

#Get current month
if [ `date +'%d'` -lt "5" ]; then
	_DATE_=`date +'%Y%m' -d '-1 month'`
else
	_DATE_=`date +'%Y%m'`
fi

#Get Login Data
for i in mysql1 mssql1 oracle1; do
	echo "User Report for $i";
	ssh idb@$i -q "find /logs/201610*/idb.uilog.* | xargs egrep 'scalearc.com/api/login DATA=\"username' --text" | awk -F 'DATA=' '{print $2}' | sort | uniq -c;
done

exit 0