DECLARE @teamProjectCollectionSK INT = 1;

SELECT c.System_Id
	, c.IterationPath
	, c.System_Title AS 'Feature'
	, c.WorkItemSK AS 'Feature WorkItemSK'
	, l.TargetWorkitemSK AS 'Activity WorkItemSK'
	, l2.TargetWorkitemSK AS 'User Story WorkItemSK'
	, cUStory.System_Title
	, cUStory.Microsoft_VSTS_Scheduling_Effort
	, cUStory.system_state
FROM tfs_warehouse.dbo.CurrentWorkItemView AS c
INNER JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem AS l ON c.WorkItemSK = l.SourceWorkItemSK
INNER JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem AS l2 ON l.TargetWorkitemSK = l2.SourceWorkItemSK
INNER JOIN tfs_warehouse.dbo.CurrentWorkItemView AS cUStory ON l2.TargetWorkitemSK = cUStory.WorkItemSK
WHERE c.TeamProjectCollectionSK = @teamProjectCollectionSK
	AND c.System_WorkItemType = 'Feature'
	AND c.System_State <> 'Removed'
	AND c.IterationPath IN (
		'\MCG\Cite Auto Auth\4.0 Release'
		, '\MCG\Cite CareWebQI\6.0 Release'
		, '\MCG\Cite Health Management\3.0 Release'
		, '\MCG\Indicia\Care Coordination'
		)
	AND l.WorkItemLinkTypeSK = 2
	AND l2.WorkItemLinkTypeSK = 2
	AND cUStory.System_WorkItemType = 'User Story'
	and cUStory.system_state <> 'Removed'
ORDER BY IterationPath
	, c.WorkItemSK
	, l.TargetWorkitemSK
	, l2.TargetWorkitemSK
