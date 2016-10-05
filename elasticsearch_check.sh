#!/bin/bash

#############################
##	elasticsearch_check.sh ##
#############################

## Check running
## Test1:
curl -X GET http://127.0.0.1:9200 >/dev/null
if [[ $? > 0 ]]; then
	ps -ef | grep elasticsearch | grep -v grep
	if [[ $? > 0 ]]; then
		echo "`date`: elasticsearch java thread down restarting" >> /var/log/elasticsearch_check.log
		nohup /usr/share/elasticsearch/bin/elasticsearch
	fi
fi 

exit 0