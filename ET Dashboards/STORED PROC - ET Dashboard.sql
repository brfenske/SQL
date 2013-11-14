-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian F
-- Create date: 2/21/2013
-- Description:	Executive Dashboard Query
-- =============================================
ALTER PROCEDURE ETDashboard
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @sql NVARCHAR(MAX);
	DECLARE @BusinessReasonFld NVARCHAR(128);
	DECLARE @BusinessSourceFld NVARCHAR(128);
	DECLARE @InitialComplexityEstimateFld NVARCHAR(128);
	DECLARE @CrossProductImplicationsFld NVARCHAR(128);
	DECLARE @CrossTeamImplicationsFld NVARCHAR(128);
	DECLARE @EstimatedEffortFld NVARCHAR(128);
	DECLARE @ActualEffortFld NVARCHAR(128);

    -- Different top-level projects use different custom field names so
    -- we need to dereference them specifically for the given project
	SELECT @BusinessReasonFld = ColName
	FROM Fields
	WHERE [Name] = 'Business Reason'

	SELECT @BusinessSourceFld = ColName
	FROM Fields
	WHERE [Name] = 'Business Source'

	SELECT @InitialComplexityEstimateFld = ColName
	FROM Fields
	WHERE [Name] = 'Initial Complexity Estimate'

	SELECT @CrossProductImplicationsFld = ColName
	FROM Fields
	WHERE [Name] = 'Cross-Product Implications'

	SELECT @CrossTeamImplicationsFld = ColName
	FROM Fields
	WHERE [Name] = 'Cross-Team Implications'

	SELECT @EstimatedEffortFld = ColName
	FROM Fields
	WHERE [Name] = 'Effort'

	SELECT @ActualEffortFld = ColName
	FROM Fields
	WHERE [Name] = 'Actual Effort'

	SET @sql = 'SELECT dbo.LongTextForWorkItem(wil.Id, ''Market Problem'', ''MCG'') AS [Market Problem]
	                , dbo.CleanCheckboxListItems(' + @BusinessReasonFld + ') AS [Business Reason]
	                , dbo.CleanCheckboxListItems(' + @BusinessSourceFld + ') AS [Business Source]
	                , wil.Title AS Feature
	                , dbo.LongTextForWorkItem(wil.Id, ''Description HTML'', ''MCG'') AS [Feature Description]
	                , dbo.CleanCheckboxListItems(' + @InitialComplexityEstimateFld + ') AS [Initial Complexity Estimate]
	                , estEff.[Estimated Effort]
	                , actEff.[Actual Effort]
	                , dbo.CleanCheckboxListItems(' + @CrossProductImplicationsFld + ') AS [Cross Product Implications]
	                , dbo.CleanCheckboxListItems(' + @CrossTeamImplicationsFld + ') AS [Cross Team Implications]
	                , wil.ID
	                , tree.[Name]
                FROM [dbo].[WorkItemsLatest] wil
                LEFT JOIN [dbo].TreeNodes tree ON wil.AreaID = tree.ID
                LEFT JOIN (
	                SELECT l.SourceID
		                , (wiUserStory.' + @EstimatedEffortFld + 
		                ') AS [Estimated Effort]
	                FROM WorkItemsLatest AS wiUserStory
	                INNER JOIN LinksLatest l ON wiUserStory.ID = l.TargetID
	                RIGHT JOIN WorkItemsLatest AS wiFeature ON l.SourceID = wiFeature.ID
	                GROUP BY l.SourceID
		                , wiUserStory.' + @EstimatedEffortFld + '
	                ) estEff ON wil.ID = estEff.SourceID
                LEFT JOIN (
	                SELECT l2.SourceID
		                , (wiUserStory2.' + @ActualEffortFld + ') AS [Actual Effort]
	                FROM WorkItemsLatest AS wiUserStory2
	                INNER JOIN LinksLatest l2 ON wiUserStory2.ID = l2.TargetID
	                RIGHT JOIN WorkItemsLatest AS wiFeature2 ON l2.SourceID = wiFeature2.ID
	                GROUP BY l2.SourceID
		                , wiUserStory2.' + @ActualEffortFld + '
	                ) actEff ON wil.ID = actEff.SourceID
                WHERE wil.[Work Item Type] = ''Feature''
	                AND (
		                wil.[State] = ''New''
		                OR wil.[State] = ''Approved''
		                OR wil.[State] = ''Committed''
		                )';

	EXECUTE sp_executesql @sql
END
GO


