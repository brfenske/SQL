SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian F
-- Create date: 2/20/2013
-- Description:	Rolls up Effort for a given Feature
-- =============================================
CREATE FUNCTION FeatureEffort (
	@FeatureWorkItemSK INT
	)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT;

	WITH UserStories
	AS (
		SELECT wito.WorkItemSK
			,wito.WorkItemTreeSK
			,wito.IterationPath
			,wito.System_WorkItemType
			,cwiv.System_Id
			,cwiv.System_Title
			,cwiv.Microsoft_VSTS_Scheduling_Effort
			,0 AS lvl
		FROM tfs_warehouse.dbo.vDimWorkItemTreeOverlay wito
		INNER JOIN CurrentWorkItemView cwiv ON wito.WorkItemSK = cwiv.WorkItemSK
		WHERE wito.WorkItemSK = @FeatureWorkItemSK
		
		UNION ALL
		
		SELECT v.WorkItemSK
			,v.WorkItemTreeSK
			,v.IterationPath
			,v.System_WorkItemType
			,cwiv.System_Id
			,cwiv.System_Title
			,cwiv.Microsoft_VSTS_Scheduling_Effort
			,p.lvl + 1
		FROM UserStories p
		INNER JOIN CurrentWorkItemView cwiv ON p.WorkItemSK = cwiv.WorkItemSK
		INNER JOIN tfs_warehouse.dbo.vDimWorkItemTreeOverlay v ON v.ParentWorkItemTreeSK = p.WorkItemTreeSK
		)
		,Features
	AS (
		SELECT DISTINCT System_Id
			,System_Title
			,Microsoft_VSTS_Scheduling_Effort
		FROM UserStories
		)
	SELECT @Result = SUM(Microsoft_VSTS_Scheduling_Effort)
	FROM Features;

	RETURN @Result;
END
GO


