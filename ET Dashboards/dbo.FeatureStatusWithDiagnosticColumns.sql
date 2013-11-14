IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.FeatureStatus')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.FeatureStatus;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian F
-- Create date: 3/26/2013
-- Description:	Feature Status Query
-- =============================================
CREATE PROCEDURE dbo.FeatureStatus (
	@TeamProjectCollectionSK INT = 1
	, @Iteration VARCHAR(50) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	WITH Features
	AS (
		SELECT c.System_Id AS FeatureID
			, c.System_State AS FeatureState
			, c.IterationPath
			, c.System_Title AS Feature
			, c.WorkItemSK AS FeatureWorkItemSK
		FROM tfs_warehouse.dbo.CurrentWorkItemView AS c
		WHERE c.TeamProjectCollectionSK = @teamProjectCollectionSK
			AND c.System_WorkItemType = 'Feature'
			AND c.System_State <> 'Removed'
			AND c.IterationPath LIKE COALESCE(@Iteration, '') + '%'
			--AND c.IterationPath IN (
			--	'\MCG\Cite Auto Auth\4.0 Release'
			--	, '\MCG\Cite CareWebQI\6.0 Release'
			--	, '\MCG\Cite Health Management\3.0 Release'
			--	, '\MCG\Indicia\Care Coordination'
			--	)
		)
		, Activities
	AS (
		SELECT f.FeatureID
			, f.IterationPath
			, f.Feature
			, f.FeatureState
			, cActivity.WorkItemSK AS ActivityWorkItemSK
		FROM Features f
		INNER JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem AS l ON f.FeatureWorkItemSK = l.SourceWorkItemSK
		INNER JOIN tfs_warehouse.dbo.CurrentWorkItemView AS cActivity ON l.TargetWorkitemSK = cActivity.WorkItemSK
		WHERE cActivity.System_State <> 'Removed'
			AND cActivity.System_WorkItemType = 'Activity'
		)
		, UserStories
	AS (
		SELECT a.IterationPath
			, a.FeatureID
			, a.Feature
			, a.FeatureState
			, cUserStory.System_Id AS UserStoryID
			, cUserStory.System_Title AS UserStory
			, cUserStory.System_State AS UserStoryState
			, cUserStory.CWQI_MMF
			, cUserStory.Microsoft_VSTS_Scheduling_Effort
		FROM Activities a
		INNER JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem AS l2 ON a.ActivityWorkItemSK = l2.SourceWorkItemSK
		INNER JOIN tfs_warehouse.dbo.CurrentWorkItemView AS cUserStory ON l2.TargetWorkitemSK = cUserStory.WorkItemSK
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
					WHEN u.FeatureState = 'Done'
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
	SELECT r.IterationPath
		, charter.[Priority]
		, r.FeatureID
		, r.Feature
		, SUM(r.UserStoryCount) AS [User Story Count]
		, SUM(r.UserStoriesNew) AS [New]
		, SUM(r.UserStoriesApproved) AS [Approved]
		, SUM(r.UserStoriesCommitted) AS [Committed]
		, SUM(r.UserStoriesDone) AS Done
		, SUM(r.MMFYes) AS [MMF Yes]
		, SUM(r.MMFNo) AS [MMF No]
		, SUM(r.PointsCompleted) AS [Points Completed]
		, CASE 
			WHEN SUM(r.PointsCompleted) > 0
				THEN (SUM(r.PointsCompleted) / (SUM(r.MMFYes) + SUM(r.MMFNo))) * 100
			ELSE 0
			END AS [% Complete]
		, CASE 
			WHEN SUM(r.UserStoriesCommitted) > 0
				THEN 'In Progress'
			WHEN SUM(r.UserStoryCount) = SUM(r.UserStoriesDone)
				THEN 'Completed'
			ELSE 'Not Started'
			END AS [Status]
	FROM Rollup r
	LEFT JOIN (
		SELECT pwi.System_Id
			, pwic.Microsoft_VSTS_Common_Priority AS [Priority]
		FROM tfs_warehouse.dbo.CurrentWorkItemView AS pwic
		INNER JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem AS pl ON pwic.WorkItemSK = pl.SourceWorkItemSK
		INNER JOIN tfs_warehouse.dbo.CurrentWorkItemView AS pwi ON pl.TargetWorkitemSK = pwi.WorkItemSK
		WHERE pl.WorkItemLinkTypeSK = 2
		) charter ON r.FeatureID = charter.System_ID
	GROUP BY r.IterationPath
		, charter.[Priority]
		, r.FeatureID
		, r.Feature
	ORDER BY r.IterationPath
		, charter.[Priority]
		, r.Feature;
END;
