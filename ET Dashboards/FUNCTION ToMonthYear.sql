SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian F
-- Create date: 2/25/13
-- Description:	Returns data as MM/yyyy
-- =============================================
CREATE FUNCTION ToMonthYear (@DateValue DATETIME)
RETURNS DATETIME
AS
BEGIN
	DECLARE @Result DATETIME

	SELECT @Result = RIGHT(CONVERT(VARCHAR(10), @DateValue, 103), 7);

	RETURN @Result
END
GO


