USE [Tfs_Milliman]
GO

/****** Object:  StoredProcedure [dbo].[ETDashboard]    Script Date: 11/05/2013 11:31:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ETDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ETDashboard]
GO

USE [Tfs_Milliman]
GO

/****** Object:  StoredProcedure [dbo].[ETDashboard]    Script Date: 11/05/2013 11:31:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Brian F
-- Create date: 2/21/2013
-- Description:	Executive Dashboard Query
-- =============================================
CREATE PROCEDURE [dbo].[ETDashboard] (
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
		, RIGHT(CONVERT(VARCHAR(25), wi.[CG_Business_TargetRelease], 103), 7) AS [Target Release]
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
		WHERE pl.WorkItemLinkTypeSK = @LinkTypeSK
		) charter ON wi.System_Id = charter.System_ID
	WHERE (wi.TeamProjectCollectionSK = @TeamProjectCollectionSK)
		AND (wi.System_WorkItemType = 'Feature')
		AND (wi.System_State <> 'Removed')
		AND wi.IterationPath = COALESCE(@Iteration, wi.IterationPath)
	ORDER BY wi.IterationPath
		, charter.[Priority];
END;

GO


