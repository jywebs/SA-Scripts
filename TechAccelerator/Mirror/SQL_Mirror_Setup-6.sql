--init mirror partnership
--run on SQLServer-2
ALTER DATABASE mirror   
    SET PARTNER =   
    'TCP://SQLServer-1:7022'  
GO  

EXIT;