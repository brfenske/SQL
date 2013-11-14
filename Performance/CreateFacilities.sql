IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.CreateFacilities')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE dbo.CreateFacilities;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
		VALUES (1)

		SET @NextID = SCOPE_IDENTITY();
		SET @FacilityIDSource = 'FAC-' + RIGHT('00000000' + CAST(@NextID AS VARCHAR(8)), 8);

		SELECT @RecordCount = COUNT(1)
		FROM Facility(NOLOCK)
		WHERE FacilityIDSource = @FacilityIDSource

		IF @RecordCount <> 0
		BEGIN
			EXEC @LockResult = sp_getapplock @Resource = '@ProcName'
				,@LockMode = 'Exclusive'
				,@LockOwner = 'Transaction'
				,@LockTimeout = 20000;-- Wait 20 seconds to aquire a lock.  

			IF (@LockResult < 0)
				--RAISERROR('Could not get exclusive lock on %s.', 11, 1, @ProcName );   
				EXEC cgasp_NextFacilitySourceID @FacilityIDSource OUT
		END

		SET @FacilityTypeValue = FLOOR(1.9999999999 * RAND()) + 1;
		SET @FacilityName = (
				SELECT TOP 1 Word + ' Medical Center'
				FROM [PERF-CTRL].[TestData].[dbo].[RandomWords]
				ORDER BY NEWID()
				);
		SET @LicenseNumber = dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 7);
		SET @TaxID = '91-' + dbo.RandomNumberAsString(RAND(), 8);
		SET @City = (
				SELECT TOP 1 CityName
				FROM [PERF-CTRL].[TestData].[dbo].City
				ORDER BY NEWID()
				);
		SET @Active = 1;
		SET @DeactivatedDate = NULL;
		SET @PostalCode = dbo.RandomNumberAsString(RAND(), 5) + '-' + dbo.RandomNumberAsString(RAND(), 4);
		SET @Email = (
				SELECT TOP 1 EmailAddress
				FROM [PERF-CTRL].[TestData].[dbo].Email
				ORDER BY NEWID()
				);
		SET @BusinessPhone = '(' + dbo.RandomNumberAsString(RAND(), 3) + ') ' + dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 4);
		SET @FaxPhone = '(' + dbo.RandomNumberAsString(RAND(), 3) + ') ' + dbo.RandomNumberAsString(RAND(), 3) + '-' + dbo.RandomNumberAsString(RAND(), 4);
		SET @Address1 = (
				SELECT TOP 1 Address
				FROM [PERF-CTRL].[TestData].[dbo].StreetAddress
				ORDER BY NEWID()
				);
		SET @Address2 = (
				SELECT TOP 1 Type
				FROM [PERF-CTRL].[TestData].[dbo].Address2Types
				ORDER BY NEWID()
				) + dbo.RandomNumberAsString(RAND(), 3);
		SET @StateID = (
				SELECT TOP 1 [ID]
				FROM RefState
				ORDER BY NEWID()
				);

		INSERT INTO [Facility] (
			[FacilityIDSource]
			,[FacilityTypeValue]
			,[FacilityName]
			,[LicenseNumber]
			,[TaxID]
			,[City]
			,[Active]
			,[DeactivatedDate]
			,[PostalCode]
			,[Email]
			,[BusinessPhone]
			,[FaxPhone]
			,[Address1]
			,[Address2]
			,[UpdateDate]
			,[InsertDate]
			,[StateID]
			)
		VALUES (
			@FacilityIDSource
			,@FacilityTypeValue
			,@FacilityName
			,@LicenseNumber
			,@TaxID
			,@City
			,@Active
			,@DeactivatedDate
			,@PostalCode
			,@Email
			,@BusinessPhone
			,@FaxPhone
			,@Address1
			,@Address2
			,@UpdateDate
			,@InsertDate
			,@StateID
			);

		SET @FacilityID = SCOPE_IDENTITY();

		-- All Facilitys must belong to at least one Group. Assign to default Group. 
		DECLARE @DefaultGroupID INT;

		SELECT @DefaultGroupID = GroupID
		FROM [AppGroup]
		WHERE isdefault = 1;

		INSERT INTO FacilityGroup (
			FacilityID
			,GroupID
			)
		VALUES (
			@FacilityID
			,@DefaultGroupID
			);

		PRINT @FacilityIDSource + ' ' + @FacilityName;

		SET @I = @I + 1;
	END;
END;
