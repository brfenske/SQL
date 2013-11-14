SELECT RIGHT(SCHEMA_NAME(t.schema_id), 32) AS SchemaName
	, RIGHT(t.NAME, 40) AS TableName
	, REPLACE(CONVERT(VARCHAR(15), CAST(i.rows AS MONEY), 1), '.00', '') AS [Row Count]
FROM sys.tables AS t
INNER JOIN sys.sysindexes AS i ON t.object_id = i.id
	AND i.indid < 2
ORDER BY SchemaName
	, TableName
