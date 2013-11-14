SELECT LinkFeatureActivity.LinkType
	,WorkItemsLatest_Feature.Title AS Feature
	,WorkItemsLatest_Activity.Title AS Activity
	,WorkItemsLatest_UserStory.Title AS UserStory
	,WorkItemsLatest_ProductBacklogItem.Title AS ProductBacklogItem
	,WorkItemsLatest_Task.Title AS Task
FROM WorkItemsLatest AS WorkItemsLatest_Task
RIGHT JOIN LinksLatest AS LinkTask ON WorkItemsLatest_Task.ID = LinkTask.TargetID
RIGHT JOIN WorkItemsLatest AS WorkItemsLatest_ProductBacklogItem ON LinkTask.SourceID = WorkItemsLatest_ProductBacklogItem.ID
RIGHT JOIN LinksLatest AS LinkUserStoryProductBacklogItem ON WorkItemsLatest_ProductBacklogItem.ID = LinkUserStoryProductBacklogItem.TargetID
RIGHT JOIN WorkItemsLatest AS WorkItemsLatest_UserStory ON LinkUserStoryProductBacklogItem.SourceID = WorkItemsLatest_UserStory.ID
RIGHT JOIN LinksLatest AS LinkActivityUserStory ON WorkItemsLatest_UserStory.ID = LinkActivityUserStory.TargetID
RIGHT JOIN WorkItemsLatest AS WorkItemsLatest_Activity ON LinkActivityUserStory.SourceID = WorkItemsLatest_Activity.ID
RIGHT JOIN LinksLatest AS LinkFeatureActivity ON WorkItemsLatest_Activity.ID = LinkFeatureActivity.TargetID
RIGHT JOIN WorkItemsLatest AS WorkItemsLatest_Feature ON LinkFeatureActivity.SourceID = WorkItemsLatest_Feature.ID
WHERE (LinkFeatureActivity.LinkType = 2)
	AND (WorkItemsLatest_Feature.[Work Item Type] = N'Feature')
	AND (WorkItemsLatest_Activity.[Work Item Type] = N'Activity')
	AND (WorkItemsLatest_UserStory.[Work Item Type] = N'User Story')
	AND (WorkItemsLatest_ProductBacklogItem.[Work Item Type] = N'Product Backlog Item')
	AND (WorkItemsLatest_Task.[Work Item Type] = N'Task')
