##################################
##  Prep SQL Server             ##
##  prep_sql_server.ps1         ##
##################################



Import-Module ServerManager
        
Add-WindowsFeature Failover-Clustering 

net localgroup administrators "CORP\Install" /Add
        
Set-ExecutionPolicy -Execution RemoteSigned -Force
    
Import-Module -Name "sqlps" -DisableNameChecking

net localgroup administrators "CORP\Install" /Add
        
Invoke-SqlCmd -Query "EXEC sp_addsrvrolemember 'CORP\Install', 'sysadmin'" -ServerInstance "."

Invoke-SqlCmd -Query "CREATE LOGIN [NT AUTHORITY\SYSTEM] FROM WINDOWS" -ServerInstance "."
        
Invoke-SqlCmd -Query "GRANT ALTER ANY AVAILABILITY GROUP TO [NT AUTHORITY\SYSTEM] AS SA" -ServerInstance "." 
        
Invoke-SqlCmd -Query "GRANT CONNECT SQL TO [NT AUTHORITY\SYSTEM] AS SA" -ServerInstance "."

Invoke-SqlCmd -Query "GRANT VIEW SERVER STATE TO [NT AUTHORITY\SYSTEM] AS SA" -ServerInstance "."

netsh advfirewall firewall add rule name='SQL Server (TCP-In)' program='C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\sqlservr.exe' dir=in action=allow protocol=TCP

logoff.exe"