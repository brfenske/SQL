SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DECLARE @TestDataHost VARCHAR(255);

SET @TestDataHost = N'PERF-CTRL.CompanyNet.org';

IF NOT EXISTS (
		SELECT *
		FROM sys.servers
		WHERE NAME = 'PERF-CTRL.CompanyNet.org'
		)
BEGIN
	EXEC master.dbo.sp_addlinkedserver @server = @TestDataHost
		, @srvproduct = N'SQL Server';

	EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = @TestDataHost
		, @useself = N'False'
		, @locallogin = NULL
		, @rmtuser = N'sa'
		, @rmtpassword = 'p@ssw0rd';
END;

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'dbo.[RandomNumberAsString]')
			AND type IN (
				N'F'
				, N'FN'
				)
		)
	DROP FUNCTION dbo.[RandomNumberAsString];
GO

-- =============================================
-- Author:		Brian
-- Create date: 7/30/12
-- Description:	Return random number with a specified number of digits
-- =============================================
CREATE FUNCTION RandomNumberAsString (
	@Number FLOAT
	, @NumDigits INT
	)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Result INT;

	SELECT @Result = LEFT(CONVERT(VARCHAR, CAST(@Number * POWER(10, @NumDigits) AS INT)) + REPLICATE('0', @NumDigits), @NumDigits);

	RETURN @Result;
END
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'dbo.[RandomDate]')
			AND type IN (
				N'F'
				, N'FN'
				)
		)
	DROP FUNCTION dbo.[RandomDate];
GO

-- =============================================
-- Author:		Brian
-- Create date: 7/30/2012
-- Description:	Get a random date in the past or future
-- =============================================
CREATE FUNCTION RandomDate (
	@RandomID UNIQUEIDENTIFIER
	, @TimeFrame INT
	)
RETURNS DATETIME
AS
BEGIN
	DECLARE @Result DATETIME;
	DECLARE @DatePastFrom DATETIME;
	DECLARE @DateFutureFrom DATETIME;

	SET @DatePastFrom = '1925-01-01';
	SET @DateFutureFrom = CAST(YEAR(GETDATE()) AS VARCHAR) + '-12-31';

	IF (@TimeFrame = 0)
		-- Date from the past
		SELECT @Result = @DatePastFrom + (ABS(CAST(CAST(@RandomID AS BINARY (8)) AS INT)) % CAST((GETDATE() - @DatePastFrom) AS INT));
	ELSE
		-- Future date
		SELECT @Result = @DateFutureFrom - (ABS(CAST(CAST(@RandomID AS BINARY (8)) AS INT)) % CAST((@DateFutureFrom - GETDATE()) AS INT));

	RETURN @Result;
END;
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'dbo.[RandomDate]')
			AND type IN (
				N'F'
				, N'FN'
				)
		)
	DROP FUNCTION dbo.[RandomDate];
GO

-- =============================================
-- Author:		Brian
-- Create date: 7/30/2012
-- Description:	Get a random date in the past or future
-- =============================================
CREATE FUNCTION RandomDate (
	@RandomID UNIQUEIDENTIFIER
	, @TimeFrame INT
	)
RETURNS DATETIME
AS
BEGIN
	DECLARE @Result DATETIME;
	DECLARE @DatePastFrom DATETIME;
	DECLARE @DateFutureFrom DATETIME;

	SET @DatePastFrom = '1925-01-01';
	SET @DateFutureFrom = CAST(YEAR(GETDATE()) AS VARCHAR) + '-12-31';

	IF (@TimeFrame = 0)
		-- Date from the past
		SELECT @Result = @DatePastFrom + (ABS(CAST(CAST(@RandomID AS BINARY (8)) AS INT)) % CAST((GETDATE() - @DatePastFrom) AS INT));
	ELSE
		-- Future date
		SELECT @Result = @DateFutureFrom - (ABS(CAST(CAST(@RandomID AS BINARY (8)) AS INT)) % CAST((@DateFutureFrom - GETDATE()) AS INT));

	RETURN @Result;
END
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'dbo.[TableOfNumbers]')
			AND type IN (N'TF')
		)
	DROP FUNCTION dbo.[TableOfNumbers];
GO

-- =============================================
-- Author:		Brian
-- Create date: 8/6/12
-- Description:	Returns a table filled with numbers in a range 
-- specified by the number of digits passed in.  
-- For example, @digits = 4 returns table filled with
-- the numbers 1000 - 9999.
-- =============================================
CREATE FUNCTION TableOfNumbers (@digits INT)
RETURNS @NumTable TABLE (n INT)
AS
BEGIN
	DECLARE @Max AS INT;
	DECLARE @Increment AS INT;

	SET @Max = CAST(REPLICATE('9', @digits) AS INT);
	SET @Increment = 1;

	INSERT INTO @NumTable
	VALUES (POWER(10, @digits - 1));

	WHILE @Increment * 2 <= @Max
	BEGIN
		INSERT INTO @NumTable
		SELECT n + @Increment
		FROM @NumTable;

		SET @Increment = @Increment * 2;
	END;

	INSERT INTO @NumTable
	SELECT n + @Increment
	FROM @NumTable
	WHERE n + @Increment <= @Max;

	RETURN;
END
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'dbo.[RandomNumberAsString]')
			AND type IN (
				N'F'
				, N'FN'
				)
		)
	DROP FUNCTION dbo.[RandomNumberAsString];
GO

-- =============================================
-- Author:		Brian
-- Create date: 7/30/12
-- Description:	Return random number with a specified number of digits
-- =============================================
CREATE FUNCTION RandomNumberAsString (
	@Number FLOAT
	, @NumDigits INT
	)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Result INT;

	SELECT @Result = LEFT(CONVERT(VARCHAR, CAST(@Number * POWER(10, @NumDigits) AS INT)) + REPLICATE('0', @NumDigits), @NumDigits);

	RETURN @Result;
END
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.CreateFacilities')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.CreateFacilities;
GO

CREATE PROCEDURE dbo.CreateFacilities (@NumRecords INT)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Active BIT;
	DECLARE @Address1 VARCHAR(255);
	DECLARE @Address2 VARCHAR(255);
	DECLARE @BusinessPhone VARCHAR(50);
	DECLARE @City VARCHAR(50);
	DECLARE @DeactivatedDate DATETIME;
	DECLARE @Email VARCHAR(100);
	DECLARE @FacilityID INT;
	DECLARE @FacilityIDSource VARCHAR(50);
	DECLARE @FacilityName VARCHAR(50);
	DECLARE @FacilityTypeValue VARCHAR(50);
	DECLARE @FaxPhone VARCHAR(50);
	DECLARE @I INT;
	DECLARE @InsertDate DATETIME;
	DECLARE @LicenseNumber VARCHAR(50);
	DECLARE @LockResult INT;
	DECLARE @NextID INT;
	DECLARE @PostalCode VARCHAR(25);
	DECLARE @RecordCount INT;
	DECLARE @StateID INT;
	DECLARE @TaxID VARCHAR(50);
	DECLARE @UpdateDate DATETIME;

	SET @InsertDate = GETDATE();
	SET @UpdateDate = NULL;
	SET @I = 1;

	WHILE (@I <= @NumRecords)
	BEGIN
		INSERT INTO FacilityIDSourceGenerator
		VALUES (1);

		SET @NextID = SCOPE_IDENTITY();
		SET @FacilityIDSource = 'FAC-' + RIGHT('00000000' + CAST(@NextID AS VARCHAR(8)), 8);

		SELECT @RecordCount = COUNT(1)
		FROM Facility(NOLOCK)
		WHERE FacilityIDSource = @FacilityIDSource;

		IF @RecordCount <> 0
		BEGIN
			EXEC @LockResult = sp_getapplock @Resource = '@ProcName'
				, @LockMode = 'Exclusive'
				, @LockOwner = 'Transaction'
				, @LockTimeout = 20000;-- Wait 20 seconds to aquire a lock.  

			IF (@LockResult < 0)
				--RAISERROR('Could not get exclusive lock on %s.', 11, 1, @ProcName );   
				EXEC cgasp_NextFacilitySourceID @FacilityIDSource OUT;
		END;

		SET @FacilityTypeValue = FLOOR(1.9999999999 * RAND()) + 1;
		SET @FacilityName = (
				SELECT TOP 1 Word + ' Medical Center'
				FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.[RandomWords]
				ORDER BY NEWID()
				);
		SET @LicenseNumber = dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 7);
		SET @TaxID = '91-' + dbo.RandomNumberAsString(RAND(), 8);
		SET @City = (
				SELECT TOP 1 CityName
				FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.City
				ORDER BY NEWID()
				);
		SET @Active = 1;
		SET @DeactivatedDate = NULL;
		SET @PostalCode = dbo.RandomNumberAsString(RAND(), 5) + '-' + dbo.RandomNumberAsString(RAND(), 4);
		SET @Email = (
				SELECT TOP 1 EmailAddress
				FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.Email
				ORDER BY NEWID()
				);
		SET @BusinessPhone = '(' + dbo.RandomNumberAsString(RAND(), 3) + ') ' + dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 4);
		SET @FaxPhone = '(' + dbo.RandomNumberAsString(RAND(), 3) + ') ' + dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 4);
		SET @Address1 = (
				SELECT TOP 1 Address
				FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.StreetAddress
				ORDER BY NEWID()
				);
		SET @Address2 = (
				SELECT TOP 1 Type
				FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.Address2Types
				ORDER BY NEWID()
				) + dbo.RandomNumberAsString(RAND(), 3);
		SET @StateID = (
				SELECT TOP 1 [ID]
				FROM RefState
				ORDER BY NEWID()
				);

		-------------------------------------------------------
		DECLARE @return_value INT
			, @UserSessionID INT;

		EXEC @return_value = [dbo].[cgasp_InsertUserSession] @UserSessionID = @UserSessionID OUTPUT
			, @userID = 1
			, @active = 1
			, @isapi = 0;

		EXEC [dbo].[cgasp_InsertFacilityAndGroups] @UserSessionID = @UserSessionID
			, @facilityID = @FacilityID OUTPUT
			, @facilityIDSource = @FacilityIDSource OUTPUT
			, @facilityTypeValue = @FacilityTypeValue
			, @facilityName = @FacilityName
			, @licenseNumber = @LicenseNumber
			, @taxID = @TaxID
			, @city = @City
			, @active = @Active
			, @deactivatedDate = @DeactivatedDate
			, @postalCode = @PostalCode
			, @email = @Email
			, @businessPhone = @BusinessPhone
			, @faxPhone = @FaxPhone
			, @address1 = @Address1
			, @address2 = @Address2
			, @stateID = @StateID
			, @GroupID = 1
			, @Debug = 0;

		PRINT @FacilityIDSource + ' ' + @FacilityName;

		SET @I = @I + 1;
	END;
END;
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.CreateProviders')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.CreateProviders;
GO

CREATE PROCEDURE dbo.CreateProviders (@NumRecords INT)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Table999 TABLE (n INT);
	DECLARE @Table9999 TABLE (n INT);
	DECLARE @Table99999 TABLE (n INT);
	DECLARE @Table999999 TABLE (n INT);
	DECLARE @Table9999999 TABLE (n INT);
	DECLARE @Table99999999 TABLE (n INT);
	DECLARE @Address1Table TABLE ([Address] VARCHAR(100));
	DECLARE @Address2Table TABLE ([Type] VARCHAR(50));
	DECLARE @Cities TABLE (CityName VARCHAR(50));
	DECLARE @EmailTable TABLE (EmailAddress VARCHAR(100));
	DECLARE @PatientNameTable TABLE (
		[FirstName] VARCHAR(50) NULL
		, [LastName] VARCHAR(50) NULL
		, [MiddleInitial] NCHAR(1) NULL
		);
	DECLARE @StateTable TABLE (ID INT);
	DECLARE @FacilityIDTable TABLE (FacilityID INT);

	INSERT INTO @Table999
	SELECT n
	FROM dbo.TableOfNumbers(3);

	INSERT INTO @Table9999
	SELECT n
	FROM dbo.TableOfNumbers(4);

	INSERT INTO @Table99999
	SELECT n
	FROM dbo.TableOfNumbers(5);

	--INSERT INTO @Table999999
	--SELECT n
	--FROM dbo.TableOfNumbers(6);
	--INSERT INTO @Table9999999
	--SELECT n
	--FROM dbo.TableOfNumbers(7);
	INSERT INTO @Address1Table
	SELECT [Address]
	FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.[StreetAddress];

	INSERT INTO @Address2Table
	SELECT [Type]
	FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.[Address2Types];

	INSERT INTO @Cities
	SELECT [CityName]
	FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.[City];

	INSERT INTO @EmailTable
	SELECT [EmailAddress]
	FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.[Email];

	INSERT INTO @PatientNameTable
	SELECT [FirstName]
		, [LastName]
		, [MiddleInitial]
	FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.[PatientNames];

	INSERT INTO @StateTable
	SELECT ID
	FROM dbo.RefState;

	INSERT INTO @FacilityIDTable
	SELECT FacilityID
	FROM dbo.Facility;

	DECLARE @Active BIT;
	DECLARE @Address1 VARCHAR(255);
	DECLARE @Address2 VARCHAR(255);
	DECLARE @BusinessPhone VARCHAR(50);
	DECLARE @City VARCHAR(50);
	DECLARE @DeactivatedDate DATETIME;
	DECLARE @DefaultGroupID INT;
	DECLARE @Email VARCHAR(100);
	DECLARE @FacilityID INT;
	DECLARE @FaxPhone VARCHAR(50);
	DECLARE @FirstName VARCHAR(50);
	DECLARE @I INT;
	DECLARE @InsertDate DATETIME;
	DECLARE @LastName VARCHAR(100);
	DECLARE @LicenseNumber VARCHAR(50);
	DECLARE @MiddleInitial VARCHAR(5);
	DECLARE @NextID INT;
	DECLARE @PostalCode VARCHAR(25);
	DECLARE @ProviderID INT;
	DECLARE @ProviderIDSource VARCHAR(50);
	DECLARE @ProviderTypeValue INT;
	DECLARE @RecordCount INT;
	DECLARE @SalutationTypeID INT;
	DECLARE @SpecialtyID1 INT;
	DECLARE @SpecialtyID2 INT;
	DECLARE @SpecialtyID3 INT;
	DECLARE @StateID INT;
	DECLARE @TaxID VARCHAR(50);
	DECLARE @TitleID INT;
	DECLARE @UpdateDate DATETIME;

	SET @InsertDate = GETDATE();
	SET @UpdateDate = NULL;
	SET @I = 1;

	WHILE (@I <= @NumRecords)
	BEGIN
		INSERT INTO ProviderIDSourceGenerator
		VALUES (1);

		SET @NextID = SCOPE_IDENTITY();
		SET @ProviderIDSource = 'PRO-' + RIGHT('00000000' + CAST(@NextID AS VARCHAR(8)), 8);
		--SELECT @RecordCount = COUNT(1)
		--FROM Provider(NOLOCK)
		--WHERE ProviderIDSource = @ProviderIDSource
		SET @ProviderTypeValue = @I % 3 + 1;
		SET @LastName = (
				SELECT TOP 1 [LastName]
				FROM @PatientNameTable
				ORDER BY NEWID()
				);
		SET @FirstName = (
				SELECT TOP 1 [FirstName]
				FROM @PatientNameTable
				ORDER BY NEWID()
				);
		SET @MiddleInitial = (
				SELECT TOP 1 [MiddleInitial]
				FROM @PatientNameTable
				ORDER BY NEWID()
				);
		SET @SalutationTypeID = @I % 5 + 1;
		SET @TitleID = @I % 4 + 1;
		SET @LicenseNumber = (
				SELECT TOP 1 n
				FROM @Table999
				ORDER BY NEWID()
				) + '-' + (
				SELECT TOP 1 n
				FROM @Table99999
				ORDER BY NEWID()
				);
		SET @TaxID = '91-99999999';-- + dbo.RandomNumberAsString(RAND(), 8);
		SET @SpecialtyID1 = @I % 20 + 1;
		SET @SpecialtyID2 = (@I + 1) % 20 + 1;
		SET @SpecialtyID3 = (@I + 2) % 20 + 1;
		SET @City = (
				SELECT TOP 1 CityName
				FROM @Cities
				ORDER BY NEWID()
				);
		SET @Active = 1;
		SET @DeactivatedDate = NULL;
		SET @PostalCode = '99999';--dbo.RandomNumberAsString(RAND(), 5) + '-' + dbo.RandomNumberAsString(RAND(), 4);
		SET @Email = (
				SELECT TOP 1 EmailAddress
				FROM @EmailTable
				ORDER BY NEWID()
				);
		SET @BusinessPhone = '(999) 999-9999';--'(' + dbo.RandomNumberAsString(RAND(), 3) + ') ' + dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 4);
		SET @FaxPhone = '(999) 999-9999';--'(' + dbo.RandomNumberAsString(RAND(), 3) + ') ' + dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 4);
		SET @Address1 = (
				SELECT TOP 1 Address
				FROM @Address1Table
				ORDER BY NEWID()
				);
		SET @Address2 = (
				SELECT TOP 1 Type
				FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.Address2Types
				ORDER BY NEWID()
				) + ' ' + '999';--dbo.RandomNumberAsString(RAND(), 3);
		SET @StateID = (
				SELECT TOP 1 [ID]
				FROM @StateTable
				ORDER BY NEWID()
				);
		SET @FacilityID = (
				SELECT TOP 1 [FacilityID]
				FROM @FacilityIDTable
				ORDER BY NEWID()
				);

		-------------------------------------------------------
		DECLARE @return_value INT
			, @UserSessionID INT;

		EXEC @return_value = [dbo].[cgasp_InsertUserSession] @UserSessionID = @UserSessionID OUTPUT
			, @userID = 1
			, @active = 1
			, @isapi = 0;

		EXEC [dbo].[cgasp_InsertProviderAndGroups] @UserSessionID = @UserSessionID
			, @providerID = @ProviderID OUTPUT
			, @providerIDSource = @ProviderIDSource OUTPUT
			, @lastName = @LastName
			, @firstName = @FirstName
			, @middleInitial = @MiddleInitial
			, @titleID = @TitleID
			, @salutationTypeID = @SalutationTypeID
			, @licenseNumber = @LicenseNumber
			, @specialtyID1 = 1
			, @specialtyID2 = 2
			, @specialtyID3 = 3
			, @businessPhone = @BusinessPhone
			, @faxPhone = @FaxPhone
			, @address1 = @Address1
			, @address2 = @Address2
			, @city = @City
			, @postalCode = @PostalCode
			, @email = @Email
			, @taxID = @TaxID
			, @facilityID = @FacilityID
			, @active = @Active
			, @stateID = @StateID
			, @providerTypeValue = @ProviderTypeValue
			, @GroupID = 1
			, @debug = 0;

		PRINT @ProviderIDSource + ' ' + @FirstName + ' ' + @LastName;

		SET @I = @I + 1;
	END;
END;
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[CreatePatients]')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE [dbo].[CreatePatients];
GO

CREATE PROCEDURE dbo.CreatePatients (@NumRecords INT)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Table999 TABLE (n INT);
	DECLARE @Table9999 TABLE (n INT);
	DECLARE @Table99999 TABLE (n INT);
	DECLARE @Table999999 TABLE (n INT);
	DECLARE @Table9999999 TABLE (n INT);
	DECLARE @Table99999999 TABLE (n INT);
	DECLARE @Address1Table TABLE ([Address] VARCHAR(100));
	DECLARE @Address2Table TABLE ([Type] VARCHAR(50));
	DECLARE @Cities TABLE (CityName VARCHAR(50));
	DECLARE @EmailTable TABLE (EmailAddress VARCHAR(100));
	DECLARE @PatientNameTable TABLE (
		[FirstName] VARCHAR(50) NULL
		, [LastName] VARCHAR(50) NULL
		, [MiddleInitial] NCHAR(1) NULL
		);
	DECLARE @StateTable TABLE (ID INT);
	DECLARE @FacilityIDTable TABLE (FacilityID INT);

	EXEC ('DISABLE TRIGGER dbo.InsertPatientTrigg ON Patient');

	INSERT INTO @Table999
	SELECT n
	FROM dbo.TableOfNumbers(3);

	INSERT INTO @Table9999
	SELECT n
	FROM dbo.TableOfNumbers(4);

	INSERT INTO @Table99999
	SELECT n
	FROM dbo.TableOfNumbers(5);

	INSERT INTO @Address1Table
	SELECT [Address]
	FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.[StreetAddress]

	INSERT INTO @Address2Table
	SELECT [Type]
	FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.[Address2Types];

	INSERT INTO @Cities
	SELECT [CityName]
	FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.[City];

	INSERT INTO @EmailTable
	SELECT [EmailAddress]
	FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.[Email];

	INSERT INTO @PatientNameTable
	SELECT [FirstName]
		, [LastName]
		, [MiddleInitial]
	FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.[PatientNames];

	INSERT INTO @StateTable
	SELECT ID
	FROM dbo.RefState;

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
	SET @I = 1;

	WHILE (@I <= @NumRecords)
	BEGIN
		INSERT INTO PatientIDSourceGenerator
		VALUES (1);

		SET @NextID = SCOPE_IDENTITY();
		SET @PatientIDSource = 'PAT-' + RIGHT('00000000' + CAST(@NextID AS VARCHAR(8)), 8);

		SELECT @RecordCount = COUNT(1)
		FROM Patient(NOLOCK)
		WHERE PatientIDSource = @PatientIDSource;

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
		END;

		SET @SalutationTypeID = @I % 5 + 1;
		SET @LastName = (
				SELECT TOP 1 [LastName]
				FROM @PatientNameTable
				ORDER BY NEWID()
				);
		SET @FirstName = (
				SELECT TOP 1 [FirstName]
				FROM @PatientNameTable
				ORDER BY NEWID()
				);
		SET @MiddleInitial = (
				SELECT TOP 1 [MiddleInitial]
				FROM @PatientNameTable
				ORDER BY NEWID()
				);
		SET @RelationshipID = @I % 3 + 1;
		SET @OtherID = CAST(@I % 3 + 1 AS VARCHAR) + '-OTH';
		SET @MRN = '9999999999';
		SET @GenderID = @I % 1 + 1;
		SET @SSN = '999' + '-' + '99' + '-' + '9999';
		SET @DateOfBirth = dbo.RandomDate(NEWID(), 0);
		SET @Address1 = (
				SELECT TOP 1 Address
				FROM @Address1Table
				ORDER BY NEWID()
				);
		SET @Address2 = (
				SELECT TOP 1 Type
				FROM [PERF-CTRL.CompanyNet.org].TestData.dbo.Address2Types
				ORDER BY NEWID()
				) + ' ' + '999';--dbo.RandomNumberAsString(RAND(), 3);
		SET @City = (
				SELECT TOP 1 CityName
				FROM @Cities
				ORDER BY NEWID()
				);
		SET @StateID = (
				SELECT TOP 1 [ID]
				FROM @StateTable
				ORDER BY NEWID()
				);
		SET @CountryID = @I % 246 + 1;
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
		SET @HomePhone = '(999) 999-9999';
		SET @BusinessPhone = '(999) 999-9999';
		SET @FaxNumber = '(999) 999-9999';
		SET @CellPhoneNumber = '(999) 999-9999';
		SET @Email = @FirstName + '@' + @LastName + '.com';
		SET @Active = 1;
		SET @PostalCode = '99999';
		SET @ReviewerID = 1;
		SET @ReviewerName = 'admin';
		SET @CreatorID = 1;
		SET @CreatorName = 'Bud Gack';
		SET @PolicyStartDate = dbo.RandomDate(NEWID(), 1);
		SET @PolicyEndDate = DATEADD(year, 1, @PolicyStartDate);
		SET @DoNotContactFlag = CASE 
				WHEN @I % 10 = 0
					THEN 1
				ELSE 0
				END

		DECLARE @BenefitPlanID INT;

		IF NOT EXISTS (
				SELECT *
				FROM BenefitPlan
				)
			EXEC [dbo].[BenefitPlanInsert] @BenefitPlanID = @BenefitPlanID OUTPUT
				, @Code = '1'
				, @BenefitPlanName = 'Group Health'
				, @BenefitPlanDescription = 'Benefits Plus'
				, @OrganizationID = 1
				, @Active = 1
				, @InsertUserID = 1
				, @Debug = 0;

		SELECT TOP 1 @BenefitPlanID = BenefitPlanID
			, @BenefitPlanName = BenefitPlanName
			, @BenefitProduct = BenefitPlanDescription
		FROM BenefitPlan;

		SET @BenefitGroupID = 'GRP9999';
		SET @BenefitMemberID = 'KKK 999999999';
		SET @BenefitEligibilityDate = dbo.RandomDate(NEWID(), 1);
		SET @BenefitDisenrollmentDate = DATEADD(year, 1, @PolicyStartDate);
		SET @Debug = 1;

		-------------------------------------------------------
		DECLARE @return_value INT
			, @UserSessionID INT;

		EXEC @return_value = [dbo].[cgasp_InsertUserSession] @UserSessionID = @UserSessionID OUTPUT
			, @userID = 1
			, @active = 1
			, @isapi = 0;

		EXEC @return_value = [dbo].[Cgasp_insertpatient] @UserSessionID = @UserSessionID
			, @active = 1
			, @address1 = @Address1
			, @address2 = @Address2
			, @BenefitEligibilityDate = @BenefitEligibilityDate
			, @BenefitGroupID = @BenefitGroupID
			, @BenefitMemberID = @BenefitMemberID
			, @benefitPlanID = @benefitPlanID
			, @BenefitPlanName = @BenefitPlanName
			, @BenefitProduct = @BenefitProduct
			, @businessPhone = @businessPhone
			, @cCGFlag = @CCGFlag
			, @cellPhoneNumber = @CellPhoneNumber
			, @city = @City
			, @countryID = @CountryID
			, @creatorID = 1
			, @creatorName = @CreatorName
			, @dateOfBirth = @DateOfBirth
			, @donotContactFlag = @DoNotContactFlag
			, @email = @Email
			, @faxNumber = @faxNumber
			, @firstName = @firstName
			, @genderID = @GenderID
			, @homePhone = @homePhone
			, @isVIP = @IsVIP
			--, @LanguageName = @LanguageName
			, @lastName = @lastName
			, @middleInitial = @middleInitial
			, @mRN = @mRN
			, @patientID = @PatientID OUTPUT
			, @patientIDSource = @PatientIDSource OUTPUT
			, @policyEndDate = @policyEndDate
			, @policyStartDate = @policyStartDate
			, @postalCode = @postalCode
			, @relationshipID = @RelationshipID
			, @reviewerID = 1
			, @reviewerName = @reviewerName
			, @salutationTypeID = @salutationTypeID
			, @sSN = @sSN
			, @stateID = @StateID;

		--SELECT @PatientID AS N'@PatientID'
		--	, @PatientIDSource AS N'@PatientIDSource'
		--PRINT @PatientIDSource + ', ' + @FirstName + ' ' + @LastName + ' inserted';
		SET @I = @I + 1;

		EXEC ('ENABLE TRIGGER dbo.InsertPatientTrigg ON Patient');
	END;
END
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.CreateEpisodes')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.CreateEpisodes;
GO

CREATE PROCEDURE dbo.CreateEpisodes (@NumRecords INT)
AS
DECLARE @admitdate DATETIME;
DECLARE @admittingproviderID INT;
DECLARE @admittingprovidername VARCHAR(150);
DECLARE @attendingproviderID INT;
DECLARE @attendingprovidername VARCHAR(150);
DECLARE @count INT;
DECLARE @errcode INT;
DECLARE @facilityID INT;
DECLARE @facilityname VARCHAR(100);
DECLARE @EpisodeId INT;
DECLARE @EpisodeIdsource VARCHAR(50);
DECLARE @patientcount INT;
DECLARE @patientFirstName VARCHAR(50);
DECLARE @patientID INT;
DECLARE @patientIDSource VARCHAR(100);
DECLARE @PatientLastName VARCHAR(100);
DECLARE @pcpproviderID INT;
DECLARE @pcpprovidername VARCHAR(150);
DECLARE @rand INT;
DECLARE @rightnow DATETIME;

BEGIN
	EXEC ('DISABLE TRIGGER InsertEpisodeTrigg on episode');

	-- Make sure that there are existing major entities that we can select from randomly
	IF NOT EXISTS (
			SELECT FacilityID
			FROM dbo.Facility
			)
	BEGIN
		EXEC dbo.CreateFacilities 3;
	END;

	IF NOT EXISTS (
			SELECT ProviderID
			FROM dbo.Provider
			)
	BEGIN
		EXEC dbo.CreateProviders 10;
	END;

	IF NOT EXISTS (
			SELECT PatientID
			FROM dbo.Patient
			)
	BEGIN
		EXEC dbo.CreatePatients 10;
	END;

	SET @rightnow = GETUTCDATE();
	SET @count = 0;

	WHILE (@count < @NumRecords)
	BEGIN
		SET @admitdate = @rightnow - RAND() * 100;

		SELECT TOP (1) @FacilityID = FacilityID
			, @Facilityname = FacilityName
		FROM Facility
		ORDER BY CHECKSUM(NEWID());

		SELECT TOP (1) @attendingproviderID = ProviderID
			, @attendingprovidername = LastName + ', ' + FirstName
		FROM Provider
		ORDER BY CHECKSUM(NEWID());

		SELECT TOP (1) @admittingproviderID = ProviderID
			, @admittingproviderName = LastName + ', ' + FirstName
		FROM Provider
		ORDER BY CHECKSUM(NEWID());

		SELECT TOP (1) @pcpproviderID = ProviderID
			, @pcpproviderName = LastName + ', ' + FirstName
		FROM Provider
		ORDER BY CHECKSUM(NEWID());

		SELECT TOP (1) @PatientID = PatientID
			, @patientidsource = patientidsource
			, @PatientFirstname = FirstName
			, @PatientLastname = LastName
		FROM Patient
		ORDER BY CHECKSUM(NEWID());

		EXEC @errCode = cgasp_insertepisode @Active = 1
			, @AdmitDate = @Admitdate
			, @AdmittingProviderId = @AdmittingProviderId
			, @AdmittingProviderName = @AdmittingProviderName
			, @AttendingProviderId = @AttendingProviderId
			, @AttendingProviderName = @AttendingProviderName
			, @Bed = '2a'
			, @Building = 'Blue One'
			--, @CreatorId = @CreatorId
			--, @CreatorName = @CreatorName
			, @Debug = 0
			--, @DischargeDate = @DischargeDate
			--, @DischargeUserId = @DischargeUserId
			--, @DischargeUserName = @DischargeUserName
			, @EpisodeId = @EpisodeId OUTPUT
			, @EpisodeIdSource = @EpisodeIdSource OUTPUT
			--, @EpisodeInsurancePrimaryId = @EpisodeInsurancePrimaryId
			--, @EpisodeInsuranceSecondaryId = @EpisodeInsuranceSecondaryId
			--, @EpisodeInsurancetertiaryId = @EpisodeInsurancetertiaryId
			, @FacilityId = @FacilityId
			, @FacilityName = @FacilityName
			, @Floor = '12'
			, @PatientFirstName = @PatientFirstName
			, @PatientId = @PatientId
			, @PatientIdSource = @PatientIdSource
			, @PatientLastName = @PatientLastName
			, @PatientMiddleinitial = 'Q'
			, @PcpId = @pcpproviderID
			, @PcpName = @pcpproviderName
			, @Pointofcare = 'Some point of care'
			--, @RefBedId = @RefBedId
			--, @RefBuildingId = @RefBuildingId
			--, @RefDischargetoId = @RefDischargetoId
			--, @RefepisodetypeId = @RefepisodetypeId
			--, @RefFloorId = @RefFloorId
			--, @RefPointofcareId = @RefPointofcareId
			--, @RefRoomId = @RefRoomId
			--, @RequestedAdmitDate = @RequestedAdmitDate
			, @ReviewerId = 1
			, @ReviewerName = 'admin, admin'
			, @Room = '10'
			, @State = 1;

		-- need to reset these back to null or you get a pk violation
		SET @EpisodeId = NULL;
		SET @EpisodeIdsource = NULL;
		SET @count = @count + 1;
	END

	EXEC ('ENABLE TRIGGER InsertEpisodeTrigg on episode');
END;
GO


