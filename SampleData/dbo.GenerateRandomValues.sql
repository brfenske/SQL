TRUNCATE TABLE RandomValues;

INSERT INTO RandomValues
SELECT TOP (10000) 'Patient'
	, p.LastName
	, p.PatientID
	from Patient p
--FROM PatientGroup pg
--INNER JOIN Episode e ON e.PatientID = pg.patientid
--INNER JOIN Patient p ON e.PatientID = p.PatientID
--WHERE pg.Groupid = 1
	--AND p.LastName <> 'Yu'
ORDER BY CHECKSUM(NEWID())

INSERT INTO RandomValues
SELECT TOP (10000) 'Episode'
	, e.EpisodeIDSource
	, e.EpisodeID
FROM PatientGroup pg
INNER JOIN Episode e ON e.PatientID = pg.patientid
WHERE pg.Groupid = 1
ORDER BY CHECKSUM(NEWID())

INSERT INTO RandomValues
SELECT TOP (10000) 'Facility'
	, f.FacilityName
	, f.FacilityID
FROM Facility f
WHERE Active = 1
ORDER BY CHECKSUM(NEWID());

INSERT INTO RandomValues
SELECT TOP (10000) 'Provider'
	, p.LastName
	, p.ProviderID
FROM Provider p
WHERE Active = 1
ORDER BY CHECKSUM(NEWID());

INSERT INTO RandomValues
SELECT TOP (10000) 'ICD9Code'
	, c.Code
	, c.SearchCodeID
FROM [Content].[SearchCode] c
WHERE CodeType = 'ICD9-D'
ORDER BY CHECKSUM(NEWID());

INSERT INTO RandomValues
SELECT TOP (10000) 'CPTCode'
	, c.Code
	, c.SearchCodeID
FROM [Content].[SearchCode] c
WHERE CodeType = 'CPT'
ORDER BY CHECKSUM(NEWID());
