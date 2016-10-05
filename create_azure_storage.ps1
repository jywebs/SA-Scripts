#Storage Account creation for Azure

Import-Module "C:\Program Files (x86)\Microsoft SDKs\Windows Azure\PowerShell\Azure\Azure.psd1"
Get-AzurePublishSettingsFile

$settings_file = Read-Host 'Enter location of the PublishSettingsFile: '
Import-AzurePublishSettingsFile $settings_file 

$createaffinity = Read-Host 'Use existing Affinity Group? (y/n): '
if ($createaffinity -like "n") 
{
	#create affinity group vars
	$location = "West US"
	$affinityGroupName = Read-Host 'Enter affinity group name: '
	$affinityGroupDescription = Read-Host 'Enter affinity group description: '
	$affinityGroupLabel = Read-Host 'Enter affinity group label: '
	
	#Create Affinity Group
	New-AzureAffinityGroup -Name $affinityGroupName -Location $location -Description $affinityGroupDescription -Label $affinityGroupLabel
}
ElseIf ($createaffinity -like "y")
{
	$affinityGroupName = Read-Host 'Enter existing affinity group name: '
}

#Create storage Account Vars
$storageAccountName = Read-Host 'Enter unique storage account name: '
$storageAccountLabel = Read-Host 'Enter storage account label: ' 
$storageAccountContainer = "https://" + $storageAccountName + ".blob.core.windows.net/vhds/" 

#Create Storage Account
New-AzureStorageAccount -StorageAccountName $storageAccountName -Label $storageAccountLabel -AffinityGroup $affinityGroupName
Set-AzureSubscription -SubscriptionName (Get-AzureSubscription).SubscriptionName -CurrentStorageAccount $storageAccountName
New-AzureStorageContainer vhds -Permission Blob

echo $storageAccountContainer