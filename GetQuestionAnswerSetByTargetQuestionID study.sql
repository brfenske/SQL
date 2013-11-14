SELECT  'Question',
        *
FROM    iCCG.Question
SELECT  'Answer',
        *
FROM    iCCG.Answer
SELECT  'QuestionAnswer',
        *
FROM    iCCG.QuestionAnswer
ORDER BY QuestionID,
        AnswerID
SELECT  'SectionQuestionAnswerGroupMember',
        *
FROM    iCCG.SectionQuestionAnswerGroupMember
SELECT  'SectionQuestionAnswerGroup',
        *
FROM    iCCG.SectionQuestionAnswerGroup
SELECT  'SectionQuestionAnswerGroup',
        *
FROM    iCCG.SectionQuestionAnswerGroup
SELECT  'SectionQuestionAnswerGroupMember',
        *
FROM    iCCG.SectionQuestionAnswerGroupMember


DECLARE @TargetQuestionID INT
SET @TargetQuestionID = 12

SELECT DISTINCT
        SQAGM.SectionQuestionAnswerGroupID,
        iCCG.Question.QuestionID,
        iCCG.Answer.AnswerID
FROM    iCCG.QASSectionQAG QQ
        JOIN iCCG.QuestionAnswerSet QAS ON QQ.QuestionAnswerSetID = QAS.QuestionAnswerSetID
        JOIN iCCG.QuestionAnswerSetMember QASM ON QAS.QuestionAnswerSetID = QASM.QuestionAnswerSetID
        JOIN iCCG.SectionQuestionAnswerGroupMember SQAGM ON QASM.SectionQuestionAnswerGroupMemberID = SQAGM.SectionQuestionAnswerGroupMemberID
        JOIN iCCG.QuestionAnswer QA ON SQAGM.QuestionAnswerID = QA.QuestionAnswerID
        JOIN iCCG.Question ON QA.QuestionID = iCCG.Question.QuestionID
        JOIN iCCG.Answer ON QA.AnswerID = iCCG.Answer.AnswerID
WHERE   SQAGM.SectionQuestionAnswerGroupID IN (SELECT DISTINCT
                                                        iCCG.SectionQuestionAnswerGroup.ParentSectionQuestionAnswerGroupID
                                               FROM     iCCG.Question
                                                        JOIN iCCG.QuestionAnswer QA ON iCCG.Question.QuestionID = QA.QuestionID
                                                        JOIN iCCG.SectionQuestionAnswerGroupMember SQAGM ON QA.QuestionAnswerID = SQAGM.QuestionAnswerID
                                                        JOIN iCCG.SectionQuestionAnswerGroup SQAG ON SQAGM.SectionQuestionAnswerGroupID = SQAG.SectionQuestionAnswerGroupID
                                               WHERE    iCCG.Question.QuestionID = @TargetQuestionID)