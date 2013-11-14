/*
Deployment script for CareWebQIDb
*/
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


PRINT N'Creating [workflow]...';


GO
CREATE SCHEMA [workflow]
    AUTHORIZATION [dbo];


GO

PRINT N'Creating [workflow].[RefTask]...';


GO
CREATE TABLE [workflow].[RefTask] (
    [RefTaskID]     INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RefTaskName]   VARCHAR (100) NOT NULL,
    [Description]   VARCHAR (255) NULL,
    [RefWorkflowID] INT           NOT NULL,
    [Active]        BIT           NOT NULL,
    [InsertDate]    DATETIME      NOT NULL,
    [InsertUserID]  INT           NULL,
    [UpdateDate]    DATETIME      NULL,
    [UpdateUserID]  INT           NULL
);


GO
PRINT N'Creating PK_RefTask...';


GO
ALTER TABLE [workflow].[RefTask]
    ADD CONSTRAINT [PK_RefTask] PRIMARY KEY CLUSTERED ([RefTaskID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [workflow].[StateTask]...';


GO
CREATE TABLE [workflow].[StateTask] (
    [StateTaskID]     INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [StartRefStateID] INT      NOT NULL,
    [EndRefStateID]   INT      NOT NULL,
    [RefTaskID]       INT      NOT NULL,
    [RefTaskStatusID] INT      NOT NULL,
    [Active]          BIT      NOT NULL,
    [InsertDate]      DATETIME NOT NULL,
    [InsertUserID]    INT      NULL,
    [UpdateDate]      DATETIME NULL,
    [UpdateUserID]    INT      NULL
);


GO
PRINT N'Creating PK_StateTask...';


GO
ALTER TABLE [workflow].[StateTask]
    ADD CONSTRAINT [PK_StateTask] PRIMARY KEY CLUSTERED ([StateTaskID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [workflow].[RefWorkflow]...';


GO
CREATE TABLE [workflow].[RefWorkflow] (
    [RefWorkflowID]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RefWorkflowName] VARCHAR (100) NOT NULL,
    [Description]     VARCHAR (255) NULL,
    [StateObject]     VARCHAR (255) NULL,
    [Active]          BIT           NOT NULL,
    [InsertDate]      DATETIME      NOT NULL,
    [InsertUserID]    INT           NULL,
    [UpdateDate]      DATETIME      NULL,
    [UpdateUserID]    INT           NULL
);


GO
PRINT N'Creating PK_RefWorkflow...';


GO
ALTER TABLE [workflow].[RefWorkflow]
    ADD CONSTRAINT [PK_RefWorkflow] PRIMARY KEY CLUSTERED ([RefWorkflowID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [workflow].[RefState]...';


GO
CREATE TABLE [workflow].[RefState] (
    [RefStateID]    INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RefStateName]  VARCHAR (100) NOT NULL,
    [Description]   VARCHAR (255) NULL,
    [RefWorkflowID] INT           NOT NULL,
    [RefObjectID]   INT           NOT NULL,
    [Active]        BIT           NOT NULL,
    [InsertDate]    DATETIME      NOT NULL,
    [InsertUserID]  INT           NULL,
    [UpdateDate]    DATETIME      NULL,
    [UpdateUserID]  INT           NULL
);


GO
PRINT N'Creating PK_RefState...';


GO
ALTER TABLE [workflow].[RefState]
    ADD CONSTRAINT [PK_RefState] PRIMARY KEY CLUSTERED ([RefStateID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [workflow].[RefTaskStatus]...';


GO
CREATE TABLE [workflow].[RefTaskStatus] (
    [RefTaskStatusID]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RefTaskStatusName] VARCHAR (100) NOT NULL,
    [Description]       VARCHAR (255) NULL,
    [Active]            BIT           NOT NULL,
    [InsertDate]        DATETIME      NOT NULL,
    [InsertUserID]      INT           NULL,
    [UpdateDate]        DATETIME      NULL,
    [UpdateUserID]      INT           NULL
);


GO
PRINT N'Creating PK_RefTaskStatus...';


GO
ALTER TABLE [workflow].[RefTaskStatus]
    ADD CONSTRAINT [PK_RefTaskStatus] PRIMARY KEY CLUSTERED ([RefTaskStatusID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating DF_RefTask_Active...';


GO
ALTER TABLE [workflow].[RefTask]
    ADD CONSTRAINT [DF_RefTask_Active] DEFAULT ((1)) FOR [Active];


GO
PRINT N'Creating DF__RefTask__InsertD__0DAF0CB0...';


GO
ALTER TABLE [workflow].[RefTask]
    ADD DEFAULT (getutcdate()) FOR [InsertDate];


GO
PRINT N'Creating DF__RefTask__UpdateD__0EA330E9...';


GO
ALTER TABLE [workflow].[RefTask]
    ADD DEFAULT (getutcdate()) FOR [UpdateDate];


GO
PRINT N'Creating DF_StateTask_Active...';


GO
ALTER TABLE [workflow].[StateTask]
    ADD CONSTRAINT [DF_StateTask_Active] DEFAULT ((1)) FOR [Active];


GO
PRINT N'Creating DF__StateTask__Inser__1367E606...';


GO
ALTER TABLE [workflow].[StateTask]
    ADD DEFAULT (getutcdate()) FOR [InsertDate];


GO
PRINT N'Creating DF__StateTask__Updat__145C0A3F...';


GO
ALTER TABLE [workflow].[StateTask]
    ADD DEFAULT (getutcdate()) FOR [UpdateDate];


GO
PRINT N'Creating DF_RefWorkflow_Active...';


GO
ALTER TABLE [workflow].[RefWorkflow]
    ADD CONSTRAINT [DF_RefWorkflow_Active] DEFAULT ((1)) FOR [Active];


GO
PRINT N'Creating DF__RefWorkfl__Inser__7E6CC920...';


GO
ALTER TABLE [workflow].[RefWorkflow]
    ADD DEFAULT (getutcdate()) FOR [InsertDate];


GO
PRINT N'Creating DF__RefWorkfl__Updat__7F60ED59...';


GO
ALTER TABLE [workflow].[RefWorkflow]
    ADD DEFAULT (getutcdate()) FOR [UpdateDate];


GO
PRINT N'Creating DF_RefState_Active...';


GO
ALTER TABLE [workflow].[RefState]
    ADD CONSTRAINT [DF_RefState_Active] DEFAULT ((1)) FOR [Active];


GO
PRINT N'Creating DF__RefState__Insert__03317E3D...';


GO
ALTER TABLE [workflow].[RefState]
    ADD DEFAULT (getutcdate()) FOR [InsertDate];


GO
PRINT N'Creating DF__RefState__Update__0425A276...';


GO
ALTER TABLE [workflow].[RefState]
    ADD DEFAULT (getutcdate()) FOR [UpdateDate];


GO
PRINT N'Creating DF_RefTaskStatus_Active...';


GO
ALTER TABLE [workflow].[RefTaskStatus]
    ADD CONSTRAINT [DF_RefTaskStatus_Active] DEFAULT ((1)) FOR [Active];


GO
PRINT N'Creating DF__RefTaskSt__Inser__08EA5793...';


GO
ALTER TABLE [workflow].[RefTaskStatus]
    ADD DEFAULT (getutcdate()) FOR [InsertDate];


GO
PRINT N'Creating DF__RefTaskSt__Updat__09DE7BCC...';


GO
ALTER TABLE [workflow].[RefTaskStatus]
    ADD DEFAULT (getutcdate()) FOR [UpdateDate];


GO
PRINT N'Creating FK_RefTask_RefWorkflow...';


GO
ALTER TABLE [workflow].[RefTask] WITH NOCHECK
    ADD CONSTRAINT [FK_RefTask_RefWorkflow] FOREIGN KEY ([RefWorkflowID]) REFERENCES [workflow].[RefWorkflow] ([RefWorkflowID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_StateTask_StartRefState...';


GO
ALTER TABLE [workflow].[StateTask] WITH NOCHECK
    ADD CONSTRAINT [FK_StateTask_StartRefState] FOREIGN KEY ([StartRefStateID]) REFERENCES [workflow].[RefState] ([RefStateID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_StateTask_EndRefState...';


GO
ALTER TABLE [workflow].[StateTask] WITH NOCHECK
    ADD CONSTRAINT [FK_StateTask_EndRefState] FOREIGN KEY ([EndRefStateID]) REFERENCES [workflow].[RefState] ([RefStateID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_StateTask_RefTask...';


GO
ALTER TABLE [workflow].[StateTask] WITH NOCHECK
    ADD CONSTRAINT [FK_StateTask_RefTask] FOREIGN KEY ([RefTaskID]) REFERENCES [workflow].[RefTask] ([RefTaskID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_StateTask_RefTaskStatus...';


GO
ALTER TABLE [workflow].[StateTask] WITH NOCHECK
    ADD CONSTRAINT [FK_StateTask_RefTaskStatus] FOREIGN KEY ([RefTaskStatusID]) REFERENCES [workflow].[RefTaskStatus] ([RefTaskStatusID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_RefState_RefWorkflow...';


GO
ALTER TABLE [workflow].[RefState] WITH NOCHECK
    ADD CONSTRAINT [FK_RefState_RefWorkflow] FOREIGN KEY ([RefWorkflowID]) REFERENCES [workflow].[RefWorkflow] ([RefWorkflowID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating [workflow].[RefStateRetrieveAll]...';


GO


CREATE PROCEDURE [workflow].[RefStateRetrieveAll]
(
	@RefWorkflowName		VARCHAR(100),
	@Debug		BIT = 0
)
AS
/************************************************
* CareWebQI
* NAME		: RefStateRetrieveAll
* AUTHOR  	: (generated)
* DATE		: 2/16/2011
* LAST REV	: 2/16/2011
*
* PURPOSE:	Selects all RefState records.
*
* TABLES USED:  RefState
*
* PARAMETERS IN:
* 		Debug				- Flag for debug printing
*
* RETURNS:
* 		 0	- Successful
* 		-1	- Generic failure
*
*****************************************************
* REVISION HISTORY:
*
*****************************************************
*/
BEGIN

	DECLARE @errCode  INT;
	DECLARE @procName VARCHAR(50);

	SET @errCode  = 0;
	SET @procName = 'RefStateRetrieveAll';

	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Selecting all [RefState] records...';
	 END

	SELECT rf.RefStateID, rf.RefStateName, rf.Description
	FROM Workflow.RefState rf
	INNER JOIN Workflow.RefWorkflow rw ON rw.RefWorkflowID = rf.RefWorkflowID
	WHERE rw.RefWorkflowName = @RefWorkflowName
	AND rw.Active = 1
	AND rf.Active = 1;

	SELECT @errCode = @errCode + @@ERROR;

	IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
PRINT N'Creating [workflow].[RefStateRetrieveByName]...';


GO


CREATE PROCEDURE [workflow].[RefStateRetrieveByName]
(
	@RefWorkflowName		VARCHAR(100),
	@RefStateName			VARCHAR(100),
	@Debug					BIT = 0
)
AS
/************************************************
* CareWebQI
* NAME		: RefStateRetrieveByName
* AUTHOR  	: (generated)
* DATE		: 2/16/2011
* LAST REV	: 2/16/2011
*
* PURPOSE:	Selects a RefState record based on the primary key.
*
* TABLES USED:  RefState
*
* PARAMETERS IN:
* 		refStateID			- Primary Key
* 		Debug				- Flag for debug printing
*
* RETURNS:
* 		 0	- Successful
* 		-1	- Generic failure
*
*****************************************************
* REVISION HISTORY:
*
*****************************************************
*/
BEGIN

	DECLARE @errCode  INT;
	DECLARE @procName VARCHAR(50);

	SET @errCode  = 0;
	SET @procName = 'RefStateRetrieveByName';

	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Selecting specified [RefState] record...';
	 END

	SELECT rf.RefStateID, rf.RefStateName, rf.Description
	FROM Workflow.RefState rf
	INNER JOIN Workflow.RefWorkflow rw ON rw.RefWorkflowID = rf.RefWorkflowID
	WHERE rw.RefWorkflowName = @RefWorkflowName
	AND rf.RefStateName = @RefStateName
	AND rw.Active = 1
	AND rf.Active = 1;

	SELECT @errCode = @errCode + @@ERROR;

IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
PRINT N'Creating [workflow].[StateTaskRetrieveEndRefState]...';


GO


CREATE PROCEDURE [workflow].[StateTaskRetrieveEndRefState]
(
	@RefWorkflowName		VARCHAR(100),
	@StartRefStateName			VARCHAR(100),
	@RefTaskName			VARCHAR(100),
	@RefTaskStatusName			VARCHAR(100),
	@Debug					BIT = 0
)
AS
/************************************************
* Workflow
* NAME		: StateTaskRetrieveEndRefState
* AUTHOR  	: (generated)
* DATE		: 2/11/2011
* LAST REV	: 2/11/2011
*
* PURPOSE:	Selecting RefTask record by StartRefStateName and RefTaskName.
*
* TABLES USED:  StateTask
*
* PARAMETERS IN:
* 		barrierID			- Primary Key
* 		Debug				- Flag for debug printing
*
* RETURNS:
* 		 0	- Successful
* 		-1	- Generic failure
*
*****************************************************
* REVISION HISTORY:
*
*****************************************************
*/
BEGIN

	DECLARE @errCode  INT;
	DECLARE @procName VARCHAR(50);

	SET @errCode  = 0;
	SET @procName = 'StateTaskRetrieveEndRefState';

	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Selecting RefTask record by StartState...';
	 END

SELECT rs2.RefStateID, rs2.RefStateName, rs2.Description
	FROM Workflow.StateTask st
	INNER JOIN Workflow.RefState rs ON rs.RefStateID = st.StartRefStateID
	INNER JOIN Workflow.RefState rs2 ON rs2.RefStateID = st.EndRefStateID
	INNER JOIN Workflow.RefTask rt ON rt.RefTaskID = st.RefTaskID
	INNER JOIN Workflow.RefTaskStatus rts ON rts.RefTaskStatusID = st.RefTaskStatusID
	INNER JOIN Workflow.RefWorkflow rw ON rw.RefWorkflowID = rs.RefWorkflowID
	WHERE rw.RefWorkflowName = @RefWorkflowName
	AND rs.RefStateName = @StartRefStateName
	AND rt.RefTaskName = @RefTaskName
	AND rts.RefTaskStatusName = @RefTaskStatusName
	AND st.Active = 1
	AND rw.Active = 1
	AND rs.Active = 1
	AND rt.Active = 1
	AND rts.Active = 1;

	SELECT @errCode = @errCode + @@ERROR;

IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
PRINT N'Creating [workflow].[StateTaskRetrieveRefTasks]...';


GO


CREATE PROCEDURE [workflow].[StateTaskRetrieveRefTasks]
(
	@RefWorkflowName		VARCHAR(100),
	@StartRefStateName			VARCHAR(100),
	@Debug					BIT = 0
)
AS
/************************************************
* Workflow
* NAME		: StateTaskRetrieveRefTasks
* AUTHOR  	: (generated)
* DATE		: 2/11/2011
* LAST REV	: 2/11/2011
*
* PURPOSE:	Selecting RefTask record by StartRefStateName.
*
* TABLES USED:  StateTask
*
* PARAMETERS IN:
* 		barrierID			- Primary Key
* 		Debug				- Flag for debug printing
*
* RETURNS:
* 		 0	- Successful
* 		-1	- Generic failure
*
*****************************************************
* REVISION HISTORY:
*
*****************************************************
*/
BEGIN

	DECLARE @errCode  INT;
	DECLARE @procName VARCHAR(50);

	SET @errCode  = 0;
	SET @procName = 'StateTaskRetrieveRefTasks';

	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Selecting RefTask record by StartState...';
	 END

	SELECT rt.RefTaskID, rt.RefTaskName, rt.Description
	FROM Workflow.StateTask st
	INNER JOIN Workflow.RefState rs ON rs.RefStateID = st.StartRefStateID
	INNER JOIN Workflow.RefTask rt ON rt.RefTaskID = st.RefTaskID
	INNER JOIN Workflow.RefWorkflow rw ON rw.RefWorkflowID = rs.RefWorkflowID
	WHERE rw.RefWorkflowName = @RefWorkflowName
	AND rs.RefStateName = @StartRefStateName
	AND rw.Active = 1
	AND rs.Active = 1
	AND rt.Active = 1;

	SELECT @errCode = @errCode + @@ERROR;

IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
PRINT N'Checking existing data against newly created constraints';


GO
ALTER TABLE [workflow].[RefTask] WITH CHECK CHECK CONSTRAINT [FK_RefTask_RefWorkflow];

ALTER TABLE [workflow].[StateTask] WITH CHECK CHECK CONSTRAINT [FK_StateTask_StartRefState];

ALTER TABLE [workflow].[StateTask] WITH CHECK CHECK CONSTRAINT [FK_StateTask_EndRefState];

ALTER TABLE [workflow].[StateTask] WITH CHECK CHECK CONSTRAINT [FK_StateTask_RefTask];

ALTER TABLE [workflow].[StateTask] WITH CHECK CHECK CONSTRAINT [FK_StateTask_RefTaskStatus];

ALTER TABLE [workflow].[RefState] WITH CHECK CHECK CONSTRAINT [FK_RefState_RefWorkflow];


GO
