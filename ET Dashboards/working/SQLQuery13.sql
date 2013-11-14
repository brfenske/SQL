SELECT wi.System_State AS ParentState
	, wi.IterationPath
	, wi.System_Id AS ParentID
	, wi.System_WorkItemType As ParentItemType
	, wi.System_Title AS Parent
	, u.ChildID
	, u.ChildType
	, u.Child
--, COUNT(u.System_WorkItemType)
FROM CurrentWorkItemView wi
INNER JOIN (
	SELECT link.SourceWorkItemSK
		, link.TargetWorkitemSK
		, wiUStory.System_WorkItemType AS ChildType
		, wiUStory.System_Id AS ChildID
		, wiUStory.System_Title AS Child
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
, u.Child