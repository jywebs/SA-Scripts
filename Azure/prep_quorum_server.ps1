##################################
##  Prep Quorum Server          ##
##  prep_quorum_server.ps1      ##
##################################

Import-Module ServerManager

Add-WindowsFeature Failover-Clustering 

net localgroup administrators "CORP\Install" /Add

logoff.exe"