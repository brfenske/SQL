USE [CareWebQIDb]
GO

DECLARE	@return_value int,
		@RecordCount INT,
		@weekStart DATETIME,
		@weekEnd DATETIME
		
SET @weekStart = DATEADD(ww, DATEDIFF(ww, 0, GETDATE()), 0);		
SET @weekEnd = DATEADD(wk, DATEDIFF(wk, 6, GETDATE()), 6 + 7);

EXEC	@return_value = [Platform].[TaskRetrieveByFilter2]
		@ThisWeekStart = @weekStart,
		@ThisWeekEnd = @weekEnd,
		@RecordCount = @RecordCount OUTPUT

SELECT	@RecordCount as N'@RecordCount'

SELECT	'Return Value' = @return_value

GO
