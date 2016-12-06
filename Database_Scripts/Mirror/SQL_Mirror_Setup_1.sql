--Create Database and init backup
--Run on SQLServer-1

Create DATABASE mirror
GO

USE [mirror]
GO

/****** Object:  Table [dbo].[oltp1]    Script Date: 10/18/2016 1:33:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[oltp1](
	[id] [int] NOT NULL,
	[k] [int] NOT NULL CONSTRAINT [DF_oltp1_k]  DEFAULT ((0)),
	[c] [varchar](120) NOT NULL,
	[pad] [varchar](60) NOT NULL,
 CONSTRAINT [PK_oltp1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

BACKUP DATABASE mirror   
    TO DISK = '\\SQLServer-1\backup\mirror.bak'   
    WITH FORMAT  
GO 
BACKUP LOG mirror   
    TO DISK = '\\SQLServer-1\backup\mirror.bak'   
GO  

EXIT;