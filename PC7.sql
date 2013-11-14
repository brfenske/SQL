DECLARE @episodeCount INT;

SELECT @episodeCount = COUNT(EpisodeID)
FROM dbo.Episode;

DECLARE @startID INT;
DECLARE @segmentSize INT;

SET @segmentSize = @episodeCount / 6;
SET @startID = (5 * @segmentSize) + 6;

SET NOCOUNT ON;

SELECT EpisodeID FROM Episode WHERE EpisodeID BETWEEN @startID AND @startID + @segmentSize;
