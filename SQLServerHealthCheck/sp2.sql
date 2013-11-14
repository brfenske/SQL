CREATE PROC [dbo].[chk_Db_Health_mssql] 
AS
BEGIN
  set nocount on
  Create Table #DBDetails
   (dbName sysname,
    dbSize varchar(50),
    dbOwner sysname,
    dbId smallint,
    dbCreate datetime,
    dbStatus varchar(2000),
    dbCmptLvl int)
  
  Insert into #DBDetails Exec sp_helpdb

  Select *,'******* Error: Database need to be checked!...*****'
  from #DBDetails 
  where ((CHARINDEX ('ONLINE',dbStatus ,1)  = 0) or
         (CHARINDEX ('READ_WRITE',dbStatus ,1)  = 0 )OR
         (CHARINDEX ('MULTI_USER',dbStatus ,1)  = 0) or
         (CHARINDEX ('IsAutoShrink',dbStatus ,1)  > 0))
  union all 
  select [name] , 'NA', 'NA', dbid,crdate, 'OFFLINE!',cmptlevel
   , '******* Error: Database need to be checked!...*****'
   from sysdatabases
   WHERE name not in (select dbName from #DBDetails)
       
  drop table #DBDetails
  
END
