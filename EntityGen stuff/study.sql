SELECT   distinct '<StoredProcedure commandName="' + s.CommandName +
         '" sqlSprocName="' + s.CommandText +
         '" oraclePackage="' + replace(substring(o.CommandText, 0, charindex('.', o.CommandText)), 'cgasp', 'cgasp') +
         '" oracleSprocName="' + substring(o.CommandText, charindex('.', o.CommandText) + 1, 99999) + '" />' + CHAR(13) + CHAR(10)
         --replace(replace(replace(replace(replace(s.CommandText, '[dbo]', ''), '[', ''), ']', ''), '.', ''), 'cgasp_', '') AS stext,
         --substring(o.CommandText, charindex('.', o.CommandText) + 1, 99999) AS otext
FROM     sqlsprocs AS s
         LEFT OUTER JOIN
         oraclesprocs AS o
         ON s.CommandName = o.CommandName
WHERE    replace(replace(replace(replace(replace(s.CommandText, '[dbo]', ''), '[', ''), ']', ''), '.', ''), 'cgasp_', '') <> substring(o.CommandText, charindex('.', o.CommandText) + 1, 99999)
--ORDER BY s.CommandName;




--SELECT DISTINCT SC.NAME
-- FROM SYS.OBJECTS SO INNER JOIN SYS.COLUMNS SC
-- ON SO.OBJECT_ID = SC.OBJECT_ID 
--WHERE SO.TYPE = 'U' and so.name not like 'spt%' and schema_id <> 7
-- ORDER BY SC.NAME

SELECT s.name, p.name FROM sys.procedures p 
join sys.schemas s on p.schema_id = s.schema_id 
WHERE p.[TYPE] = 'P' 
AND p.is_ms_shipped = 0 
AND p.name NOT LIKE 'sp[_]%diagram%' 
AND p.SCHEMA_ID <> 7 
order by s.name, p.name


