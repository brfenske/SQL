--USE [iCCG]

--Program
SET IDENTITY_INSERT [iCCG].[Program] ON
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (1, N'Asthma - Adult', 1, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (2, N'Asthma - Pediatric', 2, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (3, N'Cancer - Low', 3, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (4, N'Children with Special Health Care Needs - Low', 4, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (5, N'Complex Case Management', 5, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (6, N'COPD', 6, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (7, N'Coronary Artery Disease', 7, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (8, N'Cystic Fibrosis - Low', 8, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (9, N'Diabetes', 9, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (10, N'Heart Failure', 10, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (11, N'High Risk Pregnancy', 11, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (12, N'HIV/AIDS - Low', 12, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (13, N'Kidney Disease - Low', 13, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (14, N'Liver Disease - Low', 14, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (15, N'Multiple Sclerosis - Low', 15, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (16, N'Organ Transplant - Low', 16, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (17, N'Parkinson Disease - Low', 17, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (18, N'Sickle Cell Disease - Low', 18, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (19, N'Spinal Cord Injury - Low', 19, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (20, N'Stroke - Low', 20, 1, 1)
INSERT [iCCG].[Program] ([ProgramID], [Description], [Ordinal], [OptIn], [InsertBy]) VALUES (21, N'Traumatic Brain Injury - Low', 21, 1, 1)

SET IDENTITY_INSERT [iCCG].[Program] OFF
GO

-- ProgramGuideline
SET IDENTITY_INSERT [iCCG].[ProgramGuideline] ON

INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (1,1,'Asthma - Adult','iccg_105',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (2,2,'Asthma - Pediatric','iccg_106',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (3,3,'Cancer - Low','iccg_113',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (4,4,'Children with Special Health Care Needs - Low','iccg_114',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (5,5,'Complex Case Management','iccg_107',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (6,6,'COPD','iccg_108',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (7,7,'Coronary Artery Disease','iccg_109',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (8,8,'Cystic Fibrosis - Low','iccg_115',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (9,9,'Diabetes','iccg_110',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (10,9,'Coronary Artery Disease','iccg_110',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (11,10,'Heart Failure','iccg_111',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (12,11,'High Risk Pregnancy','iccg_112',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (13,12,'HIV/AIDS - Low','iccg_116',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (14,13,'Kidney Disease - Low','iccg_117',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (15,14,'Liver Disease - Low','iccg_118',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (16,15,'Multiple Sclerosis - Low','iccg_119',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (17,16,'Organ Transplant - Low','iccg_120',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (18,17,'Parkinson Disease - Low','iccg_121',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (19,18,'Sickle Cell Disease - Low','iccg_122',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (20,19,'Spinal Cord Injury - Low','iccg_123',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (21,20,'Stroke - Low','iccg_124',1,1)
INSERT INTO [iCCG].[ProgramGuideline] ([ProgramGuidelineID],[ProgramID],[GuidelineTitle],[ProductCode],[HSIM],[Ordinal],[InsertBy]) VALUES (22,21,'Traumatic Brain Injury - Low','iccg_125',1,1)

SET IDENTITY_INSERT [iCCG].[ProgramGuideline] OFF