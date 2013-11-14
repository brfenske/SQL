-- #########################################################
-- Author:	www.sqlbook.com
-- Copyright:	(c) www.sqlbook.com. You are free to use and redistribute
--		this script as long as this comments section with the 
--		author and copyright details are not altered.
-- Purpose:	For a specified user defined table (or all user defined
--		tables) in the database this script generates 4 Stored 
--		Procedure definitions with different Procedure name 
--		suffixes:
--		1) List all records in the table (suffix of  RetrieveAll)
--		2) Get a specific record from the table (suffix of Retrieve)
--		3) UPDATE or INSERT (UPSERT) - (suffix of Upsert)
--		4) DELETE a specified row - (suffix of Deactivate)
--		e.g. For a table called Location the script will create
--		procedure definitions for the following procedures:
--		dbo.LocationRetrieveAll
--		dbo.LocationRetrieve
--		dbo.LocationUpsert
--		dbo.LocationDeactivate
-- Notes: 	The stored procedure definitions can either be printed
--		to the screen or executed using EXEC sp_ExecuteSQL.
--		The stored proc names are prefixed with  to avoid 
--		conflicts with system stored procs.
-- Assumptions:	- This script assumes that the primary key is the first
--		column in the table and that if the primary key is
--		an integer then it is an IDENTITY (autonumber) field.
--		- This script is not suitable for the link tables
--		in the middle of a many to many relationship.
--		- After the script has run you will need to add
--		an ORDER BY clause into the 'RetrieveAll' procedures
--		according to your needs / required sort order.
--		- Assumes you have set valid values for the 
--		config variables in the section immediately below
-- #########################################################

-- Significantly modified by Brian Fenske, Milliman Care Guidelines, Feb 2012

-- ##########################################################
/* SET CONFIG VARIABLES THAT ARE USED IN SCRIPT */
-- ##########################################################

-- Do we want to generate the SP definitions for every user defined
-- table in the database or just a single specified table?
-- Assign a blank string - '' for all tables or the table name for
-- a single table.
DECLARE @GenerateProcsFor VARCHAR(100) ;
--SET @GenerateProcsFor = 'CaseProblemNote'
SET @GenerateProcsFor = '' ;

-- which database do we want to create the procs for?
-- Change both the USE and SET lines below to set the datbase name
-- to the required database.
USE CareWebQIDb ;
DECLARE @DatabaseName VARCHAR(100) ;
SET @DatabaseName = 'CareWebQIDb' ;

-- do we want the script to print out the CREATE PROC statements
-- or do we want to execute them to actually create the procs?
-- Assign a value of either 'Print' or 'Execute'
DECLARE @PrintOrExecute VARCHAR(10) ;
SET @PrintOrExecute = 'Print' ;


-- Is there a table name prefix i.e. 'tbl_' which we don't want
-- to include in our stored proc names?
DECLARE @TablePrefix VARCHAR(10) ;
SET @TablePrefix = '' ;

-- ##########################################################
/* END SETTING OF CONFIG VARIABLE 
-- do not edit below this line */
-- ##########################################################


-- DECLARE CURSOR containing all columns from user defined tables
-- in the database
DECLARE curTableColumns CURSOR FOR 
SELECT c.TABLE_SCHEMA, c.TABLE_NAME, c.COLUMN_NAME, c.DATA_TYPE, c.CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.Columns c INNER JOIN
INFORMATION_SCHEMA.Tables t ON c.TABLE_NAME = t.TABLE_NAME
WHERE t.Table_Catalog = @DatabaseName
AND t.TABLE_TYPE = 'BASE TABLE'
ORDER BY c.TABLE_SCHEMA, c.TABLE_NAME, c.ORDINAL_POSITION ;

-- Declare variables which will hold values from cursor rows
DECLARE @charLength INT ;
DECLARE @ColumnName VARCHAR(100) ;
DECLARE @ColumnNameCleaned VARCHAR(100) ;
DECLARE @CurrentTable VARCHAR(100)
DECLARE @DataType VARCHAR(30) ;
DECLARE @deactivate VARCHAR(4000) ;
DECLARE @fileName VARCHAR(255) ;
DECLARE @filePath VARCHAR(255) ;
DECLARE @FirstColumnDataType VARCHAR(30)
DECLARE @FirstColumnName VARCHAR(100)
DECLARE @FirstTable BIT
DECLARE @insert VARCHAR(4000) ;
DECLARE @insertValues VARCHAR(4000) ;
DECLARE @retrieveAll VARCHAR(4000) ;
DECLARE @ObjectName VARCHAR(100)
DECLARE @retrieve VARCHAR(4000) ;
DECLARE @TableName VARCHAR(100) ;
DECLARE @TablePrefixLength INT
DECLARE @TableSchema VARCHAR(100) ;
DECLARE @update VARCHAR(4000) ;
DECLARE @upsert VARCHAR(4000) ;

SET @CurrentTable = '' ;
SET @FirstTable = 1 ;
SET @TablePrefixLength = LEN(@TablePrefix) ;
SET @filePath = 'C:\sprocs' ;

-- open the cursor
OPEN curTableColumns

-- get the first row of cursor into variables
FETCH NEXT FROM curTableColumns INTO @TableSchema, @TableName, @ColumnName, @DataType, @charLength

-- loop through the rows of the cursor
WHILE @@FETCH_STATUS = 0 
    BEGIN
        SET @ColumnNameCleaned = REPLACE(@ColumnName, ' ', '') ;

		-- is this a new table?
        IF @TableName <> @CurrentTable 
            BEGIN
				-- if is the end of the last table
                IF @CurrentTable <> '' 
                    BEGIN
                        IF @GenerateProcsFor = ''
                            OR @GenerateProcsFor = @CurrentTable 
                            BEGIN
                                PRINT @TableSchema + '.' + @CurrentTable ;

								-- first add any syntax to end of the statement

                                SET @retrieveAll = @retrieveAll + CHAR(13) ;                                
                                SET @retrieveAll = @retrieveAll + CHAR(9) + 'FROM [' + @TableSchema + '].[' + @CurrentTable + ']' + CHAR(13) ;
                                SET @retrieveAll = @retrieveAll + CHAR(13) ;                                
                                SET @retrieveAll = @retrieveAll + CHAR(9) + 'SET NOCOUNT OFF;' + CHAR(13) ;
                                SET @retrieveAll = @retrieveAll + CHAR(13) ;                                
                                SET @retrieveAll = @retrieveAll + CHAR(9) + 'SELECT @errCode = @errCode + @@ERROR;' + CHAR(13) ;
                                SET @retrieveAll = @retrieveAll + CHAR(9) + 'IF @errCode <> 0' + CHAR(13) ;                                
                                SET @retrieveAll = @retrieveAll + CHAR(9) + CHAR(9) + 'RETURN -1;' + CHAR(13) ;                                
                                SET @retrieveAll = @retrieveAll + CHAR(9) + 'ELSE' + CHAR(13) ;                                
                                SET @retrieveAll = @retrieveAll + CHAR(9) + CHAR(9) + 'RETURN 0;' + CHAR(13) ;                                
                                SET @retrieveAll = @retrieveAll + 'END' + CHAR(13) ;                                
                                SET @retrieveAll = @retrieveAll + 'GO' + CHAR(13) ;                                
                                SET @retrieveAll = @retrieveAll + CHAR(13) ;                                
                                SET @retrieveAll = @retrieveAll + 'GRANT EXECUTE ON [' + @TableSchema + '].[' + @CurrentTable + '] TO [CWUser];' + CHAR(13) ;                                
                                SET @retrieveAll = @retrieveAll + 'GO' + CHAR(13) ;                                

                                SET @retrieve = @retrieve + CHAR(13) ;                                
                                SET @retrieve = @retrieve + CHAR(9) + 'FROM [' + @TableSchema + '].[' + @CurrentTable + ']' + CHAR(13) ;
                                SET @retrieve = @retrieve + CHAR(9) + 'WHERE [' + @FirstColumnName + '] = @' + REPLACE(@FirstColumnName, ' ', '') + CHAR(13) ;
                                SET @retrieve = @retrieve + CHAR(13) ;                                
                                SET @retrieve = @retrieve + CHAR(9) + 'SET NOCOUNT OFF;' + CHAR(13) ;
                                SET @retrieve = @retrieve + CHAR(13) ;                                
                                SET @retrieve = @retrieve + CHAR(9) + 'SELECT @errCode = @errCode + @@ERROR;' + CHAR(13) ;
                                SET @retrieve = @retrieve + CHAR(9) + 'IF @errCode <> 0' + CHAR(13) ;                                
                                SET @retrieve = @retrieve + CHAR(9) + CHAR(9) + 'RETURN -1;' + CHAR(13) ;                                
                                SET @retrieve = @retrieve + CHAR(9) + 'ELSE' + CHAR(13) ;                                
                                SET @retrieve = @retrieve + CHAR(9) + CHAR(9) + 'RETURN 0;' + CHAR(13) ;                                
                                SET @retrieve = @retrieve + 'END' + CHAR(13) ;                                
                                SET @retrieve = @retrieve + 'GO' + CHAR(13) ;                                
                                SET @retrieve = @retrieve + CHAR(13) ;                                
                                SET @retrieve = @retrieve + 'GRANT EXECUTE ON [' + @TableSchema + '].[' + @CurrentTable + '] TO [CWUser];' + CHAR(13) ;                                
                                SET @retrieve = @retrieve + 'GO' + CHAR(13) ;                                

								-- remove trailing comma and append the WHERE clause
                                SET @update = SUBSTRING(@update, 0, LEN(@update) - 1) + CHAR(13) + CHAR(9) + 'WHERE [' + @FirstColumnName + '] = @' + REPLACE(@FirstColumnName, ' ', '') + CHAR(13) ;

                                SET @insert = SUBSTRING(@insert, 0, LEN(@insert) - 1) + CHAR(13) + CHAR(9) + ')' + CHAR(13) ;
                                SET @insertValues = SUBSTRING(@insertValues, 0, LEN(@insertValues) - 1) + CHAR(13) + CHAR(9) + ')' ;
                                SET @insert = @insert + @insertValues ;

                                SET @upsert = @upsert + CHAR(13) + ')' + CHAR(13) + 'AS' + CHAR(13) ;
                                SET @upsert = @upsert + 'BEGIN' + CHAR(13) ;
                                SET @upsert = @upsert + CHAR(9) + 'SET NOCOUNT ON;' + CHAR(13) ;
                                SET @upsert = @upsert + CHAR(13) ;                                
                                IF @FirstColumnDataType IN ('int', 'bigint', 'smallint', 'tinyint', 'float', 'decimal') 
                                    BEGIN
                                        SET @upsert = @upsert + CHAR(9) + 'IF @' + REPLACE(@FirstColumnName, ' ', '') + ' = 0 BEGIN' + CHAR(13) ;
                                    END
                                ELSE 
                                    BEGIN
                                        SET @upsert = @upsert + CHAR(9) + 'IF @' + REPLACE(@FirstColumnName, ' ', '') + ' = '''' BEGIN' + CHAR(13) ;
                                    END ;
                                SET @upsert = @upsert + CHAR(9) + ISNULL(@insert, '') + CHAR(13) ;
                                SET @upsert = @upsert + CHAR(9) + 'SELECT SCOPE_IDENTITY() As InsertedID' + CHAR(13) ;
                                SET @upsert = @upsert + 'END' + CHAR(13) ;
                                SET @upsert = @upsert + 'ELSE BEGIN' + CHAR(13) ;
                                SET @upsert = @upsert + CHAR(9) + ISNULL(@update, '') + CHAR(13) ;
                                SET @upsert = @upsert + 'END' + CHAR(13) + CHAR(13) ;
                                SET @upsert = @upsert + CHAR(9) + 'SET NOCOUNT OFF;' + CHAR(13) ;
                                SET @upsert = @upsert + CHAR(13) ;                                
                                SET @upsert = @upsert + CHAR(9) + 'SELECT @errCode = @errCode + @@ERROR;' + CHAR(13) ;
                                SET @upsert = @upsert + CHAR(9) + 'IF @errCode <> 0' + CHAR(13) ;                                
                                SET @upsert = @upsert + CHAR(9) + CHAR(9) + 'RETURN -1;' + CHAR(13) ;                                
                                SET @upsert = @upsert + CHAR(9) + 'ELSE' + CHAR(13) ;                                
                                SET @upsert = @upsert + CHAR(9) + CHAR(9) + 'RETURN 0;' + CHAR(13) ;                                
                                SET @upsert = @upsert + 'END' + CHAR(13) ;                                
                                SET @upsert = @upsert + 'GO' + CHAR(13) ;                                
                                SET @upsert = @upsert + CHAR(13) ;                                
                                SET @upsert = @upsert + 'GRANT EXECUTE ON [' + @TableSchema + '].[' + @CurrentTable + '] TO [CWUser];' + CHAR(13) ;                                
                                SET @upsert = @upsert + 'GO' + CHAR(13) ;                                

								-- --------------------------------------------------
								-- now either print the SP definitions or 
								-- execute the statements to create the procs
								-- --------------------------------------------------
                                IF @PrintOrExecute <> 'Execute' 
                                    BEGIN
                                        IF (SUBSTRING(@CurrentTable, 1, 3) = 'Ref') 
                                            BEGIN
                                                SET @fileName = @TableSchema + '.' + @CurrentTable + 'RetrieveAll.StoredProcedure.sql' ;
                                                EXECUTE spWriteStringToFile 
                                                    @retrieveAll,
                                                    @filePath,
                                                    @fileName ;
                                            END ;

                                        SET @fileName = @TableSchema + '.' + @CurrentTable + 'Retrieve.StoredProcedure.sql' ;
                                        EXECUTE spWriteStringToFile 
                                            @retrieve,
                                            @filePath,
                                            @fileName
                                       
                                        SET @fileName = @TableSchema + '.' + @CurrentTable + 'Upsert.StoredProcedure.sql' ;
                                        EXECUTE spWriteStringToFile 
                                            @upsert,
                                            @filePath,
                                            @fileName
                                       
                                        SET @fileName = @TableSchema + '.' + @CurrentTable + 'Deactivate.StoredProcedure.sql' ;
                                        EXECUTE spWriteStringToFile 
                                            @deactivate,
                                            @filePath,
                                            @fileName
                                    END
                                ELSE 
                                    BEGIN
                                        EXEC sp_Executesql 
                                            @retrieveAll
                                        EXEC sp_Executesql 
                                            @retrieve
                                        EXEC sp_Executesql 
                                            @upsert
                                        EXEC sp_Executesql 
                                            @deactivate
                                    END
                            END -- end @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable
                    END
		
				-- update the value held in @CurrentTable
                SET @CurrentTable = @TableName
                SET @FirstColumnName = @ColumnName
                SET @FirstColumnDataType = @DataType
		
                IF @TablePrefixLength > 0 
                    IF SUBSTRING(@CurrentTable, 1, @TablePrefixLength) = @TablePrefix 
                        SET @ObjectName = RIGHT(@CurrentTable, LEN(@CurrentTable) - @TablePrefixLength)
                    ELSE 
                        SET @ObjectName = @CurrentTable
                ELSE 
                    SET @ObjectName = @CurrentTable
		
                IF @GenerateProcsFor = ''
                    OR @GenerateProcsFor = @CurrentTable 
                    BEGIN
					
						-- ----------------------------------------------------
						-- now start building the procedures for the next table
						-- ----------------------------------------------------
						
						-- RetrieveAll
                        SET @retrieveAll = 'IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[' + @TableSchema + '].[' + @currentTable + ']'') AND type in (N''P'', N''PC''))' + CHAR(13)
                        SET @retrieveAll = @retrieveAll + CHAR(9) + 'DROP PROCEDURE [' + @TableSchema + '].[' + @currentTable + '];' + CHAR(13)
                        SET @retrieveAll = @retrieveAll + 'GO' + CHAR(13) ; 
                        SET @retrieveAll = @retrieveAll + CHAR(13) ; 
                        SET @retrieveAll = @retrieveAll + 'SET ANSI_NULLS ON' + CHAR(13) ;
                        SET @retrieveAll = @retrieveAll + 'GO' + CHAR(13) ; 
                        SET @retrieveAll = @retrieveAll + 'SET QUOTED_IDENTIFIER ON' + CHAR(13) ;
                        SET @retrieveAll = @retrieveAll + 'GO' + CHAR(13) ; 
                        SET @retrieveAll = @retrieveAll + CHAR(13) ; 
                        SET @retrieveAll = @retrieveAll + 'CREATE PROCEDURE [' + @TableSchema + '].[' + @ObjectName + 'RetrieveAll]' + CHAR(13)
                        SET @retrieveAll = @retrieveAll + '(' + CHAR(13) ; 
                        SET @retrieveAll = @retrieveAll + CHAR(9) + '@Debug BIT = 0' + CHAR(13) ;
                        SET @retrieveAll = @retrieveAll + ')' + CHAR(13) ; 
                        SET @retrieveAll = @retrieveAll + 'AS' + CHAR(13) ;
                        SET @retrieveAll = @retrieveAll + 'BEGIN' + CHAR(13) ;
                        SET @retrieveAll = @retrieveAll + CHAR(9) + 'SET NOCOUNT ON;' + CHAR(13) ;
                        SET @retrieveAll = @retrieveAll + CHAR(13) ;
                        SET @retrieveAll = @retrieveAll + CHAR(9) + 'SELECT [' + @ColumnName + ']' ;
                        
						-- Retrieve
                        SET @retrieve = 'IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[' + @TableSchema + '].[' + @currentTable + ']'') AND type in (N''P'', N''PC''))' + CHAR(13)
                        SET @retrieve = @retrieve + CHAR(9) + 'DROP PROCEDURE [' + @TableSchema + '].[' + @currentTable + '];' + CHAR(13)
                        SET @retrieve = @retrieve + 'GO' + CHAR(13) ; 
                        SET @retrieve = @retrieve + CHAR(13) ; 
                        SET @retrieve = @retrieve + 'SET ANSI_NULLS ON' + CHAR(13) ;
                        SET @retrieve = @retrieve + 'GO' + CHAR(13) ; 
                        SET @retrieve = @retrieve + 'SET QUOTED_IDENTIFIER ON' + CHAR(13) ;
                        SET @retrieve = @retrieve + 'GO' + CHAR(13) ; 
                        SET @retrieve = @retrieve + CHAR(13) ; 
                        SET @retrieve = @retrieve + 'CREATE PROCEDURE [' + @TableSchema + '].[' + @ObjectName + 'Retrieve]' + CHAR(13)
                        SET @retrieve = @retrieve + '(' + CHAR(13) ; 
                        SET @retrieve = @retrieve + CHAR(9) + '@' + @ColumnNameCleaned + ' ' + @DataType
                        IF @DataType IN ('varchar', 'VARCHAR', 'char', 'nchar') 
                            SET @retrieve = @retrieve + '(' + CAST(@charLength AS VARCHAR(10)) + ')' + CHAR(13) ;
                        SET @retrieve = @retrieve + CHAR(13) + ')' + CHAR(13) ; 
                        SET @retrieve = @retrieve + CHAR(13) + 'AS' + CHAR(13) ;
                        SET @retrieve = @retrieve + 'BEGIN' + CHAR(13) ;
                        SET @retrieve = @retrieve + CHAR(9) + 'SET NOCOUNT ON;' + CHAR(13) ;
                        SET @retrieve = @retrieve + CHAR(13) ; 
                        SET @retrieve = @retrieve + CHAR(9) + 'SELECT [' + @ColumnName + ']' ;
	
						-- Upsert
                        SET @upsert = 'IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[' + @TableSchema + '].[' + @currentTable + ']'') AND type in (N''P'', N''PC''))' + CHAR(13)
                        SET @upsert = @upsert + CHAR(9) + 'DROP PROCEDURE [' + @TableSchema + '].[' + @currentTable + '];' + CHAR(13)
                        SET @upsert = @upsert + 'GO' + CHAR(13) ; 
                        SET @upsert = @upsert + CHAR(13) ; 
                        SET @upsert = @upsert + 'SET ANSI_NULLS ON' + CHAR(13) ;
                        SET @upsert = @upsert + 'GO' + CHAR(13) ; 
                        SET @upsert = @upsert + 'SET QUOTED_IDENTIFIER ON' + CHAR(13) ;
                        SET @upsert = @upsert + 'GO' + CHAR(13) ; 
                        SET @upsert = @upsert + CHAR(13) ; 
                        SET @upsert = @upsert + 'CREATE PROCEDURE [' + @TableSchema + '].[' + @ObjectName + 'Upsert]' + CHAR(13) ;
                        SET @upsert = @upsert + '(' + CHAR(13) ; 
                        SET @upsert = @upsert + CHAR(9) + '@' + @ColumnNameCleaned + ' ' + @DataType ;
                        IF @DataType IN ('varchar', 'VARCHAR', 'char', 'nchar') 
                            SET @upsert = @upsert + '(' + CAST(@charLength AS VARCHAR(10)) + ')' ;
	
						-- UPDATE
                        SET @update = CHAR(9) + 'UPDATE [' + @TableSchema + '].[' + @CurrentTable + ']' + ' SET ' + CHAR(13) ;
			
						-- INSERT -- don't add first column to insert if it is an
						--	     integer (assume autonumber)
                        SET @insert = CHAR(9) + 'INSERT INTO [' + @TableSchema + '].[' + @CurrentTable + ']' + ' (' + CHAR(13) ;
                        SET @insertValues = CHAR(9) + 'VALUES (' + CHAR(13) ;
			
                        IF @FirstColumnDataType NOT IN ('int', 'bigint', 'smallint', 'tinyint') 
                            BEGIN
                                SET @insert = @insert + CHAR(9) + CHAR(9) + '[' + @ColumnName + '],' + CHAR(13) ;
                                SET @insertValues = @insertValues + CHAR(9) + CHAR(9) + '@' + @ColumnNameCleaned + ',' + CHAR(13) ;
                            END
	
						-- Deactivate
                        SET @deactivate = 'IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[' + @TableSchema + '].[' + @currentTable + ']'') AND type in (N''P'', N''PC''))' + CHAR(13)
                        SET @deactivate = @deactivate + CHAR(9) + 'DROP PROCEDURE [' + @TableSchema + '].[' + @currentTable + '];' + CHAR(13) ;
                        SET @deactivate = @deactivate + 'GO' + CHAR(13) ; 
                        SET @deactivate = @deactivate + CHAR(13) ; 
                        SET @deactivate = @deactivate + 'SET ANSI_NULLS ON' + CHAR(13) ;
                        SET @deactivate = @deactivate + 'GO' + CHAR(13) ; 
                        SET @deactivate = @deactivate + 'SET QUOTED_IDENTIFIER ON' + CHAR(13) ;
                        SET @deactivate = @deactivate + 'GO' + CHAR(13) ; 
                        SET @deactivate = @deactivate + CHAR(13) ; 
                        SET @deactivate = @deactivate + 'CREATE PROCEDURE [' + @TableSchema + '].[' + @ObjectName + 'Deactivate]' + CHAR(13) ;
                        SET @deactivate = @deactivate + '(' + CHAR(13) ; 
                        SET @deactivate = @deactivate + CHAR(9) + '@' + @ColumnNameCleaned + ' ' + @DataType + ',' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(9) + '@Debug BIT = 0' + CHAR(13) ;
                        SET @deactivate = @deactivate + ')' + CHAR(13) ; 
                        SET @deactivate = @deactivate + CHAR(13) + 'AS' + CHAR(13) ;
                        SET @deactivate = @deactivate + 'BEGIN' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(9) + 'DECLARE @errCode  INT;' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(9) + 'DECLARE @procName VARCHAR(50);' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(13) ; 
                        SET @deactivate = @deactivate + CHAR(9) + 'SET @errCode  = 0;' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(9) + 'SET @procName = ''' + @ObjectName + 'Deactivate'';' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(13) ; 
                        SET @deactivate = @deactivate + CHAR(9) + 'IF @Debug = 1' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(9) + CHAR(9) + 'PRINT @procName + '': Deactivating specified record...'';' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(13) ; 
                        SET @deactivate = @deactivate + CHAR(9) + 'SET NOCOUNT ON;' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(13) ; 
                        SET @deactivate = @deactivate + CHAR(9) + 'UPDATE ' + @TableSchema + '.' + @TableName + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(9) + CHAR(9) + 'SET [Active] = 0' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(9) + 'WHERE [' + @ColumnName + '] = @' + @ColumnNameCleaned + ';' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(13) ;                                
                        SET @deactivate = @deactivate + CHAR(9) + 'SET NOCOUNT OFF;' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(13) ;                                
                        SET @deactivate = @deactivate + CHAR(9) + 'SELECT @errCode = @errCode + @@ERROR;' + CHAR(13) ;
                        SET @deactivate = @deactivate + CHAR(9) + 'IF @errCode <> 0' + CHAR(13) ;                                
                        SET @deactivate = @deactivate + CHAR(9) + CHAR(9) + 'RETURN -1;' + CHAR(13) ;                                
                        SET @deactivate = @deactivate + CHAR(9) + 'ELSE' + CHAR(13) ;                                
                        SET @deactivate = @deactivate + CHAR(9) + CHAR(9) + 'RETURN 0;' + CHAR(13) ;                                
                        SET @deactivate = @deactivate + 'END' + CHAR(13) ;                                
                        SET @deactivate = @deactivate + 'GO' + CHAR(13) ;                                
                        SET @deactivate = @deactivate + CHAR(13) ;                                
                        SET @deactivate = @deactivate + 'GRANT EXECUTE ON [' + @TableSchema + '].[' + @CurrentTable + '] TO [CWUser];' + CHAR(13) ;                                
                        SET @deactivate = @deactivate + 'GO' + CHAR(13) ;                                
                    END	-- end @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable
            END
        ELSE 
            BEGIN
                IF @GenerateProcsFor = ''
                    OR @GenerateProcsFor = @CurrentTable 
                    BEGIN
						-- is the same table as the last row of the cursor
						-- just append the column
                        SET @retrieveAll = @retrieveAll + ', ' + CHAR(13) + CHAR(9) + CHAR(9) + '[' + @ColumnName + ']' ;
	
                        SET @retrieve = @retrieve + ', ' + CHAR(13) + CHAR(9) + CHAR(9) + '[' + @ColumnName + ']' ;

                        SET @upsert = @upsert + ',' + CHAR(13) + CHAR(9) + '@' + @ColumnNameCleaned + ' ' + @DataType ;
                        IF @DataType IN ('varchar', 'VARCHAR', 'char', 'nchar') 
                            SET @upsert = @upsert + '(' + CAST(@charLength AS VARCHAR(10)) + ')' ;

                        SET @update = @update + CHAR(9) + CHAR(9) + '[' + @ColumnName + '] = @' + @ColumnNameCleaned + ',' + CHAR(13) ;

                        SET @insert = @insert + CHAR(9) + CHAR(9) + '[' + @ColumnName + '],' + CHAR(13) ;
                        SET @insertValues = @insertValues + CHAR(9) + CHAR(9) + '@' + @ColumnNameCleaned + ',' + CHAR(13) ;
                    END -- end @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable'
            END

		-- fetch next row of cursor into variables
        FETCH NEXT FROM curTableColumns INTO @TableSchema, @TableName, @ColumnName, @DataType, @charLength ;
    END ;

-- ----------------
-- clean up cursor
-- ----------------
CLOSE curTableColumns ;
DEALLOCATE curTableColumns ;

-- ------------------------------------------------
-- repeat the block of code from within the cursor
-- So that the last table has its procs completed
-- and printed / executed
-- ------------------------------------------------

-- if is the end of the last table
IF @CurrentTable <> '' 
    BEGIN
        IF @GenerateProcsFor = ''
            OR @GenerateProcsFor = @CurrentTable 
            BEGIN
                SET @retrieveAll = @retrieveAll + CHAR(13) + 'FROM [' + @TableSchema + '].[' + @CurrentTable + ']' + CHAR(13) ;
                SET @retrieveAll = @retrieveAll + CHAR(13) + CHAR(13) + 'SET NOCOUNT OFF;' + CHAR(13) ;
                SET @retrieveAll = @retrieveAll + CHAR(13) ;

                SET @retrieve = @retrieve + CHAR(13) + 'FROM [' + @TableSchema + '].[' + @CurrentTable + ']' + CHAR(13) ;
                SET @retrieve = @retrieve + 'WHERE [' + @FirstColumnName + '] = @' + REPLACE(@FirstColumnName, ' ', '') + CHAR(13) ;
                SET @retrieve = @retrieve + CHAR(13) + CHAR(13) + 'SET NOCOUNT OFF;' + CHAR(13) ;
                SET @retrieve = @retrieve + CHAR(13)

                SET @update = SUBSTRING(@update, 0, LEN(@update) - 1) + CHAR(13) + CHAR(9) + 'WHERE [' + @FirstColumnName + '] = @' + REPLACE(@FirstColumnName, ' ', '') + CHAR(13) ;

                SET @insert = SUBSTRING(@insert, 0, LEN(@insert) - 1) + CHAR(13) + CHAR(9) + ')' + CHAR(13) ;
                SET @insertValues = SUBSTRING(@insertValues, 0, LEN(@insertValues) - 1) + CHAR(13) + CHAR(9) + ')' ;
                SET @insert = @insert + @insertValues ;

                SET @upsert = @upsert + CHAR(13) + 'AS' + CHAR(13) ;
                SET @upsert = @upsert + 'BEGIN' + CHAR(13) ;
                SET @upsert = @upsert + 'SET NOCOUNT ON;' + CHAR(13) ;
                IF @FirstColumnDataType IN ('int', 'bigint', 'smallint', 'tinyint', 'float', 'decimal') 
                    SET @upsert = @upsert + 'IF @' + REPLACE(@FirstColumnName, ' ', '') + ' = 0 BEGIN' + CHAR(13) ;
                ELSE 
                    SET @upsert = @upsert + 'IF @' + REPLACE(@FirstColumnName, ' ', '') + ' = '''' BEGIN' + CHAR(13) ;
                SET @upsert = @upsert + ISNULL(@insert, '') + CHAR(13) ;
                SET @upsert = @upsert + CHAR(9) + 'SELECT SCOPE_IDENTITY() As InsertedID' + CHAR(13) ;
                SET @upsert = @upsert + 'END' + CHAR(13) ;
                SET @upsert = @upsert + 'ELSE BEGIN' + CHAR(13) ;
                SET @upsert = @upsert + ISNULL(@update, '') + CHAR(13) ;
                SET @upsert = @upsert + 'END' + CHAR(13) + CHAR(13) ;
                SET @upsert = @upsert + 'SET NOCOUNT OFF;' + CHAR(13) ;
                SET @upsert = @upsert + CHAR(13) ;

				-- --------------------------------------------------
				-- now either print the SP definitions or 
				-- execute the statements to create the procs
				-- --------------------------------------------------
                IF @PrintOrExecute <> 'Execute' 
                    BEGIN
                        IF (SUBSTRING(@CurrentTable, 1, 3) = 'Ref') 
                            BEGIN
                                SET @fileName = @TableSchema + '.' + @CurrentTable + 'RetrieveAll.StoredProcedure.sql' ;
                                EXECUTE spWriteStringToFile 
                                    @retrieveAll,
                                    @filePath,
                                    @fileName ;
                            END ;
                                       
                        SET @fileName = @TableSchema + '.' + @CurrentTable + 'Retrieve.StoredProcedure.sql' ;
                        EXECUTE spWriteStringToFile 
                            @retrieve,
                            @filePath,
                            @fileName ;
                                       
                        SET @fileName = @TableSchema + '.' + @CurrentTable + 'Upsert.StoredProcedure.sql' ;
                        EXECUTE spWriteStringToFile 
                            @upsert,
                            @filePath,
                            @fileName ;
                                       
                        SET @fileName = @TableSchema + '.' + @CurrentTable + 'Deactivate.StoredProcedure.sql' ;
                        EXECUTE spWriteStringToFile 
                            @deactivate,
                            @filePath,
                            @fileName ;
                    END
                ELSE 
                    BEGIN
                        EXEC sp_Executesql 
                            @retrieveAll ;
                        EXEC sp_Executesql 
                            @retrieve ;
                        EXEC sp_Executesql 
                            @upsert ;
                        EXEC sp_Executesql 
                            @deactivate ;
                    END
            END -- end @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable
    END