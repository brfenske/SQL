USE [iCCG]

SELECT  iCCG.Guideline.GuidelineID
       ,iCCG.GuidelineSection.GuidelineSectionID
       ,iCCG.Section.SectionID
       ,iCCG.Section.Heading
       ,iCCG.SectionQuestionAnswer.SectionQuestionAnswerID
       ,iCCG.QuestionAnswer.QuestionAnswerID
       ,iCCG.Question.QuestionID
       ,iCCG.Question.TypeID
       ,iCCG.Question.QuestionText
       ,iCCG.Answer.AnswerID
       ,iCCG.Answer.AnswerText
FROM    iCCG.Guideline
        LEFT JOIN iCCG.GuidelineSection ON iCCG.Guideline.GuidelineID = iCCG.GuidelineSection.GuidelineID
        LEFT JOIN iCCG.Section ON iCCG.GuidelineSection.SectionID = iCCG.Section.SectionID
        LEFT JOIN iCCG.SectionQuestionAnswer ON iCCG.SectionQuestionAnswer.SectionID = iCCG.Section.SectionID
        LEFT JOIN iCCG.QuestionAnswer ON iCCG.QuestionAnswer.QuestionAnswerID = iCCG.SectionQuestionAnswer.QuestionAnswerID
        LEFT JOIN iCCG.Question ON iCCG.QuestionAnswer.QuestionID = iCCG.Question.QuestionID
        LEFT JOIN iCCG.Answer ON iCCG.QuestionAnswer.AnswerID = iCCG.Answer.AnswerID
ORDER BY iCCG.Guideline.GuidelineID
       ,iCCG.GuidelineSection.GuidelineSectionID
       ,iCCG.Section.SectionID
       ,iCCG.SectionQuestionAnswer.SectionQuestionAnswerID
       ,iCCG.QuestionAnswer.QuestionAnswerID
       ,iCCG.Question.QuestionID
       ,iCCG.Answer.AnswerID
  