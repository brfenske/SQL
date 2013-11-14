CREATE OR REPLACE PACKAGE BODY sampledata
AS

PROCEDURE fillpatient(p_count  IN INTEGER DEFAULT 10)
AS
    TYPE lname_t IS TABLE OF lnames.name%TYPE INDEX BY PLS_INTEGER;
    TYPE fname_t IS TABLE OF fnames.name%TYPE INDEX BY PLS_INTEGER;

    tbl_lnames                 lname_t;
    tbl_fnames                 fname_t;

    v_rand                     INTEGER;
    v_gender                   INTEGER;

    v_fname                    patient.firstname%TYPE;
    v_lname                    patient.lastname%TYPE;

    -- garbage variables for output from procs
    v_outid                    INTEGER;
    v_errcode                  INTEGER;

    v_outidsource              VARCHAR2(50);

BEGIN
    -- disable change history trigger
    EXECUTE IMMEDIATE 'ALTER TRIGGER insertpatienttrigg disable';

    SELECT name bulk COLLECT
    INTO   tbl_lnames
    FROM   lnames;

    SELECT name bulk COLLECT
    INTO   tbl_fnames
    FROM   fnames;

    -- build patients
	FOR i IN 1..p_count
	LOOP

	    SELECT TRUNC(DBMS_RANDOM.value(1,1001))
	    INTO   v_rand
	    FROM   DUAL;

        v_fname := tbl_fnames(v_rand);

        IF v_rand < 500
        THEN
        	v_gender := 1;
        ELSE
        	v_gender := 2;
        END IF;

	    SELECT TRUNC(DBMS_RANDOM.value(1,1001))
	    INTO   v_rand
	    FROM   DUAL;

        v_lname := tbl_lnames(v_rand);


        cgasp_patient.insertpatientandgroups
         (i_UserSessionID    => 0
         ,o_patientID        => v_outid
         ,o_patientIDSource  => v_outidsource
         ,i_lastName         => v_lname
         ,i_firstName        => v_fname
         ,i_active           => 1
         ,i_GroupID          => 1
         ,i_ccgflag          => 0
         ,i_isvip            => 0
         ,i_dateofbirth      => SYSDATE-365*dbms_random.value(1,75)
         ,i_genderid         => v_gender
         ,i_ssn              => trunc(dbms_random.value(100,999))||'-'||trunc(dbms_random.value(10,99))||'-'||trunc(dbms_random.value(1000,9999))
         ,i_mrn              => DBMS_RANDOM.string('L',14)
         ,i_homePhone        => '('||trunc(dbms_random.value(100,999))||') '||trunc(dbms_random.value(100,999))||'-'||trunc(dbms_random.value(1000,9999))
         ,i_cellPhoneNumber  => '('||trunc(dbms_random.value(100,999))||') '||trunc(dbms_random.value(100,999))||'-'||trunc(dbms_random.value(1000,9999))
         ,i_Debug            => 0
         ,o_ErrCode          => v_errcode);

        -- need to reset these back to null or you get a pk violation
        v_outid := null;
        v_outidsource := null;

    END LOOP; -- patients

    EXECUTE IMMEDIATE 'ALTER TRIGGER insertpatienttrigg enable';

END fillpatient;
--************************************************************************************************************
PROCEDURE fillprovider(p_count  IN INTEGER DEFAULT 10)
AS
    v_rand        INTEGER;

    v_fname       provider.firstname%TYPE;
    v_lname       provider.lastname%TYPE;

    -- garbage variables for output from procs
    v_outid                    INTEGER;
    v_errcode                  INTEGER;

    v_outidsource              VARCHAR2(50);

BEGIN
    -- disable change history trigger

	FOR i IN 1..p_count  -- build providers
	LOOP

	    SELECT TRUNC(DBMS_RANDOM.value(1,1001))
	    INTO   v_rand
	    FROM   DUAL;

        SELECT name
        INTO   v_fname
        FROM   fnames
	    WHERE  id = v_rand;

	    SELECT TRUNC(DBMS_RANDOM.value(1,1001))
	    INTO   v_rand
	    FROM   DUAL;

        SELECT name
        INTO   v_lname
        FROM   lnames
	    WHERE  id = v_rand;

        cgasp_provider.insertproviderandgroups
         (i_UserSessionID    => 0
         ,o_providerID       => v_outid
         ,o_providerIDSource => v_outidsource
         ,i_lastName         => v_lname
         ,i_firstName        => v_fname
         ,i_active           => 1
         ,i_GroupID          => 1
         ,i_Debug            => 0
         ,o_ErrCode          => v_errcode);

        -- need to reset these back to null or you get a pk violation
        v_outid := null;
        v_outidsource := null;

    END LOOP; -- providers

END fillprovider;
--************************************************************************************************************
PROCEDURE fillfacility(p_count  IN INTEGER DEFAULT 10)
AS
    v_rand        INTEGER;

    v_fname       VARCHAR2(100);
    v_lname       VARCHAR2(100);

    -- garbage variables for output from procs
    v_outid                    INTEGER;
    v_errcode                  INTEGER;

    v_outidsource              VARCHAR2(50);

BEGIN
    -- disable change history trigger

	FOR i IN 1..p_count  -- build providers
	LOOP

	    SELECT TRUNC(DBMS_RANDOM.value(1,1001))
	    INTO   v_rand
	    FROM   DUAL;

        SELECT name
        INTO   v_lname
        FROM   lnames
	    WHERE  id = v_rand;

	    SELECT TRUNC(DBMS_RANDOM.value(1,5))
	    INTO   v_rand
	    FROM   DUAL;

        SELECT name
        INTO   v_fname
        FROM   facility_suff
	    WHERE  id = v_rand;

        cgasp_facility.insertfacilityandgroups
         (i_UserSessionID    => 0
         ,o_facilityID       => v_outid
         ,o_facilityIDSource => v_outidsource
         ,i_facilityName     => v_lname||v_fname
         ,i_active           => 1
         ,i_GroupID          => 1
         ,i_Debug            => 0
         ,o_ErrCode          => v_errcode);

        -- need to reset these back to null or you get a pk violation
        v_outid := null;
        v_outidsource := null;

    END LOOP; -- facilities

END fillfacility;
--************************************************************************************************************
FUNCTION getRandomPatient
RETURN patient_t
AS

    TYPE randpatient_type IS TABLE OF patient_t INDEX BY PLS_INTEGER;

    randpatient      randpatient_type;

    returntype       patient_t;

    v_count          INTEGER;

BEGIN

    SELECT patientid,patientidsource,lastname,firstname BULK COLLECT
    INTO   randpatient
    FROM   patient;

    v_count := randpatient.count;

    IF v_count > 0 THEN
        returntype := randpatient(FLOOR(DBMS_RANDOM.value(1,v_count+1)));
    END IF;

    RETURN returntype;

END getRandomPatient;
--************************************************************************************************************
FUNCTION getRandomFacility
RETURN facility_t
AS

    TYPE randfacility_type IS TABLE OF facility_t INDEX BY PLS_INTEGER;

    randfacility     randfacility_type;

    returntype       facility_t;

    v_count          INTEGER;

BEGIN

    SELECT facilityid,facilityName BULK COLLECT
    INTO   randfacility
    FROM   facility;

    v_count := randfacility.count;

    IF v_count > 0 THEN
        returntype := randfacility(FLOOR(DBMS_RANDOM.value(1,v_count+1)));
    END IF;

    RETURN returntype;

END getRandomFacility;
--************************************************************************************************************
FUNCTION getRandomProvider
RETURN Provider_t
AS

    TYPE randProvider_type IS TABLE OF Provider_t INDEX BY PLS_INTEGER;

    randProvider     randProvider_type;

    returntype       Provider_t;

    v_count          INTEGER;

BEGIN

    SELECT Providerid,lastname||','||firstname BULK COLLECT
    INTO   randProvider
    FROM   Provider;

    v_count := randProvider.count;

    IF v_count > 0 THEN
        returntype := randProvider(FLOOR(DBMS_RANDOM.value(1,v_count+1)));
    END IF;

    RETURN returntype;

END getRandomProvider;
--************************************************************************************************************
PROCEDURE fillEpisode(p_count IN INTEGER DEFAULT 10)
AS
    TYPE randpatient_type IS TABLE OF patient_t INDEX BY PLS_INTEGER;
    TYPE randProvider_type IS TABLE OF Provider_t INDEX BY PLS_INTEGER;
    TYPE randfacility_type IS TABLE OF facility_t INDEX BY PLS_INTEGER;

    randpatient                randpatient_type;
    randProvider               randProvider_type;
    randfacility               randfacility_type;

    v_outid                    INTEGER;
    v_errcode                  INTEGER;
    v_patientcount             INTEGER;
    v_providercount            INTEGER;
    v_facilitycount            INTEGER;

    v_outidsource              VARCHAR2(50);
    v_patientidsource          VARCHAR2(50);
    v_errMsg                   VARCHAR2(4000);

    v_patient                  patient_t;

    v_facility                 facility_t;

    v_attending                provider_t;
    v_admitting                provider_t;
    v_pcp                      provider_t;

BEGIN 

    EXECUTE IMMEDIATE 'ALTER TRIGGER insertepisodetrigg disable';

    -- pre load providers
    SELECT Providerid,lastname||','||firstname BULK COLLECT
    INTO   randProvider
    FROM   Provider;

    v_providercount := randProvider.count;

    -- pre load facility
    SELECT facilityid,facilityName BULK COLLECT
    INTO   randfacility
    FROM   facility;

    v_facilitycount := randfacility.count;

    -- pre load patient
    SELECT patientid,patientidsource,lastname,firstname BULK COLLECT
    INTO   randpatient
    FROM   patient;

    v_patientcount := randpatient.count;

    -- build episodes
	FOR i IN 1..p_count
	LOOP
  
        v_patient := randpatient(FLOOR(DBMS_RANDOM.value(1,v_patientcount+1)));     -- grab a random patient
        v_facility := randfacility(FLOOR(DBMS_RANDOM.value(1,v_facilitycount+1)));   -- grab a random facility
        v_attending := randProvider(FLOOR(DBMS_RANDOM.value(1,v_providercount+1)));  -- grab a random provider
        v_admitting := randProvider(FLOOR(DBMS_RANDOM.value(1,v_providercount+1)));  -- grab a random provider
        v_pcp := randProvider(FLOOR(DBMS_RANDOM.value(1,v_providercount+1)));        -- grab a random provider

        -- insert the episode
        cgasp_episode.insertepisode
          (o_episodeID               => v_outid
          ,o_episodeIDSource         => v_outidsource
          ,i_patientID               => v_patient.patientID
          ,i_patientIDSource         => v_patient.patientIDSource
          ,i_patientLastName         => v_patient.LastName
          ,i_patientFirstName        => v_patient.FirstName
          ,i_facilityID              => v_facility.facilityID
          ,i_facilityname            => v_facility.facilityname
          ,i_pCPID                   => v_pcp.providerid
          ,i_pcpname                 => v_pcp.providername
          ,i_attendingProviderID     => v_attending.providerID
          ,i_attendingProviderName   => v_attending.providername
          ,i_admittingProviderID     => v_admitting.providerID
          ,i_admittingProviderName   => v_admitting.providername
          ,i_admitdate               => SYSDATE-dbms_random.value(1,100)
          ,i_active                  => 1
          ,i_state                   => 1
          ,i_creatorID               => 1
          ,o_ErrCode                 => v_errcode
          ,o_ErrMsg                  => v_errmsg);

        -- need to reset these back to null or you get a pk violation
        v_outid := null;
        v_outidsource := null;

    END LOOP;

    EXECUTE IMMEDIATE 'ALTER TRIGGER insertepisodetrigg enable';

END fillEpisode;
--************************************************************************************************************
PROCEDURE fillAllData
    (i_patientcount  IN INTEGER DEFAULT 1
    ,i_providercount  IN INTEGER DEFAULT 1
    ,i_facilitycount  IN INTEGER DEFAULT 1
    ,i_episodecount   IN INTEGER DEFAULT 0)
AS

BEGIN
	fillpatient(i_patientcount);
	fillprovider(i_providercount);
	fillfacility(i_facilitycount);
	fillepisode(i_episodecount);
	
END fillAllData;	   
--************************************************************************************************************
--************************************************************************************************************
--************************************************************************************************************
--************************************************************************************************************
--************************************************************************************************************
--************************************************************************************************************
--************************************************************************************************************
--************************************************************************************************************
END sampledata;


