#!/bin/bash
# managesync.sh

LOGFILE=/var/log/buildsync.log
CPSLOGFILE=/var/log/currentpkgs_sync.log

function checkrun_allbuild {
	ps -ef | grep 'buildsync.sh all_builds' | grep -v 'grep' &> /dev/null
	if [ $? -eq 0 ]
		then
		echo "Sync run at `date` failed previous run still in process" &>> ${LOGFILE}
		exit 0
	else
		nohup /root/jobs/buildsync.sh all_builds &
	fi
}

checkrun_allbuild

exit 0