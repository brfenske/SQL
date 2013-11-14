SET NOCOUNT ON;

DECLARE @episodeCount INT;
DECLARE @segmentSize INT;
DECLARE @startID INT;

SELECT @episodeCount = COUNT(EpisodeID) FROM dbo.Episode;

SET @segmentSize = @episodeCount / 3;

SET @startID = 1;
IF OBJECT_ID('CME', 'U') IS NOT NULL DROP TABLE dbo.CME;
SELECT EpisodeIDSource, EpisodeID INTO dbo.CME FROM Episode WHERE EpisodeID BETWEEN @startID AND @startID + @segmentSize;

SET @startID = @segmentSize + 2;
IF OBJECT_ID('URNE', 'U') IS NOT NULL DROP TABLE dbo.URNE;
SELECT EpisodeIDSource, EpisodeID INTO dbo.URNE FROM Episode WHERE EpisodeID BETWEEN @startID AND @startID + @segmentSize;

SET @startID = (2 * @segmentSize) + 3;
IF OBJECT_ID('PAE', 'U') IS NOT NULL DROP TABLE dbo.PAE;
SELECT EpisodeIDSource, EpisodeID INTO dbo.PAE FROM Episode WHERE EpisodeID BETWEEN @startID AND @startID + @segmentSize;
