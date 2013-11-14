IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'Annotations'))
BEGIN
truncate table content.Annotations
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'BulletStatuses'))
BEGIN
truncate table content.BulletStatuses
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'CareFlowHeadings'))
BEGIN
truncate table content.CareFlowHeadings
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'Citations'))
BEGIN
truncate table content.Citations
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'Definitions'))
BEGIN
truncate table content.Definitions
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'FootNotes'))
BEGIN
truncate table content.FootNotes
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'Guidelines'))
BEGIN
truncate table content.Guidelines
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'GuidelineTypes'))
BEGIN
truncate table content.GuidelineTypes
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'LogicStatuses'))
BEGIN
truncate table content.LogicStatuses
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'Products'))
BEGIN
truncate table content.Products
END


IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'ProgressionCategories'))
BEGIN
truncate table content.ProgressionCategories
END


IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'QualityMeasureGroups'))
BEGIN
truncate table content.QualityMeasureGroups
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'QualityMeasures'))
BEGIN
truncate table content.QualityMeasures
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'SearchCode'))
BEGIN
truncate table content.SearchCode
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'SearchCodeRelated'))
BEGIN
truncate table content.SearchCodeRelated
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'SearchData'))
BEGIN
truncate table content.SearchData
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'SearchGuideline'))
BEGIN
truncate table content.SearchGuideline
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'SearchGuidelineRelated'))
BEGIN
truncate table content.SearchGuidelineRelated
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'SearchTermTypes'))
BEGIN
truncate table content.SearchTermTypes
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'Sections'))
BEGIN
truncate table content.Sections
END


IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'SectionTypes'))
BEGIN
truncate table content.SectionTypes
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'Versions'))
BEGIN
truncate table content.Versions
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'AutoAuthorizationSectionText'))
BEGIN
truncate table content.AutoAuthorizationSectionText
END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'content' AND  TABLE_NAME = 'AutoAuthorizationType'))
BEGIN
truncate table content.AutoAuthorizationType
END