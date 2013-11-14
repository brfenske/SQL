select 'exec master..xp_cmdshell' 
            + ' '''
            + 'bcp'
            + ' ' + TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME 
            + ' out'
            + ' c:\bcp\'
            + TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME + '.txt' 
            + ' -N'
            + ' -T'
            + ' -S' + @@servername
            + ''''
from INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Ref%' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME
