SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[AnswerRetrieveByAnswerUniqueID]
    (
     @AnswerUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'AnswerRetrieveByAnswerUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Answer] record...' ;
            END
        SELECT  [AnswerID]
               ,[AnswerUniqueID]
               ,[AnswerText]
               ,[XmlID]
               ,[XmlContent]
               ,[TypeID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Answer]
        WHERE   [AnswerUniqueID] = @AnswerUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[AnswerRetrieveByTypeID]
    (
     @TypeID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'AnswerRetrieveByTypeID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Answer] record...' ;
            END
        SELECT  [AnswerID]
               ,[AnswerUniqueID]
               ,[AnswerText]
               ,[XmlID]
               ,[XmlContent]
               ,[TypeID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Answer]
        WHERE   [TypeID] = @TypeID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[AnswerRetrieveByXmlID]
    (
     @XmlID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'AnswerRetrieveByXmlID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Answer] record...' ;
            END
        SELECT  [AnswerID]
               ,[AnswerUniqueID]
               ,[AnswerText]
               ,[XmlID]
               ,[XmlContent]
               ,[TypeID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Answer]
        WHERE   [XmlID] = @XmlID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[AnswerProblemRefRetrieveByAnswerUniqueID]
    (
     @AnswerUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'AnswerProblemRefRetrieveByAnswerUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [AnswerProblemRef] record...' ;
            END
        SELECT  [AnswerProblemRefID]
               ,[AnswerUniqueID]
               ,[ProblemUniqueID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [AnswerProblemRef]
        WHERE   [AnswerUniqueID] = @AnswerUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[AnswerProblemRefRetrieveByProblemUniqueID]
    (
     @ProblemUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'AnswerProblemRefRetrieveByProblemUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [AnswerProblemRef] record...' ;
            END
        SELECT  [AnswerProblemRefID]
               ,[AnswerUniqueID]
               ,[ProblemUniqueID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [AnswerProblemRef]
        WHERE   [ProblemUniqueID] = @ProblemUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[AnswerQuestionRefRetrieveByAnswerUniqueID]
    (
     @AnswerUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'AnswerQuestionRefRetrieveByAnswerUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [AnswerQuestionRef] record...' ;
            END
        SELECT  [AnswerQuestionRefID]
               ,[AnswerUniqueID]
               ,[QuestionUniqueID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [AnswerQuestionRef]
        WHERE   [AnswerUniqueID] = @AnswerUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[AnswerQuestionRefRetrieveByQuestionUniqueID]
    (
     @QuestionUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'AnswerQuestionRefRetrieveByQuestionUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [AnswerQuestionRef] record...' ;
            END
        SELECT  [AnswerQuestionRefID]
               ,[AnswerUniqueID]
               ,[QuestionUniqueID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [AnswerQuestionRef]
        WHERE   [QuestionUniqueID] = @QuestionUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[AppUserRetrieveByUserID]
    (
     @UserID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'AppUserRetrieveByUserID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [AppUser] record...' ;
            END
        SELECT  [UserID]
               ,[LoginName]
               ,[Password]
               ,[FirstName]
               ,[LastName]
               ,[Email]
               ,[ChangedPassword]
               ,[LockDate]
               ,[PasswordChangeDate]
               ,[DeactivateDate]
               ,[UnsuccessfulAttempts]
               ,[LastAttemptedDate]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [AppUser]
        WHERE   [UserID] = @UserID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[BarrierRetrieveByBarrierUniqueID]
    (
     @BarrierUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'BarrierRetrieveByBarrierUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Barrier] record...' ;
            END
        SELECT  [BarrierID]
               ,[BarrierUniqueID]
               ,[BarrierText]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Barrier]
        WHERE   [BarrierUniqueID] = @BarrierUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseRetrieveByCaseOwnerID]
    (
     @CaseOwnerID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseRetrieveByCaseOwnerID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Case] record...' ;
            END
        SELECT  [CaseID]
               ,[OriginalCaseNumber]
               ,[PatientID]
               ,[CaseOwnerID]
               ,[ProviderID]
               ,[TypeID]
               ,[IdentifiedDate]
               ,[OpenDate]
               ,[CloseDate]
               ,[ClosureReasonID]
               ,[StatusID]
               ,[Source]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Case]
        WHERE   [CaseOwnerID] = @CaseOwnerID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseRetrieveByClosureReasonID]
    (
     @ClosureReasonID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseRetrieveByClosureReasonID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Case] record...' ;
            END
        SELECT  [CaseID]
               ,[OriginalCaseNumber]
               ,[PatientID]
               ,[CaseOwnerID]
               ,[ProviderID]
               ,[TypeID]
               ,[IdentifiedDate]
               ,[OpenDate]
               ,[CloseDate]
               ,[ClosureReasonID]
               ,[StatusID]
               ,[Source]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Case]
        WHERE   [ClosureReasonID] = @ClosureReasonID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseRetrieveByPatientID]
    (
     @PatientID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseRetrieveByPatientID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Case] record...' ;
            END
        SELECT  [CaseID]
               ,[OriginalCaseNumber]
               ,[PatientID]
               ,[CaseOwnerID]
               ,[ProviderID]
               ,[TypeID]
               ,[IdentifiedDate]
               ,[OpenDate]
               ,[CloseDate]
               ,[ClosureReasonID]
               ,[StatusID]
               ,[Source]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Case]
        WHERE   [PatientID] = @PatientID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseRetrieveByProviderID]
    (
     @ProviderID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseRetrieveByProviderID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Case] record...' ;
            END
        SELECT  [CaseID]
               ,[OriginalCaseNumber]
               ,[PatientID]
               ,[CaseOwnerID]
               ,[ProviderID]
               ,[TypeID]
               ,[IdentifiedDate]
               ,[OpenDate]
               ,[CloseDate]
               ,[ClosureReasonID]
               ,[StatusID]
               ,[Source]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Case]
        WHERE   [ProviderID] = @ProviderID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseRetrieveByStatusID]
    (
     @StatusID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseRetrieveByStatusID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Case] record...' ;
            END
        SELECT  [CaseID]
               ,[OriginalCaseNumber]
               ,[PatientID]
               ,[CaseOwnerID]
               ,[ProviderID]
               ,[TypeID]
               ,[IdentifiedDate]
               ,[OpenDate]
               ,[CloseDate]
               ,[ClosureReasonID]
               ,[StatusID]
               ,[Source]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Case]
        WHERE   [StatusID] = @StatusID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseRetrieveByTypeID]
    (
     @TypeID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseRetrieveByTypeID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Case] record...' ;
            END
        SELECT  [CaseID]
               ,[OriginalCaseNumber]
               ,[PatientID]
               ,[CaseOwnerID]
               ,[ProviderID]
               ,[TypeID]
               ,[IdentifiedDate]
               ,[OpenDate]
               ,[CloseDate]
               ,[ClosureReasonID]
               ,[StatusID]
               ,[Source]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Case]
        WHERE   [TypeID] = @TypeID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseAnswerRetrieveByCaseGuidelineSectionID]
    (
     @CaseGuidelineSectionID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseAnswerRetrieveByCaseGuidelineSectionID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseAnswer] record...' ;
            END
        SELECT  [CaseAnswerID]
               ,[CaseGuidelineSectionID]
               ,[QuestionAnswerID]
               ,[TextValue]
               ,[DateValue]
               ,[DecimalValue]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
               ,[Active]
        FROM    [CaseAnswer]
        WHERE   [CaseGuidelineSectionID] = @CaseGuidelineSectionID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseAnswerRetrieveByQuestionAnswerID]
    (
     @QuestionAnswerID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseAnswerRetrieveByQuestionAnswerID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseAnswer] record...' ;
            END
        SELECT  [CaseAnswerID]
               ,[CaseGuidelineSectionID]
               ,[QuestionAnswerID]
               ,[TextValue]
               ,[DateValue]
               ,[DecimalValue]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
               ,[Active]
        FROM    [CaseAnswer]
        WHERE   [QuestionAnswerID] = @QuestionAnswerID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseBarrierRetrieveByBarrierUniqueID]
    (
     @BarrierUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseBarrierRetrieveByBarrierUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseBarrier] record...' ;
            END
        SELECT  [CaseBarrierID]
               ,[BarrierUniqueID]
               ,[CaseGoalID]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
               ,[Active]
        FROM    [CaseBarrier]
        WHERE   [BarrierUniqueID] = @BarrierUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseBarrierRetrieveByCaseGoalID]
    (
     @CaseGoalID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseBarrierRetrieveByCaseGoalID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseBarrier] record...' ;
            END
        SELECT  [CaseBarrierID]
               ,[BarrierUniqueID]
               ,[CaseGoalID]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
               ,[Active]
        FROM    [CaseBarrier]
        WHERE   [CaseGoalID] = @CaseGoalID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseGoalRetrieveByGoalUniqueID]
    (
     @GoalUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseGoalRetrieveByGoalUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseGoal] record...' ;
            END
        SELECT  [CaseGoalID]
               ,[ProblemListID]
               ,[GoalUniqueID]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
               ,[Active]
        FROM    [CaseGoal]
        WHERE   [GoalUniqueID] = @GoalUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseGoalRetrieveByProblemListID]
    (
     @ProblemListID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseGoalRetrieveByProblemListID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseGoal] record...' ;
            END
        SELECT  [CaseGoalID]
               ,[ProblemListID]
               ,[GoalUniqueID]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
               ,[Active]
        FROM    [CaseGoal]
        WHERE   [ProblemListID] = @ProblemListID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseGuidelineSectionRetrieveByCaseID]
    (
     @CaseID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseGuidelineSectionRetrieveByCaseID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseGuidelineSection] record...' ;
            END
        SELECT  [CaseGuidelineSectionID]
               ,[CaseID]
               ,[GuidelineSectionID]
               ,[StartDate]
               ,[EndDate]
               ,[StatusID]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [CaseGuidelineSection]
        WHERE   [CaseID] = @CaseID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseGuidelineSectionRetrieveByGuidelineSectionID]
    (
     @GuidelineSectionID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseGuidelineSectionRetrieveByGuidelineSectionID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseGuidelineSection] record...' ;
            END
        SELECT  [CaseGuidelineSectionID]
               ,[CaseID]
               ,[GuidelineSectionID]
               ,[StartDate]
               ,[EndDate]
               ,[StatusID]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [CaseGuidelineSection]
        WHERE   [GuidelineSectionID] = @GuidelineSectionID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseGuidelineSectionRetrieveByStatusID]
    (
     @StatusID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseGuidelineSectionRetrieveByStatusID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseGuidelineSection] record...' ;
            END
        SELECT  [CaseGuidelineSectionID]
               ,[CaseID]
               ,[GuidelineSectionID]
               ,[StartDate]
               ,[EndDate]
               ,[StatusID]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [CaseGuidelineSection]
        WHERE   [StatusID] = @StatusID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseInterventionRetrieveByCaseGoalID]
    (
     @CaseGoalID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseInterventionRetrieveByCaseGoalID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseIntervention] record...' ;
            END
        SELECT  [CaseInterventionID]
               ,[InterventionUniqueID]
               ,[CaseGoalID]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
               ,[Active]
        FROM    [CaseIntervention]
        WHERE   [CaseGoalID] = @CaseGoalID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseInterventionRetrieveByInterventionUniqueID]
    (
     @InterventionUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseInterventionRetrieveByInterventionUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseIntervention] record...' ;
            END
        SELECT  [CaseInterventionID]
               ,[InterventionUniqueID]
               ,[CaseGoalID]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
               ,[Active]
        FROM    [CaseIntervention]
        WHERE   [InterventionUniqueID] = @InterventionUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseOutcomeRetrieveByCaseGoalID]
    (
     @CaseGoalID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseOutcomeRetrieveByCaseGoalID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseOutcome] record...' ;
            END
        SELECT  [CaseOutcomeID]
               ,[OutcomeUniqueID]
               ,[CaseGoalID]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
               ,[Active]
        FROM    [CaseOutcome]
        WHERE   [CaseGoalID] = @CaseGoalID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseOutcomeRetrieveByOutcomeUniqueID]
    (
     @OutcomeUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseOutcomeRetrieveByOutcomeUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseOutcome] record...' ;
            END
        SELECT  [CaseOutcomeID]
               ,[OutcomeUniqueID]
               ,[CaseGoalID]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
               ,[Active]
        FROM    [CaseOutcome]
        WHERE   [OutcomeUniqueID] = @OutcomeUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseProgramRetrieveByCaseID]
    (
     @CaseID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseProgramRetrieveByCaseID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseProgram] record...' ;
            END
        SELECT  [CaseProgramID]
               ,[CaseID]
               ,[ProgramID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [CaseProgram]
        WHERE   [CaseID] = @CaseID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[CaseProgramRetrieveByProgramID]
    (
     @ProgramID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'CaseProgramRetrieveByProgramID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [CaseProgram] record...' ;
            END
        SELECT  [CaseProgramID]
               ,[CaseID]
               ,[ProgramID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [CaseProgram]
        WHERE   [ProgramID] = @ProgramID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[GoalRetrieveByGoalUniqueID]
    (
     @GoalUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'GoalRetrieveByGoalUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Goal] record...' ;
            END
        SELECT  [GoalID]
               ,[GoalUniqueID]
               ,[GoalText]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Goal]
        WHERE   [GoalUniqueID] = @GoalUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[GoalBarrierRetrieveByBarrierID]
    (
     @BarrierID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'GoalBarrierRetrieveByBarrierID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [GoalBarrier] record...' ;
            END
        SELECT  [GoalBarrierID]
               ,[GoalID]
               ,[BarrierID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [GoalBarrier]
        WHERE   [BarrierID] = @BarrierID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[GoalBarrierRetrieveByGoalID]
    (
     @GoalID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'GoalBarrierRetrieveByGoalID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [GoalBarrier] record...' ;
            END
        SELECT  [GoalBarrierID]
               ,[GoalID]
               ,[BarrierID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [GoalBarrier]
        WHERE   [GoalID] = @GoalID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[GoalInterventionRetrieveByGoalID]
    (
     @GoalID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'GoalInterventionRetrieveByGoalID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [GoalIntervention] record...' ;
            END
        SELECT  [GoalInterventionID]
               ,[GoalID]
               ,[InterventionID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [GoalIntervention]
        WHERE   [GoalID] = @GoalID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[GoalInterventionRetrieveByInterventionID]
    (
     @InterventionID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'GoalInterventionRetrieveByInterventionID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [GoalIntervention] record...' ;
            END
        SELECT  [GoalInterventionID]
               ,[GoalID]
               ,[InterventionID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [GoalIntervention]
        WHERE   [InterventionID] = @InterventionID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[GoalOutcomeRetrieveByGoalID]
    (
     @GoalID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'GoalOutcomeRetrieveByGoalID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [GoalOutcome] record...' ;
            END
        SELECT  [GoalOutcomeID]
               ,[GoalID]
               ,[OutcomeID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [GoalOutcome]
        WHERE   [GoalID] = @GoalID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[GoalOutcomeRetrieveByOutcomeID]
    (
     @OutcomeID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'GoalOutcomeRetrieveByOutcomeID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [GoalOutcome] record...' ;
            END
        SELECT  [GoalOutcomeID]
               ,[GoalID]
               ,[OutcomeID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [GoalOutcome]
        WHERE   [OutcomeID] = @OutcomeID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[GoalProblemRetrieveByGoalID]
    (
     @GoalID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'GoalProblemRetrieveByGoalID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [GoalProblem] record...' ;
            END
        SELECT  [GoalProblemID]
               ,[GoalID]
               ,[ProblemID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [GoalProblem]
        WHERE   [GoalID] = @GoalID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[GoalProblemRetrieveByProblemID]
    (
     @ProblemID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'GoalProblemRetrieveByProblemID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [GoalProblem] record...' ;
            END
        SELECT  [GoalProblemID]
               ,[GoalID]
               ,[ProblemID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [GoalProblem]
        WHERE   [ProblemID] = @ProblemID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[GuidelineRetrieveByGuidelineUniqueID]
    (
     @GuidelineUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'GuidelineRetrieveByGuidelineUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Guideline] record...' ;
            END
        SELECT  [GuidelineID]
               ,[GuidelineUniqueID]
               ,[GuidelineTitle]
               ,[ProductCode]
               ,[Version]
               ,[ContentOwner]
               ,[Hsim]
               ,[GuidelineCode]
               ,[GuidelineType]
               ,[ChronicCondition]
               ,[GLOS]
               ,[GuidelineXML]
               ,[GLOSXML]
               ,[GLOSMin]
               ,[GLOSMax]
               ,[GLOSType]
               ,[VersionMajor]
               ,[VersionMinor]
        FROM    [Guideline]
        WHERE   [GuidelineUniqueID] = @GuidelineUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[GuidelineSectionRetrieveByGuidelineID]
    (
     @GuidelineID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'GuidelineSectionRetrieveByGuidelineID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [GuidelineSection] record...' ;
            END
        SELECT  [GuidelineSectionID]
               ,[GuidelineID]
               ,[SectionID]
               ,[SectionPath]
               ,[SectionXml]
               ,[ContentVersion]
               ,[Hsim]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [GuidelineSection]
        WHERE   [GuidelineID] = @GuidelineID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[GuidelineSectionRetrieveBySectionID]
    (
     @SectionID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'GuidelineSectionRetrieveBySectionID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [GuidelineSection] record...' ;
            END
        SELECT  [GuidelineSectionID]
               ,[GuidelineID]
               ,[SectionID]
               ,[SectionPath]
               ,[SectionXml]
               ,[ContentVersion]
               ,[Hsim]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [GuidelineSection]
        WHERE   [SectionID] = @SectionID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[InterventionRetrieveByInterventionUniqueID]
    (
     @InterventionUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'InterventionRetrieveByInterventionUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Intervention] record...' ;
            END
        SELECT  [InterventionID]
               ,[InterventionUniqueID]
               ,[TypeID]
               ,[InterventionText]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Intervention]
        WHERE   [InterventionUniqueID] = @InterventionUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[InterventionRetrieveByTypeID]
    (
     @TypeID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'InterventionRetrieveByTypeID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Intervention] record...' ;
            END
        SELECT  [InterventionID]
               ,[InterventionUniqueID]
               ,[TypeID]
               ,[InterventionText]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Intervention]
        WHERE   [TypeID] = @TypeID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[NoteRetrieveByParentID]
    (
     @ParentID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'NoteRetrieveByParentID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Note] record...' ;
            END
        SELECT  [NoteID]
               ,[NoteType]
               ,[ParentID]
               ,[NoteText]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Note]
        WHERE   [ParentID] = @ParentID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[OutcomeRetrieveByOutcomeUniqueID]
    (
     @OutcomeUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'OutcomeRetrieveByOutcomeUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Outcome] record...' ;
            END
        SELECT  [OutcomeID]
               ,[OutcomeUniqueID]
               ,[OutcomeText]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Outcome]
        WHERE   [OutcomeUniqueID] = @OutcomeUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[PatientMedicineRetrieveByFrequencyID]
    (
     @FrequencyID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'PatientMedicineRetrieveByFrequencyID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [PatientMedicine] record...' ;
            END
        SELECT  [PatientMedicineID]
               ,[PatientID]
               ,[MedicationName]
               ,[Dose]
               ,[RouteID]
               ,[FrequencyID]
               ,[Started]
               ,[Discontinued]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [PatientMedicine]
        WHERE   [FrequencyID] = @FrequencyID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[PatientMedicineRetrieveByPatientID]
    (
     @PatientID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'PatientMedicineRetrieveByPatientID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [PatientMedicine] record...' ;
            END
        SELECT  [PatientMedicineID]
               ,[PatientID]
               ,[MedicationName]
               ,[Dose]
               ,[RouteID]
               ,[FrequencyID]
               ,[Started]
               ,[Discontinued]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [PatientMedicine]
        WHERE   [PatientID] = @PatientID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[PatientMedicineRetrieveByRouteID]
    (
     @RouteID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'PatientMedicineRetrieveByRouteID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [PatientMedicine] record...' ;
            END
        SELECT  [PatientMedicineID]
               ,[PatientID]
               ,[MedicationName]
               ,[Dose]
               ,[RouteID]
               ,[FrequencyID]
               ,[Started]
               ,[Discontinued]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [PatientMedicine]
        WHERE   [RouteID] = @RouteID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[ProblemRetrieveByProblemUniqueID]
    (
     @ProblemUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'ProblemRetrieveByProblemUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Problem] record...' ;
            END
        SELECT  [ProblemID]
               ,[ProblemUniqueID]
               ,[ProblemText]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Problem]
        WHERE   [ProblemUniqueID] = @ProblemUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[ProblemListRetrieveByCaseID]
    (
     @CaseID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'ProblemListRetrieveByCaseID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [ProblemList] record...' ;
            END
        SELECT  [ProblemListID]
               ,[ProblemUniqueID]
               ,[CaseID]
               ,[Selected]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
               ,[Active]
        FROM    [ProblemList]
        WHERE   [CaseID] = @CaseID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[ProblemListRetrieveByProblemUniqueID]
    (
     @ProblemUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'ProblemListRetrieveByProblemUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [ProblemList] record...' ;
            END
        SELECT  [ProblemListID]
               ,[ProblemUniqueID]
               ,[CaseID]
               ,[Selected]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
               ,[Active]
        FROM    [ProblemList]
        WHERE   [ProblemUniqueID] = @ProblemUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[ProgramGuidelineRetrieveByGuidelineID]
    (
     @GuidelineID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'ProgramGuidelineRetrieveByGuidelineID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [ProgramGuideline] record...' ;
            END
        SELECT  [ProgramGuidelineID]
               ,[ProgramID]
               ,[GuidelineID]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [ProgramGuideline]
        WHERE   [GuidelineID] = @GuidelineID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[ProgramGuidelineRetrieveByProgramID]
    (
     @ProgramID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'ProgramGuidelineRetrieveByProgramID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [ProgramGuideline] record...' ;
            END
        SELECT  [ProgramGuidelineID]
               ,[ProgramID]
               ,[GuidelineID]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [ProgramGuideline]
        WHERE   [ProgramID] = @ProgramID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[QuestionRetrieveByQuestionUniqueID]
    (
     @QuestionUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'QuestionRetrieveByQuestionUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Question] record...' ;
            END
        SELECT  [QuestionID]
               ,[QuestionUniqueID]
               ,[QuestionText]
               ,[CanPipe]
               ,[CanForward]
               ,[IsMandatory]
               ,[XmlID]
               ,[XmlContent]
               ,[TypeID]
               ,[Weight]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Question]
        WHERE   [QuestionUniqueID] = @QuestionUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[QuestionRetrieveByTypeID]
    (
     @TypeID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'QuestionRetrieveByTypeID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Question] record...' ;
            END
        SELECT  [QuestionID]
               ,[QuestionUniqueID]
               ,[QuestionText]
               ,[CanPipe]
               ,[CanForward]
               ,[IsMandatory]
               ,[XmlID]
               ,[XmlContent]
               ,[TypeID]
               ,[Weight]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Question]
        WHERE   [TypeID] = @TypeID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[QuestionRetrieveByXmlID]
    (
     @XmlID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'QuestionRetrieveByXmlID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Question] record...' ;
            END
        SELECT  [QuestionID]
               ,[QuestionUniqueID]
               ,[QuestionText]
               ,[CanPipe]
               ,[CanForward]
               ,[IsMandatory]
               ,[XmlID]
               ,[XmlContent]
               ,[TypeID]
               ,[Weight]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [Question]
        WHERE   [XmlID] = @XmlID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[QuestionAnswerRetrieveByAnswerID]
    (
     @AnswerID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'QuestionAnswerRetrieveByAnswerID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [QuestionAnswer] record...' ;
            END
        SELECT  [QuestionAnswerID]
               ,[QuestionID]
               ,[AnswerID]
               ,[ParentQuestionAnswerID]
               ,[Help]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [QuestionAnswer]
        WHERE   [AnswerID] = @AnswerID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[QuestionAnswerRetrieveByParentQuestionAnswerID]
    (
     @ParentQuestionAnswerID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'QuestionAnswerRetrieveByParentQuestionAnswerID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [QuestionAnswer] record...' ;
            END
        SELECT  [QuestionAnswerID]
               ,[QuestionID]
               ,[AnswerID]
               ,[ParentQuestionAnswerID]
               ,[Help]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [QuestionAnswer]
        WHERE   [ParentQuestionAnswerID] = @ParentQuestionAnswerID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[QuestionAnswerRetrieveByQuestionID]
    (
     @QuestionID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'QuestionAnswerRetrieveByQuestionID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [QuestionAnswer] record...' ;
            END
        SELECT  [QuestionAnswerID]
               ,[QuestionID]
               ,[AnswerID]
               ,[ParentQuestionAnswerID]
               ,[Help]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [QuestionAnswer]
        WHERE   [QuestionID] = @QuestionID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[QuestionAnswerSetRetrieveByQuestionLogicID]
    (
     @QuestionLogicID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'QuestionAnswerSetRetrieveByQuestionLogicID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [QuestionAnswerSet] record...' ;
            END
        SELECT  [QuestionAnswerSetID]
               ,[QuestionLogicID]
               ,[TargetQuestionAnswerID]
               ,[TargetSectionID]
               ,[TargetProblemID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [QuestionAnswerSet]
        WHERE   [QuestionLogicID] = @QuestionLogicID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[QuestionAnswerSetRetrieveByTargetProblemID]
    (
     @TargetProblemID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'QuestionAnswerSetRetrieveByTargetProblemID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [QuestionAnswerSet] record...' ;
            END
        SELECT  [QuestionAnswerSetID]
               ,[QuestionLogicID]
               ,[TargetQuestionAnswerID]
               ,[TargetSectionID]
               ,[TargetProblemID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [QuestionAnswerSet]
        WHERE   [TargetProblemID] = @TargetProblemID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[QuestionAnswerSetRetrieveByTargetQuestionAnswerID]
    (
     @TargetQuestionAnswerID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'QuestionAnswerSetRetrieveByTargetQuestionAnswerID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [QuestionAnswerSet] record...' ;
            END
        SELECT  [QuestionAnswerSetID]
               ,[QuestionLogicID]
               ,[TargetQuestionAnswerID]
               ,[TargetSectionID]
               ,[TargetProblemID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [QuestionAnswerSet]
        WHERE   [TargetQuestionAnswerID] = @TargetQuestionAnswerID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[QuestionAnswerSetRetrieveByTargetSectionID]
    (
     @TargetSectionID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'QuestionAnswerSetRetrieveByTargetSectionID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [QuestionAnswerSet] record...' ;
            END
        SELECT  [QuestionAnswerSetID]
               ,[QuestionLogicID]
               ,[TargetQuestionAnswerID]
               ,[TargetSectionID]
               ,[TargetProblemID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [QuestionAnswerSet]
        WHERE   [TargetSectionID] = @TargetSectionID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[QuestionAnswerSetMemberRetrieveByQuestionAnswerID]
    (
     @QuestionAnswerID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'QuestionAnswerSetMemberRetrieveByQuestionAnswerID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [QuestionAnswerSetMember] record...' ;
            END
        SELECT  [QuestionAnswerSetMemberID]
               ,[QuestionAnswerSetID]
               ,[QuestionAnswerID]
               ,[Weight]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [QuestionAnswerSetMember]
        WHERE   [QuestionAnswerID] = @QuestionAnswerID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[QuestionAnswerSetMemberRetrieveByQuestionAnswerSetID]
    (
     @QuestionAnswerSetID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'QuestionAnswerSetMemberRetrieveByQuestionAnswerSetID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [QuestionAnswerSetMember] record...' ;
            END
        SELECT  [QuestionAnswerSetMemberID]
               ,[QuestionAnswerSetID]
               ,[QuestionAnswerID]
               ,[Weight]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [QuestionAnswerSetMember]
        WHERE   [QuestionAnswerSetID] = @QuestionAnswerSetID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[RefAnswerTypeRetrieveByAnswerTypeID]
    (
     @AnswerTypeID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'RefAnswerTypeRetrieveByAnswerTypeID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [RefAnswerType] record...' ;
            END
        SELECT  [AnswerTypeID]
               ,[AnswerTypeName]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [RefAnswerType]
        WHERE   [AnswerTypeID] = @AnswerTypeID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[RefCaseGLSectionStatusTypeRetrieveByCaseGLSectionStatusTypeID]
    (
     @CaseGLSectionStatusTypeID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'RefCaseGLSectionStatusTypeRetrieveByCaseGLSectionStatusTypeID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [RefCaseGLSectionStatusType] record...' ;
            END
        SELECT  [CaseGLSectionStatusTypeID]
               ,[CaseGLSectionStatusTypeName]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [RefCaseGLSectionStatusType]
        WHERE   [CaseGLSectionStatusTypeID] = @CaseGLSectionStatusTypeID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[RefCaseStatusTypeRetrieveByCaseStatusTypeID]
    (
     @CaseStatusTypeID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'RefCaseStatusTypeRetrieveByCaseStatusTypeID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [RefCaseStatusType] record...' ;
            END
        SELECT  [CaseStatusTypeID]
               ,[CaseStatusTypeName]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [RefCaseStatusType]
        WHERE   [CaseStatusTypeID] = @CaseStatusTypeID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[RefClosureReasonRetrieveByClosureReasonID]
    (
     @ClosureReasonID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'RefClosureReasonRetrieveByClosureReasonID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [RefClosureReason] record...' ;
            END
        SELECT  [ClosureReasonID]
               ,[ClosureReasonName]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [RefClosureReason]
        WHERE   [ClosureReasonID] = @ClosureReasonID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[RefFrequencyRetrieveByFrequencyID]
    (
     @FrequencyID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'RefFrequencyRetrieveByFrequencyID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [RefFrequency] record...' ;
            END
        SELECT  [FrequencyID]
               ,[FrequencyName]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [RefFrequency]
        WHERE   [FrequencyID] = @FrequencyID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[RefInterventionTypeRetrieveByInterventionTypeID]
    (
     @InterventionTypeID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'RefInterventionTypeRetrieveByInterventionTypeID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [RefInterventionType] record...' ;
            END
        SELECT  [InterventionTypeID]
               ,[InterventionTypeName]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [RefInterventionType]
        WHERE   [InterventionTypeID] = @InterventionTypeID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[RefQuestionLogicTypeRetrieveByQuestionLogicTypeID]
    (
     @QuestionLogicTypeID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'RefQuestionLogicTypeRetrieveByQuestionLogicTypeID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [RefQuestionLogicType] record...' ;
            END
        SELECT  [QuestionLogicTypeID]
               ,[QuestionLogicTypeName]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [RefQuestionLogicType]
        WHERE   [QuestionLogicTypeID] = @QuestionLogicTypeID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[RefQuestionTypeRetrieveByQuestionTypeID]
    (
     @QuestionTypeID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'RefQuestionTypeRetrieveByQuestionTypeID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [RefQuestionType] record...' ;
            END
        SELECT  [QuestionTypeID]
               ,[QuestionTypeName]
               ,[Description]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [RefQuestionType]
        WHERE   [QuestionTypeID] = @QuestionTypeID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[RefRouteRetrieveByRouteID]
    (
     @RouteID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'RefRouteRetrieveByRouteID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [RefRoute] record...' ;
            END
        SELECT  [RouteID]
               ,[RouteName]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [RefRoute]
        WHERE   [RouteID] = @RouteID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[RefSectionTypeRetrieveBySectionTypeID]
    (
     @SectionTypeID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'RefSectionTypeRetrieveBySectionTypeID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [RefSectionType] record...' ;
            END
        SELECT  [SectionTypeID]
               ,[SectionTypeName]
               ,[Ordinal]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [RefSectionType]
        WHERE   [SectionTypeID] = @SectionTypeID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionRetrieveBySectionUniqueID]
    (
     @SectionUniqueID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'SectionRetrieveBySectionUniqueID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [Section] record...' ;
            END
        SELECT  [SectionID]
               ,[SectionUniqueID]
               ,[Heading]
               ,[Hsim]
               ,[ProductCode]
               ,[ContentVersion]
               ,[ContentOwner]
               ,[SectionPath]
               ,[SectionXML]
               ,[DisplayOrder]
               ,[VersionMajor]
               ,[VersionMinor]
        FROM    [Section]
        WHERE   [SectionUniqueID] = @SectionUniqueID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionQuestionAnswerRetrieveByQuestionAnswerID]
    (
     @QuestionAnswerID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'SectionQuestionAnswerRetrieveByQuestionAnswerID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [SectionQuestionAnswer] record...' ;
            END
        SELECT  [SectionQuestionAnswerID]
               ,[SectionID]
               ,[QuestionAnswerID]
               ,[Ordinal]
               ,[SurveyID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [SectionQuestionAnswer]
        WHERE   [QuestionAnswerID] = @QuestionAnswerID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionQuestionAnswerRetrieveBySectionID]
    (
     @SectionID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'SectionQuestionAnswerRetrieveBySectionID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [SectionQuestionAnswer] record...' ;
            END
        SELECT  [SectionQuestionAnswerID]
               ,[SectionID]
               ,[QuestionAnswerID]
               ,[Ordinal]
               ,[SurveyID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [SectionQuestionAnswer]
        WHERE   [SectionID] = @SectionID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END



    
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [iCCG].[SectionQuestionAnswerRetrieveBySurveyID]
    (
     @SurveyID INT
    ,@Debug BIT = 0
    )
AS 
    BEGIN
        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        SET @errCode = 0 ;
        SET @procName = 'SectionQuestionAnswerRetrieveBySurveyID' ;
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Selecting specified [SectionQuestionAnswer] record...' ;
            END
        SELECT  [SectionQuestionAnswerID]
               ,[SectionID]
               ,[QuestionAnswerID]
               ,[Ordinal]
               ,[SurveyID]
               ,[Active]
               ,[CreatedDate]
               ,[CreatedBy]
               ,[ModifiedDate]
               ,[ModifiedBy]
        FROM    [SectionQuestionAnswer]
        WHERE   [SurveyID] = @SurveyID ;
        SELECT  @errCode = @errCode + @@ERROR ;
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END
