--Init Mirror
--run on SQLServer-2
CREATE ENDPOINT Endpoint_Mirroring  
    STATE=STARTED   
    AS TCP (LISTENER_PORT=7022)   
    FOR DATABASE_MIRRORING (ROLE=ALL)  
GO  
--Partners under same domain user; login already exists in master.  
--Create a login for the witness server instance,  
--which is running as Somedomain\witnessuser:  
USE master ;   
--Grant connect permissions on endpoint to login account of witness.  
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO 'corp\administrator';  
--Grant connect permissions on endpoint to login account of partners.  
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO 'corp\administrator';  
GO  

EXIT;