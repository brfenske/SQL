IF NOT EXISTS (
		SELECT *
		FROM sys.servers
		WHERE NAME = 'PERF-CTRL'
		)
BEGIN
	EXEC master.dbo.sp_addlinkedserver @server = N'PERF-CTRL'
		,@srvproduct = N'SQL Server';

	EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'PERF-CTRL'
		,@useself = N'False'
		,@locallogin = NULL
		,@rmtuser = N'sa'
		,@rmtpassword = 'p@ssw0rd';

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'collation compatible'
		,@optvalue = N'false';

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'data access'
		,@optvalue = N'true';

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'dist'
		,@optvalue = N'false';

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'pub'
		,@optvalue = N'false';

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'rpc'
		,@optvalue = N'false';

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'rpc out'
		,@optvalue = N'false';

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'sub'
		,@optvalue = N'false';

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'connect timeout'
		,@optvalue = N'0';

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'collation name'
		,@optvalue = NULL;

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'lazy schema validation'
		,@optvalue = N'false';

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'query timeout'
		,@optvalue = N'0';

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'use remote collation'
		,@optvalue = N'true';

	EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
		,@optname = N'remote proc transaction promotion'
		,@optvalue = N'true';
END

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[RandomNumberAsString]')
			AND type IN (
				N'F'
				,N'FN'
				)
		)
	DROP FUNCTION [dbo].[RandomNumberAsString];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian
-- Create date: 7/30/12
-- Description:	Return random number with a specified number of digits
-- =============================================
CREATE FUNCTION RandomNumberAsString (
	@Number FLOAT
	,@NumDigits INT
	)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Result INT;

	SELECT @Result = LEFT(CONVERT(VARCHAR, CAST(@Number * POWER(10, @NumDigits) AS INT)) + REPLICATE('0', @NumDigits), @NumDigits);

	RETURN @Result;
END
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[RandomDate]')
			AND type IN (
				N'F'
				,N'FN'
				)
		)
	DROP FUNCTION [dbo].[RandomDate];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brian
-- Create date: 7/30/2012
-- Description:	Get a random date in the past or future
-- =============================================
CREATE FUNCTION RandomDate (
	@RandomID UNIQUEIDENTIFIER
	,@TimeFrame INT
	)
RETURNS DATETIME
AS
BEGIN
	DECLARE @Result DATETIME;
	DECLARE @DatePastFrom DATETIME;
	DECLARE @DateFutureFrom DATETIME;

	SET @DatePastFrom = '1925-01-01';
	SET @DateFutureFrom = '2014-12-31';

	IF (@TimeFrame = 0)
		-- Date from the past
		SELECT @Result = @DatePastFrom + (ABS(CAST(CAST(@RandomID AS BINARY (8)) AS INT)) % CAST((GETDATE() - @DatePastFrom) AS INT));
	ELSE
		-- Future date
		SELECT @Result = @DateFutureFrom - (ABS(CAST(CAST(@RandomID AS BINARY (8)) AS INT)) % CAST((@DateFutureFrom - GETDATE()) AS INT));

	RETURN @Result;
END
GO


