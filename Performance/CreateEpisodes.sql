IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.CreateEpisodes')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE dbo.CreateEpisodes;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.CreateEpisodes (
	@NumPatients INT
	,@NumEpisodesPerRecord INT
	)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Active BIT;
	DECLARE @AddDate DATETIME;
	DECLARE @AddUserID INT;
	DECLARE @AddUserName VARCHAR(255);
	DECLARE @AdmitDate DATETIME;
	DECLARE @AdmittingProviderID INT;
	DECLARE @AdmittingProviderName VARCHAR(255);
	DECLARE @AttendingProviderID INT;
	DECLARE @AttendingProviderName VARCHAR(255);
	DECLARE @Bed VARCHAR(255);
	DECLARE @Blos_A VARCHAR(50);
	DECLARE @Blos_G VARCHAR(50);
	DECLARE @Blos_P VARCHAR(50);
	DECLARE @Building VARCHAR(255);
	DECLARE @CanDocumentTopLevelBullets BIT;
	DECLARE @ChronicCondition BIT;
	DECLARE @ContentVersion VARCHAR(25);
	DECLARE @ContentVersionID INT;
	DECLARE @CreatorID INT;
	DECLARE @CreatorName VARCHAR(255);
	DECLARE @Debug BIT;
	DECLARE @DischargeDate DATETIME;
	DECLARE @DischargeToID INT;
	DECLARE @Documented BIT;
	DECLARE @EpisodeID INT;
	DECLARE @EpisodeIDSource VARCHAR(100);
	DECLARE @FacilityID INT;
	DECLARE @FacilityIDSource VARCHAR(50);
	DECLARE @FacilityName VARCHAR(50);
	DECLARE @FirstName VARCHAR(50);
	DECLARE @Floor VARCHAR(255);
	DECLARE @GCode VARCHAR(50);
	DECLARE @GenderID INT;
	DECLARE @GLOS VARCHAR(255);
	DECLARE @GlosMax INT;
	DECLARE @GlosMin INT;
	DECLARE @GlosType VARCHAR(50);
	DECLARE @GuidelineID INT;
	DECLARE @GuidelineName VARCHAR(255);
	DECLARE @GuidelineTypeCode VARCHAR(50);
	DECLARE @GuidelineXML XML;
	DECLARE @HSIMCode VARCHAR(20);
	DECLARE @I INT;
	DECLARE @InsertDate DATETIME;
	DECLARE @J INT;
	DECLARE @LastName VARCHAR(100);
	DECLARE @LockResult INT;
	DECLARE @MiddleInitial VARCHAR(5);
	DECLARE @NextID INT;
	DECLARE @NextReviewDate DATETIME;
	DECLARE @PatientID INT;
	DECLARE @PatientIDSource VARCHAR(100);
	DECLARE @PcpID INT;
	DECLARE @PcpName VARCHAR(255);
	DECLARE @PointOfCare VARCHAR(255);
	DECLARE @PubTypeID SMALLINT;
	DECLARE @RecordCount INT;
	DECLARE @RefEpisodeTypeID INT;
	DECLARE @RequestedAdmitDate DATETIME;
	DECLARE @ReviewerID INT;
	DECLARE @ReviewerName VARCHAR(255);
	DECLARE @Room VARCHAR(255);
	DECLARE @State SMALLINT;
	DECLARE @UpdateDate DATETIME;

	SET @InsertDate = GETDATE();
	SET @UpdateDate = NULL;
				SET @Active = 1;

	SET @I = 1;

	WHILE (@I <= @NumPatients)
	BEGIN
	
		SET @PatientID = (
				SELECT TOP 1 [PatientID]
				FROM Patient
				ORDER BY NEWID()
				);

		SELECT @PatientIDSource = PatientIDSource
			,@LastName = LastName
			,@FirstName = FirstName
			,@MiddleInitial = MiddleInitial
		FROM Patient
		WHERE PatientID = @PatientID;

		SET @J = 1;

		WHILE (@J <= @NumEpisodesPerRecord)
		BEGIN
			SET @RequestedAdmitDate = @InsertDate;
			SET @FacilityID = (
					SELECT TOP 1 [FacilityID]
					FROM Facility
					ORDER BY NEWID()
					);

			SELECT @FacilityName = FacilityName
			FROM Facility
			WHERE FacilityID = @FacilityID;

			SET @PcpID = (
					SELECT TOP 1 ProviderID
					FROM Provider
					ORDER BY NEWID()
					);

			SELECT @PcpName = LastName + ', ' + FirstName
			FROM Provider
			WHERE ProviderID = @PcpID;

			INSERT INTO EpisodeIDSourceGenerator
			VALUES (1)

			SET @NextID = SCOPE_IDENTITY();
			SET @EpisodeIDSource = 'EPS-' + RIGHT('00000000' + CAST(@NextID AS VARCHAR(8)), 8);

			SELECT @RecordCount = COUNT(1)
			FROM Episode(NOLOCK)
			WHERE EpisodeIDSource = @EpisodeIDSource

			IF @RecordCount <> 0
			BEGIN
				EXEC @LockResult = sp_getapplock @Resource = 'CreateEpisodes'
					,@LockMode = 'Exclusive'
					,@LockOwner = 'Transaction'
					,@LockTimeout = 20000;-- Wait 20 seconds to aquire a lock.  

				IF (@LockResult < 0)
					RAISERROR (
							'Could not get exclusive lock on %s.'
							,11
							,1
							,'CreateEpisodes'
							);

				EXEC cgasp_NextEpisodeSourceID @EpisodeIDSource OUT;
			END

			-- Perform insert Statement  
			INSERT INTO [Episode]
			WITH (TABLOCK) (
					[EpisodeIDSource]
					,[PatientID]
					,[PatientIDSource]
					,[PatientLastName]
					,[PatientFirstName]
					,[PatientMiddleInitial]
					,[FacilityID]
					,[FacilityName]
					,[PcpID]
					,[PcpName]
					,[AttendingProviderID]
					,[AttendingProviderName]
					,[AdmittingProviderID]
					,[AdmittingProviderName]
					,[ReviewerID]
					,[ReviewerName]
					,[AdmitDate]
					,[RequestedAdmitDate]
					,[State]
					,[Active]
					,[CreatorID]
					,[CreatorName]
					,[DischargeUserID]
					,[DischargeUserName]
					,[RefDischargeToID]
					,[DischargeDate]
					,[RefEpisodeTypeID]
					,[LastModifiedDate]
					,[UpdateDate]
					,[InsertDate]
					,[PointOfCare]
					,[Room]
					,[Bed]
					,[Building]
					,[Floor]
					)
			VALUES (
				LTRIM(RTRIM(@EpisodeIDSource))
				,@PatientID
				,@PatientIDSource
				,@LastName
				,@FirstName
				,@MiddleInitial
				,@FacilityID
				,@FacilityName
				,@PcpID
				,@PcpName
				,@AttendingProviderID
				,@AttendingProviderName
				,@AdmittingProviderID
				,@AdmittingProviderName
				,@ReviewerID
				,@ReviewerName
				,@AdmitDate
				,@RequestedAdmitDate
				,1
				,@Active
				,@CreatorID
				,@CreatorName
				,1
				,'Bud Gack'
				,NULL
				,@InsertDate
				,@RefEpisodeTypeID
				,@InsertDate
				,@UpdateDate
				,@InsertDate
				,@PointOfCare
				,@Room
				,@Bed
				,@Building
				,@Floor
				);

			--SET @InsertError = @@ERROR;
			SET @EpisodeID = SCOPE_IDENTITY();
			
			
			print 'identity = ' + @EpisodeID;
			
			
			SET @GuidelineID = (
					SELECT TOP 1 GuidelineID
					FROM SharedContentDB.Content.Guidelines
					WHERE GuidelineType IN (
							'acg'
							,'ccc'
							,'ccg'
							,'grg'
							,'grg_cm'
							,'grg_hc'
							,'grg_rfc'
							,'loc'
							,'ltach'
							,'ocg'
							,'org'
							,'otg'
							,'rmg'
							)
					ORDER BY NEWID()
					);

			SELECT @HSIMCode = HSIM
				,@GCode = g.GuidelineCode
				,@GuidelineName = g.GuidelineTitle
				,@GuidelineTypeCode = g.GuidelineType
				,@GLOS = g.GLOS
				,@GLOSMin = g.GLOSMin
				,@GLOSMax = g.GLOSMax
				,@GLOSType = g.GLOSType
				,@ChronicCondition = g.ChronicCondition
				,@GuidelineXML = g.GuidelineXML
				,@PubTypeID = p.RefPublicationID
			FROM SharedContentDB.Content.Guidelines g
			INNER JOIN RefPublication p ON g.ProductCode = p.PubTypeCode
			WHERE GuidelineID = @GuidelineID;

			SET @Documented = 0;
			SET @AddDate = @InsertDate;
			SET @AddUserID = 1;
			SET @AddUserName = 'admin, admin';
			SET @ReviewerID = 1;
			SET @ReviewerName = 'admin, admin';
			SET @PubTypeID = 2;
			SET @Blos_A = NULL;
			SET @Blos_P = NULL;
			SET @Blos_G = NULL;
			SET @ContentVersionID = NULL;
			SET @ContentVersion = '16.0';
			SET @State = 0;
			SET @DischargeDate = NULL;
			SET @DischargeToID = NULL;
			SET @NextReviewDate = NULL;
			SET @CanDocumentTopLevelBullets = 0;

			INSERT INTO [EpisodeGuideline] (
				[EpisodeID]
				,[Documented]
				,[Active]
				,[AddDate]
				,[AddUserID]
				,[AddUserName]
				,[ReviewerID]
				,[ReviewerName]
				,[HSIMCode]
				,[GCode]
				,[GuidelineName]
				,[PubTypeID]
				,[GLOS]
				,[Blos_A]
				,[Blos_P]
				,[Blos_G]
				,[ContentVersionID]
				,[ContentVersion]
				,[State]
				,[DischargeDate]
				,[DischargeToID]
				,[UpdateDate]
				,[InsertDate]
				,[NextReviewDate]
				,[CanDocumentTopLevelBullets]
				)
			VALUES (
				@EpisodeID
				,@Documented
				,@Active
				,@AddDate
				,@AddUserID
				,@AddUserName
				,@ReviewerID
				,@ReviewerName
				,@HSIMCode
				,@GCode
				,@GuidelineName
				,@PubTypeID
				,@GLOS
				,@Blos_A
				,@Blos_P
				,@Blos_G
				,@ContentVersionID
				,@ContentVersion
				,@State
				,@DischargeDate
				,@DischargeToID
				,@InsertDate
				,@InsertDate
				,@NextReviewDate
				,@CanDocumentTopLevelBullets
				)

			EXEC [dbo].[cgasp_InsertGuidelineCache] 0
				,@ContentVersion
				,@PubTypeID
				,@GuidelineTypeCode
				,@HSIMCode
				,@GLOSMin
				,@GLOSMax
				,@GLOSType
				,@ChronicCondition
				,@sections = @GuidelineXML
				,@contentLoaded = 0
				,@active = 1
				,@Debug = 0

			PRINT @PatientIDSource + ': Episode ' + @EpisodeIDSource + ', ' + @FirstName + ' ' + @LastName + ', Guideline = ' + @GuidelineName;

			SET @J = @J + 1;
		END

		SET @I = @I + 1;
	END
END
GO


