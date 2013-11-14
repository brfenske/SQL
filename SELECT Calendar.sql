SELECT DATENAME(MONTH, GETDATE());

DECLARE @Month AS INT = MONTH (GETDATE());-- 4 --Set the MONTH for which you want to generate the Calendar.
DECLARE @Year AS INT = YEAR (GETDATE());--2013 --Set the YEAR for which you want to generate the Calendar.
	--Find and set the Start & End Date of the said Month-Year
DECLARE @StartDate AS DATETIME = CONVERT (
	VARCHAR
	, @Year
	) + RIGHT (
	'0' + CONVERT(VARCHAR, @Month)
	, 2
	) + '01'
DECLARE @EndDate AS DATETIME = DATEADD (
	DAY
	, - 1
	, DATEADD(MONTH, 1, @StartDate)
	);

WITH Dates
AS (
	SELECT @StartDate Dt
	
	UNION ALL
	
	SELECT DATEADD(DAY, 1, Dt)
	FROM Dates
	WHERE DATEADD(DAY, 1, Dt) <= @EndDate
	)
	, Details
AS (
	SELECT DAY(Dt) CDay
		, DATEPART(WK, Dt) CWeek
		, MONTH(Dt) CMonth
		, YEAR(Dt) CYear
		, DATENAME(WEEKDAY, Dt) DOW
		, Dt
	FROM Dates
	)
SELECT Sunday
	, Monday
	, Tuesday
	, Wednesday
	, Thursday
	, Friday
	, Saturday
FROM (
	SELECT CWeek
		, DOW
		, CDay
	FROM Details
	) D
PIVOT(MIN(CDay) FOR DOW IN (
			Sunday
			, Monday
			, Tuesday
			, Wednesday
			, Thursday
			, Friday
			, Saturday
			)) AS PVT
ORDER BY CWeek
