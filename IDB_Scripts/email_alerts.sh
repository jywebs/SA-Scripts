#!/bin/bash

#######################################
# ScaleArc Email Alerting Temp Script #
# scalearc_email_alert.sh             #
#######################################

#Set Global Var
_DATE_=`date "+%Y%m%d"`
_TIME_=`date -d "-1 minute" "+%H:%M"`
_ALERT_USR_='jacy.york@scalearc.com'
_DBDATE_=`date -d "-1 minute" "+%Y-%m-%d %H:%M"`
_HADATE_=`date -d "-1 minute" "+%Y%m%d%H%M"`

#Unknown cluster level alert
  function clusteralert {
  grep "IDB AGENT" /currentlogs/${_DATE_cat }/idb_main.log | grep ${_TIME_} >> /dev/null
  if [ $? = 0 ] 
    then
    grep "IDB AGENT" /currentlogs/${_DATE_}/idb_main.log | grep ${_TIME_} | mail -s "Unexpected ScaleArc Cluster Event occured ${_DATE_} ${_TIME_}!!" ${_ALERT_USR_}
  fi 
}
#Alert on ScaleArc Events
function dbalerts {
  _EVENTS_=`sqlite3 /system/lb.sqlite "select count(message) from lb_eventmaster where reset = 0 and updatetime > '${_DBDATE_}'"`
  if [ ${_EVENTS_} != 0 ] 
    then
    sqlite3 /system/lb.sqlite "select message from lb_eventmaster where reset = 0 and updatetime > '${_DBDATE_}'" | mail -s "!!ScaleArc Event Occured ${_DATE_} ${_TIME_}!!" ${_ALERT_USR_}
  fi 
}
#Alert Failover
function failoveralert {
  grep Attempting /logs/services/failover.log | grep "${_DBDATE_}">> /dev/null
  if [ $? = 0 ] 
    then
  	grep Attempting /logs/services/failover.log | grep "${_DBDATE_}" | mail -s "!!Autofailover Event Occured  ${_DATE_} ${_TIME_}!!" ${_ALERT_USR_}
  fi
}
#HA Alert 
function halert {
  grep switch /logs/ha_idb.log | grep ${_HADATE_} >> /dev/null
  if [ $? = 0 ] 
    then
  	grep switch /logs/ha_idb.log | grep ${_HADATE_} | mail -s "!!ScaleArc HA event Occured  ${_DATE_} ${_TIME_}!!" ${_ALERT_USR_}
  fi 
}
#Main
#Is Primary
IS_PRI=`/etc/init.d/monitor_idb status`
if [ ${IS_PRI} == "Running" ] 
  then
    clusteralert
    dbalerts
    failoveralert
    halert
else
	exit 0
fi
exit 0
