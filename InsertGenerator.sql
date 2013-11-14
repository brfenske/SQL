USE [iCCG]
GO

/****** Object:  StoredProcedure [iCCG].[InsertGenerator]    Script Date: 02/01/2011 14:11:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE PROC [iCCG].[InsertGenerator]
    (
     @tableName VARCHAR(100)
    )
AS
    DECLARE cursCol CURSOR FAST_FORWARD FOR 
    SELECT column_name,data_type, TABLE_SCHEMA FROM information_schema.columns WHERE table_name = @tableName
    OPEN cursCol
    DECLARE @columns NVARCHAR(3000) --for storing the first half of INSERT statement
    DECLARE @values NVARCHAR(3000) --for storing the data (VALUES) related statement
    DECLARE @dataType NVARCHAR(1000) --data types returned for respective columns
    SET @columns = 'INSERT ' + @tableName + '('
    SET @values = ''

    DECLARE @colName NVARCHAR(50)
    DECLARE @schemaName NVARCHAR(50)

    FETCH NEXT FROM cursCol INTO @colName, @dataType, @schemaName

    IF @@fetch_status <> 0 
        BEGIN
            PRINT 'Table ' + @tableName + ' not found, processing skipped.'
            CLOSE curscol
            DEALLOCATE curscol
            RETURN
        END

    WHILE @@FETCH_STATUS = 0 
        BEGIN
            IF @dataType IN ('varchar', 'char', 'nchar', 'nvarchar') 
                BEGIN
	                SET @values = @values + '''' + '''+isnull(''''' + '''''+' + @colName + '+''''' + ''''',''NULL'')+'',''+'
                END
            ELSE 
                IF @dataType IN ('text', 'ntext') --if the datatype is text or something else 
                    BEGIN
                        SET @values = @values + '''''''''+isnull(cast(' + @colName + ' as varchar(2000)),'''')+'''''',''+'
                    END
                ELSE 
                    IF @dataType = 'money' --because money doesn't get converted from varchar implicitly
                        BEGIN
                            SET @values = @values + '''convert(money,''''''+isnull(cast(' + @colName + ' as varchar(200)),''0.0000'')+''''''),''+'
                        END
                    ELSE 
                        IF @dataType = 'datetime' 
                            BEGIN
                                SET @values = @values + '''convert(datetime,' + '''+isnull(''''' + '''''+convert(varchar(200),' + @colName + ',121)+''''' + ''''',''NULL'')+'',121),''+'
                            END
                        ELSE 
                            IF @dataType = 'image' 
                                BEGIN
                                    SET @values = @values + '''''''''+isnull(cast(convert(varbinary,' + @colName + ') as varchar(6)),''0'')+'''''',''+'
                                END
                            ELSE --presuming the data type is int,bit,numeric,decimal 
                                BEGIN
                                    SET @values = @values + '''' + '''+isnull(''''' + '''''+convert(varchar(200),' + @colName + ')+''''' + ''''',''NULL'')+'',''+'
                                END

            SET @columns = @columns + @colName + ', '
            FETCH NEXT FROM cursCol INTO @colName, @dataType, @schemaName
        END

    DECLARE @query NVARCHAR(4000)
    SET @query = 'SELECT ''' + SUBSTRING(@columns, 0, LEN(@columns)) + ') VALUES(''+ ' + SUBSTRING(@values, 0, LEN(@values) - 2) + '''+'')'' FROM ' + @schemaName + '.' + @tableName
    EXEC sp_executesql @query

    CLOSE cursCol
    DEALLOCATE cursCol



GO


