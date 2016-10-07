
##########################################################
## Azure Always-On Setup Script create_azure_awo.ps1    ##
## Not all aspects of the script can/could be automated ##
## The script does provide Actionable steps to complete ##
##########################################################

#Get account information
Get-AzurePublishSettingsFile
$publistsettings = Read-Host 'Enter Publish Settings File location'
Import-AzurePublishSettingsFile $publistsettings

#Define a series of variables that you will use to create your cloud IT infrastructure
$location = Read-Host 'location (i.e West US)'
$affinityGroupName = Read-Host 'Affinity Group Name'
$affinityGroupDescription = Read-Host 'Affinity Group Description'
$affinityGroupLabel =  Read-Host 'Affinity Group Label'
$networkConfigPath =  Read-Host 'Network Config Path (i.e: C:\scripts\Network.netcfg)'
$virtualNetworkName = Read-Host 'Virtual Network Name'
$storageAccountName = Read-Host 'Unique storageAccount Name'
$storageAccountLabel = Read-Host 'Storage Account Label'
$storageAccountContainer = Read-Host 'Storage Account Container'
$winImageName = (Get-AzureVMImage | where {$_.Label -like "Windows Server 2008 R2 SP1*"} | sort PublishedDate -Descending)[0].ImageName
$sqlImageName = (Get-AzureVMImage | where {$_.Label -like "SQL Server 2012 SP1 Enterprise*"} | sort PublishedDate -Descending)[0].ImageName
$dcServerName = Read-Host 'Domain Controller Server Name'
$dcServiceName = Read-Host 'Domain Controller Service Name'
$availabilitySetName = Read-Host 'Availability Set Name'
$vmAdminUser = Read-Host 'VM Admin User'
$vmAdminPassword = Read-Host 'VM Admin Password' 
$workingDir = Read-Host 'Working Dir (i.e: c:\scripts\)'

#Create Azure Affinity Group
New-AzureAffinityGroup -Name $affinityGroupName -Location $location -Description $affinityGroupDescription -Label $affinityGroupLabel

#Create Azure VNet
Set-AzureVNetConfig -ConfigurationPath $networkConfigPath

#Create new Azure Storage Account
New-AzureStorageAccount -StorageAccountName $storageAccountName -Label $storageAccountLabel -AffinityGroup $affinityGroupName 

#Set Storage Account as Current Storage
Set-AzureSubscription -SubscriptionName (Get-AzureSubscription).SubscriptionName -CurrentStorageAccount $storageAccountName

#Create Domain Controller
New-AzureVMConfig -Name $dcServerName -InstanceSize Medium -ImageName $winImageName -MediaLocation "$storageAccountContainer$dcServerName.vhd" -DiskLabel "OS" | Add-AzureProvisioningConfig -Windows -DisableAutomaticUpdates -AdminUserName $vmAdminUser -Password $vmAdminPassword | New-AzureVM -ServiceName $dcServiceName –AffinityGroup $affinityGroupName -VNetName $virtualNetworkName

#Wait for Domain Controller to be created.
$VMStatus = Get-AzureVM -ServiceName $dcServiceName -Name $dcServerName

While ($VMStatus.InstanceStatus -ne "ReadyRole")
{
    write-host "Waiting for " $VMStatus.Name "... Current Status = " $VMStatus.InstanceStatus
    Start-Sleep -Seconds 15
    $VMStatus = Get-AzureVM -ServiceName $dcServiceName -Name $dcServerName
}

Get-AzureRemoteDesktopFile `
    -ServiceName $dcServiceName `
    -Name $dcServerName `
    -LocalPath "$workingDir$dcServerName.rdp" 

#Domain Controller Prep
    
echo "On the Domain Controller run the create_dc.ps1 script"
pause


#Build SQL Server machines
$domainName= "corp"
$FQDN = "corp.contoso.com"
$subnetName = "Back"
$sqlServiceName =  Read-Host 'Unique SQL Service Name'
$quorumServerName =  Read-Host 'Quorum Server Name'
$sql1ServerName =  Read-Host 'SQL Server 1 Name'
$sql2ServerName =  Read-Host 'SQL Server 2 Name'
$availabilitySetName =  Read-Host 'Availablity Set Name'
$dataDiskSize = 100
$dnsSettings = New-AzureDns -Name "ContosoBackDNS" -IPAddress "10.10.0.4" #Note you will need to change this variable if you are using a different subnet

#Create Quorum Server
New-AzureVMConfig -Name $quorumServerName -InstanceSize Medium -ImageName $winImageName -MediaLocation "$storageAccountContainer$quorumServerName.vhd" -AvailabilitySetName $availabilitySetName -DiskLabel "OS" | Add-AzureProvisioningConfig -WindowsDomain -AdminUserName $vmAdminUser -Password $vmAdminPassword -DisableAutomaticUpdates -Domain $domainName -JoinDomain $FQDN -DomainUserName $vmAdminUser -DomainPassword $vmAdminPassword |Set-AzureSubnet -SubnetNames $subnetName |New-AzureVM -ServiceName $sqlServiceName –AffinityGroup $affinityGroupName -VNetName $virtualNetworkName -DnsSettings $dnsSettings

# Create SQL1...
New-AzureVMConfig -Name $sql1ServerName -InstanceSize Large -ImageName $sqlImageName -MediaLocation "$storageAccountContainer$sql1ServerName.vhd" -AvailabilitySetName $availabilitySetName -HostCaching "ReadOnly" -DiskLabel "OS" |Add-AzureProvisioningConfig -WindowsDomain -AdminUserName $vmAdminUser -Password $vmAdminPassword -DisableAutomaticUpdates -Domain $domainName -JoinDomain $FQDN -DomainUserName $vmAdminUser -DomainPassword $vmAdminPassword |Set-AzureSubnet -SubnetNames $subnetName |Add-AzureEndpoint  -Name "SQL" -Protocol "tcp" -PublicPort 1 -LocalPort 1433 |  New-AzureVM -ServiceName $sqlServiceName

# Create SQL2...
New-AzureVMConfig -Name $sql2ServerName -InstanceSize Large -ImageName $sqlImageName -MediaLocation "$storageAccountContainer$sql2ServerName.vhd" -AvailabilitySetName $availabilitySetName -HostCaching "ReadOnly" -DiskLabel "OS" |Add-AzureProvisioningConfig -WindowsDomain -AdminUserName $vmAdminUser -Password $vmAdminPassword -DisableAutomaticUpdates -Domain $domainName -JoinDomain $FQDN -DomainUserName $vmAdminUser -DomainPassword $vmAdminPassword |Set-AzureSubnet -SubnetNames $subnetName | Add-AzureEndpoint -Name "SQL" -Protocol "tcp"  -PublicPort 2 -LocalPort 1433 | New-AzureVM -ServiceName $sqlServiceName

#Monitor and wait for VMs to start
Foreach ($VM in $VMs = Get-AzureVM -ServiceName $sqlServiceName)
{
    write-host "Waiting for " $VM.Name "..."

    # Loop until the VM status is "ReadyRole"
    While ($VM.InstanceStatus -ne "ReadyRole")
    {
        write-host "  Current Status = " $VM.InstanceStatus
        Start-Sleep -Seconds 15
        $VM = Get-AzureVM -ServiceName $VM.ServiceName -Name $VM.InstanceName
    }

    write-host "  Current Status = " $VM.InstanceStatus

    # Download remote desktop file
    Get-AzureRemoteDesktopFile -ServiceName $VM.ServiceName -Name $VM.InstanceName -LocalPath "$workingDir$($VM.InstanceName).rdp"
}

#Prep Quorum Server
echo "Run the prep_quorum_server.ps1 on the Quorum Server"
pause

#Prep the SQL Servers
echo "Run the prep_sql_server.ps1 on both SQL Servers"

echo "Now you can create your availability groups"

exit