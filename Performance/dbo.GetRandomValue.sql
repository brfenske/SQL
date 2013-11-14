/****** Object:  StoredProcedure [dbo].[GetRandomValue]    Script Date: 11/12/2013 16:00:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRandomValue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetRandomValue]
GO

/****** Object:  StoredProcedure [dbo].[GetRandomValue]    Script Date: 11/12/2013 16:00:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetRandomValue] @ValueType VARCHAR(25)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP (1) RandomValue
		, RandomValuePrimaryKey
	FROM RandomValues
	WHERE ValueType = @ValueType
	ORDER BY CHECKSUM(NEWID());
END

GO


