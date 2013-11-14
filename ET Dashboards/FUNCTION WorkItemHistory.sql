SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian F
-- Create date: 2/21/2013
-- Description:	Returns the most recent revision of a longtext for a give Work Item ID
-- =============================================
CREATE FUNCTION WorkItemHistory (
	@ID INT
	, @Project VARCHAR(255)
	)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Result VARCHAR(MAX);

	WITH longText
	AS (
		SELECT wilt2.ID
			, fld2.[Name]
			, wilt2.Words
			, txt.Rev
		FROM WorkItemLongTexts wilt2
		INNER JOIN Fields fld2 ON wilt2.FldID = fld2.FldID
		INNER JOIN (
			SELECT fld.[Name]
				, wilt.ID
				, wilt.Rev
			FROM WorkItemLongTexts wilt
			INNER JOIN Fields fld ON wilt.FldID = fld.FldID
			WHERE wilt.ID = @ID
			--GROUP BY fld.[Name]
			--	, wilt.ID
			) txt ON txt.[Name] = fld2.[Name]
			AND txt.rev = wilt2.Rev
		)
	SELECT @Result = (SELECT TOP 1 txt.words
	FROM xxtree tree
	INNER JOIN (
		SELECT *
		FROM WorkItemsWere
		WHERE ID = @ID
		
		UNION ALL
		
		SELECT NULL AS 'Revised Date'
			, *
		FROM WorkItemsAre
		WHERE ID = @ID
		) AS wrkItm ON tree.ID = wrkItm.AreaID
	LEFT JOIN longText txt ON wrkItm.ID = txt.ID
		AND txt.[Name] = 'History'
	WHERE tree.[Team Project] = @Project
	--	AND wrkItm.ID = @ID
	ORDER BY txt.Rev DESC)

	RETURN @Result
END
