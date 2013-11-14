;

WITH Features
AS (
	SELECT System_Id
		, WorkItemSK
		, MAX(System_Rev) AS MaxRev
	FROM tfs_warehouse.dbo.CurrentWorkItemView
	WHERE System_WorkItemType = 'Feature'
		AND TeamProjectCollectionSK = 1
	GROUP BY System_Id
		, WorkItemSK
	)
SELECT f.System_Id
	, f.WorkItemSK
	, f.MaxRev
	, link.TargetWorkitemSK
FROM Features f
LEFT JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem link ON f.WorkItemSK = link.SourceWorkItemSK
	AND link.WorkItemLinkTypeSK = 2
ORDER BY f.System_Id
	, f.WorkItemSK
	, f.MaxRev
	, link.TargetWorkitemSK
