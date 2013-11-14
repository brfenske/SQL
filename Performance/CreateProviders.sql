IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.CreateProviders')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE dbo.CreateProviders;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
		,[LastName] VARCHAR(50) NULL
		,[MiddleInitial] NCHAR(1) NULL
		);
	DECLARE @StateTable TABLE (ID INT);
	DECLARE @FacilityIDTable TABLE (FacilityID INT);

	INSERT INTO @Table999
	SELECT n
	FROM [dbo].TableOfNumbers(3);

	INSERT INTO @Table9999
	SELECT n
	FROM [dbo].TableOfNumbers(4);

	INSERT INTO @Table99999
	SELECT n
	FROM [dbo].TableOfNumbers(5);

	--INSERT INTO @Table999999
	--SELECT n
	--FROM [dbo].TableOfNumbers(6);

	--INSERT INTO @Table9999999
	--SELECT n
	--FROM [dbo].TableOfNumbers(7);

	INSERT INTO @Address1Table
	SELECT [Address]
	FROM [PERF-CTRL].[TestData].[dbo].[StreetAddress]

	INSERT INTO @Address2Table
	SELECT [Type]
	FROM [PERF-CTRL].[TestData].[dbo].[Address2Types];

	INSERT INTO @Cities
	SELECT [CityName]
	FROM [PERF-CTRL].[TestData].[dbo].[City];

	INSERT INTO @EmailTable
	SELECT [EmailAddress]
	FROM [PERF-CTRL].[TestData].[dbo].[Email];

	INSERT INTO @PatientNameTable
	SELECT [FirstName]
		,[LastName]
		,[MiddleInitial]
	FROM [PERF-CTRL].[TestData].[dbo].[PatientNames];

	INSERT INTO @StateTable
	SELECT ID
	FROM [dbo].RefState;

	INSERT INTO @FacilityIDTable
	SELECT FacilityID
	FROM [dbo].Facility;

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
		VALUES (1)

		SET @NextID = SCOPE_IDENTITY();
		SET @ProviderIDSource = 'FAC-' + RIGHT('00000000' + CAST(@NextID AS VARCHAR(8)), 8);
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
		SET @TaxID = '91-99999999'; -- + dbo.RandomNumberAsString(RAND(), 8);
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
		SET @PostalCode = '99999'; --dbo.RandomNumberAsString(RAND(), 5) + '-' + dbo.RandomNumberAsString(RAND(), 4);
		SET @Email = (
				SELECT TOP 1 EmailAddress
				FROM @EmailTable
				ORDER BY NEWID()
				);
		SET @BusinessPhone = '(999) 999-9999'; --'(' + dbo.RandomNumberAsString(RAND(), 3) + ') ' + dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 4);
		SET @FaxPhone = '(999) 999-9999'; --'(' + dbo.RandomNumberAsString(RAND(), 3) + ') ' + dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 4);
		SET @Address1 = (
				SELECT TOP 1 Address
				FROM @Address1Table
				ORDER BY NEWID()
				);
		SET @Address2 = (
				SELECT TOP 1 Type
				FROM [PERF-CTRL].[TestData].[dbo].Address2Types
				ORDER BY NEWID()
				) + ' ' + '999'; --dbo.RandomNumberAsString(RAND(), 3);
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

		INSERT INTO [Provider] (
			[ProviderIDSource]
			,[LastName]
			,[FirstName]
			,[MiddleInitial]
			,[TitleID]
			,[SalutationTypeID]
			,[LicenseNumber]
			,[SpecialtyID1]
			,[SpecialtyID2]
			,[SpecialtyID3]
			,[BusinessPhone]
			,[FaxPhone]
			,[Address1]
			,[Address2]
			,[City]
			,[PostalCode]
			,[Email]
			,[TaxID]
			,[FacilityID]
			,[Active]
			,[UpdateDate]
			,[InsertDate]
			,[StateID]
			,[ProviderTypeValue]
			)
		VALUES (
			@ProviderIDSource
			,@LastName
			,@FirstName
			,@MiddleInitial
			,@TitleID
			,@SalutationTypeID
			,@LicenseNumber
			,@SpecialtyID1
			,@SpecialtyID2
			,@SpecialtyID3
			,@BusinessPhone
			,@FaxPhone
			,@Address1
			,@Address2
			,@City
			,@PostalCode
			,@Email
			,@TaxID
			,@FacilityID
			,@Active
			,@UpdateDate
			,@InsertDate
			,@StateID
			,@ProviderTypeValue
			);

		SET @ProviderID = SCOPE_IDENTITY();

		-- All Providers must belong to at least one Group. Assign to default Group. 
		SELECT @DefaultGroupID = GroupID
		FROM [AppGroup]
		WHERE IsDefault = 1;

		INSERT INTO ProviderGroup (
			ProviderID
			,GroupID
			)
		VALUES (
			@ProviderID
			,@DefaultGroupID
			);

		PRINT @ProviderIDSource + ' ' + @FirstName + ' ' + @LastName;

		SET @I = @I + 1;
	END;
END;
GO


