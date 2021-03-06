
/****** Object:  StoredProcedure [iCCG].[SectionQuestionAnswerGroupUpdate]    Script Date: 03/13/2011 12:57:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionQuestionAnswerGroupUpdate]
(
	@SectionQuestionAnswerGroupID   INT              OUTPUT,
	@GuidelineSectionID        INT              = NULL,
	@QuestionAnswerID          INT              = NULL,
	@Ordinal                   INT              = NULL,
	@SurveyID                  INT              = NULL,
	@Active                    BIT              = NULL,
	@CreatedDate               DATETIME         = NULL,
	@CreatedBy                 INT              = NULL,
	@ModifiedDate              DATETIME         = NULL,
	@ModifiedBy                INT              = NULL,
	@Debug                     BIT              = 0
)
AS
/************************************************
* CareWebQI
* NAME		: SectionQuestionAnswerGroupUpdate
* AUTHOR  	: (generated)
* DATE		: 3/8/2011
* LAST REV	: 3/8/2011
*
* PURPOSE:	Updates an existing SectionQuestionAnswerGroup record.
*
* TABLES USED:  SectionQuestionAnswerGroup
*
* PARAMETERS IN:
* 		SectionQuestionAnswerGroupID
* 		GuidelineSectionID
* 		QuestionAnswerID
* 		Ordinal
* 		SurveyID
* 		Active
* 		CreatedDate
* 		CreatedBy
* 		ModifiedDate
* 		ModifiedBy
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
	SET @procName = 'SectionQuestionAnswerGroupUpdate';
	
	
	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Updating specified [SectionQuestionAnswerGroup] record...';
	 END
	
	
	UPDATE [SectionQuestionAnswerGroup]
	 SET
		[GuidelineSectionID] = @GuidelineSectionID,
		[QuestionAnswerID]   = @QuestionAnswerID,
		[Ordinal]            = @Ordinal,
		[SurveyID]           = @SurveyID,
		[Active]             = @Active,
		[CreatedDate]        = @CreatedDate,
		[CreatedBy]          = @CreatedBy,
		[ModifiedDate]       = @ModifiedDate,
		[ModifiedBy]         = @ModifiedBy
	 WHERE
		[SectionQuestionAnswerGroupID] = @SectionQuestionAnswerGroupID;
	
	SELECT @errCode = @errCode + @@ERROR;
	
	
IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [iCCG].[SectionQuestionAnswerGroupRetrieveBySurveyID]    Script Date: 03/13/2011 12:57:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionQuestionAnswerGroupRetrieveBySurveyID]
(
	@SurveyID INT,
	@Debug                     BIT = 0
)
AS
/************************************************
* CareWebQI
* NAME		: SectionQuestionAnswerGroupRetrieveBySurveyID
* AUTHOR  	: (generated)
* DATE		: 3/8/2011
* LAST REV	: 3/8/2011
*
* PURPOSE:	Selects a SectionQuestionAnswerGroup record based on the value of one of its ID columns.
*
* TABLES USED:  SectionQuestionAnswerGroup
*
* PARAMETERS IN:
* 		SurveyID			- Key field 
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
	SET @procName = 'SectionQuestionAnswerGroupRetrieveBySurveyID';
	
	
	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Selecting specified [SectionQuestionAnswerGroup] record...';
	 END
	
	
	SELECT
		[SectionQuestionAnswerGroupID],
		[GuidelineSectionID],
		[QuestionAnswerID],
		[Ordinal],
		[SurveyID],
		[Active],
		[CreatedDate],
		[CreatedBy],
		[ModifiedDate],
		[ModifiedBy]
	 FROM
		[SectionQuestionAnswerGroup]
	 WHERE
		[SurveyID] = @SurveyID 
	
	SELECT @errCode = @errCode + @@ERROR;
	
	
IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [iCCG].[SectionQuestionAnswerGroupRetrieveByQuestionAnswerID]    Script Date: 03/13/2011 12:57:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionQuestionAnswerGroupRetrieveByQuestionAnswerID]
(
	@QuestionAnswerID INT,
	@Debug                     BIT = 0
)
AS
/************************************************
* CareWebQI
* NAME		: SectionQuestionAnswerGroupRetrieveByQuestionAnswerID
* AUTHOR  	: (generated)
* DATE		: 3/8/2011
* LAST REV	: 3/8/2011
*
* PURPOSE:	Selects a SectionQuestionAnswerGroup record based on the value of one of its ID columns.
*
* TABLES USED:  SectionQuestionAnswerGroup
*
* PARAMETERS IN:
* 		QuestionAnswerID			- Key field 
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
	SET @procName = 'SectionQuestionAnswerGroupRetrieveByQuestionAnswerID';
	
	
	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Selecting specified [SectionQuestionAnswerGroup] record...';
	 END
	
	
	SELECT
		[SectionQuestionAnswerGroupID],
		[GuidelineSectionID],
		[QuestionAnswerID],
		[Ordinal],
		[SurveyID],
		[Active],
		[CreatedDate],
		[CreatedBy],
		[ModifiedDate],
		[ModifiedBy]
	 FROM
		[SectionQuestionAnswerGroup]
	 WHERE
		[QuestionAnswerID] = @QuestionAnswerID 
	
	SELECT @errCode = @errCode + @@ERROR;
	
	
IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [iCCG].[SectionQuestionAnswerGroupRetrieveByGuidelineSectionID]    Script Date: 03/13/2011 12:57:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionQuestionAnswerGroupRetrieveByGuidelineSectionID]
(
	@GuidelineSectionID INT,
	@Debug                     BIT = 0
)
AS
/************************************************
* CareWebQI
* NAME		: SectionQuestionAnswerGroupRetrieveByGuidelineSectionID
* AUTHOR  	: (generated)
* DATE		: 3/8/2011
* LAST REV	: 3/8/2011
*
* PURPOSE:	Selects a SectionQuestionAnswerGroup record based on the value of one of its ID columns.
*
* TABLES USED:  SectionQuestionAnswerGroup
*
* PARAMETERS IN:
* 		GuidelineSectionID			- Key field 
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
	SET @procName = 'SectionQuestionAnswerGroupRetrieveByGuidelineSectionID';
	
	
	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Selecting specified [SectionQuestionAnswerGroup] record...';
	 END
	
	
	SELECT
		[SectionQuestionAnswerGroupID],
		[GuidelineSectionID],
		[QuestionAnswerID],
		[Ordinal],
		[SurveyID],
		[Active],
		[CreatedDate],
		[CreatedBy],
		[ModifiedDate],
		[ModifiedBy]
	 FROM
		[SectionQuestionAnswerGroup]
	 WHERE
		[GuidelineSectionID] = @GuidelineSectionID 
	
	SELECT @errCode = @errCode + @@ERROR;
	
	
IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [iCCG].[SectionQuestionAnswerGroupRetrieveAll]    Script Date: 03/13/2011 12:57:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionQuestionAnswerGroupRetrieveAll]
(
	@Debug		BIT = 0
)
AS
/************************************************
* CareWebQI
* NAME		: SectionQuestionAnswerGroupRetrieveAll
* AUTHOR  	: (generated)
* DATE		: 3/8/2011
* LAST REV	: 3/8/2011
*
* PURPOSE:	Selects all SectionQuestionAnswerGroup records.
*
* TABLES USED:  SectionQuestionAnswerGroup
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
	SET @procName = 'SectionQuestionAnswerGroupRetrieveAll';
	
	
	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Selecting all [SectionQuestionAnswerGroup] records...';
	 END
	
	
	SELECT
		[SectionQuestionAnswerGroupID],
		[GuidelineSectionID],
		[QuestionAnswerID],
		[Ordinal],
		[SurveyID],
		[Active],
		[CreatedDate],
		[CreatedBy],
		[ModifiedDate],
		[ModifiedBy]
	 FROM
		[SectionQuestionAnswerGroup];
	
	SELECT @errCode = @errCode + @@ERROR;
	
	
IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [iCCG].[SectionQuestionAnswerGroupRetrieve]    Script Date: 03/13/2011 12:57:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionQuestionAnswerGroupRetrieve]
(
	@SectionQuestionAnswerGroupID   INT,
	@Debug                     BIT = 0
)
AS
/************************************************
* CareWebQI
* NAME		: SectionQuestionAnswerGroupRetrieve
* AUTHOR  	: (generated)
* DATE		: 3/8/2011
* LAST REV	: 3/8/2011
*
* PURPOSE:	Selects a SectionQuestionAnswerGroup record based on the primary key.
*
* TABLES USED:  SectionQuestionAnswerGroup
*
* PARAMETERS IN:
* 		SectionQuestionAnswerGroupID			- Primary Key
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
	SET @procName = 'SectionQuestionAnswerGroupRetrieve';
	
	
	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Selecting specified [SectionQuestionAnswerGroup] record...';
	 END
	
	
	SELECT
		[SectionQuestionAnswerGroupID],
		[GuidelineSectionID],
		[QuestionAnswerID],
		[Ordinal],
		[SurveyID],
		[Active],
		[CreatedDate],
		[CreatedBy],
		[ModifiedDate],
		[ModifiedBy]
	 FROM
		[SectionQuestionAnswerGroup]
	 WHERE
		[SectionQuestionAnswerGroupID] = @SectionQuestionAnswerGroupID;
	
	SELECT @errCode = @errCode + @@ERROR;
	
	
IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [iCCG].[SectionQuestionAnswerGroupInsert]    Script Date: 03/13/2011 12:57:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionQuestionAnswerGroupInsert]
(
	@SectionQuestionAnswerGroupID   INT              OUTPUT,
	@GuidelineSectionID        INT              = NULL,
	@QuestionAnswerID          INT              = NULL,
	@Ordinal                   INT              = NULL,
	@SurveyID                  INT              = NULL,
	@Active                    BIT              = NULL,
	@CreatedDate               DATETIME         = NULL,
	@CreatedBy                 INT              = NULL,
	@ModifiedDate              DATETIME         = NULL,
	@ModifiedBy                INT              = NULL,
	@Debug                     BIT              = 0
)
AS
/************************************************
* CareWebQI
* NAME		: SectionQuestionAnswerGroupInsert
* AUTHOR  	: (generated)
* DATE		: 3/8/2011
* LAST REV	: 3/8/2011
*
* PURPOSE:	Inserts a SectionQuestionAnswerGroup record and returns the new ID.
*
* TABLES USED:  SectionQuestionAnswerGroup
*
* PARAMETERS IN:
* 		SectionQuestionAnswerGroupID
* 		GuidelineSectionID
* 		QuestionAnswerID
* 		Ordinal
* 		SurveyID
* 		Active
* 		CreatedDate
* 		CreatedBy
* 		ModifiedDate
* 		ModifiedBy
* 		Debug				- Flag for debug printing
*
* PARAMETERS OUT:
* 		SectionQuestionAnswerGroupID
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
	SET @procName = 'SectionQuestionAnswerGroupInsert';
	
	
	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Inserting new [SectionQuestionAnswerGroup] record...';
	 END
	
	
	INSERT INTO [SectionQuestionAnswerGroup]
	 (
		[GuidelineSectionID],
		[QuestionAnswerID],
		[Ordinal],
		[SurveyID],
		[Active],
		[CreatedDate],
		[CreatedBy],
		[ModifiedDate],
		[ModifiedBy]
	 )
	 VALUES
	 (
		@GuidelineSectionID,
		@QuestionAnswerID,
		@Ordinal,
		@SurveyID,
		@Active,
		@CreatedDate,
		@CreatedBy,
		@ModifiedDate,
		@ModifiedBy
	 );
	
	SELECT @errCode = @errCode + @@ERROR;
	
	
	SELECT @SectionQuestionAnswerGroupID = SCOPE_IDENTITY();
	
	
	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Trapped SectionQuestionAnswerGroupID = ' + CAST(@SectionQuestionAnswerGroupID AS VARCHAR(10));
	 END
	
IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [iCCG].[SectionQuestionAnswerGroupDelete]    Script Date: 03/13/2011 12:57:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionQuestionAnswerGroupDelete]
(
	@SectionQuestionAnswerGroupID   INT,
	@Debug                     BIT = 0
)
AS
/************************************************
* CareWebQI
* NAME		: SectionQuestionAnswerGroupDelete
* AUTHOR  	: (generated)
* DATE		: 3/8/2011
* LAST REV	: 3/8/2011
*
* PURPOSE:	Deletes a SectionQuestionAnswerGroup record based on the primary key.
*
* TABLES USED:  SectionQuestionAnswerGroup
*
* PARAMETERS IN:
* 		SectionQuestionAnswerGroupID			- Primary Key
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
	SET @procName = 'SectionQuestionAnswerGroupDelete';
	
	
	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Deleting specified [SectionQuestionAnswerGroup] record...';
	 END
	
	
	DELETE FROM [SectionQuestionAnswerGroup]
	 WHERE
		[SectionQuestionAnswerGroupID] = @SectionQuestionAnswerGroupID;
	
	SELECT @errCode = @errCode + @@ERROR;
	
	
IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
/****** Object:  StoredProcedure [iCCG].[SectionQuestionAnswerGroupDeactivate]    Script Date: 03/13/2011 12:57:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionQuestionAnswerGroupDeactivate]
(
	@SectionQuestionAnswerGroupID   INT,
	@Debug                     BIT = 0
)
AS
/************************************************
* CareWebQI
* NAME		: SectionQuestionAnswerGroupDeactivate
* AUTHOR  	: (generated)
* DATE		: 3/8/2011
* LAST REV	: 3/8/2011
*
* PURPOSE:	Deactivates a SectionQuestionAnswerGroup record based on the primary key.
*
* TABLES USED:  SectionQuestionAnswerGroup
*
* PARAMETERS IN:
* 		SectionQuestionAnswerGroupID			- Primary Key
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
	SET @procName = 'SectionQuestionAnswerGroupDeactivate';
	
	
	IF @Debug = 1
	 BEGIN
		PRINT @procName + ': Deactivating specified [SectionQuestionAnswerGroup] record...';
	 END
	
	
	UPDATE [SectionQuestionAnswerGroup]
	 SET [Active] = 0
	 WHERE
		[SectionQuestionAnswerGroupID] = @SectionQuestionAnswerGroupID;
	
	SELECT @errCode = @errCode + @@ERROR;
	
	
IF @errCode <> 0
	RETURN -1;
ELSE
	RETURN 0;

END
GO
