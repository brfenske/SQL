;

WITH Items
AS (
	SELECT w.System_WorkItemType AS [Type]
		, w.System_Id AS ID
		, w.System_Title AS Title
		, w.System_State AS [State]
		, w.WorkItemSK
	FROM CurrentWorkItemView AS w
	WHERE (w.TeamProjectCollectionSK = 3)
		AND (
			w.System_WorkItemType IN (
				'User Story'
				, 'Bug'
				)
			)
		AND (
			w.System_State NOT IN (
				'New'
				, 'Closed'
				, 'Done'
				, 'Removed'
				)
			)
		AND (w.CG_Team = N'Blue')
	) 
SELECT i.*, l.SourceWorkItemSK, l.TargetWorkItemSK, t.WorkItemSK, t.System_Title --, t.Microsoft_VSTS_Scheduling_RemainingWork
FROM Items i
LEFT JOIN vFactLinkedCurrentWorkItem AS l ON i.WorkItemSK = l.SourceWorkitemSK
LEFT JOIN CurrentWorkItemView AS t ON l.TargetWorkItemSK = t.WorkItemSK
where l.WorkItemLinkTypeSK = 6
	--, COALESCE(SUM(t.Microsoft_VSTS_Scheduling_RemainingWork), 0) AS [Remaining Work]


	--LEFT JOIN vFactLinkedCurrentWorkItem AS l ON w.WorkItemSK = l.SourceWorkitemSK
	--LEFT JOIN CurrentWorkItemView AS t ON l.TargetWorkItemSK = t.WorkItemSK


	--AND (l.WorkItemLinkTypeSK = 2)
	--AND (t.System_WorkItemType = N'Task')
	--	group by w.System_WorkItemType 
	--	, w.System_Id 
	--	, w.System_Title 
	--	, w.System_State 
	ORDER BY  i.[Type] DESC
		, i.[State] DESC
