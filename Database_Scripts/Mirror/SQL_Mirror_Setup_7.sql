--init principal mirror
--run on SQLSERVER-1
ALTER DATABASE AdventureWorks   
    SET PARTNER = 'TCP://SQLSERVER-2:7022'  
GO  

--Init Witness
ALTER DATABASE mirror   
    SET WITNESS =   
    'TCP://SQLSERVER-3:7022'  
GO  

EXIT;