IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.DailyBuildTestResults')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.DailyBuildTestResults;
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
CREATE PROCEDURE [dbo].[DailyBuildTestResults] (@BuildGroup VARCHAR(50))
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @MostRecentBuild VARCHAR(50);
	DECLARE @BuildGroupDay VARCHAR(50);

	SELECT TOP 1 @MostRecentBuild = BuildName
	FROM DimBuild
	WHERE BuildName LIKE @BuildGroup
	ORDER BY BuildStartTime DESC;

	SET @BuildGroupDay = SUBSTRING(REVERSE(@MostRecentBuild), CHARINDEX('.', REVERSE(@MostRecentBuild)), LEN(@MostRecentBuild));
	SET @BuildGroupDay = REVERSE(@BuildGroupDay) + '%';

	SELECT BuildName AS 'Build'
		, CONVERT(VARCHAR(20), BuildStartTime, 100) AS BuildStartTime
		, COALESCE([Passed], 0) AS Passed
		, COALESCE([Failed], 0) AS Failed
	FROM (
		SELECT dtr.OutcomeSELECT     DimBuild.BuildName, DimBuild.BuildType, DimBuild.BuildStartTime, DimBuild.TeamProjectCollectionSK, FactBuildDetails.LastUpdatedDateTime, 
                      FactBuildDetails.BuildStatusSK, DimBuildStatus.BuildStatusName, FactBuildProject.CompileErrors, FactBuildProject.CompileWarnings, 
                      FactBuildProject.StaticAnalysisErrors, FactBuildProject.StaticAnalysisWarnings
FROM         DimBuild INNER JOIN
                      FactBuildDetails ON DimBuild.BuildSK = FactBuildDetails.BuildSK INNER JOIN
                      DimBuildStatus ON FactBuildDetails.BuildStatusSK = DimBuildStatus.BuildStatusSK INNER JOIN
                      FactBuildProject ON DimBuild.BuildSK = FactBuildProject.BuildSK
			, BuildName
			, BuildStartTime
			, COUNT(*) AS TestCount
		FROM dbo.FactTestResult ftr
		INNER JOIN dbo.DimTestResult dtr ON ftr.ResultSK = dtr.ResultSK
		INNER JOIN dbo.DimBuild db ON ftr.BuildSK = db.BuildSK
		WHERE dtr.TestTypeId = '13cdc9d9-ddb5-4fa4-a97d-d965ccfc6d4b'
			AND (BuildName LIKE @BuildGroupDay)
		GROUP BY dtr.Outcome
			, BuildName
			, BuildStartTime
		) AS SourceTable
	PIVOT(SUM(TestCount) FOR Outcome IN (
				[Passed]
				, [Failed]
				)) AS PivotTable
	ORDER BY BuildStartTime;
END;
