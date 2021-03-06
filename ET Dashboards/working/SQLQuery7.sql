USE [Tfs_Milliman]
GO
/****** Object:  StoredProcedure [dbo].[ETDashboard]    Script Date: 03/07/2013 14:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian F
-- Create date: 2/21/2013
-- Description:	Executive Dashboard Query
-- =============================================
ALTER PROCEDURE [dbo].[ETDashboard] (
	@TeamProjectCollectionSK INT = 1
	, @Iteration VARCHAR(50) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	WITH Features
	AS (
		SELECT System_Id
			, MAX(System_Rev) AS MaxRev
		FROM tfs_warehouse.dbo.CurrentWorkItemView
		WHERE System_WorkItemType = 'Feature'
		GROUP BY System_Id
		)
	SELECT charter.[Priority] AS [Charter Priority]
		, dbo.LongTextForWorkItem(wi.System_Id, 'Market Problem', 'MCG') AS [Market Problem]
		, dbo.CleanCheckboxListItems(wi.CG_Business_BusinessReason) AS [Business Reason]
		, wi.CG_Business_BusinessSource AS [Business Source]
		, wi.System_Title AS Feature
		, dbo.LongTextForWorkItem(wi.System_Id, 'Description HTML', 'MCG') AS [Feature Description]
		, wi.CG_Business_InitialComplexityEstimate AS [Initial Complexity Estimate]
		, estEff.[Estimated Effort] AS [Estimated Effort (Sum)]
		, RIGHT(CONVERT(VARCHAR(25), GETDATE(), 103), 7) AS [Target Release]
		, RIGHT(CONVERT(VARCHAR(25), wi.[CG_Business_EstimatedRelease], 103), 7) AS [Estimated Release]
		, dbo.CleanCheckboxListItems(wi.CG_Business_CrossTeamImplications) AS [Cross Team Implications]
		, dbo.CleanCheckboxListItems(wi.CG_Business_CrossProductImplications) AS [Cross Product Implications]
		, f.System_Id AS [TFS ID]
	FROM Features f
	INNER JOIN tfs_warehouse.dbo.CurrentWorkItemView wi ON f.System_Id = wi.System_Id
		AND f.MaxRev = wi.System_Rev
	LEFT JOIN (
		SELECT wilFeat.WorkItemSK
			, wilFeat.System_id
			, SUM(wilUStory.Microsoft_VSTS_Scheduling_Effort) AS [Estimated Effort]
		FROM tfs_warehouse.dbo.CurrentWorkItemView wilFeat
		INNER JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem l ON wilFeat.WorkItemSK = l.SourceWorkItemSK
		INNER JOIN tfs_warehouse.dbo.CurrentWorkItemView wilUStory ON l.TargetWorkItemSK = wilUStory.WorkItemSK
		WHERE wilfeat.System_WorkItemType = 'Feature'
		GROUP BY wilFeat.WorkItemSK
			, wilFeat.System_id
		) estEff ON wi.System_Id = estEff.System_Id
	LEFT JOIN (
		SELECT pwi.System_Id
			, pwic.Microsoft_VSTS_Common_Priority AS [Priority]
		FROM tfs_warehouse.dbo.CurrentWorkItemView AS pwic
		INNER JOIN tfs_warehouse.dbo.vFactLinkedCurrentWorkItem AS pl ON pwic.WorkItemSK = pl.SourceWorkItemSK
		INNER JOIN tfs_warehouse.dbo.CurrentWorkItemView AS pwi ON pl.TargetWorkitemSK = pwi.WorkItemSK
		WHERE pl.WorkItemLinkTypeSK = 2
		) charter ON wi.System_Id = charter.System_ID
	WHERE (wi.TeamProjectCollectionSK = @TeamProjectCollectionSK)
		AND (wi.System_WorkItemType = 'Feature')
		AND wi.IterationPath = COALESCE(@Iteration, wi.IterationPath)
	ORDER BY wi.IterationPath
		, charter.[Priority];
END;
