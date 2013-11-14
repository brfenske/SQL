USE iCCG
GO

SELECT 'SET ANSI_NULLS ON'
       ,'GO'
       ,'SET QUOTED_IDENTIFIER ON'
       ,'GO'
       ,'IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[iCCG].[' + TABLE_NAME + 'RetrieveBy' + COLUMN_NAME +']'') AND type in (N''P'', N''PC''))'
       ,'    DROP PROCEDURE [iCCG].[' + TABLE_NAME + 'RetrieveBy' + COLUMN_NAME + ']'
       ,'GO'
       ,'CREATE PROCEDURE [iCCG].[' + TABLE_NAME + 'RetrieveBy' + COLUMN_NAME + ']'
       ,'    ('
       ,'    @' + COLUMN_NAME + ' INT'
       ,'    ,@Debug BIT = 0'
       ,'    )'
       ,'AS '
       ,'    BEGIN'
       ,'        DECLARE @errCode INT ;'
       ,'        DECLARE @procName VARCHAR(50) ;'
       ,'        SET @errCode = 0 ;'
       ,'        SET @procName = ''' + TABLE_NAME + 'RetrieveBy' + COLUMN_NAME + ''';'
       ,'        IF @Debug = 1 '
       ,'            BEGIN'
       ,'                PRINT @procName + '': Selecting specified [' + TABLE_NAME + '] record...'' ;'
       ,'            END'
       ,'        SELECT ' + dbo.TableColumnsAsList(TABLE_NAME)
       ,'        FROM [' + TABLE_NAME + ']'
       ,'        WHERE [' + COLUMN_NAME + '] = @' + COLUMN_NAME + ' ;'
       ,'        SELECT @errCode = @errCode + @@ERROR ;'
       ,'        IF @errCode <> 0 '
       ,'            RETURN -1 ;'
       ,'        ELSE '
       ,'            RETURN 0 ;'
       ,'    END'
       ,CHAR(13) + CHAR(10)
FROM    INFORMATION_SCHEMA.COLUMNS
WHERE   COLUMN_NAME LIKE '%ID'
        AND COLUMN_NAME <> TABLE_NAME + 'ID'
        AND TABLE_NAME NOT IN ('sysdiagrams')
ORDER BY TABLE_NAME
       ,COLUMN_NAME
