SELECT wi.System_State
	, wi.IterationPath
	, wi.System_Id AS ParentID
	, wi.System_WorkItemType
	, wi.System_Title
	, u.UserStoryID
	, u.UserStory
--, COUNT(u.System_WorkItemType)
FROM CurrentWorkItemView wi
INNER JOIN (
	SELECT link.SourceWorkItemSK
		, link.TargetWorkitemSK
		, wiUStory.System_WorkItemType
		, wiUStory.System_Id AS UserStoryID
		, wiUStory.System_Title AS UserStory
	FROM vFactLinkedCurrentWorkItem link
	INNER JOIN CurrentWorkItemView wiUStory ON link.TargetWorkitemSK = wiUStory.WorkItemSK
	WHERE (link.WorkItemLinkTypeSK = 2)
		AND (wiUStory.System_WorkItemType = N'User Story')
	) u ON wi.WorkItemSK = u.SourceWorkItemSK
WHERE wi.TeamProjectCollectionSK = 1
	AND wi.System_State IN (
		'Approved'
		, 'Created'
		, 'Committed'
		, 'New'
		)
--GROUP BY wi.System_WorkItemType
ORDER BY wi.System_State
	, wi.IterationPath
	, wi.System_WorkItemType
	, wi.System_Id
