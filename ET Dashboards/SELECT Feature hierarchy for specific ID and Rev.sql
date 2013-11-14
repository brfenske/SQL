--DECLARE @rev INT = 1;--[tree specific revision number];
DECLARE @id INT = 594;-- [tree specific work item id];
DECLARE @project VARCHAR(255) = 'MCGSandbox';--[tree specific team project [Name]];

WITH longText
AS (
	SELECT wilt.ID
		, fld2.[Name]
		, wilt.Words
		, txt.Rev
	FROM WorkItemLongTexts wilt
	INNER JOIN Fields fld2 ON wilt.FldID = fld2.FldID
	INNER JOIN (
		SELECT fld.[Name]
			, tree.ID
			, MAX(tree.Rev) AS Rev
		FROM WorkItemLongTexts tree
		INNER JOIN Fields fld ON tree.FldID = fld.FldID
		WHERE tree.ID = @id
		--AND tree.Rev <= @rev
		GROUP BY fld.[Name]
			, tree.id
		) txt ON txt.[Name] = fld2.[Name]
		AND txt.rev = wilt.Rev
	)
--SELECT * FROM longText
SELECT TOP 1 tree.id
	, tree.[Team Project]
	, txt.words AS 'Description HTML'
	, txt2.words AS 'Market Problem'
	, wrkItm.*
FROM xxtree tree
INNER JOIN (
	SELECT *
	FROM workitemswere
	WHERE id = @id
	
	UNION ALL
	
	SELECT NULL AS 'Revised Date'
		, *
	FROM workitemsare
	WHERE id = @id
	) AS wrkItm ON tree.id = wrkItm.AreaID
LEFT JOIN longText txt ON wrkItm.id = txt.ID
	AND txt.[Name] = 'Description HTML'
LEFT JOIN longText txt2 ON wrkItm.id = txt2.ID
	AND txt2.[Name] = 'Market Problem'
--WHERE tree.[Team Project] = @project
--	AND wrkItm.id = @id
--	AND wrkItm.rev = @rev
ORDER BY TXT.Rev DESC
