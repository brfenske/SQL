DROP TABLE [dbo].Task
GO
DROP TABLE [dbo].TaskLog
GO
DROP TABLE [dbo].[RefTaskParentType]
GO
DROP TABLE [dbo].[RefTaskOutcome]
GO
DROP TABLE [dbo].[RefTaskReason]
GO
DROP TABLE [dbo].[RefTaskStatus]
GO

/****** Object:  Table [dbo].[Task]    Script Date: 04/11/2011 10:44:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Task](
	[TaskID] [int] IDENTITY(1,1) NOT NULL,
	[TypeID] [int] NULL,
	[Subject] [varchar](max) NULL,
	[IsSystemTask] [bit] NULL,
	[PriorityID] [int] NULL,
	[StatusID] [int] NULL,
	[PatientID] [int] NULL,
	[ParentTypeID] [int] NULL,
	[ParentID] [int] NULL,
	[ReasonID] [int] NULL,
	[OwnerUserID] [int] NULL,
	[OutcomeID] [int] NULL,
	[CurrentUserID] [int] NULL,
	[PreviousUserID] [int] NULL,
	[ContactName] [varchar](255) NULL,
	[ContactDetails] [varchar](512) NULL,
	[NoteID] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CloseDate] [datetime] NULL,
	[InsertDate] [datetime] NULL,
	[InsertBy] [int] NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateBy] [int] NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[TaskLog]    Script Date: 04/11/2011 10:45:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TaskLog](
	[TaskLogID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NULL,
	[TypeID] [int] NULL,
	[PriorityID] [int] NULL,
	[StatusID] [int] NULL,
	[PatientID] [int] NULL,
	[ParentTypeID] [int] NULL,
	[ParentID] [int] NULL,
	[ReasonID] [int] NULL,
	[OwnerUserID] [int] NULL,
	[OutcomeID] [int] NULL,
	[CurrentUserID] [int] NULL,
	[PersonContacted] [varchar](255) NULL,
	[NoteID] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CloseDate] [datetime] NULL,
	[InsertDate] [datetime] NULL,
	[InsertBy] [int] NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_TaskLog] PRIMARY KEY CLUSTERED 
(
	[TaskLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[RefTaskOutcome]    Script Date: 04/11/2011 10:45:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RefTaskParentType](
	[TaskParentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TaskParentTypeName] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[InsertDate] [datetime] NOT NULL CONSTRAINT [DF_RefTaskParentType_InsertDate]  DEFAULT (GETDATE()),
	[InsertUserID] [int] NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUserID] [int] NULL,
 CONSTRAINT [PK_RefTaskParentType] PRIMARY KEY CLUSTERED 
(
	[TaskParentTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF


/****** Object:  Table [dbo].[RefTaskOutcome]    Script Date: 04/11/2011 10:45:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RefTaskOutcome](
	[TaskOutcomeID] [int] IDENTITY(1,1) NOT NULL,
	[TaskOutcomeName] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[InsertDate] [datetime] NOT NULL CONSTRAINT [DF_RefTaskOutcome_InsertDate]  DEFAULT (GETDATE()),
	[InsertUserID] [int] NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUserID] [int] NULL,
 CONSTRAINT [PK_RefTaskOutcome] PRIMARY KEY CLUSTERED 
(
	[TaskOutcomeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF


/****** Object:  Table [dbo].[RefTaskReason]    Script Date: 04/11/2011 10:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RefTaskReason](
	[TaskReasonID] [int] IDENTITY(1,1) NOT NULL,
	[TaskReasonName] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[InsertDate] [datetime] NOT NULL CONSTRAINT [DF_RefTaskReason_InsertDate]  DEFAULT (GETDATE()),
	[InsertUserID] [int] NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUserID] [int] NULL,
 CONSTRAINT [PK_RefTaskReason] PRIMARY KEY CLUSTERED 
(
	[TaskReasonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF



GO
/****** Object:  Table [dbo].[RefTaskStatus]    Script Date: 04/11/2011 10:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RefTaskStatus](
	[TaskStatusID] [int] IDENTITY(1,1) NOT NULL,
	[TaskStatusName] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[InsertDate] [datetime] NOT NULL CONSTRAINT [DF_RefTaskStatus_InsertDate]  DEFAULT (GETDATE()),
	[InsertUserID] [int] NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUserID] [int] NULL,
 CONSTRAINT [PK_RefTaskStatus] PRIMARY KEY CLUSTERED 
(
	[TaskStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_AppUser_Current] FOREIGN KEY([CurrentUserID])
REFERENCES [dbo].[AppUser] ([UserID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_AppUser_Current]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_AppUser_Owner] FOREIGN KEY([OwnerUserID])
REFERENCES [dbo].[AppUser] ([UserID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_AppUser_Owner]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_AppUser_Previous] FOREIGN KEY([PreviousUserID])
REFERENCES [dbo].[AppUser] ([UserID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_AppUser_Previous]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_Patient] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_Patient]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_RefTaskOutcome] FOREIGN KEY([OutcomeID])
REFERENCES [dbo].[RefTaskOutcome] ([TaskOutcomeID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_RefTaskOutcome]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_RefTaskPriority] FOREIGN KEY([PriorityID])
REFERENCES [dbo].[RefTaskPriority] ([ID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_RefTaskPriority]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_RefTaskPriority1] FOREIGN KEY([PriorityID])
REFERENCES [dbo].[RefTaskPriority] ([ID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_RefTaskPriority1]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_RefTaskReason] FOREIGN KEY([ReasonID])
REFERENCES [dbo].[RefTaskReason] ([TaskReasonID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_RefTaskReason]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_RefTaskStatus] FOREIGN KEY([StatusID])
REFERENCES [dbo].[RefTaskStatus] ([TaskStatusID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_RefTaskStatus]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_RefTaskType] FOREIGN KEY([TypeID])
REFERENCES [dbo].[RefTaskType] ([ID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_RefTaskType]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_RefTaskType1] FOREIGN KEY([TypeID])
REFERENCES [dbo].[RefTaskType] ([ID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_RefTaskType1]



GO

SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TaskLog]  WITH CHECK ADD  CONSTRAINT [FK_TaskLog_AppUser_Current] FOREIGN KEY([CurrentUserID])
REFERENCES [dbo].[AppUser] ([UserID])
GO
ALTER TABLE [dbo].[TaskLog] CHECK CONSTRAINT [FK_TaskLog_AppUser_Current]
GO
ALTER TABLE [dbo].[TaskLog]  WITH CHECK ADD  CONSTRAINT [FK_TaskLog_AppUser_Owner] FOREIGN KEY([OwnerUserID])
REFERENCES [dbo].[AppUser] ([UserID])
GO
ALTER TABLE [dbo].[TaskLog] CHECK CONSTRAINT [FK_TaskLog_AppUser_Owner]
GO
ALTER TABLE [dbo].[TaskLog]  WITH CHECK ADD  CONSTRAINT [FK_TaskLog_Patient] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
GO
ALTER TABLE [dbo].[TaskLog] CHECK CONSTRAINT [FK_TaskLog_Patient]
GO
ALTER TABLE [dbo].[TaskLog]  WITH CHECK ADD  CONSTRAINT [FK_TaskLog_RefTaskLogPriority] FOREIGN KEY([PriorityID])
REFERENCES [dbo].[RefTaskPriority] ([ID])
GO
ALTER TABLE [dbo].[TaskLog] CHECK CONSTRAINT [FK_TaskLog_RefTaskLogPriority]
GO
ALTER TABLE [dbo].[TaskLog]  WITH CHECK ADD  CONSTRAINT [FK_TaskLog_RefTaskLogType] FOREIGN KEY([TypeID])
REFERENCES [dbo].[RefTaskType] ([ID])
GO
ALTER TABLE [dbo].[TaskLog] CHECK CONSTRAINT [FK_TaskLog_RefTaskLogType]
GO
ALTER TABLE [dbo].[TaskLog]  WITH CHECK ADD  CONSTRAINT [FK_TaskLog_RefTaskOutcome] FOREIGN KEY([OutcomeID])
REFERENCES [dbo].[RefTaskOutcome] ([TaskOutcomeID])
GO
ALTER TABLE [dbo].[TaskLog] CHECK CONSTRAINT [FK_TaskLog_RefTaskOutcome]
GO
ALTER TABLE [dbo].[TaskLog]  WITH CHECK ADD  CONSTRAINT [FK_TaskLog_RefTaskPriority] FOREIGN KEY([PriorityID])
REFERENCES [dbo].[RefTaskPriority] ([ID])
GO
ALTER TABLE [dbo].[TaskLog] CHECK CONSTRAINT [FK_TaskLog_RefTaskPriority]
GO
ALTER TABLE [dbo].[TaskLog]  WITH CHECK ADD  CONSTRAINT [FK_TaskLog_RefTaskReason] FOREIGN KEY([ReasonID])
REFERENCES [dbo].[RefTaskReason] ([TaskReasonID])
GO
ALTER TABLE [dbo].[TaskLog] CHECK CONSTRAINT [FK_TaskLog_RefTaskReason]
GO
ALTER TABLE [dbo].[TaskLog]  WITH CHECK ADD  CONSTRAINT [FK_TaskLog_RefTaskStatus] FOREIGN KEY([StatusID])
REFERENCES [dbo].[RefTaskStatus] ([TaskStatusID])
GO
ALTER TABLE [dbo].[TaskLog] CHECK CONSTRAINT [FK_TaskLog_RefTaskStatus]
GO
ALTER TABLE [dbo].[TaskLog]  WITH CHECK ADD  CONSTRAINT [FK_TaskLog_RefTaskType] FOREIGN KEY([TypeID])
REFERENCES [dbo].[RefTaskType] ([ID])
GO
ALTER TABLE [dbo].[TaskLog] CHECK CONSTRAINT [FK_TaskLog_RefTaskType]

