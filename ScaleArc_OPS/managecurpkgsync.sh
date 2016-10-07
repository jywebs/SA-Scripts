#!/bin/bash
# managecurpkgsync.sh

LOGFILE=/var/log/buildsync.log
CPSLOGFILE=/var/log/currentpkgs_sync.log


function checkrun_currentpkgs {
	ps -ef | grep 'buildsync.sh currentpkgs' | grep -v 'grep' &> /dev/null
	if [ $? -eq 0 ]
		then
		echo "Sync run at `date` failed previous run still in process" &>> ${CPSLOGFILE}
		exit 0
	else
		nohup /root/jobs/buildsync.sh currentpkgs &
	fi
}

checkrun_currentpkgs

exit 0