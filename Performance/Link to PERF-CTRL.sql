/****** Object:  LinkedServer [PERF-CTRL]    Script Date: 07/30/2012 12:30:32 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'PERF-CTRL'
	, @srvproduct = N'SQL Server'

/* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'PERF-CTRL'
	, @useself = N'False'
	, @locallogin = NULL
	, @rmtuser = N'sa'
	, @rmtpassword = 'p@ssw0rd'
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'collation compatible'
	, @optvalue = N'false'
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'data access'
	, @optvalue = N'true'
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'dist'
	, @optvalue = N'false'
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'pub'
	, @optvalue = N'false'
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'rpc'
	, @optvalue = N'false'
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'rpc out'
	, @optvalue = N'false'
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'sub'
	, @optvalue = N'false'
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'connect timeout'
	, @optvalue = N'0'
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'collation name'
	, @optvalue = NULL
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'lazy schema validation'
	, @optvalue = N'false'
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'query timeout'
	, @optvalue = N'0'
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'use remote collation'
	, @optvalue = N'true'
GO

EXEC master.dbo.sp_serveroption @server = N'PERF-CTRL'
	, @optname = N'remote proc transaction promotion'
	, @optvalue = N'true'
GO


