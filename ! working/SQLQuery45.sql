SELECT DISTINCT cs.CreationDate
	, cs.ChangeSetId
	, c.DisplayPart
	, cs.Comment
FROM tbl_ChangeSet AS cs
LEFT JOIN tbl_Identity AS i ON cs.OwnerId = i.IdentityId
LEFT JOIN Constants AS c ON i.TeamFoundationId = c.TeamFoundationId
LEFT JOIN tbl_Version AS v ON v.Versionfrom = cs.ChangeSetId
WHERE cs.CreationDate > '08/12/2013'
	AND v.fullpath LIKE '$\MCG\SourceCode\%'
ORDER BY cs.CreationDate DESC
