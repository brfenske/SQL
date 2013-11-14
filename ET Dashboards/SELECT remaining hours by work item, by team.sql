DECLARE @Team VARCHAR(25);

SET @Team = 'Red';

SELECT wi.System_WorkItemType AS [Work Item Type]
	, wi.System_Id AS [Item ID]
	, wi.System_Title AS [Title]
	, SUM(t.Microsoft_VSTS_Scheduling_RemainingWork) AS [Remaining Hours]
	, wi.System_State AS [State]
	, wi.CG_Sprint AS [Sprint]
FROM tfs_warehouse.dbo.CurrentWorkItemView t
LEFT JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem l ON t.WorkItemSK = l.SourceWorkItemSK
LEFT JOIN tfs_warehouse.dbo.DimWorkItemLinkType lt ON l.WorkItemLinkTypeSK = lt.WorkItemLinkTypeSK
LEFT JOIN tfs_warehouse.dbo.CurrentWorkItemView wi ON l.TargetWorkitemSK = wi.WorkItemSK
WHERE t.TeamProjectCollectionSK = 3
	AND t.System_WorkItemType = 'Task'
	AND t.System_State IN (
		'In Progress'
		, 'To Do'
		)
	AND lt.WorkItemLinkTypeSK = 6
	AND t.CG_Team = @Team
GROUP BY wi.System_WorkItemType
	, wi.System_Id
	, wi.System_Title
	, wi.CG_Sprint
	, wi.System_State

UNION ALL

SELECT wi.System_WorkItemType AS [Work Item Type]
	, wi.System_Id AS [Item ID]
	, wi.System_Title AS [Title]
	, wi.Microsoft_VSTS_Scheduling_RemainingWork AS [Remaining Hours]
	, wi.System_State AS [State]
	, wi.CG_Sprint AS [Sprint]
FROM tfs_warehouse.dbo.CurrentWorkItemView wi
WHERE wi.TeamProjectCollectionSK = 3
	AND wi.System_WorkItemType = 'Task'
	AND wi.System_State IN (
		'In Progress'
		, 'To Do'
		)
	AND NOT EXISTS (
		SELECT *
		FROM tfs_warehouse.dbo.vFactLinkedCurrentWorkItem l
		WHERE wi.WorkItemSK = l.SourceWorkItemSK
			AND l.WorkItemLinkTypeSK = 6
		)
	AND wi.CG_Team = @Team
ORDER BY wi.CG_Sprint DESC
	, wi.System_WorkItemType DESC
	, wi.System_ID
