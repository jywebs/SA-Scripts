#!/bin/bash

for i in mysql1 mssql1 oracle1; do
	echo "User Report for $i";
	ssh idb@$i -q "find /logs/201610*/idb.uilog.* | xargs egrep 'scalearc.com/api/login DATA=\"username' --text" | awk -F 'DATA=' '{print $2}'| sort | uniq -c;
done

exit 0
