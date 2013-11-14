DECLARE @date_from DATETIME;
DECLARE @date_to DATETIME;

SET @date_from = '1925-01-01';
SET @date_to = GETDATE();

DECLARE @UserSessionID INT;
DECLARE @patientID INT;
DECLARE @patientIDSource VARCHAR(100);
DECLARE @salutationTypeID INT;
DECLARE @lastName VARCHAR(100);
DECLARE @firstName VARCHAR(50);
DECLARE @middleInitial VARCHAR(5);
DECLARE @relationshipID INT;
DECLARE @otherID VARCHAR(100);
DECLARE @mRN VARCHAR(50);
DECLARE @genderID INT;
DECLARE @sSN VARCHAR(50);
DECLARE @dateOfBirth DATETIME;
DECLARE @address1 VARCHAR(255);
DECLARE @address2 VARCHAR(255);
DECLARE @city VARCHAR(50);
DECLARE @cCGFlag BIT;
DECLARE @isVIP BIT;
DECLARE @homePhone VARCHAR(50);
DECLARE @businessPhone VARCHAR(50);
DECLARE @faxNumber VARCHAR(50);
DECLARE @cellPhoneNumber VARCHAR(50);
DECLARE @email VARCHAR(100);
DECLARE @active BIT;
DECLARE @stateID INT;
DECLARE @countryID INT;
DECLARE @postalCode VARCHAR(25);
DECLARE @reviewerID INT;
DECLARE @reviewerName VARCHAR(255);
DECLARE @creatorID INT;
DECLARE @creatorName VARCHAR(255);
DECLARE @policyStartDate DATETIME;
DECLARE @policyEndDate DATETIME;
DECLARE @donotContactFlag BIT;
DECLARE @BenefitPlanName VARCHAR(255);
DECLARE @BenefitProduct VARCHAR(255);
DECLARE @BenefitGroupID VARCHAR(255);
DECLARE @BenefitMemberID VARCHAR(255);
DECLARE @BenefitEligibilityDate DATETIME;
DECLARE @BenefitDisenrollmentDate DATETIME;
DECLARE @Debug BIT;
DECLARE @RC INT;
DECLARE @I INT;

SET @I = 0;

WHILE (@I <= 10)
BEGIN
	SELECT @salutationTypeID = 1;

	SELECT @lastName = (
			SELECT TOP 1 [LastName]
			FROM [PERF-CTRL].[TestData].[dbo].[PatientNames]
			ORDER BY NEWID()
			);

	SELECT @firstName = (
			SELECT TOP 1 [FirstName]
			FROM [PERF-CTRL].[TestData].[dbo].[PatientNames]
			ORDER BY NEWID()
			);

	SELECT @middleInitial = (
			SELECT TOP 1 [MiddleInitial]
			FROM [PERF-CTRL].[TestData].[dbo].[PatientNames]
			ORDER BY NEWID()
			);

	SELECT @relationshipID = NULL;

	SELECT @otherID = NULL;

	SELECT @mRN = NULL;

	SELECT @genderID = FLOOR(1.9999999999 * RAND());

	SELECT @sSN = LEFT(CONVERT(VARCHAR, CAST(RAND() * 1000 AS INT)) + '000', 3) + '-' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 100 AS INT)) + '00', 2) + '-' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 10000 AS INT)) + '0000', 4);

	SELECT @dateOfBirth = (@date_from + (ABS(CAST(CAST(NEWID() AS BINARY (8)) AS INT)) % CAST((GETDATE() - @date_from) AS INT)));

	SELECT @address1 = '901 5th Ave';

	SELECT @address2 = 'Suite 2000';

	SELECT @city = 'Seattle';

	SELECT @cCGFlag = FLOOR(1.9999999999 * RAND());

	SELECT @isVIP = FLOOR(1.9999999999 * RAND());

	SELECT @homePhone = '(' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 1000 AS INT)) + '000', 3) + ') ' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 1000 AS INT)) + '000', 3) + '-' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 10000 AS INT)) + '0000', 4);

	SELECT @businessPhone = '(' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 1000 AS INT)) + '000', 3) + ') ' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 1000 AS INT)) + '000', 3) + '-' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 10000 AS INT)) + '0000', 4);

	SELECT @faxNumber = '(' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 1000 AS INT)) + '000', 3) + ') ' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 1000 AS INT)) + '000', 3) + '-' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 10000 AS INT)) + '0000', 4);

	SELECT @cellPhoneNumber = '(' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 1000 AS INT)) + '000', 3) + ') ' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 1000 AS INT)) + '000', 3) + '-' + LEFT(CONVERT(VARCHAR, CAST(RAND() * 10000 AS INT)) + '0000', 4);

	SELECT @email = @firstName + '@' + @lastName + '.com';

	SELECT @active = 1;

	SELECT @stateID = (
			SELECT TOP 1 [ID]
			FROM RefState
			ORDER BY NEWID()
			);

	SELECT @countryID = (
			SELECT TOP 1 [ID]
			FROM RefCountry
			ORDER BY NEWID()
			);

	SELECT @postalCode = LEFT(CONVERT(VARCHAR, CAST(RAND() * 100000 AS INT)) + '00000', 5)

	SELECT @reviewerID = 1;

	SELECT @reviewerName = 'admin';

	SELECT @creatorID = 1;

	SELECT @creatorName = 'Bud Gack';

	SELECT @policyStartDate = NULL;

	SELECT @policyEndDate = NULL;

	SELECT @donotContactFlag = FLOOR(1.9999999999 * RAND());

	SELECT @BenefitPlanName = NULL;

	SELECT @BenefitProduct = NULL;

	SELECT @BenefitGroupID = NULL;

	SELECT @BenefitMemberID = NULL;

	SELECT @BenefitEligibilityDate = NULL;

	SELECT @BenefitDisenrollmentDate = NULL;

	SELECT @Debug = 1;

	EXECUTE @RC = [dbo].[Cgasp_insertpatient] @UserSessionID
		,@patientID OUTPUT
		,@patientIDSource OUTPUT
		,@salutationTypeID
		,@lastName
		,@firstName
		,@middleInitial
		,@relationshipID
		,@otherID
		,@mRN
		,@genderID
		,@sSN
		,@dateOfBirth
		,@address1
		,@address2
		,@city
		,@cCGFlag
		,@isVIP
		,@homePhone
		,@businessPhone
		,@faxNumber
		,@cellPhoneNumber
		,@email
		,@active
		,@stateID
		,@countryID
		,@postalCode
		,@reviewerID
		,@reviewerName
		,@creatorID
		,@creatorName
		,@policyStartDate
		,@policyEndDate
		,@donotContactFlag
		,@BenefitPlanName
		,@BenefitProduct
		,@BenefitGroupID
		,@BenefitMemberID
		,@BenefitEligibilityDate
		,@BenefitDisenrollmentDate
		,@Debug;

	PRINT 'Patient inserted'

	DECLARE @episodeID INT;
	DECLARE @episodeIDSource VARCHAR(100);
	DECLARE @requestedAdmitDate DATETIME;

	SELECT @requestedAdmitDate = GETUTCDATE();

	EXECUTE @RC = [dbo].[cgasp_InsertEpisode] @episodeID OUTPUT
		,@episodeIDSource OUTPUT
		,@patientID
		,@patientIDSource
		,@lastName
		,@firstName
		,@middleInitial
		,NULL
		,''
		,NULL
		,''
		,NULL
		,''
		,NULL
		,''
		,1
		,'Fenske, Brian'
		,NULL
		,@requestedAdmitDate
		,1
		,1
		,1
		,'Fenske, Brian'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,''
		,''
		,''
		,''
		,''
		,1;

	PRINT 'Episode inserted'

	EXECUTE [dbo].[cgasp_InsertWorkQueue] 1
		,@episodeID
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,1
		,1
		,''
		,1
		,1;

	PRINT 'Work queue inserted'
	PRINT '---------------------------------------------------------------------------------'

	--DECLARE @CaseID INT
	--DECLARE @CaseIDSource VARCHAR(100)
	--DECLARE @CaseOwnerID INT
	--DECLARE @CaseAssigneeID INT
	--DECLARE @TypeID INT
	--DECLARE @ReferralSourceID INT
	--DECLARE @IdentificationSourceID INT
	--DECLARE @IdentifiedDate DATETIME
	--DECLARE @OpenDate DATETIME
	--DECLARE @CloseDate DATETIME
	--DECLARE @ClosureReasonID INT
	--DECLARE @StatusID INT
	--DECLARE @Source VARCHAR(255)
	--DECLARE @InsertBy INT
	--DECLARE @UpdateBy INT
	--DECLARE @StratificationLevel INT
	--DECLARE @ProviderID INT
	--      -- TODO: Set parameter values here.
	--SELECT
	--    @CaseIDSource = '',
	--    @CaseOwnerID = 1,
	--    @CaseAssigneeID = 1,
	--    @ProviderID = 0,
	--    @TypeID = 1,
	--    @ReferralSourceID = 7,
	--    @IdentificationSourceID = 12,
	--    @IdentifiedDate = GETUTCDATE(),
	--    @OpenDate = GETUTCDATE(),
	--    @CloseDate = NULL,
	--    @ClosureReasonID = NULL,
	--    @StatusID = 3,
	--    @active = 1,
	--    @StratificationLevel = 2
	--EXECUTE @RC = [iCCG].[CaseInsert] 
	--    @CaseID OUTPUT,
	--    @CaseIDSource,
	--    @PatientID,
	--    @CaseOwnerID,
	--    @CaseAssigneeID,
	--    NULL,
	--    @TypeID,
	--    @ReferralSourceID,
	--    @IdentificationSourceID,
	--    @IdentifiedDate,
	--    @OpenDate,
	--    @CloseDate,
	--    @ClosureReasonID,
	--    @StatusID,
	--    @Source,
	--    @Active,
	--    1,
	--    1,
	--    @StratificationLevel,
	--    1
	--PRINT 'Case ' + CAST(@CaseID AS VARCHAR) + ' for ' + @firstName + ' ' + @lastName + ' inserted.'
	--DECLARE @CaseProgramID INT
	--DECLARE @ProgramID INT
	--DECLARE @Ordinal INT
	--      -- TODO: Set parameter values here.
	--SELECT
	--    @ProgramID = 10    
	--EXECUTE @RC = [iCCG].[CaseProgramInsert] 
	--    @CaseProgramID OUTPUT,
	--    @CaseID,
	--    @ProgramID,
	--    1,
	--    1,
	--    1
	--      GO
	--PRINT 'CaseProgram inserted'
	SET @I = @I + 1;
END
