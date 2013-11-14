SELECT  iCCG.Question.QuestionID,
        Question_1.QuestionText,
        iCCG.Question.QuestionUniqueID,
        iCCG.Answer.AnswerID,
        iCCG.Answer.AnswerUniqueID,
        iCCG.AnswerQuestionRef.AnswerQuestionRefID,
        Question_1.QuestionID AS Expr1,
        iCCG.Question.QuestionText AS Expr2,
        iCCG.QuestionAnswer.QuestionAnswerID,
        iCCG.SectionQuestionAnswerGroupMember.SectionQuestionAnswerGroupMemberID,
        iCCG.SectionQuestionAnswerGroupMember.SectionQuestionAnswerGroupID,
        iCCG.SectionQuestionAnswerGroup.ParentSectionQuestionAnswerGroupID,
        iCCG.SectionQuestionAnswerGroup.Depth
FROM    iCCG.Question AS Question_1
        INNER JOIN iCCG.AnswerQuestionRef ON Question_1.QuestionUniqueID = iCCG.AnswerQuestionRef.QuestionUniqueID
        RIGHT OUTER JOIN iCCG.Answer
        INNER JOIN iCCG.QuestionAnswer ON iCCG.Answer.AnswerID = iCCG.QuestionAnswer.AnswerID
        INNER JOIN iCCG.Question ON iCCG.QuestionAnswer.QuestionID = iCCG.Question.QuestionID
        INNER JOIN iCCG.SectionQuestionAnswerGroupMember ON iCCG.QuestionAnswer.QuestionAnswerID = iCCG.SectionQuestionAnswerGroupMember.QuestionAnswerID
        INNER JOIN iCCG.SectionQuestionAnswerGroup ON iCCG.SectionQuestionAnswerGroupMember.SectionQuestionAnswerGroupID = iCCG.SectionQuestionAnswerGroup.SectionQuestionAnswerGroupID ON iCCG.AnswerQuestionRef.AnswerUniqueID = iCCG.Answer.AnswerUniqueID
ORDER BY iCCG.Question.QuestionUniqueID,
        iCCG.Answer.AnswerUniqueID