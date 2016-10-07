
Connect-MsolService

$FirstName = Read-Host "Enter Users First Name"
$LastName = Read-Host "Enter Users Last Name"
$DisplayName = "$FirstName $LastName"
$UserPrincipalName = Read-Host "Enter Users Email Address" 
$UsageLocation = Read-Host "Location (US) or India(IN)?"
New-MsolUser -DisplayName "$DisplayName" –UserPrincipalName "$UserPrincipalName" –UsageLocation "$UsageLocation" | Set-MsolUserLicense -AddLicenses "scalearcinc:MIDSIZEPACK"

$LiveCred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session
Get-DistributionGroup

$addgroups = Read-Host " Add user to a group? <Y/N>"

set-user -identity $UserPrincipalName -company "ScaleArc"