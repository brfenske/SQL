SELECT     [content].Guidelines.GuidelineID, [content].Guidelines.GuidelineTitle, [content].Guidelines.ProductCode, [content].Guidelines.Version, 
                      [content].Guidelines.ContentOwner, [content].Guidelines.HSIM, [content].Guidelines.GuidelineCode, [content].Guidelines.GuidelineType, 
                      [content].Guidelines.ChronicCondition, [content].Guidelines.GLOS, [content].Guidelines.GuidelineXML, [content].Guidelines.GLOSXML, [content].Guidelines.GLOSMin, 
                      [content].Guidelines.GLOSMax, [content].Guidelines.GLOSType, [content].Guidelines.VersionMajor, [content].Guidelines.VersionMinor, [content].Sections.SectionID, 
                      [content].Sections.HSIM AS Expr1, [content].Sections.ProductCode AS Expr2, [content].Sections.ContentVersion, [content].Sections.ContentOwner AS Expr3, 
                      [content].Sections.SectionPath, [content].Sections.SectionXML, [content].Sections.ProgressionPeriod, [content].Sections.ProgressionBehavior, 
                      [content].Sections.DisplayOrder, [content].Sections.VersionMajor AS Expr4, [content].Sections.VersionMinor AS Expr5
FROM         [content].Guidelines INNER JOIN
                      [content].Sections ON [content].Guidelines.HSIM = [content].Sections.HSIM
WHERE     ([content].Guidelines.HSIM LIKE 'iccg%') AND ([content].Guidelines.GuidelineType = 'iccg_dm_lowrisk')
ORDER BY [content].Guidelines.HSIM, [content].Guidelines.GuidelineID, [content].Sections.SectionID