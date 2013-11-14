SELECT  iCCG.Question.QuestionID,
        iCCG.Question.QuestionUniqueID,
        iCCG.Question.QuestionText,
        iCCG.QuestionAnswer.QuestionAnswerID,
        iCCG.QuestionAnswer.AnswerID,
        iCCG.SectionQuestionAnswerGroupMember.SectionQuestionAnswerGroupID,
        iCCG.SectionQuestionAnswerGroupMember.SectionQuestionAnswerGroupMemberID,
        iCCG.QuestionAnswerSetMember.QuestionAnswerSetID,
        iCCG.QuestionAnswerSetMember.QuestionAnswerSetMemberID
        
FROM    iCCG.Question
        INNER JOIN iCCG.QuestionAnswer ON iCCG.Question.QuestionID = iCCG.QuestionAnswer.QuestionID
        INNER JOIN iCCG.SectionQuestionAnswerGroupMember ON iCCG.QuestionAnswer.QuestionAnswerID = iCCG.SectionQuestionAnswerGroupMember.QuestionAnswerID
        INNER JOIN iCCG.QuestionAnswerSetMember ON iCCG.SectionQuestionAnswerGroupMember.SectionQuestionAnswerGroupMemberID = iCCG.QuestionAnswerSetMember.SectionQuestionAnswerGroupMemberID
        INNER JOIN iCCG.QuestionAnswerSet ON iCCG.QuestionAnswerSetMember.QuestionAnswerSetID = iCCG.QuestionAnswerSet.QuestionAnswerSetID
ORDER BY iCCG.Question.QuestionUniqueID,
        iCCG.SectionQuestionAnswerGroupMember.SectionQuestionAnswerGroupID,
        iCCG.SectionQuestionAnswerGroupMember.SectionQuestionAnswerGroupMemberID,
        iCCG.QuestionAnswerSetMember.QuestionAnswerSetID,
        iCCG.QuestionAnswerSetMember.QuestionAnswerSetMemberID
        