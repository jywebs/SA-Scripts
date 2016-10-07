#!/bin/bash

#######################
##fandango_install.sh##
#######################

#install deps
rpm -ihv --force --nodeps ./deps/*.rpm

#Add apache and admin user 
/usr/sbin/userdel apache
/usr/sbin/groupadd apache
/usr/sbin/adduser -p '$1$pMoAj.oh$ONad0wfs8gc4Yo2ZSpfHv0' apache -g apache
/usr/sbin/groupadd admin
/usr/sbin/adduser -p '$1$B7zaVl8R$bFtWSQ5sj/J0n0RXNyGnk/' -d /idb/lbgui/console admin -g admin -s /idb/lbgui/console/url.sh

#install idb
rpm -ihv --force ./idb/*.rpm

#Copy freetds configuration
/bin/echo "/usr/local/apache/freetds/lib/" >> /etc/ld.so.conf
/bin/echo "/usr/local/apache/freetds/bin/" >> /etc/ld.so.conf
#Create iscloud.txt
/bin/touch /system/iscloud.txt
/bin/echo "2" > /system/iscloud.txt
/bin/chmod 777 /system/iscloud.txt

#Copy default cron files
/bin/cp /idb/lbgui/fs/cron.ORG /var/spool/cron/root  
/bin/cp /idb/lbgui/fs/cron.ORG /system/cron  
/usr/bin/crontab /system/cron 

#Add entry to sysctl.conf
/bin/echo "# iDB-Admin" >> /etc/sysctl.conf
/bin/echo "kernel.core_pattern = /cache/core" >> /etc/sysctl.conf

#Create RamDisk
/bin/mkdir -p /cache/ramdisk  
/bin/mount -t tmpfs none /cache/ramdisk -o size=100m  
/bin/cp -p /idb/lbgui/fs/lbstats.sqlite.ram /cache/ramdisk/lbstats.sqlite  
rm -rf /idb/lbgui/lbstats.sqlite  
ln -s /cache/ramdisk/lbstats.sqlite /idb/lbgui/lbstats.sqlite 

#Copy required files use by core to check status of HA
/bin/cp /idb/lbgui/fs/scripts/killmonitoridb /etc/ha.d/resource.d/killmonitoridb
/bin/cp /idb/lbgui/fs/scripts/monitor_idb  /etc/init.d/monitor_idb

#Copy Heartbeat default files
/bin/cp -pr /idb/lbgui/fs/scripts/authkeys /etc/ha.d/  
/bin/cp -pr /idb/lbgui/fs/scripts/ha.cf /etc/ha.d/  
/bin/cp /idb/lbgui/fs/scripts/haresources /etc/ha.d/haresources
/bin/chmod 0600 /etc/ha.d/authkeys

#Copy network related files
/bin/cp -rp /etc/sysconfig/network-scripts/ifcfg-eth* /system/  
/bin/cp -rp /etc/sysconfig/network-scripts/route* /system/  

#Other files
/bin/sh /idb/lbgui/fs/scripts/password_set.sh  
/bin/cp /idb/lbgui/fs/scripts/bwm-ng /usr/local/bin/  
/bin/cp /idb/lbgui/fs/scripts/sshpass  /usr/local/bin/sshpass  
/bin/cp /idb/lbgui/fs/scripts/config /etc/selinux/config  
/bin/cp /idb/lbgui/fs/scripts/rc.local /etc/rc.local  

#Turn off unwanted services at boot level
/sbin/chkconfig  --add rsync  
/sbin/chkconfig rsync off 35  
/sbin/chkconfig heartbeat on  
/sbin/chkconfig sendmail off 35   >> NA
/sbin/chkconfig postfix off 35  
/sbin/chkconfig nfslock off 35  
/sbin/chkconfig ip6tables off 35 
/sbin/chkconfig iptables off

#Add entry in sudoers file
/bin/echo "apache ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
/bin/echo "admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
/bin/sed -i -e 's/\(Defaults    requiretty\)/#\1\n#Defaults    requiretty /' /etc/sudoers
/bin/sed -i -e 's/\(Defaults   !visiblepw\)/#\1\n#Defaults   !visiblepw /' /etc/sudoers

#Other files
/bin/echo "4000   5000" > /proc/sys/net/ipv4/ip_local_port_range
/bin/echo "ulimit -n 1000000" >> /root/.bashrc
/bin/echo "ulimit -c unlimited" >> /root/.bashrc
/bin/echo "Port=555" >> /etc/ssh/sshd_config
/bin/echo "Port=22" >> /etc/ssh/sshd_config
/sbin/ldconfig –vv
/bin/echo "#Restrict Admin User login via SSH" >> /etc/ssh/sshd_config
/bin/echo "Match User admin" >> /etc/ssh/sshd_config
/bin/echo "    PasswordAuthentication no" >> /etc/ssh/sshd_config
/bin/cp -rp /idb/lbgui/fs/scripts/httpd /etc/init.d/httpd
/bin/chmod 777 /etc/init.d/httpd
