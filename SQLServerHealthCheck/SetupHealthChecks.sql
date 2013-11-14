USE master
GO

DROP TABLE dbo.configuration
GO

CREATE TABLE dbo.configuration (
	threshold_value DECIMAL(10, 3) NULL
	, threshold_category VARCHAR(30) NULL
	, compare_op CHAR(1) NULL
	) ON [PRIMARY]
GO

INSERT INTO configuration (
	threshold_value
	, threshold_category
	, compare_op
	)
VALUES (
	100.0
	, 'DISK_SPACE'
	, '<'
	)

INSERT INTO configuration (
	threshold_value
	, threshold_category
	, compare_op
	)
VALUES (
	90.0
	, 'HIT_RATIO'
	, '<'
	)

INSERT INTO configuration (
	threshold_value
	, threshold_category
	, compare_op
	)
VALUES (
	0
	, 'NET_ERRORS'
	, '>'
	)

INSERT INTO configuration (
	threshold_value
	, threshold_category
	, compare_op
	)
VALUES (
	999999
	, 'CPU_BUSY'
	, '>'
	)

INSERT INTO configuration (
	threshold_value
	, threshold_category
	, compare_op
	)
VALUES (
	7
	, 'BACKUP_DAYS'
	, '>'
	)

INSERT INTO configuration (
	threshold_value
	, threshold_category
	, compare_op
	)
VALUES (
	2000
	, '#CONNECTIONS'
	, '>'
	)
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.chk_cpu_busy')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.chk_cpu_busy;
GO

CREATE PROCEDURE dbo.chk_cpu_busy
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #cpubusy (cpu_err INT)

	INSERT INTO #cpubusy
	SELECT @@cpu_busy

	SELECT *
		, 'Error:******** CPU BUSY OVERLOAD DETECTED! *******' AS Errors
	FROM #cpubusy
	WHERE convert(REAL, cpu_err) > (
			SELECT threshold_value
			FROM configuration
			WHERE threshold_category = 'CPU_BUSY'
			)
END

DROP TABLE #cpubusy
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.chk_Db_Health_mssql')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.chk_Db_Health_mssql;
GO

CREATE PROCEDURE dbo.chk_Db_Health_mssql
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #DBDetails (
		dbName SYSNAME
		, dbSize VARCHAR(50)
		, dbOwner SYSNAME
		, dbId SMALLINT
		, dbCreate DATETIME
		, dbStatus VARCHAR(2000)
		, dbCmptLvl INT
		)

	INSERT INTO #DBDetails
	EXEC sp_helpdb

	SELECT *
		, '******* Error: Database need to be checked!...*****' AS Errors
	FROM #DBDetails
	WHERE (
			(CHARINDEX('ONLINE', dbStatus, 1) = 0)
			OR (CHARINDEX('READ_WRITE', dbStatus, 1) = 0)
			OR (CHARINDEX('MULTI_USER', dbStatus, 1) = 0)
			OR (CHARINDEX('IsAutoShrink', dbStatus, 1) > 0)
			)
	
	UNION ALL
	
	SELECT NAME
		, 'NA'
		, 'NA'
		, dbid
		, crdate
		, 'OFFLINE!'
		, cmptlevel
		, '******* Error: Database need to be checked!...*****'
	FROM sysdatabases
	WHERE NAME NOT IN (
			SELECT dbName
			FROM #DBDetails
			)
END

DROP TABLE #DBDetails
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.chk_disks_free_space')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.chk_disks_free_space;
GO

CREATE PROCEDURE dbo.chk_disks_free_space
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #freeDisksSpace (
		drive VARCHAR(5)
		, MBFree VARCHAR(20)
		)

	INSERT INTO #freeDisksSpace
	EXEC sys.xp_fixeddrives

	SELECT *
		, 'Error: ******** INSUFICIENT DISK SPACE *********' AS Errors
	FROM #freeDisksSpace
	WHERE convert(REAL, MBFree) < (
			SELECT threshold_value
			FROM configuration
			WHERE threshold_category = 'DISK_SPACE'
			)
END

DROP TABLE #freeDisksSpace
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.chk_mssql_error_log')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.chk_mssql_error_log;
GO

CREATE PROCEDURE dbo.chk_mssql_error_log
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #LogLines (
		Logdate DATETIME
		, ProcessInfo VARCHAR(200)
		, Msg_Text VARCHAR(2000)
		)

	INSERT INTO #LogLines
	EXEC sys.xp_readErrorLog

	SELECT *
		, '******* Error: Reported in MSSQL Log! ****' AS Errors
	FROM #LogLines
	WHERE lower(Msg_Text) LIKE '%error %'
		OR lower(Msg_Text) LIKE '% error%'
END

DROP TABLE #LogLines
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.chk_network_errors')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.chk_network_errors;
GO

CREATE PROCEDURE dbo.chk_network_errors
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #networkerr (net_err INT)

	INSERT INTO #networkerr
	SELECT @@PACKET_ERRORS

	SELECT *
		, 'Error:******** NETWORK PACKET ERRORS DETECTED! *******' AS Errors
	FROM #networkerr
	WHERE convert(REAL, net_err) < (
			SELECT threshold_value
			FROM configuration
			WHERE threshold_category = 'NET_ERRORS'
			)
END

DROP TABLE #networkerr
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.chk_tot_serv_cache_hit_ratio')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.chk_tot_serv_cache_hit_ratio;
GO

CREATE PROCEDURE dbo.chk_tot_serv_cache_hit_ratio
AS
BEGIN
	DECLARE @r REAL

	SET NOCOUNT ON

	SELECT @r = 100.0 * (
			SELECT avg(cntr_value) x
			FROM sys.dm_os_performance_counters
			WHERE counter_name = 'Buffer cache hit ratio'
			) / (
			SELECT avg(cntr_value) y
			FROM sys.dm_os_performance_counters
			WHERE counter_name = 'Buffer cache hit ratio base'
			)

	IF @r < (
			SELECT threshold_value
			FROM configuration
			WHERE threshold_category = 'HIT_RATIO'
			)
	BEGIN
		PRINT 'Error:****** cache hit ratio problem.... ' + STR(@r)
	END
END
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.chk_backup_db_status')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.chk_backup_db_status;
GO

CREATE PROCEDURE dbo.chk_backup_db_status
AS
BEGIN
	SET NOCOUNT ON

	SELECT 'Error: ******old or no backup at all! ' + s.dbname + ' days no backup=' + ' *****' AS Errors
		, s.[Days since Backup]
	FROM (
		SELECT t.NAME AS DBName
			, (COALESCE(Convert(VARCHAR(10), MAX(datediff(d, getdate(), u.backup_finish_date))), 101)) AS [Days since Backup]
		FROM SYS.DATABASES t
		LEFT JOIN msdb.dbo.BACKUPSET u ON t.NAME = u.database_name
		GROUP BY t.NAME
		) AS s
	WHERE s.dbname <> 'tempdb'
		AND s.[Days since Backup] > (
			SELECT configuration.threshold_value
			FROM configuration
			WHERE configuration.threshold_category = 'BACKUP_DAYS'
			)
END
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.chk_num_connections')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.chk_num_connections;
GO

CREATE PROCEDURE dbo.chk_num_connections
AS
BEGIN
	DECLARE @cntconn INT
	DECLARE @maxconn INT

	SET NOCOUNT ON

	SELECT @cntconn = count(*)
	FROM sysprocesses

	SELECT @maxconn = floor(threshold_value)
	FROM configuration
	WHERE threshold_category = '#CONNECTIONS'

	IF (@cntconn > @maxconn)
	BEGIN
		PRINT 'Error: ******** Num connection exceeded threshold ' + STR(@cntconn) + '*********'
	END
END
GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'dbo.chk_wrapper_mssql_health')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE dbo.chk_wrapper_mssql_health;
GO

CREATE PROCEDURE dbo.chk_wrapper_mssql_health
AS
BEGIN
	SET NOCOUNT ON

	EXECUTE dbo.chk_cpu_busy

	EXECUTE dbo.chk_Db_Health_mssql

	EXECUTE dbo.chk_disks_free_space

	EXECUTE dbo.chk_mssql_error_log

	EXECUTE dbo.chk_network_errors

	EXECUTE dbo.chk_tot_serv_cache_hit_ratio

	EXECUTE dbo.chk_backup_db_status

	EXECUTE dbo.chk_num_connections
END
GO

EXEC dbo.chk_wrapper_mssql_health
GO
