USE [tfs_warehouse]
GO

/****** Object:  View [dbo].[UserStoriesGold]    Script Date: 11/08/2013 14:10:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.VIEWS
		WHERE object_id = OBJECT_ID(N'[dbo].[UserStoriesGold]')
		)
	DROP VIEW [dbo].[UserStoriesGold]
GO

USE [tfs_warehouse]
GO

/****** Object:  View [dbo].[UserStoriesGold]    Script Date: 11/08/2013 14:10:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[UserStoriesGold]
AS
SELECT TOP (100) PERCENT wi.System_WorkItemType AS Type
	, wi.System_Id AS ID
	, wi.System_Title AS Title
	, SUM(t.Microsoft_VSTS_Scheduling_RemainingWork) AS RemainingHours
	, wi.System_State AS STATE
	, wi.CG_Sprint AS Sprint
FROM dbo.CurrentWorkItemView AS t
LEFT JOIN dbo.vFactLinkedCurrentWorkItem AS l ON t.WorkItemSK = l.SourceWorkItemSK
LEFT JOIN dbo.DimWorkItemLinkType AS lt ON l.WorkItemLinkTypeSK = lt.WorkItemLinkTypeSK
LEFT JOIN dbo.CurrentWorkItemView AS wi ON l.TargetWorkitemSK = wi.WorkItemSK
WHERE (t.TeamProjectCollectionSK = 3)
	AND (t.System_WorkItemType = 'Task')
	AND (wi.System_WorkItemType = 'User Story')
	AND (
		t.System_State IN (
			'In Progress'
			, 'To Do'
			)
		)
	AND (lt.WorkItemLinkTypeSK = 6)
	AND (t.CG_Team = 'Gold')
GROUP BY wi.System_WorkItemType
	, wi.System_Id
	, wi.System_Title
	, wi.CG_Sprint
	, wi.System_State
ORDER BY ID
GO

EXEC sys.sp_addextendedproperty @name = N'MS_DiagramPane1'
	, @value = 
	N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 357
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "l"
            Begin Extent = 
               Top = 6
               Left = 395
               Bottom = 125
               Right = 606
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lt"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "wi"
            Begin Extent = 
               Top = 126
               Left = 299
               Bottom = 245
               Right = 618
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
'
	, @level0type = N'SCHEMA'
	, @level0name = N'dbo'
	, @level1type = N'VIEW'
	, @level1name = N'UserStoriesGold'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount'
	, @value = 1
	, @level0type = N'SCHEMA'
	, @level0name = N'dbo'
	, @level1type = N'VIEW'
	, @level1name = N'UserStoriesGold'
GO


