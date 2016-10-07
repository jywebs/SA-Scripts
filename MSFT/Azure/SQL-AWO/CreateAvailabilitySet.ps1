<#
.SYNOPSIS
   Powershell script to create a base SQL2012 AWO environment
.DESCRIPTION
   script will create a 2node AWO cluster on the AZURE environment along with a DC and watcher.
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>

#import azure module and account information
Import-Module "C:\Program Files (x86)\Microsoft SDKs\Windows Azure\PowerShell\Azure\Azure.psd1"
Get-AzurePublishSettingsFile
$userinput = Read-Host "specify publish settings file path: "
Import-AzurePublishSettingsFile $userinput


#Get Params from users
$location = Read-Host "specify location (West US, East US, West Europe, etc...): "
$affinityGroupName= Read-Host "specify affinity group name (i.e. ContosoAG): " 
$affinityGroupDescription = Read-Host "specify affinity group description (i.e. Contoso SQL HADR Affinity Group): "
$affinityGroupLabel = Read-Host "specify affinity group label (i.e. IaaS BI Affinity Group): "
$networkConfigPath = "C:\scripts\Network.netcfg"
$virtualNetworkName = "ContosoNET"
$storageAccountName = "<uniquestorageaccountname>"
$storageAccountLabel = "Contoso SQL HADR Storage Account"
$storageAccountContainer = "https://" + $storageAccountName + ".blob.core.windows.net/vhds/"
$winImageName = (Get-AzureVMImage | where {$_.Label -like "Windows Server 2008 R2 SP1*"} | sort PublishedDate -Descending)[0].ImageName
$sqlImageName = (Get-AzureVMImage | where {$_.Label -like "SQL Server 2012 SP1 Enterprise*"} | sort PublishedDate -Descending)[0].ImageName
$dcServerName = "ContosoDC"
$dcServiceName = "<uniqueservicename>" 
$availabilitySetName = "SQLHADR"
$vmAdminUser = "AzureAdmin" 
$vmAdminPassword = "Contoso!000" 
$workingDir = "c:\scripts\" 