USE [iCCG]
/****** Object:  StoredProcedure [iCCG].[PatientMedicineInsert]    Script Date: 03/03/2011 10:38:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


GO   
ALTER PROCEDURE [iCCG].[PatientMedicineInsert]
    (
     @PatientMedicineID INT OUTPUT,
     @PatientID INT = NULL,
     @MedicationName VARCHAR(255) = NULL,
     @Dose VARCHAR(15) = NULL,
     @RouteID INT = NULL,
     @FrequencyID INT = NULL,
     @Started DATETIME = NULL,
     @Discontinued DATETIME = NULL,
     @DurationID INT = NULL,
     @Active BIT = NULL,
     @CreatedDate DATETIME = NULL,
     @CreatedBy INT = NULL,
     @ModifiedDate DATETIME = NULL,
     @ModifiedBy INT = NULL,
     @Debug BIT = 0
    )
AS 
    BEGIN

        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
	
        SET @errCode = 0 ;
        SET @procName = 'PatientMedicineInsert' ;
	
	
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Inserting new [PatientMedicine] record...' ;
            END
	
	
        INSERT  INTO [PatientMedicine]
                ([PatientID],
                 [MedicationName],
                 [Dose],
                 [RouteID],
                 [FrequencyID],
                 [Started],
                 [Discontinued],
                 [DurationID],
                 [Active],
                 [CreatedDate],
                 [CreatedBy],
                 [ModifiedDate],
                 [ModifiedBy])
        VALUES  (@PatientID,
                 @MedicationName,
                 @Dose,
                 CASE WHEN (@routeID = 0) THEN NULL
                      ELSE @routeID
                 END,
                 CASE WHEN (@frequencyID = 0) THEN NULL
                      ELSE @frequencyID
                 END,
                 @Started,
                 @Discontinued,
                 CASE WHEN (@durationID = 0) THEN NULL
                      ELSE @durationID
                 END,
                 @Active,
                 @CreatedDate,
                 @CreatedBy,
                 @ModifiedDate,
                 @ModifiedBy) ;
	
        SELECT  @errCode = @errCode + @@ERROR ;
	
	
        SELECT  @PatientMedicineID = SCOPE_IDENTITY() ;
	
	
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Trapped PatientMedicineID = ' + CAST(@PatientMedicineID AS VARCHAR(10)) ;
            END
	
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;

    END


/****** Object:  StoredProcedure [iCCG].[PatientMedicineUpdate]    Script Date: 03/03/2011 10:51:19 ******/
    SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


GO  

ALTER PROCEDURE [iCCG].[PatientMedicineUpdate]
    (
     @PatientMedicineID INT OUTPUT,
     @PatientID INT = NULL,
     @MedicationName VARCHAR(255) = NULL,
     @Dose VARCHAR(15) = NULL,
     @RouteID INT = NULL,
     @FrequencyID INT = NULL,
     @Started DATETIME = NULL,
     @Discontinued DATETIME = NULL,
     @DurationID INT = NULL,
     @Active BIT = NULL,
     @CreatedDate DATETIME = NULL,
     @CreatedBy INT = NULL,
     @ModifiedDate DATETIME = NULL,
     @ModifiedBy INT = NULL,
     @Debug BIT = 0
    )
AS 
    BEGIN

        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
	
        SET @errCode = 0 ;
        SET @procName = 'PatientMedicineUpdate' ;
	
	
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Updating specified [PatientMedicine] record...' ;
            END

        UPDATE  [PatientMedicine]
        SET     [PatientID] = @PatientID,
                [MedicationName] = @MedicationName,
                [Dose] = @Dose,
                [RouteID] = CASE WHEN (@routeID = 0) THEN NULL
                                 ELSE @routeID
                            END,
                [FrequencyID] = CASE WHEN (@frequencyID = 0) THEN NULL
                                     ELSE @frequencyID
                                END,
                [Started] = @Started,
                [Discontinued] = @Discontinued,
                [DurationID] = CASE WHEN (@durationID = 0) THEN NULL
                                    ELSE @durationID
                               END,
                [Active] = @Active,
                [CreatedDate] = @CreatedDate,
                [CreatedBy] = @CreatedBy,
                [ModifiedDate] = @ModifiedDate,
                [ModifiedBy] = @ModifiedBy
        WHERE   [PatientMedicineID] = @PatientMedicineID ;
	
        SELECT  @errCode = @errCode + @@ERROR ;
	
	
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;

    END


go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [iCCG].[CaseInsert]
    (
     @CaseID INT OUTPUT,
     @OriginalCaseNumber VARCHAR(255) = NULL,
     @PatientID INT = NULL,
     @CaseOwnerID INT = NULL,
     @ProviderID INT = NULL,
     @TypeID INT = NULL,
     @IdentifiedDate DATETIME = NULL,
     @OpenDate DATETIME = NULL,
     @CloseDate DATETIME = NULL,
     @ClosureReasonID INT = NULL,
     @StatusID INT = NULL,
     @Source VARCHAR(255) = NULL,
     @Active BIT = NULL,
     @CreatedDate DATETIME = NULL,
     @CreatedBy INT = NULL,
     @ModifiedDate DATETIME = NULL,
     @ModifiedBy INT = NULL,
     @Debug BIT = 0
    )
AS 
    BEGIN

        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
        DECLARE @rightNow DATETIME ;
        DECLARE @LockResult INT ;
        DECLARE @genIdSource BIT ;
        DECLARE @nextID INT ;
        DECLARE @insertError INT ;
        DECLARE @Reccnt INT ;
	
        SET @errCode = 0 ;
        SET @procName = 'iCCG.CaseInsert' ;	
	
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Inserting new [Case] record...' ;
            END


        SET @rightNow = GETUTCDATE() ;
	
	-- Login the user based on credentials
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Construct Case insert statement' ;
            END
	
	
        IF (@OriginalCaseNumber IS NULL)
            OR (LTRIM(RTRIM(@OriginalCaseNumber)) = '') 
            SET @genIdSource = 1 ;
        ELSE 
            SET @genIdSource = 0 ;
	
	
        BEGIN TRAN
	
	-- Massage FacilityIDSource if null
        IF @genIdSource = 1 
            BEGIN  
                INSERT  INTO [iCCG].[CaseIDSourceGenerator]
                VALUES  (1)
                SET @nextID = SCOPE_IDENTITY() ;
                SET @OriginalCaseNumber = 'CAS-' + RIGHT('00000000' + CAST(@nextID AS VARCHAR(8)), 8) ;
                SELECT  @Reccnt = COUNT(1)
                FROM    [iCCG].[Case] (NOLOCK)
                WHERE   OriginalCaseNumber = @OriginalCaseNumber
                IF @Reccnt <> 0 
                    BEGIN
                        EXEC @LockResult = sp_getapplock @Resource = @procName, @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 20000 ; -- Wait 20 seconds to aquire a lock.  
                        IF (@LockResult < 0) 
                            RAISERROR('Could not get exclusive lock on %s.', 11, 1, @procName ) ;   
                        EXEC [iCCG].[CaseNextOriginalCaseNumber] @OriginalCaseNumber OUT
                    END
            END  

        INSERT  INTO [iCCG].[Case]
                ([OriginalCaseNumber],
                 [PatientID],
                 [CaseOwnerID],
                 [ProviderID],
                 [TypeID],
                 [IdentifiedDate],
                 [OpenDate],
                 [CloseDate],
                 [ClosureReasonID],
                 [StatusID],
                 [Source],
                 [Active],
                 [CreatedDate],
                 [CreatedBy],
                 [ModifiedDate],
                 [ModifiedBy])
        VALUES  (@OriginalCaseNumber,
                 @PatientID,
                 @CaseOwnerID,
                 @ProviderID,
                 @TypeID,
                 @IdentifiedDate,
                 @OpenDate,
                 @CloseDate,
                 CASE WHEN @ClosureReasonID = 0 THEN NULL
                      ELSE @ClosureReasonID
                 END,
                 CASE WHEN @StatusID = 0 THEN NULL
                      ELSE @StatusID
                 END,
                 @Source,
                 @Active,
                 @rightNow,
                 @CreatedBy,
                 @ModifiedDate,
                 @ModifiedBy) ;
	
        SELECT  @CaseID = SCOPE_IDENTITY() ;
	
        SELECT  @errCode = @errCode + @@ERROR ;
			
        IF @errCode = 0 
            BEGIN 
                IF @Debug = 1 
                    BEGIN
                        PRINT @procName + ': Trapped CaseID = ' + CAST(@CaseID AS VARCHAR(10)) ;
                    END
                COMMIT TRAN  
            END  
        ELSE 
            BEGIN
                SET @errCode = ERROR_NUMBER() ;  
                ROLLBACK TRAN  
                SET @CaseID = 0 ;  
            END 
	
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Trapped CaseID = ' + CAST(@CaseID AS VARCHAR(10)) ;
            END
	
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;
    END
GO



ALTER PROCEDURE [iCCG].[CaseUpdate]
    (
     @CaseID INT OUTPUT,
     @OriginalCaseNumber VARCHAR(255) = NULL,
     @PatientID INT = NULL,
     @CaseOwnerID INT = NULL,
     @ProviderID INT = NULL,
     @TypeID INT = NULL,
     @IdentifiedDate DATETIME = NULL,
     @OpenDate DATETIME = NULL,
     @CloseDate DATETIME = NULL,
     @ClosureReasonID INT = NULL,
     @StatusID INT = NULL,
     @Source VARCHAR(255) = NULL,
     @Active BIT = NULL,
     @CreatedDate DATETIME = NULL,
     @CreatedBy INT = NULL,
     @ModifiedDate DATETIME = NULL,
     @ModifiedBy INT = NULL,
     @Debug BIT = 0
    )
AS 
    BEGIN

        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
	
        SET @errCode = 0 ;
        SET @procName = 'CaseUpdate' ;
	
	
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Updating specified [Case] record...' ;
            END
	
	
        UPDATE  [Case]
        SET     [OriginalCaseNumber] = @OriginalCaseNumber,
                [PatientID] = @PatientID,
                [CaseOwnerID] = @CaseOwnerID,
                [ProviderID] = @ProviderID,
                [TypeID] = CASE WHEN (@TypeID = 0) THEN NULL
                                ELSE @TypeID
                           END,
                [IdentifiedDate] = @IdentifiedDate,
                [OpenDate] = @OpenDate,
                [CloseDate] = @CloseDate,
                [ClosureReasonID] = CASE WHEN (@ClosureReasonID = 0) THEN NULL
                                         ELSE @ClosureReasonID
                                    END,
                [StatusID] = CASE WHEN (@StatusID = 0) THEN NULL
                                  ELSE @StatusID
                             END,
                [Source] = @Source,
                [Active] = @Active,
                [CreatedDate] = @CreatedDate,
                [CreatedBy] = @CreatedBy,
                [ModifiedDate] = @ModifiedDate,
                [ModifiedBy] = @ModifiedBy
        WHERE   [CaseID] = @CaseID ;
	
        SELECT  @errCode = @errCode + @@ERROR ;
	
	
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;

    END

GO

GO    

ALTER PROCEDURE [iCCG].[InterventionInsert]
    (
     @InterventionID INT OUTPUT,
     @InterventionUniqueID INT = NULL,
     @TypeID INT = NULL,
     @InterventionText VARCHAR(1000) = NULL,
     @Ordinal INT = NULL,
     @Active BIT = NULL,
     @CreatedDate DATETIME = NULL,
     @CreatedBy INT = NULL,
     @ModifiedDate DATETIME = NULL,
     @ModifiedBy INT = NULL,
     @Debug BIT = 0
    )
AS 
    BEGIN

        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
	
        SET @errCode = 0 ;
        SET @procName = 'InterventionInsert' ;
	
	
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Inserting new [Intervention] record...' ;
            END
	
	
        INSERT  INTO [Intervention]
                ([InterventionUniqueID],
                 [TypeID],
                 [InterventionText],
                 [Ordinal],
                 [Active],
                 [CreatedDate],
                 [CreatedBy],
                 [ModifiedDate],
                 [ModifiedBy])
        VALUES  (@InterventionUniqueID,
                 CASE WHEN (@TypeID = 0) THEN NULL
                      ELSE @TypeID
                 END,
                 @InterventionText,
                 @Ordinal,
                 @Active,
                 @CreatedDate,
                 @CreatedBy,
                 @ModifiedDate,
                 @ModifiedBy) ;
	
        SELECT  @errCode = @errCode + @@ERROR ;
	
	
        SELECT  @InterventionID = SCOPE_IDENTITY() ;
	
	
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Trapped InterventionID = ' + CAST(@InterventionID AS VARCHAR(10)) ;
            END
	
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;

    END


GO 

ALTER PROCEDURE [iCCG].[InterventionUpdate]
    (
     @InterventionID INT OUTPUT,
     @InterventionUniqueID INT = NULL,
     @TypeID INT = NULL,
     @InterventionText VARCHAR(1000) = NULL,
     @Ordinal INT = NULL,
     @Active BIT = NULL,
     @CreatedDate DATETIME = NULL,
     @CreatedBy INT = NULL,
     @ModifiedDate DATETIME = NULL,
     @ModifiedBy INT = NULL,
     @Debug BIT = 0
    )
AS 
    BEGIN

        DECLARE @errCode INT ;
        DECLARE @procName VARCHAR(50) ;
	
        SET @errCode = 0 ;
        SET @procName = 'InterventionUpdate' ;
	
	
        IF @Debug = 1 
            BEGIN
                PRINT @procName + ': Updating specified [Intervention] record...' ;
            END
	
	
        UPDATE  [Intervention]
        SET     [InterventionUniqueID] = @InterventionUniqueID,
                [TypeID] = CASE WHEN (@TypeID = 0) THEN NULL
                                ELSE @TypeID
                           END,
                [InterventionText] = @InterventionText,
                [Ordinal] = @Ordinal,
                [Active] = @Active,
                [CreatedDate] = @CreatedDate,
                [CreatedBy] = @CreatedBy,
                [ModifiedDate] = @ModifiedDate,
                [ModifiedBy] = @ModifiedBy
        WHERE   [InterventionID] = @InterventionID ;
	
        SELECT  @errCode = @errCode + @@ERROR ;
	
	
        IF @errCode <> 0 
            RETURN -1 ;
        ELSE 
            RETURN 0 ;

    END




