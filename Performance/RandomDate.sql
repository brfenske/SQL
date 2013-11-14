IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[RandomDate]')
			AND type IN (
				N'F'
				,N'FN'
				)
		)
	DROP FUNCTION [dbo].[RandomDate];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian
-- Create date: 7/30/2012
-- Description:	Get a random date in the past or future
-- =============================================
CREATE FUNCTION RandomDate (
	@RandomID UNIQUEIDENTIFIER
	,@TimeFrame INT
	)
RETURNS DATETIME
AS
BEGIN
	DECLARE @Result DATETIME;
	DECLARE @DatePastFrom DATETIME;
	DECLARE @DateFutureFrom DATETIME;

	SET @DatePastFrom = '1925-01-01';
	SET @DateFutureFrom = '2014-12-31';

	IF (@TimeFrame = 0)
		-- Date from the past
		SELECT @Result = @DatePastFrom + (ABS(CAST(CAST(@RandomID AS BINARY (8)) AS INT)) % CAST((GETDATE() - @DatePastFrom) AS INT));
	ELSE
		-- Future date
		SELECT @Result = @DateFutureFrom - (ABS(CAST(CAST(@RandomID AS BINARY (8)) AS INT)) % CAST((@DateFutureFrom - GETDATE()) AS INT));

	RETURN @Result;
END
GO


