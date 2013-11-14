USE [Tfs_MillimanSandbox];

DECLARE @sql NVARCHAR(MAX);
DECLARE @BusinessReasonFld NVARCHAR(128);
DECLARE @BusinessSourceFld NVARCHAR(128);
DECLARE @InitialComplexityEstimateFld NVARCHAR(128);
DECLARE @CrossProductImplicationsFld NVARCHAR(128);
DECLARE @CrossTeamImplicationsFld NVARCHAR(128);
DECLARE @EstimatedEffortFld NVARCHAR(128);
DECLARE @ActualEffortFld NVARCHAR(128);

SELECT @BusinessReasonFld = ColName
FROM Fields
WHERE [Name] = 'Business Reason'

SELECT @BusinessSourceFld = ColName
FROM Fields
WHERE [Name] = 'Business Source'

SELECT @InitialComplexityEstimateFld = ColName
FROM Fields
WHERE [Name] = 'Initial Complexity Estimate'

SELECT @CrossProductImplicationsFld = ColName
FROM Fields
WHERE [Name] = 'Cross-Product Implications'

SELECT @CrossTeamImplicationsFld = ColName
FROM Fields
WHERE [Name] = 'Cross-Team Implications'

SELECT @EstimatedEffortFld = ColName
FROM Fields
WHERE [Name] = 'Effort'

SELECT @ActualEffortFld = ColName
FROM Fields
WHERE [Name] = 'Actual Effort'

SET @sql = 'SELECT dbo.LongTextForWorkItem(wil.Id, ''Market Problem'', ''MCG'') AS [Market Problem]
	, REPLACE(' + @BusinessReasonFld + ', '';'', CHAR(13)) AS [Business Reason]
	, REPLACE(' + @BusinessSourceFld + ', '';'', CHAR(13)) AS [Business Source]
	, wil.Title AS Feature
	, dbo.LongTextForWorkItem(wil.Id, ''Description HTML'', ''MCG'') AS [Feature Description]
	, REPLACE(' + @InitialComplexityEstimateFld + ', '';'', CHAR(13)) AS [Initial Complexity Estimate]
	, estEff.[Estimated Effort]
	, actEff.[Actual Effort]
	, REPLACE(' + @CrossProductImplicationsFld + ', '';'', CHAR(13)) AS [Cross Product Implications]
	, REPLACE(' + @CrossTeamImplicationsFld + ', '';'', CHAR(13)) AS [Cross Team Implications]
	, wil.ID
	, tree.[Name]
FROM [dbo].[WorkItemsLatest] wil
LEFT JOIN [dbo].TreeNodes tree ON wil.AreaID = tree.ID
LEFT JOIN (
	SELECT l.SourceID
		, (wiUserStory.' + @EstimatedEffortFld + ') AS [Estimated Effort]
	FROM WorkItemsLatest AS wiUserStory
	INNER JOIN LinksLatest l ON wiUserStory.ID = l.TargetID
	RIGHT JOIN WorkItemsLatest AS wiFeature ON l.SourceID = wiFeature.ID
	GROUP BY l.SourceID
		, wiUserStory.' + @EstimatedEffortFld + '
	) estEff ON wil.ID = estEff.SourceID
LEFT JOIN (
	SELECT l2.SourceID
		, (wiUserStory2.' + @ActualEffortFld + ') AS [Actual Effort]
	FROM WorkItemsLatest AS wiUserStory2
	INNER JOIN LinksLatest l2 ON wiUserStory2.ID = l2.TargetID
	RIGHT JOIN WorkItemsLatest AS wiFeature2 ON l2.SourceID = wiFeature2.ID
	GROUP BY l2.SourceID
		, wiUserStory2.' + @ActualEffortFld + '
	) actEff ON wil.ID = actEff.SourceID
WHERE wil.[Work Item Type] = ''Feature''
	AND (
		wil.[State] = ''New''
		OR wil.[State] = ''Approved''
		OR wil.[State] = ''Committed''
		)';
        
EXECUTE sp_executesql @sql