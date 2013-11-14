DECLARE @p1 INT

SET @p1 = NULL

DECLARE @p2 VARCHAR(100)

SET @p2 = ''

EXEC [dbo].[cgasp_InsertEpisode] @episodeID = @p1 OUTPUT
	,@episodeIDSource = @p2 OUTPUT
	,@patientID = 2
	,@patientIDSource = 'PAT-00000002'
	,@patientLastName = 'Harris'
	,@patientFirstName = 'Gene'
	,@patientMiddleInitial = ''
	,@facilityID = 0
	,@facilityName = ''
	,@pCPID = 0
	,@pCPName = ''
	,@attendingProviderID = 0
	,@attendingProviderName = ''
	,@admittingProviderID = 0
	,@admittingProviderName = ''
	,@reviewerID = 1
	,@reviewerName = 'Fenske, Brian'
	,@admitDate = DEFAULT
	,@requestedAdmitDate = '2012-08-03 00:00:00'
	,@state = 1
	,@active = 1
	,@creatorID = 1
	,@creatorName = 'Fenske, Brian'
	,@dischargeUserID = 0
	,@dischargeUserName = ''
	,@refDischargeToID = 0
	,@dischargeDate = DEFAULT
	,@refEpisodeTypeID = 0
	,@pointOfCare = ''
	,@room = ''
	,@bed = ''
	,@building = ''
	,@floor = ''

SELECT @p1
	,@p2

INSERT INTO [Episode] (
	[EpisodeIDSource]
	,[PatientID]
	,[PatientIDSource]
	,[PatientLastName]
	,[PatientFirstName]
	,[PatientMiddleInitial]
	,[FacilityID]
	,[FacilityName]
	,[PCPID]
	,[PCPName]
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
	LTRIM(RTRIM(@episodeIDSource))
	,@patientID
	,@patientIDSource
	,@patientLastName
	,@patientFirstName
	,@patientMiddleInitial
	,CASE 
		WHEN (@facilityID = 0)
			THEN NULL
		ELSE @facilityID
		END
	,@facilityName
	,CASE 
		WHEN (@pCPID = 0)
			THEN NULL
		ELSE @pCPID
		END
	,@pCPName
	,CASE 
		WHEN (@attendingProviderID = 0)
			THEN NULL
		ELSE @attendingProviderID
		END
	,@attendingProviderName
	,CASE 
		WHEN (@admittingProviderID = 0)
			THEN NULL
		ELSE @admittingProviderID
		END
	,@admittingProviderName
	,CASE 
		WHEN (@reviewerID = 0)
			THEN NULL
		ELSE @reviewerID
		END
	,@reviewerName
	,@admitDate
	,@requestedAdmitDate
	,@state
	,@active
	,CASE 
		WHEN (@creatorID = 0)
			THEN NULL
		ELSE @creatorID
		END
	,@creatorName
	,CASE 
		WHEN (@dischargeUserID = 0)
			THEN NULL
		ELSE @dischargeUserID
		END
	,@dischargeUserName
	,CASE 
		WHEN (@refDischargeToID = 0)
			THEN NULL
		ELSE @refDischargeToID
		END
	,@dischargeDate
	,CASE 
		WHEN (@refEpisodeTypeID = 0)
			THEN NULL
		ELSE @refEpisodeTypeID
		END
	,@rightNow
	,@rightNow
	,@rightNow
	,@pointOfCare
	,@room
	,@bed
	,@building
	,@floor
	);

INSERT INTO ChangeHistory (
	TableName
	,RowID
	,FieldName
	,Operation
	,PerformedByUser
	,PerformedByUserID
	,PerformedTime
	,OldValue
	,NewValue
	,Active
	)
SELECT 'Episode'
	,EpisodeID
	,'EpisodeIDSource'
	,'I'
	,CreatorName
	,CreatorID
	,InsertDate
	,NULL
	,EpisodeIDSource
	,1
FROM INSERTED;

DECLARE @p1 INT

SET @p1 = 203

DECLARE @p2 VARCHAR(100)

SET @p2 = 'EPS-00000018'

EXEC [dbo].[cgasp_InsertEpisode] @episodeID = @p1 OUTPUT
	,@episodeIDSource = @p2 OUTPUT
	,@patientID = 2
	,@patientIDSource = 'PAT-00000002'
	,@patientLastName = 'Harris'
	,@patientFirstName = 'Gene'
	,@patientMiddleInitial = ''
	,@facilityID = 0
	,@facilityName = ''
	,@pCPID = 0
	,@pCPName = ''
	,@attendingProviderID = 0
	,@attendingProviderName = ''
	,@admittingProviderID = 0
	,@admittingProviderName = ''
	,@reviewerID = 1
	,@reviewerName = 'Fenske, Brian'
	,@admitDate = DEFAULT
	,@requestedAdmitDate = 'Aug  3 2012 12:00:00:000AM'
	,@state = 1
	,@active = 1
	,@creatorID = 1
	,@creatorName = 'Fenske, Brian'
	,@dischargeUserID = 0
	,@dischargeUserName = ''
	,@refDischargeToID = 0
	,@dischargeDate = DEFAULT
	,@refEpisodeTypeID = 0
	,@pointOfCare = ''
	,@room = ''
	,@bed = ''
	,@building = ''
	,@floor = ''

SELECT @p1
	,@p2

INSERT INTO @esec (
	UserSessionID
	,GroupID
	,SecMask
	)
SELECT UserSessionID
	,GroupID
	,SecMask
FROM v_SessionResourceAccess
WHERE UserSessionID = @UserSessionID
	AND ResourceTypeID = @EpisodeResourceTypeID
	AND SecMask & @ReadAccessTypeBit = @ReadAccessTypeBit

INSERT INTO @resultTable
SELECT e.EpisodeID
	,isNull(psec.SecMask, 0)
	,isNull(fsec.SecMask, 0)
	,isNull(epsec.SecMask, 0) | isNull(efsec.SecMask, 0) | isNull(epcpsec.SecMask, 0) | isNull(eattndsec.SecMask, 0) | isNull(eadmitsec.SecMask, 0) | isNull(ereqsec.SecMask, 0)
FROM (
	SELECT *
	FROM Episode
	WHERE EpisodeId = @EpisodeId
	) e
INNER JOIN PatientGroup pg ON e.PatientID = pg.PatientID
LEFT JOIN AuthorizationRequest a ON a.EpisodeID = e.EpisodeID
LEFT JOIN (
	SELECT UserSessionID
		,GroupID
		,SecMask
	FROM v_SessionResourceAccess
	WHERE UserSessionID = @UserSessionID
		AND ResourceTypeID = @PatientResourceTypeID
		AND SecMask & @ReadAccessTypeBit = @ReadAccessTypeBit
	) psec ON pg.GroupID = psec.GroupID
LEFT JOIN @esec epsec ON pg.GroupID = epsec.GroupID
LEFT JOIN FacilityGroup fg ON e.FacilityID = fg.FacilityID
LEFT JOIN (
	SELECT UserSessionID
		,GroupID
		,SecMask
	FROM v_SessionResourceAccess
	WHERE UserSessionID = @UserSessionID
		AND ResourceTypeID = @FacilityResourceTypeID
		AND SecMask & @ReadAccessTypeBit = @ReadAccessTypeBit
	) fsec ON fg.GroupID = fsec.GroupID
LEFT JOIN @esec efsec ON fg.GroupID = efsec.GroupID
LEFT JOIN ProviderGroup pcpg ON e.PCPID = pcpg.ProviderID
LEFT JOIN @prsec pcpsec ON pcpg.GroupID = pcpsec.GroupID
LEFT JOIN @esec epcpsec ON pcpg.GroupID = epcpsec.GroupID
LEFT JOIN ProviderGroup attndg ON e.AttendingProviderID = attndg.ProviderID
LEFT JOIN @prsec attndsec ON attndg.GroupID = attndsec.GroupID
LEFT JOIN @esec eattndsec ON attndg.GroupID = eattndsec.GroupID
LEFT JOIN ProviderGroup admitg ON e.AdmittingProviderID = admitg.ProviderID
LEFT JOIN @prsec admitsec ON admitg.GroupID = admitsec.GroupID
LEFT JOIN @esec eadmitsec ON admitg.GroupID = eadmitsec.GroupID
LEFT JOIN ProviderGroup reqg ON a.RequestingProviderID = reqg.ProviderID
LEFT JOIN @prsec reqsec ON reqg.GroupID = reqsec.GroupID
LEFT JOIN @esec ereqsec ON reqg.GroupID = ereqsec.GroupID
WHERE isNull(psec.SecMask, 0) & @DriveAccessTypeBit = @DriveAccessTypeBit
	OR isNull(fsec.SecMask, 0) & @DriveAccessTypeBit = @DriveAccessTypeBit
	OR isNull(pcpsec.PcpSecMask, 0) & @DriveAccessTypeBit = @DriveAccessTypeBit
	OR isNull(attndsec.AttSecMask, 0) & @DriveAccessTypeBit = @DriveAccessTypeBit
	OR isNull(admitsec.AdmSecMask, 0) & @DriveAccessTypeBit = @DriveAccessTypeBit
	OR isNull(reqsec.ReqSecMask, 0) & @DriveAccessTypeBit = @DriveAccessTypeBit

EXEC [dbo].[cgasp_InsertWorkQueue] @workQueueID = 0
	,@episodeID = 203
	,@reviewerID = 1
	,@coReviewerID = 0
	,@groupReviewerID = 0
	,@routedID = 0
	,@refEpisodePendReasonID = 0
	,@refWorkQueueActionID = 1
	,@refReviewStatusID = 1
	,@routeNote = N''
	,@creatorID = 1
	,@debug = 0
