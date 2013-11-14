DECLARE @TeamProjectCollectionSK INT;

IF @TeamProjectCollectionSK IS NULL
	SELECT @TeamProjectCollectionSK = [ProjectNodeSK]
	FROM [tfs_warehouse].[dbo].[DimTeamProject]
	WHERE [ProjectNodeTypeName] = 'Team Project Collection'
		AND ProjectNodeName = 'Milliman';

DECLARE @LinkTypeSK INT;

SELECT @LinkTypeSK = [WorkItemLinkTypeSK]
FROM [tfs_warehouse].[dbo].[DimWorkItemLinkType]
WHERE ReferenceName = 'System.LinkTypes.Hierarchy'
	AND LinkName = 'Child'
	AND TeamProjectCollectionSK = @TeamProjectCollectionSK;

WITH Charters
AS (
	SELECT c.System_Id
		, c.System_Title
		, MAX(c.System_Rev) AS MaxRev
		, c.Microsoft_VSTS_Common_Priority
	FROM tfs_warehouse.dbo.CurrentWorkItemView c
	left join Tfs_Milliman
	WHERE System_WorkItemType = 'Charter Item'
		AND Microsoft_VSTS_Common_Priority < 500
		AND TeamProjectCollectionSK = @TeamProjectCollectionSK
		AND NOT System_State IN (
			'Removed'
			, 'Done'
			)
	GROUP BY System_Id
		, System_Title
		, Microsoft_VSTS_Common_Priority
	)
	, CharterFeatures
AS (
	SELECT c.Microsoft_VSTS_Common_Priority AS [Priority]
		, c.System_Title AS [Charter Item]
		, COUNT(f.System_Title) AS [Number of Features]
		, COALESCE(SUM(f.IsDone), 0) AS [Number of Completed Features]
		--, CASE 
		--	WHEN SUM(f.IsDone) > 0
		--		THEN CAST(((SUM(f.IsDone) / COUNT(f.System_Id)) * 100) AS VARCHAR) + '%'
		--	ELSE ''
		--	END AS [Feature % Complete]
		, COALESCE(SUM(complEff.[Completed Effort]), 0) AS [Completed Effort]
		, COALESCE(SUM(estEff.[Estimated Effort]), 0) AS [Estimated Effort]
		, CASE 
			WHEN SUM(complEff.[Completed Effort]) > 0
				AND SUM(estEff.[Estimated Effort]) > 0
				THEN CAST(((SUM(complEff.[Completed Effort]) / SUM(estEff.[Estimated Effort])) * 100) AS VARCHAR) + '%'
			ELSE ''
			END AS [Effort % Complete]
	FROM Charters c
	INNER JOIN tfs_warehouse.dbo.CurrentWorkItemView wi ON c.System_Id = wi.System_Id
		AND c.MaxRev = wi.System_Rev
	LEFT JOIN (
		SELECT wilChart.System_Id
			, wilFeat.System_Title
			, wilFeat.System_Id AS FeatureID
			, CASE 
				WHEN wilFeat.System_State = 'Done'
					THEN 1
				ELSE 0
				END AS IsDone
		FROM tfs_warehouse.dbo.CurrentWorkItemView wilChart
		INNER JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem l ON wilChart.WorkItemSK = l.SourceWorkItemSK
		INNER JOIN tfs_warehouse.dbo.CurrentWorkItemView wilFeat ON l.TargetWorkItemSK = wilFeat.WorkItemSK
		WHERE wilChart.System_WorkItemType = 'Charter Item'
		) f ON wi.System_Id = f.System_Id
	LEFT JOIN (
		SELECT wilFeat.WorkItemSK
			, wilFeat.System_id
			, SUM(wilUStory.Microsoft_VSTS_Scheduling_Effort) AS [Completed Effort]
		FROM tfs_warehouse.dbo.CurrentWorkItemView wilFeat
		INNER JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem l ON wilFeat.WorkItemSK = l.SourceWorkItemSK
		INNER JOIN tfs_warehouse.dbo.CurrentWorkItemView wilUStory ON l.TargetWorkItemSK = wilUStory.WorkItemSK
		WHERE wilfeat.System_WorkItemType = 'Feature'
			AND wilFeat.System_State = 'Done'
		GROUP BY wilFeat.WorkItemSK
			, wilFeat.System_id
		) complEff ON f.FeatureID = complEff.System_Id
	LEFT JOIN (
		SELECT wilFeat.WorkItemSK
			, wilFeat.System_id
			, SUM(wilUStory.Microsoft_VSTS_Scheduling_Effort) AS [Estimated Effort]
		FROM tfs_warehouse.dbo.CurrentWorkItemView wilFeat
		INNER JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem l ON wilFeat.WorkItemSK = l.SourceWorkItemSK
		INNER JOIN tfs_warehouse.dbo.CurrentWorkItemView wilUStory ON l.TargetWorkItemSK = wilUStory.WorkItemSK
		WHERE wilfeat.System_WorkItemType = 'Feature'
		GROUP BY wilFeat.WorkItemSK
			, wilFeat.System_id
		) estEff ON f.FeatureID = estEff.System_Id
	GROUP BY c.System_Title
		, c.Microsoft_VSTS_Common_Priority
		, complEff.[Completed Effort]
		, estEff.[Estimated Effort]
	)
SELECT [Priority]
	, [Charter Item]
	, SUM([Number of Features]) AS [Number of Features]
	, CASE 
		WHEN SUM([Number of Completed Features]) > 0
			AND SUM([Number of Features]) > 0
			THEN CAST(((SUM([Number of Completed Features]) / SUM([Number of Features])) * 100) AS VARCHAR) + '%'
		ELSE ''
		END AS [Features % Complete]
	, CASE 
		WHEN SUM([Completed Effort]) > 0
			AND SUM([Estimated Effort]) > 0
			THEN CAST(((SUM([Completed Effort]) / SUM([Estimated Effort])) * 100) AS VARCHAR) + '%'
		ELSE ''
		END AS [Effort % Complete]
	, '' AS 'Charter Description'
	, '' AS 'Notes'
FROM CharterFeatures
GROUP BY [Priority]
	, [Charter Item]
ORDER BY [Priority]
	, [Charter Item]
