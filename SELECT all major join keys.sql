SELECT  iCCG.Assessment.AssessmentID
       ,iCCG.Assessment.CaseSectionID
       ,iCCG.CaseAnswer.CaseAnswerID
       ,iCCG.CaseAnswer.QuestionAnswerID
       ,iCCG.CaseSection.CaseID
       ,iCCG.CaseSection.ProgramGuidelineID
       ,iCCG.CaseSection.GuidelineSectionID
       ,iCCG.GuidelineSection.GuidelineID
       ,iCCG.GuidelineSection.SectionID
       ,iCCG.ProgramGuideline.ProgramID
       ,iCCG.QuestionAnswer.QuestionID
       ,iCCG.QuestionAnswer.AnswerID
       ,iCCG.QuestionAnswer.ParentQuestionAnswerID
       ,iCCG.Question.QuestionText
       ,iCCG.Answer.AnswerText
       ,iCCG.CaseAnswer.DecimalValue
       ,iCCG.QuestionAnswer.Ordinal AS QAOrdinal
FROM    iCCG.SectionQuestionAnswer
        INNER JOIN iCCG.QuestionAnswer ON iCCG.SectionQuestionAnswer.QuestionAnswerID = iCCG.QuestionAnswer.QuestionAnswerID
        RIGHT OUTER JOIN iCCG.Section
        INNER JOIN iCCG.GuidelineSection ON iCCG.Section.SectionID = iCCG.GuidelineSection.SectionID
        RIGHT OUTER JOIN iCCG.Assessment
        LEFT OUTER JOIN iCCG.CaseAnswer ON iCCG.Assessment.AssessmentID = iCCG.CaseAnswer.AssessmentID
        LEFT OUTER JOIN iCCG.CaseSection ON iCCG.Assessment.CaseSectionID = iCCG.CaseSection.CaseSectionID ON iCCG.GuidelineSection.GuidelineSectionID = iCCG.CaseSection.GuidelineSectionID
        LEFT OUTER JOIN iCCG.ProgramGuideline ON iCCG.CaseSection.ProgramGuidelineID = iCCG.ProgramGuideline.ProgramGuidelineID ON iCCG.QuestionAnswer.QuestionAnswerID = iCCG.CaseAnswer.QuestionAnswerID
        LEFT OUTER JOIN iCCG.Answer ON iCCG.QuestionAnswer.AnswerID = iCCG.Answer.AnswerID
        LEFT OUTER JOIN iCCG.Question ON iCCG.QuestionAnswer.QuestionID = iCCG.Question.QuestionID
ORDER BY iCCG.Section.DisplayOrder
       ,QAOrdinal