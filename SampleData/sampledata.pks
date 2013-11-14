CREATE OR REPLACE PACKAGE sampledata
AS

TYPE patient_t IS RECORD (patientid        patient.patientid%TYPE
	                     ,patientidsource  patient.patientidsource%TYPE
	                     ,lastname         patient.lastname%TYPE
	                     ,firstname        patient.firstname%TYPE);

TYPE facility_t IS RECORD (facilityid        facility.facilityid%TYPE
                          ,facilityname      facility.facilityname%TYPE);

TYPE provider_t IS RECORD (providerid        provider.providerid%TYPE
                          ,providername      provider.lastname%TYPE);

--************************************************************************************************************
PROCEDURE fillpatient(p_count  IN INTEGER DEFAULT 10);
--************************************************************************************************************
PROCEDURE fillprovider(p_count  IN INTEGER DEFAULT 10);
--************************************************************************************************************
PROCEDURE fillfacility(p_count  IN INTEGER DEFAULT 10);
--************************************************************************************************************
FUNCTION getRandomPatient RETURN patient_t;
--************************************************************************************************************
FUNCTION getRandomFacility RETURN facility_t;
--************************************************************************************************************
FUNCTION getRandomProvider RETURN provider_t;
--************************************************************************************************************
PROCEDURE fillEpisode(p_count  IN INTEGER DEFAULT 10);
--************************************************************************************************************
PROCEDURE fillAllData
    (i_patientcount  IN INTEGER DEFAULT 1
    ,i_providercount  IN INTEGER DEFAULT 1
    ,i_facilitycount  IN INTEGER DEFAULT 1
    ,i_episodecount   IN INTEGER DEFAULT 0);
--************************************************************************************************************
--************************************************************************************************************
--************************************************************************************************************
--************************************************************************************************************
--************************************************************************************************************
--************************************************************************************************************
END sampledata;
/

EXIT;
