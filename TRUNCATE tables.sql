-- THIS WILL TRUNCATE ALL TABLES WITH CONSTRAINTS WHICH WE MAY NOT WANT TO DO


SET NOCOUNT ON

-- GLOBAL VARIABLES
DECLARE @i INT
DECLARE @Debug BIT
DECLARE @Recycle BIT
DECLARE @Verbose BIT
DECLARE @TableName VARCHAR(80)
DECLARE @ColumnName VARCHAR(80)
DECLARE @ReferencedTableName VARCHAR(80)
DECLARE @ReferencedColumnName VARCHAR(80)
DECLARE @ConstraintName VARCHAR(250)

DECLARE @CreateStatement VARCHAR(MAX)
DECLARE @DropStatement VARCHAR(MAX)   
DECLARE @TruncateStatement VARCHAR(MAX)
DECLARE @CreateStatementTemp VARCHAR(MAX)
DECLARE @DropStatementTemp VARCHAR(MAX)
DECLARE @TruncateStatementTemp VARCHAR(MAX)
DECLARE @Statement VARCHAR(MAX)

        -- 1 = Will not execute statements 
SET @Debug = 1
        -- 0 = Will not create or truncate storage table
        -- 1 = Will create or truncate storage table
SET @Recycle = 0
        -- 1 = Will print a message on every step
SET @Verbose = 1

SET @i = 1
SET @CreateStatement = 'ALTER TABLE [dbo].[<tablename>]  WITH NOCHECK ADD  CONSTRAINT [<constraintname>] FOREIGN KEY([<column>]) REFERENCES [dbo].[<reftable>] ([<refcolumn>])'
SET @DropStatement = 'ALTER TABLE [dbo].[<tablename>] DROP CONSTRAINT [<constraintname>]'
SET @TruncateStatement = 'TRUNCATE TABLE [<tablename>]'

-- Drop Temporary tables
IF EXISTS ( SELECT  *
            FROM    tempdb.dbo.sysobjects o
            WHERE   o.xtype IN ('U')
                    AND o.id = OBJECT_ID(N'tempdb..#FKs') ) 
    DROP TABLE #FKs

-- GET FKs
SELECT  ROW_NUMBER() OVER (ORDER BY OBJECT_NAME(parent_object_id), clm1.name) AS ID
       ,OBJECT_NAME(constraint_object_id) AS ConstraintName
       ,OBJECT_NAME(parent_object_id) AS TableName
       ,clm1.name AS ColumnName
       ,OBJECT_NAME(referenced_object_id) AS ReferencedTableName
       ,clm2.name AS ReferencedColumnName
INTO    #FKs
FROM    sys.foreign_key_columns fk
        JOIN sys.columns clm1 ON fk.parent_column_id = clm1.column_id
                                 AND fk.parent_object_id = clm1.object_id
        JOIN sys.columns clm2 ON fk.referenced_column_id = clm2.column_id
                                 AND fk.referenced_object_id = clm2.object_id
WHERE   OBJECT_NAME(parent_object_id) NOT IN ('//tables that you do not wont to be truncated')
ORDER BY OBJECT_NAME(parent_object_id)


-- Prepare Storage Table
IF NOT EXISTS ( SELECT  1
                FROM    INFORMATION_SCHEMA.TABLES
                WHERE   TABLE_NAME = 'Internal_FK_Definition_Storage' ) 
    BEGIN
        IF @Verbose = 1 
            PRINT '1. Creating Process Specific Tables...'

  -- CREATE STORAGE TABLE IF IT DOES NOT EXISTS
        CREATE TABLE [Internal_FK_Definition_Storage]
            (
             ID INT NOT NULL
                    IDENTITY(1, 1)
                    PRIMARY KEY
            ,FK_Name VARCHAR(250) NOT NULL
            ,FK_CreationStatement VARCHAR(MAX) NOT NULL
            ,FK_DestructionStatement VARCHAR(MAX) NOT NULL
            ,Table_TruncationStatement VARCHAR(MAX) NOT NULL
            ) 
    END 
ELSE 
    BEGIN
        IF @Recycle = 0 
            BEGIN
                IF @Verbose = 1 
                    PRINT '1. Truncating Process Specific Tables...'

    -- TRUNCATE TABLE IF IT ALREADY EXISTS
                TRUNCATE TABLE [Internal_FK_Definition_Storage]    
            END
        ELSE 
            PRINT '1. Process specific table will be recycled from previous execution...'
    END

IF @Recycle = 0 
    BEGIN

        IF @Verbose = 1 
            PRINT '2. Backing up Foreign Key Definitions...'

  -- Fetch and persist FKs             
        WHILE (@i <= (SELECT    MAX(ID)
                      FROM      #FKs)) 
            BEGIN
                SET @ConstraintName = (SELECT   ConstraintName
                                       FROM     #FKs
                                       WHERE    ID = @i)
                SET @TableName = (SELECT    TableName
                                  FROM      #FKs
                                  WHERE     ID = @i)
                SET @ColumnName = (SELECT   ColumnName
                                   FROM     #FKs
                                   WHERE    ID = @i)
                SET @ReferencedTableName = (SELECT  ReferencedTableName
                                            FROM    #FKs
                                            WHERE   ID = @i)
                SET @ReferencedColumnName = (SELECT ReferencedColumnName
                                             FROM   #FKs
                                             WHERE  ID = @i)

                SET @DropStatementTemp = REPLACE(REPLACE(@DropStatement, '<tablename>', @TableName), '<constraintname>', @ConstraintName)
                SET @CreateStatementTemp = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@CreateStatement, '<tablename>', @TableName), '<column>', @ColumnName), '<constraintname>', @ConstraintName), '<reftable>', @ReferencedTableName), '<refcolumn>', @ReferencedColumnName)
                SET @TruncateStatementTemp = REPLACE(@TruncateStatement, '<tablename>', @TableName) 

                INSERT  INTO [Internal_FK_Definition_Storage]
                        SELECT  @ConstraintName
                               ,@CreateStatementTemp
                               ,@DropStatementTemp
                               ,@TruncateStatementTemp

                SET @i = @i + 1

                IF @Verbose = 1 
                    PRINT '  > Backing up [' + @ConstraintName + '] from [' + @TableName + ']'

            END
    END   
ELSE 
    PRINT '2. Backup up was recycled from previous execution...'

IF @Verbose = 1 
    PRINT '3. Dropping Foreign Keys...'

    -- DROP FOREING KEYS
SET @i = 1
WHILE (@i <= (SELECT    MAX(ID)
              FROM      [Internal_FK_Definition_Storage])) 
    BEGIN
        SET @ConstraintName = (SELECT   FK_Name
                               FROM     [Internal_FK_Definition_Storage]
                               WHERE    ID = @i)
        SET @Statement = (SELECT    FK_DestructionStatement
                          FROM      [Internal_FK_Definition_Storage] WITH (NOLOCK)
                          WHERE     ID = @i)

        IF @Debug = 1 
            PRINT @Statement
        ELSE 
            EXEC(@Statement)

        SET @i = @i + 1

        IF @Verbose = 1 
            PRINT '  > Dropping [' + @ConstraintName + ']'
    END     

IF @Verbose = 1 
    PRINT '4. Truncating Tables...'

    -- TRUNCATE TABLES
SET @i = 1
WHILE (@i <= (SELECT    MAX(ID)
              FROM      [Internal_FK_Definition_Storage])) 
    BEGIN
        SET @Statement = (SELECT    Table_TruncationStatement
                          FROM      [Internal_FK_Definition_Storage]
                          WHERE     ID = @i)

        IF @Debug = 1 
            PRINT @Statement
        ELSE 
            EXEC(@Statement)

        SET @i = @i + 1

        IF @Verbose = 1 
            PRINT '  > ' + @Statement
    END

IF @Verbose = 1 
    PRINT '5. Re-creating Foreign Keys...'

    -- CREATE FOREING KEYS
SET @i = 1
WHILE (@i <= (SELECT    MAX(ID)
              FROM      [Internal_FK_Definition_Storage])) 
    BEGIN
        SET @ConstraintName = (SELECT   FK_Name
                               FROM     [Internal_FK_Definition_Storage]
                               WHERE    ID = @i)
        SET @Statement = (SELECT    FK_CreationStatement
                          FROM      [Internal_FK_Definition_Storage]
                          WHERE     ID = @i)

        IF @Debug = 1 
            PRINT @Statement
        ELSE 
            EXEC(@Statement)

        SET @i = @i + 1

        IF @Verbose = 1 
            PRINT '  > Re-creating [' + @ConstraintName + ']'
    END

IF @Verbose = 1 
    PRINT '6. Process Completed'