-- check for database link and create if necessary
IF NOT EXISTS (SELECT * FROM   sys.servers WHERE  name = N'sqldev1\dev2k5a')
   exec sp_addlinkedserver N'sqldev1\dev2k5a',N'SQL Server'
   exec sp_addlinkedsrvlogin N'sqldev1\dev2k5a','false',null,apputil,password1
GO


IF EXISTS ( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID( N'[dbo].[sampledata_fillpatient]' ) AND OBJECTPROPERTY( id, N'IsProcedure' ) = 1 ) 
     DROP PROCEDURE [dbo].[sampledata_fillpatient] 
GO 
 
IF EXISTS (SELECT * FROM   dbo.sysobjects WHERE  id = OBJECT_ID( N'[dbo].[sampledata_fillfacility]' ) AND OBJECTPROPERTY( id, N'IsProcedure' ) = 1 ) 
     DROP PROCEDURE [dbo].[sampledata_fillfacility] 
GO 

IF EXISTS (SELECT * FROM   dbo.sysobjects WHERE  id = OBJECT_ID( N'[dbo].[sampledata_fillprovider]' ) AND OBJECTPROPERTY( id, N'IsProcedure' ) = 1 ) 
     DROP PROCEDURE [dbo].[sampledata_fillprovider] 
GO 
 
IF EXISTS (SELECT * FROM   dbo.sysobjects WHERE  id = OBJECT_ID( N'[dbo].[sampledata_fillepisode]' ) AND OBJECTPROPERTY( id, N'IsProcedure' ) = 1 ) 
     DROP PROCEDURE [dbo].[sampledata_fillepisode] 
GO 
 
IF EXISTS (SELECT * FROM   dbo.sysobjects WHERE  id = OBJECT_ID( N'[dbo].[sampledata_fillalldata]' ) AND OBJECTPROPERTY( id, N'IsProcedure' ) = 1 ) 
     DROP PROCEDURE [dbo].[sampledata_fillalldata] 
GO 
 
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sampledata_fillpatient]
(
    @pcount   INT = 10
)
AS
    DECLARE        @v_rand         INTEGER
                  ,@v_gender       INTEGER
                  ,@v_outid        INTEGER  
                  ,@v_errcode      INTEGER
                  ,@v_count        INTEGER
                  ,@ErrorNumber    INTEGER;

    DECLARE        @v_fname        VARCHAR(50)
                  ,@v_lname        VARCHAR(100)
                  ,@v_outidsource  VARCHAR(50)
                  ,@phone1         VARCHAR(50)
                  ,@phone2         VARCHAR(50)
                  ,@socsec         VARCHAR(50)
                  ,@medrec         VARCHAR(20)
                  
    DECLARE        @DOB            DATETIME;

BEGIN
    -- disable change history trigger
    EXEC('disable TRIGGER dbo.insertpatienttrigg on patient');

    SET @v_outid = 0
    SET @v_outidsource = ''

    CREATE TABLE #fnames
    (
        id      INTeger
       ,name    VARCHAR(50)
    )

    insert into #fnames
    select * from [sqldev1\dev2k5a].app_utility.dbo.fnames
    
    CREATE TABLE #lnames 
    (
        id      INTeger
       ,name    VARCHAR(50)
    )

    insert into #lnames
    select * from [sqldev1\dev2k5a].app_utility.dbo.lnames
    
    SET @v_count = 0;
    
    -- build patients
    WHILE (@v_count < @pcount)
    BEGIN
        SELECT @v_rand = cast(rand()*999 as integer)+1

        SELECT @v_fname = name
        FROM   #fnames
        WHERE  id = @v_rand;

        IF @v_rand < 500
        BEGIN
            set @v_gender = 1;
        END
        ELSE
        BEGIN
            SET @v_gender = 2;
        END

        SELECT @v_rand = cast(rand()*999 as integer)+1

        SELECT @v_lname = name
        FROM   #lnames
        WHERE  id = @v_rand;

        -- build the random parts
        SET @dob = cast(getdate()-365*75*rand() AS DATETIME)
        SET @socsec = right('000'+cast(round(rand()*999,0) as varchar),3)+'-'+right('00'+cast(round(rand()*99,0) as varchar),2)+'-'+right('0000'+cast(round(rand()*9999,0) as varchar),4)
        SET @phone1 = '('+right('000'+cast(round(rand()*999,0) as varchar),3)+') '+right('00'+cast(round(rand()*999,0) as varchar),3)+'-'+right('0000'+cast(round(rand()*9999,0) as varchar),4)
        SET @phone2 = '('+right('000'+cast(round(rand()*999,0) as varchar),3)+') '+right('00'+cast(round(rand()*999,0) as varchar),3)+'-'+right('0000'+cast(round(rand()*9999,0) as varchar),4)
        SET @medrec = right(CONVERT(varchar(255), NEWID()),14)

        exec @v_errcode = dbo.cgasp_insertpatientandgroups
          @UserSessionID    = 0
         ,@patientID        = @v_outid
         ,@patientIDSource  = @v_outidsource
         ,@lastName         = @v_lname
         ,@firstName        = @v_fname
         ,@SalutationTypeID = ''
         ,@active           = 1
         ,@GroupID          = 1
         ,@ccgflag          = 0
         ,@isvip            = 0
         ,@dateofbirth      = @dob
         ,@genderid         = @v_gender
         ,@ssn              = @socsec
         ,@mrn              = @medrec
         ,@homePhone        = @phone1
         ,@cellPhoneNumber  = @phone2
         ,@Debug            = 1;
       
    IF ( @v_ErrCode != 0 ) 
        begin
        RAISERROR('Error', 11, 1);
        print 'Error Code is ' + cast(@v_errCode as varchar)
        end

        -- need to reset these back to null or you get a pk violation
        SET @v_outid = 0
        SET @v_outidsource = null
        
        SET @v_count = @v_count + 1
    END

    EXEC('ENABLE TRIGGER insertpatienttrigg ON patient');

END
--**************************************************************************************************
go

CREATE PROCEDURE [dbo].[sampledata_fillfacility]
(
    @pcount  INT = 10
)
AS
    DECLARE   @v_rand          INTEGER
             ,@v_count         INTEGER
             ,@v_outid         INTEGER
             ,@v_errcode       INTEGER;

    DECLARE   @v_fname         VARCHAR(100)
             ,@v_lname         VARCHAR(100)
             ,@v_outidsource   VARCHAR(50);



BEGIN

    CREATE TABLE #fnames
    (
        id      INTeger
       ,name    VARCHAR(50)
    )

    INSERT INTO #fnames
    select * from [sqldev1\dev2k5a].app_utility.dbo.facility_suff
    
    CREATE TABLE #lnames 
    (
        id      INTeger
       ,name    VARCHAR(50)
    )

    insert into #lnames
    select * from [sqldev1\dev2k5a].app_utility.dbo.lnames

    SET @v_count = 0

    WHILE (@v_count < @pcount)
    BEGIN

        SELECT @v_rand = cast(rand()*1000 as integer)+1

        SELECT @v_lname = name
        FROM   #lnames
        WHERE  id = @v_rand;

        SELECT @v_rand = cast(rand()*4 as integer)+1

        SELECT @v_fname = name
        FROM   #fnames
        WHERE  id = @v_rand;

        SET @v_lname = @v_lname + @v_fname

        EXEC @v_errcode = dbo.cgasp_insertfacilityandgroups
          @UserSessionID    = 0
         ,@facilityID       = @v_outid
         ,@facilityIDSource = @v_outidsource
         ,@facilityName     = @v_lname
         ,@active           = 1
         ,@GroupID          = 1
         ,@Debug            = 0

        -- need to reset these back to null or you get a pk violation
        SET @v_outid = null
        SET @v_outidsource = null

        IF ( @v_ErrCode != 0 ) 
        BEGIN
            RAISERROR('Error', 11, 1);
            PRINT 'Error Code is ' + cast(@v_errCode as varchar)
        END
    
        -- need to reset these back to null or you get a pk violation
        SET @v_outid = 0
        SET @v_outidsource = null
            
        SET @v_count = @v_count + 1

    END

END
--************************************************************************************************************
GO

CREATE PROCEDURE [dbo].[sampledata_fillprovider]
(
    @pcount   INT = 10
)
AS
    DECLARE   @v_rand          INTEGER
             ,@v_outid         INTEGER
             ,@v_errcode       INTEGER
             ,@v_count         INTEGER;

    DECLARE   @v_fname         VARCHAR(50)
             ,@v_lname         VARCHAR(100)
             ,@v_outidsource   VARCHAR(50);

BEGIN
    -- disable change history trigger
    CREATE TABLE #fnames
    (
        id      INTeger
       ,name    VARCHAR(50)
    )

    INSERT INTO #fnames
    select * from [sqldev1\dev2k5a].app_utility.dbo.fnames
    
    CREATE TABLE #lnames 
    (
        id      INTeger
       ,name    VARCHAR(50)
    )

    insert into #lnames
    select * from [sqldev1\dev2k5a].app_utility.dbo.lnames

    
    SET @v_count = 0

    SET @v_outid = null
    SET @v_outidsource = null


    WHILE (@v_count < @pcount)  -- build providers
    BEGIN

        SET @v_rand = cast(rand()*999 as integer) + 1
    
        SELECT @v_fname = name
        FROM   #fnames
        WHERE  id = @v_rand;
    
        SET @v_rand = cast(rand()*1000 as integer) + 1
    
        SELECT @v_lname = name
        FROM   #lnames
        WHERE  id = @v_rand;

        exec @v_errcode = cgasp_insertproviderandgroups
          @UserSessionID    = 0
         ,@providerID       = @v_outid
         ,@providerIDSource = @v_outidsource
         ,@lastName         = @v_lname
         ,@firstName        = @v_fname
         ,@active           = 1
         ,@GroupID          = 1
         ,@Debug            = 0

        -- need to reset these back to null or you get a pk violation
        SET @v_outid = null
        SET @v_outidsource = null

        SET @v_count = @v_count + 1
        
    END

END
--************************************************************************************************************
GO

CREATE PROCEDURE [dbo].[sampledata_fillepisode]
(
    @pcount   INT = 10
)
AS
    DECLARE    @v_outid                      INTEGER
              ,@v_rand                       INTEGER
              ,@v_count                      INTEGER
              ,@v_errcode                    INTEGER
              ,@v_patientcount               INTEGER
              ,@v_providercount              INTEGER
              ,@v_facilitycount              INTEGER
           -- input params for insertepisode
              ,@v_patientID                  INTEGER
              ,@v_facilityID                 INTEGER
              ,@v_pcpproviderID              INTEGER
              ,@v_attendingproviderID        INTEGER
              ,@v_admittingproviderID        INTEGER;
                                             
    DECLARE    @v_outidsource                VARCHAR(50)
           -- input params for insertepisode
              ,@v_patientIDSource            VARCHAR(100)
              ,@v_PatientLastName            VARCHAR(100)
              ,@v_patientFirstName           VARCHAR(50)
              ,@v_facilityname               VARCHAR(100)
              ,@v_pcpprovidername            VARCHAR(150)
              ,@v_attendingprovidername      VARCHAR(150)
              ,@v_admittingprovidername      VARCHAR(150);
              
    DECLARE    @admitdate                    DATETIME
              ,@rightnow                     DATETIME;


BEGIN 
    EXEC ('DISABLE TRIGGER InsertEpisodeTrigg on episode')

    SET @rightnow = getutcdate()

    CREATE TABLE #providers
    (
        id                  INTEGER identity(1,1)
       ,providerid          INTEGER 
       ,name                VARCHAR(150)
    )

    INSERT INTO #providers (providerid,name)
    select providerid,lastname+', '+firstname from dbo.provider

    SELECT @v_providercount = count(*) from #providers

    CREATE TABLE #facilities
    (
        id                  INTEGER identity(1,1)
       ,facilityid          INTEGER 
       ,facilityname        VARCHAR(100)
    )

    INSERT INTO #facilities (facilityid,facilityname)
    select facilityid,facilityname from dbo.facility

    SELECT @v_facilitycount = count(*) from #providers

    CREATE TABLE #patients
    (
        id                  INTEGER identity(1,1)
       ,patientid           INTEGER
       ,patientidsource     VARCHAR(100) 
       ,lastname            VARCHAR(100)
       ,firstname           VARCHAR(50)
    )

    INSERT INTO #patients (patientid,patientidsource,lastname,firstname)
    select patientid,patientidsource,lastname,firstname from dbo.patient

    SELECT @v_patientcount = count(*) from #patients

    SET @v_count = 0

    WHILE (@v_count < @pcount)
    BEGIN
        SET @admitdate = @rightnow - rand() * 100
         
        -- populate patient info
        SET @v_rand = CAST(rand()*@v_patientcount AS INTEGER) + 1          
        
        SELECT @v_patientid = patientid
              ,@v_patientidsource = patientidsource
              ,@v_patientlastname = lastname
              ,@v_patientfirstname = firstname
        FROM   #patients
        where  id = @v_rand
         
        -- populate facility info
        SET @v_rand = CAST(rand()*@v_facilitycount AS INTEGER) + 1          
        
        SELECT @v_facilityid = facilityid
              ,@v_facilityname = facilityname
        FROM   #facilities
        where  id = @v_rand
        
        -- populate provider info
        -- pcp first
        SET @v_rand = CAST(rand()*@v_providercount AS INTEGER) + 1          
        
        SELECT @v_pcpproviderid = providerid
              ,@v_pcpprovidername = name
        FROM   #providers
        where  id = @v_rand
        
        -- attending
        SET @v_rand = CAST(rand()*@v_providercount AS INTEGER) + 1          
        
        SELECT @v_attendingproviderid = providerid
              ,@v_attendingprovidername = name
        FROM   #providers
        where  id = @v_rand
        
        -- admitting
        SET @v_rand = CAST(rand()*@v_providercount AS INTEGER) + 1          
        
        SELECT @v_admittingproviderid = providerid
              ,@v_admittingprovidername = name
        FROM   #providers
        where  id = @v_rand
        
        
        EXEC @v_errCode = cgasp_insertepisode
           @episodeID               = @v_outid
          ,@episodeIDSource         = @v_outidsource
          ,@patientID               = @v_patientID
          ,@patientIDSource         = @v_patientIDSource
          ,@patientLastName         = @v_PatientLastName
          ,@patientFirstName        = @v_patientFirstName
          ,@facilityID              = @v_facilityID
          ,@facilityname            = @v_facilityname
          ,@pCPID                   = @v_pcpproviderid
          ,@pcpname                 = @v_pcpprovidername
          ,@attendingProviderID     = @v_attendingproviderID
          ,@attendingProviderName   = @v_attendingprovidername
          ,@admittingProviderID     = @v_admittingproviderID
          ,@admittingProviderName   = @v_admittingprovidername
          ,@admitdate               = @admitdate
          ,@active                  = 1
          ,@state                   = 1
          ,@creatorID               = 1

        -- need to reset these back to null or you get a pk violation
        SET @v_outid = null
        SET @v_outidsource = null

        SET @v_count = @v_count + 1
        
    END

    EXEC ('ENABLE TRIGGER InsertEpisodeTrigg on episode')

END
--************************************************************************************************************
GO

CREATE PROCEDURE [dbo].[sampledata_fillalldata]
(
    @patientcount      INT = 1
   ,@providercount     INT = 1
   ,@facilitycount     INT = 1
   ,@episodecount      INT = 0
)
AS
BEGIN

    EXEC sampledata_fillpatient @patientcount
    EXEC sampledata_fillprovider @providercount
    EXEC sampledata_fillfacility @facilitycount
    EXEC sampledata_fillepisode @episodecount
    
END

