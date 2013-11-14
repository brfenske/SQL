CREATE TABLE #t (
	HostName VARCHAR(50)
	, DBName SYSNAME NOT NULL
	, [Name] [varchar](50) NULL
	, [DisplayName] [varchar](255) NULL
	, [VersionNumber] [varchar](25) NOT NULL
	, [ContentVersionPath] [varchar](1000) NULL
	, [UserContentPath] [varchar](1000) NULL
	)

EXEC sp_msforeachdb 'USE [?]; IF OBJECT_ID(''dbo.AppUser'') IS NOT NULL 
    INSERT INTO #t (HostName
        , DBName
        , [Name]
        , [DisplayName]
        , [VersionNumber]
        , [ContentVersionPath]
        , [UserContentPath]) 
    SELECT @@SERVERNAME AS HostName
      , ''?'' AS DatabaseName
      , [Name] AS Edition
      , [DisplayName]
      , [VersionNumber]
      , [ContentVersionPath]
      , [UserContentPath]
      FROM [?].[dbo].[ContentVersion]
      WHERE Active = 1'

SELECT *
FROM #t;

DROP TABLE #t
