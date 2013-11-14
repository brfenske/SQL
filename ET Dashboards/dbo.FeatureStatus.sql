USE [Tfs_Milliman]
GO

/****** Object:  StoredProcedure [dbo].[FeatureStatus]    Script Date: 11/01/2013 12:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FeatureStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[FeatureStatus]
GO

USE [Tfs_Milliman]
GO

/****** Object:  StoredProcedure [dbo].[FeatureStatus]    Script Date: 11/01/2013 12:03:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Brian F
-- Create date: 3/26/2013
-- Description:	Feature Status Query
-- =============================================
CREATE PROCEDURE [dbo].[FeatureStatus] (
	@TeamProjectCollectionSK INT = NULL
	, @Iteration VARCHAR(50) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	IF @TeamProjectCollectionSK IS NULL
		SELECT @TeamProjectCollectionSK = [ProjectNodeSK]
		FROM [tfs_warehouse].[dbo].[DimTeamProject]
		WHERE [ProjectNodeTypeName] = 'Team Project Collection'
			AND ProjectNodeName = 'Milliman';

	DECLARE @LinkTypeSK INT;

	SELECT @LinkTypeSK = [WorkItemLinkTypeSK]
	FROM [tfs_warehouse].[dbo].[DimWorkItemLinkType]
	WHERE ReferenceName = 'System.LinkTypes.Hierarchy'
		AND LinkName = 'Child'
		AND TeamProjectCollectionSK = @TeamProjectCollectionSK;

	WITH Features
	AS (
		SELECT c.System_Id AS FeatureID
			, c.System_State AS FeatureState
			, c.IterationPath
			, c.System_Title AS Feature
			, c.WorkItemSK AS FeatureWorkItemSK
		FROM tfs_warehouse.dbo.CurrentWorkItemView AS c
		WHERE c.TeamProjectCollectionSK = @TeamProjectCollectionSK
			AND c.System_WorkItemType = 'Feature'
			AND c.System_State <> 'Removed'
			AND c.IterationPath LIKE COALESCE(@Iteration, '') + '%'
		)
		, UserStories
	AS (
		SELECT f.IterationPath
			, f.FeatureID
			, f.Feature
			, f.FeatureState
			, cUserStory.System_Id AS UserStoryID
			, cUserStory.System_Title AS UserStory
			, cUserStory.System_State AS UserStoryState
			, cUserStory.CWQI_MMF
			, cUserStory.Microsoft_VSTS_Scheduling_Effort
		FROM Features f
		LEFT JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem AS l2 ON f.FeatureWorkItemSK = l2.SourceWorkItemSK
			AND l2.WorkItemLinkTypeSK = @LinkTypeSK
		LEFT JOIN tfs_warehouse.dbo.CurrentWorkItemView AS cUserStory ON l2.TargetWorkitemSK = cUserStory.WorkItemSK
		WHERE cUserStory.System_State <> 'Removed'
			AND cUserStory.System_WorkItemType = 'User Story'
		)
		, Rollup
	AS (
		SELECT u.IterationPath
			, u.FeatureID
			, u.Feature
			, COUNT(u.UserStoryID) AS UserStoryCount
			, SUM(CASE 
					WHEN u.UserStoryState = 'Done'
						THEN 1
					ELSE 0
					END) AS UserStoriesDone
			, SUM(CASE 
					WHEN u.UserStoryState = 'New'
						THEN 1
					ELSE 0
					END) AS UserStoriesNew
			, SUM(CASE 
					WHEN u.UserStoryState = 'Committed'
						THEN 1
					ELSE 0
					END) AS UserStoriesCommitted
			, SUM(CASE 
					WHEN u.UserStoryState = 'Approved'
						THEN 1
					ELSE 0
					END) AS UserStoriesApproved
			, SUM(CASE 
					WHEN u.CWQI_MMF = 'Yes'
						AND NOT u.Microsoft_VSTS_Scheduling_Effort IS NULL
						THEN u.Microsoft_VSTS_Scheduling_Effort
					ELSE 0
					END) AS MMFYes
			, SUM(CASE 
					WHEN u.CWQI_MMF = 'No'
						AND NOT u.Microsoft_VSTS_Scheduling_Effort IS NULL
						THEN u.Microsoft_VSTS_Scheduling_Effort
					ELSE 0
					END) AS MMFNo
			, SUM(CASE 
					WHEN u.UserStoryState = 'Done'
						AND NOT u.Microsoft_VSTS_Scheduling_Effort IS NULL
						THEN u.Microsoft_VSTS_Scheduling_Effort
					ELSE 0
					END) AS PointsCompleted
		FROM UserStories u
		GROUP BY u.IterationPath
			, u.FeatureID
			, u.Feature
			, u.FeatureState
			, u.CWQI_MMF
		)
	SELECT charter.[Priority] AS [Charter Item Priority]
		, r.Feature
		, SUM(r.UserStoryCount) AS [User Stories for Feature]
		, SUM(r.UserStoriesDone) AS [User Stories Done]
		, SUM(r.MMFYes) AS [MMF Yes]
		, SUM(r.MMFNo) AS [MMF No]
		, SUM(r.PointsCompleted) AS [Completed]
		, CASE 
			WHEN SUM(r.MMFYes) > 0
				THEN SUM(r.PointsCompleted) / SUM(r.MMFYes)
			ELSE 0
			END AS [% Points Completed]
		, CASE 
			WHEN SUM(r.UserStoriesCommitted) > 0
				OR (
					SUM(r.UserStoriesDone) BETWEEN 1
						AND SUM(r.UserStoryCount) - 1
					)
				THEN 'In Progress'
			WHEN SUM(r.UserStoriesDone) >= SUM(r.UserStoryCount)
				THEN 'Completed'
			ELSE 'Not Started'
			END AS [Status]
		, '' AS Comments
	FROM Rollup r
	LEFT JOIN (
		SELECT pwi.System_Id
			, pwic.Microsoft_VSTS_Common_Priority AS [Priority]
		FROM tfs_warehouse.dbo.CurrentWorkItemView AS pwic
		INNER JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem AS pl ON pwic.WorkItemSK = pl.SourceWorkItemSK
		INNER JOIN tfs_warehouse.dbo.CurrentWorkItemView AS pwi ON pl.TargetWorkitemSK = pwi.WorkItemSK
		WHERE pl.WorkItemLinkTypeSK = @LinkTypeSK
		) charter ON r.FeatureID = charter.System_ID
	GROUP BY r.IterationPath
		, charter.[Priority]
		, r.FeatureID
		, r.Feature
	ORDER BY charter.[Priority]
		, r.Feature;
END;

GO


