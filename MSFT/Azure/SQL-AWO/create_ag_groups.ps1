##################################
##  Create Availability Groups  ##
##  create_ag_groups.ps1        ##
##################################


echo " This script must be run from SQL Server 1"
echo " This script requires that the WSFC cluster is already setup and funtioning correctly"
echo "Script is setup for a SQL+SQL+Quorum model"

#Define the below VARs

$server1 = Read-Host "SQL Server 1 Name"
$server2 = Read-Host "SQL Server 2 Name"
$serverQuorum = Read-Host "Quorum Server Name"
$acct1 = Read-Host "SysAdmin AD Account for SQL Server 1 (CORP\SQLSvc1)"
$acct2 = Read-Host "SysAdmin AD Account for SQL Server 2 (CORP\SQLSvc2)"
$password = Read-Host "Password for AD Account (Contoso!000)"
$clusterName = Read-Host "Cluster Name (Cluster1)"
$timeout = New-Object System.TimeSpan -ArgumentList 0, 0, 30
$db = Read-Host "DB Name (MyDB1)"
$backupShare = Read-Host "Backup Share Location (i.e \\$server1\backup)"
$quorumShare = Read-Host "Quorum Share Location (i.e \\$server1\quorum)"
$ag = Read-Host "Availability group name"

#Enable AlwaysOn Availability Groups for the default SQL Server instances
Enable-SqlAlwaysOn -Path SQLSERVER:\SQL\$server1\Default -Force
Enable-SqlAlwaysOn -Path SQLSERVER:\SQL\$server2\Default -NoServiceRestart
$svc2.Stop()
$svc2.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Stopped,$timeout)
$svc2.Start(); 
$svc2.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Running,$timeout)

#Create a backup directory and grant permissions for the SQL Server service accounts.
$backup = Read-Host "Name of Directory to create backup (i.e c:\backup)"
New-Item $backup -ItemType directory
net share backup=$backup "/grant:$acct1,FULL" "/grant:$acct2,FULL"
icacls.exe "$backup" /grant:r ("$acct1" + ":(OI)(CI)F") ("$acct2" + ":(OI)(CI)F") 

Create a database on SQL1, take both a full backup and a log backup, and restore them on SQL2 with the WITH NORECOVERY option.
Invoke-SqlCmd -Query "CREATE database $db"
Backup-SqlDatabase -Database $db -BackupFile "$backupShare\db.bak" -ServerInstance $server1
Backup-SqlDatabase -Database $db -BackupFile "$backupShare\db.log" -ServerInstance $server1 -BackupAction Log
Restore-SqlDatabase -Database $db -BackupFile "$backupShare\db.bak" -ServerInstance $server2 -NoRecovery
Restore-SqlDatabase -Database $db -BackupFile "$backupShare\db.log" -ServerInstance $server2 -RestoreAction Log -NoRecovery

#Create the availability group endpoints on the SQL Server VMs and set the proper permissions on the endpoints.
$endpoint = 
            New-SqlHadrEndpoint MyMirroringEndpoint -Port 5022 -Path "SQLSERVER:\SQL\$server1\Default" 
            Set-SqlHadrEndpoint -InputObject $endpoint -State "Started"
$endpoint = 
            New-SqlHadrEndpoint MyMirroringEndpoint -Port 5022 -Path "SQLSERVER:\SQL\$server2\Default"
            Set-SqlHadrEndpoint -InputObject $endpoint  State "Started"
            
            Invoke-SqlCmd -Query "CREATE LOGIN [$acct2] FROM WINDOWS" -ServerInstance $server1
            Invoke-SqlCmd -Query "GRANT CONNECT ON ENDPOINT::[MyMirroringEndpoint] TO [$acct2]" -ServerInstance $server1
            Invoke-SqlCmd -Query "CREATE LOGIN [$acct1] FROM WINDOWS" -ServerInstance $server2
            Invoke-SqlCmd -Query "GRANT CONNECT ON ENDPOINT::[MyMirroringEndpoint] TO [$acct1]" -ServerInstance $server2 

#Create the availability replicas.
$primaryReplica = New-SqlAvailabilityReplica -Name $server1 -EndpointURL "TCP://$server1.corp.contoso.com:5022" -AvailabilityMode "SynchronousCommit" -FailoverMode "Automatic" -Version 11 -AsTemplate
$secondaryReplica = New-SqlAvailabilityReplica -Name $server2 -EndpointURL "TCP://$server2.corp.contoso.com:5022" -AvailabilityMode "SynchronousCommit"  -FailoverMode "Automatic" -Version 11 -AsTemplate 

#create the availability group and join the secondary replica to the availability group.
New-SqlAvailabilityGroup -Name $ag -Path "SQLSERVER:\SQL\$server1\Default" -AvailabilityReplica @($primaryReplica,$secondaryReplica) -Database $db
Join-SqlAvailabilityGroup -Path "SQLSERVER:\SQL\$server2\Default" -Name $ag
Add-SqlAvailabilityDatabase -Path "SQLSERVER:\SQL\$server2\Default\AvailabilityGroups\$ag" -Database $db

echo "Availability Group Created"