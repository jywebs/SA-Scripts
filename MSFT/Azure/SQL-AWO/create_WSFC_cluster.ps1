##################################
##  Create Create WSFC Cluster  ##
##  create_WSFC_cluster.ps1     ##
##################################

echo " This script must be run from SQL Server 1"

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

Set-ExecutionPolicy RemoteSigned -Force
Import-Module "sqlps" -DisableNameChecking 

$wmi1 = new-object ("Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer") $server1
$wmi1.services | where {$_.Type -eq 'SqlServer'} | foreach{$_.SetServiceAccount($acct1,$password)}
$svc1 = Get-Service -ComputerName $server1 -Name 'MSSQLSERVER'
$svc1.Stop()
$svc1.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Stopped,$timeout)
$svc1.Start(); 
$svc1.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Running,$timeout)

Set-ExecutionPolicy Unrestricted -Force
.\CreateAzureFailoverCluster.ps1 -ClusterName "$clusterName" -ClusterNode "$server1","$server2","$serverQuorum"