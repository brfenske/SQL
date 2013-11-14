WITH Fkeys
AS (
	SELECT DISTINCT onTable = onTable.[name], againstTable = againstTable.[name]
	FROM sys.sysforeignkeys fk
	INNER JOIN sys.sysobjects onTable ON fk.fkeyid = onTable.id
	INNER JOIN sys.sysobjects againstTable ON fk.rkeyid = againstTable.id
	WHERE 1 = 1
		AND againstTable.TYPE = 'U'
		AND onTable.TYPE = 'U'
		-- ignore self joins; they cause an infinite recursion
		AND onTable.[name] <> againstTable.[name]
	), TablePairs
AS (
	SELECT onTable = o.[name], againstTable = FKeys.againstTable
	FROM sys.objects o
	LEFT JOIN FKeys ON o.[name] = FKeys.onTable
	INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
	WHERE 1 = 1
		AND o.type = 'U'
		AND o.[name] NOT LIKE 'sys%'
	), Recursion
AS (
	-- base case
	SELECT TableName = onTable, RecursionLevel = 1
	FROM TablePairs
	WHERE 1 = 1
		AND againstTable IS NULL
	-- recursive case
	
	UNION ALL
	
	SELECT TableName = onTable, RecursionLevel = r.RecursionLevel + 1
	FROM TablePairs d
	INNER JOIN Recursion r ON d.againstTable = r.TableName
	)
SELECT 'SELECT ''[' + s.SchemaName + '].[' + s.TableName + ']''; DELETE FROM [' + s.SchemaName + '].[' + s.TableName + ']; ' + CASE 
		WHEN EXISTS (
				SELECT OBJECT_NAME(OBJECT_ID) AS TABLE_NAME
				FROM SYS.COLUMNS
				WHERE COLUMNPROPERTY(OBJECT_ID, [name], 'IsIdentity') = 1
					AND OBJECT_NAME(OBJECT_ID) = s.TableName
				)
			THEN 'DBCC CHECKIDENT (''' + s.SchemaName + '.' + s.TableName + ''', RESEED, ' + CAST(ABS(CHECKSUM(NEWID()) / 1000) AS VARCHAR(20)) + ');'
		ELSE ''
		END AS DBC
FROM Recursion r
INNER JOIN (
	SELECT SCHEMA_NAME(t.schema_id) AS SchemaName, t.NAME AS TableName
	FROM sys.tables AS t
	INNER JOIN sys.sysindexes AS i ON t.object_id = i.id
		AND i.indid < 2
		AND [rows] = 0
	) s ON r.TableName = s.TableName
GROUP BY s.SchemaName, s.TableName
ORDER BY MAX(r.RecursionLevel) DESC, s.TableName DESC
