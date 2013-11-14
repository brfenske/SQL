

SET NOCOUNT ON

--SELECT DISTINCT a.AssessmentID, cpg.CaseProgramGuidelineID, SUBSTRING(cpg.GuidelineTitle,0,15) AS GuidelineTitle, cp.CaseProgramID, c.CaseID, s.Description, t.Description, c.CaseIDSource FROM iCCG.Assessment a JOIN iCCG.CaseProgramGuideline cpg ON a.CaseProgramGuidelineID = cpg.CaseProgramGuidelineID
--JOIN iCCG.CaseProgram cp ON cpg.CaseProgramID = cp.CaseProgramID
--join iCCG.[Case] c ON cp.CaseID = c.CaseID
--JOIN iCCG.RefAssessmentStatus s ON a.StatusID = s.ID
--JOIN iCCG.RefAssessmentType t ON a.TypeID = t.ID

IF EXISTS (SELECT * FROM dbo.Episode) SELECT 'Episode', * FROM dbo.Episode
IF EXISTS (SELECT * FROM dbo.Patient) SELECT 'Patient', * FROM dbo.Patient

IF EXISTS (SELECT * FROM iCCG.Answer) SELECT 'Answer', * FROM iCCG.Answer 
IF EXISTS (SELECT * FROM iCCG.Assessment) SELECT 'Assessment', * FROM iCCG.Assessment
IF EXISTS (SELECT * FROM iCCG.AssessmentDocumentation) SELECT 'AssessmentDocumentation', * FROM iCCG.AssessmentDocumentation
IF EXISTS (SELECT * FROM iCCG.AssessmentProblem) SELECT 'AssessmentProblem', * FROM iCCG.AssessmentProblem
IF EXISTS (SELECT * FROM iCCG.Barrier) SELECT 'Barrier', * FROM iCCG.Barrier
IF EXISTS (SELECT * FROM iCCG.[Case]) SELECT '[Case]', * FROM iCCG.[Case]
IF EXISTS (SELECT * FROM iCCG.CaseBarrier) SELECT 'CaseBarrier', * FROM iCCG.CaseBarrier
IF EXISTS (SELECT * FROM iCCG.CaseContact) SELECT 'CaseContact', * FROM iCCG.CaseContact
IF EXISTS (SELECT * FROM iCCG.CaseGoal) SELECT 'CaseGoal', * FROM iCCG.CaseGoal
IF EXISTS (SELECT * FROM iCCG.CaseIntervention) SELECT 'CaseIntervention', * FROM iCCG.CaseIntervention
IF EXISTS (SELECT * FROM iCCG.CaseProblem) SELECT 'CaseProblem', * FROM iCCG.CaseProblem
IF EXISTS (SELECT * FROM iCCG.CaseProgram) SELECT 'CaseProgram', * FROM iCCG.CaseProgram
IF EXISTS (SELECT * FROM iCCG.CaseProgramGuideline) SELECT 'CaseProgramGuideline', CaseProgramGuidelineID, CaseProgramID, SUBSTRING(GuidelineTitle,0,15), HSIM, Active  FROM iCCG.CaseProgramGuideline
IF EXISTS (SELECT * FROM iCCG.Goal) SELECT 'Goal', * FROM iCCG.Goal
IF EXISTS (SELECT * FROM iCCG.GoalIntervention) SELECT 'GoalIntervention', * FROM iCCG.GoalIntervention
IF EXISTS (SELECT * FROM iCCG.GoalProblem) SELECT 'GoalProblem', * FROM iCCG.GoalProblem
IF EXISTS (SELECT * FROM iCCG.Intervention) SELECT 'Intervention', * FROM iCCG.Intervention
--IF EXISTS (SELECT * FROM iCCG.Note) SELECT 'Note', * FROM iCCG.Note
IF EXISTS (SELECT * FROM iCCG.PatientMedicine) SELECT 'PatientMedicine', * FROM iCCG.PatientMedicine
IF EXISTS (SELECT * FROM iCCG.Problem) SELECT 'Problem', * FROM iCCG.Problem
--IF EXISTS (SELECT * FROM iCCG.Program) SELECT 'Program', * FROM iCCG.Program
--IF EXISTS (SELECT * FROM iCCG.ProgramGuideline) SELECT 'ProgramGuideline', * FROM iCCG.ProgramGuideline
IF EXISTS (SELECT * FROM iCCG.QASBarrier) SELECT 'QASBarrier', * FROM iCCG.QASBarrier
IF EXISTS (SELECT * FROM iCCG.QASProblem) SELECT 'QASProblem', * FROM iCCG.QASProblem
IF EXISTS (SELECT * FROM iCCG.QASSectionQAG) SELECT 'QASSectionQAG', * FROM iCCG.QASSectionQAG --WHERE SectionQuestionAnswerGroupID = 134   --WHERE SectionQuestionAnswerGroupID = 134) 
IF EXISTS (SELECT * FROM iCCG.Question) SELECT 'Question', * FROM iCCG.Question
IF EXISTS (SELECT * FROM iCCG.QuestionAnswer) SELECT 'QuestionAnswer', * FROM iCCG.QuestionAnswer --WHERE QuestionAnswerID IN (46,47,48,49,50,51,52,53,54,55)  --WHERE QuestionAnswerID IN (46,47,48,49,50,51,52,53,54,55)) 
IF EXISTS (SELECT * FROM iCCG.QuestionAnswerSet ) SELECT 'QuestionAnswerSet', * FROM iCCG.QuestionAnswerSet 
IF EXISTS (SELECT * FROM iCCG.QuestionAnswerSetMember) SELECT 'QuestionAnswerSetMember', * FROM iCCG.QuestionAnswerSetMember --WHERE SectionQuestionAnswerGroupMemberID=39
--IF EXISTS (SELECT * FROM iCCG.RefAnswerType) SELECT 'RefAnswerType', * FROM iCCG.RefAnswerType
--IF EXISTS (SELECT * FROM iCCG.RefAssessmentStatus) SELECT 'RefAssessmentStatus', * FROM iCCG.RefAssessmentStatus
--IF EXISTS (SELECT * FROM iCCG.RefAssessmentType) SELECT 'RefAssessmentType', * FROM iCCG.RefAssessmentType
--IF EXISTS (SELECT * FROM iCCG.RefCaseStatusType) SELECT 'RefCaseStatusType', * FROM iCCG.RefCaseStatusType
--IF EXISTS (SELECT * FROM iCCG.RefClosureReason) SELECT 'RefClosureReason', * FROM iCCG.RefClosureReason
--IF EXISTS (SELECT * FROM iCCG.RefClosureReason) SELECT 'RefDuration', * FROM iCCG.RefClosureReason
--IF EXISTS (SELECT * FROM iCCG.RefFrequency) SELECT 'RefFrequency', * FROM iCCG.RefFrequency
--IF EXISTS (SELECT * FROM iCCG.RefInterventionType) SELECT 'RefInterventionType', * FROM iCCG.RefInterventionType
--IF EXISTS (SELECT * FROM iCCG.RefQuestionLogicType) SELECT 'RefQuestionLogicType', * FROM iCCG.RefQuestionLogicType
--IF EXISTS (SELECT * FROM iCCG.RefQuestionType) SELECT 'RefQuestionType', * FROM iCCG.RefQuestionType
--IF EXISTS (SELECT * FROM iCCG.RefRoute) SELECT 'RefRoute', * FROM iCCG.RefRoute
--IF EXISTS (SELECT * FROM iCCG.RefSectionType) SELECT 'RefSectionType', * FROM iCCG.RefSectionType
IF EXISTS (SELECT * FROM iCCG.SectionBarrier) SELECT 'SectionBarrier', * FROM iCCG.SectionBarrier
IF EXISTS (SELECT * FROM iCCG.SectionHierarchy) SELECT 'SectionHierarchy', * FROM iCCG.SectionHierarchy
IF EXISTS (SELECT * FROM iCCG.SectionProblem) SELECT 'SectionProblem', * FROM iCCG.SectionProblem
IF EXISTS (SELECT * FROM iCCG.SectionQuestionAnswerGroup) SELECT 'SectionQuestionAnswerGroup', * FROM iCCG.SectionQuestionAnswerGroup --WHERE SectionQuestionAnswerGroupID=15
IF EXISTS (SELECT * FROM iCCG.SectionQuestionAnswerGroupMember) SELECT 'SectionQuestionAnswerGroupMember', * FROM iCCG.SectionQuestionAnswerGroupMember --WHERE SectionQuestionAnswerGroupID=15
IF EXISTS (SELECT * FROM iCCG.Survey) SELECT 'Survey', * FROM iCCG.Survey

IF EXISTS (SELECT * FROM Platform.Contact) SELECT 'Contact', * FROM Platform.Contact

IF EXISTS (SELECT * FROM Platform.Task) SELECT 'Task', * FROM Platform.Task
IF EXISTS (SELECT * FROM dbo.TaskEpisode) SELECT 'TaskEpisode', * FROM dbo.TaskEpisode
IF EXISTS (SELECT * FROM dbo.TaskPatient) SELECT 'TaskPatient', * FROM dbo.TaskPatient
IF EXISTS (SELECT * FROM iCCG.TaskCase) SELECT 'TaskCase', * FROM iCCG.TaskCase
IF EXISTS (SELECT * FROM Platform.TaskNote) SELECT 'TaskNote', * FROM Platform.TaskNote

IF EXISTS (SELECT * FROM dbo.GuidelineCache) SELECT 'GuidelineCache', * FROM dbo.GuidelineCache
IF EXISTS (SELECT * FROM dbo.GuidelineSection) SELECT 'GuidelineSection', * FROM dbo.GuidelineSection

IF EXISTS (SELECT * FROM dbo.AppUser) SELECT 'AppUser', * FROM dbo.AppUser
