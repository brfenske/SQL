SELECT wiFeat.IterationPath
	, wiFeat.System_Id
	, wiFeat.System_WorkItemType AS [Feature Type]
	, wiFeat.System_Title AS Feature
	, wiUStory.System_WorkItemType AS [SubItem Type]
	, wiUStory.System_Title AS [User Story]
FROM CurrentWorkItemView AS wiUStory
RIGHT JOIN vFactLinkedCurrentWorkItem AS link ON wiUStory.WorkItemSK = link.TargetWorkitemSK
RIGHT JOIN CurrentWorkItemView AS wiFeat ON link.SourceWorkItemSK = wiFeat.WorkItemSK
WHERE (wiFeat.System_WorkItemType = 'Activity')
	AND (wiFeat.TeamProjectCollectionSK = 1)
	AND wiUStory.System_WorkItemType = 'User Story'
	AND wiFeat.IterationPath IN (
		'\MCG\Cite CareWebQI\6.0 Release'
		, '\MCG\Cite Health Management'
		, '\MCG\Cite Auto Auth\4.0 Release'
		, '\MCG\Indicia Care Coordination'
		)
	AND wiUStory.System_State IN (
		'New'
		, 'Approved'
		, 'Committed'
		)
ORDER BY wiFeat.IterationPath
	, wiFeat.System_Title
	, wiUStory.System_WorkItemType
