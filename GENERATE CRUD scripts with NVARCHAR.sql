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

-- ##########################################################
/* SET CONFIG VARIABLES THAT ARE USED IN SCRIPT */
-- ##########################################################

-- Do we want to generate the SP definitions for every user defined
-- table in the database or just a single specified table?
-- Assign a blank string - '' for all tables or the table name for
-- a single table.
DECLARE @GenerateProcsFor VARCHAR(100)
--SET @GenerateProcsFor = 'Patient'
SET @GenerateProcsFor = ''

-- which database do we want to create the procs for?
-- Change both the USE and SET lines below to set the datbase name
-- to the required database.
USE CareWebQIDb
DECLARE @DatabaseName VARCHAR(100)
SET @DatabaseName = 'CareWebQIDb'

-- do we want the script to print out the CREATE PROC statements
-- or do we want to execute them to actually create the procs?
-- Assign a value of either 'Print' or 'Execute'
DECLARE @PrintOrExecute VARCHAR(10)
SET @PrintOrExecute = 'Print'


-- Is there a table name prefix i.e. 'tbl_' which we don't want
-- to include in our stored proc names?
DECLARE @TablePrefix VARCHAR(10)
SET @TablePrefix = ''

-- For our 'RetrieveAll' and 'Retrieve' procedures do we want to 
-- do SELECT * or SELECT [ColumnName,]...
-- Assign a value of either 1 or 0
DECLARE @UseSelectWildCard BIT
SET @UseSelectWildCard = 0

-- ##########################################################
/* END SETTING OF CONFIG VARIABLE 
-- do not edit below this line */
-- ##########################################################


-- DECLARE CURSOR containing all columns from user defined tables
-- in the database
DECLARE TableCol CURSOR FOR 
SELECT c.TABLE_SCHEMA, c.TABLE_NAME, c.COLUMN_NAME, c.DATA_TYPE, c.CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.Columns c INNER JOIN
INFORMATION_SCHEMA.Tables t ON c.TABLE_NAME = t.TABLE_NAME
WHERE t.Table_Catalog = @DatabaseName
AND t.TABLE_TYPE = 'BASE TABLE'
ORDER BY c.TABLE_NAME, c.ORDINAL_POSITION

-- Declare variables which will hold values from cursor rows
DECLARE @TableSchema VARCHAR(100) ;
DECLARE @TableName VARCHAR(100) ;
DECLARE @ColumnName VARCHAR(100) ;
DECLARE @DataType VARCHAR(30) ;
DECLARE @CharLength INT ;
DECLARE @ColumnNameCleaned VARCHAR(100) ;

-- Declare variables which will track what table we are
-- creating Stored Procs for
DECLARE @CurrentTable VARCHAR(100)
DECLARE @FirstTable BIT
DECLARE @FirstColumnName VARCHAR(100)
DECLARE @FirstColumnDataType VARCHAR(30)
DECLARE @ObjectName VARCHAR(100)
 -- this is the tablename with the specified tableprefix lopped off.
DECLARE @TablePrefixLength INT

-- init vars
SET @CurrentTable = ''
SET @FirstTable = 1
SET @TablePrefixLength = LEN(@TablePrefix)

-- Declare variables which will hold the queries we are building use unicode
-- data types so that can execute using sp_ExecuteSQL
DECLARE @LIST VARCHAR(4000) ;
DECLARE @UPSERT NVARCHAR(4000) ;
DECLARE @SELECT NVARCHAR(4000) ;
DECLARE @INSERT NVARCHAR(4000) ;
DECLARE @INSERTVALUES VARCHAR(4000) ;
DECLARE @UPDATE NVARCHAR(4000) ;
DECLARE @DELETE NVARCHAR(4000) ;

-- open the cursor
OPEN TableCol

-- get the first row of cursor into variables
FETCH NEXT FROM TableCol INTO @TableSchema, @TableName, @ColumnName, @DataType, @CharLength

-- loop through the rows of the cursor
WHILE @@FETCH_STATUS = 0 
    BEGIN

        SET @ColumnNameCleaned = REPLACE(@ColumnName, ' ', '')

	-- is this a new table?
        IF @TableName <> @CurrentTable 
            BEGIN
		
		-- if is the end of the last table
                IF @CurrentTable <> '' 
                    BEGIN
                        IF @GenerateProcsFor = ''
                            OR @GenerateProcsFor = @CurrentTable 
                            BEGIN

				-- first add any syntax to end the statement
				
				-- RetrieveAll
                                SET @LIST = @List + CHAR(13) + 'FROM ' + @CurrentTable + CHAR(13)
                                SET @LIST = @LIST + CHAR(13) + CHAR(13) + 'SET NOCOUNT OFF' + CHAR(13) + CHAR(13)
                                SET @LIST = @LIST + CHAR(13)
				
				-- Retrieve
                                SET @SELECT = @SELECT + CHAR(13) + 'FROM ' + @CurrentTable + CHAR(13)
                                SET @SELECT = @SELECT + 'WHERE [' + @FirstColumnName + '] = @' + REPLACE(@FirstColumnName, ' ', '') + CHAR(13)
                                SET @SELECT = @SELECT + CHAR(13) + CHAR(13) + 'SET NOCOUNT OFF' + CHAR(13) + CHAR(13)
                                SET @SELECT = @SELECT + CHAR(13)
	
	
				-- UPDATE (remove trailing comma and append the WHERE clause)
                                SET @UPDATE = SUBSTRING(@UPDATE, 0, LEN(@UPDATE) - 1) + CHAR(13) + CHAR(9) + 'WHERE [' + @FirstColumnName + '] = @' + REPLACE(@FirstColumnName, ' ', '') + CHAR(13)
				
				-- INSERT
                                SET @INSERT = SUBSTRING(@INSERT, 0, LEN(@INSERT) - 1) + CHAR(13) + CHAR(9) + ')' + CHAR(13)
                                SET @INSERTVALUES = SUBSTRING(@INSERTVALUES, 0, LEN(@INSERTVALUES) - 1) + CHAR(13) + CHAR(9) + ')'
                                SET @INSERT = @INSERT + @INSERTVALUES
				
				-- Upsert
                                SET @UPSERT = @UPSERT + CHAR(13) + 'AS' + CHAR(13)
                                SET @UPSERT = @UPSERT + 'SET NOCOUNT ON' + CHAR(13)
                                IF @FirstColumnDataType IN ('int', 'bigint', 'smallint', 'tinyint', 'float', 'decimal') 
                                    BEGIN
                                        SET @UPSERT = @UPSERT + 'IF @' + REPLACE(@FirstColumnName, ' ', '') + ' = 0 BEGIN' + CHAR(13)
                                    END
                                ELSE 
                                    BEGIN
                                        SET @UPSERT = @UPSERT + 'IF @' + REPLACE(@FirstColumnName, ' ', '') + ' = '''' BEGIN' + CHAR(13)	
                                    END
                                SET @UPSERT = @UPSERT + ISNULL(@INSERT, '') + CHAR(13)
                                SET @UPSERT = @UPSERT + CHAR(9) + 'SELECT SCOPE_IDENTITY() As InsertedID' + CHAR(13)
                                SET @UPSERT = @UPSERT + 'END' + CHAR(13)
                                SET @UPSERT = @UPSERT + 'ELSE BEGIN' + CHAR(13)
                                SET @UPSERT = @UPSERT + ISNULL(@UPDATE, '') + CHAR(13)
                                SET @UPSERT = @UPSERT + 'END' + CHAR(13) + CHAR(13)
                                SET @UPSERT = @UPSERT + 'SET NOCOUNT OFF' + CHAR(13) + CHAR(13)
                                SET @UPSERT = @UPSERT + CHAR(13)
	
				-- Deactivate
				-- delete proc completed already
	
				-- --------------------------------------------------
				-- now either print the SP definitions or 
				-- execute the statements to create the procs
				-- --------------------------------------------------
                                IF @PrintOrExecute <> 'Execute' 
                                    BEGIN
                                    DECLARE @sql VARCHAR(MAX);
                                    SET @sql = 'echo ' + @LIST + ' > c:\sprocs\' + @TableSchema + '.' + @TableName + 'RetrieveAll.StoredProcedure.sql';
                                    exec master..xp_cmdshell @sql;
                                        PRINT @LIST
                                        PRINT @SELECT
                                        PRINT @UPSERT
                                        PRINT @DELETE
                                    END
                                ELSE 
                                    BEGIN
                                        EXEC sp_Executesql 
                                            @LIST
                                        EXEC sp_Executesql 
                                            @SELECT
                                        EXEC sp_Executesql 
                                            @UPSERT
                                        EXEC sp_Executesql 
                                            @DELETE
                                    END
                            END -- end @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable
                    END
		
		-- update the value held in @CurrentTable
                SET @CurrentTable = @TableName
                SET @FirstColumnName = @ColumnName
                SET @FirstColumnDataType = @DataType
		
                IF @TablePrefixLength > 0 
                    BEGIN
                        IF SUBSTRING(@CurrentTable, 1, @TablePrefixLength) = @TablePrefix 
                            BEGIN
				--PRINT Char(13) + 'DEBUG: OBJ NAME: ' + RIGHT(@CurrentTable, LEN(@CurrentTable) - @TablePrefixLength)
                                SET @ObjectName = RIGHT(@CurrentTable, LEN(@CurrentTable) - @TablePrefixLength)
                            END
                        ELSE 
                            BEGIN
                                SET @ObjectName = @CurrentTable
                            END
                    END
                ELSE 
                    BEGIN
                        SET @ObjectName = @CurrentTable
                    END
		
                IF @GenerateProcsFor = ''
                    OR @GenerateProcsFor = @CurrentTable 
                    BEGIN
		
			-- ----------------------------------------------------
			-- now start building the procedures for the next table
			-- ----------------------------------------------------
			
			-- RetrieveAll
                        SET @LIST = 'CREATE PROC [' + @TableSchema + '].[' + @ObjectName + 'RetrieveAll]' + CHAR(13)
                        SET @LIST = @LIST + 'AS' + CHAR(13)
                        SET @LIST = @LIST + 'SET NOCOUNT ON' + CHAR(13)
                        IF @UseSelectWildcard = 1 
                            BEGIN
                                SET @LIST = @LIST + CHAR(13) + 'SELECT * '
                            END 
                        ELSE 
                            BEGIN
                                SET @LIST = @LIST + CHAR(13) + 'SELECT [' + @ColumnName + ']'
                            END
	
			-- Retrieve
                        SET @SELECT = 'CREATE PROC [' + @TableSchema + '].[' + @ObjectName + 'Retrieve]' + CHAR(13)
                        SET @SELECT = @SELECT + CHAR(9) + '@' + @ColumnNameCleaned + ' ' + @DataType
                        IF @DataType IN ('varchar', 'nvarchar', 'char', 'nchar') 
                            BEGIN
                                SET @SELECT = @SELECT + '(' + CAST(@CharLength AS VARCHAR(10)) + ')'
                            END
                        SET @SELECT = @SELECT + CHAR(13) + 'AS' + CHAR(13)
                        SET @SELECT = @SELECT + 'SET NOCOUNT ON' + CHAR(13)
                        IF @UseSelectWildcard = 1 
                            BEGIN
                                SET @SELECT = @SELECT + CHAR(13) + 'SELECT * '
                            END 
                        ELSE 
                            BEGIN
                                SET @SELECT = @SELECT + CHAR(13) + 'SELECT [' + @ColumnName + ']'
                            END
	
			-- Upsert
                        SET @UPSERT = 'CREATE PROC [' + @TableSchema + '].[' + @ObjectName + 'Upsert]' + CHAR(13)
                        SET @UPSERT = @UPSERT + CHAR(9) + '@' + @ColumnNameCleaned + ' ' + @DataType
                        IF @DataType IN ('varchar', 'nvarchar', 'char', 'nchar') 
                            BEGIN
                                SET @UPSERT = @UPSERT + '(' + CAST(@CharLength AS VARCHAR(10)) + ')'
                            END
	
			-- UPDATE
                        SET @UPDATE = CHAR(9) + 'UPDATE ' + @TableName + ' SET ' + CHAR(13)
			
			-- INSERT -- don't add first column to insert if it is an
			--	     integer (assume autonumber)
                        SET @INSERT = CHAR(9) + 'INSERT INTO ' + @TableName + ' (' + CHAR(13)
                        SET @INSERTVALUES = CHAR(9) + 'VALUES (' + CHAR(13)
			
                        IF @FirstColumnDataType NOT IN ('int', 'bigint', 'smallint', 'tinyint') 
                            BEGIN
                                SET @INSERT = @INSERT + CHAR(9) + CHAR(9) + '[' + @ColumnName + '],' + CHAR(13)
                                SET @INSERTVALUES = @INSERTVALUES + CHAR(9) + CHAR(9) + '@' + @ColumnNameCleaned + ',' + CHAR(13)
                            END
	
			-- Deactivate
                        SET @DELETE = 'CREATE PROC [' + @TableSchema + '].[' + @ObjectName + 'Deactivate]' + CHAR(13)
                        SET @DELETE = @DELETE + CHAR(9) + '@' + @ColumnNameCleaned + ' ' + @DataType
                        IF @DataType IN ('varchar', 'nvarchar', 'char', 'nchar') 
                            BEGIN
                                SET @DELETE = @DELETE + '(' + CAST(@CharLength AS VARCHAR(10)) + ')'
                            END
                        SET @DELETE = @DELETE + CHAR(13) + 'AS' + CHAR(13)
                        SET @DELETE = @DELETE + 'SET NOCOUNT ON' + CHAR(13) + CHAR(13)
                        SET @DELETE = @DELETE + 'UPDATE ' + @TableName + CHAR(13)
                        SET @DELETE = @DELETE + CHAR(9) + ' SET [Active] = 0' + CHAR(13)
                        SET @DELETE = @DELETE + 'WHERE [' + @ColumnName + '] = @' + @ColumnNameCleaned + CHAR(13)
                        SET @DELETE = @DELETE + CHAR(13) + 'SET NOCOUNT OFF' + CHAR(13)
                        SET @DELETE = @DELETE + CHAR(13) 

                    END	-- end @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable
            END
        ELSE 
            BEGIN
                IF @GenerateProcsFor = ''
                    OR @GenerateProcsFor = @CurrentTable 
                    BEGIN
		
			-- is the same table as the last row of the cursor
			-- just append the column
			
			-- RetrieveAll
                        IF @UseSelectWildCard = 0 
                            BEGIN
                                SET @LIST = @LIST + ', ' + CHAR(13) + CHAR(9) + '[' + @ColumnName + ']'
                            END
	
			-- Retrieve
                        IF @UseSelectWildCard = 0 
                            BEGIN
                                SET @SELECT = @SELECT + ', ' + CHAR(13) + CHAR(9) + '[' + @ColumnName + ']'
                            END
	
			-- Upsert
                        SET @UPSERT = @UPSERT + ',' + CHAR(13) + CHAR(9) + '@' + @ColumnNameCleaned + ' ' + @DataType
                        IF @DataType IN ('varchar', 'nvarchar', 'char', 'nchar') 
                            BEGIN
                                SET @UPSERT = @UPSERT + '(' + CAST(@CharLength AS VARCHAR(10)) + ')'
                            END
	
			-- UPDATE
                        SET @UPDATE = @UPDATE + CHAR(9) + CHAR(9) + '[' + @ColumnName + '] = @' + @ColumnNameCleaned + ',' + CHAR(13)
	
			-- INSERT
                        SET @INSERT = @INSERT + CHAR(9) + CHAR(9) + '[' + @ColumnName + '],' + CHAR(13)
                        SET @INSERTVALUES = @INSERTVALUES + CHAR(9) + CHAR(9) + '@' + @ColumnNameCleaned + ',' + CHAR(13)
	
			-- Deactivate
			-- delete proc completed already
                    END -- end @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable'
            END

	-- fetch next row of cursor into variables
        FETCH NEXT FROM TableCol INTO @TableSchema, @TableName, @ColumnName, @DataType, @CharLength
    END

-- ----------------
-- clean up cursor
-- ----------------
CLOSE TableCol
DEALLOCATE TableCol

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

		-- first add any syntax to end the statement
		
		-- RetrieveAll
                SET @LIST = @List + CHAR(13) + 'FROM ' + @CurrentTable + CHAR(13)
                SET @LIST = @LIST + CHAR(13) + CHAR(13) + 'SET NOCOUNT OFF' + CHAR(13)
                SET @LIST = @LIST + CHAR(13)
		
		-- Retrieve
                SET @SELECT = @SELECT + CHAR(13) + 'FROM ' + @CurrentTable + CHAR(13)
                SET @SELECT = @SELECT + 'WHERE [' + @FirstColumnName + '] = @' + REPLACE(@FirstColumnName, ' ', '') + CHAR(13)
                SET @SELECT = @SELECT + CHAR(13) + CHAR(13) + 'SET NOCOUNT OFF' + CHAR(13)
                SET @SELECT = @SELECT + CHAR(13)


		-- UPDATE (remove trailing comma and append the WHERE clause)
                SET @UPDATE = SUBSTRING(@UPDATE, 0, LEN(@UPDATE) - 1) + CHAR(13) + CHAR(9) + 'WHERE [' + @FirstColumnName + '] = @' + REPLACE(@FirstColumnName, ' ', '') + CHAR(13)
		
		-- INSERT
                SET @INSERT = SUBSTRING(@INSERT, 0, LEN(@INSERT) - 1) + CHAR(13) + CHAR(9) + ')' + CHAR(13)
                SET @INSERTVALUES = SUBSTRING(@INSERTVALUES, 0, LEN(@INSERTVALUES) - 1) + CHAR(13) + CHAR(9) + ')'
                SET @INSERT = @INSERT + @INSERTVALUES
		
		-- Upsert
                SET @UPSERT = @UPSERT + CHAR(13) + 'AS' + CHAR(13)
                SET @UPSERT = @UPSERT + 'SET NOCOUNT ON' + CHAR(13)
                IF @FirstColumnDataType IN ('int', 'bigint', 'smallint', 'tinyint', 'float', 'decimal') 
                    BEGIN
                        SET @UPSERT = @UPSERT + 'IF @' + REPLACE(@FirstColumnName, ' ', '') + ' = 0 BEGIN' + CHAR(13)
                    END
                ELSE 
                    BEGIN
                        SET @UPSERT = @UPSERT + 'IF @' + REPLACE(@FirstColumnName, ' ', '') + ' = '''' BEGIN' + CHAR(13)	
                    END
                SET @UPSERT = @UPSERT + ISNULL(@INSERT, '') + CHAR(13)
                SET @UPSERT = @UPSERT + CHAR(9) + 'SELECT SCOPE_IDENTITY() As InsertedID' + CHAR(13)
                SET @UPSERT = @UPSERT + 'END' + CHAR(13)
                SET @UPSERT = @UPSERT + 'ELSE BEGIN' + CHAR(13)
                SET @UPSERT = @UPSERT + ISNULL(@UPDATE, '') + CHAR(13)
                SET @UPSERT = @UPSERT + 'END' + CHAR(13) + CHAR(13)
                SET @UPSERT = @UPSERT + 'SET NOCOUNT OFF' + CHAR(13)
                SET @UPSERT = @UPSERT + CHAR(13)

		-- Deactivate
		-- delete proc completed already

		-- --------------------------------------------------
		-- now either print the SP definitions or 
		-- execute the statements to create the procs
		-- --------------------------------------------------
                IF @PrintOrExecute <> 'Execute' 
                    BEGIN
                        PRINT @LIST
                        PRINT @SELECT
                        PRINT @UPSERT
                        PRINT @DELETE
                    END
                ELSE 
                    BEGIN
                        EXEC sp_Executesql 
                            @LIST
                        EXEC sp_Executesql 
                            @SELECT
                        EXEC sp_Executesql 
                            @UPSERT
                        EXEC sp_Executesql 
                            @DELETE
                    END
            END -- end @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable
    END