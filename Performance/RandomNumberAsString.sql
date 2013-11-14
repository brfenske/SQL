IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[RandomNumberAsString]')
			AND type IN (
				N'F'
				,N'FN'
				)
		)
	DROP FUNCTION [dbo].[RandomNumberAsString];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian
-- Create date: 7/30/12
-- Description:	Return random number with a specified number of digits
-- =============================================
CREATE FUNCTION RandomNumberAsString (
	@Number FLOAT
	,@NumDigits INT
	)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Result INT;

	SELECT @Result = LEFT(CONVERT(VARCHAR, CAST(@Number * POWER(10, @NumDigits) AS INT)) + REPLICATE('0', @NumDigits), @NumDigits);

	RETURN @Result;
END
GO


