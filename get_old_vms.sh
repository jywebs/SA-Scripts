#!/bin/bash

####################################
## get shutdown vm shutdown date. ##
## get_old_vms.sh                 ##
####################################

for VVMINFO in `xe vm-list power-state=halted | awk -F':' '/uuid/{print $2}'| cut -c 2-`
  do
    xe vm-list uuid=${VVMINFO} params=name-label| sed -e 1b -e '$!d'| cut -d ':' -f2| tr -d '\n' >> /tmp/rtp_data_`date +'%Y-%m-%d'`.out
    wait $!
    echo -n "  :  " >> /tmp/rtp_data_`date +'%Y-%m-%d'`.out
    xe message-list name=VM_SHUTDOWN obj-uuid=${VVMINFO} params=timestamp | sed -e 1b -e '$!d' | cut -d ':' -f2| awk -F'T' '{print $1}'| tr -d '\n'  >> /tmp/rtp_data_`date +'%Y-%m-%d'`.out
    printf "\n" >> /tmp/rtp_data_`date +'%Y-%m-%d'`.out
    wait $!
  done

exit 0