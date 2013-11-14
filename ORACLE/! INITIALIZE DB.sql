
INSERT  dbo.ContentEdition
        ([Name],
         DisplayName,
         Active,
         ReleaseOrder)
VALUES  ('16th Edition',
         'Milliman Care Guidelines 16th Edition',
         '1',
         '7')
GO

INSERT  dbo.ContentVersion
        (Active,
         VersionNumber,
         ActiveDate,
         SortOrder,
         ReleaseOrder,
         ContentEditionID)
VALUES  (1,
         '16.0',
         GETDATE(),
         1,
         1,
         16)
GO         
         
UPDATE  ApplicationParameter
SET     ApplicationValue = 'Milliman Care Guidelines'
WHERE   ApplicationKey = 'ClientName' 
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
VALUES  ('HM9N-HJJ4-54W7-DTHS-FC81-BD1S-TH6Q-2XFM-636PEFC-112C',
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
VALUES  (1,
         30,
         GETDATE(),
         1)
GO
PRINT 'MasterLicense inserted and associated with LicenseKey.'

DECLARE @RC INT
DECLARE @providerID INT
DECLARE @providerIDSource VARCHAR(100)
EXECUTE @RC = [dbo].[cgasp_InsertProvider] 
    0,
    @providerID OUTPUT,
    @providerIDSource OUTPUT,
    'Maynard',
    'Doc',
    'Q',
    1,
    1,
    'TYW-57298',
    1,
    2,
    3,
    '(206) 567-5747',
    '(206) 567-0000',
    '435 NE 45th',
    'STE 876',
    'Seattle',
    '98114',
    'info@maynard.com',
    '91-85737332',
    NULL,
    1,
    5,
    7,
    0
GO
PRINT 'Provider inserted.'



DECLARE @fRC INT
DECLARE @facilityID INT
DECLARE @facilityIDSource VARCHAR(100)
EXECUTE @fRC = [dbo].[cgasp_InsertFacility] 
    0,
    @facilityID OUTPUT,
    @facilityIDSource OUTPUT,
    3,
    'VM Med Center',
    'RTW-423895',
    '91-08936589',
    'Seattle',
    1,
    NULL,
    '98111',
    'info@vm.org',
    '(206) 223-6600',
    '(206) 223-9999',
    '1100 9th Ave',
    '#101',
    4,
    1
GO
PRINT 'Facility inserted.'


DECLARE @RC INT
DECLARE @UserSessionID INT
DECLARE @patientID INT
DECLARE @patientIDSource VARCHAR(100)
EXECUTE @RC = [dbo].[cgasp_InsertPatient] 
    @UserSessionID,
    @patientID OUTPUT,
    @patientIDSource OUTPUT,
    1,
    'Gack',
    'Bud',
    'R',
    1,
    '',
    '',
    1,
    '111111111',
    '10/12/1950',
    '1111 1st Ave',
    '',
    'Seattle',
    0,
    0,
    '(206)111-1111',
    '',
    '',
    '(206)111-1112',
    'Bud@email.com',
    1,
    11,
    233,
    '',
    1,
    'admin',
    1,
    'admin,admin',
    NULL,
    NULL,
    1
GO

PRINT 'Patient inserted.'

UPDATE [CareWebQIDb].[dbo].[Localization]
   SET [TimeZoneID] = 'Pacific Standard Time'
      ,[DateFormatID] = 2
      ,[TimeFormatID] = 2
      ,[StandardAbbr] = 'GMT'
      ,[DaylightAbbr] = ''
      ,[CultureName] = ''
      ,[FirstDayOfWeek] = 1
      ,[Active] = 1
 WHERE LocalizationID = 1
 
 
BEGIN TRANSACTION;
INSERT INTO [dbo].[AppUser]([LoginName], [Password], [LastName], [FirstName], [Email], [ChangePassword], [LockDate], [PasswordChangedDate], [DeactivateDate], [UnsuccessfulAttempts], [LastAttemptedDate], [Active], [UpdateDate], [CreatedDate])
SELECT N'brianf', N'brianfpassword1', N'Fenske', N'Brian', N'brian.fenske@milliman.com', 1, NULL, GETDATE(), NULL, 0, NULL, 1, GETDATE(), GETDATE()
COMMIT;
RAISERROR (N'[dbo].[AppUser]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO
