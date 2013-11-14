SET NOCOUNT ON 

SELECT  'SELECT CAST(''' + s.[name] + '.' + t.[name] + ''' AS VARCHAR(35)) AS [Table], CAST([Text] AS VARCHAR(30)) AS [Text], CAST([Description] AS VARCHAR(50)) AS [Description] FROM ' + s.[name] + '.' + t.[name]
FROM    sys.tables t
        JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE   t.[name] LIKE '%Ref%'
ORDER BY s.[name],
        t.[name]
