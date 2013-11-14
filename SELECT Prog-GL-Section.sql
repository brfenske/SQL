SELECT  iCCG.ProgramGuideline.ProgramID
       ,iCCG.Program.Description
       ,iCCG.ProgramGuideline.ProgramGuidelineID
       ,iCCG.ProgramGuideline.GuidelineID
       ,iCCG.GuidelineSection.GuidelineSectionID
       ,iCCG.GuidelineSection.SectionID
       ,iCCG.GuidelineSection.SectionPath
FROM    iCCG.ProgramGuideline
        INNER JOIN iCCG.Program ON iCCG.ProgramGuideline.ProgramID = iCCG.Program.ProgramID
        INNER JOIN iCCG.Guideline ON iCCG.Guideline.GuidelineID = iCCG.ProgramGuideline.GuidelineID
        INNER JOIN iCCG.GuidelineSection ON iCCG.Guideline.GuidelineID = iCCG.GuidelineSection.GuidelineID
										