#!/bin/bash
#####
#idb_mon.sh
#Monitor and alert is idb has been restarted
#add every minute check to cron
#Crontab entry * * * * * /idb/scripts/wc_idb_mon.sh
#####

PROC_NAME=idblb
ENV="War Commander"
MAIL_SUBJECT="${ENV} has been restarted"
MAIL_LIST=support@scalearc.com

#Start basic check
ps -ef | grep ${PROC_NAME} | grep -v grep >> /dev/null
if [ $? != 0 ]
        then
        echo "idblb is not running on ${ENV}" | mail -s "idblb is not  currently running on ${ENV}" ${MAIL_LIST}
        echo "${PROC_NAME} is down"
        exit 1
fi

#get process ID
PROC_ID=`ps -ef | grep ${PROC_NAME} | head -n 1 | awk '{print $2}'`

#get process ID start time
PROC_START=`ls -ld /proc/${PROC_ID} | awk '{print $6,$7,$8}'`

#compare times to gather uptime
T1=$(date +%s -d "`date`")
T2=$(date +%s -d "${PROC_START}")
((diffsec=${T1} - ${T2}))

#compare uptime within the last 1 minute
#since the cron job runs everyminute it should never be less than 1 minute

if [ ${diffsec} -lt 120 ]
        then
                #process has restarted within the last 2 minutes
                echo "${MAIL_SUBJECT} please login and collect logs" | mail -s "${MAIL_SUBJECT} current uptime is ${diffsec} seconds" ${MAIL_LIST}
                echo "${PROC_NAME} uptime is ${diffsec}"
fi

exit 0