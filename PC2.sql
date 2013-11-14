DECLARE @episodeCount INT;

SELECT @episodeCount = COUNT(EpisodeID)
FROM dbo.Episode;

DECLARE @startID INT;
DECLARE @segmentSize INT;

SET @segmentSize = @episodeCount / 6;
SET @startID = 1;

SELECT EpisodeID
FROM Episode
WHERE EpisodeID BETWEEN @startID
		AND @startID + @segmentSize;
