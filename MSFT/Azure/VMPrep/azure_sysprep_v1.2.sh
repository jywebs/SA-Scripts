#!/bin/bash

###################################
## AZURE BUILD PREP SCRIPT       ##
## Written by Jacy York/ScaleArc ##
## Version 1.1 dated 2014.03.27  ## 
###################################

#Backup files Azure messes with
function backup ()
{
	mkdir ~/azure_backup
	cp /etc/sysconfig/network ~/azure_backup/
	cp /etc/sysconfig/network-scripts/ifcfg-eth0 ~/azure_backup/
	cp /etc/yum.repos.d/CentOS-Base.repo ~/azure_backup/

} #end backup

#NETWORK PREP
function net_prep ()
{

	#setup network file
	echo "NETWORKING=yes" > /etc/sysconfig/network
	echo "HOSTNAME=localhost.localdomain" >> /etc/sysconfig/network

	#Create new ifcfg-eth0 file
	echo "DEVICE=eth0" > /etc/sysconfig/network-scripts/ifcfg-eth0
	echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-eth0
	echo "DHCP=yes" >> /etc/sysconfig/network-scripts/ifcfg-eth0
	echo "BOOTPROTO=dhcp" >> /etc/sysconfig/network-scripts/ifcfg-eth0
	echo "TYPE=Ethernet" >> /etc/sysconfig/network-scripts/ifcfg-eth0
	echo "USERCTL=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
	echo "PEERDNS=yes" >> /etc/sysconfig/network-scripts/ifcfg-eth0
	echo "IPV6INIT=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0

	chkconfig network on

} ##net_prep done


#apply yum changes
function yum_changes ()
{

sudo yum install python-pyasn1 -y

#Modify default repo
cat > /etc/yum.repos.d/CentOS-Base.repo << EOF
[openlogic]
name=CentOS-$releasever - openlogic packages for $basearch
baseurl=http://olcentgbl.trafficmanager.net/openlogic/6/openlogic/x86_64/
enabled=1
gpgcheck=0

[base]
name=CentOS-$releasever - Base
baseurl=http://olcentgbl.trafficmanager.net/centos/6.5/os/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#released updates
[updates]
name=CentOS-$releasever - Updates
baseurl=http://olcentgbl.trafficmanager.net/centos/6.5/updates/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
baseurl=http://olcentgbl.trafficmanager.net/centos/6.5/extras/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
baseurl=http://olcentgbl.trafficmanager.net/centos/6.5/centosplus/x86_64/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#contrib - packages by Centos Users
[contrib]
name=CentOS-$releasever - Contrib
baseurl=http://olcentgbl.trafficmanager.net/centos/6.5/contrib/x86_64/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
EOF

	#modify yum config
	echo "http_caching=packages" >> /etc/yum.conf
	echo "exclude=kernel*" >> /etc/yum.conf
	
	sed -i.bak 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf
	
	yum --disableexcludes=all install kernel -y

} ##end yum changes

#Install additional AZURE components
function azure_comps ()
{
	
	#Modify grub to send output to console
	sed -i.bak '/kernel/ s/$/ console=ttyS0 earlyprintk=ttyS0 rootdelay=300/' /boot/grub/grub.conf
	yum install WALinuxAgent -y
	
	sed -i.bak1 's/ResourceDisk.EnableSwap=n/ResourceDisk.EnableSwap=y/' /etc/waagent.conf
	sed -i.bak2 's/ResourceDisk.SwapSizeMB=0/ResourceDisk.SwapSizeMB=8192/' /etc/waagent.conf
	
	mkdir /var/lib/waagent
	rm -f /lib/udev/rules.d/75-persistent-net-generator.rules
	rm -f /etc/udev/rules.d/70-persistent-net.rules
	rm -f /etc/resolv.conf

	#apache changes
	sed -i.bak1 '/#ServerName www.example.com/a ServerName localhost:80' /usr/local/apache/conf/httpd.conf
	
	echo "3" > /system/iscloud.txt
	
	chkconfig network on
	chkconfig iptables off #this will make sure that any iptables rules added do not get in the way of the setup process. 
	
	waagent -force -deprovision
	export HISTSIZE=0

} ## end azure_comps

## START
backup
net_prep
yum_changes
azure_comps

echo "Azure provisioning complete please shutdown the VM"

exit 0