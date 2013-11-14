SELECT parent.IterationPath AS ParentIterationPath
	, ff.FeatureSK
	, parent.System_WorkItemType AS ParentType
	, l.[SourceWorkItemSK] AS ParentSK
	, l.[TargetWorkitemSK] AS ChildSK
	, child.System_WorkItemType AS ChildType
	, child.System_Id AS ChildID
	, child.Microsoft_VSTS_Scheduling_Effort
FROM [tfs_warehouse].[dbo].[vFactLinkedCurrentWorkItem] l
INNER JOIN CurrentWorkItemView parent ON l.SourceWorkItemSK = parent.WorkItemSK
INNER JOIN CurrentWorkItemView child ON l.TargetWorkitemSK = child.WorkItemSK
LEFT JOIN (
	SELECT CurrentWorkItemView.WorkItemSK AS FeatureSK
		, CurrentWorkItemView_1.WorkItemSK AS ActivitySK
	FROM CurrentWorkItemView
	INNER JOIN vFactLinkedCurrentWorkItem ON CurrentWorkItemView.WorkItemSK = vFactLinkedCurrentWorkItem.SourceWorkItemSK
	INNER JOIN CurrentWorkItemView AS CurrentWorkItemView_1 ON vFactLinkedCurrentWorkItem.TargetWorkitemSK = CurrentWorkItemView_1.WorkItemSK
	WHERE (vFactLinkedCurrentWorkItem.WorkItemLinkTypeSK = 2)
		AND (CurrentWorkItemView.System_WorkItemType = N'Feature')
		AND (CurrentWorkItemView_1.System_WorkItemType = N'Activity')
	) ff ON l.SourceWorkItemSK = ff.ActivitySK
WHERE l.[WorkItemLinkTypeSK] = 2
	AND parent.TeamProjectCollectionSK = 1
	AND child.System_WorkItemType = 'User Story'
	AND child.IterationPath IN (
		'\MCG\Cite CareWebQI\6.0 Release'
		, '\MCG\Cite Health Management'
		, '\MCG\Cite Auto Auth\4.0 Release'
		, '\MCG\Indicia Care Coordination'
		)
	AND child.System_State IN (
		'New'
		, 'Approved'
		, 'Committed'
		)
ORDER BY parent.IterationPath
	, parent.System_WorkItemType
	, l.[SourceWorkItemSK]
