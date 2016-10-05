Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

Connect-MsolService

#Make sure passwords do not expire
#Get-MsolUser | Set-MsolUser –PasswordNeverExpires $False

#Make sure users require strong passwords.
#Get-MsolUser | Set-MsolUser -StrongPasswordRequired $True

#set owners of groups

$OwnerList=@('jacy.york@scalearc.com','bobby.brown@scalearc.com','agustin.rios@scalearc.com','sanjay.naikwadi@scalearc.com','subramani.thevar@scalearc.com')
Get-DistributionGroup | Set-DistributionGroup -ManagedBy $OwnerList –BypassSecurityGroupManagerCheck  

#Set organization
#Set-User -Identity "jacy.york@scalearc.com" -Company "ScaleArc" 