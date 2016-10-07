#Upload VHD file

#Get account information
Get-AzurePublishSettingsFile
$publistsettings = Read-Hosts 'Enter Publish Settings File location: '
Import-AzurePublishSettingsFile $publistsettings

#upload image vhd to Azure
$vhdname = Read-Host 'What do you want the blob name to be (ie. mssql.vhd): '
$container = Read-Host 'Enter container location (i.e http://jacy.blob.core.windows.net/vhds): '
$imagelocation = Read-Host 'Enter location of the local VHD file: '

Add-AzureVhd -Destination $container/$vhdname -LocalFilePath $imagelocation