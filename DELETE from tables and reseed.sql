DELETE
FROM [dbo].ProgressionElementNote
DBCC CHECKIDENT (ProgressionElementNote, RESEED, 12345)

DELETE
FROM [dbo].DocumentedProgressionElement
DBCC CHECKIDENT (DocumentedProgressionElement, RESEED, 22345)

DELETE
FROM [dbo].CareDayInfo
DBCC CHECKIDENT (CareDayInfo, RESEED, 32345)

DELETE
FROM [dbo].ProgressionElement
DBCC CHECKIDENT (ProgressionElement, RESEED, 42345)

DELETE
FROM [dbo].Progression
DBCC CHECKIDENT (Progression, RESEED, 52345)

DELETE
FROM [dbo].PatientGroup
--DBCC CHECKIDENT (PatientGroup, RESEED, 12345)

DELETE
FROM [dbo].WorkQueue
DBCC CHECKIDENT (WorkQueue, RESEED, 62345)

DELETE
FROM [dbo].Outline
DBCC CHECKIDENT (Outline, RESEED, 72345)

DELETE
FROM [dbo].EpisodeGuideline
DBCC CHECKIDENT (EpisodeGuideline, RESEED, 82345)

DELETE
FROM [dbo].Episode
DBCC CHECKIDENT (Episode, RESEED, 92345)

DELETE
FROM [dbo].TaskPatient
DBCC CHECKIDENT (TaskPatient, RESEED, 102345)

DELETE
FROM iCCG.TaskCase
DBCC CHECKIDENT ('iCCG.TaskCase', RESEED, 112345)

DELETE
FROM iCCG.AssessmentDocumentation
DBCC CHECKIDENT ('iCCG.AssessmentDocumentation', RESEED, 122345)

DELETE
FROM iCCG.Assessment
DBCC CHECKIDENT ('iCCG.Assessment', RESEED, 132345)

DELETE
FROM iCCG.CaseProgramGuideline
DBCC CHECKIDENT ('iCCG.CaseProgramGuideline', RESEED, 142345)

DELETE
FROM iCCG.CaseProgram
DBCC CHECKIDENT ('iCCG.CaseProgram', RESEED, 152345)

DELETE
FROM iCCG.[Case]
DBCC CHECKIDENT ('iCCG.Case', RESEED, 162345)

DELETE
FROM iCCG.CaseProgram
DBCC CHECKIDENT ('iCCG.CaseProgram', RESEED, 172345)

DELETE
FROM dbo.Patient
DBCC CHECKIDENT (Patient, RESEED, 182345)
