ALTER PROCEDURE dbo.GenerateEpisode
AS
BEGIN
	DECLARE @CareDayInfoID1 INT;
	DECLARE @CareDayInfoID2 INT;
	DECLARE @ChangeHistoryRowID INT;
	DECLARE @ContentVersion VARCHAR(25);
	DECLARE @EpisodeGuidelineID INT;
	DECLARE @EpisodeID INT;
	DECLARE @GCode VARCHAR(50);
	DECLARE @GLOS VARCHAR(50);
	DECLARE @Guid VARCHAR(50);
	DECLARE @GuidelineName VARCHAR(255);
	DECLARE @HSIMCode VARCHAR(25);
	DECLARE @Now DATETIME;
	DECLARE @PatientID INT;
	DECLARE @ProgressionID INT;
	DECLARE @UserID INT;
	DECLARE @UserName NVARCHAR(50);

	SET @ContentVersion = N'16.0';
	SET @GCode = 'M-157';
	SET @GLOS = 'A-1 (PO)';
	SET @Guid = ABS(CHECKSUM(NEWID()));
	SET @GuidelineName = 'Electrophysiologic Study and Implantable Cardioverter-Defibrillator (ICD) Insertion, Transvenous';
	SET @HSIMCode = '0466170b';
	SET @Now = GETUTCDATE();
	SET @UserName = @Guid;

	INSERT INTO [dbo].[AppUser] (
		[LoginName]
		,[Password]
		,[LastName]
		,[FirstName]
		,[Email]
		,[ChangePassword]
		,[LockDate]
		,[PasswordChangedDate]
		,[DeactivateDate]
		,[UnsuccessfulAttempts]
		,[LastAttemptedDate]
		,[Active]
		,[UpdateDate]
		,[CreatedDate]
		)
	VALUES (
		'User' + @Guid
		,LOWER('User' + @Guid + 'password1')
		,'First' + @Guid
		,'Last' + @Guid
		,''
		,0
		,NULL
		,@Now
		,NULL
		,0
		,NULL
		,1
		,@Now
		,@Now
		)

	SELECT @UserID = UserID
	FROM AppUser
	WHERE LoginName = 'User' + @Guid;

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,1
		,1
		,N'admin, admin'
		,@Now
		)

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,4
		,1
		,N'admin, admin'
		,@Now
		)

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,5
		,1
		,N'admin, admin'
		,@Now
		)

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,6
		,1
		,N'admin, admin'
		,@Now
		)

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,7
		,1
		,N'admin, admin'
		,@Now
		)

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,8
		,1
		,N'admin, admin'
		,@Now
		)

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,9
		,1
		,N'admin, admin'
		,@Now
		)

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,10
		,1
		,N'admin, admin'
		,@Now
		)

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,11
		,1
		,N'admin, admin'
		,@Now
		)

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,12
		,1
		,N'admin, admin'
		,@Now
		)

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,16
		,1
		,N'admin, admin'
		,@Now
		)

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,18
		,1
		,N'admin, admin'
		,@Now
		)

	INSERT INTO [dbo].[AccessControlGroupUser] (
		[UserID]
		,[AccessControlGroupID]
		,[AddUserID]
		,[AddUserName]
		,[InsertDate]
		)
	VALUES (
		@UserID
		,19
		,1
		,N'admin, admin'
		,@Now
		)

	--INSERT INTO [dbo].[AccessControlGroupUser] (
	--	[UserID]
	--	,[AccessControlGroupID]
	--	,[AddUserID]
	--	,[AddUserName]
	--	,[InsertDate]
	--	)
	--VALUES (
	--	@UserID
	--	,200
	--	,1
	--	,N'admin, admin'
	--	,@Now
	--	)

	INSERT INTO [Platform].[UserProfileRole] (
		[UserID]
		,[RefProfileRoleID]
		,[InsertDate]
		,[InsertUserID]
		)
	VALUES (
		@UserID
		,11
		,@Now
		,1
		)

	INSERT INTO [Platform].[UserProfileRole] (
		[UserID]
		,[RefProfileRoleID]
		,[InsertDate]
		,[InsertUserID]
		)
	VALUES (
		@UserID
		,12
		,@Now
		,1
		)

	INSERT INTO [Platform].[UserProfileRole] (
		[UserID]
		,[RefProfileRoleID]
		,[InsertDate]
		,[InsertUserID]
		)
	VALUES (
		@UserID
		,14
		,@Now
		,1
		)

	INSERT INTO [Platform].[UserProfileRole] (
		[UserID]
		,[RefProfileRoleID]
		,[InsertDate]
		,[InsertUserID]
		)
	VALUES (
		@UserID
		,17
		,@Now
		,1
		)

	--INSERT INTO [Platform].[UserProfileRole] (
	--	[UserID]
	--	,[RefProfileRoleID]
	--	,[InsertDate]
	--	,[InsertUserID]
	--	)
	--VALUES (
	--	@UserID
	--	,300
	--	,@Now
	--	,1
	--	)

	INSERT INTO [dbo].[UserRole] (
		[UserID]
		,[RoleID]
		)
	VALUES (
		@UserID
		,1
		)

	INSERT INTO dbo.Patient (
		PatientIDSource
		,LastName
		,FirstName
		,SSN
		,CCGFlag
		,IsVIP
		,Active
		,UpdateDate
		,InsertDate
		,ReviewerID
		,ReviewerName
		,CreatorID
		,CreatorName
		)
	VALUES (
		N'PAT-' + @Guid
		,N'LastName-' + @Guid
		,N'FirstName-' + @Guid
		,N'999-99-9999'
		,0
		,0
		,1
		,@Now
		,@Now
		,@UserID
		,@UserName
		,@UserID
		,@UserName
		);

	SELECT @PatientID = PatientID
	FROM Patient
	WHERE PatientIDSource = 'PAT-' + @Guid;

	INSERT INTO dbo.Episode (
		EpisodeIDSource
		,PatientID
		,PatientIDSource
		,PatientLastName
		,PatientFirstName
		,ReviewerID
		,ReviewerName
		,RequestedAdmitDate
		,AdmitDate
		,[State]
		,Active
		,CreatorID
		,CreatorName
		,LastModifiedDate
		,UpdateDate
		,InsertDate
		)
	VALUES (
		N'EPS-' + @Guid
		,@PatientID
		,N'PAT-' + @Guid
		,N'LastName-' + @Guid
		,N'FirstName-' + @Guid
		,@UserID
		,@UserName
		,@Now
		,@Now
		--,DATEADD(dd, 1, @Now)
		--,DATEADD(dd, 1, @Now)
		,1
		,1
		,@UserID
		,@UserName
		,@Now
		,@Now
		,@Now
		);

	SELECT @EpisodeID = EpisodeID
	FROM Episode
	WHERE EpisodeIDSource = 'EPS-' + @Guid;

	INSERT INTO dbo.EpisodeGuideline (
		EpisodeID
		,Documented
		,Active
		,AddDate
		,AddUserID
		,AddUserName
		,ReviewerID
		,ReviewerName
		,HSIMCode
		,GCode
		,GuidelineName
		,PubTypeID
		,GLOS
		,ContentVersion
		,UpdateDate
		,InsertDate
		)
	VALUES (
		@EpisodeID
		,0
		,1
		,CAST(@Now AS DATE)
		,@UserID
		,@UserName
		,@UserID
		,@UserName
		,@HSIMCode
		,@GCode
		,@GuidelineName
		,2
		,@GLOS
		,@ContentVersion
		,@Now
		,@Now
		);

	SELECT @EpisodeGuidelineID = EpisodeGuidelineID
	FROM EpisodeGuideline
	WHERE EpisodeID = @EpisodeID;

	INSERT INTO dbo.WorkQueue (
		EpisodeID
		,ReviewerUserID
		,CoReviewerUserID
		,ReviewerGroupID
		,RoutedUserID
		,RefEpisodePendReasonID
		,RefWorkQueueActionID
		,RefReviewStatusID
		,EffectiveDate
		,Active
		,RouteNote
		,InsertUserID
		,InsertDate
		,Discharged
		)
	VALUES (
		@EpisodeID
		,@UserID
		,NULL
		,NULL
		,NULL
		,NULL
		,1
		,1
		,@Now
		,0
		,NULL
		,@UserID
		,@Now
		,0
		);

	INSERT INTO dbo.WorkQueue (
		EpisodeID
		,ReviewerUserID
		,CoReviewerUserID
		,ReviewerGroupID
		,RoutedUserID
		,RefEpisodePendReasonID
		,RefWorkQueueActionID
		,RefReviewStatusID
		,EffectiveDate
		,Active
		,RouteNote
		,InsertUserID
		,InsertDate
		,Discharged
		)
	VALUES (
		@EpisodeID
		,@UserID
		,NULL
		,NULL
		,NULL
		,NULL
		,2
		,2
		,@Now
		,1
		,NULL
		,@UserID
		,@Now
		,0
		);

	INSERT INTO dbo.PatientGroup (
		GroupID
		,PatientID
		)
	VALUES (
		1
		,@PatientID
		);

	INSERT INTO dbo.Progression (
		EpisodeGuidelineID
		,SectionID
		,ReviewerID
		,ReviewerName
		,GLOSMin
		,GLOSMax
		,Active
		,Documented
		,UpdateDate
		,InsertDate
		,RefProgressionPeriodID
		,RefProgressionBehaviorID
		,SectionPath
		)
	VALUES (
		@EpisodeGuidelineID
		,NULL
		,@UserID
		,@UserName
		,1
		,1
		,1
		,1
		,@Now
		,@Now
		,3
		,2
		,'/Hospitalization/Optimal_Recovery_Course'
		);

	SELECT @ProgressionID = ProgressionID
	FROM Progression
	WHERE EpisodeGuidelineID = @EpisodeGuidelineID;

	INSERT INTO dbo.ProgressionElement (
		ProgressionID
		,CategoryID
		,ProgressionElementTypeID
		,GuidelineDay
		,[Text]
		,Active
		,SortOrder
		)
	SELECT @ProgressionID
		,1
		,3
		,1
		,N'<listitem logic_status="1" bullet_status="0"><para>Catheterization laboratory to intermediate care</para></listitem>'
		,1
		,1
	
	UNION ALL
	
	SELECT @ProgressionID
		,1
		,3
		,1
		,N'<listitem logic_status="1" bullet_status="0"><para>Discharge planning</para></listitem>'
		,1
		,2
	
	UNION ALL
	
	SELECT @ProgressionID
		,1
		,3
		,1
		,N'<listitem logic_status="1" bullet_status="0"><para>Possible discharge<footnote id="f_12040_1_28" display_value="G" cl="cl_f_7" /></para></listitem>'
		,1
		,3
	
	UNION ALL
	
	SELECT @ProgressionID
		,2
		,2
		,1
		,N'<listitem logic_status="1" bullet_status="0" type="rm"><para>Clinical Indications met<footnote id="f0466170b_mcg20051212_5" display_value="H" cl="cl_f_8" /></para></listitem>'
		,1
		,1
	
	UNION ALL
	
	SELECT @ProgressionID
		,3
		,3
		,1
		,N'<listitem logic_status="1" bullet_status="0"><para>Bed rest</para></listitem>'
		,1
		,1
	
	UNION ALL
	
	SELECT @ProgressionID
		,3
		,3
		,1
		,N'<listitem logic_status="1" bullet_status="0"><para>Limited ambulation postoperatively</para></listitem>'
		,1
		,2
	
	UNION ALL
	
	SELECT @ProgressionID
		,4
		,3
		,1
		,N'<listitem logic_status="1" bullet_status="0"><para>IV fluids, medications for procedure</para></listitem>'
		,1
		,1
	
	UNION ALL
	
	SELECT @ProgressionID
		,4
		,3
		,1
		,N'<listitem logic_status="1" bullet_status="0"><para>Oral hydration, medications, and diet as tolerated postoperatively</para></listitem>'
		,1
		,2
	
	UNION ALL
	
	SELECT @ProgressionID
		,5
		,3
		,1
		,N'<listitem logic_status="1" bullet_status="0"><para>Cardiac monitoring</para></listitem>'
		,1
		,1
	
	UNION ALL
	
	SELECT @ProgressionID
		,1
		,3
		,2
		,N'<listitem logic_status="1" bullet_status="0"><para>Intermediate care to discharge</para></listitem>'
		,1
		,1
	
	UNION ALL
	
	SELECT @ProgressionID
		,1
		,3
		,2
		,N'<listitem logic_status="1" bullet_status="0"><para>Complete discharge planning</para></listitem>'
		,1
		,2
	
	UNION ALL
	
	SELECT @ProgressionID
		,2
		,2
		,2
		,N'<listitem logic_status="1" bullet_status="0" type="rm"><para>Procedure completed</para></listitem>'
		,1
		,1
	
	UNION ALL
	
	SELECT @ProgressionID
		,2
		,2
		,2
		,N'<listitem logic_status="1" bullet_status="0" type="rm"><para>ICD functioning properly</para></listitem>'
		,1
		,2
	
	UNION ALL
	
	SELECT @ProgressionID
		,2
		,2
		,2
		,N'<listitem logic_status="1" bullet_status="0" type="rm"><para>Pneumothorax absent</para></listitem>'
		,1
		,3
	
	UNION ALL
	
	SELECT @ProgressionID
		,2
		,2
		,2
		,N'<listitem logic_status="1" bullet_status="0" type="rm"><para>Stable cardiac rhythm and puncture site</para></listitem>'
		,1
		,4
	
	UNION ALL
	
	SELECT @ProgressionID
		,2
		,2
		,2
		,N'<listitem logic_status="1" bullet_status="0" type="rm"><para>Pain absent or managed</para></listitem>'
		,1
		,5
	
	UNION ALL
	
	SELECT @ProgressionID
		,2
		,2
		,2
		,N'<listitem logic_status="1" bullet_status="0" type="rm"><para>Discharge plans and education understood</para></listitem>'
		,1
		,6
	
	UNION ALL
	
	SELECT @ProgressionID
		,3
		,2
		,2
		,N'<listitem logic_status="1" bullet_status="0" type="rm"><para>Ambulatory</para></listitem>'
		,1
		,1
	
	UNION ALL
	
	SELECT @ProgressionID
		,4
		,2
		,2
		,N'<listitem logic_status="1" bullet_status="0" type="rm"><para>Oral hydration, medications, and diet</para></listitem>'
		,1
		,1
	
	UNION ALL
	
	SELECT @ProgressionID
		,5
		,3
		,2
		,N'<listitem logic_status="1" bullet_status="0"><para>Possible EPS evaluation</para></listitem>'
		,1
		,1
	
	UNION ALL
	
	SELECT @ProgressionID
		,5
		,3
		,2
		,N'<listitem logic_status="1" bullet_status="0"><para>CXR</para></listitem>'
		,1
		,2
	
	UNION ALL
	
	SELECT @ProgressionID
		,5
		,3
		,2
		,N'<listitem logic_status="1" bullet_status="0"><para>Cardiac monitoring</para></listitem>'
		,1
		,3
	
	UNION ALL
	
	SELECT @ProgressionID
		,6
		,3
		,2
		,N'<listitem logic_status="1" bullet_status="0"><para>Possible beta-blocker or antiarrhythmic drug</para></listitem>'
		,1
		,1;

	INSERT INTO dbo.CareDayInfo (
		CareDate
		,ReviewDate
		,LevelOfCareID
		,ReviewerID
		,ReviewerName
		,AttendingProviderID
		,AttendingProviderName
		,IsProviderNotApplicable
		,Active
		,UpdateDate
		,InsertDate
		,[Status]
		,EpisodeGuidelineID
		,GuidelineDay
		,NextGuidelineDay
		,EncounterTypeID
		,ProviderTypeID
		,EncounterNumber
		,Discharge
		)
	VALUES (
		CAST(@Now AS DATE)
		,NULL
		,1
		,@UserID
		,@UserName + ', ' + @UserName
		,NULL
		,NULL
		,0
		,1
		,@Now
		,@Now
		,1
		,@EpisodeGuidelineID
		,1
		,2
		,NULL
		,NULL
		,0
		,0
		);

	SELECT @CareDayInfoID1 = CareDayInfoID
	FROM CareDayInfo
	WHERE ReviewerID = @UserID
		AND GuidelineDay = 1;

	INSERT INTO dbo.CareDayInfo (
		CareDate
		,ReviewDate
		,LevelOfCareID
		,ReviewerID
		,ReviewerName
		,AttendingProviderID
		,AttendingProviderName
		,IsProviderNotApplicable
		,Active
		,UpdateDate
		,InsertDate
		,[Status]
		,EpisodeGuidelineID
		,GuidelineDay
		,NextGuidelineDay
		,EncounterTypeID
		,ProviderTypeID
		,EncounterNumber
		,Discharge
		)
	VALUES (
		CAST(DATEADD(dd, 1, @Now) AS DATE)
		,NULL
		,1
		,@UserID
		,@UserName + ', ' + @UserName
		,NULL
		,NULL
		,0
		,1
		,@Now
		,@Now
		,1
		,@EpisodeGuidelineID
		,2
		,3
		,NULL
		,NULL
		,0
		,1
		);

	SELECT @Guid AS IDSource
		,@UserID AS AppUserID
		,@PatientID AS PatientID
		,@EpisodeID AS EpisodeID
		,@EpisodeGuidelineID AS EpisodeGuidelineID
		,@CareDayInfoID1 AS CareDayInfoID1
		,@CareDayInfoID2 AS CareDayInfoID2
		,@Now AS InsertDate;
END
