USE [iCCG]
GO

/****** Object:  StoredProcedure [iCCG].[PersistCaseAnswer]    Script Date: 02/23/2011 13:51:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [iCCG].[PersistCaseAnswer]
    @caseID INT = 0
   ,@programID INT = 0
   ,@guidelineID INT = 0
   ,@questionID INT = NULL
   ,@answerID INT = NULL
   ,@answerValue VARCHAR(MAX)
AS 
    BEGIN
        DECLARE @programGuidelineID INT
        DECLARE @assessmentID INT
        DECLARE @questionAnswerID INT
        DECLARE @answerType INT

        SELECT  @programGuidelineID = ProgramGuidelineID
        FROM    [iCCG].[iCCG].ProgramGuideline
        WHERE   [ProgramID] = @programID
                AND [GuidelineID] = @guidelineID

        UPDATE  [iCCG].[iCCG].[Assessment]
        SET     [StatusID] = 1
               ,[Active] = 1
               ,[ModifiedDate] = GETDATE()
               ,[ModifiedBy] = 1
        WHERE   CaseID = @caseID
                AND ProgramGuidelineID = @programGuidelineID
        IF @@ROWCOUNT = 0 
            BEGIN
                INSERT  INTO [iCCG].[iCCG].[Assessment]
                        ([CaseID]
                        ,[ProgramGuidelineID]
                        ,[StatusID]
                        ,[Active]
                        ,[CreatedDate]
                        ,[CreatedBy])
                VALUES  (@caseID
                        ,@programGuidelineID
                        ,1
                        ,1
                        ,GETDATE()
                        ,1)
                        
                SET @assessmentID = @@IDENTITY
            END
       
        SELECT  @questionAnswerID = QuestionAnswerID
        FROM    iCCG.QuestionAnswer
        WHERE   QuestionID = @questionID
                AND AnswerID = @answerID
        
        SELECT  @answerType = [TypeID]
        FROM    [iCCG].[iCCG].[Answer]
        WHERE   AnswerID = @answerID

        DECLARE @textValue VARCHAR(MAX) 
        DECLARE @dateValue DATETIME
        DECLARE @decimalValue DECIMAL(18, 0)

        IF (@answerType = 1) 
            SET @textValue = @answerValue
        IF (@answerType = 2) 
            SET @decimalValue = CAST(@answerValue AS DECIMAL(18, 0))
        IF (@answerType = 3) 
            SET @dateValue = CAST(@answerValue AS DATETIME)

        UPDATE  [iCCG].[iCCG].[CaseAnswer]
        SET     [TextValue] = @textValue
               ,[DateValue] = @dateValue
               ,[DecimalValue] = @decimalValue
               ,[ModifiedDate] = GETDATE()
               ,[ModifiedBy] = 1
               ,[Active] = 1
        WHERE   AssessmentID = @assessmentID
                AND QuestionAnswerID = @questionAnswerID
        IF @@ROWCOUNT = 0 
            BEGIN
                INSERT  INTO [iCCG].[iCCG].[CaseAnswer]
                        ([AssessmentID]
                        ,[QuestionAnswerID]
                        ,[TextValue]
                        ,[DateValue]
                        ,[DecimalValue]
                        ,[CreatedBy]
                        ,[ModifiedDate]
                        ,[ModifiedBy]
                        ,[Active])
                VALUES  (@assessmentID
                        ,@questionAnswerID
                        ,@textValue
                        ,@dateValue
                        ,@decimalValue
                        ,1
                        ,NULL
                        ,NULL
                        ,1)
            END
    END

GO


