/****** Object:  Table [dbo].[RefPublication]    Script Date: 03/15/2011 15:13:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RefPublication](
	[RefPublicationID] [smallint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PubTypeCode] [varchar](10) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[PubNum] [int] NOT NULL,
	[CodeSearchSortOrder] [int] NOT NULL,
	[Active] [bit] NOT NULL CONSTRAINT [DF_RefPublication_Active]  DEFAULT ((1)),
	[UpdateDate] [datetime] NULL,
	[InsertDate] [datetime] NOT NULL CONSTRAINT [DF_RefPublication_InsertDate]  DEFAULT (getutcdate()),
	[ParentID] [smallint] NULL,
	[IsSearchable] [bit] NOT NULL CONSTRAINT [DF_RefPublication_IsSearchable]  DEFAULT ((1)),
 CONSTRAINT [PK_Publication] PRIMARY KEY CLUSTERED 
(
	[RefPublicationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  ForeignKey [FK_RefPublication_RefPublicationID]    Script Date: 03/15/2011 15:13:10 ******/
ALTER TABLE [dbo].[RefPublication]  WITH NOCHECK ADD  CONSTRAINT [FK_RefPublication_RefPublicationID] FOREIGN KEY([ParentID])
REFERENCES [dbo].[RefPublication] ([RefPublicationID])
GO
ALTER TABLE [dbo].[RefPublication] CHECK CONSTRAINT [FK_RefPublication_RefPublicationID]
GO
/****** Object:  Table [dbo].[GuidelineCache]    Script Date: 03/15/2011 15:12:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GuidelineCache](
	[GuidelineCacheID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ContentVersion] [varchar](25) NOT NULL,
	[PubTypeID] [smallint] NOT NULL,
	[GuidelineTypeCode] [varchar](50) NOT NULL,
	[HSIMCode] [varchar](25) NOT NULL,
	[GLOSMin] [int] NULL,
	[GLOSMax] [int] NULL,
	[GLOSType] [varchar](50) NULL,
	[ChronicCondition] [bit] NOT NULL,
	[Sections] [xml] NOT NULL,
	[Active] [bit] NOT NULL CONSTRAINT [DF_GuidelineCache_Active]  DEFAULT ((1)),
	[InsertDate] [datetime] NOT NULL,
 CONSTRAINT [PK_GuidelineCache] PRIMARY KEY NONCLUSTERED 
(
	[GuidelineCacheID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GuidelineSection]    Script Date: 03/15/2011 15:12:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GuidelineSection](
	[GuidelineSectionID] [int] IDENTITY(1,1) NOT NULL,
	[HSIMCode] [varchar](25) NOT NULL,
	[PubTypeID] [smallint] NOT NULL,
	[ContentVersion] [varchar](25) NULL,
	[ContentVersionID] [int] NULL,
	[SectionPath] [varchar](8000) NULL,
	[SectionID] [int] NULL,
	[SectionXML] [xml] NOT NULL,
	[UpdateDate] [datetime] NULL,
	[InsertDate] [datetime] NOT NULL,
	[CreatorID] [int] NULL,
	[CreatorName] [varchar](255) NULL,
 CONSTRAINT [pk_GuidelineSection_GuidelineSectionID] PRIMARY KEY CLUSTERED 
(
	[GuidelineSectionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  ForeignKey [FK_GuidelineSection_RefPublication]    Script Date: 03/15/2011 15:12:05 ******/
ALTER TABLE [dbo].[GuidelineSection]  WITH CHECK ADD  CONSTRAINT [FK_GuidelineSection_RefPublication] FOREIGN KEY([PubTypeID])
REFERENCES [dbo].[RefPublication] ([RefPublicationID])
GO
ALTER TABLE [dbo].[GuidelineSection] CHECK CONSTRAINT [FK_GuidelineSection_RefPublication]
GO
/****** Object:  Table [iCCG].[Note]    Script Date: 03/15/2011 15:09:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Note](
	[NoteID] [int] IDENTITY(1,1) NOT NULL,
	[NoteType] [nchar](10) NOT NULL,
	[ParentID] [int] NULL,
	[NoteText] [varchar](max) NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Note_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [varchar](50) NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Note] PRIMARY KEY CLUSTERED 
(
	[NoteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[Outcome]    Script Date: 03/15/2011 15:09:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Outcome](
	[OutcomeID] [int] IDENTITY(1,1) NOT NULL,
	[OutcomeUniqueID] [int] NULL,
	[OutcomeText] [varchar](1000) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Outcome_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [Outcome_PK] PRIMARY KEY CLUSTERED 
(
	[OutcomeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[Problem]    Script Date: 03/15/2011 15:09:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Problem](
	[ProblemID] [int] IDENTITY(1,1) NOT NULL,
	[ProblemUniqueID] [int] NOT NULL,
	[ProblemText] [varchar](1000) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Problem_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [Problem_PK] PRIMARY KEY CLUSTERED 
(
	[ProblemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[Program]    Script Date: 03/15/2011 15:09:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Program](
	[ProgramID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Program_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Program] PRIMARY KEY CLUSTERED 
(
	[ProgramID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[AnswerProblemRef]    Script Date: 03/15/2011 15:08:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[AnswerProblemRef](
	[AnswerProblemRefID] [int] IDENTITY(1,1) NOT NULL,
	[AnswerUniqueID] [int] NOT NULL,
	[ProblemUniqueID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_AnswerProblemRef_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_AnswerProblemRef] PRIMARY KEY CLUSTERED 
(
	[AnswerProblemRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[AnswerQuestionRef]    Script Date: 03/15/2011 15:08:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[AnswerQuestionRef](
	[AnswerQuestionRefID] [int] IDENTITY(1,1) NOT NULL,
	[AnswerUniqueID] [int] NOT NULL,
	[QuestionUniqueID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_AnswerQuestionRef_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_AnswerQuestionRef] PRIMARY KEY CLUSTERED 
(
	[AnswerQuestionRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[RefAnswerType]    Script Date: 03/15/2011 15:09:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[RefAnswerType](
	[AnswerTypeID] [int] IDENTITY(1,1) NOT NULL,
	[AnswerTypeName] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RefAnswerType_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_RefAnswerType] PRIMARY KEY CLUSTERED 
(
	[AnswerTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[Barrier]    Script Date: 03/15/2011 15:08:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Barrier](
	[BarrierID] [int] IDENTITY(1,1) NOT NULL,
	[BarrierUniqueID] [int] NOT NULL,
	[BarrierText] [varchar](1000) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Barrier_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [Barrier_PK] PRIMARY KEY CLUSTERED 
(
	[BarrierID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[RefCaseStatusType]    Script Date: 03/15/2011 15:09:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[RefCaseStatusType](
	[CaseStatusTypeID] [int] IDENTITY(1,1) NOT NULL,
	[CaseStatusTypeName] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RefCaseStatusType_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_RefCaseStatusType] PRIMARY KEY CLUSTERED 
(
	[CaseStatusTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[RefClosureReason]    Script Date: 03/15/2011 15:09:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[RefClosureReason](
	[ClosureReasonID] [int] IDENTITY(1,1) NOT NULL,
	[ClosureReasonName] [varchar](255) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RefClosureReason_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_RefClosureReason] PRIMARY KEY CLUSTERED 
(
	[ClosureReasonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[CaseIDSourceGenerator]    Script Date: 03/15/2011 15:08:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[CaseIDSourceGenerator](
	[CaseIDSourceID] [int] IDENTITY(1,1) NOT NULL,
	[Filler] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[RefDuration]    Script Date: 03/15/2011 15:09:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[RefDuration](
	[DurationID] [int] IDENTITY(1,1) NOT NULL,
	[DurationName] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RefDuration_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_RefDuration] PRIMARY KEY CLUSTERED 
(
	[DurationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[RefFrequency]    Script Date: 03/15/2011 15:09:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[RefFrequency](
	[FrequencyID] [int] IDENTITY(1,1) NOT NULL,
	[FrequencyName] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RefFrequency_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_RefFrequency] PRIMARY KEY CLUSTERED 
(
	[FrequencyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[RefInterventionType]    Script Date: 03/15/2011 15:09:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[RefInterventionType](
	[InterventionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[InterventionTypeName] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RefInterventionType_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_RefInterventionType] PRIMARY KEY CLUSTERED 
(
	[InterventionTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[RefQuestionLogicType]    Script Date: 03/15/2011 15:09:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[RefQuestionLogicType](
	[QuestionLogicTypeID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionLogicTypeName] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RefQuestionLogicType_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_RefQuestionLogic] PRIMARY KEY CLUSTERED 
(
	[QuestionLogicTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[RefQuestionType]    Script Date: 03/15/2011 15:09:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[RefQuestionType](
	[QuestionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionTypeName] [varchar](50) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RefQuestionType_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_RefQuestionType] PRIMARY KEY CLUSTERED 
(
	[QuestionTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[RefSectionType]    Script Date: 03/15/2011 15:09:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[RefSectionType](
	[SectionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[SectionTypeName] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RefSectionType_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_RefSectionType] PRIMARY KEY CLUSTERED 
(
	[SectionTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[RefRoute]    Script Date: 03/15/2011 15:09:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[RefRoute](
	[RouteID] [int] IDENTITY(1,1) NOT NULL,
	[RouteName] [varchar](15) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RefRoute_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_RefRoute] PRIMARY KEY CLUSTERED 
(
	[RouteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[Goal]    Script Date: 03/15/2011 15:09:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Goal](
	[GoalID] [int] IDENTITY(1,1) NOT NULL,
	[GoalUniqueID] [int] NULL,
	[GoalText] [varchar](1000) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Goal_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [Goal_PK] PRIMARY KEY CLUSTERED 
(
	[GoalID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[Survey]    Script Date: 03/15/2011 15:09:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Survey](
	[SurveyID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyName] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Survey_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Survey] PRIMARY KEY CLUSTERED 
(
	[SurveyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[GoalOutcome]    Script Date: 03/15/2011 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[GoalOutcome](
	[GoalOutcomeID] [int] IDENTITY(1,1) NOT NULL,
	[GoalID] [int] NOT NULL,
	[OutcomeID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_GoalOutcome_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [GoalOutcome_PK] PRIMARY KEY CLUSTERED 
(
	[GoalOutcomeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[GoalProblem]    Script Date: 03/15/2011 15:09:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[GoalProblem](
	[GoalProblemID] [int] IDENTITY(1,1) NOT NULL,
	[GoalID] [int] NOT NULL,
	[ProblemID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_GoalProblem_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [GoalProblem_PK] PRIMARY KEY CLUSTERED 
(
	[GoalProblemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[QuestionAnswerSet]    Script Date: 03/15/2011 15:09:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[QuestionAnswerSet](
	[QuestionAnswerSetID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionLogicID] [int] NULL,
	[TargetQuestionAnswerID] [int] NULL,
	[TargetSectionID] [int] NULL,
	[TargetProblemID] [int] NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_QuestionAnswerSet_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_QuestionAnswerSet] PRIMARY KEY CLUSTERED 
(
	[QuestionAnswerSetID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[CaseGoal]    Script Date: 03/15/2011 15:08:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[CaseGoal](
	[CaseGoalID] [int] IDENTITY(1,1) NOT NULL,
	[ProblemListID] [int] NOT NULL,
	[GoalUniqueID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_CaseGoal_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_CaseGoal] PRIMARY KEY CLUSTERED 
(
	[CaseGoalID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[CaseProgram]    Script Date: 03/15/2011 15:08:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[CaseProgram](
	[CaseProgramID] [int] IDENTITY(1,1) NOT NULL,
	[CaseID] [int] NOT NULL,
	[ProgramID] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_CaseProgram_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_CaseProgram] PRIMARY KEY CLUSTERED 
(
	[CaseProgramID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[ProgramGuideline]    Script Date: 03/15/2011 15:09:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[ProgramGuideline](
	[ProgramGuidelineID] [int] IDENTITY(1,1) NOT NULL,
	[ProgramID] [int] NOT NULL,
	[GuidelineTitle] [varchar](255) NOT NULL,
	[ProductCode] [varchar](50) NOT NULL,
	[HSIM] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProgramGuideline_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_ProgramGuideline] PRIMARY KEY CLUSTERED 
(
	[ProgramGuidelineID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[QuestionAnswer]    Script Date: 03/15/2011 15:09:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[QuestionAnswer](
	[QuestionAnswerID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionID] [int] NOT NULL,
	[AnswerID] [int] NOT NULL,
	[ParentQuestionAnswerID] [int] NULL,
	[Help] [varchar](max) NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_QuestionAnswer_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_QuestionAnswer] PRIMARY KEY CLUSTERED 
(
	[QuestionAnswerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[QuestionAnswerSetMember]    Script Date: 03/15/2011 15:09:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[QuestionAnswerSetMember](
	[QuestionAnswerSetMemberID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionAnswerSetID] [int] NOT NULL,
	[QuestionAnswerID] [int] NOT NULL,
	[Weight] [int] NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_QuestionAnswerSetMember_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_QuestionAnswerSetMember] PRIMARY KEY CLUSTERED 
(
	[QuestionAnswerSetMemberID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[SectionQuestionAnswerGroupMember]    Script Date: 03/15/2011 15:09:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[SectionQuestionAnswerGroupMember](
	[SectionQuestionAnswerGroupMemberID] [int] IDENTITY(1,1) NOT NULL,
	[SectionQuestionAnswerGroupID] [int] NOT NULL,
	[QuestionAnswerID] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_SectionQuestionAnswerGroupMember_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_SectionQuestionAnswerGroupMember] PRIMARY KEY CLUSTERED 
(
	[SectionQuestionAnswerGroupMemberID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[AssessmentSectionQuestionAnswerGroupMember]    Script Date: 03/15/2011 15:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[AssessmentSectionQuestionAnswerGroupMember](
	[AssessmentSectionQuestionAnswerGroupMemberID] [int] IDENTITY(1,1) NOT NULL,
	[SectionQuestionAnswerGroupMemberID] [int] NOT NULL,
	[AssessmentID] [int] NOT NULL,
	[TextValue] [varchar](max) NULL,
	[DateValue] [datetime] NULL,
	[DecimalValue] [decimal](18, 0) NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_AssessmentSectionQuestionAnswerGroupMember_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_AssessmentSectionQuestionAnswerGroupMember] PRIMARY KEY CLUSTERED 
(
	[AssessmentSectionQuestionAnswerGroupMemberID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[Answer]    Script Date: 03/15/2011 15:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Answer](
	[AnswerID] [int] IDENTITY(1,1) NOT NULL,
	[AnswerUniqueID] [int] NOT NULL,
	[AnswerText] [varchar](max) NOT NULL,
	[XmlID] [varchar](50) NULL,
	[XmlContent] [xml] NULL,
	[TypeID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Answer_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Answer] PRIMARY KEY CLUSTERED 
(
	[AnswerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[GoalBarrier]    Script Date: 03/15/2011 15:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[GoalBarrier](
	[GoalBarrierID] [int] IDENTITY(1,1) NOT NULL,
	[GoalID] [int] NOT NULL,
	[BarrierID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_GoalBarrier_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [GoalBarrier_PK] PRIMARY KEY CLUSTERED 
(
	[GoalBarrierID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[Case]    Script Date: 03/15/2011 15:08:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Case](
	[CaseID] [int] IDENTITY(1,1) NOT NULL,
	[OriginalCaseNumber] [varchar](255) NULL,
	[PatientID] [int] NOT NULL,
	[CaseOwnerID] [int] NOT NULL,
	[ProviderID] [int] NULL,
	[TypeID] [int] NOT NULL,
	[IdentifiedDate] [datetime] NULL,
	[OpenDate] [datetime] NULL,
	[CloseDate] [datetime] NULL,
	[ClosureReasonID] [int] NULL,
	[StatusID] [int] NOT NULL,
	[Source] [varchar](255) NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Case_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Case] PRIMARY KEY CLUSTERED 
(
	[CaseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[ProblemList]    Script Date: 03/15/2011 15:09:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[ProblemList](
	[ProblemListID] [int] IDENTITY(1,1) NOT NULL,
	[ProblemUniqueID] [int] NOT NULL,
	[CaseID] [int] NOT NULL,
	[Selected] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProblemList_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [int] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_ProblemList] PRIMARY KEY CLUSTERED 
(
	[ProblemListID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[PatientMedicine]    Script Date: 03/15/2011 15:09:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[PatientMedicine](
	[PatientMedicineID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NOT NULL,
	[MedicationName] [varchar](255) NULL,
	[Dose] [varchar](15) NULL,
	[RouteID] [int] NULL,
	[FrequencyID] [int] NULL,
	[Started] [datetime] NULL,
	[Discontinued] [datetime] NULL,
	[DurationID] [int] NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_PatientMedicine_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_PatientMedicine] PRIMARY KEY CLUSTERED 
(
	[PatientMedicineID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[CaseBarrier]    Script Date: 03/15/2011 15:08:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[CaseBarrier](
	[CaseBarrierID] [int] IDENTITY(1,1) NOT NULL,
	[BarrierUniqueID] [int] NULL,
	[CaseGoalID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_CaseBarrier_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_CaseBarrier] PRIMARY KEY CLUSTERED 
(
	[CaseBarrierID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[CaseOutcome]    Script Date: 03/15/2011 15:08:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[CaseOutcome](
	[CaseOutcomeID] [int] IDENTITY(1,1) NOT NULL,
	[OutcomeUniqueID] [int] NULL,
	[CaseGoalID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_CaseOutcome_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_CaseOutcome] PRIMARY KEY CLUSTERED 
(
	[CaseOutcomeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[CaseIntervention]    Script Date: 03/15/2011 15:08:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[CaseIntervention](
	[CaseInterventionID] [int] IDENTITY(1,1) NOT NULL,
	[InterventionUniqueID] [int] NULL,
	[CaseGoalID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_CaseIntervention_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_CaseIntervention] PRIMARY KEY CLUSTERED 
(
	[CaseInterventionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[Intervention]    Script Date: 03/15/2011 15:09:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Intervention](
	[InterventionID] [int] IDENTITY(1,1) NOT NULL,
	[InterventionUniqueID] [int] NULL,
	[TypeID] [int] NOT NULL,
	[InterventionText] [varchar](1000) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Intervention_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [Intervention_PK] PRIMARY KEY CLUSTERED 
(
	[InterventionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[Question]    Script Date: 03/15/2011 15:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Question](
	[QuestionID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionUniqueID] [int] NOT NULL,
	[QuestionText] [varchar](max) NOT NULL,
	[CanPipe] [bit] NULL,
	[CanForward] [bit] NULL,
	[IsMandatory] [bit] NULL,
	[XmlID] [varchar](50) NULL,
	[XmlContent] [xml] NULL,
	[TypeID] [int] NOT NULL,
	[Weight] [int] NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Question_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[CaseProgramGuideline]    Script Date: 03/15/2011 15:09:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[CaseProgramGuideline](
	[CaseProgramGuidelineID] [int] IDENTITY(1,1) NOT NULL,
	[CaseProgramID] [int] NOT NULL,
	[GuidelineTitle] [varchar](255) NOT NULL,
	[ProductCode] [varchar](50) NOT NULL,
	[HSIM] [varchar](50) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_CaseProgramGuideline_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_CaseProgramGuideline] PRIMARY KEY CLUSTERED 
(
	[CaseProgramGuidelineID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[Section]    Script Date: 03/15/2011 15:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Section](
	[SectionID] [int] IDENTITY(1,1) NOT NULL,
	[GuidelineSectionID] [int] NOT NULL,
	[ParentSectionID] [int] NULL,
	[Heading] [varchar](50) NOT NULL,
	[TypeID] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[SurveyID] [int] NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Section_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Section] PRIMARY KEY CLUSTERED 
(
	[SectionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[SectionQuestionAnswerGroup]    Script Date: 03/15/2011 15:09:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[SectionQuestionAnswerGroup](
	[SectionQuestionAnswerGroupID] [int] IDENTITY(1,1) NOT NULL,
	[SectionID] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[SurveyID] [int] NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_SectionQuestionAnswerGroup_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_SectionQuestionAnswerGroup] PRIMARY KEY CLUSTERED 
(
	[SectionQuestionAnswerGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [iCCG].[Assessment]    Script Date: 03/15/2011 15:08:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [iCCG].[Assessment](
	[AssessmentID] [int] IDENTITY(1,1) NOT NULL,
	[CaseProgramGuidelineID] [int] NOT NULL,
	[GuidelineTitle] [varchar](255) NOT NULL,
	[ProductCode] [varchar](50) NOT NULL,
	[HSIM] [varchar](50) NOT NULL,
	[ContentVersion] [varchar](50) NOT NULL,
	[StatusID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Assessment] PRIMARY KEY CLUSTERED 
(
	[AssessmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [iCCG].[GoalIntervention]    Script Date: 03/15/2011 15:09:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [iCCG].[GoalIntervention](
	[GoalInterventionID] [int] IDENTITY(1,1) NOT NULL,
	[GoalID] [int] NOT NULL,
	[InterventionID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_GoalIntervention_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [GoalIntervention_PK] PRIMARY KEY CLUSTERED 
(
	[GoalInterventionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  ForeignKey [FK_Assessment_CaseProgramGuideline]    Script Date: 03/15/2011 15:08:44 ******/
ALTER TABLE [iCCG].[Assessment]  WITH CHECK ADD  CONSTRAINT [FK_Assessment_CaseProgramGuideline] FOREIGN KEY([CaseProgramGuidelineID])
REFERENCES [iCCG].[CaseProgramGuideline] ([CaseProgramGuidelineID])
GO
ALTER TABLE [iCCG].[Assessment] CHECK CONSTRAINT [FK_Assessment_CaseProgramGuideline]
GO
/****** Object:  ForeignKey [FK_AssessmentSectionQuestionAnswerGroupMember_Assessment]    Script Date: 03/15/2011 15:08:46 ******/
ALTER TABLE [iCCG].[AssessmentSectionQuestionAnswerGroupMember]  WITH CHECK ADD  CONSTRAINT [FK_AssessmentSectionQuestionAnswerGroupMember_Assessment] FOREIGN KEY([AssessmentID])
REFERENCES [iCCG].[Assessment] ([AssessmentID])
GO
ALTER TABLE [iCCG].[AssessmentSectionQuestionAnswerGroupMember] CHECK CONSTRAINT [FK_AssessmentSectionQuestionAnswerGroupMember_Assessment]
GO
/****** Object:  ForeignKey [FK_AssessmentSectionQuestionAnswerGroupMember_SectionQuestionAnswerGroupMember]    Script Date: 03/15/2011 15:08:46 ******/
ALTER TABLE [iCCG].[AssessmentSectionQuestionAnswerGroupMember]  WITH CHECK ADD  CONSTRAINT [FK_AssessmentSectionQuestionAnswerGroupMember_SectionQuestionAnswerGroupMember] FOREIGN KEY([SectionQuestionAnswerGroupMemberID])
REFERENCES [iCCG].[SectionQuestionAnswerGroupMember] ([SectionQuestionAnswerGroupMemberID])
GO
ALTER TABLE [iCCG].[AssessmentSectionQuestionAnswerGroupMember] CHECK CONSTRAINT [FK_AssessmentSectionQuestionAnswerGroupMember_SectionQuestionAnswerGroupMember]
GO
/****** Object:  ForeignKey [FK_Case_RefCaseStatusType]    Script Date: 03/15/2011 15:08:51 ******/
ALTER TABLE [iCCG].[Case]  WITH CHECK ADD  CONSTRAINT [FK_Case_RefCaseStatusType] FOREIGN KEY([StatusID])
REFERENCES [iCCG].[RefCaseStatusType] ([CaseStatusTypeID])
GO
ALTER TABLE [iCCG].[Case] CHECK CONSTRAINT [FK_Case_RefCaseStatusType]
GO
/****** Object:  ForeignKey [FK_Case_RefClosureReason]    Script Date: 03/15/2011 15:08:51 ******/
ALTER TABLE [iCCG].[Case]  WITH CHECK ADD  CONSTRAINT [FK_Case_RefClosureReason] FOREIGN KEY([ClosureReasonID])
REFERENCES [iCCG].[RefClosureReason] ([ClosureReasonID])
GO
ALTER TABLE [iCCG].[Case] CHECK CONSTRAINT [FK_Case_RefClosureReason]
GO
/****** Object:  ForeignKey [FK_CaseBarrier_CaseGoal]    Script Date: 03/15/2011 15:08:52 ******/
ALTER TABLE [iCCG].[CaseBarrier]  WITH CHECK ADD  CONSTRAINT [FK_CaseBarrier_CaseGoal] FOREIGN KEY([CaseGoalID])
REFERENCES [iCCG].[CaseGoal] ([CaseGoalID])
GO
ALTER TABLE [iCCG].[CaseBarrier] CHECK CONSTRAINT [FK_CaseBarrier_CaseGoal]
GO
/****** Object:  ForeignKey [FK_CaseGoal_ProblemList]    Script Date: 03/15/2011 15:08:54 ******/
ALTER TABLE [iCCG].[CaseGoal]  WITH CHECK ADD  CONSTRAINT [FK_CaseGoal_ProblemList] FOREIGN KEY([ProblemListID])
REFERENCES [iCCG].[ProblemList] ([ProblemListID])
GO
ALTER TABLE [iCCG].[CaseGoal] CHECK CONSTRAINT [FK_CaseGoal_ProblemList]
GO
/****** Object:  ForeignKey [FK_CaseIntervention_CaseGoal]    Script Date: 03/15/2011 15:08:56 ******/
ALTER TABLE [iCCG].[CaseIntervention]  WITH CHECK ADD  CONSTRAINT [FK_CaseIntervention_CaseGoal] FOREIGN KEY([CaseGoalID])
REFERENCES [iCCG].[CaseGoal] ([CaseGoalID])
GO
ALTER TABLE [iCCG].[CaseIntervention] CHECK CONSTRAINT [FK_CaseIntervention_CaseGoal]
GO
/****** Object:  ForeignKey [FK_CaseOutcome_CaseGoal]    Script Date: 03/15/2011 15:08:57 ******/
ALTER TABLE [iCCG].[CaseOutcome]  WITH CHECK ADD  CONSTRAINT [FK_CaseOutcome_CaseGoal] FOREIGN KEY([CaseGoalID])
REFERENCES [iCCG].[CaseGoal] ([CaseGoalID])
GO
ALTER TABLE [iCCG].[CaseOutcome] CHECK CONSTRAINT [FK_CaseOutcome_CaseGoal]
GO
/****** Object:  ForeignKey [FK_CaseProgram_Case]    Script Date: 03/15/2011 15:08:59 ******/
ALTER TABLE [iCCG].[CaseProgram]  WITH CHECK ADD  CONSTRAINT [FK_CaseProgram_Case] FOREIGN KEY([CaseID])
REFERENCES [iCCG].[Case] ([CaseID])
GO
ALTER TABLE [iCCG].[CaseProgram] CHECK CONSTRAINT [FK_CaseProgram_Case]
GO
/****** Object:  ForeignKey [FK_CaseProgram_Program]    Script Date: 03/15/2011 15:08:59 ******/
ALTER TABLE [iCCG].[CaseProgram]  WITH CHECK ADD  CONSTRAINT [FK_CaseProgram_Program] FOREIGN KEY([ProgramID])
REFERENCES [iCCG].[Program] ([ProgramID])
GO
ALTER TABLE [iCCG].[CaseProgram] CHECK CONSTRAINT [FK_CaseProgram_Program]
GO
/****** Object:  ForeignKey [FK_CaseProgramGuideline_CaseProgram]    Script Date: 03/15/2011 15:09:01 ******/
ALTER TABLE [iCCG].[CaseProgramGuideline]  WITH CHECK ADD  CONSTRAINT [FK_CaseProgramGuideline_CaseProgram] FOREIGN KEY([CaseProgramID])
REFERENCES [iCCG].[CaseProgram] ([CaseProgramID])
GO
ALTER TABLE [iCCG].[CaseProgramGuideline] CHECK CONSTRAINT [FK_CaseProgramGuideline_CaseProgram]
GO
/****** Object:  ForeignKey [GoalBarrier_BarrierID_FK]    Script Date: 03/15/2011 15:09:04 ******/
ALTER TABLE [iCCG].[GoalBarrier]  WITH CHECK ADD  CONSTRAINT [GoalBarrier_BarrierID_FK] FOREIGN KEY([BarrierID])
REFERENCES [iCCG].[Barrier] ([BarrierID])
GO
ALTER TABLE [iCCG].[GoalBarrier] CHECK CONSTRAINT [GoalBarrier_BarrierID_FK]
GO
/****** Object:  ForeignKey [GoalBarrier_GoalID_FK]    Script Date: 03/15/2011 15:09:04 ******/
ALTER TABLE [iCCG].[GoalBarrier]  WITH CHECK ADD  CONSTRAINT [GoalBarrier_GoalID_FK] FOREIGN KEY([GoalID])
REFERENCES [iCCG].[Goal] ([GoalID])
GO
ALTER TABLE [iCCG].[GoalBarrier] CHECK CONSTRAINT [GoalBarrier_GoalID_FK]
GO
/****** Object:  ForeignKey [FK_GoalIntervention_Intervention]    Script Date: 03/15/2011 15:09:06 ******/
ALTER TABLE [iCCG].[GoalIntervention]  WITH CHECK ADD  CONSTRAINT [FK_GoalIntervention_Intervention] FOREIGN KEY([InterventionID])
REFERENCES [iCCG].[Intervention] ([InterventionID])
GO
ALTER TABLE [iCCG].[GoalIntervention] CHECK CONSTRAINT [FK_GoalIntervention_Intervention]
GO
/****** Object:  ForeignKey [GoalIntervention_GoalID_FK]    Script Date: 03/15/2011 15:09:06 ******/
ALTER TABLE [iCCG].[GoalIntervention]  WITH CHECK ADD  CONSTRAINT [GoalIntervention_GoalID_FK] FOREIGN KEY([GoalID])
REFERENCES [iCCG].[Goal] ([GoalID])
GO
ALTER TABLE [iCCG].[GoalIntervention] CHECK CONSTRAINT [GoalIntervention_GoalID_FK]
GO
/****** Object:  ForeignKey [GoalOutcome_GoalID_FK]    Script Date: 03/15/2011 15:09:08 ******/
ALTER TABLE [iCCG].[GoalOutcome]  WITH CHECK ADD  CONSTRAINT [GoalOutcome_GoalID_FK] FOREIGN KEY([GoalID])
REFERENCES [iCCG].[Goal] ([GoalID])
GO
ALTER TABLE [iCCG].[GoalOutcome] CHECK CONSTRAINT [GoalOutcome_GoalID_FK]
GO
/****** Object:  ForeignKey [GoalOutcome_OutcomeID_FK]    Script Date: 03/15/2011 15:09:08 ******/
ALTER TABLE [iCCG].[GoalOutcome]  WITH CHECK ADD  CONSTRAINT [GoalOutcome_OutcomeID_FK] FOREIGN KEY([OutcomeID])
REFERENCES [iCCG].[Outcome] ([OutcomeID])
GO
ALTER TABLE [iCCG].[GoalOutcome] CHECK CONSTRAINT [GoalOutcome_OutcomeID_FK]
GO
/****** Object:  ForeignKey [GoalProblem_GoalID_FK]    Script Date: 03/15/2011 15:09:09 ******/
ALTER TABLE [iCCG].[GoalProblem]  WITH CHECK ADD  CONSTRAINT [GoalProblem_GoalID_FK] FOREIGN KEY([GoalID])
REFERENCES [iCCG].[Goal] ([GoalID])
GO
ALTER TABLE [iCCG].[GoalProblem] CHECK CONSTRAINT [GoalProblem_GoalID_FK]
GO
/****** Object:  ForeignKey [GoalProblem_ProblemID_FK]    Script Date: 03/15/2011 15:09:09 ******/
ALTER TABLE [iCCG].[GoalProblem]  WITH CHECK ADD  CONSTRAINT [GoalProblem_ProblemID_FK] FOREIGN KEY([ProblemID])
REFERENCES [iCCG].[Problem] ([ProblemID])
GO
ALTER TABLE [iCCG].[GoalProblem] CHECK CONSTRAINT [GoalProblem_ProblemID_FK]
GO
/****** Object:  ForeignKey [FK_Intervention_RefInterventionType1]    Script Date: 03/15/2011 15:09:11 ******/
ALTER TABLE [iCCG].[Intervention]  WITH CHECK ADD  CONSTRAINT [FK_Intervention_RefInterventionType1] FOREIGN KEY([TypeID])
REFERENCES [iCCG].[RefInterventionType] ([InterventionTypeID])
GO
ALTER TABLE [iCCG].[Intervention] CHECK CONSTRAINT [FK_Intervention_RefInterventionType1]
GO
/****** Object:  ForeignKey [FK_PatientMedicine_RefDuration]    Script Date: 03/15/2011 15:09:17 ******/
ALTER TABLE [iCCG].[PatientMedicine]  WITH CHECK ADD  CONSTRAINT [FK_PatientMedicine_RefDuration] FOREIGN KEY([DurationID])
REFERENCES [iCCG].[RefDuration] ([DurationID])
GO
ALTER TABLE [iCCG].[PatientMedicine] CHECK CONSTRAINT [FK_PatientMedicine_RefDuration]
GO
/****** Object:  ForeignKey [FK_PatientMedicine_RefFrequency]    Script Date: 03/15/2011 15:09:17 ******/
ALTER TABLE [iCCG].[PatientMedicine]  WITH CHECK ADD  CONSTRAINT [FK_PatientMedicine_RefFrequency] FOREIGN KEY([FrequencyID])
REFERENCES [iCCG].[RefFrequency] ([FrequencyID])
GO
ALTER TABLE [iCCG].[PatientMedicine] CHECK CONSTRAINT [FK_PatientMedicine_RefFrequency]
GO
/****** Object:  ForeignKey [FK_PatientMedicine_RefRoute]    Script Date: 03/15/2011 15:09:17 ******/
ALTER TABLE [iCCG].[PatientMedicine]  WITH CHECK ADD  CONSTRAINT [FK_PatientMedicine_RefRoute] FOREIGN KEY([RouteID])
REFERENCES [iCCG].[RefRoute] ([RouteID])
GO
ALTER TABLE [iCCG].[PatientMedicine] CHECK CONSTRAINT [FK_PatientMedicine_RefRoute]
GO
/****** Object:  ForeignKey [FK_ProblemList_Case]    Script Date: 03/15/2011 15:09:20 ******/
ALTER TABLE [iCCG].[ProblemList]  WITH CHECK ADD  CONSTRAINT [FK_ProblemList_Case] FOREIGN KEY([CaseID])
REFERENCES [iCCG].[Case] ([CaseID])
GO
ALTER TABLE [iCCG].[ProblemList] CHECK CONSTRAINT [FK_ProblemList_Case]
GO
/****** Object:  ForeignKey [FK_ProgramGuideline_Program]    Script Date: 03/15/2011 15:09:24 ******/
ALTER TABLE [iCCG].[ProgramGuideline]  WITH CHECK ADD  CONSTRAINT [FK_ProgramGuideline_Program] FOREIGN KEY([ProgramID])
REFERENCES [iCCG].[Program] ([ProgramID])
GO
ALTER TABLE [iCCG].[ProgramGuideline] CHECK CONSTRAINT [FK_ProgramGuideline_Program]
GO
/****** Object:  ForeignKey [FK_Question_RefQuestionType]    Script Date: 03/15/2011 15:09:26 ******/
ALTER TABLE [iCCG].[Question]  WITH CHECK ADD  CONSTRAINT [FK_Question_RefQuestionType] FOREIGN KEY([TypeID])
REFERENCES [iCCG].[RefQuestionType] ([QuestionTypeID])
GO
ALTER TABLE [iCCG].[Question] CHECK CONSTRAINT [FK_Question_RefQuestionType]
GO
/****** Object:  ForeignKey [FK_QuestionAnswer_Answer]    Script Date: 03/15/2011 15:09:28 ******/
ALTER TABLE [iCCG].[QuestionAnswer]  WITH CHECK ADD  CONSTRAINT [FK_QuestionAnswer_Answer] FOREIGN KEY([AnswerID])
REFERENCES [iCCG].[Answer] ([AnswerID])
GO
ALTER TABLE [iCCG].[QuestionAnswer] CHECK CONSTRAINT [FK_QuestionAnswer_Answer]
GO
/****** Object:  ForeignKey [FK_QuestionAnswer_Question]    Script Date: 03/15/2011 15:09:29 ******/
ALTER TABLE [iCCG].[QuestionAnswer]  WITH CHECK ADD  CONSTRAINT [FK_QuestionAnswer_Question] FOREIGN KEY([QuestionID])
REFERENCES [iCCG].[Question] ([QuestionID])
GO
ALTER TABLE [iCCG].[QuestionAnswer] CHECK CONSTRAINT [FK_QuestionAnswer_Question]
GO
/****** Object:  ForeignKey [FK_QuestionAnswerSet_Problem]    Script Date: 03/15/2011 15:09:30 ******/
ALTER TABLE [iCCG].[QuestionAnswerSet]  WITH CHECK ADD  CONSTRAINT [FK_QuestionAnswerSet_Problem] FOREIGN KEY([TargetProblemID])
REFERENCES [iCCG].[Problem] ([ProblemID])
GO
ALTER TABLE [iCCG].[QuestionAnswerSet] CHECK CONSTRAINT [FK_QuestionAnswerSet_Problem]
GO
/****** Object:  ForeignKey [FK_QuestionAnswerSet_RefQuestionLogic]    Script Date: 03/15/2011 15:09:30 ******/
ALTER TABLE [iCCG].[QuestionAnswerSet]  WITH CHECK ADD  CONSTRAINT [FK_QuestionAnswerSet_RefQuestionLogic] FOREIGN KEY([QuestionLogicID])
REFERENCES [iCCG].[RefQuestionLogicType] ([QuestionLogicTypeID])
GO
ALTER TABLE [iCCG].[QuestionAnswerSet] CHECK CONSTRAINT [FK_QuestionAnswerSet_RefQuestionLogic]
GO
/****** Object:  ForeignKey [FK_QuestionAnswerSetMember_QuestionAnswer]    Script Date: 03/15/2011 15:09:32 ******/
ALTER TABLE [iCCG].[QuestionAnswerSetMember]  WITH CHECK ADD  CONSTRAINT [FK_QuestionAnswerSetMember_QuestionAnswer] FOREIGN KEY([QuestionAnswerID])
REFERENCES [iCCG].[QuestionAnswer] ([QuestionAnswerID])
GO
ALTER TABLE [iCCG].[QuestionAnswerSetMember] CHECK CONSTRAINT [FK_QuestionAnswerSetMember_QuestionAnswer]
GO
/****** Object:  ForeignKey [FK_QuestionAnswerSetMember_QuestionAnswerSet]    Script Date: 03/15/2011 15:09:32 ******/
ALTER TABLE [iCCG].[QuestionAnswerSetMember]  WITH CHECK ADD  CONSTRAINT [FK_QuestionAnswerSetMember_QuestionAnswerSet] FOREIGN KEY([QuestionAnswerSetID])
REFERENCES [iCCG].[QuestionAnswerSet] ([QuestionAnswerSetID])
GO
ALTER TABLE [iCCG].[QuestionAnswerSetMember] CHECK CONSTRAINT [FK_QuestionAnswerSetMember_QuestionAnswerSet]
GO
/****** Object:  ForeignKey [FK_Section_GuidelineSection]    Script Date: 03/15/2011 15:09:49 ******/
ALTER TABLE [iCCG].[Section]  WITH CHECK ADD  CONSTRAINT [FK_Section_GuidelineSection] FOREIGN KEY([GuidelineSectionID])
REFERENCES [dbo].[GuidelineSection] ([GuidelineSectionID])
GO
ALTER TABLE [iCCG].[Section] CHECK CONSTRAINT [FK_Section_GuidelineSection]
GO
/****** Object:  ForeignKey [FK_Section_RefSectionType]    Script Date: 03/15/2011 15:09:49 ******/
ALTER TABLE [iCCG].[Section]  WITH CHECK ADD  CONSTRAINT [FK_Section_RefSectionType] FOREIGN KEY([TypeID])
REFERENCES [iCCG].[RefSectionType] ([SectionTypeID])
GO
ALTER TABLE [iCCG].[Section] CHECK CONSTRAINT [FK_Section_RefSectionType]
GO
/****** Object:  ForeignKey [FK_Section_Survey]    Script Date: 03/15/2011 15:09:49 ******/
ALTER TABLE [iCCG].[Section]  WITH CHECK ADD  CONSTRAINT [FK_Section_Survey] FOREIGN KEY([SurveyID])
REFERENCES [iCCG].[Survey] ([SurveyID])
GO
ALTER TABLE [iCCG].[Section] CHECK CONSTRAINT [FK_Section_Survey]
GO
/****** Object:  ForeignKey [FK_SectionQuestionAnswerGroup_GuidelineSection]    Script Date: 03/15/2011 15:09:51 ******/
ALTER TABLE [iCCG].[SectionQuestionAnswerGroup]  WITH CHECK ADD  CONSTRAINT [FK_SectionQuestionAnswerGroup_GuidelineSection] FOREIGN KEY([SectionID])
REFERENCES [dbo].[GuidelineSection] ([GuidelineSectionID])
GO
ALTER TABLE [iCCG].[SectionQuestionAnswerGroup] CHECK CONSTRAINT [FK_SectionQuestionAnswerGroup_GuidelineSection]
GO
/****** Object:  ForeignKey [FK_SectionQuestionAnswerGroup_Survey]    Script Date: 03/15/2011 15:09:51 ******/
ALTER TABLE [iCCG].[SectionQuestionAnswerGroup]  WITH CHECK ADD  CONSTRAINT [FK_SectionQuestionAnswerGroup_Survey] FOREIGN KEY([SurveyID])
REFERENCES [iCCG].[Survey] ([SurveyID])
GO
ALTER TABLE [iCCG].[SectionQuestionAnswerGroup] CHECK CONSTRAINT [FK_SectionQuestionAnswerGroup_Survey]
GO
/****** Object:  ForeignKey [FK_SectionQuestionAnswerGroupMember_QuestionAnswer]    Script Date: 03/15/2011 15:09:53 ******/
ALTER TABLE [iCCG].[SectionQuestionAnswerGroupMember]  WITH CHECK ADD  CONSTRAINT [FK_SectionQuestionAnswerGroupMember_QuestionAnswer] FOREIGN KEY([QuestionAnswerID])
REFERENCES [iCCG].[QuestionAnswer] ([QuestionAnswerID])
GO
ALTER TABLE [iCCG].[SectionQuestionAnswerGroupMember] CHECK CONSTRAINT [FK_SectionQuestionAnswerGroupMember_QuestionAnswer]
GO
/****** Object:  ForeignKey [FK_SectionQuestionAnswerGroupMember_SectionQuestionAnswerGroup]    Script Date: 03/15/2011 15:09:53 ******/
ALTER TABLE [iCCG].[SectionQuestionAnswerGroupMember]  WITH CHECK ADD  CONSTRAINT [FK_SectionQuestionAnswerGroupMember_SectionQuestionAnswerGroup] FOREIGN KEY([SectionQuestionAnswerGroupID])
REFERENCES [iCCG].[SectionQuestionAnswerGroup] ([SectionQuestionAnswerGroupID])
GO
ALTER TABLE [iCCG].[SectionQuestionAnswerGroupMember] CHECK CONSTRAINT [FK_SectionQuestionAnswerGroupMember_SectionQuestionAnswerGroup]
GO
/****** Object:  ForeignKey [FK_Answer_RefAnswerType]    Script Date: 03/15/2011 15:09:56 ******/
ALTER TABLE [iCCG].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answer_RefAnswerType] FOREIGN KEY([TypeID])
REFERENCES [iCCG].[RefAnswerType] ([AnswerTypeID])
GO
ALTER TABLE [iCCG].[Answer] CHECK CONSTRAINT [FK_Answer_RefAnswerType]
GO
