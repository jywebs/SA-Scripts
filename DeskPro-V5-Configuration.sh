###General Changes

#update hosts
echo "
10.133.223.91 dpv5prod2
10.133.223.90 dpv5prod1
">>/etc/hosts

#Update system
apt-get update -y
apt-get upgrade -y
apt-get upgrade vim ubuntu-core-launcher -y
apt autoremove

#Install DESKPRO
wget -q -O - https://www.deskpro.com/go/install.sh | sudo bash

#Clear Deskpro Setup
ln -s 

###Setup dpv5prod1
sed -i 's/0.0.0.0/10.133.223.90' /etc/mysql/my.cnf

#Update my.cnf for Master
echo "
server-id=90

log-bin=mysql-bin 
binlog_format=mixed 
max_connections = 20000 
max_connect_errors = 99999999 
#wait_timeout = 28800 
#interactive_timeout = 28800 
wait_timeout = 180 
interactive_timeout = 180 
skip-name-resolve

binlog-ignore-db=test		 	  # input the database that should be ignored for replication
" >> /etc/mysql/my.cnf

systemclt restart mysql

mysql -u root "grant replication slave on *.* to 'replication'@10.133.223.91 identified by 'M5zNu5ZAJt28d7hm5J93'"
mysql -u root "show master status"


###Setup dpv5prod2
sed -i 's/0.0.0.0/10.133.223.91' /etc/mysql/my.cnf
echo "
server-id=90

log-bin=mysql-bin 
binlog_format=mixed 
max_connections = 20000 
max_connect_errors = 99999999 
#wait_timeout = 28800 
#interactive_timeout = 28800 
wait_timeout = 180 
interactive_timeout = 180 
skip-name-resolve

binlog-ignore-db=test		 	  # input the database that should be ignored for replication
" >> /etc/mysql/my.cnf

systemclt restart mysql

mysql -u root "grant replication slave on *.* to 'replication'@10.133.223.91 identified by 'M5zNu5ZAJt28d7hm5J93'"

stop slave; 
CHANGE MASTER TO MASTER_HOST = '10.133.223.90', MASTER_USER = 'replication', MASTER_PASSWORD = 'M5zNu5ZAJt28d7hm5J93', MASTER_LOG_FILE = '<LOGFILE>', MASTER_LOG_POS = <POS>; 
start slave;

grant replication slave on *.* to 'replication'@10.133.223.90 identified by 'M5zNu5ZAJt28d7hm5J93';


###Update dpvprod01 mysql for Slave
stop slave; 
CHANGE MASTER TO MASTER_HOST = '10.133.223.91', MASTER_USER = 'replication', MASTER_PASSWORD = 'M5zNu5ZAJt28d7hm5J93', MASTER_LOG_FILE = '<LOGFILE>', MASTER_LOG_POS = <POS>; 
start slave;



#Add Deskpro User to DB Servers
CREATE USER 'dpv5prodadmin'@'%' IDENTIFIED BY 'jb2sJAEecuR762f7n5r6';
CREATE DATABASE deskpro_prod_db;
GRANT ALL PRIVILEGES ON deskpro_prod_db.* TO 'dpv5prodadmin'@'%';

Deskpro MySQL UID: dpv5prodadmin
deskpro MySQL PWD: jb2sJAEecuR762f7n5r6


#Change MySQL Root Password
#New Password Mysql root password: L86F4VzcZ761


