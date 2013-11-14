;

WITH x
AS (
	SELECT DISTINCT wilt2.ID
		, wilt2.AddedDate AS Updated
		, dbo.udf_StripHTML(wilt2.Words) AS [SEAD Update]
		, txt.Rev
	FROM Tfs_MillimanSandbox.dbo.WorkItemLongTexts wilt2
	INNER JOIN Tfs_MillimanSandbox.dbo.Fields fld2 ON wilt2.FldID = fld2.FldID
	INNER JOIN (
		SELECT fld.[Name]
			, wilt.ID
			, wilt.Rev
		FROM Tfs_MillimanSandbox.dbo.WorkItemLongTexts wilt
		INNER JOIN Tfs_MillimanSandbox.dbo.Fields fld ON wilt.FldID = fld.FldID
		GROUP BY fld.[Name]
			, wilt.ID
			, wilt.Rev
		) txt ON txt.[Name] = fld2.[Name]
		AND txt.rev = wilt2.Rev
	WHERE fld2.NAME = 'History'
	)
SELECT c.CG_Team AS [Type of Issue]
	, c.CG_CustomerIssue_ImpactedCustomers AS Customers
	, c.System_Id AS [Issue ID]
	, c.System_Title AS Issues
	, c.System_State AS [Status]
	, c.System_CreatedDate AS Created
	, DATEDIFF(day, c.System_CreatedDate, GETDATE()) AS [Days Old]
	, c.Microsoft_VSTS_Common_Severity AS Severity
	, c.System_AssignedTo AS [Current Ownership]
	, ' ' + STUFF((
			SELECT ' ' + CONVERT(VARCHAR, x.Updated) + + CHAR(10) + '       ' + x.[SEAD Update] + CHAR(10) + CHAR(10)
			FROM x
			WHERE c.System_Id = x.ID
			ORDER BY x.Rev DESC
			FOR XML path('')
			), 1, 1, '') AS [SEAD Update]
FROM tfs_warehouse.dbo.CurrentWorkItemView c
WHERE c.System_WorkItemType = 'Customer Issue'
GROUP BY c.CG_Team
	, c.System_CreatedDate
	, c.CG_CustomerIssue_ImpactedCustomers
	, c.System_Id
	, c.System_Title
	, c.System_State
	, c.Microsoft_VSTS_Common_Severity
	, c.System_AssignedTo
ORDER BY c.Microsoft_VSTS_Common_Severity
	, c.System_CreatedDate
