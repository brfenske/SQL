IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.RecentBuildResults')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.RecentBuildResults;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RecentBuildResults] (@BuildGroup VARCHAR(50))
AS
BEGIN
	SET NOCOUNT ON;

	--DECLARE @BuildGroup VARCHAR(50);
	--SET @BuildGroup = 'Release_CHM22CiteHM_2.2%';
	--DECLARE @MostRecentBuild VARCHAR(50);
	--DECLARE @BuildGroupDay VARCHAR(50);

	--SELECT TOP 1 @MostRecentBuild = BuildName
	--FROM DimBuild
	--WHERE BuildName LIKE @BuildGroup
	--ORDER BY BuildStartTime DESC;

	--SET @BuildGroupDay = SUBSTRING(REVERSE(@MostRecentBuild), CHARINDEX('.', REVERSE(@MostRecentBuild)), LEN(@MostRecentBuild));
	--SET @BuildGroupDay = REVERSE(@BuildGroupDay) + '%';

	SELECT TOP 6 b.BuildDefinitionName AS [Build]
		, CAST(b.BuildStartTime AS VARCHAR) AS Started
		, b.BuildType AS [Type]
		, CONVERT(VARCHAR, CAST(f.BuildDuration / 60 AS INT)) + ' min' AS Duration
		, s.BuildStatusName AS [Status]
		, t.Passed
		, t.Failed
	FROM DimBuild b
	INNER JOIN FactBuildDetails f ON b.BuildSK = f.BuildSK
	INNER JOIN DimBuildStatus s ON f.BuildStatusSK = s.BuildStatusSK
	INNER JOIN (
		SELECT BuildName AS 'Build'
			, CONVERT(VARCHAR(20), BuildStartTime, 100) AS BuildStartTime
			, COALESCE([Passed], 0) AS Passed
			, COALESCE([Failed], 0) AS Failed
		FROM (
			SELECT dtr.Outcome
				, BuildName
				, BuildStartTime
				, COUNT(*) AS TestCount
			FROM dbo.FactTestResult ftr
			INNER JOIN dbo.DimTestResult dtr ON ftr.ResultSK = dtr.ResultSK
			INNER JOIN dbo.DimBuild db ON ftr.BuildSK = db.BuildSK
			WHERE dtr.TestTypeId = '13cdc9d9-ddb5-4fa4-a97d-d965ccfc6d4b'
				AND (BuildName LIKE @BuildGroup)
			GROUP BY dtr.Outcome
				, BuildName
				, BuildStartTime
			) AS SourceTable
		PIVOT(SUM(TestCount) FOR Outcome IN (
					[Passed]
					, [Failed]
					)) AS PivotTable
		) t ON b.BuildName = t.Build
	--WHERE (b.BuildName LIKE @BuildGroup)
	--	AND f.LastUpdatedDateTime > CAST(GETDATE() AS DATE)
	ORDER BY b.BuildStartTime
END;
	--	SET NOCOUNT ON;
	--	SELECT DISTINCT DimBuild.BuildDefinitionName AS [Build]
	--		, CAST(DimBuild.BuildStartTime AS VARCHAR) AS Started
	--		, DimBuild.BuildType AS [Type]
	--		, CONVERT(VARCHAR, CAST(FactBuildDetails.BuildDuration / 60 AS INT)) + ' min' AS Duration
	--		, DimBuildStatus.BuildStatusName AS [Status]
	--	FROM DimBuild
	--	INNER JOIN FactBuildDetails ON DimBuild.BuildSK = FactBuildDetails.BuildSK
	--	INNER JOIN DimBuildStatus ON FactBuildDetails.BuildStatusSK = DimBuildStatus.BuildStatusSK
	--	WHERE (DimBuild.BuildName LIKE @BuildGroup)
	--		AND FactBuildDetails.LastUpdatedDateTime > CAST(GETDATE() AS DATE)
	--END;
