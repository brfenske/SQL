IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TableOfNumbers]')
			AND type IN (
				N'TF'
				)
		)
	DROP FUNCTION [dbo].[TableOfNumbers];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian
-- Create date: 8/6/12
-- Description:	Returns a table filled with numbers in a range specified by the number of digits passed in
-- =============================================
CREATE FUNCTION TableOfNumbers (@digits INT)
RETURNS @NumTable TABLE (n INT)
AS
BEGIN
	DECLARE @Max AS INT;
	DECLARE @Increment AS INT;

	SET @Max = CAST(REPLICATE('9', @digits) AS INT);
	SET @Increment = 1;

	INSERT INTO @NumTable
	VALUES (POWER(10, @digits - 1));

	WHILE @Increment * 2 <= @Max
	BEGIN
		INSERT INTO @NumTable
		SELECT n + @Increment
		FROM @NumTable;

		SET @Increment = @Increment * 2;
	END

	INSERT INTO @NumTable
	SELECT n + @Increment
	FROM @NumTable
	WHERE n + @Increment <= @Max;

	RETURN;
END
GO


