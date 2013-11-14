DECLARE @root INT = 372517;;

WITH Subs
AS (
	SELECT WorkItemSK
		,WorkItemTreeSK
		,IterationPath
		,System_WorkItemType
		,0 AS lvl
	FROM tfs_warehouse.dbo.vDimWorkItemTreeOverlay
	WHERE WorkItemSK = @root
	
	UNION ALL
	
	SELECT v.WorkItemSK
		,v.WorkItemTreeSK
		,v.IterationPath
		,v.System_WorkItemType
		,p.lvl + 1
	FROM Subs p
	INNER JOIN tfs_warehouse.dbo.vDimWorkItemTreeOverlay v ON v.ParentWorkItemTreeSK = p.WorkItemTreeSK
	)
SELECT *
FROM Subs
	--,
	--Activities as
	--(
	--SELECT WorkItemTreeSK
	--	,IterationPath
	--	,System_WorkItemType
	--FROM tfs_warehouse.dbo.vDimWorkItemTreeOverlay v
	--join Features f.WorkItemTreeSK = v.ParentWorkItemTreeSK
	--WHERE IterationTeamProjectCollection = 'Milliman'
	--	AND System_WorkItemType = 'Activity'
	--)
	----WHERE IterationTeamProjectCollection = 'Milliman'
	----	AND System_WorkItemType = 'Feature'
