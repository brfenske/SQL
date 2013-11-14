;

WITH Folders
AS (
	SELECT fcc.ChangeSetSK
		, REPLACE(f.FilePath, REPLACE(f.[FileName], '\', ''), '') AS Folder
		, fcc.NetLinesAdded
	FROM FactCodeChurn fcc
	INNER JOIN DimFile f ON fcc.FilenameSK = f.FileSK
	WHERE fcc.TeamProjectSK = 5
		AND f.LastUpdatedDateTime > DATEADD(D, - 7, GETDATE())
	)
SELECT Folder
	, SUM(NetLinesAdded) AS [Net Lines Added]
FROM Folders
GROUP BY Folder
