exec [dbo].[cgasp_GetAccessControlGroups] 
go
exec [dbo].[cgasp_GetAllRole] 
go
exec [dbo].[cgasp_GetUserByLoginName] @loginName='e4185071_feb3_4015_a4d4_cef36dc30968'
go
declare @p1 int
set @p1=51
exec [dbo].[cgasp_InsertUserAndAccessControlGroup] @userID=@p1 output,@loginName='e4185071_feb3_4015_a4d4_cef36dc30968',@password='e4185071_feb3_4015_a4d4_cef36dc30968fff@22',@lastName='¸6R.~?ãê>ßá''?!1ú¶Lb?',@firstName='Ã=VXeQV÷?a¦æÉâ©½Gh?',@email='',@changePassword=0,@unsuccessfulAttempts=0,@active=1,@accessControlGroupIDs='1',@reviewerID=1,@reviewerName='Admin'
select @p1
go
exec [dbo].[cgasp_DeleteUserRoleByUserID] @UserID=51,@debug=0
go
exec [dbo].[cgasp_InsertUserRole] @RoleID=1,@UserID=51,@debug=0
go
exec cgasp_GetConfigurationParameter @Debug=default
go
exec [dbo].[cgasp_UserSessionLogoutAll] @timeout=15,@debug=0
go
exec [dbo].[cgasp_GetUserByLoginName] @loginName='e4185071_feb3_4015_a4d4_cef36dc30968'
go
exec [dbo].[cgasp_GetAccessControlGroupsByUserID] @UserID=51
go
exec [dbo].[cgasp_GetRolesByUserID] @UserID=51,@debug=0
go
exec [dbo].[cgasp_GetLocalizationByPrimaryKey] @LocalizationID=0,@debug=0
go
exec [dbo].[cgasp_GetAllRefDateFormat] @debug=0
go
exec [dbo].[cgasp_GetAllRefTimeFormat] @debug=0
go
exec [dbo].[cgasp_GetUserSessionsActiveByUserID] @userID=51
go
declare @p1 int
set @p1=49
exec [dbo].[cgasp_InsertUserSession] @userSessionID=@p1 output,@userID=51,@ipAddress='127.0.0.1',@active=1
select @p1
go
exec [dbo].[cgasp_GetUserSessionByPrimaryKey] @userSessionID=49
go
declare @p1 int
set @p1=49
exec [dbo].[cgasp_InsertLoginActivity] @loginActivityID=@p1 output,@userID=0,@userName='e4185071_feb3_4015_a4d4_cef36dc30968',@iPAddress='127.0.0.1',@sessionID=49,@status=1
select @p1
go
exec [dbo].[cgasp_GetRefPages] 
go
exec [dbo].[cgasp_GetRefSessionActivities] 
go
declare @p1 int
set @p1=49
exec [dbo].[cgasp_InsertSessionActivity] @sessionActivityID=@p1 output,@pageID=2,@userSessionID=49,@patientID=0,@episodeID=0,@facilityID=0,@providerID=0,@userID=0,@appReportID=0,@activityID=2,@IsVIP=0
select @p1
go
exec [dbo].[cgasp_UpdateUser] @userID=51,@loginName='e4185071_feb3_4015_a4d4_cef36dc30968',@password='e4185071_feb3_4015_a4d4_cef36dc30968fff@22',@lastName='¸6R.~?ãê>ßá''?!1ú¶Lb?',@firstName='Ã=VXeQV÷?a¦æÉâ©½Gh?',@email='',@changePassword=0,@lockDate=default,@passwordChangedDate='2011-04-23 00:00:00:000',@deactivateDate=default,@unsuccessfulAttempts=0,@lastAttemptedDate='2011-04-23 00:50:35:000',@active=1
go
exec [dbo].[cgasp_ReleaseAllUserLocks] @userID=51
go
exec [dbo].[cgasp_GetMasterLicenseKeys] @debug=0
go
exec [dbo].[cgasp_GetMasterLicenseKeys] @debug=0
go
exec cgasp_GetApplicationParameterCollection @ApplicationKeyID=15,@Debug=0
go
exec cgasp_GetApplicationParameterCollection @ApplicationKeyID=45,@Debug=0
go
exec [dbo].[cgasp_GetMasterLicenseKeys] @debug=0
go
exec [dbo].[cgasp_GetMasterLicenseKeys] @debug=0
go
declare @p1 int
set @p1=49
exec [dbo].[cgasp_InsertLicenseKey] @licenseKeyID=@p1 output,@licenseKey='7M9T-GKPC-H9SQ-J4G6-1PUW-6LVQ-H148-S0HB-1FP6FC-1277',@active=1,@insertUserID=1,@insertUserName='admin',@insertDate=default,@debug=0
select @p1
go
declare @p1 int
set @p1=49
exec [dbo].[cgasp_InsertMasterLicense] @MasterLicenseID=@p1 output,@LicenseKeyID=49,@ApplicationKeyID=30,@InsertedByID=1,@debug=0
select @p1
go
exec [dbo].[cgasp_GetAllGroup] 
go
exec [dbo].[cgasp_GetAllAccessType] 
go
exec [dbo].[cgasp_GetAllResourceTypeBySessionID] @debug=0,@UserSessionID=49
go
declare @p2 int
set @p2=49
declare @p3 varchar(100)
set @p3='2222å*?¨uæ'
exec [dbo].[cgasp_InsertPatientAndGroups] @UserSessionID=49,@patientID=@p2 output,@patientIDSource=@p3 output,@salutationTypeID=1,@lastName='Test',@firstName='Noonin',@middleInitial='',@relationshipID=0,@otherID='',@mRN='',@genderID=0,@sSN='Test',@dateOfBirth='1970-01-10 00:00:00:000',@address1='',@address2='',@city='',@cCGFlag=0,@isVIP=0,@homePhone='',@businessPhone='',@faxNumber='',@cellPhoneNumber='',@email='',@active=1,@stateID=1,@countryID=0,@postalCode='44444',@reviewerID=0,@reviewerName='',@creatorID=1,@creatorName='Unknown',@GroupID=1,@policyStartDate=default,@policyEndDate=default,@donotContactFlag=0,@debug=0
select @p2, @p3
go
exec cgasp_GetPatientByPrimaryKey @UserSessionID=49,@PatientID=49
go
exec [dbo].[cgasp_GetAllGroup] 
go
exec [dbo].[cgasp_GetAllResourceTypeBySessionID] @debug=0,@UserSessionID=49
go
declare @p2 int
set @p2=49
declare @p3 varchar(100)
set @p3='2222FøSë?ÛõÄ'
exec [dbo].[cgasp_InsertProviderAndGroups] @UserSessionID=49,@providerID=@p2 output,@providerIDSource=@p3 output,@lastName='Test',@firstName='Doc Noonin',@middleInitial='',@titleID=1,@salutationTypeID=1,@licenseNumber='12',@specialtyID1=0,@specialtyID2=0,@specialtyID3=0,@businessPhone='',@faxPhone='',@address1='',@address2='',@city='Seattle',@postalCode='98104',@email='',@taxID='123548787',@facilityID=0,@active=1,@stateID=1,@providerTypeValue=1,@GroupID=1,@debug=0
select @p2, @p3
go
exec [dbo].[cgasp_GetAllGroup] 
go
declare @p2 int
set @p2=49
declare @p3 varchar(100)
set @p3='222222Wæn??[;'
exec [dbo].[cgasp_InsertFacilityAndGroups] @UserSessionID=49,@facilityID=@p2 output,@facilityIDSource=@p3 output,@facilityTypeValue=1,@facilityName='Test Hospital',@licenseNumber='Lic222222',@taxID='1111',@city='seattle',@active=1,@deactivatedDate=default,@postalCode='98104',@email='',@businessPhone='206-555-1212',@faxPhone='206-555-1212',@address1='12 13th St.',@address2='',@stateID=1,@GroupID=1,@Debug=0
select @p2, @p3
go
exec [dbo].[cgasp_GetFacilityByPrimaryKey] @usersessionid=49,@facilityID=49,@Debug=0
go
exec [dbo].[RefTaskPriorityRetrieveAll] @debug=0
go
exec [dbo].[RefTaskReasonRetrieveAll] @debug=0
go
exec [dbo].[RefTaskStatusRetrieveAll] @debug=0
go
exec [dbo].[RefTaskTypeRetrieveAll] @debug=0
go
exec [dbo].[cgasp_GetPatientGroupsByPatientID] @UserSessionID=49,@PatientID=49,@debug=0
go
declare @p1 int
set @p1=45
exec [dbo].[TaskInsert] @taskID=@p1 output,@typeID=1,@priorityID=1,@statusID=2,@reasonID=1,@outcomeID=0,@subject='',@notes='second one second one second one second one',@contactName='Betty',@contactDetails='Home: (206) 555-1212',@dueDate=default,@startDate='2011-04-22 00:00:00:000',@endDate='2011-05-28 17:50:35:793',@insertBy=1,@updateBy=1,@isSystemTask=0,@active=1,@debug=0
select @p1
go
declare @p1 int
set @p1=170
exec [dbo].[TaskParentInsert] @TaskParentID=@p1 output,@TaskID=45,@ParentPrimaryKeyID=49,@ParentTypeID=1,@InsertBy=1,@UpdateBy=0,@Active=1,@debug=0
select @p1
go
declare @p1 int
set @p1=171
exec [dbo].[TaskParentInsert] @TaskParentID=@p1 output,@TaskID=45,@ParentPrimaryKeyID=2,@ParentTypeID=2,@InsertBy=1,@UpdateBy=0,@Active=1,@debug=0
select @p1
go
declare @p1 int
set @p1=172
exec [dbo].[TaskParentInsert] @TaskParentID=@p1 output,@TaskID=45,@ParentPrimaryKeyID=3,@ParentTypeID=3,@InsertBy=1,@UpdateBy=0,@Active=1,@debug=0
select @p1
go
declare @p1 int
set @p1=173
exec [dbo].[TaskParentInsert] @TaskParentID=@p1 output,@TaskID=45,@ParentPrimaryKeyID=4,@ParentTypeID=4,@InsertBy=1,@UpdateBy=0,@Active=1,@debug=0
select @p1
go
exec [dbo].[RefTaskParentTypeRetrieveAll] @debug=0
go
exec [dbo].[TaskParentRetrieveByTaskID] @TaskID=45,@debug=0
go
exec [dbo].[RefTaskOutcomeRetrieve] @TaskOutcomeID=0,@debug=0
go
exec [dbo].[RefTaskParentTypeRetrieveAll] @debug=0
go
exec [dbo].[TaskParentRetrieveByTaskID] @TaskID=45,@debug=0
go
exec [dbo].[RefTaskPriorityRetrieve] @ID=1,@debug=0
go
exec [dbo].[RefTaskPriorityRetrieve] @ID=1,@debug=0
go
exec [dbo].[RefTaskReasonRetrieve] @TaskReasonID=1,@debug=0
go
exec [dbo].[RefTaskReasonRetrieve] @TaskReasonID=1,@debug=0
go
exec [dbo].[RefTaskStatusRetrieve] @TaskStatusID=2,@debug=0
go
exec [dbo].[RefTaskStatusRetrieve] @TaskStatusID=2,@debug=0
go
exec [dbo].[RefTaskTypeRetrieve] @ID=1,@debug=0
go
exec [dbo].[RefTaskTypeRetrieve] @ID=1,@debug=0
go
declare @p1 int
set @p1=44
exec [dbo].[TaskLogInsert] @TaskLogID=@p1 output,@AuditType='I',@TaskID=45,@TaskType='Reminder',@ParentType='',@ParentID=0,@PatientID=0,@PatientName='',@Priority='Urgent',@Status='In Progress',@Reason='Normal',@Outcome='',@OwnerUserName='',@AssigneeUserName='',@Subject='second one',@Notes='second one second one second one second one',@ContactName='Betty',@ContactDetails='Home: (206) 555-1212',@DueDate=default,@StartDate='2011-04-22 00:00:00:000',@EndDate='2011-05-28 17:50:35:793',@InsertBy=1,@suser_sname='',@debug=0
select @p1
go
exec [dbo].[cgasp_GetPatientGroupsByPatientID] @UserSessionID=49,@PatientID=49,@debug=0
go
declare @p1 int
set @p1=45
exec [dbo].[TaskUpdate] @TaskID=@p1 output,@TypeID=1,@PriorityID=1,@StatusID=2,@ReasonID=1,@OutcomeID=0,@Subject='',@Notes='updated updated updated updated updated updated updated ',@ContactName='Betty Lou',@ContactDetails='Home: (206) 121-5555',@DueDate=default,@StartDate='2011-04-22 00:00:00:000',@EndDate='2011-05-28 17:50:35:820',@InsertBy=1,@UpdateBy=1,@IsSystemTask=0,@Active=1,@debug=0
select @p1
go
declare @p1 int
set @p1=174
exec [dbo].[TaskParentInsert] @TaskParentID=@p1 output,@TaskID=45,@ParentPrimaryKeyID=49,@ParentTypeID=1,@InsertBy=1,@UpdateBy=0,@Active=1,@debug=0
select @p1
go
declare @p1 int
set @p1=175
exec [dbo].[TaskParentInsert] @TaskParentID=@p1 output,@TaskID=45,@ParentPrimaryKeyID=20,@ParentTypeID=2,@InsertBy=1,@UpdateBy=0,@Active=1,@debug=0
select @p1
go
declare @p1 int
set @p1=176
exec [dbo].[TaskParentInsert] @TaskParentID=@p1 output,@TaskID=45,@ParentPrimaryKeyID=30,@ParentTypeID=3,@InsertBy=1,@UpdateBy=0,@Active=1,@debug=0
select @p1
go
declare @p1 int
set @p1=177
exec [dbo].[TaskParentInsert] @TaskParentID=@p1 output,@TaskID=45,@ParentPrimaryKeyID=40,@ParentTypeID=4,@InsertBy=1,@UpdateBy=0,@Active=1,@debug=0
select @p1
go
exec [dbo].[RefTaskParentTypeRetrieveAll] @debug=0
go
exec [dbo].[TaskParentRetrieveByTaskID] @TaskID=45,@debug=0
go
exec [dbo].[RefTaskOutcomeRetrieve] @TaskOutcomeID=0,@debug=0
go
exec [dbo].[RefTaskParentTypeRetrieveAll] @debug=0
go
exec [dbo].[TaskParentRetrieveByTaskID] @TaskID=45,@debug=0
go
exec [dbo].[RefTaskPriorityRetrieve] @ID=1,@debug=0
go
exec [dbo].[RefTaskPriorityRetrieve] @ID=1,@debug=0
go
exec [dbo].[RefTaskReasonRetrieve] @TaskReasonID=1,@debug=0
go
exec [dbo].[RefTaskReasonRetrieve] @TaskReasonID=1,@debug=0
go
exec [dbo].[RefTaskStatusRetrieve] @TaskStatusID=2,@debug=0
go
exec [dbo].[RefTaskStatusRetrieve] @TaskStatusID=2,@debug=0
go
exec [dbo].[RefTaskTypeRetrieve] @ID=1,@debug=0
go
exec [dbo].[RefTaskTypeRetrieve] @ID=1,@debug=0
go
declare @p1 int
set @p1=45
exec [dbo].[TaskLogInsert] @TaskLogID=@p1 output,@AuditType='I',@TaskID=45,@TaskType='Reminder',@ParentType='',@ParentID=0,@PatientID=0,@PatientName='',@Priority='Urgent',@Status='In Progress',@Reason='Normal',@Outcome='',@OwnerUserName='',@AssigneeUserName='',@Subject='updated',@Notes='updated updated updated updated updated updated updated ',@ContactName='Betty Lou',@ContactDetails='Home: (206) 121-5555',@DueDate=default,@StartDate='2011-04-22 00:00:00:000',@EndDate='2011-05-28 17:50:35:820',@InsertBy=1,@suser_sname='',@debug=0
select @p1
go
exec [dbo].[TaskParentRetrieveByParentTypeID] @ParentTypeID=2,@debug=0
go
exec [dbo].[TaskParentRetrieveByParentPrimaryKeyID] @ParentPrimaryKeyID=2,@debug=0
go
exec [dbo].[TaskRetrieve] @TaskID=41,@debug=0
go
exec [dbo].[TaskRetrieve] @TaskID=45,@debug=0
go
exec [dbo].[RefTaskPriorityRetrieve] @ID=1,@debug=0
go
exec [dbo].[RefTaskPriorityRetrieve] @ID=1,@debug=0
go
exec [dbo].[RefTaskReasonRetrieve] @TaskReasonID=1,@debug=0
go
exec [dbo].[RefTaskReasonRetrieve] @TaskReasonID=1,@debug=0
go
exec [dbo].[RefTaskStatusRetrieve] @TaskStatusID=2,@debug=0
go
exec [dbo].[RefTaskStatusRetrieve] @TaskStatusID=2,@debug=0
go
exec [dbo].[RefTaskTypeRetrieve] @ID=1,@debug=0
go
exec [dbo].[RefTaskTypeRetrieve] @ID=1,@debug=0
go
exec [dbo].[TaskParentRetrieveByTaskID] @TaskID=45,@debug=0
go
