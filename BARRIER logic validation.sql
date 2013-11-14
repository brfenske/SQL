SELECT  iCCG.QASBarrier.QASBarrierID,
        iCCG.QASBarrier.BarrierID,
        iCCG.QASBarrier.QuestionAnswerSetID,
        iCCG.QuestionAnswerSetMember.SectionQuestionAnswerGroupMemberID,
        iCCG.SectionQuestionAnswerGroupMember.QuestionAnswerID,
        iCCG.QuestionAnswer.QuestionID,
        iCCG.QuestionAnswer.AnswerID
FROM    iCCG.QASBarrier
        INNER JOIN iCCG.QuestionAnswerSet ON iCCG.QASBarrier.QuestionAnswerSetID = iCCG.QuestionAnswerSet.QuestionAnswerSetID
        INNER JOIN iCCG.Barrier ON iCCG.QASBarrier.BarrierID = iCCG.Barrier.BarrierID
        INNER JOIN iCCG.QuestionAnswerSetMember ON iCCG.QuestionAnswerSet.QuestionAnswerSetID = iCCG.QuestionAnswerSetMember.QuestionAnswerSetID
        INNER JOIN iCCG.SectionQuestionAnswerGroupMember ON iCCG.QuestionAnswerSetMember.SectionQuestionAnswerGroupMemberID = iCCG.SectionQuestionAnswerGroupMember.SectionQuestionAnswerGroupMemberID
        INNER JOIN iCCG.QuestionAnswer ON iCCG.SectionQuestionAnswerGroupMember.QuestionAnswerID = iCCG.QuestionAnswer.QuestionAnswerID