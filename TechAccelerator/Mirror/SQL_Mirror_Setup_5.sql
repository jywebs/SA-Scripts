--Init Witness
-- run on SQLServer-3
CREATE ENDPOINT Endpoint_Mirroring  
    STATE=STARTED   
    AS TCP (LISTENER_PORT=7022)   
    FOR DATABASE_MIRRORING (ROLE=WITNESS)  
GO  
--Create a login for the partner server instances,  
--which are both running as Mydomain\dbousername:  
USE master ;  
GO  
CREATE LOGIN [Mydomain\dbousername] FROM WINDOWS ;  
GO  
--Grant connect permissions on endpoint to login account of partners.  
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO 'corp\administrator';  
GO  

EXIT;