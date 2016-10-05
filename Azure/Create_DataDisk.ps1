$numOfDisks=16
$cloudServiceName="SQL-8CORE"
$diskSizeInGB=25
$vmName="SQL4-8CORE"
 
$vmConfig = Get-AzureVM -ServiceName $cloudServiceName -Name $vmName
for ($index = 0; $index -lt $numOfDisks; $index++)
{ 
    $diskLabel = "$cloudServiceName$index"
    $vmConfig = $vmConfig | Add-AzureDataDisk   -CreateNew `
                                                -DiskSizeInGB $diskSizeInGB `
                                                -DiskLabel $diskLabel `
                                                -LUN $index  
}
 
$vmConfig | Update-AzureVM
 

