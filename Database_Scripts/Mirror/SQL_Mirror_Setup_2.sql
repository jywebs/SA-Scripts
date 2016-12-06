--Prep Mirror Server
--run on SQLServer-2
RESTORE DATABASE TESTPROJECT 
FROM DISK = N'\\SQLServer-1\Backup\mirror.bak'
with NORECOVERY
GO

RESTORE LOG AdventureWorks   
    FROM DISK = '\\SQLServer-1\Backup\mirror.bak'   
    WITH FILE=1, NORECOVERY  
GO  

EXIT;