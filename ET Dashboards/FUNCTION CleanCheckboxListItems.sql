-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian F
-- Create date: 2/21/2013
-- Description:	Reformats checkbox list items for report
-- =============================================
ALTER FUNCTION CleanCheckboxListItems (@data VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Result VARCHAR(MAX)

	SET @data = REPLACE(@data, ';', CHAR(13) + CHAR(10));
	SET @data = REPLACE(@data, '[', '');
	SET @data = REPLACE(@data, ']', '');

    SET @Result = @data;
    
	RETURN @Result
END
GO


