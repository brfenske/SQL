USE [tfs_warehouse]
GO
/****** Object:  StoredProcedure [dbo].[DailyBuildResults]    Script Date: 06/07/2013 12:18:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[DailyBuildResults] (@BuildGroup VARCHAR(50))
AS
BEGIN
	SET NOCOUNT ON;

	IF CHARINDEX(@BuildGroup, 'Content', 0) > 0
		SELECT c.Build
			, c.[Started]
			, c.[Type]
			, c.Duration
			, c.[Status]
			, c.Passed
			, c.Failed
		FROM (
			SELECT ROW_NUMBER() OVER (
					PARTITION BY b.BuildDefinitionName ORDER BY b.BuildStartTime DESC
					) AS RowNum
				, b.BuildDefinitionName AS [Build]
				, CAST(b.BuildStartTime AS VARCHAR) AS Started
				, b.BuildType AS [Type]
				, CONVERT(VARCHAR, CAST(f.BuildDuration / 60 AS INT)) + ' min' AS Duration
				, s.BuildStatusName AS [Status]
				, COALESCE(t.Passed, 0) AS Passed
				, COALESCE(t.Failed, 0) AS Failed
			FROM DimBuild b
			INNER JOIN FactBuildDetails f ON b.BuildSK = f.BuildSK
			INNER JOIN DimBuildStatus s ON f.BuildStatusSK = s.BuildStatusSK
			LEFT JOIN FactTestResult ftr ON b.BuildSK = ftr.BuildSK
			LEFT JOIN DimTestResult dtr ON ftr.ResultSK = dtr.ResultSK
			LEFT JOIN (
				SELECT BuildName AS 'Build'
					, CONVERT(VARCHAR(20), BuildStartTime, 100) AS BuildStartTime
					, [Passed] AS Passed
					, [Failed] AS Failed
				FROM (
					SELECT dtr.Outcome
						, BuildName
						, BuildStartTime
						, COUNT(*) AS TestCount
					FROM dbo.FactTestResult ftr
					INNER JOIN dbo.DimTestResult dtr ON ftr.ResultSK = dtr.ResultSK
					INNER JOIN dbo.DimBuild db ON ftr.BuildSK = db.BuildSK
					WHERE dtr.TestTypeId = '13cdc9d9-ddb5-4fa4-a97d-d965ccfc6d4b'
					GROUP BY dtr.Outcome
						, BuildName
						, BuildStartTime
					) AS SourceTable
				PIVOT(SUM(TestCount) FOR Outcome IN (
							[Passed]
							, [Failed]
							)) AS PivotTable
				) t ON b.BuildName = t.Build
			WHERE BuildDefinitionName IN (
					'ContentBuilds_Dev_18.0'
					, 'ContentBuilds_Dev_Wellpoint_17.0'
					, 'Content_UpdateContentMap_18.0'
					, 'ContentDB_Main_Deploy_18.0'
					, 'ContentBuilds_GatedCheckin_18.0'
					)
			) c
		WHERE RowNum = 1
		ORDER BY CONVERT(DATETIME, c.[Started]) DESC
	ELSE
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
		ORDER BY b.BuildStartTime DESC
END;
