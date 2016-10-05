$cloudServiceName="SQL-4CORE"
$vmName="SQL2-4CORE"

$vmConfig = Get-AzureVM -ServiceName $cloudServiceName -Name $vmName
$dataDisk = ($vmConfig | Get-AzureDataDisk )

$dataDisk | foreach { Remove-AzureDataDisk -VM $vmConfig.VM -LUN $_.Lun -DeleteVHD }

$vmConfig | Update-AzureVM

$cloudServiceName="SQL-4CORE"
$vmName="SQL3-4CORE"

$vmConfig = Get-AzureVM -ServiceName $cloudServiceName -Name $vmName
$dataDisk = ($vmConfig | Get-AzureDataDisk )

$dataDisk | foreach { Remove-AzureDataDisk -VM $vmConfig.VM -LUN $_.Lun -DeleteVHD }

$vmConfig | Update-AzureVM

$cloudServiceName="SQL-4CORE"
$vmName="SQL4-4CORE"

$vmConfig = Get-AzureVM -ServiceName $cloudServiceName -Name $vmName
$dataDisk = ($vmConfig | Get-AzureDataDisk )

$dataDisk | foreach { Remove-AzureDataDisk -VM $vmConfig.VM -LUN $_.Lun -DeleteVHD }

$vmConfig | Update-AzureVM

$cloudServiceName="SQL-4CORE"
$vmName="SQL5-4CORE"

$vmConfig = Get-AzureVM -ServiceName $cloudServiceName -Name $vmName
$dataDisk = ($vmConfig | Get-AzureDataDisk )

$dataDisk | foreach { Remove-AzureDataDisk -VM $vmConfig.VM -LUN $_.Lun -DeleteVHD }

$vmConfig | Update-AzureVM