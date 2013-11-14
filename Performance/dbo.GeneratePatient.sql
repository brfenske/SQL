IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.GeneratePatient')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE dbo.GeneratePatient;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.GeneratePatient
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Active BIT;
	DECLARE @Address1 VARCHAR(255);
	DECLARE @Address2 VARCHAR(255);
	DECLARE @BenefitDisenrollmentDate DATETIME;
	DECLARE @BenefitEligibilityDate DATETIME;
	DECLARE @BenefitGroupID VARCHAR(255);
	DECLARE @BenefitMemberID VARCHAR(255);
	DECLARE @BenefitPlanName VARCHAR(255);
	DECLARE @BenefitProduct VARCHAR(255);
	DECLARE @BusinessPhone VARCHAR(50);
	DECLARE @CCGFlag BIT;
	DECLARE @CellPhoneNumber VARCHAR(50);
	DECLARE @City VARCHAR(50);
	DECLARE @CountryID INT;
	DECLARE @CreatorID INT;
	DECLARE @CreatorName VARCHAR(255);
	DECLARE @DateOfBirth DATETIME;
	DECLARE @Debug BIT;
	DECLARE @DefaultGroupID INT;
	DECLARE @DoNotContactFlag BIT;
	DECLARE @Email VARCHAR(100);
	DECLARE @FaxNumber VARCHAR(50);
	DECLARE @FirstName VARCHAR(50);
	DECLARE @GenderID INT;
	DECLARE @HomePhone VARCHAR(50);
	DECLARE @I INT;
	DECLARE @InsertDate DATETIME;
	DECLARE @IsVIP BIT;
	DECLARE @LastName VARCHAR(100);
	DECLARE @LockResult INT;
	DECLARE @MiddleInitial VARCHAR(5);
	DECLARE @MRN VARCHAR(50);
	DECLARE @NextID INT;
	DECLARE @OtherID VARCHAR(100);
	DECLARE @PatientID INT;
	DECLARE @PatientIDSource VARCHAR(100);
	DECLARE @PolicyEndDate DATETIME;
	DECLARE @PolicyStartDate DATETIME;
	DECLARE @PostalCode VARCHAR(25);
	DECLARE @RecordCount INT;
	DECLARE @RelationshipID INT;
	DECLARE @ReviewerID INT;
	DECLARE @ReviewerName VARCHAR(255);
	DECLARE @SalutationTypeID INT;
	DECLARE @SSN VARCHAR(50);
	DECLARE @StateID INT;
	DECLARE @UpdateDate DATETIME;

	SET @InsertDate = GETDATE();
	SET @UpdateDate = NULL;

	INSERT INTO PatientIDSourceGenerator
	VALUES (1)

	SET @NextID = Scope_identity();
	SET @PatientIDSource = 'PAT-' + RIGHT('00000000' + CAST(@NextID AS VARCHAR(8)), 8);

	SELECT @RecordCount = COUNT(1)
	FROM Patient(NOLOCK)
	WHERE PatientIDSource = @PatientIDSource

	IF @RecordCount <> 0
	BEGIN
		EXEC @LockResult = sp_getapplock @Resource = 'CreatePatients'
			, @LockMode = 'Exclusive'
			, @LockOwner = 'Transaction'
			, @LockTimeout = 20000;-- Wait 20 seconds to aquire a lock.   

		IF (@LockResult < 0)
			RAISERROR (
					'Could not get exclusive lock on %s.'
					, 11
					, 1
					, 'CreatePatients'
					);

		EXEC cgasp_NextPatientSourceID @PatientIDSource OUT;
	END

	SET @SalutationTypeID = 1;
	SET @LastName = (
			SELECT TOP 1 [LastName]
			FROM [PERF-CTRL].[TestData].[dbo].[PatientNames]
			ORDER BY NEWID()
			);
	SET @FirstName = (
			SELECT TOP 1 [FirstName]
			FROM [PERF-CTRL].[TestData].[dbo].[PatientNames]
			ORDER BY NEWID()
			);
	SET @MiddleInitial = (
			SELECT TOP 1 [MiddleInitial]
			FROM [PERF-CTRL].[TestData].[dbo].[PatientNames]
			ORDER BY NEWID()
			);
	SET @RelationshipID = (
			SELECT TOP 1 ID
			FROM [dbo].RefRelationship
			ORDER BY NEWID()
			);
	SET @OtherID = dbo.RandomNumberAsString(RAND(), 3) + '-OTH';
	SET @MRN = dbo.RandomNumberAsString(RAND(), 9);
	SET @GenderID = FLOOR(1.9999999999 * RAND()) + 1;
	SET @SSN = dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 2) + '-' + dbo.RandomNumberAsString(RAND(), 4);
	SET @DateOfBirth = dbo.RandomDate(NEWID(), 0);
	SET @Address1 = (
			SELECT TOP 1 Address
			FROM [PERF-CTRL].[TestData].[dbo].StreetAddress
			ORDER BY NEWID()
			);
	SET @Address2 = (
			SELECT TOP 1 Type
			FROM [PERF-CTRL].[TestData].[dbo].Address2Types
			ORDER BY NEWID()
			) + ' ' + dbo.RandomNumberAsString(RAND(), 3);
	SET @City = (
			SELECT TOP 1 CityName
			FROM [PERF-CTRL].[TestData].[dbo].City
			ORDER BY NEWID()
			);
	SET @CCGFlag = CASE 
			WHEN @I % 33 = 0
				THEN 1
			ELSE 0
			END
	SET @IsVIP = CASE 
			WHEN @I % 100 = 0
				THEN 1
			ELSE 0
			END
	SET @HomePhone = '(' + dbo.RandomNumberAsString(RAND(), 3) + ') ' + dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 4);
	SET @BusinessPhone = '(' + dbo.RandomNumberAsString(RAND(), 3) + ') ' + dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 4);
	SET @FaxNumber = '(' + dbo.RandomNumberAsString(RAND(), 3) + ') ' + dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 4);
	SET @CellPhoneNumber = '(' + dbo.RandomNumberAsString(RAND(), 3) + ') ' + dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 4);
	SET @Email = @FirstName + '@' + @LastName + '.com';
	SET @Active = 1;
	SET @StateID = (
			SELECT TOP 1 [ID]
			FROM RefState
			ORDER BY NEWID()
			);
	SET @CountryID = (
			SELECT TOP 1 [ID]
			FROM RefCountry
			ORDER BY NEWID()
			);
	SET @PostalCode = dbo.RandomNumberAsString(RAND(), 5)
	SET @ReviewerID = 1;
	SET @ReviewerName = 'admin';
	SET @CreatorID = 1;
	SET @CreatorName = 'Bud Gack';
	SET @PolicyStartDate = dbo.RandomDate(NEWID(), 1);
	SET @PolicyEndDate = DATEADD(year, 1, @PolicyStartDate);
	SET @DoNotContactFlag = FLOOR(1.9999999999 * RAND());
	SET @BenefitPlanName = (
			SELECT TOP 1 Word + ' Plan'
			FROM [PERF-CTRL].[TestData].[dbo].[RandomWords]
			ORDER BY NEWID()
			);
	SET @BenefitProduct = (
			SELECT TOP 1 Word + ' Thing'
			FROM [PERF-CTRL].[TestData].[dbo].[RandomWords]
			ORDER BY NEWID()
			);
	SET @BenefitGroupID = dbo.RandomNumberAsString(RAND(), 7);
	SET @BenefitMemberID = dbo.RandomNumberAsString(RAND(), 2) + '-' + dbo.RandomNumberAsString(RAND(), 2) + '-' + dbo.RandomNumberAsString(RAND(), 2);
	SET @BenefitEligibilityDate = dbo.RandomDate(NEWID(), 1);
	SET @BenefitDisenrollmentDate = DATEADD(year, 1, @PolicyStartDate);
	SET @Debug = 1;

	INSERT INTO [Patient]
	WITH (TABLOCK) (
			[PatientIDSource]
			, [SalutationTypeID]
			, [LastName]
			, [FirstName]
			, [MiddleInitial]
			, [RelationshipID]
			, [OtherID]
			, [MRN]
			, [GenderID]
			, [SSN]
			, [DateOfBirth]
			, [Address1]
			, [Address2]
			, [City]
			, [CCGFlag]
			, [IsVIP]
			, [HomePhone]
			, [BusinessPhone]
			, [FaxNumber]
			, [CellPhoneNumber]
			, [Email]
			, [Active]
			, [UpdateDate]
			, [InsertDate]
			, [StateID]
			, [CountryID]
			, [PostalCode]
			, [ReviewerID]
			, [ReviewerName]
			, [CreatorID]
			, [CreatorName]
			, [PolicyStartDate]
			, [PolicyEndDate]
			, [DoNotContactFlag]
			, [BenefitPlanName]
			, [BenefitProduct]
			, [BenefitGroupID]
			, [BenefitMemberID]
			, [BenefitEligibilityDate]
			, [BenefitDisenrollmentDate]
			)
	VALUES (
		@PatientIDSource
		, @SalutationTypeID
		, @LastName
		, @FirstName
		, @MiddleInitial
		, @RelationshipID
		, @OtherID
		, @MRN
		, @GenderID
		, @SSN
		, @DateOfBirth
		, @Address1
		, @Address2
		, @City
		, @CCGFlag
		, @IsVIP
		, @HomePhone
		, @BusinessPhone
		, @FaxNumber
		, @CellPhoneNumber
		, @Email
		, @Active
		, @UpdateDate
		, @InsertDate
		, @StateID
		, @CountryID
		, @PostalCode
		, @ReviewerID
		, @ReviewerName
		, @CreatorID
		, @CreatorName
		, @PolicyStartDate
		, @PolicyEndDate
		, @DoNotContactFlag
		, @BenefitPlanName
		, @BenefitProduct
		, @BenefitGroupID
		, @BenefitMemberID
		, @BenefitEligibilityDate
		, @BenefitDisenrollmentDate
		);

	SET @PatientID = SCOPE_IDENTITY();

	-- All Patients must belong to at least one Group. Assign to default Group. 
	SELECT @DefaultGroupID = GroupID
	FROM [AppGroup]
	WHERE isdefault = 1;

	INSERT INTO PatientGroup (
		PatientID
		, GroupID
		)
	VALUES (
		@PatientID
		, @DefaultGroupID
		);

	--PRINT @PatientIDSource + ', ' + @FirstName + ' ' + @LastName + ' inserted';
	SELECT LastName, FirstName
	FROM Patient
	WHERE PatientID = @PatientID;
END;
