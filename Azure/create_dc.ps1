##################################
##  Create Domain Controler     ##
##  create_dc.ps1               ##
##################################

echo "Script is to be used with the the create always on configuration"
echo "The domain that is corp.contoso.com if you want a differnt domain you will need to modify the script."
echo "ready to start?"
pause

dcpromo.exe /unattend /ReplicaOrNewDomain:Domain /NewDomain:Forest /NewDomainDNSName:corp.contoso.com /ForestLevel:4 /DomainNetbiosName:CORP /DomainLevel:4 /InstallDNS:Yes /ConfirmGc:Yes /CreateDNSDelegation:No /DatabasePath:"C:\Windows\NTDS" /LogPath:"C:\Windows\NTDS" /SYSVOLPath:"C:\Windows\SYSVOL" /SafeModeAdminPassword:"Contoso!000"
	
Allow the DC to restart
	
After restart login as the domain controller created in previous step
	
Import-Module ActiveDirectory
$pwd = ConvertTo-SecureString "Contoso!000" -AsPlainText -Force
New-ADUser -Name 'Install' -AccountPassword  $pwd -PasswordNeverExpires $true -ChangePasswordAtLogon $false -Enabled $true
New-ADUser -Name 'SQLSvc1' -AccountPassword  $pwd -PasswordNeverExpires $true -ChangePasswordAtLogon $false -Enabled $true
New-ADUser -Name 'SQLSvc2' -AccountPassword  $pwd -PasswordNeverExpires $true -ChangePasswordAtLogon $false -Enabled $true

cd ad:
$sid = new-object System.Security.Principal.SecurityIdentifier (Get-ADUser "Install").SID
$guid = new-object Guid bf967a86-0de6-11d0-a285-00aa003049e2
$ace1 = new-object System.DirectoryServices.ActiveDirectoryAccessRule $sid,"CreateChild","Allow",$guid,"All"
$corp = Get-ADObject -Identity "DC=corp,DC=contoso,DC=com"
$acl = Get-Acl $corp
$acl.AddAccessRule($ace1)
Set-Acl -Path "DC=corp,DC=contoso,DC=com" -AclObject $acl"