USE [Recon]
GO

/****** Object:  StoredProcedure [dbo].[NTLogEventInsert]    Script Date: 10/28/2013 14:45:41 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[NTLogEventInsert]')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE [dbo].[NTLogEventInsert]
GO

USE [Recon]
GO

/****** Object:  StoredProcedure [dbo].[NTLogEventInsert]    Script Date: 10/28/2013 14:45:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[NTLogEventInsert] @Category SMALLINT
	, @CategoryString VARCHAR(255)
	, @ComputerName VARCHAR(255)
	, @EventCode SMALLINT
	, @EventIdentifier DECIMAL(18, 0)
	, @EventType TINYINT
	, @Logfile VARCHAR(255)
	, @Message VARCHAR(8000)
	, @RecordNumber DECIMAL(18, 0)
	, @SourceName VARCHAR(255)
	, @TimeGenerated DATETIME
	, @TimeWritten DATETIME
	, @Type VARCHAR(255)
	, @User VARCHAR(255)
AS
SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @MessageID INT;

IF NOT EXISTS (
		SELECT *
		FROM NTLogEvent
		WHERE ComputerName = @ComputerName
			AND RecordNumber = @RecordNumber
		)
BEGIN
	IF NOT EXISTS (
			SELECT MessageText
			FROM NTLogEventMessages
			WHERE MessageText = @Message
			)
		INSERT INTO [dbo].[NTLogEventMessages] ([MessageText])
		SELECT @Message;

	SELECT @MessageID = ID
	FROM NTLogEventMessages
	WHERE MessageText = @Message;

	BEGIN TRANSACTION

	INSERT INTO [dbo].[NTLogEvent] (
		[Category]
		, [CategoryString]
		, [ComputerName]
		, [EventCode]
		, [EventIdentifier]
		, [EventType]
		, [Logfile]
		, [MessageID]
		, [RecordNumber]
		, [SourceName]
		, [TimeGenerated]
		, [TimeWritten]
		, [Type]
		, [User]
		)
	SELECT @Category
		, @CategoryString
		, @ComputerName
		, @EventCode
		, @EventIdentifier
		, @EventType
		, @Logfile
		, @MessageID
		, @RecordNumber
		, @SourceName
		, @TimeGenerated
		, @TimeWritten
		, @Type
		, @User

	COMMIT
END
GO


