SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TableColumnsAsList] (@TableName VARCHAR(50))
RETURNS VARCHAR(MAX)
AS 
    BEGIN
        DECLARE @listStr VARCHAR(MAX)
        SELECT  @listStr = COALESCE(@listStr + ',', '') + '[' + COLUMN_NAME + ']'
        FROM    INFORMATION_SCHEMA.COLUMNS
        WHERE   TABLE_NAME = @TableName
        RETURN @listStr

    END
