SELECT c.System_Id
	, c.System_Rev
	, SUM(c2.Microsoft_VSTS_Scheduling_Effort) AS TotalPoints
FROM CurrentWorkItemView AS c
INNER JOIN vFactLinkedCurrentWorkItem AS l ON c.WorkItemSK = l.SourceWorkItemSK
INNER JOIN vFactLinkedCurrentWorkItem AS l2 ON l.TargetWorkitemSK = l2.SourceWorkItemSK
INNER JOIN CurrentWorkItemView AS c2 ON l2.TargetWorkitemSK = c2.WorkItemSK
	AND l2.WorkItemLinkTypeSK = 11
INNER JOIN (
	SELECT c.System_Id
		, c.System_Rev
		, SUM(c2.Microsoft_VSTS_Scheduling_Effort) AS TotalPoints
	FROM CurrentWorkItemView AS c
	INNER JOIN vFactLinkedCurrentWorkItem AS l ON c.WorkItemSK = l.SourceWorkItemSK
	INNER JOIN vFactLinkedCurrentWorkItem AS l2 ON l.TargetWorkitemSK = l2.SourceWorkItemSK
	INNER JOIN CurrentWorkItemView AS c2 ON l2.TargetWorkitemSK = c2.WorkItemSK
		AND l2.WorkItemLinkTypeSK = 11
	WHERE (c.TeamProjectCollectionSK = 2)
		AND (c.System_Id = 323)
		AND (l.WorkItemLinkTypeSK = 11)
		AND c.System_State = 'New'
	GROUP BY c.System_Id
		, c.System_Rev
	) x ON x.System_Id = c.System_id
WHERE (c.TeamProjectCollectionSK = 2)
	AND (c.System_Id = 323)
	AND (l.WorkItemLinkTypeSK = 11)
GROUP BY c.System_Id
	, c.System_Rev
ORDER BY c.System_Id
	, c.System_Rev
