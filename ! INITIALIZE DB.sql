--USE CareWebQIDb

UPDATE
    [dbo].AppUser
SET 
    [Password] = 'admin',
    [FirstName] = 'Brian',
    [LastName] = 'Fenske'
WHERE
    UserID = 1
GO

PRINT 'admin user password updated to empty string.'

UPDATE
    ApplicationParameter
SET 
    ApplicationValue = 'Milliman Care Guidelines'
WHERE
    ApplicationKey = 'ClientName' 
GO

UPDATE
    ApplicationParameter
SET 
    ApplicationValue = '5'
WHERE
    ApplicationKey = 'PageSize' 
GO

PRINT 'ApplicationKey updated for ClientName to Milliman Care Guidelines.'

INSERT  INTO [dbo].[LicenseKey]
        ([LicenseKey],
         [Active],
         [InsertUserID],
         [InsertUserName],
         [InsertDate],
         [UpdateUserID],
         [UpdateUserName],
         [UpdateDate])
VALUES
        ('K171-PC2D-7ADW-X98E-SP20-BW04-RL5G-SX9U-477FP2EFC-12D4',
         1,
         1,
         'admin',
         GETDATE(),
         1,
         'admin',
         GETDATE())
GO

PRINT 'LicenseKey inserted.'

INSERT  INTO [dbo].[MasterLicense]
        ([LicenseKeyID],
         [ApplicationKeyID],
         [InsertDate],
         [InsertedByID])
VALUES
        (1,
         30,
         GETDATE(),
         1)
GO

PRINT 'MasterLicense inserted and associated with LicenseKey.'

-- Insert the ContentEdition if it isn't present.
IF NOT EXISTS ( SELECT
                    Name
                FROM
                    ContentEdition
                WHERE
                    Name = '16th Edition' ) 
    BEGIN
        INSERT  INTO ContentEdition
                (Name,
                 DisplayName,
                 Active,
                 ReleaseOrder)
        VALUES
                ('16th Edition',
                 'Milliman Care Guidelines 16th Edition',
                 1,
                 7)
    END
DECLARE @ContentEditionID INT
SELECT
    @ContentEditionID = (SELECT
                            ContentEditionID
                         FROM
                            ContentEdition
                         WHERE
                            Name = '16th Edition')


-- Insert the ContentVersion if it isn't present. -- CONTENT_16.0.5383.001037
IF NOT EXISTS ( SELECT
                    VersionNumber
                FROM
                    ContentVersion
                WHERE
                    VersionNumber = '16.0' ) 
    BEGIN
        INSERT  INTO ContentVersion
                (Name,
                 DisplayName,
                 Active,
                 VersionNumber,
                 ContentVersionPath,
                 SortOrder,
                 ReleaseOrder,
                 ContentEditionID)
        VALUES
                ('16th Edition',
                 'Milliman Care Guidelines 16th Edition',
                 1,
                 '16.0',
                 'C:\All\Content\16.0.5689.001070\Content\Milliman\16.0',
                 1,
                 1,
                 @ContentEditionID)
    END
GO

DECLARE @userId1 INT
EXEC [dbo].[cgasp_InsertUserAndAccessControlGroup] 
    @userId1 OUTPUT,
    @loginName = 'admin2',
    @password = 'admin2@P@ssw0rd',
    @lastName = 'Gack',
    @firstName = 'Bud',
    @email = '',
    @changePassword = 0,
    @unsuccessfulAttempts = 0,
    @active = 1,
    @accessControlGroupIDs = '1,5,200', --Comma delimited list of accesscontrolgroups
    @reviewerID = 1,
    @reviewerName = 'Fenske, Brian',
    @Debug = 1
GO

DECLARE @curUserId INT ;
SELECT
    @curUserId = IDENT_CURRENT('dbo.AppUser') ;
DECLARE @UserProfileRoleID1 INT ;
EXECUTE [Platform].[UserProfileRoleInsert] 
    @UserProfileRoleID1 OUTPUT,
    @UserID = @curUserId,
    @RefProfileRoleID = 6,
    @InsertUserID = 1,
    @Debug = 1
GO

DECLARE @curUserId INT ;
SELECT
    @curUserId = IDENT_CURRENT('dbo.AppUser') ;
DECLARE @UserProfileRoleID1 INT ;
EXECUTE [Platform].[UserProfileRoleInsert] 
    @UserProfileRoleID1 OUTPUT,
    @UserID = @curUserId,
    @RefProfileRoleID = 11,
    @InsertUserID = 1,
    @Debug = 1
GO

DECLARE @curUserId INT ;
SELECT
    @curUserId = IDENT_CURRENT('dbo.AppUser') ;
DECLARE @UserProfileRoleID1 INT ;
EXECUTE [Platform].[UserProfileRoleInsert] 
    @UserProfileRoleID1 OUTPUT,
    @UserID = @curUserId,
    @RefProfileRoleID = 300,
    @InsertUserID = 1,
    @Debug = 1
GO



DECLARE @curUserId INT ;
SELECT
    @curUserId = IDENT_CURRENT('dbo.AppUser') ;

EXECUTE [dbo].[cgasp_InsertUserRole] 
    @RoleID = 1,
    @UserID = @curUserId,
    @Debug = 1
  
GO

DECLARE @curUserId INT ;
SELECT
    @curUserId = IDENT_CURRENT('dbo.AppUser') ;
UPDATE
    [dbo].AppUser
SET 
    [Password] = 'admin2'
WHERE
    UserID = @curUserId
GO


--PRINT 'admin2 inserted ID='+cast(@userId1 as varchar(10))
PRINT 'admin2 inserted'
GO

DECLARE @userId2 INT
EXEC [dbo].[cgasp_InsertUserAndAccessControlGroup] 
    @userId2 OUTPUT,
    @loginName = 'admin3',
    @password = 'admin3@P@ssw0rd',
    @lastName = 'Gack',
    @firstName = 'Fern',
    @email = '',
    @changePassword = 0,
    @unsuccessfulAttempts = 0,
    @active = 1,
    @accessControlGroupIDs = '1,5,200', --Comma delimited list of accesscontrolgroups
    @reviewerID = 1,
    @reviewerName = 'Fenske, Brian',
    @Debug = 1

--PRINT 'admin3 inserted ID='+cast(@userId2 as varchar(10))

DECLARE @curUserId INT ;
SELECT
    @curUserId = IDENT_CURRENT('dbo.AppUser') ;
DECLARE @UserProfileRoleID1 INT ;
EXECUTE [Platform].[UserProfileRoleInsert] 
    @UserProfileRoleID1 OUTPUT,
    @UserID = @curUserId,
    @RefProfileRoleID = 6,
    @InsertUserID = 1,
    @Debug = 1
GO

DECLARE @curUserId INT ;
SELECT
    @curUserId = IDENT_CURRENT('dbo.AppUser') ;
DECLARE @UserProfileRoleID1 INT ;
EXECUTE [Platform].[UserProfileRoleInsert] 
    @UserProfileRoleID1 OUTPUT,
    @UserID = @curUserId,
    @RefProfileRoleID = 11,
    @InsertUserID = 1,
    @Debug = 1
GO

DECLARE @curUserId INT ;
SELECT
    @curUserId = IDENT_CURRENT('dbo.AppUser') ;
DECLARE @UserProfileRoleID1 INT ;
EXECUTE [Platform].[UserProfileRoleInsert] 
    @UserProfileRoleID1 OUTPUT,
    @UserID = @curUserId,
    @RefProfileRoleID = 300,
    @InsertUserID = 1,
    @Debug = 1
GO

DECLARE @curUserId INT ;
SELECT
    @curUserId = IDENT_CURRENT('dbo.AppUser') ;
EXECUTE [dbo].[cgasp_InsertUserRole] 
    @RoleID = 1,
    @UserID = @curUserId,
    @Debug = 1
  
GO

DECLARE @curUserId INT ;
SELECT
    @curUserId = IDENT_CURRENT('dbo.AppUser') ;
UPDATE
    [dbo].AppUser
SET 
    [Password] = 'admin3'
WHERE
    UserID = @curUserId
GO

PRINT 'admin3 inserted'
GO

DECLARE @RC INT
DECLARE @providerID INT
DECLARE @providerIDSource VARCHAR(100)
EXECUTE @RC = [dbo].[cgasp_InsertProvider] 
    0,
    @providerID OUTPUT,
    @providerIDSource OUTPUT,
    'Getz',
    'Stan',
    '',
    1,
    1,
    '',
    NULL,
    NULL,
    NULL,
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    NULL,
    1,
    NULL,
    7,
    0
PRINT 'Provider Stan Getz inserted.'
GO

DECLARE @fRC INT
DECLARE @facilityID INT
DECLARE @facilityIDSource VARCHAR(100)
EXECUTE @fRC = [dbo].[cgasp_InsertFacility] 
    0,
    @facilityID OUTPUT,
    @facilityIDSource OUTPUT,
    3,
    'First Hospital',
    '',
    '',
    '',
    1,
    NULL,
    '',
    '',
    '',
    '',
    '',
    '',
    NULL,
    1
PRINT 'Facility First Hospital inserted.'
GO

-- let's work on patient episode and case insertion

DECLARE @UserSessionID INT
DECLARE @patientID INT
DECLARE @patientIDSource VARCHAR(100)
DECLARE @salutationTypeID INT
DECLARE @lastName VARCHAR(100)
DECLARE @firstName VARCHAR(50)
DECLARE @middleInitial VARCHAR(5)
DECLARE @relationshipID INT
DECLARE @otherID VARCHAR(100)
DECLARE @mRN VARCHAR(50)
DECLARE @genderID INT
DECLARE @sSN VARCHAR(50)
DECLARE @dateOfBirth DATETIME
DECLARE @address1 VARCHAR(255)
DECLARE @address2 VARCHAR(255)
DECLARE @city VARCHAR(50)
DECLARE @cCGFlag BIT
DECLARE @isVIP BIT
DECLARE @homePhone VARCHAR(50)
DECLARE @businessPhone VARCHAR(50)
DECLARE @faxNumber VARCHAR(50)
DECLARE @cellPhoneNumber VARCHAR(50)
DECLARE @email VARCHAR(100)
DECLARE @active BIT
DECLARE @stateID INT
DECLARE @countryID INT
DECLARE @postalCode VARCHAR(25)
DECLARE @reviewerID INT
DECLARE @reviewerName VARCHAR(255)
DECLARE @creatorID INT
DECLARE @creatorName VARCHAR(255)
DECLARE @policyStartDate DATETIME
DECLARE @policyEndDate DATETIME
DECLARE @donotContactFlag BIT
DECLARE @BenefitPlanName VARCHAR(255)
DECLARE @BenefitProduct VARCHAR(255)
DECLARE @BenefitGroupID VARCHAR(255)
DECLARE @BenefitMemberID VARCHAR(255)
DECLARE @BenefitEligibilityDate DATETIME
DECLARE @BenefitDisenrollmentDate DATETIME
DECLARE @Debug BIT
DECLARE @RC INT

SELECT
    @salutationTypeID = 1,
    @lastName = 'Evans',
    @firstName = 'Bill',
    @middleInitial = '',
    @relationshipID = NULL,
    @otherID = NULL,
    @mRN = NULL,
    @genderID = 1,
    @sSN = '111111111',
    @dateOfBirth = '10/12/1920',
    @address1 = '1111 1st Ave',
    @address2 = '',
    @city = 'Seattle',
    @cCGFlag = 0,
    @isVIP = 0,
    @homePhone = '(111)111-2222',
    @businessPhone = '',
    @faxNumber = '',
    @cellPhoneNumber = '(222)222-2345',
    @email = 'billevans@jazz.com',
    @active = 1,
    @stateID = 51,
    @countryID = 233,
    @postalCode = '98166',
    @reviewerID = 1,
    @reviewerName = 'admin',
    @creatorID = 1,
    @creatorName = 'Brian Fenske',
    @policyStartDate = NULL,
    @policyEndDate = NULL,
    @donotContactFlag = 1,
    @BenefitPlanName = NULL,
    @BenefitProduct = NULL,
    @BenefitGroupID = NULL,
    @BenefitMemberID = NULL,
    @BenefitEligibilityDate = NULL,
    @BenefitDisenrollmentDate = NULL,
    @Debug = 1

EXECUTE @RC = [dbo].[Cgasp_insertpatient] 
    @UserSessionID,
    @patientID OUTPUT,
    @patientIDSource OUTPUT,
    @salutationTypeID,
    @lastName,
    @firstName,
    @middleInitial,
    @relationshipID,
    @otherID,
    @mRN,
    @genderID,
    @sSN,
    @dateOfBirth,
    @address1,
    @address2,
    @city,
    @cCGFlag,
    @isVIP,
    @homePhone,
    @businessPhone,
    @faxNumber,
    @cellPhoneNumber,
    @email,
    @active,
    @stateID,
    @countryID,
    @postalCode,
    @reviewerID,
    @reviewerName,
    @creatorID,
    @creatorName,
    @policyStartDate,
    @policyEndDate,
    @donotContactFlag,
    @BenefitPlanName,
    @BenefitProduct,
    @BenefitGroupID,
    @BenefitMemberID,
    @BenefitEligibilityDate,
    @BenefitDisenrollmentDate,
    @Debug
      
PRINT 'Patient ' + @firstName + ' ' + @lastName + ' inserted.'     

DECLARE @episodeID INT
DECLARE @episodeIDSource VARCHAR(100)
DECLARE @requestedAdmitDate DATETIME
SELECT
    @requestedAdmitDate = GETUTCDATE() ;
EXECUTE @RC = [dbo].[cgasp_InsertEpisode] 
    @episodeID OUTPUT,
    @episodeIDSource OUTPUT,
    @patientID,
    @patientIDSource,
    @lastName,
    @firstName,
    @middleInitial,
    NULL,
    '',
    NULL,
    '',
    NULL,
    '',
    NULL,
    '',
    1,
    'Fenske, Brian',
    NULL,
    @requestedAdmitDate,
    1,
    1,
    1,
    'Fenske, Brian',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '',
    '',
    '',
    '',
    '',
    1

EXECUTE [dbo].[cgasp_InsertWorkQueue] 
    1,
    @episodeID,
    1,
    NULL,
    NULL,
    NULL,
    NULL,
    1,
    1,
    '',
    1,
    1

PRINT 'Episode ' + @episodeIDSource + ' for ' + @firstName + ' ' + @lastName + ' inserted.'

DECLARE @CaseID INT
DECLARE @CaseIDSource VARCHAR(100)
DECLARE @CaseOwnerID INT
DECLARE @CaseAssigneeID INT
DECLARE @TypeID INT
DECLARE @ReferralSourceID INT
DECLARE @IdentificationSourceID INT
DECLARE @IdentifiedDate DATETIME
DECLARE @OpenDate DATETIME
DECLARE @CloseDate DATETIME
DECLARE @ClosureReasonID INT
DECLARE @StatusID INT
DECLARE @Source VARCHAR(255)
DECLARE @InsertBy INT
DECLARE @UpdateBy INT
DECLARE @StratificationLevel INT
DECLARE @ProviderID INT

      -- TODO: Set parameter values here.
SELECT
    @CaseIDSource = '',
    @CaseOwnerID = 1,
    @CaseAssigneeID = 1,
    @ProviderID = 0,
    @TypeID = 1,
    @ReferralSourceID = 7,
    @IdentificationSourceID = 12,
    @IdentifiedDate = GETUTCDATE(),
    @OpenDate = GETUTCDATE(),
    @CloseDate = NULL,
    @ClosureReasonID = NULL,
    @StatusID = 3,
    @active = 1,
    @StratificationLevel = 2

EXECUTE @RC = [iCCG].[CaseInsert] 
    @CaseID OUTPUT,
    @CaseIDSource,
    @PatientID,
    @CaseOwnerID,
    @CaseAssigneeID,
    NULL,
    @TypeID,
    @ReferralSourceID,
    @IdentificationSourceID,
    @IdentifiedDate,
    @OpenDate,
    @CloseDate,
    @ClosureReasonID,
    @StatusID,
    @Source,
    1,
    @StratificationLevel,
    1
      
PRINT 'Case ' + CAST(@CaseID AS VARCHAR) + ' for ' + @firstName + ' ' + @lastName + ' inserted.'
      
DECLARE @CaseProgramID INT
DECLARE @ProgramID INT
DECLARE @Ordinal INT

      -- TODO: Set parameter values here.
SELECT
    @ProgramID = 10    

EXECUTE @RC = [iCCG].[CaseProgramInsert] 
    @CaseProgramID OUTPUT,
    @CaseID,
    @ProgramID,
    1,
    1,
    1
GO
PRINT 'CaseProgram inserted'
-- end patient 1
                        
-- PATIENT 2
DECLARE @UserSessionID INT
DECLARE @patientID INT
DECLARE @patientIDSource VARCHAR(100)
DECLARE @salutationTypeID INT
DECLARE @lastName VARCHAR(100)
DECLARE @firstName VARCHAR(50)
DECLARE @middleInitial VARCHAR(5)
DECLARE @relationshipID INT
DECLARE @otherID VARCHAR(100)
DECLARE @mRN VARCHAR(50)
DECLARE @genderID INT
DECLARE @sSN VARCHAR(50)
DECLARE @dateOfBirth DATETIME
DECLARE @address1 VARCHAR(255)
DECLARE @address2 VARCHAR(255)
DECLARE @city VARCHAR(50)
DECLARE @cCGFlag BIT
DECLARE @isVIP BIT
DECLARE @homePhone VARCHAR(50)
DECLARE @businessPhone VARCHAR(50)
DECLARE @faxNumber VARCHAR(50)
DECLARE @cellPhoneNumber VARCHAR(50)
DECLARE @email VARCHAR(100)
DECLARE @active BIT
DECLARE @stateID INT
DECLARE @countryID INT
DECLARE @postalCode VARCHAR(25)
DECLARE @reviewerID INT
DECLARE @reviewerName VARCHAR(255)
DECLARE @creatorID INT
DECLARE @creatorName VARCHAR(255)
DECLARE @policyStartDate DATETIME
DECLARE @policyEndDate DATETIME
DECLARE @donotContactFlag BIT
DECLARE @BenefitPlanName VARCHAR(255)
DECLARE @BenefitProduct VARCHAR(255)
DECLARE @BenefitGroupID VARCHAR(255)
DECLARE @BenefitMemberID VARCHAR(255)
DECLARE @BenefitEligibilityDate DATETIME
DECLARE @BenefitDisenrollmentDate DATETIME
DECLARE @Debug BIT
DECLARE @RC INT

SELECT
    @salutationTypeID = 2,
    @lastName = 'Harris',
    @firstName = 'Gene',
    @middleInitial = '',
    @relationshipID = NULL,
    @otherID = NULL,
    @mRN = NULL,
    @genderID = 2,
    @sSN = '222222222',
    @dateOfBirth = '1/30/1930',
    @address1 = '1111 1st Ave',
    @address2 = '',
    @city = 'Seattle',
    @cCGFlag = 0,
    @isVIP = 0,
    @homePhone = '(111)111-2222',
    @businessPhone = '',
    @faxNumber = '',
    @cellPhoneNumber = '(333)222-2345',
    @email = 'geneharris@jazz.com',
    @active = 1,
    @stateID = 51,
    @countryID = 233,
    @postalCode = '98166',
    @reviewerID = 1,
    @reviewerName = 'admin',
    @creatorID = 1,
    @creatorName = 'Brian Fenske',
    @policyStartDate = NULL,
    @policyEndDate = NULL,
    @donotContactFlag = 1,
    @BenefitPlanName = NULL,
    @BenefitProduct = NULL,
    @BenefitGroupID = NULL,
    @BenefitMemberID = NULL,
    @BenefitEligibilityDate = NULL,
    @BenefitDisenrollmentDate = NULL,
    @Debug = 1
            
EXECUTE @RC = [dbo].[Cgasp_insertpatient] 
    @UserSessionID,
    @patientID OUTPUT,
    @patientIDSource OUTPUT,
    @salutationTypeID,
    @lastName,
    @firstName,
    @middleInitial,
    @relationshipID,
    @otherID,
    @mRN,
    @genderID,
    @sSN,
    @dateOfBirth,
    @address1,
    @address2,
    @city,
    @cCGFlag,
    @isVIP,
    @homePhone,
    @businessPhone,
    @faxNumber,
    @cellPhoneNumber,
    @email,
    @active,
    @stateID,
    @countryID,
    @postalCode,
    @reviewerID,
    @reviewerName,
    @creatorID,
    @creatorName,
    @policyStartDate,
    @policyEndDate,
    @donotContactFlag,
    @BenefitPlanName,
    @BenefitProduct,
    @BenefitGroupID,
    @BenefitMemberID,
    @BenefitEligibilityDate,
    @BenefitDisenrollmentDate,
    @Debug   
      
PRINT 'Patient ' + @firstName + ' ' + @lastName + ' inserted.'     

DECLARE @episodeID INT
DECLARE @episodeIDSource VARCHAR(100)
DECLARE @requestedAdmitDate DATETIME
SELECT
    @requestedAdmitDate = GETUTCDATE() ;
EXECUTE @RC = [dbo].[cgasp_InsertEpisode] 
    @episodeID OUTPUT,
    @episodeIDSource OUTPUT,
    @patientID,
    @patientIDSource,
    @lastName,
    @firstName,
    @middleInitial,
    NULL,
    '',
    NULL,
    '',
    NULL,
    '',
    NULL,
    '',
    1,
    'Fenske, Brian',
    NULL,
    @requestedAdmitDate,
    1,
    1,
    1,
    'Fenske, Brian',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '',
    '',
    '',
    '',
    '',
    1  
        
EXECUTE [dbo].[cgasp_InsertWorkQueue] 
    1,
    @episodeID,
    1,
    NULL,
    NULL,
    NULL,
    NULL,
    1,
    1,
    '',
    1,
    1    

PRINT 'Episode ' + @episodeIDSource + ' for ' + @firstName + ' ' + @lastName + ' inserted.'
      
DECLARE @CaseID INT
DECLARE @CaseIDSource VARCHAR(100)
DECLARE @CaseOwnerID INT
DECLARE @CaseAssigneeID INT
DECLARE @TypeID INT
DECLARE @ReferralSourceID INT
DECLARE @IdentificationSourceID INT
DECLARE @IdentifiedDate DATETIME
DECLARE @OpenDate DATETIME
DECLARE @CloseDate DATETIME
DECLARE @ClosureReasonID INT
DECLARE @StatusID INT
DECLARE @Source VARCHAR(255)
DECLARE @InsertBy INT
DECLARE @UpdateBy INT
DECLARE @StratificationLevel INT
DECLARE @ProviderID INT

      -- TODO: Set parameter values here.
SELECT
    @CaseIDSource = '',
    @CaseOwnerID = 1,
    @CaseAssigneeID = 1,
    @ProviderID = 0,
    @TypeID = 1,
    @ReferralSourceID = 7,
    @IdentificationSourceID = 12,
    @IdentifiedDate = GETUTCDATE(),
    @OpenDate = GETUTCDATE(),
    @CloseDate = NULL,
    @ClosureReasonID = NULL,
    @StatusID = 3,
    @active = 1,
    @StratificationLevel = 2

EXECUTE @RC = [iCCG].[CaseInsert] 
    @CaseID OUTPUT,
    @CaseIDSource,
    @PatientID,
    @CaseOwnerID,
    @CaseAssigneeID,
    NULL,
    @TypeID,
    @ReferralSourceID,
    @IdentificationSourceID,
    @IdentifiedDate,
    @OpenDate,
    @CloseDate,
    @ClosureReasonID,
    @StatusID,
    @Source,
    1,
    @StratificationLevel,
    1
      
PRINT 'Case ' + CAST(@CaseID AS VARCHAR) + ' for ' + @firstName + ' ' + @lastName + ' inserted.'
      
DECLARE @CaseProgramID INT
DECLARE @ProgramID INT
DECLARE @Ordinal INT

      -- TODO: Set parameter values here.
SELECT
    @ProgramID = 10    

EXECUTE @RC = [iCCG].[CaseProgramInsert] 
    @CaseProgramID OUTPUT,
    @CaseID,
    @ProgramID,
    1,
    1,
    1
      GO
PRINT 'CaseProgram inserted'
-- end patient 2        

-- patient 3
DECLARE @UserSessionID INT
DECLARE @patientID INT
DECLARE @patientIDSource VARCHAR(100)
DECLARE @salutationTypeID INT
DECLARE @lastName VARCHAR(100)
DECLARE @firstName VARCHAR(50)
DECLARE @middleInitial VARCHAR(5)
DECLARE @relationshipID INT
DECLARE @otherID VARCHAR(100)
DECLARE @mRN VARCHAR(50)
DECLARE @genderID INT
DECLARE @sSN VARCHAR(50)
DECLARE @dateOfBirth DATETIME
DECLARE @address1 VARCHAR(255)
DECLARE @address2 VARCHAR(255)
DECLARE @city VARCHAR(50)
DECLARE @cCGFlag BIT
DECLARE @isVIP BIT
DECLARE @homePhone VARCHAR(50)
DECLARE @businessPhone VARCHAR(50)
DECLARE @faxNumber VARCHAR(50)
DECLARE @cellPhoneNumber VARCHAR(50)
DECLARE @email VARCHAR(100)
DECLARE @active BIT
DECLARE @stateID INT
DECLARE @countryID INT
DECLARE @postalCode VARCHAR(25)
DECLARE @reviewerID INT
DECLARE @reviewerName VARCHAR(255)
DECLARE @creatorID INT
DECLARE @creatorName VARCHAR(255)
DECLARE @policyStartDate DATETIME
DECLARE @policyEndDate DATETIME
DECLARE @donotContactFlag BIT
DECLARE @BenefitPlanName VARCHAR(255)
DECLARE @BenefitProduct VARCHAR(255)
DECLARE @BenefitGroupID VARCHAR(255)
DECLARE @BenefitMemberID VARCHAR(255)
DECLARE @BenefitEligibilityDate DATETIME
DECLARE @BenefitDisenrollmentDate DATETIME
DECLARE @Debug BIT
DECLARE @RC INT

SELECT
    @salutationTypeID = 1,
    @lastName = 'Corea',
    @firstName = 'Chick',
    @middleInitial = '',
    @relationshipID = NULL,
    @otherID = NULL,
    @mRN = NULL,
    @genderID = 1,
    @sSN = '333333333',
    @dateOfBirth = '2/10/1935',
    @address1 = '9912 Grady Way',
    @address2 = '',
    @city = 'Renton',
    @cCGFlag = 0,
    @isVIP = 0,
    @homePhone = '(333)333-3333',
    @businessPhone = '',
    @faxNumber = '',
    @cellPhoneNumber = '(333)333-3334',
    @email = 'chickcorea@jazz.com',
    @active = 1,
    @stateID = 11,
    @countryID = 233,
    @postalCode = '98055',
    @reviewerID = 1,
    @reviewerName = 'admin',
    @creatorID = 1,
    @creatorName = 'Brian Fenske',
    @policyStartDate = NULL,
    @policyEndDate = NULL,
    @donotContactFlag = 1,
    @BenefitPlanName = NULL,
    @BenefitProduct = NULL,
    @BenefitGroupID = NULL,
    @BenefitMemberID = NULL,
    @BenefitEligibilityDate = NULL,
    @BenefitDisenrollmentDate = NULL,
    @Debug = 1
            
EXECUTE @RC = [dbo].[Cgasp_insertpatient] 
    @UserSessionID,
    @patientID OUTPUT,
    @patientIDSource OUTPUT,
    @salutationTypeID,
    @lastName,
    @firstName,
    @middleInitial,
    @relationshipID,
    @otherID,
    @mRN,
    @genderID,
    @sSN,
    @dateOfBirth,
    @address1,
    @address2,
    @city,
    @cCGFlag,
    @isVIP,
    @homePhone,
    @businessPhone,
    @faxNumber,
    @cellPhoneNumber,
    @email,
    @active,
    @stateID,
    @countryID,
    @postalCode,
    @reviewerID,
    @reviewerName,
    @creatorID,
    @creatorName,
    @policyStartDate,
    @policyEndDate,
    @donotContactFlag,
    @BenefitPlanName,
    @BenefitProduct,
    @BenefitGroupID,
    @BenefitMemberID,
    @BenefitEligibilityDate,
    @BenefitDisenrollmentDate,
    @Debug
      
      
PRINT 'Patient ' + @firstName + ' ' + @lastName + ' inserted.'     

DECLARE @episodeID INT
DECLARE @episodeIDSource VARCHAR(100)
DECLARE @requestedAdmitDate DATETIME
SELECT
    @requestedAdmitDate = GETUTCDATE() ;
EXECUTE @RC = [dbo].[cgasp_InsertEpisode] 
    @episodeID OUTPUT,
    @episodeIDSource OUTPUT,
    @patientID,
    @patientIDSource,
    @lastName,
    @firstName,
    @middleInitial,
    NULL,
    '',
    NULL,
    '',
    NULL,
    '',
    NULL,
    '',
    1,
    'Fenske, Brian',
    NULL,
    @requestedAdmitDate,
    1,
    1,
    1,
    'Fenske, Brian',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '',
    '',
    '',
    '',
    '',
    1

EXECUTE [dbo].[cgasp_InsertWorkQueue] 
    1,
    @episodeID,
    1,
    NULL,
    NULL,
    NULL,
    NULL,
    1,
    1,
    '',
    1,
    1

PRINT 'Episode ' + @episodeIDSource + ' for ' + @firstName + ' ' + @lastName + ' inserted.'
      
DECLARE @CaseID INT
DECLARE @CaseIDSource VARCHAR(100)
DECLARE @CaseOwnerID INT
DECLARE @CaseAssigneeID INT
DECLARE @TypeID INT
DECLARE @ReferralSourceID INT
DECLARE @IdentificationSourceID INT
DECLARE @IdentifiedDate DATETIME
DECLARE @OpenDate DATETIME
DECLARE @CloseDate DATETIME
DECLARE @ClosureReasonID INT
DECLARE @StatusID INT
DECLARE @Source VARCHAR(255)
DECLARE @InsertBy INT
DECLARE @UpdateBy INT
DECLARE @StratificationLevel INT
DECLARE @ProviderID INT

      -- TODO: Set parameter values here.
SELECT
    @CaseIDSource = '',
    @CaseOwnerID = 1,
    @CaseAssigneeID = 1,
    @ProviderID = 0,
    @TypeID = 1,
    @ReferralSourceID = 7,
    @IdentificationSourceID = 12,
    @IdentifiedDate = GETUTCDATE(),
    @OpenDate = GETUTCDATE(),
    @CloseDate = NULL,
    @ClosureReasonID = NULL,
    @StatusID = 3,
    @active = 1,
    @StratificationLevel = 2

EXECUTE @RC = [iCCG].[CaseInsert] 
    @CaseID OUTPUT,
    @CaseIDSource,
    @PatientID,
    @CaseOwnerID,
    @CaseAssigneeID,
    NULL,
    @TypeID,
    @ReferralSourceID,
    @IdentificationSourceID,
    @IdentifiedDate,
    @OpenDate,
    @CloseDate,
    @ClosureReasonID,
    @StatusID,
    @Source,
    1,
    @StratificationLevel,
    1
      
PRINT 'Case ' + CAST(@CaseID AS VARCHAR) + ' for ' + @firstName + ' ' + @lastName + ' inserted.'
      
DECLARE @CaseProgramID INT
DECLARE @ProgramID INT
DECLARE @Ordinal INT

      -- TODO: Set parameter values here.
SELECT
    @ProgramID = 10    

EXECUTE @RC = [iCCG].[CaseProgramInsert] 
    @CaseProgramID OUTPUT,
    @CaseID,
    @ProgramID,
    1,
    1,
    1
      GO
PRINT 'CaseProgram inserted'
-- end patient 3        
            
-- patient 4
DECLARE @UserSessionID INT
DECLARE @patientID INT
DECLARE @patientIDSource VARCHAR(100)
DECLARE @salutationTypeID INT
DECLARE @lastName VARCHAR(100)
DECLARE @firstName VARCHAR(50)
DECLARE @middleInitial VARCHAR(5)
DECLARE @relationshipID INT
DECLARE @otherID VARCHAR(100)
DECLARE @mRN VARCHAR(50)
DECLARE @genderID INT
DECLARE @sSN VARCHAR(50)
DECLARE @dateOfBirth DATETIME
DECLARE @address1 VARCHAR(255)
DECLARE @address2 VARCHAR(255)
DECLARE @city VARCHAR(50)
DECLARE @cCGFlag BIT
DECLARE @isVIP BIT
DECLARE @homePhone VARCHAR(50)
DECLARE @businessPhone VARCHAR(50)
DECLARE @faxNumber VARCHAR(50)
DECLARE @cellPhoneNumber VARCHAR(50)
DECLARE @email VARCHAR(100)
DECLARE @active BIT
DECLARE @stateID INT
DECLARE @countryID INT
DECLARE @postalCode VARCHAR(25)
DECLARE @reviewerID INT
DECLARE @reviewerName VARCHAR(255)
DECLARE @creatorID INT
DECLARE @creatorName VARCHAR(255)
DECLARE @policyStartDate DATETIME
DECLARE @policyEndDate DATETIME
DECLARE @donotContactFlag BIT
DECLARE @BenefitPlanName VARCHAR(255)
DECLARE @BenefitProduct VARCHAR(255)
DECLARE @BenefitGroupID VARCHAR(255)
DECLARE @BenefitMemberID VARCHAR(255)
DECLARE @BenefitEligibilityDate DATETIME
DECLARE @BenefitDisenrollmentDate DATETIME
DECLARE @Debug BIT
DECLARE @RC INT
            
SELECT
    @salutationTypeID = 1,
    @lastName = 'Brown',
    @firstName = 'Ray',
    @middleInitial = '',
    @relationshipID = NULL,
    @otherID = NULL,
    @mRN = NULL,
    @genderID = 1,
    @sSN = '444444444',
    @dateOfBirth = '3/25/1945',
    @address1 = '44 NE 4th Street',
    @address2 = '',
    @city = 'Chicago',
    @cCGFlag = 0,
    @isVIP = 0,
    @homePhone = '(444)444-4444',
    @businessPhone = '',
    @faxNumber = '',
    @cellPhoneNumber = '(444)444-4445',
    @email = 'raybrown@jazz.com',
    @active = 1,
    @stateID = 22,
    @countryID = 233,
    @postalCode = '98055',
    @reviewerID = 1,
    @reviewerName = 'admin',
    @creatorID = 1,
    @creatorName = 'Brian Fenske',
    @policyStartDate = NULL,
    @policyEndDate = NULL,
    @donotContactFlag = 1,
    @BenefitPlanName = NULL,
    @BenefitProduct = NULL,
    @BenefitGroupID = NULL,
    @BenefitMemberID = NULL,
    @BenefitEligibilityDate = NULL,
    @BenefitDisenrollmentDate = NULL,
    @Debug = 1
            
EXECUTE @RC = [dbo].[Cgasp_insertpatient] 
    @UserSessionID,
    @patientID OUTPUT,
    @patientIDSource OUTPUT,
    @salutationTypeID,
    @lastName,
    @firstName,
    @middleInitial,
    @relationshipID,
    @otherID,
    @mRN,
    @genderID,
    @sSN,
    @dateOfBirth,
    @address1,
    @address2,
    @city,
    @cCGFlag,
    @isVIP,
    @homePhone,
    @businessPhone,
    @faxNumber,
    @cellPhoneNumber,
    @email,
    @active,
    @stateID,
    @countryID,
    @postalCode,
    @reviewerID,
    @reviewerName,
    @creatorID,
    @creatorName,
    @policyStartDate,
    @policyEndDate,
    @donotContactFlag,
    @BenefitPlanName,
    @BenefitProduct,
    @BenefitGroupID,
    @BenefitMemberID,
    @BenefitEligibilityDate,
    @BenefitDisenrollmentDate,
    @Debug
      
      
PRINT 'Patient ' + @firstName + ' ' + @lastName + ' inserted.'     

DECLARE @episodeID INT
DECLARE @episodeIDSource VARCHAR(100)
DECLARE @requestedAdmitDate DATETIME
SELECT
    @requestedAdmitDate = GETUTCDATE() ;
EXECUTE @RC = [dbo].[cgasp_InsertEpisode] 
    @episodeID OUTPUT,
    @episodeIDSource OUTPUT,
    @patientID,
    @patientIDSource,
    @lastName,
    @firstName,
    @middleInitial,
    NULL,
    '',
    NULL,
    '',
    NULL,
    '',
    NULL,
    '',
    1,
    'Fenske, Brian',
    NULL,
    @requestedAdmitDate,
    1,
    1,
    1,
    'Fenske, Brian',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '',
    '',
    '',
    '',
    '',
    1

EXECUTE [dbo].[cgasp_InsertWorkQueue] 
    1,
    @episodeID,
    1,
    NULL,
    NULL,
    NULL,
    NULL,
    1,
    1,
    '',
    1,
    1

PRINT 'Episode ' + @episodeIDSource + ' for ' + @firstName + ' ' + @lastName + ' inserted.'
      
DECLARE @CaseID INT
DECLARE @CaseIDSource VARCHAR(100)
DECLARE @CaseOwnerID INT
DECLARE @CaseAssigneeID INT
DECLARE @TypeID INT
DECLARE @ReferralSourceID INT
DECLARE @IdentificationSourceID INT
DECLARE @IdentifiedDate DATETIME
DECLARE @OpenDate DATETIME
DECLARE @CloseDate DATETIME
DECLARE @ClosureReasonID INT
DECLARE @StatusID INT
DECLARE @Source VARCHAR(255)
DECLARE @InsertBy INT
DECLARE @UpdateBy INT
DECLARE @StratificationLevel INT
DECLARE @ProviderID INT

      -- TODO: Set parameter values here.
SELECT
    @CaseIDSource = '',
    @CaseOwnerID = 1,
    @CaseAssigneeID = 1,
    @ProviderID = 0,
    @TypeID = 1,
    @ReferralSourceID = 7,
    @IdentificationSourceID = 12,
    @IdentifiedDate = GETUTCDATE(),
    @OpenDate = GETUTCDATE(),
    @CloseDate = NULL,
    @ClosureReasonID = NULL,
    @StatusID = 3,
    @active = 1,
    @StratificationLevel = 2

EXECUTE @RC = [iCCG].[CaseInsert] 
    @CaseID OUTPUT,
    @CaseIDSource,
    @PatientID,
    @CaseOwnerID,
    @CaseAssigneeID,
    NULL,
    @TypeID,
    @ReferralSourceID,
    @IdentificationSourceID,
    @IdentifiedDate,
    @OpenDate,
    @CloseDate,
    @ClosureReasonID,
    @StatusID,
    @Source,
    1,
    @StratificationLevel,
    1
      
PRINT 'Case ' + CAST(@CaseID AS VARCHAR) + ' for ' + @firstName + ' ' + @lastName + ' inserted.'
      
DECLARE @CaseProgramID INT
DECLARE @ProgramID INT
DECLARE @Ordinal INT

      -- TODO: Set parameter values here.
SELECT
    @ProgramID = 10    

EXECUTE @RC = [iCCG].[CaseProgramInsert] 
    @CaseProgramID OUTPUT,
    @CaseID,
    @ProgramID,
    1,
    1,
    1
      GO
PRINT 'CaseProgram inserted'
-- end patient 4        
            
-- patient 5            
DECLARE @UserSessionID INT
DECLARE @patientID INT
DECLARE @patientIDSource VARCHAR(100)
DECLARE @salutationTypeID INT
DECLARE @lastName VARCHAR(100)
DECLARE @firstName VARCHAR(50)
DECLARE @middleInitial VARCHAR(5)
DECLARE @relationshipID INT
DECLARE @otherID VARCHAR(100)
DECLARE @mRN VARCHAR(50)
DECLARE @genderID INT
DECLARE @sSN VARCHAR(50)
DECLARE @dateOfBirth DATETIME
DECLARE @address1 VARCHAR(255)
DECLARE @address2 VARCHAR(255)
DECLARE @city VARCHAR(50)
DECLARE @cCGFlag BIT
DECLARE @isVIP BIT
DECLARE @homePhone VARCHAR(50)
DECLARE @businessPhone VARCHAR(50)
DECLARE @faxNumber VARCHAR(50)
DECLARE @cellPhoneNumber VARCHAR(50)
DECLARE @email VARCHAR(100)
DECLARE @active BIT
DECLARE @stateID INT
DECLARE @countryID INT
DECLARE @postalCode VARCHAR(25)
DECLARE @reviewerID INT
DECLARE @reviewerName VARCHAR(255)
DECLARE @creatorID INT
DECLARE @creatorName VARCHAR(255)
DECLARE @policyStartDate DATETIME
DECLARE @policyEndDate DATETIME
DECLARE @donotContactFlag BIT
DECLARE @BenefitPlanName VARCHAR(255)
DECLARE @BenefitProduct VARCHAR(255)
DECLARE @BenefitGroupID VARCHAR(255)
DECLARE @BenefitMemberID VARCHAR(255)
DECLARE @BenefitEligibilityDate DATETIME
DECLARE @BenefitDisenrollmentDate DATETIME
DECLARE @Debug BIT
DECLARE @RC INT

SELECT
    @salutationTypeID = 1,
    @lastName = 'Farkel',
    @firstName = 'Fanny',
    @middleInitial = '',
    @relationshipID = NULL,
    @otherID = NULL,
    @mRN = NULL,
    @genderID = 1,
    @sSN = '555555555',
    @dateOfBirth = '7/7/1950',
    @address1 = '5555 5th Ave NE',
    @address2 = '',
    @city = 'San Diego',
    @cCGFlag = 0,
    @isVIP = 0,
    @homePhone = '(444)444-4444',
    @businessPhone = '',
    @faxNumber = '',
    @cellPhoneNumber = '(444)444-4445',
    @email = 'fannyfarkel@jazz.com',
    @active = 1,
    @stateID = 33,
    @countryID = 233,
    @postalCode = '12345',
    @reviewerID = 1,
    @reviewerName = 'admin',
    @creatorID = 1,
    @creatorName = 'Brian Fenske',
    @policyStartDate = NULL,
    @policyEndDate = NULL,
    @donotContactFlag = 1,
    @BenefitPlanName = NULL,
    @BenefitProduct = NULL,
    @BenefitGroupID = NULL,
    @BenefitMemberID = NULL,
    @BenefitEligibilityDate = NULL,
    @BenefitDisenrollmentDate = NULL,
    @Debug = 1
      
EXECUTE @RC = [dbo].[Cgasp_insertpatient] 
    @UserSessionID,
    @patientID OUTPUT,
    @patientIDSource OUTPUT,
    @salutationTypeID,
    @lastName,
    @firstName,
    @middleInitial,
    @relationshipID,
    @otherID,
    @mRN,
    @genderID,
    @sSN,
    @dateOfBirth,
    @address1,
    @address2,
    @city,
    @cCGFlag,
    @isVIP,
    @homePhone,
    @businessPhone,
    @faxNumber,
    @cellPhoneNumber,
    @email,
    @active,
    @stateID,
    @countryID,
    @postalCode,
    @reviewerID,
    @reviewerName,
    @creatorID,
    @creatorName,
    @policyStartDate,
    @policyEndDate,
    @donotContactFlag,
    @BenefitPlanName,
    @BenefitProduct,
    @BenefitGroupID,
    @BenefitMemberID,
    @BenefitEligibilityDate,
    @BenefitDisenrollmentDate,
    @Debug
      
      
PRINT 'Patient ' + @firstName + ' ' + @lastName + ' inserted.'     

DECLARE @episodeID INT
DECLARE @episodeIDSource VARCHAR(100)
DECLARE @requestedAdmitDate DATETIME
SELECT
    @requestedAdmitDate = GETUTCDATE() ;
EXECUTE @RC = [dbo].[cgasp_InsertEpisode] 
    @episodeID OUTPUT,
    @episodeIDSource OUTPUT,
    @patientID,
    @patientIDSource,
    @lastName,
    @firstName,
    @middleInitial,
    NULL,
    '',
    NULL,
    '',
    NULL,
    '',
    NULL,
    '',
    1,
    'Fenske, Brian',
    NULL,
    @requestedAdmitDate,
    1,
    1,
    1,
    'Fenske, Brian',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '',
    '',
    '',
    '',
    '',
    1
      
EXECUTE [dbo].[cgasp_InsertWorkQueue] 
    1,
    @episodeID,
    1,
    NULL,
    NULL,
    NULL,
    NULL,
    1,
    1,
    '',
    1,
    1
      
PRINT 'Episode ' + @episodeIDSource + ' for ' + @firstName + ' ' + @lastName + ' inserted.'
      
DECLARE @CaseID INT
DECLARE @CaseIDSource VARCHAR(100)
DECLARE @CaseOwnerID INT
DECLARE @CaseAssigneeID INT
DECLARE @TypeID INT
DECLARE @ReferralSourceID INT
DECLARE @IdentificationSourceID INT
DECLARE @IdentifiedDate DATETIME
DECLARE @OpenDate DATETIME
DECLARE @CloseDate DATETIME
DECLARE @ClosureReasonID INT
DECLARE @StatusID INT
DECLARE @Source VARCHAR(255)
DECLARE @InsertBy INT
DECLARE @UpdateBy INT
DECLARE @StratificationLevel INT
DECLARE @ProviderID INT

      -- TODO: Set parameter values here.
SELECT
    @CaseIDSource = '',
    @CaseOwnerID = 1,
    @CaseAssigneeID = 1,
    @ProviderID = 0,
    @TypeID = 1,
    @ReferralSourceID = 7,
    @IdentificationSourceID = 12,
    @IdentifiedDate = GETUTCDATE(),
    @OpenDate = GETUTCDATE(),
    @CloseDate = NULL,
    @ClosureReasonID = NULL,
    @StatusID = 3,
    @active = 1,
    @StratificationLevel = 2

EXECUTE @RC = [iCCG].[CaseInsert] 
    @CaseID OUTPUT,
    @CaseIDSource,
    @PatientID,
    @CaseOwnerID,
    @CaseAssigneeID,
    NULL,
    @TypeID,
    @ReferralSourceID,
    @IdentificationSourceID,
    @IdentifiedDate,
    @OpenDate,
    @CloseDate,
    @ClosureReasonID,
    @StatusID,
    @Source,
    1,
    @StratificationLevel,
    1
      
PRINT 'Case ' + CAST(@CaseID AS VARCHAR) + ' for ' + @firstName + ' ' + @lastName + ' inserted.'
      
DECLARE @CaseProgramID INT
DECLARE @ProgramID INT
DECLARE @Ordinal INT

      -- TODO: Set parameter values here.
SELECT
    @ProgramID = 10    

EXECUTE @RC = [iCCG].[CaseProgramInsert] 
    @CaseProgramID OUTPUT,
    @CaseID,
    @ProgramID,
    1,
    1,
    1
      GO
PRINT 'CaseProgram inserted'


PRINT 'ALL DONE GO TO POPULATE TASKS NOW!!!' 

-- populate tasks
DECLARE @TotalTaskCounter INT
SET @TotalTaskCounter = 1201
DECLARE @TotalInnerTaskCounter INT
SET @TotalInnerTaskCounter = 1
DECLARE @TypePriorityCounter INT
SET @TypePriorityCounter = 1
DECLARE @StatusCounter INT
SET @StatusCounter = 1
DECLARE @OwnerID INT
SET @OwnerID = 1
DECLARE @AssigneeID INT
SET @AssigneeID = 1
DECLARE @PatientIDCounter INT
SET @PatientIDCounter = 1
DECLARE @DueDateCounter INT
SET @DueDateCounter = -3
DECLARE @Subject VARCHAR(255)
DECLARE @Notes VARCHAR(1000)
DECLARE
    @IsPatient BIT,
    @IsCase BIT,
    @IsEpisode BIT
--DECLARE @CaseID INT

-- start inserting tasks
WHILE @TotalInnerTaskCounter < @TotalTaskCounter 
    BEGIN

        IF @TypePriorityCounter % 5 = 0 
            SELECT
                @TypePriorityCounter = 1
        IF @StatusCounter % 7 = 0 
            SELECT
                @StatusCounter = 1     
        IF @DueDateCounter % 30 = 0 
            SELECT
                @DueDateCounter = 0

        IF @TotalInnerTaskCounter < 101--@TotalTaskCounter
            BEGIN
                SELECT
                    @OwnerID = 1
                SELECT
                    @AssigneeID = 1
                SELECT
                    @Subject = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' SUBJECT created by Brian and assigned to Brian'
                SELECT
                    @Notes = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' Notes created by Brian and assigned to Brian'
                SELECT
                    @IsPatient = 0,
                    @IsCase = 0,
                    @IsEpisode = 0
            END
        IF @TotalInnerTaskCounter > 100
            AND @TotalInnerTaskCounter < 201 
            BEGIN
                SELECT
                    @OwnerID = 1
                SELECT
                    @AssigneeID = 3
                SELECT
                    @Subject = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' SUBJECT created by Brian and assigned to Foo Pooh'
                SELECT
                    @Notes = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' Notes created by Brian and assigned to Foo Pooh'
                SELECT
                    @IsPatient = 1,
                    @IsCase = 0,
                    @IsEpisode = 0
            END
        IF @TotalInnerTaskCounter > 200
            AND @TotalInnerTaskCounter < 301 
            BEGIN
                SELECT
                    @OwnerID = 1
                SELECT
                    @AssigneeID = 4
                SELECT
                    @Subject = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' SUBJECT created by Jim Goodman and assigned to Eggfoo Young'
                SELECT
                    @Notes = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' Notes created by Jim Goodman and assigned to Eggfoo Young'    
                SELECT
                    @IsPatient = 0,
                    @IsCase = 1,
                    @IsEpisode = 0
            END
        IF @TotalInnerTaskCounter > 300
            AND @TotalInnerTaskCounter < 401 
            BEGIN
                SELECT
                    @OwnerID = 3
                SELECT
                    @AssigneeID = 1
                SELECT
                    @Subject = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' SUBJECT created by Foo Pooh and assigned to Brian Fenske'
                SELECT
                    @Notes = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' Notes created by Foo Pooh and assigned to Brian Fenske'    
                SELECT
                    @IsPatient = 0,
                    @IsCase = 0,
                    @IsEpisode = 1
            END
        IF @TotalInnerTaskCounter > 400
            AND @TotalInnerTaskCounter < 501 
            BEGIN
                SELECT
                    @OwnerID = 3
                SELECT
                    @AssigneeID = 3
                SELECT
                    @Subject = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' SUBJECT created by Foo Pooh and assigned to Foo Pooh'
                SELECT
                    @Notes = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' Notes created by Foo Pooh and assigned to Foo Pooh'     
                SELECT
                    @IsPatient = 1,
                    @IsCase = 0,
                    @IsEpisode = 0
            END
        IF @TotalInnerTaskCounter > 500
            AND @TotalInnerTaskCounter < 601 
            BEGIN
                SELECT
                    @OwnerID = 3
                SELECT
                    @AssigneeID = 4
                SELECT
                    @Subject = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' SUBJECT created by Foo Pooh and assigned to Eggfoo Young'
                SELECT
                    @Notes = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' Notes created by Foo Pooh and assigned to Eggfoo Young' 
                SELECT
                    @IsPatient = 0,
                    @IsCase = 1,
                    @IsEpisode = 0
            END
        IF @TotalInnerTaskCounter > 600
            AND @TotalInnerTaskCounter < 701 
            BEGIN
                SELECT
                    @OwnerID = 4
                SELECT
                    @AssigneeID = 1
                SELECT
                    @Subject = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' SUBJECT created by Eggfoo Young and assigned to Brian Fenske'
                SELECT
                    @Notes = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' Notes created by Eggfoo Young and assigned to Brian Fenske'      
                SELECT
                    @IsPatient = 0,
                    @IsCase = 0,
                    @IsEpisode = 1
            END
        IF @TotalInnerTaskCounter > 700
            AND @TotalInnerTaskCounter < 801 
            BEGIN
                SELECT
                    @OwnerID = 4
                SELECT
                    @AssigneeID = 3
                SELECT
                    @Subject = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' SUBJECT created by Eggfoo Young and assigned to Foo Pooh'
                SELECT
                    @Notes = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' Notes created by Eggfoo Young and assigned to Foo Pooh' 
                SELECT
                    @IsPatient = 1,
                    @IsCase = 0,
                    @IsEpisode = 0
            END
        IF @TotalInnerTaskCounter > 800
            AND @TotalInnerTaskCounter < 901 
            BEGIN
                SELECT
                    @OwnerID = 4
                SELECT
                    @AssigneeID = 4
                SELECT
                    @Subject = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' SUBJECT created by Eggfoo Young and assigned to Eggfoo Young'
                SELECT
                    @Notes = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' Notes created by Eggfoo Young and assigned to Eggfoo Young'   
                SELECT
                    @IsPatient = 0,
                    @IsCase = 1,
                    @IsEpisode = 0
            END
        IF @TotalInnerTaskCounter > 900
            AND @TotalInnerTaskCounter < 1001 
            BEGIN
                SELECT
                    @OwnerID = 1
                SELECT
                    @AssigneeID = 1
                SELECT
                    @Subject = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' SUBJECT created by Brian Fenske and assigned to Brian Fenske'
                SELECT
                    @Notes = 'Test Task ' + CAST(@TotalInnerTaskCounter AS VARCHAR) + ' Notes created by Brian Fenske and assigned to Brian Fenske'   
                SELECT
                    @IsPatient = 0,
                    @IsCase = 0,
                    @IsEpisode = 1
            END

        INSERT  INTO [Platform].[Task]
                ([TypeID],
                 [PriorityID],
                 [StatusID],
                 [OwnerID],
                 [AssigneeID],
                 [Subject],
                 [Notes],
                 [StartDate],
                 [DueDate],
                 [InsertBy],
                 [InsertDate],
                 [UpdateBy],
                 [UpdateDate],
                 [IsSystemTask],
                 [Active])
        VALUES
                (@TypePriorityCounter -- TypeID totalCount of 4
                 ,
                 @TypePriorityCounter -- PriorityID totalCount of 4
                 ,
                 @StatusCounter -- StatusID totalCount of 6
                 ,
                 @OwnerID -- OwnerID
                 ,
                 @AssigneeID -- AssigneeID
                 ,
                 @Subject -- Subject
                 ,
                 @Notes-- Notes
                 ,
                 GETUTCDATE() + @DueDateCounter,
                 GETUTCDATE() + @DueDateCounter,
                 @OwnerID -- InsertBy
                 ,
                 GETDATE() - @DueDateCounter,
                 NULL -- UpdateBy
                 ,
                 NULL -- UpdateDate
                 ,
                 0 -- IsSytemTask
                 ,
                 1 -- Active
                 )
    
        DECLARE @ID INT
        SELECT
            @ID = SCOPE_IDENTITY()
    
        INSERT  INTO [Platform].[TaskNote]
                ([TaskID],
                 [Text],
                 [NoteSubjectTypeID],
                 [Active],
                 [InsertBy],
                 [InsertDate])
        VALUES
                (@ID,
                 @Notes,
                 1,
                 1,
                 1,
                 GETUTCDATE())
    
        IF (@IsPatient = 1
            OR @IsCase = 1
            OR @IsEpisode = 1) 
            BEGIN
            
                DECLARE @TaskPatientID INT
                IF @TotalInnerTaskCounter % 5 = 0 
                    SET @TaskPatientID = 5
                ELSE 
                    IF @TotalInnerTaskCounter % 5 = 1 
                        SET @TaskPatientID = 4
                    ELSE 
                        IF @TotalInnerTaskCounter % 5 = 2 
                            SET @TaskPatientID = 3
                        ELSE 
                            IF @TotalInnerTaskCounter % 5 = 3 
                                SET @TaskPatientID = 2
                            ELSE 
                                IF @TotalInnerTaskCounter % 5 = 4 
                                    SET @TaskPatientID = 1
                  
                INSERT  INTO [dbo].[TaskPatient]
                        ([TaskID],
                         [PatientID],
                         [Active],
                         [InsertDate],
                         [InsertBy],
                         [UpdateDate],
                         [UpdateBy])
                VALUES
                        (@ID,
                         @TaskPatientID,
                         1,
                         GETUTCDATE() - @DueDateCounter,
                         @OwnerID,
                         NULL,
                         NULL)
            END
    --
        IF @IsCase = 1 
            BEGIN
    
                DECLARE @ReasonID INT
                DECLARE @ContactName VARCHAR(255)
                DECLARE @ContantDetails VARCHAR(512)
                DECLARE @CaseID INT
                SET @ReasonID = 1
                IF @TotalInnerTaskCounter % 5 = 0 
                    BEGIN
                        SET @CaseID = 1
                        SELECT
                            @ContactName = 'Steve Jobs for CaseID: ' + CAST(@CaseID AS VARCHAR)
                        SELECT
                            @ContantDetails = '(111)111-1111'
                    END
                ELSE 
                    IF @TotalInnerTaskCounter % 5 = 1 
                        BEGIN
                            SET @CaseID = 2
                            SELECT
                                @ContactName = 'Gene Harris for CaseID: ' + CAST(@CaseID AS VARCHAR)
                            SELECT
                                @ContantDetails = '(222)222-2222'
                        END
                    ELSE 
                        IF @TotalInnerTaskCounter % 5 = 2 
                            BEGIN
                                SET @CaseID = 3
                                SELECT
                                    @ContactName = 'Joey De Francesco for CaseID: ' + CAST(@CaseID AS VARCHAR)
                                SELECT
                                    @ContantDetails = '(333)333-3333'
                            END
                        ELSE 
                            IF @TotalInnerTaskCounter % 5 = 3 
                                BEGIN
                                    SET @CaseID = 4
                                    SELECT
                                        @ContactName = 'Bill Gates for CaseID: ' + CAST(@CaseID AS VARCHAR)
                                    SELECT
                                        @ContantDetails = '(444)444-4444'
                                END
                            ELSE 
                                IF @TotalInnerTaskCounter % 5 = 4 
                                    BEGIN
                                        SET @CaseID = 5
                                        SELECT
                                            @ContactName = 'Jeff Bezos for CaseID: ' + CAST(@CaseID AS VARCHAR)
                                        SELECT
                                            @ContantDetails = '(555)555-5555'
                                    END

                INSERT  INTO [iCCG].[TaskCase]
                        ([TaskID],
                         [CaseID],
                         [ReasonID],
                         [ContactName],
                         [ContactDetails],
                         [Active],
                         [InsertDate],
                         [InsertBy],
                         [UpdateDate],
                         [UpdateBy])
                VALUES
                        (@ID,
                         @CaseID,
                         @ReasonID,
                         @ContactName,
                         @ContantDetails,
                         1,
                         GETUTCDATE() - @DueDateCounter,
                         @OwnerID,
                         NULL,
                         NULL)       
            END
    
        ELSE 
            IF @IsEpisode = 1 
                BEGIN
    
                    DECLARE @EpisodeID INT
                    IF @TotalInnerTaskCounter % 5 = 0 
                        BEGIN
                            SET @EpisodeID = 1
                        END
                    ELSE 
                        IF @TotalInnerTaskCounter % 5 = 1 
                            BEGIN
                                SET @EpisodeID = 2
                            END
                        ELSE 
                            IF @TotalInnerTaskCounter % 5 = 2 
                                BEGIN
                                    SET @EpisodeID = 3
                                END
                            ELSE 
                                IF @TotalInnerTaskCounter % 5 = 3 
                                    BEGIN
                                        SET @EpisodeID = 4
                                    END
                                ELSE 
                                    IF @TotalInnerTaskCounter % 5 = 4 
                                        BEGIN
                                            SET @EpisodeID = 5
                                        END

                    INSERT  INTO [dbo].[TaskEpisode]
                            ([TaskID],
                             [EpisodeID],
                             [Active],
                             [InsertDate],
                             [InsertBy],
                             [UpdateDate],
                             [UpdateBy])
                    VALUES
                            (@ID,
                             @EpisodeID,
                             1,
                             GETUTCDATE() - @DueDateCounter,
                             1,
                             NULL,
                             NULL)
    
                END
    
           
        SELECT
            @TotalInnerTaskCounter = @TotalInnerTaskCounter + 1
        SELECT
            @TypePriorityCounter = @TypePriorityCounter + 1
        SELECT
            @StatusCounter = @StatusCounter + 1
        SELECT
            @DueDateCounter = @DueDateCounter + 1

    END          
GO

--COMMIT TRANSACTION

PRINT 'ALL DONE!!!'
GO

