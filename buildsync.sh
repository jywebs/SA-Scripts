#!/bin/bash

# buildsync.sh
# REMOTE Sync all_builds

LOGFILE=/var/log/buildsync.log
CPSLOGFILE=/var/log/currentpkgs_sync.log

function rsync_alldata {

#for all_builds
echo "Rsync all_build files to NAS" >> ${LOGFILE}
nohup rsync -rltzuvh -e 'ssh -p 2222' --progress root@124.153.92.112:/var/www/ALLRPMS/all_builds/ /mnt/all_builds/ &>>${LOGFILE} &
wait $!
#Alert that process completed. 

cat ${LOGFILE} | mail -s "All Build rsync Complete `date`" jacy.york@scalearc.com

} #end rsync all_data

function rsync_currentpkgs {

#for IDS3 31 update1 pkgs
nohup rsync -rltzuvh -e 'ssh -p 2222' --progress root@124.153.92.112:/var/www/ALLRPMS/all_builds/IDB3_COMMON_BRANCH/3_1_Update1/packages/ /mnt/all_builds/IDB3_COMMON_BRANCH/3_1_Update1/packages/ &>> ${CPSLOGFILE} &
wait $!

#Alert that process completed. 

cat ${CPSLOGFILE} | mail -s "Current Packages rsync Complete `date`" jacy.york@scalearc.com

}

if [ $# != 1 ]
	then
	echo "invalid number of arguments"
	exit 1
fi

if [ $1 = "all_builds" ]
	then
	rsync_alldata
	exit 0
elif [ $1 = currentpkgs ]
	then
	rsync_currentpkgs
	exit 0
else
	echo "invalid option"
	exit 1
fi