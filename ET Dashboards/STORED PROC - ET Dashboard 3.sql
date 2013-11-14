IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ETDashboard]')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ETDashboard];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian F
-- Create date: 2/21/2013
-- Description:	Executive Dashboard Query
-- =============================================
CREATE PROCEDURE [dbo].[ETDashboard] (@Iteration VARCHAR(50) = NULL)
AS
BEGIN
	SET NOCOUNT ON;

	WITH Features
	AS (
		SELECT System_Id
			, MAX([System_Rev]) AS MaxRev
		FROM [tfs_warehouse].[dbo].[CurrentWorkItemView]
		WHERE System_WorkItemType = 'Feature'
		GROUP BY System_Id
		)
	SELECT tfs_millimansandbox.dbo.LongTextForWorkItem(wi.System_Id, 'Market Problem', 'MCG') AS [Market Problem]
		, tfs_millimansandbox.dbo.CleanCheckboxListItems(wi.CG_Business_BusinessReason) AS [Business Reason]
		, wi.CG_Business_BusinessSource AS [Business Source]
		, wi.System_Title AS Feature
		, tfs_millimansandbox.dbo.LongTextForWorkItem(wi.System_Id, 'Description HTML', 'MCG') AS [Feature Description]
		, wi.CG_Business_InitialComplexityEstimate AS [Initial Complexity Estimate]
		, estEff.[Estimated Effort]
		, RIGHT(CONVERT(VARCHAR(25), wi.[CG_Business_EstimatedRelease], 103), 7) AS [Estimated Release]
		, tfs_millimansandbox.dbo.CleanCheckboxListItems(wi.CG_Business_CrossTeamImplications) AS [Cross Team Implications]
		, tfs_millimansandbox.dbo.CleanCheckboxListItems(wi.CG_Business_CrossProductImplications) AS [Cross Product Implications]
		, f.System_Id
		, wi.WorkItemSK
		, wi.IterationPath
	FROM Features f
	INNER JOIN [tfs_warehouse].[dbo].[CurrentWorkItemView] wi ON f.System_Id = wi.System_Id
		AND f.MaxRev = wi.System_Rev
	LEFT JOIN (
		SELECT wilFeat.WorkItemSK
			, wilFeat.System_id
			, SUM(wilUStory.Microsoft_VSTS_Scheduling_Effort) AS [Estimated Effort]
		FROM [tfs_warehouse].[dbo].[CurrentWorkItemView] wilFeat
		INNER JOIN [tfs_warehouse].[dbo].[vFactLinkedCurrentWorkItem] l ON wilFeat.WorkItemSK = l.SourceWorkItemSK
		INNER JOIN [tfs_warehouse].[dbo].[CurrentWorkItemView] wilUStory ON l.TargetWorkItemSK = wilUStory.WorkItemSK
		WHERE wilfeat.System_WorkItemType = 'Feature'
		GROUP BY wilFeat.WorkItemSK
			, wilFeat.System_id
		) estEff ON wi.System_Id = estEff.System_Id
	WHERE (wi.TeamProjectCollectionSK = 2)
		AND (wi.System_WorkItemType = 'Feature')
		AND wi.IterationPath = COALESCE(@Iteration, wi.IterationPath)
	ORDER BY wi.IterationPath
		, System_Title;
END;
