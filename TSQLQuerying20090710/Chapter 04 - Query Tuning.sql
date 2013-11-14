---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Querying (MSPress, 2009)
-- Chapter 04 - Query Tuning
-- Copyright Itzik Ben-Gan, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Sample Data for this Chapter
---------------------------------------------------------------------

-- Listing 4-1: Creation Script for Sample Database and Tables
SET NOCOUNT ON;
USE master;
IF DB_ID('Performance') IS NULL
  CREATE DATABASE Performance;
GO
USE Performance;
GO

-- Creating and Populating the Nums Auxiliary Table
SET NOCOUNT ON;
IF OBJECT_ID('dbo.Nums', 'U') IS NOT NULL
  DROP TABLE dbo.Nums;
CREATE TABLE dbo.Nums(n INT NOT NULL PRIMARY KEY);

DECLARE @max AS INT, @rc AS INT;
SET @max = 1000000;
SET @rc = 1;

INSERT INTO dbo.Nums(n) VALUES(1);
WHILE @rc * 2 <= @max
BEGIN
  INSERT INTO dbo.Nums(n) SELECT n + @rc FROM dbo.Nums;
  SET @rc = @rc * 2;
END

INSERT INTO dbo.Nums(n)
  SELECT n + @rc FROM dbo.Nums WHERE n + @rc <= @max;
GO

-- Drop Data Tables if Exist
IF OBJECT_ID('dbo.EmpOrders', 'V') IS NOT NULL
  DROP VIEW dbo.EmpOrders;
GO
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL
  DROP TABLE dbo.Orders;
GO
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL
  DROP TABLE dbo.Customers;
GO
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
  DROP TABLE dbo.Employees;
GO
IF OBJECT_ID('dbo.Shippers', 'U') IS NOT NULL
  DROP TABLE dbo.Shippers;
GO

-- Data Distribution Settings
DECLARE
  @numorders   AS INT,
  @numcusts    AS INT,
  @numemps     AS INT,
  @numshippers AS INT,
  @numyears    AS INT,
  @startdate   AS DATETIME;

SELECT
  @numorders   =   1000000,
  @numcusts    =     20000,
  @numemps     =       500,
  @numshippers =         5,
  @numyears    =         4,
  @startdate   = '20050101';

-- Creating and Populating the Customers Table
CREATE TABLE dbo.Customers
(
  custid   CHAR(11)     NOT NULL,
  custname NVARCHAR(50) NOT NULL
);

INSERT INTO dbo.Customers(custid, custname)
  SELECT
    'C' + RIGHT('000000000' + CAST(n AS VARCHAR(10)), 10) AS custid,
    N'Cust_' + CAST(n AS VARCHAR(10)) AS custname
  FROM dbo.Nums
  WHERE n <= @numcusts;

ALTER TABLE dbo.Customers ADD
  CONSTRAINT PK_Customers PRIMARY KEY(custid);

-- Creating and Populating the Employees Table
CREATE TABLE dbo.Employees
(
  empid     INT          NOT NULL,
  firstname NVARCHAR(25) NOT NULL,
  lastname  NVARCHAR(25) NOT NULL
);

INSERT INTO dbo.Employees(empid, firstname, lastname)
  SELECT n AS empid,
    N'Fname_' + CAST(n AS NVARCHAR(10)) AS firstname,
    N'Lname_' + CAST(n AS NVARCHAR(10)) AS lastname
  FROM dbo.Nums
  WHERE n <= @numemps;

ALTER TABLE dbo.Employees ADD
  CONSTRAINT PK_Employees PRIMARY KEY(empid);

-- Creating and Populating the Shippers Table
CREATE TABLE dbo.Shippers
(
  shipperid   VARCHAR(5)   NOT NULL,
  shippername NVARCHAR(50) NOT NULL
);

INSERT INTO dbo.Shippers(shipperid, shippername)
  SELECT shipperid, N'Shipper_' + shipperid AS shippername
  FROM (SELECT CHAR(ASCII('A') - 2 + 2 * n) AS shipperid
        FROM dbo.Nums
        WHERE n <= @numshippers) AS D;

ALTER TABLE dbo.Shippers ADD
  CONSTRAINT PK_Shippers PRIMARY KEY(shipperid);

-- Creating and Populating the Orders Table
CREATE TABLE dbo.Orders
(
  orderid   INT        NOT NULL,
  custid    CHAR(11)   NOT NULL,
  empid     INT        NOT NULL,
  shipperid VARCHAR(5) NOT NULL,
  orderdate DATETIME   NOT NULL,
  filler    CHAR(155)  NOT NULL DEFAULT('a')
);

INSERT INTO dbo.Orders(orderid, custid, empid, shipperid, orderdate)
  SELECT n AS orderid,
    'C' + RIGHT('000000000'
            + CAST(
                1 + ABS(CHECKSUM(NEWID())) % @numcusts
                AS VARCHAR(10)), 10) AS custid,
    1 + ABS(CHECKSUM(NEWID())) % @numemps AS empid,
    CHAR(ASCII('A') - 2
           + 2 * (1 + ABS(CHECKSUM(NEWID())) % @numshippers)) AS shipperid,
      DATEADD(day, n / (@numorders / (@numyears * 365.25)), @startdate)
        -- late arrival with earlier date
        - CASE WHEN n % 10 = 0
            THEN 1 + ABS(CHECKSUM(NEWID())) % 30
            ELSE 0 
          END AS orderdate
  FROM dbo.Nums
  WHERE n <= @numorders
  ORDER BY CHECKSUM(NEWID());

CREATE CLUSTERED INDEX idx_cl_od ON dbo.Orders(orderdate);

CREATE NONCLUSTERED INDEX idx_nc_sid_od_i_cid
  ON dbo.Orders(shipperid, orderdate)
  INCLUDE(custid);

CREATE UNIQUE INDEX idx_unc_od_oid_i_cid_eid
  ON dbo.Orders(orderdate, orderid)
  INCLUDE(custid, empid);

ALTER TABLE dbo.Orders ADD
  CONSTRAINT PK_Orders PRIMARY KEY NONCLUSTERED(orderid),
  CONSTRAINT FK_Orders_Customers
    FOREIGN KEY(custid)    REFERENCES dbo.Customers(custid),
  CONSTRAINT FK_Orders_Employees
    FOREIGN KEY(empid)     REFERENCES dbo.Employees(empid),
  CONSTRAINT FK_Orders_Shippers
    FOREIGN KEY(shipperid) REFERENCES dbo.Shippers(shipperid);
GO

---------------------------------------------------------------------
-- Tuning Methodology
---------------------------------------------------------------------

-- Drop clustered index
USE Performance;
DROP INDEX dbo.Orders.idx_cl_od;
GO

-- Listing 4-2: Sample Queries
SET NOCOUNT ON;
USE Performance;
GO
SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderid = 3;
GO
SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderid = 5;
GO
SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderid = 7;
GO
SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderdate = '20080212';
GO
SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderdate = '20080118';
GO
SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderdate = '20080828';
GO
SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderdate >= '20080101'
  AND orderdate < '20080201';
GO
SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderdate >= '20080401'
  AND orderdate < '20080501';
GO
SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderdate >= '20080201'
  AND orderdate < '20090301';
GO
SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderdate >= '20080501'
  AND orderdate < '20080601';
GO

---------------------------------------------------------------------
-- Analyze Waits at the Instance Level
---------------------------------------------------------------------

SELECT
  wait_type,
  waiting_tasks_count,
  wait_time_ms,
  max_wait_time_ms,
  signal_wait_time_ms
FROM sys.dm_os_wait_stats
ORDER BY wait_type;

-- Isolate top waits
WITH Waits AS
(
  SELECT
    wait_type,
    wait_time_ms / 1000. AS wait_time_s,
    100. * wait_time_ms / SUM(wait_time_ms) OVER() AS pct,
    ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS rn,
    100. * signal_wait_time_ms / wait_time_ms as signal_pct
  FROM sys.dm_os_wait_stats
  WHERE wait_time_ms > 0
    AND wait_type NOT LIKE N'%SLEEP%'
    AND wait_type NOT LIKE N'%IDLE%'
    AND wait_type NOT LIKE N'%QUEUE%'    
    AND wait_type NOT IN(  N'CLR_AUTO_EVENT'
                         , N'REQUEST_FOR_DEADLOCK_SEARCH'
                         , N'SQLTRACE_BUFFER_FLUSH'
                         /* filter out additional irrelevant waits */ )
)
SELECT
  W1.wait_type, 
  CAST(W1.wait_time_s AS NUMERIC(12, 2)) AS wait_time_s,
  CAST(W1.pct AS NUMERIC(5, 2)) AS pct,
  CAST(SUM(W2.pct) AS NUMERIC(5, 2)) AS running_pct,
  CAST(W1.signal_pct AS NUMERIC(5, 2)) AS signal_pct
FROM Waits AS W1
  JOIN Waits AS W2
    ON W2.rn <= W1.rn
GROUP BY W1.rn, W1.wait_type, W1.wait_time_s, W1.pct, W1.signal_pct
HAVING SUM(W2.pct) - W1.pct < 80 -- percentage threshold
    OR W1.rn <= 5
ORDER BY W1.rn;
GO

-- Create the WaitStats table
USE Performance;
IF OBJECT_ID('dbo.WaitStats', 'U') IS NOT NULL DROP TABLE dbo.WaitStats;

CREATE TABLE dbo.WaitStats
(
  dt                  DATETIME     NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  wait_type           NVARCHAR(60) NOT NULL,
  waiting_tasks_count BIGINT       NOT NULL,
  wait_time_ms        BIGINT       NOT NULL,
  max_wait_time_ms    BIGINT       NOT NULL,
  signal_wait_time_ms BIGINT       NOT NULL
);

CREATE UNIQUE CLUSTERED INDEX idx_dt_type ON dbo.WaitStats(dt, wait_type);
CREATE INDEX idx_type_dt ON dbo.WaitStats(wait_type, dt);

-- Load waitstats data on regular intervals
INSERT INTO Performance.dbo.WaitStats
    (wait_type, waiting_tasks_count, wait_time_ms,
     max_wait_time_ms, signal_wait_time_ms)
  SELECT
    wait_type, waiting_tasks_count, wait_time_ms,
    max_wait_time_ms, signal_wait_time_ms
  FROM sys.dm_os_wait_stats
  WHERE wait_type NOT IN (N'MISCELLANEOUS');

-- Creation script for IntervalWaits function
IF OBJECT_ID('dbo.IntervalWaits', 'IF') IS NOT NULL
  DROP FUNCTION dbo.IntervalWaits;
GO

CREATE FUNCTION dbo.IntervalWaits
  (@fromdt AS DATETIME, @todt AS DATETIME)
RETURNS TABLE
AS

RETURN
  WITH Waits AS
  (
    SELECT dt, wait_type, wait_time_ms,
      ROW_NUMBER() OVER(PARTITION BY wait_type
                        ORDER BY dt) AS rn
    FROM dbo.WaitStats
  )
  SELECT Prv.wait_type, Prv.dt AS start_time,
    CAST((Cur.wait_time_ms - Prv.wait_time_ms)
           / 1000. AS NUMERIC(12, 2)) AS interval_wait_s
  FROM Waits AS Cur
    JOIN Waits AS Prv
      ON Cur.wait_type = Prv.wait_type
      AND Cur.rn = Prv.rn + 1
      AND Prv.dt >= @fromdt
      AND Prv.dt < DATEADD(day, 1, @todt)
GO

-- Return interval waits
SELECT wait_type, start_time, interval_wait_s
FROM dbo.IntervalWaits('20090212', '20090213') AS F
ORDER BY SUM(interval_wait_s) OVER(PARTITION BY wait_type) DESC,
  wait_type, start_time;
GO

-- Prepare view for pivot table
IF OBJECT_ID('dbo.IntervalWaitsSample', 'V') IS NOT NULL
  DROP VIEW dbo.IntervalWaitsSample;
GO

CREATE VIEW dbo.IntervalWaitsSample
AS

SELECT wait_type, start_time, interval_wait_s
FROM dbo.IntervalWaits('20090212', '20090213') AS F;
GO

---------------------------------------------------------------------
-- Correlate Waits with Queues
---------------------------------------------------------------------

SELECT
  object_name,
  counter_name,
  instance_name,
  cntr_value,
  cntr_type
FROM sys.dm_os_performance_counters;

---------------------------------------------------------------------
-- Determine Course of Action
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Drill Down to the Database/File Level
---------------------------------------------------------------------

-- Analyze DB IO
WITH DBIO AS
(
  SELECT
    DB_NAME(IVFS.database_id) AS db,
    MF.type_desc,
    SUM(IVFS.num_of_bytes_read + IVFS.num_of_bytes_written) AS io_bytes,
    SUM(IVFS.io_stall) AS io_stall_ms
  FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS IVFS
    JOIN sys.master_files AS MF
      ON IVFS.database_id = MF.database_id
      AND IVFS.file_id = MF.file_id
  GROUP BY DB_NAME(IVFS.database_id), MF.type_desc
)
SELECT db, type_desc, 
  CAST(1. * io_bytes / (1024 * 1024) AS NUMERIC(12, 2)) AS io_mb,
  CAST(io_stall_ms / 1000. AS NUMERIC(12, 2)) AS io_stall_s,
  CAST(100. * io_stall_ms / SUM(io_stall_ms) OVER()
       AS NUMERIC(10, 2)) AS io_stall_pct,
  ROW_NUMBER() OVER(ORDER BY io_stall_ms DESC) AS rn
FROM DBIO
ORDER BY io_stall_ms DESC;

---------------------------------------------------------------------
-- Drill Down to the Query Level
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Trace Performance Workload
---------------------------------------------------------------------

SET NOCOUNT ON;
USE master;
GO

IF OBJECT_ID('dbo.PerfworkloadTraceStart', 'P') IS NOT NULL
  DROP PROC dbo.PerfworkloadTraceStart;
GO

CREATE PROC dbo.PerfworkloadTraceStart
  @dbid      AS INT,
  @tracefile AS NVARCHAR(245),
  @traceid   AS INT OUTPUT
AS

-- Create a Queue
DECLARE @rc          AS INT;
DECLARE @maxfilesize AS BIGINT;

SET @maxfilesize = 5;

EXEC @rc = sp_trace_create @traceid OUTPUT, 0, @tracefile, @maxfilesize, NULL 
IF (@rc != 0) GOTO error;

-- Set the events
DECLARE @on AS BIT;
SET @on = 1;

-- RPC:Completed
exec sp_trace_setevent @traceid, 10, 15, @on;
exec sp_trace_setevent @traceid, 10, 8, @on;
exec sp_trace_setevent @traceid, 10, 16, @on;
exec sp_trace_setevent @traceid, 10, 48, @on;
exec sp_trace_setevent @traceid, 10, 1, @on;
exec sp_trace_setevent @traceid, 10, 17, @on;
exec sp_trace_setevent @traceid, 10, 10, @on;
exec sp_trace_setevent @traceid, 10, 18, @on;
exec sp_trace_setevent @traceid, 10, 11, @on;
exec sp_trace_setevent @traceid, 10, 12, @on;
exec sp_trace_setevent @traceid, 10, 13, @on;
exec sp_trace_setevent @traceid, 10, 6, @on;
exec sp_trace_setevent @traceid, 10, 14, @on;

-- SP:Completed
exec sp_trace_setevent @traceid, 43, 15, @on;
exec sp_trace_setevent @traceid, 43, 8, @on;
exec sp_trace_setevent @traceid, 43, 48, @on;
exec sp_trace_setevent @traceid, 43, 1, @on;
exec sp_trace_setevent @traceid, 43, 10, @on;
exec sp_trace_setevent @traceid, 43, 11, @on;
exec sp_trace_setevent @traceid, 43, 12, @on;
exec sp_trace_setevent @traceid, 43, 13, @on;
exec sp_trace_setevent @traceid, 43, 6, @on;
exec sp_trace_setevent @traceid, 43, 14, @on;

-- SP:StmtCompleted
exec sp_trace_setevent @traceid, 45, 8, @on;
exec sp_trace_setevent @traceid, 45, 16, @on;
exec sp_trace_setevent @traceid, 45, 48, @on;
exec sp_trace_setevent @traceid, 45, 1, @on;
exec sp_trace_setevent @traceid, 45, 17, @on;
exec sp_trace_setevent @traceid, 45, 10, @on;
exec sp_trace_setevent @traceid, 45, 18, @on;
exec sp_trace_setevent @traceid, 45, 11, @on;
exec sp_trace_setevent @traceid, 45, 12, @on;
exec sp_trace_setevent @traceid, 45, 13, @on;
exec sp_trace_setevent @traceid, 45, 6, @on;
exec sp_trace_setevent @traceid, 45, 14, @on;
exec sp_trace_setevent @traceid, 45, 15, @on;

-- SQL:BatchCompleted
exec sp_trace_setevent @traceid, 12, 15, @on;
exec sp_trace_setevent @traceid, 12, 8, @on;
exec sp_trace_setevent @traceid, 12, 16, @on;
exec sp_trace_setevent @traceid, 12, 48, @on;
exec sp_trace_setevent @traceid, 12, 1, @on;
exec sp_trace_setevent @traceid, 12, 17, @on;
exec sp_trace_setevent @traceid, 12, 6, @on;
exec sp_trace_setevent @traceid, 12, 10, @on;
exec sp_trace_setevent @traceid, 12, 14, @on;
exec sp_trace_setevent @traceid, 12, 18, @on;
exec sp_trace_setevent @traceid, 12, 11, @on;
exec sp_trace_setevent @traceid, 12, 12, @on;
exec sp_trace_setevent @traceid, 12, 13, @on;

-- SQL:StmtCompleted
exec sp_trace_setevent @traceid, 41, 15, @on;
exec sp_trace_setevent @traceid, 41, 8, @on;
exec sp_trace_setevent @traceid, 41, 16, @on;
exec sp_trace_setevent @traceid, 41, 48, @on;
exec sp_trace_setevent @traceid, 41, 1, @on;
exec sp_trace_setevent @traceid, 41, 17, @on;
exec sp_trace_setevent @traceid, 41, 10, @on;
exec sp_trace_setevent @traceid, 41, 18, @on;
exec sp_trace_setevent @traceid, 41, 11, @on;
exec sp_trace_setevent @traceid, 41, 12, @on;
exec sp_trace_setevent @traceid, 41, 13, @on;
exec sp_trace_setevent @traceid, 41, 6, @on;
exec sp_trace_setevent @traceid, 41, 14, @on;

-- Set the Filters

-- Application name filter
EXEC sp_trace_setfilter @traceid, 10, 0, 7, N'SQL Server Profiler%';
-- Database ID filter
EXEC sp_trace_setfilter @traceid, 3, 0, 0, @dbid;

-- Set the trace status to start
EXEC sp_trace_setstatus @traceid, 1;

-- Print trace id and file name for future references
PRINT 'Trace ID: ' + CAST(@traceid AS VARCHAR(10))
  + ', Trace File: ''' + @tracefile + '.trc''';

GOTO finish;

error: 
PRINT 'Error Code: ' + CAST(@rc AS VARCHAR(10));

finish: 
GO

-- Start the trace
DECLARE @dbid AS INT, @traceid AS INT;
SET @dbid = DB_ID('Performance');

EXEC master.dbo.PerfworkloadTraceStart
  @dbid      = @dbid,
  @tracefile = 'c:\temp\Perfworkload 20090212',
  @traceid   = @traceid OUTPUT;
GO

-- Stop the trace (assuming trace id was 2)
EXEC sp_trace_setstatus 2, 0;
EXEC sp_trace_setstatus 2, 2;
GO

---------------------------------------------------------------------
-- Analyze Trace Data
---------------------------------------------------------------------

-- Load trace data to table
SET NOCOUNT ON;
USE Performance;
IF OBJECT_ID('dbo.Workload', 'U') IS NOT NULL DROP TABLE dbo.Workload;
GO

SELECT CAST(TextData AS NVARCHAR(MAX)) AS tsql_code,
  Duration AS duration
INTO dbo.Workload
FROM sys.fn_trace_gettable('c:\temp\Perfworkload 20090212.trc', NULL) AS T
WHERE Duration > 0
  AND EventClass IN(41, 45);
GO

-- Aggregate trace data by query
SELECT
  tsql_code,
  SUM(duration) AS total_duration
FROM dbo.Workload
GROUP BY tsql_code;

-- Aggregate trace data by query prefix
SELECT
  SUBSTRING(tsql_code, 1, 100) AS tsql_code,
  SUM(duration) AS total_duration
FROM dbo.Workload
GROUP BY SUBSTRING(tsql_code, 1, 100);

-- Adjust substring length
SELECT
  SUBSTRING(tsql_code, 1, 94) AS tsql_code,
  SUM(duration) AS total_duration
FROM dbo.Workload
GROUP BY SUBSTRING(tsql_code, 1, 94);

-- Query Signature

-- Query template
DECLARE @my_templatetext AS NVARCHAR(MAX);
DECLARE @my_parameters   AS NVARCHAR(MAX);

EXEC sp_get_query_template 
  N'SELECT * FROM dbo.T1 WHERE col1 = 3 AND col2 > 78',
  @my_templatetext OUTPUT,
  @my_parameters OUTPUT;

SELECT @my_templatetext AS querysig, @my_parameters AS params;
GO

-- Creation Script for the SQLSig UDF
IF OBJECT_ID('dbo.SQLSig', 'FN') IS NOT NULL
  DROP FUNCTION dbo.SQLSig;
GO

CREATE FUNCTION dbo.SQLSig 
  (@p1 NTEXT, @parselength INT = 4000)
RETURNS NVARCHAR(4000)

--
-- This function is provided "AS IS" with no warranties,
-- and confers no rights. 
-- Use of included script samples are subject to the terms specified at
-- http://www.microsoft.com/info/cpyright.htm
-- 
-- Strips query strings
AS
BEGIN 
  DECLARE @pos AS INT;
  DECLARE @mode AS CHAR(10);
  DECLARE @maxlength AS INT;
  DECLARE @p2 AS NCHAR(4000);
  DECLARE @currchar AS CHAR(1), @nextchar AS CHAR(1);
  DECLARE @p2len AS INT;

  SET @maxlength = LEN(RTRIM(SUBSTRING(@p1,1,4000)));
  SET @maxlength = CASE WHEN @maxlength > @parselength 
                     THEN @parselength ELSE @maxlength END;
  SET @pos = 1;
  SET @p2 = '';
  SET @p2len = 0;
  SET @currchar = '';
  set @nextchar = '';
  SET @mode = 'command';

  WHILE (@pos <= @maxlength)
  BEGIN
    SET @currchar = SUBSTRING(@p1,@pos,1);
    SET @nextchar = SUBSTRING(@p1,@pos+1,1);
    IF @mode = 'command'
    BEGIN
      SET @p2 = LEFT(@p2,@p2len) + @currchar;
      SET @p2len = @p2len + 1 ;
      IF @currchar IN (',','(',' ','=','<','>','!')
        AND @nextchar BETWEEN '0' AND '9'
      BEGIN
        SET @mode = 'number';
        SET @p2 = LEFT(@p2,@p2len) + '#';
        SET @p2len = @p2len + 1;
      END 
      IF @currchar = ''''
      BEGIN
        SET @mode = 'literal';
        SET @p2 = LEFT(@p2,@p2len) + '#''';
        SET @p2len = @p2len + 2;
      END
    END
    ELSE IF @mode = 'number' AND @nextchar IN (',',')',' ','=','<','>','!')
      SET @mode= 'command';
    ELSE IF @mode = 'literal' AND @currchar = ''''
      SET @mode= 'command';

    SET @pos = @pos + 1;
  END
  RETURN @p2;
END
GO

-- Test SQLSig Function
SELECT dbo.SQLSig
  (N'SELECT * FROM dbo.T1 WHERE col1 = 3 AND col2 > 78', 4000);
GO

-- Listing 4-3: RegexReplace Function
/*
using Microsoft.SqlServer.Server;
using System.Data.SqlTypes;
using System.Text.RegularExpressions;

public partial class RegExp
{
  [SqlFunction(IsDeterministic = true, DataAccess = DataAccessKind.None)]
  public static SqlString RegexReplace(
    SqlString input, SqlString pattern, SqlString replacement)
  {
    return (SqlString)Regex.Replace(
      input.Value, pattern.Value, replacement.Value);
  }
}
*/

-- Enable CLR
EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;
GO

-- Create assembly 
USE Performance; 
CREATE ASSEMBLY RegExp 
FROM 'C:\RegExp\RegExp\bin\Debug\RegExp.dll';
GO

-- Create RegexReplace function
CREATE FUNCTION dbo.RegexReplace(
  @input       AS NVARCHAR(MAX),
  @pattern     AS NVARCHAR(MAX),
  @replacement AS NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME RegExp.RegExp.RegexReplace;
GO

-- Return trace data with query signature
SELECT 
  dbo.RegexReplace(tsql_code,
    N'([\s,(=<>!](?![^\]]+[\]]))(?:(?:(?:(?#    expression coming
     )(?:([N])?('')(?:[^'']|'''')*(''))(?#      character
     )|(?:0x[\da-fA-F]*)(?#                     binary
     )|(?:[-+]?(?:(?:[\d]*\.[\d]*|[\d]+)(?#     precise number
     )(?:[eE]?[\d]*)))(?#                       imprecise number
     )|(?:[~]?[-+]?(?:[\d]+))(?#                integer
     ))(?:[\s]?[\+\-\*\/\%\&\|\^][\s]?)?)+(?#   operators
     ))',
    N'$1$2$3#$4') AS sig,
  duration
FROM dbo.Workload;

-- Return trace data with query signature checksum
SELECT
  CHECKSUM(dbo.RegexReplace(tsql_code,
    N'([\s,(=<>!](?![^\]]+[\]]))(?:(?:(?:(?#    expression coming
     )(?:([N])?('')(?:[^'']|'''')*(''))(?#      character
     )|(?:0x[\da-fA-F]*)(?#                     binary
     )|(?:[-+]?(?:(?:[\d]*\.[\d]*|[\d]+)(?#     precise number
     )(?:[eE]?[\d]*)))(?#                       imprecise number
     )|(?:[~]?[-+]?(?:[\d]+))(?#                integer
     ))(?:[\s]?[\+\-\*\/\%\&\|\^][\s]?)?)+(?#   operators
     ))',
    N'$1$2$3#$4')) AS cs,
  duration
FROM dbo.Workload;
GO

-- Add cs column to Workload table
ALTER TABLE dbo.Workload ADD cs AS CHECKSUM(dbo.RegexReplace(tsql_code,
    N'([\s,(=<>!](?![^\]]+[\]]))(?:(?:(?:(?#    expression coming
     )(?:([N])?('')(?:[^'']|'''')*(''))(?#      character
     )|(?:0x[\da-fA-F]*)(?#                     binary
     )|(?:[-+]?(?:(?:[\d]*\.[\d]*|[\d]+)(?#     precise number
     )(?:[eE]?[\d]*)))(?#                       imprecise number
     )|(?:[~]?[-+]?(?:[\d]+))(?#                integer
     ))(?:[\s]?[\+\-\*\/\%\&\|\^][\s]?)?)+(?#   operators
     ))',
    N'$1$2$3#$4')) PERSISTED;

CREATE CLUSTERED INDEX idx_cl_cs ON dbo.Workload(cs);
GO

-- Query Workload
SELECT tsql_code, duration, cs
FROM dbo.Workload;
GO

-- Aggregate data by query signature checksum

-- Load aggregate data into temporary table
IF OBJECT_ID('tempdb..#AggQueries', 'U') IS NOT NULL DROP TABLE #AggQueries;

SELECT cs, SUM(duration) AS total_duration,
  100. * SUM(duration) / SUM(SUM(duration)) OVER() AS pct,
  ROW_NUMBER() OVER(ORDER BY SUM(duration) DESC) AS rn
INTO #AggQueries
FROM dbo.Workload
GROUP BY cs;

CREATE CLUSTERED INDEX idx_cl_cs ON #AggQueries(cs);
GO

-- Show aggregate data
SELECT cs, total_duration, pct, rn
FROM #AggQueries
ORDER BY rn;

-- Show running totals
SELECT AQ1.cs,
  CAST(AQ1.total_duration / 1000000.
    AS NUMERIC(12, 2)) AS total_s, 
  CAST(SUM(AQ2.total_duration) / 1000000.
    AS NUMERIC(12, 2)) AS running_total_s, 
  CAST(AQ1.pct AS NUMERIC(12, 2)) AS pct, 
  CAST(SUM(AQ2.pct) AS NUMERIC(12, 2)) AS run_pct, 
  AQ1.rn
FROM #AggQueries AS AQ1
  JOIN #AggQueries AS AQ2
    ON AQ2.rn <= AQ1.rn
GROUP BY AQ1.cs, AQ1.total_duration, AQ1.pct, AQ1.rn
HAVING SUM(AQ2.pct) - AQ1.pct <= 80 -- percentage threshold
--  OR AQ1.rn <= 5
ORDER BY AQ1.rn;

-- Isolate top offenders
WITH RunningTotals AS
(
  SELECT AQ1.cs,
    CAST(AQ1.total_duration / 1000000.
      AS NUMERIC(12, 2)) AS total_s, 
    CAST(SUM(AQ2.total_duration) / 1000000.
      AS NUMERIC(12, 2)) AS running_total_s, 
    CAST(AQ1.pct AS NUMERIC(12, 2)) AS pct, 
    CAST(SUM(AQ2.pct) AS NUMERIC(12, 2)) AS run_pct, 
    AQ1.rn
  FROM #AggQueries AS AQ1
    JOIN #AggQueries AS AQ2
      ON AQ2.rn <= AQ1.rn
  GROUP BY AQ1.cs, AQ1.total_duration, AQ1.pct, AQ1.rn
  HAVING SUM(AQ2.pct) - AQ1.pct <= 80 -- percentage threshold
--  OR AQ1.rn <= 5
)
SELECT RT.rn, RT.pct, W.tsql_code
FROM RunningTotals AS RT
  JOIN dbo.Workload AS W
    ON W.cs = RT.cs
ORDER BY RT.rn;

-- Isolate sig of top offenders and a sample query of each sig
WITH RunningTotals AS
(
  SELECT AQ1.cs,
    CAST(AQ1.total_duration / 1000000.
      AS NUMERIC(12, 2)) AS total_s, 
    CAST(SUM(AQ2.total_duration) / 1000000.
      AS NUMERIC(12, 2)) AS running_total_s, 
    CAST(AQ1.pct AS NUMERIC(12, 2)) AS pct, 
    CAST(SUM(AQ2.pct) AS NUMERIC(12, 2)) AS run_pct, 
    AQ1.rn
  FROM #AggQueries AS AQ1
    JOIN #AggQueries AS AQ2
      ON AQ2.rn <= AQ1.rn
  GROUP BY AQ1.cs, AQ1.total_duration, AQ1.pct, AQ1.rn
  HAVING SUM(AQ2.pct) - AQ1.pct <= 80 -- percentage threshold
)
SELECT RT.rn, RT.pct, S.sig, S.tsql_code AS sample_query
FROM RunningTotals AS RT
  CROSS APPLY
    (SELECT TOP(1) tsql_code, dbo.RegexReplace(tsql_code,
       N'([\s,(=<>!](?![^\]]+[\]]))(?:(?:(?:(?#    expression coming
        )(?:([N])?('')(?:[^'']|'''')*(''))(?#      character
        )|(?:0x[\da-fA-F]*)(?#                     binary
        )|(?:[-+]?(?:(?:[\d]*\.[\d]*|[\d]+)(?#     precise number
        )(?:[eE]?[\d]*)))(?#                       imprecise number
        )|(?:[~]?[-+]?(?:[\d]+))(?#                integer
        ))(?:[\s]?[\+\-\*\/\%\&\|\^][\s]?)?)+(?#   operators
        ))',
       N'$1$2$3#$4') AS sig
     FROM dbo.Workload AS W
     WHERE W.cs = RT.cs) AS S
ORDER BY RT.rn;
GO

-- Query Statistics
SELECT TOP (5)
  MAX(query) AS sample_query,
  SUM(execution_count) AS cnt,
  SUM(total_worker_time) AS cpu,
  SUM(total_physical_reads) AS reads,
  SUM(total_logical_reads) AS logical_reads,
  SUM(total_elapsed_time) AS duration
FROM (SELECT 
        QS.*,
        SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,
           ((CASE statement_end_offset 
              WHEN -1 THEN DATALENGTH(ST.text)
              ELSE QS.statement_end_offset END 
                  - QS.statement_start_offset)/2) + 1
        ) AS query
      FROM sys.dm_exec_query_stats AS QS
        CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) AS ST
        CROSS APPLY sys.dm_exec_plan_attributes(QS.plan_handle) AS PA
      WHERE PA.attribute = 'dbid'
        AND PA.value = DB_ID('Performance')) AS D
GROUP BY query_hash
ORDER BY duration DESC;

---------------------------------------------------------------------
-- Tune Indexes/Queries
---------------------------------------------------------------------

-- Create clustered index
CREATE CLUSTERED INDEX idx_cl_od ON dbo.Orders(orderdate);
GO

-- Start a trace
DECLARE @dbid AS INT, @traceid AS INT;
SET @dbid = DB_ID('Performance');

EXEC dbo.PerfworkloadTraceStart
  @dbid      = @dbid,
  @tracefile = 'c:\temp\Perfworkload 20090212 - Tuned',
  @traceid   = @traceid OUTPUT;
GO

-- Stop the trace (assuming trace id: 2)
EXEC sp_trace_setstatus 2, 0;
EXEC sp_trace_setstatus 2, 2;
GO

---------------------------------------------------------------------
-- Tools for Query Tuning
---------------------------------------------------------------------
SET NOCOUNT ON;
USE Performance;
GO

---------------------------------------------------------------------
-- Cached Query Execution Plans
---------------------------------------------------------------------

-- sys.syscacheobjects
SELECT * FROM sys.syscacheobjects;

SELECT * FROM sys.dm_exec_cached_plans;
SELECT * FROM sys.dm_exec_plan_attributes(<plan_handle>);
SELECT * FROM sys.dm_exec_sql_text(<plan_handle>);
SELECT * FROM sys.dm_exec_cached_plan_dependent_objects(<plan_handle>);

SELECT * FROM sys.dm_exec_query_plan(<plan_handle>);
GO

---------------------------------------------------------------------
-- Clearing the Cache
---------------------------------------------------------------------

-- Clearing data from cache
DBCC DROPCLEANBUFFERS;

-- Clearing execution plans from cache
DBCC FREEPROCCACHE; -- ( plan_handle | sql_handle | pool_name )
GO

-- Clearing execution plans for a particular database
DBCC FLUSHPROCINDB(<dbid>);
GO

DBCC FREESYSTEMCACHE(<cachestore>) -- 'ALL', pool_name, 'Object Plans', 'SQL Plans', 'Bound Trees'
GO

---------------------------------------------------------------------
-- Dynamic Management Objects
---------------------------------------------------------------------

---------------------------------------------------------------------
-- STATISTICS IO
---------------------------------------------------------------------

-- First clear cache
DBCC DROPCLEANBUFFERS;

-- Then run
SET STATISTICS IO ON;

SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderdate >= '20080101'
  AND orderdate < '20080201';
GO

SET STATISTICS IO OFF;
GO

---------------------------------------------------------------------
-- Measuring Runtime of Queries
---------------------------------------------------------------------

-- STATISTICS TIME

-- First clear cache
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;

-- Then run
SET STATISTICS TIME ON;

SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderdate >= '20080101'
  AND orderdate < '20080201';

SET STATISTICS TIME OFF;
GO

---------------------------------------------------------------------
-- Analyzing Execution Plans
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Graphical Execution Plans
---------------------------------------------------------------------

SELECT custid, empid, shipperid, COUNT(*) AS numorders
FROM dbo.Orders
WHERE orderdate >= '20080201'
  AND orderdate < '20080301'
GROUP BY CUBE(custid, empid, shipperid);
GO

-- Comparing cost of four query plans
SELECT custid, orderid, orderdate, empid, filler
FROM dbo.Orders AS O1
WHERE orderid =
  (SELECT TOP (1) O2.orderid
   FROM dbo.Orders AS O2
   WHERE O2.custid = O1.custid
   ORDER BY O2.orderdate DESC, O2.orderid DESC);

SELECT custid, orderid, orderdate, empid, filler
FROM dbo.Orders
WHERE orderid IN
(
  SELECT
    (SELECT TOP (1) O.orderid
     FROM dbo.Orders AS O
     WHERE O.custid = C.custid
     ORDER BY O.orderdate DESC, O.orderid DESC) AS oid
  FROM dbo.Customers AS C
);

SELECT A.*
FROM dbo.Customers AS C
  CROSS APPLY
    (SELECT TOP (1) 
       O.custid, O.orderid, O.orderdate, O.empid, O.filler
     FROM dbo.Orders AS O
     WHERE O.custid = C.custid
     ORDER BY O.orderdate DESC, O.orderid DESC) AS A;

WITH C AS
(
  SELECT custid, orderid, orderdate, empid, filler,
    ROW_NUMBER() OVER(PARTITION BY custid
                      ORDER BY orderdate DESC, orderid DESC) AS n
  FROM dbo.Orders
)
SELECT custid, orderid, orderdate, empid, filler
FROM C
WHERE n = 1;
GO

---------------------------------------------------------------------
-- Textual Showplans (scheduled for deprecation)
---------------------------------------------------------------------

-- SHOWPLAN_TEXT
SET SHOWPLAN_TEXT ON;
GO

-- Listing 4-4: Sample query to test showplan options
SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderid = 280885;
GO

SET SHOWPLAN_TEXT OFF;
GO

-- SHOWPLAN_ALL
SET SHOWPLAN_ALL ON;
GO
-- Run above query
SET SHOWPLAN_ALL OFF;
GO

-- STATISTICS PROFILE 
SET STATISTICS PROFILE ON;
GO
-- Run above query
SET STATISTICS PROFILE OFF;
GO

---------------------------------------------------------------------
-- XML Showplans
---------------------------------------------------------------------

-- SHOWPLAN_XML
SET SHOWPLAN_XML ON;
GO

SET SHOWPLAN_XML OFF;
GO

-- STATISTICS XML
SET STATISTICS XML ON;
GO

SELECT orderid, custid, empid, shipperid, orderdate, filler
FROM dbo.Orders
WHERE orderid = 280885;

SET STATISTICS XML OFF;
GO

-- Hints

-- USE PLAN

-- Generate XML plan
SET SHOWPLAN_XML ON;
GO
SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders
WHERE orderid >= 2147483647;
GO
SET SHOWPLAN_XML OFF;
GO

-- Use XML plan value in USE PLAN hint
DECLARE @oid AS INT;
SET @oid = 1000000;

SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders
WHERE orderid >= @oid
OPTION (USE PLAN N'<ShowPlanXML xmlns="http://schemas.microsoft.com/sqlserver/2004/07/showplan" Version="1.1" Build="10.0.1600.22"><BatchSequence><Batch><Statements><StmtSimple StatementText="SELECT orderid, custid, empid, shipperid, orderdate&#xd;&#xa;FROM dbo.Orders&#xd;&#xa;WHERE orderid &gt;= 2147483647;&#xd;&#xa;" StatementId="1" StatementCompId="1" StatementType="SELECT" StatementSubTreeCost="0.00657038" StatementEstRows="1" StatementOptmLevel="FULL" QueryHash="0x18A2E9F0F2A17005" QueryPlanHash="0xAB31F1D1DF79F3A4" StatementOptmEarlyAbortReason="GoodEnoughPlanFound" ParameterizedText="(@1 int)SELECT [orderid],[custid],[empid],[shipperid],[orderdate] FROM [dbo].[Orders] WHERE [orderid]&gt;=@1"><StatementSetOptions QUOTED_IDENTIFIER="true" ARITHABORT="true" CONCAT_NULL_YIELDS_NULL="true" ANSI_NULLS="true" ANSI_PADDING="true" ANSI_WARNINGS="true" NUMERIC_ROUNDABORT="false"/><QueryPlan CachedPlanSize="16" CompileTime="47" CompileCPU="47" CompileMemory="96"><RelOp NodeId="0" PhysicalOp="Nested Loops" LogicalOp="Inner Join" EstimateRows="1" EstimateIO="0" EstimateCPU="4.18e-006" AvgRowSize="40" EstimatedTotalSubtreeCost="0.00657038" Parallel="0" EstimateRebinds="0" EstimateRewinds="0"><OutputList><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="orderid"/><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="custid"/><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="empid"/><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="shipperid"/><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="orderdate"/></OutputList><NestedLoops Optimized="1"><OuterReferences><ColumnReference Column="Uniq1002"/><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="orderdate"/></OuterReferences><RelOp NodeId="2" PhysicalOp="Index Seek" LogicalOp="Index Seek" EstimateRows="1" EstimateIO="0.003125" EstimateCPU="0.0001581" AvgRowSize="23" EstimatedTotalSubtreeCost="0.0032831" TableCardinality="1e+006" Parallel="0" EstimateRebinds="0" EstimateRewinds="0"><OutputList><ColumnReference Column="Uniq1002"/><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="orderid"/><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="orderdate"/></OutputList><IndexScan Ordered="1" ScanDirection="FORWARD" ForcedIndex="0" ForceSeek="0" NoExpandHint="0"><DefinedValues><DefinedValue><ColumnReference Column="Uniq1002"/></DefinedValue><DefinedValue><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="orderid"/></DefinedValue><DefinedValue><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="orderdate"/></DefinedValue></DefinedValues><Object Database="[Performance]" Schema="[dbo]" Table="[Orders]" Index="[PK_Orders]" IndexKind="NonClustered"/><SeekPredicates><SeekPredicateNew><SeekKeys><StartRange ScanType="GE"><RangeColumns><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="orderid"/></RangeColumns><RangeExpressions><ScalarOperator ScalarString="(2147483647)"><Const ConstValue="(2147483647)"/></ScalarOperator></RangeExpressions></StartRange></SeekKeys></SeekPredicateNew></SeekPredicates></IndexScan></RelOp><RelOp NodeId="4" PhysicalOp="Clustered Index Seek" LogicalOp="Clustered Index Seek" EstimateRows="1" EstimateIO="0.003125" EstimateCPU="0.0001581" AvgRowSize="28" EstimatedTotalSubtreeCost="0.0032831" TableCardinality="1e+006" Parallel="0" EstimateRebinds="0" EstimateRewinds="0"><OutputList><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="custid"/><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="empid"/><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="shipperid"/></OutputList><IndexScan Lookup="1" Ordered="1" ScanDirection="FORWARD" ForcedIndex="0" ForceSeek="0" NoExpandHint="0"><DefinedValues><DefinedValue><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="custid"/></DefinedValue><DefinedValue><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="empid"/></DefinedValue><DefinedValue><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="shipperid"/></DefinedValue></DefinedValues><Object Database="[Performance]" Schema="[dbo]" Table="[Orders]" Index="[idx_cl_od]" TableReferenceId="-1" IndexKind="Clustered"/><SeekPredicates><SeekPredicateNew><SeekKeys><Prefix ScanType="EQ"><RangeColumns><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="orderdate"/><ColumnReference Column="Uniq1002"/></RangeColumns><RangeExpressions><ScalarOperator ScalarString="[Performance].[dbo].[Orders].[orderdate]"><Identifier><ColumnReference Database="[Performance]" Schema="[dbo]" Table="[Orders]" Column="orderdate"/></Identifier></ScalarOperator><ScalarOperator ScalarString="[Uniq1002]"><Identifier><ColumnReference Column="Uniq1002"/></Identifier></ScalarOperator></RangeExpressions></Prefix></SeekKeys></SeekPredicateNew></SeekPredicates></IndexScan></RelOp></NestedLoops></RelOp><ParameterList><ColumnReference Column="@1" ParameterCompiledValue="(2147483647)"/></ParameterList></QueryPlan></StmtSimple></Statements></Batch></BatchSequence></ShowPlanXML>');
GO

---------------------------------------------------------------------
-- Index Tuning
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Table and Index Structures
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Pages and Extents
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Table Organization
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Heap
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Clustered Index
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Nonclustered Index on a Heap
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Nonclustered Index on a Clustered Table
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Index Access Methods
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Table Scan/Unordered Clustered Index Scan
---------------------------------------------------------------------

SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders;

---------------------------------------------------------------------
-- Unordered Covering Nonclustered Index Scan
---------------------------------------------------------------------

SELECT orderid
FROM dbo.Orders;

---------------------------------------------------------------------
-- Ordered Clustered Index Scan
---------------------------------------------------------------------

SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders
ORDER BY orderdate;

---------------------------------------------------------------------
-- Ordered Covering Nonclustered Index Scan
---------------------------------------------------------------------

SELECT orderid, orderdate
FROM dbo.Orders
ORDER BY orderid;

-- With segmentation
SELECT orderid, custid, empid, orderdate
FROM dbo.Orders AS O1
WHERE orderid = 
  (SELECT MAX(orderid)
   FROM dbo.Orders AS O2
   WHERE O2.orderdate = O1.orderdate);

---------------------------------------------------------------------
-- Storage Engine's Treatment of Scans
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Allocation Order Scan: Getting Multiple Occurrences of Rows
---------------------------------------------------------------------

SET NOCOUNT ON;
USE tempdb;
GO

-- Create table T1
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;

CREATE TABLE dbo.T1
(
  cl_col UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()),
  filler CHAR(2000) NOT NULL DEFAULT('a')
);
GO
CREATE UNIQUE CLUSTERED INDEX idx_cl_col ON dbo.T1(cl_col);
GO

-- Insert rows (run for a few seconds then stop)
SET NOCOUNT ON;
USE tempdb;

TRUNCATE TABLE dbo.T1;

WHILE 1 = 1
  INSERT INTO dbo.T1 DEFAULT VALUES;
GO

-- Observe level of fragmentation
SELECT avg_fragmentation_in_percent FROM sys.dm_db_index_physical_stats
( 
  DB_ID('tempdb'),
  OBJECT_ID('dbo.T1'),
  1,
  NULL,
  NULL
);

-- Get index linked list info
DBCC IND('tempdb', 'dbo.T1', 0);
GO

CREATE TABLE #DBCCIND
(
  PageFID INT,
  PagePID INT,
  IAMFID INT,
  IAMPID INT,
  ObjectID INT,
  IndexID INT,
  PartitionNumber INT,
  PartitionID BIGINT,
  iam_chain_type VARCHAR(100),
  PageType INT,
  IndexLevel INT,
  NextPageFID INT,
  NextPagePID INT,
  PrevPageFID INT,
  PrevPagePID INT
);

INSERT INTO #DBCCIND
  EXEC ('DBCC IND(''tempdb'', ''dbo.T1'', 0)');

CREATE CLUSTERED INDEX idx_cl_prevpage ON #DBCCIND(PrevPageFID, PrevPagePID);

WITH LinkedList
AS
(
  SELECT 1 AS RowNum, PageFID, PagePID
  FROM #DBCCIND
  WHERE IndexID = 1
    AND IndexLevel = 0
    AND PrevPageFID = 0
    AND PrevPagePID = 0

  UNION ALL

  SELECT PrevLevel.RowNum + 1,
    CurLevel.PageFID, CurLevel.PagePID
  FROM LinkedList AS PrevLevel
    JOIN #DBCCIND AS CurLevel
      ON CurLevel.PrevPageFID = PrevLevel.PageFID
      AND CurLevel.PrevPagePID = PrevLevel.PagePID
)
SELECT
  CAST(PageFID AS VARCHAR(MAX)) + ':'
  + CAST(PagePID AS VARCHAR(MAX)) + ' ' AS [text()]
FROM LinkedList
ORDER BY RowNum
FOR XML PATH('')
OPTION (MAXRECURSION 0);

DROP TABLE #DBCCIND;
GO

-- Query T1

-- Index order scan
SELECT SUBSTRING(CAST(cl_col AS BINARY(16)), 11, 6) AS segment1, *
FROM dbo.T1;

-- Allocation order scan
SELECT SUBSTRING(CAST(cl_col AS BINARY(16)), 11, 6) AS segment1, *
FROM dbo.T1 WITH (NOLOCK);

-- Allocation order scan
SELECT SUBSTRING(CAST(cl_col AS BINARY(16)), 11, 6) AS segment1, *
FROM dbo.T1 WITH (TABLOCK);

-- Connection 1: insert rows (run for a few seconds then stop)
SET NOCOUNT ON;
USE tempdb;

TRUNCATE TABLE dbo.T1;

WHILE 1 = 1
  INSERT INTO dbo.T1 DEFAULT VALUES;
GO

-- Connection 2: read
SET NOCOUNT ON;
USE tempdb;

WHILE 1 = 1
BEGIN
  SELECT * INTO #T1 FROM dbo.T1 WITH(NOLOCK);

  IF EXISTS(
    SELECT cl_col
    FROM #T1 
    GROUP BY cl_col 
    HAVING COUNT(*) > 1) BREAK;

  DROP TABLE #T1;
END

SELECT cl_col, COUNT(*) AS cnt
FROM #T1 
GROUP BY cl_col
HAVING COUNT(*) > 1;

DROP TABLE #T1;
GO

-- Stop execution in Connection 1

---------------------------------------------------------------------
-- Allocation Order Scan: Skipping Rows
---------------------------------------------------------------------

-- Create table T1
SET NOCOUNT ON;
USE tempdb;

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;

CREATE TABLE dbo.T1
(
  cl_col UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()),
  seq_val INT NOT NULL,
  filler CHAR(2000) NOT NULL DEFAULT('a')
);
CREATE UNIQUE CLUSTERED INDEX idx_cl_col ON dbo.T1(cl_col);

-- Create table Sequence 
IF OBJECT_ID('dbo.Sequence', 'U') IS NOT NULL DROP TABLE dbo.Sequence;

CREATE TABLE dbo.Sequence(val INT NOT NULL);
INSERT INTO dbo.Sequence(val) VALUES(0);
GO

-- Connection 1: insert rows
SET NOCOUNT ON;
USE tempdb;

UPDATE dbo.Sequence SET val = 0;
TRUNCATE TABLE dbo.T1;

DECLARE @nextval AS INT;

WHILE 1 = 1
BEGIN
  UPDATE dbo.Sequence SET @nextval = val = val + 1;
  INSERT INTO dbo.T1(seq_val) VALUES(@nextval);
END

-- Connection 2: read
SET NOCOUNT ON;
USE tempdb;

DECLARE @max AS INT;
WHILE 1 = 1
BEGIN
  SET @max = (SELECT MAX(seq_val) FROM dbo.T1);
  SELECT * INTO #T1 FROM dbo.T1 WITH(NOLOCK);
  CREATE NONCLUSTERED INDEX idx_seq_val ON #T1(seq_val);

  IF EXISTS(
    SELECT *
    FROM (SELECT seq_val AS cur, 
            (SELECT MIN(seq_val)
             FROM #T1 AS N
             WHERE N.seq_val > C.seq_val) AS nxt
          FROM #T1 AS C
          WHERE seq_val <= @max) AS D
    WHERE nxt - cur > 1) BREAK;

  DROP TABLE #T1;
END

SELECT *
FROM (SELECT seq_val AS cur, 
        (SELECT MIN(seq_val)
         FROM #T1 AS N
         WHERE N.seq_val > C.seq_val) AS nxt
      FROM #T1 AS C      
      WHERE seq_val <= @max) AS D
WHERE nxt - cur > 1;

DROP TABLE #T1;
GO

---------------------------------------------------------------------
-- Index Order Scans
---------------------------------------------------------------------

SET NOCOUNT ON;
USE tempdb;
GO

-- Create table Employees
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;

CREATE TABLE dbo.Employees
(
  empid VARCHAR(10) NOT NULL,
  salary MONEY NOT NULL,
  filler CHAR(2500) NOT NULL DEFAULT('a')
);

CREATE CLUSTERED INDEX idx_cl_salary ON dbo.Employees(salary);
ALTER TABLE dbo.Employees
  ADD CONSTRAINT PK_Employees PRIMARY KEY NONCLUSTERED(empid);

INSERT INTO dbo.Employees(empid, salary) VALUES
  ('D', 1000.00),('A', 2000.00),('C', 3000.00),('B', 4000.00);
GO

-- Connection 1: update a row
SET NOCOUNT ON;
USE tempdb;

WHILE 1=1
  UPDATE dbo.Employees
    SET salary = 6000.00 - salary
  WHERE empid = 'D';

-- Connection 2: read
SET NOCOUNT ON;
USE tempdb;

WHILE 1 = 1
BEGIN
  SELECT * INTO #Employees FROM dbo.Employees;

  IF @@rowcount <> 4 BREAK; -- use =3 for skipping, =5 for multi occur

  DROP TABLE #Employees;
END

SELECT * FROM #Employees;

DROP TABLE #Employees;
GO

---------------------------------------------------------------------
-- Nonclustered Index Seek + Ordered Partial Scan + Lookups
---------------------------------------------------------------------

USE Performance;

SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders
WHERE orderid BETWEEN 101 AND 120;

---------------------------------------------------------------------
-- Unordered Nonclustered Index Scan + Lookups
---------------------------------------------------------------------

-- Non-first column in index; auto created statistics
SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders
WHERE custid = 'C0000000001';

SELECT name
FROM sys.stats
WHERE object_id = OBJECT_ID('dbo.Orders')
  AND auto_created = 1;

-- String cardinalities
SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders
WHERE custid LIKE '%9999';

---------------------------------------------------------------------
-- Clustered Index Seek + Ordered Partial Scan
---------------------------------------------------------------------

SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders
WHERE orderdate = '20080212';

---------------------------------------------------------------------
-- Covering Nonclustered Index Seek + Ordered Partial Scan
---------------------------------------------------------------------

SELECT shipperid, orderdate, custid
FROM dbo.Orders
WHERE shipperid = 'C'
  AND orderdate >= '20080101'
  AND orderdate < '20090101';

---------------------------------------------------------------------
-- Included Non-key Columns
---------------------------------------------------------------------

CREATE INDEX idx_nc_cid_i_oid_eid_sid_od
  ON dbo.Orders(custid)
  INCLUDE(orderid, empid, shipperid, orderdate);

SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders
WHERE custid = 'C0000000001';

DROP INDEX dbo.Orders.idx_nc_cid_i_oid_eid_sid_od;

SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders
WHERE custid = 'C0000000001';

---------------------------------------------------------------------
-- Index Intersection
---------------------------------------------------------------------

SELECT orderid, custid
FROM dbo.Orders
WHERE shipperid = 'A';
GO

---------------------------------------------------------------------
-- Filtered Indexes and Statistics
---------------------------------------------------------------------

USE AdventureWorks2008;

CREATE NONCLUSTERED INDEX idx_currate_notnull
  ON Sales.SalesOrderHeader(CurrencyRateID)
  WHERE CurrencyRateID IS NOT NULL;

-- Implicit Exclusion of NULLs
SELECT *
FROM Sales.SalesOrderHeader
WHERE CurrencyRateID = 4;

CREATE NONCLUSTERED INDEX idx_freight_5000_or_more
  ON Sales.SalesOrderHeader(Freight)
  WHERE Freight >= $5000.00;

-- Subintervals
SELECT *
FROM Sales.SalesOrderHeader
WHERE Freight BETWEEN $5500.00 AND $6000.00;

CREATE NONCLUSTERED INDEX idx_territory5_orderdate
  ON Sales.SalesOrderHeader(OrderDate)
  INCLUDE(SalesOrderID, CustomerID, TotalDue)
  WHERE TerritoryID = 5;

-- Coverage
SELECT SalesOrderID, CustomerID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE TerritoryID = 5;

-- Coverage Plus Range Scan
SELECT SalesOrderID, CustomerID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE TerritoryID = 5
  AND OrderDate >= '20040101';

-- Filtered Statistics
CREATE STATISTICS stats_territory4_orderdate
  ON Sales.SalesOrderHeader(OrderDate)
  WHERE TerritoryID = 4;
GO

-- Unique with Multiple NULLs
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
CREATE TABLE dbo.T1(col1 INT NULL, col2 VARCHAR(10) NOT NULL);
GO
CREATE UNIQUE NONCLUSTERED INDEX idx_col1_notnull
  ON dbo.T1(col1)
  WHERE col1 IS NOT NULL;
GO
  
INSERT INTO dbo.T1(col1, col2)
  VALUES(1, 'a');

-- fails
INSERT INTO dbo.T1(col1, col2)
  VALUES(1, 'a');

/*
Msg 2601, Level 14, State 1, Line 1
Cannot insert duplicate key row in object 'dbo.T1' with unique index 'idx_col1_notnull'.
The statement has been terminated.
*/

-- Run following twice
INSERT INTO dbo.T1(col1, col2)
  VALUES(NULL, 'a');

-- Cleanup
DROP INDEX Sales.SalesOrderHeader.idx_currate_notnull;
DROP INDEX Sales.SalesOrderHeader.idx_freight_5000_or_more;
DROP INDEX Sales.SalesOrderHeader.idx_territory5_orderdate;
DROP STATISTICS Sales.SalesOrderHeader.stats_territory4_orderdate;
DROP TABLE dbo.T1;
GO

---------------------------------------------------------------------
-- Indexed Views
---------------------------------------------------------------------
USE Performance;

IF OBJECT_ID('dbo.EmpOrders', 'V') IS NOT NULL
  DROP VIEW dbo.EmpOrders;
GO
CREATE VIEW dbo.EmpOrders
  WITH SCHEMABINDING
AS

SELECT empid, YEAR(orderdate) AS orderyear, COUNT_BIG(*) AS numorders
FROM dbo.Orders
GROUP BY empid, YEAR(orderdate);
GO

CREATE UNIQUE CLUSTERED INDEX idx_ucl_eid_oy
  ON dbo.EmpOrders(empid, orderyear);
GO

SELECT empid, orderyear, numorders
FROM dbo.EmpOrders;

SELECT empid, YEAR(orderdate) AS orderyear, COUNT_BIG(*) AS numorders
FROM dbo.Orders
GROUP BY empid, YEAR(orderdate);
GO

---------------------------------------------------------------------
-- Analysis of Indexing Strategies
---------------------------------------------------------------------

-- Drop view and all indexes besides the clustered index from Orders
-- Or rerun Listing 1, after removing all index and primary key
-- creation statements on Orders, only keep clustered index

DROP VIEW dbo.EmpOrders;
DROP INDEX Orders.idx_nc_sid_od_i_cid;
DROP INDEX Orders.idx_unc_od_oid_i_cid_eid;
ALTER TABLE dbo.Orders DROP CONSTRAINT PK_Orders;

-- Query
SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders
WHERE orderid >= 999001; -- change values to reflect varying selectivity
GO

---------------------------------------------------------------------
-- Table Scan (Unordered Clustered Index Scan)
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Unordered Covering Nonclustered Index Scan
---------------------------------------------------------------------

-- Create index
CREATE NONCLUSTERED INDEX idx_nc_od_i_oid_cid_eid_sid
  ON dbo.Orders(orderdate)
  INCLUDE(orderid, custid, empid, shipperid);
GO

-- Run query

-- Drop index
DROP INDEX dbo.Orders.idx_nc_od_i_oid_cid_eid_sid;
GO

---------------------------------------------------------------------
-- Unordered Nonclustered Index Scan + Lookups
---------------------------------------------------------------------

-- Create index
CREATE NONCLUSTERED INDEX idx_nc_od_i_oid
  ON dbo.Orders(orderdate)
  INCLUDE(orderid);
GO

-- Run query

-- Drop index
DROP INDEX dbo.Orders.idx_nc_od_i_oid;
GO

---------------------------------------------------------------------
-- Nonclustered Index Seek + Ordered Partial Scan + Lookups
---------------------------------------------------------------------

-- Create index
CREATE UNIQUE NONCLUSTERED INDEX idx_unc_oid
  ON dbo.Orders(orderid);
GO

-- Run query

-- Determining selectivity point
SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders
WHERE orderid >= 500001; -- use binary algorithm to determine points

-- Selectivity point where index is first used
SELECT orderid, custid, empid, shipperid, orderdate
FROM dbo.Orders
WHERE orderid >= 993347;
GO

-- Drop index
DROP INDEX dbo.Orders.idx_unc_oid;
GO

---------------------------------------------------------------------
-- Clustered Index Seek + Ordered Partial Scan
---------------------------------------------------------------------

-- Drop existing clustered index, and create the new one
DROP INDEX dbo.Orders.idx_cl_od;
CREATE UNIQUE CLUSTERED INDEX idx_cl_oid ON dbo.Orders(orderid);
GO

-- Run query

-- Restore original clustered index
DROP INDEX dbo.Orders.idx_cl_oid;
CREATE CLUSTERED INDEX idx_cl_od ON dbo.Orders(orderdate);
GO

---------------------------------------------------------------------
-- Covering Nonclustered Index Seek + Ordered Partial Scan
---------------------------------------------------------------------

-- Create index
CREATE UNIQUE NONCLUSTERED INDEX idx_unc_oid_i_od_cid_eid_sid
  ON dbo.Orders(orderid)
  INCLUDE(orderdate, custid, empid, shipperid);
GO

-- Run query

-- Drop index
DROP INDEX dbo.Orders.idx_unc_oid_i_od_cid_eid_sid;
GO

---------------------------------------------------------------------
-- Index Usage Statistics
---------------------------------------------------------------------

-- Operational Stats:
SELECT *  
FROM sys.dm_db_index_operational_stats( 
  DB_ID('Performance'), null, null, null);

-- Index Usage Stats:
SELECT *
FROM sys.dm_db_index_usage_stats;

---------------------------------------------------------------------
-- Fragmentation
---------------------------------------------------------------------

-- Last argument specifies mode: LIMITED, SAMPLED, DETAILED
SELECT * 
FROM sys.dm_db_index_physical_stats(
  DB_ID('Performance'), NULL, NULL, NULL, 'SAMPLED');

-- Rebuild Index
ALTER INDEX idx_cl_od ON dbo.Orders REBUILD WITH (ONLINE = ON);

-- Reorganize Index
ALTER INDEX idx_cl_od ON dbo.Orders REORGANIZE;

---------------------------------------------------------------------
-- Partitioning
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Preparing Sample Data
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Data Preparation
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Max Concurrent Sessions
---------------------------------------------------------------------

-- Creating and Populating Sessions
SET NOCOUNT ON;
USE Performance;

IF OBJECT_ID('dbo.Sessions', 'U') IS NOT NULL DROP TABLE dbo.Sessions;

CREATE TABLE dbo.Sessions
(
  keycol    INT         NOT NULL IDENTITY,
  app       VARCHAR(10) NOT NULL,
  usr       VARCHAR(10) NOT NULL,
  host      VARCHAR(10) NOT NULL,
  starttime DATETIME    NOT NULL,
  endtime   DATETIME    NOT NULL,
  CONSTRAINT PK_Sessions PRIMARY KEY(keycol),
  CHECK(endtime > starttime)
);
GO

INSERT INTO dbo.Sessions VALUES
  ('app1', 'user1', 'host1', '20090212 08:30', '20090212 10:30'),
  ('app1', 'user2', 'host1', '20090212 08:30', '20090212 08:45'),
  ('app1', 'user3', 'host2', '20090212 09:00', '20090212 09:30'),
  ('app1', 'user4', 'host2', '20090212 09:15', '20090212 10:30'),
  ('app1', 'user5', 'host3', '20090212 09:15', '20090212 09:30'),
  ('app1', 'user6', 'host3', '20090212 10:30', '20090212 14:30'),
  ('app1', 'user7', 'host4', '20090212 10:45', '20090212 11:30'),
  ('app1', 'user8', 'host4', '20090212 11:00', '20090212 12:30'),
  ('app2', 'user8', 'host1', '20090212 08:30', '20090212 08:45'),
  ('app2', 'user7', 'host1', '20090212 09:00', '20090212 09:30'),
  ('app2', 'user6', 'host2', '20090212 11:45', '20090212 12:00'),
  ('app2', 'user5', 'host2', '20090212 12:30', '20090212 14:00'),
  ('app2', 'user4', 'host3', '20090212 12:45', '20090212 13:30'),
  ('app2', 'user3', 'host3', '20090212 13:00', '20090212 14:00'),
  ('app2', 'user2', 'host4', '20090212 14:00', '20090212 16:30'),
  ('app2', 'user1', 'host4', '20090212 15:30', '20090212 17:00');

CREATE INDEX idx_nc_app_st_et ON dbo.Sessions(app, starttime, endtime);
GO

-- Query returning maximum number of concurrent sessions
SELECT app, MAX(concurrent) AS mx
FROM (SELECT app,
        (SELECT COUNT(*)
         FROM dbo.Sessions AS S
         WHERE T.app = S.app
           AND T.ts >= S.starttime
           AND T.ts < S.endtime) AS concurrent
      FROM (SELECT app, starttime AS ts FROM dbo.Sessions) AS T) AS C
GROUP BY app;
GO

-- Populate Sessions with Inadequate Sample Data
IF OBJECT_ID('dbo.BigSessions', 'U') IS NOT NULL DROP TABLE dbo.BigSessions;

SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 0)) AS keycol,
  app, usr, host, starttime, endtime
INTO dbo.BigSessions
FROM dbo.Sessions AS S
  CROSS JOIN Nums
WHERE n <= 62500;

CREATE UNIQUE CLUSTERED INDEX idx_ucl_keycol
  ON dbo.BigSessions(keycol);
CREATE INDEX idx_nc_app_st_et
  ON dbo.BigSessions(app, starttime, endtime);
GO

-- Query against BigSessions
SELECT app, MAX(concurrent) AS mx
FROM (SELECT app,
        (SELECT COUNT(*)
         FROM dbo.BigSessions AS S
         WHERE T.app = S.app
           AND T.ts >= S.starttime
           AND T.ts < S.endtime) AS concurrent
      FROM (SELECT app, starttime AS ts FROM dbo.BigSessions) AS T) AS C
GROUP BY app;

-- Populate Sessions with Adequate Sample Data
IF OBJECT_ID('dbo.BigSessions', 'U') IS NOT NULL DROP TABLE dbo.BigSessions;

SELECT
  ROW_NUMBER() OVER(ORDER BY (SELECT 0)) AS keycol,
  D.*,
  DATEADD(
    second,
    1 + ABS(CHECKSUM(NEWID())) % (20*60),
    starttime) AS endtime
INTO dbo.BigSessions
FROM
(
  SELECT 
    'app' + CAST(1 + ABS(CHECKSUM(NEWID())) % 10 AS VARCHAR(10)) AS app,
    'user1' AS usr,
    'host1' AS host,
    DATEADD(
      second,
      1 + ABS(CHECKSUM(NEWID())) % (30*24*60*60),
      '20090101') AS starttime
  FROM dbo.Nums
  WHERE n <= 1000000
) AS D;

CREATE UNIQUE CLUSTERED INDEX idx_ucl_keycol
  ON dbo.BigSessions(keycol);
CREATE INDEX idx_nc_app_st_et
  ON dbo.BigSessions(app, starttime, endtime);
GO

---------------------------------------------------------------------
-- TABLESAMPLE
---------------------------------------------------------------------

-- Simple example for TABLESAMPLE
SELECT *
FROM dbo.Orders TABLESAMPLE (1000 ROWS);

-- Using TABLESAMPLE with ROWS (coverted to percent)
SELECT *
FROM dbo.Orders TABLESAMPLE SYSTEM (1000 ROWS);

-- Using TABLESAMPLE with PERCENT
SELECT *
FROM dbo.Orders TABLESAMPLE (0.1 PERCENT);

-- Using TABLESAMPLE and TOP to limit upper bound
SELECT TOP (1000) *
FROM dbo.Orders TABLESAMPLE (2000 ROWS);

-- Using TABLESAMPLE with the REPEATABLE option
SELECT *
FROM dbo.Orders TABLESAMPLE (1000 ROWS) REPEATABLE(42);
GO

-- With small tables you might not get any rows
SELECT * 
FROM AdventureWorks2008.Production.ProductCostHistory TABLESAMPLE (1 ROWS);

-- Using TOP and CHECKSUM(NEWID())
-- Full table scn
SELECT TOP(1) *
FROM AdventureWorks2008.Production.ProductCostHistory
ORDER BY CHECKSUM(NEWID());

-- Bernoulli
SELECT * 
FROM AdventureWorks2008.Production.ProductCostHistory
WHERE ABS((ProductID%ProductID)+CHECKSUM(NEWID()))/POWER(2.,31) < 0.01; -- probability
GO

---------------------------------------------------------------------
-- Set-Based vs. Iterative/Procedural Approach and a Tuning Exercise
---------------------------------------------------------------------

SET NOCOUNT ON;
USE Performance;
GO

-- Make sure only clustered index and primary key exist
CREATE CLUSTERED INDEX idx_cl_od ON dbo.Orders(orderdate);

ALTER TABLE dbo.Orders ADD
  CONSTRAINT PK_Orders PRIMARY KEY NONCLUSTERED(orderid);
GO

-- Add a few rows to Shippers and Orders
INSERT INTO dbo.Shippers(shipperid, shippername) VALUES
  ('B', 'Shipper_B'),
  ('D', 'Shipper_D'),
  ('F', 'Shipper_F'),
  ('H', 'Shipper_H'),
  ('X', 'Shipper_X'),
  ('Y', 'Shipper_Y'),
  ('Z', 'Shipper_Z');

INSERT INTO dbo.Orders(orderid, custid, empid, shipperid, orderdate) VALUES
  (1000001, 'C0000000001', 1, 'B', '20030101'),
  (1000002, 'C0000000001', 1, 'D', '20030101'),
  (1000003, 'C0000000001', 1, 'F', '20030101'),
  (1000004, 'C0000000001', 1, 'H', '20030101');
GO

-- Create covering index for problem
CREATE NONCLUSTERED INDEX idx_nc_sid_od
  ON dbo.Orders(shipperid, orderdate);
GO

-- Make sure you clear the cache before running each solution
DBCC DROPCLEANBUFFERS;

-- Cursor Solution
DECLARE
  @sid     AS VARCHAR(5),
  @od      AS DATETIME,
  @prevsid AS VARCHAR(5),
  @prevod  AS DATETIME;

DECLARE ShipOrdersCursor CURSOR FAST_FORWARD FOR
  SELECT shipperid, orderdate
  FROM dbo.Orders
  ORDER BY shipperid, orderdate;

OPEN ShipOrdersCursor;

FETCH NEXT FROM ShipOrdersCursor INTO @sid, @od;

SELECT @prevsid = @sid, @prevod = @od;

WHILE @@fetch_status = 0
BEGIN
  IF @prevsid <> @sid AND @prevod < '20040101' PRINT @prevsid;
  SELECT @prevsid = @sid, @prevod = @od;
  FETCH NEXT FROM ShipOrdersCursor INTO @sid, @od;
END

IF @prevod < '20040101' PRINT @prevsid;

CLOSE ShipOrdersCursor;

DEALLOCATE ShipOrdersCursor;
GO

-- Set-based solution 1
SELECT shipperid
FROM dbo.Orders
GROUP BY shipperid
HAVING MAX(orderdate) < '20040101';

-- Get maximum date for a particular shipper
SELECT MAX(orderdate) FROM dbo.Orders WHERE shipperid = 'A';

-- Max date per shipper using MAX
SELECT shipperid,
  (SELECT MAX(orderdate)
   FROM dbo.Orders AS O
   WHERE O.shipperid = S.shipperid) AS maxod
FROM dbo.Shippers AS S;

-- Max date per shipper using TOP
SELECT shipperid,
  (SELECT TOP (1) orderdate
   FROM dbo.Orders AS O
   WHERE O.shipperid = S.shipperid
   ORDER BY orderdate DESC) AS maxod
FROM dbo.Shippers AS S;

-- Set-based solution 2
SELECT shipperid
FROM dbo.Shippers AS S
WHERE
  (SELECT TOP (1) orderdate
   FROM dbo.Orders AS O
   WHERE O.shipperid = S.shipperid
   ORDER BY orderdate DESC) < '20040101';

-- Revisions to the MAX version of the solution
SELECT shipperid
FROM dbo.Shippers AS S
WHERE
  (SELECT DISTINCT MAX(orderdate)
   FROM dbo.Orders AS O
   WHERE O.shipperid = S.shipperid) < '20040101';

SELECT shipperid
FROM dbo.Shippers AS S
WHERE
  (SELECT TOP (1) MAX(orderdate)
   FROM dbo.Orders AS O
   WHERE O.shipperid = S.shipperid) < '20040101';

-- Set-based solution 3
SELECT shipperid
FROM dbo.Shippers AS S
WHERE NOT EXISTS
  (SELECT * FROM dbo.Orders AS O
   WHERE O.shipperid = S.shipperid
     AND O.orderdate >= '20040101')
  AND EXISTS
  (SELECT * FROM dbo.Orders AS O
   WHERE O.shipperid = S.shipperid);
