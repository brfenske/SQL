-- ============================================================
-- Create Event Notifications for Deadlock Graphs
-- ============================================================

-- Change databases to new database
USE [EventNotificationsDB];
GO

-- Create a table to old the deadlock graphs as collected
CREATE TABLE dbo.CapturedDeadlocks
(RowID int identity primary key,
 DeadlockGraph XML,
 VictimPlan XML,
 ContribPlan XML,
 EntryDate datetime default(getdate()));

GO

--  Create the Activation Stored Procedure to Process the Queue
IF EXISTS (SELECT * FROM dbo.sysobjects 
   WHERE id = OBJECT_ID(N'[dbo].[ProcessDeadlockGraphs]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProcessDeadlockGraphs]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ProcessDeadlockGraphs]
WITH EXECUTE AS OWNER
AS 

DECLARE @message_body xml  
DECLARE @message_sequence_number int
DECLARE @dialog uniqueidentifier
DECLARE @email_message nvarchar(MAX)

WHILE (1 = 1)
BEGIN
	BEGIN TRANSACTION

-- Receive the next available message FROM the queue
	
	WAITFOR (
		RECEIVE TOP(1) -- just handle one message at a time
			@message_body=cast(message_body as xml),
			@message_sequence_number=message_sequence_number
			FROM dbo.DeadlockGraphQueue
	), TIMEOUT 1000  -- if the queue is empty for one second, give UPDATE AND GO away

-- If we didn't get anything, bail out
	IF (@@ROWCOUNT = 0)
		BEGIN
			ROLLBACK TRANSACTION
			BREAK
		END 

	-- validate that this is a DEADLOCK_GRAPH event
	IF (@message_body.value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(128)' ) != 'DEADLOCK_GRAPH')
		RETURN;

	DECLARE @deadlock XML,
			@victim varchar(50), 
			@victimplan XML, 
			@contribplan XML

	SELECT @deadlock = @message_body.query('/EVENT_INSTANCE/TextData/*')

	SELECT @victim = @deadlock.value('(deadlock-list/deadlock/@victim)[1]', 'varchar(50)')

	-- Get the victim plan
	SELECT @victimplan = [query_plan] 
	FROM sys.dm_exec_query_stats qs
	CROSS APPLY sys.dm_exec_query_plan([plan_handle])
	WHERE [sql_handle] = @deadlock.value('xs:hexBinary(substring((
		deadlock-list/deadlock/process-list/process[@id=sql:variable("@victim")]/executionStack/frame/@sqlhandle)[1], 
		3))', 'varbinary(max)')
		
	-- Get the contributing query plan
	SELECT @contribplan = [query_plan] 
	FROM sys.dm_exec_query_stats qs
	CROSS APPLY sys.dm_exec_query_plan([plan_handle])
	WHERE [sql_handle] = @deadlock.value('xs:hexBinary(substring((
		deadlock-list/deadlock/process-list/process[@id!=sql:variable("@victim")]/executionStack/frame/@sqlhandle)[1],
		 3))', 'varbinary(max)')

	INSERT INTO dbo.CapturedDeadlocks(DeadlockGraph, VictimPlan, ContribPlan)
	VALUES (@deadlock, @victimplan, @contribplan)
	
	SELECT @email_message = CONVERT(nvarchar(max), @deadlock)
    EXEC msdb.dbo.sp_send_dbmail
             @profile_name = 'Gmail Notification Account', -- your defined email profile 
             @recipients = 'fakeaddress@gmail.com', -- your email
             @subject = 'Deadlock Notification',
             @body = @email_message;
		
--  Commit the transaction.  At any point before this, we could roll 
--  back - the received message would be back on the queue AND the response
--  wouldn't be sent.
	COMMIT TRANSACTION
END
GO

-- Sign the procedure with the certificate's private key
ADD SIGNATURE TO OBJECT::[ProcessDeadlockGraphs]
BY CERTIFICATE [DBMailCertificate] 
WITH PASSWORD = '$tr0ngp@$$w0rd';
GO

--  Create a service broker queue to hold the events
CREATE QUEUE [DeadlockGraphQueue]
	WITH STATUS=ON, 
		 ACTIVATION 
			(PROCEDURE_NAME = [ProcessDeadlockGraphs],
			 MAX_QUEUE_READERS = 1,
			 EXECUTE AS OWNER) 
GO

--  Create a service broker service receive the events
CREATE SERVICE [DeadlockGraphService]
    ON QUEUE [DeadlockGraphQueue] ([http://schemas.microsoft.com/SQL/Notifications/PostEventNotification])
GO

CREATE ROUTE [DeadlockGraphRoute]
    WITH SERVICE_NAME = 'DeadlockGraphService',
    ADDRESS = 'LOCAL';
GO


CREATE EVENT NOTIFICATION [CaptureDeadlockGraphs]
    ON SERVER
    WITH FAN_IN
    FOR DEADLOCK_GRAPH
    TO SERVICE 'DeadlockGraphService', 'current database';
GO


/*
--  Cleanup objects
DROP EVENT NOTIFICATION CaptureDeadlockGraphs ON SERVER
DROP ROUTE DeadlockGraphRoute
DROP SERVICE DeadlockGraphService
DROP QUEUE DeadlockGraphQueue 
*/
