IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.ReleasePlanning')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.ReleasePlanning;
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
CREATE PROCEDURE [dbo].[ReleasePlanning] (
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
			, SUM(CASE 
					WHEN u.CWQI_MMF = 'Yes'
						AND NOT u.Microsoft_VSTS_Scheduling_Effort IS NULL
						THEN u.Microsoft_VSTS_Scheduling_Effort
					ELSE 0
					END) AS MMFYesEffort
		FROM UserStories u
		GROUP BY u.IterationPath
		)
	SELECT *
	FROM Rollup r
	ORDER BY r.IterationPath;
END;
