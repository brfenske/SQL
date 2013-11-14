-- Listing 1.1: Discovering system session waits.
SELECT DISTINCT
        wt.wait_type
FROM    sys.dm_os_waiting_tasks AS wt
        JOIN sys.dm_exec_sessions AS s ON wt.session_id = s.session_id
WHERE   s.is_user_process = 0

-- Listing 1.2: Finding the top ten cumulative wait events.
SELECT TOP 10
        wait_type ,
        max_wait_time_ms wait_time_ms ,
        signal_wait_time_ms ,
        wait_time_ms - signal_wait_time_ms AS resource_wait_time_ms ,
        100.0 * wait_time_ms / SUM(wait_time_ms) OVER ( ) AS percent_total_waits ,
        100.0 * signal_wait_time_ms / SUM(signal_wait_time_ms) OVER ( ) AS percent_total_signal_waits ,
        100.0 * ( wait_time_ms - signal_wait_time_ms )
        / SUM(wait_time_ms) OVER ( ) AS percent_total_resource_waits
FROM    sys.dm_os_wait_stats
WHERE   wait_time_ms > 0 -- remove zero wait_time
        AND wait_type NOT IN -- filter out additional irrelevant waits
( 'SLEEP_TASK', 'BROKER_TASK_STOP', 'BROKER_TO_FLUSH', 'SQLTRACE_BUFFER_FLUSH',
  'CLR_AUTO_EVENT', 'CLR_MANUAL_EVENT', 'LAZYWRITER_SLEEP', 'SLEEP_SYSTEMTASK',
  'SLEEP_BPOOL_FLUSH', 'BROKER_EVENTHANDLER', 'XE_DISPATCHER_WAIT',
  'FT_IFTSHC_MUTEX', 'CHECKPOINT_QUEUE', 'FT_IFTS_SCHEDULER_IDLE_WAIT',
  'BROKER_TRANSMITTER', 'FT_IFTSHC_MUTEX', 'KSOURCE_WAKEUP',
  'LAZYWRITER_SLEEP', 'LOGMGR_QUEUE', 'ONDEMAND_TASK_QUEUE',
  'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT', 'BAD_PAGE_PROCESS',
  'DBMIRROR_EVENTS_QUEUE', 'BROKER_RECEIVE_WAITFOR',
  'PREEMPTIVE_OS_GETPROCADDRESS', 'PREEMPTIVE_OS_AUTHENTICATIONOPS', 'WAITFOR',
  'DISPATCHER_QUEUE_SEMAPHORE', 'XE_DISPATCHER_JOIN', 'RESOURCE_QUEUE' )
ORDER BY wait_time_ms DESC


-- Listing 1.3: Clearing the wait statistics on a server.
DBCC SQLPERF('sys.dm_os_wait_stats', clear)


-- Listing 1.4: Virtual file statistics.
SELECT  DB_NAME(vfs.database_id) AS database_name ,
        vfs.database_id ,
        vfs.file_id ,
        io_stall_read_ms / NULLIF(num_of_reads, 0) AS avg_read_latency ,
        io_stall_write_ms / NULLIF(num_of_writes, 0) AS avg_write_latency ,
        io_stall_write_ms / NULLIF(num_of_writes + num_of_writes, 0) AS avg_total_latency ,
        num_of_bytes_read / NULLIF(num_of_reads, 0) AS avg_bytes_per_read ,
        num_of_bytes_written / NULLIF(num_of_writes, 0) AS avg_bytes_per_write ,
        vfs.io_stall ,
        vfs.num_of_reads ,
        vfs.num_of_bytes_read ,
        vfs.io_stall_read_ms ,
        vfs.num_of_writes ,
        vfs.num_of_bytes_written ,
        vfs.io_stall_write_ms ,
        size_on_disk_bytes / 1024 / 1024. AS size_on_disk_mbytes ,
        physical_name
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
        JOIN sys.master_files AS mf ON vfs.database_id = mf.database_id
                                       AND vfs.file_id = mf.file_id
ORDER BY avg_total_latency DESC

-- Listing 1.5: SQL Server performance counters.
-- Capture the first counter set
SELECT  CAST(1 AS INT) AS collection_instance ,
        object_name ,
        counter_name ,
        instance_name ,
        cntr_value ,
        cntr_type ,
        CURRENT_TIMESTAMP AS collection_time
INTO    #perf_counters_init
FROM    sys.dm_os_performance_counters
WHERE   ( object_name = 'SQLServer:Access Methods'
          AND counter_name = 'Full Scans/sec'
        )
        OR ( object_name = 'SQLServer:Access Methods'
             AND counter_name = 'Index Searches/sec'
           )
        OR ( object_name = 'SQLServer:Buffer Manager'
             AND counter_name = 'Lazy Writes/sec'
           )
        OR ( object_name = 'SQLServer:Buffer Manager'
             AND counter_name = 'Page life expectancy'
           )
        OR ( object_name = 'SQLServer:General Statistics'
             AND counter_name = 'Processes Blocked'
           )
        OR ( object_name = 'SQLServer:General Statistics'
             AND counter_name = 'User Connections'
           )
        OR ( object_name = 'SQLServer:Locks'
             AND counter_name = 'Lock Waits/sec'
           )
        OR ( object_name = 'SQLServer:Locks'
             AND counter_name = 'Lock Wait Time (ms)'
           )
        OR ( object_name = 'SQLServer:SQL Statistics'
             AND counter_name = 'SQL Re-Compilations/sec'
           )
        OR ( object_name = 'SQLServer:Memory Manager'
             AND counter_name = 'Memory Grants Pending'
           )
        OR ( object_name = 'SQLServer:SQL Statistics'
             AND counter_name = 'Batch Requests/sec'
           )
        OR ( object_name = 'SQLServer:SQL Statistics'
             AND counter_name = 'SQL Compilations/sec'
           )
-- Wait on Second between data collection
WAITFOR DELAY '00:00:01'
-- Capture the second counter set
SELECT  CAST(2 AS INT) AS collection_instance ,
        object_name ,
        counter_name ,
        instance_name ,
        cntr_value ,
        cntr_type ,
        CURRENT_TIMESTAMP AS collection_time
INTO    #perf_counters_second
FROM    sys.dm_os_performance_counters
WHERE   ( object_name = 'SQLServer:Access Methods'
          AND counter_name = 'Full Scans/sec'
        )
        OR ( object_name = 'SQLServer:Access Methods'
             AND counter_name = 'Index Searches/sec'
           )
        OR ( object_name = 'SQLServer:Buffer Manager'
             AND counter_name = 'Lazy Writes/sec'
           )
        OR ( object_name = 'SQLServer:Buffer Manager'
             AND counter_name = 'Page life expectancy'
           )
        OR ( object_name = 'SQLServer:General Statistics'
             AND counter_name = 'Processes Blocked'
           )
        OR ( object_name = 'SQLServer:General Statistics'
             AND counter_name = 'User Connections'
           )
        OR ( object_name = 'SQLServer:Locks'
             AND counter_name = 'Lock Waits/sec'
           )
        OR ( object_name = 'SQLServer:Locks'
             AND counter_name = 'Lock Wait Time (ms)'
           )
        OR ( object_name = 'SQLServer:SQL Statistics'
             AND counter_name = 'SQL Re-Compilations/sec'
           )
        OR ( object_name = 'SQLServer:Memory Manager'
             AND counter_name = 'Memory Grants Pending'
           )
        OR ( object_name = 'SQLServer:SQL Statistics'
             AND counter_name = 'Batch Requests/sec'
           )
        OR ( object_name = 'SQLServer:SQL Statistics'
             AND counter_name = 'SQL Compilations/sec'
           )
-- Calculate the cumulative counter values
SELECT  i.object_name ,
        i.counter_name ,
        i.instance_name ,
        CASE WHEN i.cntr_type = 272696576 THEN s.cntr_value - i.cntr_value
             WHEN i.cntr_type = 65792 THEN s.cntr_value
        END AS cntr_value
FROM    #perf_counters_init AS i
        JOIN #perf_counters_second AS s ON i.collection_instance + 1 = s.collection_instance
                                           AND i.object_name = s.object_name
                                           AND i.counter_name = s.counter_name
                                           AND i.instance_name = s.instance_name
ORDER BY object_name
-- Cleanup tables
DROP TABLE #perf_counters_init
DROP TABLE #perf_counters_second


-- Listing 1.6: SQL Server execution statistics.
SELECT TOP 10
        execution_count ,
        statement_start_offset AS stmt_start_offset ,
        sql_handle ,
        plan_handle ,
        total_logical_reads / execution_count AS avg_logical_reads ,
        total_logical_writes / execution_count AS avg_logical_writes ,
        total_physical_reads / execution_count AS avg_physical_reads ,
        t.text
FROM    sys.dm_exec_query_stats AS s
        CROSS APPLY sys.dm_exec_sql_text(s.sql_handle) AS t
ORDER BY avg_physical_reads DESC


-- Listing 3.1: Verifying CPU pressure via signal wait time.
SELECT  SUM(signal_wait_time_ms) AS TotalSignalWaitTime ,
        ( SUM(CAST(signal_wait_time_ms AS NUMERIC(20, 2)))
          / SUM(CAST(wait_time_ms AS NUMERIC(20, 2))) * 100 ) AS PercentageSignalWaitsOfTotalTime
FROM    sys.dm_os_wait_stats


-- Listing 3.2: Finding the top 10 wait events (cumulative).
SELECT TOP ( 10 )
        wait_type ,
        waiting_tasks_count ,
        ( wait_time_ms - signal_wait_time_ms ) AS resource_wait_time ,
        max_wait_time_ms ,
        CASE waiting_tasks_count
          WHEN 0 THEN 0
          ELSE wait_time_ms / waiting_tasks_count
        END AS avg_wait_time
FROM    sys.dm_os_wait_stats
WHERE   wait_type NOT LIKE '%SLEEP%' -- remove eg. SLEEP_TASK and
-- LAZYWRITER_SLEEP waits
        AND wait_type NOT LIKE 'XE%'
        AND wait_type NOT IN -- remove system waits
( 'KSOURCE_WAKEUP', 'BROKER_TASK_STOP', 'FT_IFTS_SCHEDULER_IDLE_WAIT',
  'SQLTRACE_BUFFER_FLUSH', 'CLR_AUTO_EVENT', 'BROKER_EVENTHANDLER',
  'BAD_PAGE_PROCESS', 'BROKER_TRANSMITTER', 'CHECKPOINT_QUEUE',
  'DBMIRROR_EVENTS_QUEUE', 'SQLTRACE_BUFFER_FLUSH', 'CLR_MANUAL_EVENT',
  'ONDEMAND_TASK_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 'LOGMGR_QUEUE',
  'BROKER_RECEIVE_WAITFOR', 'PREEMPTIVE_OS_GETPROCADDRESS',
  'PREEMPTIVE_OS_AUTHENTICATIONOPS', 'BROKER_TO_FLUSH' )
ORDER BY wait_time_ms DESC
-- **** Author: Jonathan Kaheyias ****


--Listing 3.3: Investigating scheduler queues.
SELECT  scheduler_id ,
        current_tasks_count ,
        runnable_tasks_count
FROM    sys.dm_os_schedulers
WHERE   scheduler_id < 255

-- Listing 3.4: Finding the top ten CPU-consuming queries.
SELECT TOP ( 10 )
        SUBSTRING(ST.text, ( QS.statement_start_offset / 2 ) + 1,
                  ( ( CASE statement_end_offset
                        WHEN -1 THEN DATALENGTH(st.text)
                        ELSE QS.statement_end_offset
                      END - QS.statement_start_offset ) / 2 ) + 1) AS statement_text ,
        execution_count ,
        total_worker_time / 1000 AS total_worker_time_ms ,
        ( total_worker_time / 1000 ) / execution_count AS avg_worker_time_ms ,
        total_logical_reads ,
        total_logical_reads / execution_count AS avg_logical_reads ,
        total_elapsed_time / 1000 AS total_elapsed_time_ms ,
        ( total_elapsed_time / 1000 ) / execution_count AS avg_elapsed_time_ms ,
        qp.query_plan
FROM    sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
        CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY total_worker_time DESC


-- Listing 3.5: A simple query in AdventureWorks.
SELECT  per.FirstName ,
        per.LastName ,
        p.Name ,
        p.ProductNumber ,
        OrderDate ,
        LineTotal ,
        soh.TotalDue
FROM    Sales.SalesOrderHeader AS soh
        INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
        INNER JOIN Production.Product AS p ON sod.ProductID = p.ProductID
        INNER JOIN Sales.Customer AS c ON soh.CustomerID = c.CustomerID
        INNER JOIN Person.Person AS per ON c.PersonID = per.BusinessEntityID
WHERE   LineTotal > 25000


-- Listing 3.6: Adding an index to the LineTotal column in AdventureWorks.
CREATE NONCLUSTERED INDEX idx_SalesOrderDetail_LineTotal
ON Sales.SalesOrderDetail (LineTotal)


-- Listing 3.7: A non-SARGable predicate in the search condition.
SELECT  soh.SalesOrderID ,
        OrderDate ,
        DueDate ,
        ShipDate ,
        Status ,
        SubTotal ,
        TaxAmt ,
        Freight ,
        TotalDue
FROM    Sales.SalesOrderheader AS soh
        INNER JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
WHERE   CONVERT(VARCHAR(10), sod.ModifiedDate, 101) = '01/01/2010'


-- Listing 3.8: A SARGable predicate in the search condition.
SELECT  soh.SalesOrderID ,
        OrderDate ,
        DueDate ,
        ShipDate ,
        Status ,
        SubTotal ,
        TaxAmt ,
        Freight ,
        TotalDue
FROM    Sales.SalesOrderheader AS soh
        INNER JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
WHERE   sod.ModifiedDate >= '2010/01/01'
        AND sod.ModifiedDate < '2010/01/02'


-- Listing 3.9: An implicit data type conversion in the search condition.
SELECT  p.FirstName ,
        p.LastName ,
        c.AccountNumber
FROM    Sales.Customer AS c
        INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID
WHERE   AccountNumber = N'AW00029594'


-- Listing 3.10: The user_GetCustomerShipDates stored procedure.
CREATE PROCEDURE user_GetCustomerShipDates
    (
      @ShipDateStart DATETIME ,
      @ShipDateEnd DATETIME
    )
AS 
    SELECT  CustomerID ,
            SalesOrderNumber
    FROM    Sales.SalesOrderHeader
    WHERE   ShipDate BETWEEN @ShipDateStart AND @ShipDateEnd
GO

-- Listing 3.11: A non-clustered index on the ShipDate column.
CREATE NONCLUSTERED INDEX IDX_ShipDate_ASC
ON Sales.SalesOrderHeader (ShipDate)
GO

-- Listing 3.12: Executing the user_GetCustomerShipDates stored procedure, with the large
-- date range query first.
DBCC FREEPROCCACHE
EXEC user_GetCustomerShipDates '2001/07/08', '2004/01/01'
EXEC user_GetCustomerShipDates '2001/07/10', '2001/07/20'


-- Listing 3.13: Executing the user_GetCustomerShipDates stored procedure, with the shorter date range query first.
DBCC FREEPROCCACHE
EXEC user_GetCustomerShipDates '2001/07/10', '2001/07/20'
EXEC user_GetCustomerShipDates '2001/07/08', '2004/01/01'

-- Listing 3.14: Using the OPTIMIZE FOR query hint.
CREATE PROCEDURE user_GetCustomerShipDates
    (
      @ShipDateStart DATETIME ,
      @ShipDateEnd DATETIME
    )
AS 
    SELECT  CustomerID ,
            SalesOrderNumber
    FROM    Sales.SalesOrderHeader
    WHERE   ShipDate BETWEEN @ShipDateStart AND @ShipDateEnd
    OPTION  ( OPTIMIZE FOR ( @ShipDateStart = '2001/07/08',
@ShipDateEnd = '2004/01/01' ) )
GO

-- Listing 3.15: Using the WITH RECOMPILE option.
CREATE PROCEDURE user_GetCustomerShipDates
    (
      @ShipDateStart DATETIME ,
      @ShipDateEnd DATETIME
    )
    WITH RECOMPILE
AS 
    SELECT  CustomerID ,
            SalesOrderNumber
    FROM    Sales.SalesOrderHeader
    WHERE   ShipDate BETWEEN @ShipDateStart AND @ShipDateEnd
GO

-- Listing 3.16: Using the OPTION(RECOMPILE) query hint.
CREATE PROCEDURE user_GetCustomerShipDates
    (
      @ShipDateStart DATETIME ,
      @ShipDateEnd DATETIME
    )
AS 
    SELECT  CustomerID ,
            SalesOrderNumber
    FROM    Sales.SalesOrderHeader
    WHERE   ShipDate BETWEEN @ShipDateStart AND @ShipDateEnd
    OPTION  ( RECOMPILE )
GO

-- Listing 3.17: Three simple but non-parameterized queries.
SELECT  soh.SalesOrderNumber ,
        sod.ProductID
FROM    Sales.SalesOrderHeader AS soh
        INNER JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
WHERE   soh.SalesOrderNumber = 'SO43662'
SELECT  soh.SalesOrderNumber ,
        sod.ProductID
FROM    Sales.SalesOrderHeader AS soh
        INNER JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
WHERE   soh.SalesOrderNumber = 'SO58928'
SELECT  soh.SalesOrderNumber ,
        sod.ProductID
FROM    Sales.SalesOrderHeader AS soh
        INNER JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
WHERE   soh.SalesOrderNumber = 'SO70907'


-- Listing 3.20: Setting the PARAMETERIZATION option to FORCED.
ALTER DATABASE AdventureWorks SET PARAMETERIZATION FORCED

-- Listing 3.21: Enabling the optimize for ad hoc workloads setting.
EXEC sp_configure 'show advanced options', 1
RECONFIGURE
EXEC sp_configure 'optimize for ad hoc workloads', 1
RECONFIGURE

-- Listing 3.22: Determining the estimated cost of parallel execution plans.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
WITH XMLNAMESPACES
(DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
SELECT  query_plan AS CompleteQueryPlan ,
        n.value('(@StatementText)[1]', 'VARCHAR(4000)') AS StatementText ,
        n.value('(@StatementOptmLevel)[1]', 'VARCHAR(25)') AS StatementOptimizationLevel ,
        n.value('(@StatementSubTreeCost)[1]', 'VARCHAR(128)') AS StatementSubTreeCost ,
        n.query('.') AS ParallelSubTreeXML ,
        ecp.usecounts ,
        ecp.size_in_bytes
FROM    sys.dm_exec_cached_plans AS ecp
        CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS eqp
        CROSS APPLY query_plan.nodes('/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple')
        AS qn ( n )
WHERE   n.query('.').exist('//RelOp[@PhysicalOp="Parallelism"]') = 1

-- Listing 3.23: Finding the size of the TokenAndPermUserStore cache.
SELECT  SUM(single_pages_kb + multi_pages_kb) / 1024.0 AS CacheSizeMB
FROM    sys.dm_os_memory_clerks
WHERE   [name] = 'TokenAndPermUserStore'

-- Listing 3.24: Freeing space in the TokenAndPermUserStore cache.
DBCC FREESYSTEMCACHE ('TokenAndPermUserStore')


CREATE INDEX idx_Test ON TestTable (Col2, Col1, Col3)
SELECT  1
FROM    TestTable
WHERE   Col1 = @Var1
        AND Col2 = @Var2
        AND Col3 = @Var3
SELECT  1
FROM    TestTable
WHERE   Col1 = @Var1
        AND Col3 = @Var3
SELECT  1
FROM    TestTable
WHERE   Col2 = @Var2
        AND Col3 = @Var3


-- Listing 5.2: Three possible pairs of indexes.
--3 possible pairs of indexes
CREATE INDEX idx_Test1
ON TestTable (Col1, Col3, Col2)
CREATE INDEX idx_Test1
ON TestTable (Col2, Col3)
--OR—
CREATE INDEX idx_Test
ON TestTable (Col2, Col3, Col1)
CREATE INDEX idx_Test1
ON TestTable (Col1, Col3)
--OR--
CREATE INDEX idx_Test
ON TestTable (Col3, Col1, Col2)
CREATE INDEX idx_Test1
ON TestTable (Col2, Col3)

-- Listing 5.3: Three queries against AdventureWorks.
SELECT  BusinessEntityID ,
        PersonType ,
        FirstName ,
        MiddleName ,
        LastName ,
        EmailPromotion
FROM    Person.Person AS p
WHERE   FirstName = 'Carol'
        AND PersonType = 'SC'
SELECT  BusinessEntityID ,
        FirstName ,
        LastName
FROM    Person.Person AS p
WHERE   PersonType = 'GC'
        AND Title = 'Ms.'
SELECT  BusinessEntityID ,
        PersonType ,
        EmailPromotion
FROM    Person.Person AS p
WHERE   Title = 'Mr.'
        AND FirstName = 'Paul'
        AND LastName = 'Shakespear'

-- Listing 5.4: Two indexes, designed based on column selectivity.
CREATE INDEX idx_Person_FirstNameLastNameTitleType
ON Person.Person (FirstName, LastName, Title, PersonType)
CREATE INDEX idx_Person_TypeTitle
ON Person.Person (PersonType, Title)

-- Listing 5.5: An AdventureWorks query.
SELECT  BusinessEntityID ,
        FirstName ,
        LastName
FROM    Person.Person AS p
WHERE   PersonType = 'GC'
        AND Title = 'Ms.'

-- Listing 5.6: A non-covering index.
CREATE INDEX idx_Person_TypeTitle
ON Person.Person (Title, PersonType)

-- Listing 5.7: Adding included columns to cover a query.
CREATE INDEX idx_Person_TypeTitle
ON Person.Person (Title, PersonType)
INCLUDE (BusinessEntityID, FirstName, LastName)

-- Listing 5.8: The complete, edited server-side tuning trace.
DECLARE @rc INT
DECLARE @TraceID INT
DECLARE @maxfilesize BIGINT
SET @maxfilesize = 50
EXEC @rc = sp_trace_create @TraceID OUTPUT, 0, N'InsertFileNameHere',
    @maxfilesize, NULL
IF ( @rc != 0 ) 
    GOTO error
-- Client side File and Table cannot be scripted
-- Set the events
DECLARE @on BIT
SET @on = 1
EXEC sp_trace_setevent @TraceID, 137, 15, @on
EXEC sp_trace_setevent @TraceID, 137, 1, @on
EXEC sp_trace_setevent @TraceID, 137, 13, @on
-- Set the Filters
DECLARE @intfilter INT
DECLARE @bigintfilter BIGINT
-- Set the trace status to start
EXEC sp_trace_setstatus @TraceID, 1
-- display trace id for future references
SELECT  TraceID = @TraceID
GOTO finish
error:
SELECT  ErrorCode = @rc
finish:
go

-- Listing 5.9: Identifying missing indexes based on query cost benefit.
SELECT  migs.avg_total_user_cost * ( migs.avg_user_impact / 100.0 )
        * ( migs.user_seeks + migs.user_scans ) AS improvement_measure ,
        'CREATE INDEX [missing_index_'
        + CONVERT (VARCHAR, mig.index_group_handle) + '_'
        + CONVERT (VARCHAR, mid.index_handle) + '_'
        + LEFT(PARSENAME(mid.statement, 1), 32) + ']' + ' ON ' + mid.statement
        + ' (' + ISNULL(mid.equality_columns, '')
        + CASE WHEN mid.equality_columns IS NOT NULL
                    AND mid.inequality_columns IS NOT NULL THEN ','
               ELSE ''
          END + ISNULL(mid.inequality_columns, '') + ')' + ISNULL(' INCLUDE ('
                                                              + mid.included_columns
                                                              + ')', '') AS create_index_statement ,
        migs.* ,
        mid.database_id ,
        mid.[object_id]
FROM    sys.dm_db_missing_index_groups mig
        INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
        INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE   migs.avg_total_user_cost * ( migs.avg_user_impact / 100.0 )
        * ( migs.user_seeks + migs.user_scans ) > 10
ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * ( migs.user_seeks
                                                             + migs.user_scans ) DESC

-- Listing 5.10: Parsing missing index information out of XML showplans.
;
WITH XMLNAMESPACES
(DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
SELECT  MissingIndexNode.value('(MissingIndexGroup/@Impact)[1]', 'float') AS impact ,
        OBJECT_NAME(sub.objectid, sub.dbid) AS calling_object_name ,
        MissingIndexNode.value('(MissingIndexGroup/MissingIndex/@Database)[1]',
                               'VARCHAR(128)') + '.'
        + MissingIndexNode.value('(MissingIndexGroup/MissingIndex/@Schema)[1]',
                                 'VARCHAR(128)') + '.'
        + MissingIndexNode.value('(MissingIndexGroup/MissingIndex/@Table)[1]',
                                 'VARCHAR(128)') AS table_name ,
        STUFF(( SELECT  ',' + c.value('(@Name)[1]', 'VARCHAR(128)')
                FROM    MissingIndexNode.nodes('MissingIndexGroup/MissingIndex/
ColumnGroup[@Usage="EQUALITY"]/Column') AS t ( c )
              FOR
                XML PATH('')
              ), 1, 1, '') AS equality_columns ,
        STUFF(( SELECT  ',' + c.value('(@Name)[1]', 'VARCHAR(128)')
                FROM    MissingIndexNode.nodes('MissingIndexGroup/MissingIndex/
ColumnGroup[@Usage="INEQUALITY"]/Column') AS t ( c )
              FOR
                XML PATH('')
              ), 1, 1, '') AS inequality_columns ,
        STUFF(( SELECT  ',' + c.value('(@Name)[1]', 'VARCHAR(128)')
                FROM    MissingIndexNode.nodes('MissingIndexGroup/MissingIndex/
ColumnGroup[@Usage="INCLUDE"]/Column') AS t ( c )
              FOR
                XML PATH('')
              ), 1, 1, '') AS include_columns ,
        sub.usecounts AS qp_usecounts ,
        sub.refcounts AS qp_refcounts ,
        qs.execution_count AS qs_execution_count ,
        qs.last_execution_time AS qs_last_exec_time ,
        qs.total_logical_reads AS qs_total_logical_reads ,
        qs.total_elapsed_time AS qs_total_elapsed_time ,
        qs.total_physical_reads AS qs_total_physical_reads ,
        qs.total_worker_time AS qs_total_worker_time ,
        StmtPlanStub.value('(StmtSimple/@StatementText)[1]', 'varchar(8000)') AS statement_text
FROM    ( SELECT    ROW_NUMBER() OVER ( PARTITION BY qs.plan_handle ORDER BY qs.statement_start_offset ) AS StatementID ,
                    qs.*
          FROM      sys.dm_exec_query_stats qs
        ) AS qs
        JOIN ( SELECT   x.query('../../..') AS StmtPlanStub ,
                        x.query('.') AS MissingIndexNode ,
                        x.value('(../../../@StatementId)[1]', 'int') AS StatementID ,
                        cp.* ,
                        qp.*
               FROM     sys.dm_exec_cached_plans AS cp
                        CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) qp
                        CROSS APPLY qp.query_plan.nodes('/ShowPlanXML/BatchSequence/
Batch/Statements/StmtSimple/
QueryPlan/MissingIndexes/
MissingIndexGroup') mi ( x )
             ) AS sub ON qs.plan_handle = sub.plan_handle
                         AND qs.StatementID = sub.StatementID


-- Listing 5.11: Identifying single-column, non-indexed FOREIGN KEYs.
SELECT  fk.name AS CONSTRAINT_NAME ,
        s.name AS SCHEMA_NAME ,
        o.name AS TABLE_NAME ,
        fkc_c.name AS CONSTRAINT_COLUMN_NAME
FROM    sys.foreign_keys AS fk
        JOIN sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
        JOIN sys.columns AS fkc_c ON fkc.parent_object_id = fkc_c.object_id
                                     AND fkc.parent_column_id = fkc_c.column_id
        LEFT JOIN sys.index_columns ic
        JOIN sys.columns AS c ON ic.object_id = c.object_id
                                 AND ic.column_id = c.column_id ON fkc.parent_object_id = ic.object_id
                                                              AND fkc.parent_column_id = ic.column_id
        JOIN sys.objects AS o ON o.object_id = fk.parent_object_id
        JOIN sys.schemas AS s ON o.schema_id = s.schema_id
WHERE   c.name IS NULL


-- Listing 5.12: Finding unused non-clustered indexes.
SELECT  OBJECT_SCHEMA_NAME(i.object_id) AS SchemaName ,
        OBJECT_NAME(i.object_id) AS TableName ,
        i.name ,
        ius.user_seeks ,
        ius.user_scans ,
        ius.user_lookups ,
        ius.user_updates
FROM    sys.dm_db_index_usage_stats AS ius
        JOIN sys.indexes AS i ON i.index_id = ius.index_id
                                 AND i.object_id = ius.object_id
WHERE   ius.database_id = DB_ID()
        AND i.is_unique_constraint = 0 -- no unique indexes
        AND i.is_primary_key = 0
        AND i.is_disabled = 0
        AND i.type > 1 -- don't consider heaps/clustered index
        AND ( ( ius.user_seeks + ius.user_scans + ius.user_lookups ) < ius.user_updates
              OR ( ius.user_seeks = 0
                   AND ius.user_scans = 0
                 )
            )

-- Listing 6.1: Using sysprocesses to find blocking.
SELECT  spid ,
        status ,
        blocked ,
        open_tran ,
        waitresource ,
        waittype ,
        waittime ,
        cmd ,
        lastwaittype
FROM    master.dbo.sysprocesses
WHERE   blocked <> 0

-- Listing 6.2: An uncommitted INSERT transaction in AdventureWorks 2008.
DECLARE @SalesOrderHeaderID INT
BEGIN TRANSACTION
INSERT  INTO Sales.SalesOrderHeader
        ( RevisionNumber ,
          OrderDate ,
          DueDate ,
          ShipDate ,
          Status ,
          OnlineOrderFlag ,
          PurchaseOrderNumber ,
          AccountNumber ,
          CustomerID ,
          SalesPersonID ,
          TerritoryID ,
          BillToAddressID ,
          ShipToAddressID ,
          ShipMethodID ,
          CreditCardID ,
          CreditCardApprovalCode ,
          CurrencyRateID ,
          Comment ,
          rowguid ,
          ModifiedDate
        )
VALUES  ( 5 ,
          '2011/06/20' ,
          '2011/06/25' ,
          '2011/06/30' ,
          5 ,
          0 ,
          NULL ,
          '10-4030-018749' ,
          18749 ,
          NULL ,
          6 ,
          28374 ,
          28374 ,
          1 ,
          8925 ,
          '929849Vi46003' ,
          NULL ,
          NULL ,
          NEWID() ,
          GETDATE()
        )
SET @SalesOrderHeaderID = @@IDENTITY
INSERT  INTO Sales.SalesOrderDetail
        ( SalesOrderID, CarrierTrackingNumber, OrderQty, ProductID,
          SpecialOfferID, UnitPrice, UnitPriceDiscount, rowguid, ModifiedDate )
VALUES  ( @SalesOrderHeaderID, '4911-403C-98', 15, 722, 1, 2039.994, 0,
          NEWID(), GETDATE() ),
        ( @SalesOrderHeaderID, '4911-403C-98', 4, 709, 1, 5.70, 0, NEWID(),
          GETDATE() ),
        ( @SalesOrderHeaderID, '4911-403C-98', 24, 716, 1, 28.8404, 0, NEWID(),
          GETDATE() )

-- Listing 6.3: A query against the SalesOrderHeader table.
SELECT  FirstName ,
        LastName ,
        SUM(soh.TotalDue) AS TotalDue ,
        MAX(OrderDate) AS LastOrder
FROM    Sales.SalesOrderHeader AS soh
        INNER JOIN Sales.Customer AS c ON soh.CustomerID = c.CustomerID
        INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID
WHERE   soh.OrderDate >= '2011/01/01'
GROUP BY c.CustomerID ,
        FirstName ,
        LastName

-- Listing 6.4: Find blocking with sys.dm_exec_requests and sys.dm_exec_sessions.
SELECT  er.session_id ,
        host_name ,
        program_name ,
        original_login_name ,
        er.reads ,
        er.writes ,
        er.cpu_time ,
        wait_type ,
        wait_time ,
        wait_resource ,
        blocking_session_id ,
        st.text
FROM    sys.dm_exec_sessions es
        LEFT JOIN sys.dm_exec_requests er ON er.session_id = es.session_id
        OUTER APPLY sys.dm_exec_sql_text(er.sql_handle) st
WHERE   blocking_session_id > 0
UNION
SELECT  es.session_id ,
        host_name ,
        program_name ,
        original_login_name ,
        es.reads ,
        es.writes ,
        es.cpu_time ,
        wait_type ,
        wait_time ,
        wait_resource ,
        blocking_session_id ,
        st.text
FROM    sys.dm_exec_sessions es
        LEFT JOIN sys.dm_exec_requests er ON er.session_id = es.session_id
        OUTER APPLY sys.dm_exec_sql_text(er.sql_handle) st
WHERE   es.session_id IN ( SELECT   blocking_session_id
                           FROM     sys.dm_exec_requests
                           WHERE    blocking_session_id > 0 )

-- Listing 6.5: Finding the command that caused blocking via sys.dm_exec_connections.
SELECT  ec.session_id ,
        ec.connect_time ,
        st.dbid AS DatabaseID ,
        st.objectid ,
        st.text
FROM    sys.dm_exec_connections ec
        CROSS APPLY sys.dm_exec_sql_text(ec.most_recent_sql_handle) st
WHERE   session_id = 52

-- Listing 6.6: Investigating blocking using the sys.dm_os_waiting_tasks DMV.
SELECT  blocking.session_id AS blocking_session_id ,
        blocked.session_id AS blocked_session_id ,
        waitstats.wait_type AS blocking_resource ,
        waitstats.wait_duration_ms ,
        waitstats.resource_description ,
        blocked_cache.text AS blocked_text ,
        blocking_cache.text AS blocking_text
FROM    sys.dm_exec_connections AS blocking
        INNER JOIN sys.dm_exec_requests blocked ON blocking.session_id = blocked.blocking_session_id
        CROSS APPLY sys.dm_exec_sql_text(blocked.sql_handle) blocked_cache
        CROSS APPLY sys.dm_exec_sql_text(blocking.most_recent_sql_handle) blocking_cache
        INNER JOIN sys.dm_os_waiting_tasks waitstats ON waitstats.session_id = blocked.session_id


-- Listing 6.7: Querying the sys.dm_tran_locks DMV.
SELECT  request_session_id ,
        resource_type ,
        DB_NAME(resource_database_id) AS DatabaseName ,
        resource_associated_entity_id ,
        resource_description ,
        request_mode ,
        request_status
FROM    sys.dm_tran_locks AS dtl
WHERE   request_session_id IN ( 52, 53 )
        AND resource_type NOT IN ( 'DATABASE', 'METADATA' )

-- Listing 6.8: Clearing existing wait statistics using DBCC SQLPERF.
DBCC SQLPERF("sys.dm_os_wait_stats",CLEAR) ;

-- Listing 6.9: Enabling the blocked process report and setting the threshold.
sp_configure 'show advanced options', 1 
go
RECONFIGURE
go
sp_configure 'blocked process threshold', 2
go
RECONFIGURE
go

-- Listing 6.11: Enable Service Broker.
ALTER DATABASE AdventureWorks SET ENABLE_BROKER
GO

-- Listing 6.12: Create the Service Broker queue.
CREATE QUEUE systemeventqueue
GO

-- Listing 6.13: Create the Service Broker service.
CREATE SERVICE systemeventservice
ON QUEUE systemeventqueue ( [http://schemas.microsoft.com/SQL/Notifications/
PostEventNotification] )
GO

-- Listing 6.14: Create the event notification for blocking events.
CREATE EVENT NOTIFICATION notification_blocking
ON SERVER
WITH FAN_IN
FOR blocked_process_report
TO SERVICE 'systemeventservice', 'current database' ;
GO

-- Listing 7.1: Turning on Trace Flag 1204 for all sessions.
DBCC TRACEON(1204, -1)

-- Listing 7.2: Creating the Service Broker service, queue, and event notification objects.
USE msdb ;
-- Create a service broker queue to hold the events
CREATE QUEUE DeadlockQueue
GO
-- Create a service broker service receive the events
CREATE SERVICE DeadlockService
ON QUEUE DeadlockQueue ([http://schemas.microsoft.com/SQL/Notifications/
PostEventNotification])
GO
-- Create the event notification for deadlock graphs on the service
CREATE EVENT NOTIFICATION CaptureDeadlocks
ON SERVER
WITH FAN_IN
FOR DEADLOCK_GRAPH
TO SERVICE 'DeadlockService', 'current database' ;
GO

-- Listing 7.3: Query and processing DEADLOCK_GRAPH event messages in the queue.
USE msdb ;
-- Cast message_body to XML and query deadlock graph from TextData
SELECT  message_body.valuequery('(/EVENT_INSTANCE/TextData/deadlock-list)[1]','varchar(128)') AS DeadlockGraph
FROM    ( SELECT    CAST(message_body AS XML) AS message_body
          FROM      DeadlockQueue
        ) AS sub ;
GO
-- Receive the next available message FROM the queue
DECLARE @message_body XML ;
RECEIVE TOP(1) -- just handle one message at a time
@message_body=message_body
FROM DeadlockQueue ;
-- Query deadlock graph from TextData
SELECT  @message_body.valuequery('(/EVENT_INSTANCE/TextData/deadlock-list)[1]', 'varchar(128)') AS DeadlockGraph
GO

-- Listing 7.4: Retrieving system_health session information.
SELECT  CAST(target_data AS XML) AS TargetData
FROM    sys.dm_xe_session_targets st
        JOIN sys.dm_xe_sessions s ON s.address = st.event_session_address
WHERE   name = 'system_health'

-- Listing 7.5: Retrieving an XML deadlock graph.
SELECT  CAST(event_data.value('(event/data/value)[1]', 'varchar(max)') AS XML) AS DeadlockGraph
FROM    ( SELECT    XEvent.query('.') AS event_data
          FROM      ( -- Cast the target_data to XML
                      SELECT    CAST(target_data AS XML) AS TargetData
                      FROM      sys.dm_xe_session_targets st
                                JOIN sys.dm_xe_sessions s ON s.address = st.event_session_address
                      WHERE     name = 'system_health'
                                AND target_name = 'ring_buffer'
                    ) AS Data -- Split out the Event Nodes
                    CROSS APPLY TargetData.nodes('RingBufferTarget/event[@name="xml_deadlock_report"]') AS XEventData ( XEvent )
        ) AS tab ( event_data )


-- Listing 7.7: Finding the names of the objects associated with the deadlock.
SELECT  o.name AS TableName ,
        i.name AS IndexName
FROM    sysobjects AS o
        JOIN sysindexes AS i ON o.id = i.id
WHERE   o.id = 1993058136
        AND i.indid IN ( 1, 2 )


-- Listing 7.9: Identifying the objects involved in a deadlock involving page locks.
DBCC TRACEON(3604)
DBCC PAGE(8,1,96,1)
DBCC TRACEOFF(3604)

-- Listing 7.14: Transaction1 updates TableA then reads TableB.
BEGIN TRANSACTION
UPDATE  TableA
SET     Column1 = 1
SELECT  Column2
FROM    TableB

-- Listing 7.15: Transaction2 updates TableB then reads TableA.
BEGIN TRANSACTION
UPDATE  TableB
SET     Column2 = 1
SELECT  Column1
FROM    TableA

-- Listing 7.16: TRY…CATCH handling of deadlock exceptions, in T-SQL.
DECLARE @retries INT ;
SET @retries = 4 ;
WHILE ( @retries > 0 ) 
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION ;
-- place sql code here
            SET @retries = 0 ;
            COMMIT TRANSACTION ;
        END TRY
        BEGIN CATCH
-- Error is a deadlock
            IF ( ERROR_NUMBER() = 1205 ) 
                SET @retries = @retries - 1 ;
-- Error is not a deadlock
            ELSE 
                BEGIN
                    DECLARE @ErrorMessage NVARCHAR(4000) ;
                    DECLARE @ErrorSeverity INT ;
                    DECLARE @ErrorState INT ;
                    SELECT  @ErrorMessage = ERROR_MESSAGE() ,
                            @ErrorSeverity = ERROR_SEVERITY() ,
                            @ErrorState = ERROR_STATE() ;
-- Re-Raise the Error that caused the problem
                    RAISERROR (@ErrorMessage, -- Message text.
@ErrorSeverity, -- Severity.
@ErrorState -- State.
) ;
                    SET @retries = 0 ;
                END
            IF XACT_STATE() <> 0 
                ROLLBACK TRANSACTION ;
        END CATCH ;
    END ;
GO

-- Listing 7.18: Setting deadlock priority.
-- Set a Low deadlock priority
SET DEADLOCK_PRIORITY LOW ;
GO
-- Set a High deadlock priority
SET DEADLOCK_PRIORITY HIGH ;
GO
-- Set a numeric deadlock priority
SET DEADLOCK_PRIORITY 2 ;

-- Listing 8.1: Examining the value of the log_reuse_wait_desc column.
DECLARE @DatabaseName VARCHAR(50) ;
SET @DatabaseName = 'VeryImportant'
SELECT  name ,
        recovery_model_desc ,
        log_reuse_wait_desc
FROM    sys.databases
WHERE   name = @DatabaseName

-- Listing 8.2: Bulk data deletion.
DELETE  ExampleTable
WHERE   DateTimeCol < GETDATE() - 60
-- Listing 8.3: Breaking down data purges into smaller transactions.
DECLARE @StopDate DATETIME ,
    @PurgeDate DATETIME
SELECT  @PurgeDate = DATEADD(DAY, DATEDIFF(DAY, 0, MIN(DateTimeCol)), 0) ,
        @StopDate = DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()) - 60, 0)
FROM    ExampleTable
WHILE @PurgeDate < @StopDate 
    BEGIN
        DELETE  ExampleTable
        WHERE   DateTimeCol < @PurgeDate
        SELECT  @PurgeDate = DATEADD(DAY, 1, @PurgeDate)
    END

-- Listing 8.4: Using the TOP operator inside the DELETE statement for data purges.
DECLARE @Criteria DATETIME ,
    @RowCount INT
SELECT  @Criteria = GETDATE() - 60 ,
        @RowCount = 10000
WHILE @RowCount = 10000 
    BEGIN
        DELETE TOP ( 10000 )
        FROM    ExampleTable
        WHERE   DateTimeCol < @Criteria
        SELECT  @RowCount = @@ROWCOUNT
    END

-- Listing 8.5: Identifying orphaned or long-running transactions using the DMVs.
-- SQL 2000 sysprocess query
SELECT  spid ,
        status ,
        hostname ,
        program_name ,
        loginame ,
        login_time ,
        last_batch ,
        ( SELECT    text
          FROM      ::
                    fn_get_sql(sql_handle)
        ) AS [sql_text]
FROM    sysprocesses
WHERE   spid = <SPID>

-- SQL 2005/2008 DMV query
SELECT  s.session_id ,
        s.status ,
        s.host_name ,
        s.program_name ,
        s.login_name ,
        s.login_time ,
        s.last_request_start_time ,
        s.last_request_end_time ,
        t.text
FROM    sys.dm_exec_sessions s
        JOIN sys.dm_exec_connections c ON s.session_id = c.session_id
        CROSS APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) t
WHERE   s.session_id = <SPID>

-- Listing 8.6: Gathering information about the open transaction.
SELECT  st.session_id ,
        st.is_user_transaction ,
        dt.database_transaction_begin_time ,
        dt.database_transaction_log_record_count ,
        dt.database_transaction_log_bytes_used
FROM    sys.dm_tran_session_transactions st
        JOIN sys.dm_tran_database_transactions dt ON st.transaction_id = dt.transaction_id
                                                     AND dt.database_id = DB_ID('master')
WHERE   st.session_id = <SPID>

-- Listing 8.7: Determine when the last log backup was taken.
USE msdb ;
SELECT  backup_set_id ,
        backup_start_date ,
        backup_finish_date ,
        backup_size ,
        recovery_model ,
        [type]
FROM    dbo.backupset
WHERE   database_name = 'DatabaseName'


-- Listing 9.1: Setting AdventureWorks to use FULL recovery model.
USE [master]
GO
ALTER DATABASE [AdventureWorks] SET RECOVERY FULL
GO
BACKUP DATABASE [AdventureWorks]
TO DISK = N'D:\SQLBackups\AdventureWorks.bak'
WITH NOFORMAT,
INIT,
NAME = N'AdventureWorks-Full Database Backup',
SKIP,
STATS = 10,
CHECKSUM
GO

-- Listing 9.2: Insert data into ErrorLog; back up the AdventureWorks log.
USE [AdventureWorks]
GO
SELECT  ErrorTime ,
        UserName ,
        ErrorNumber ,
        ErrorSeverity ,
        ErrorState ,
        ErrorProcedure ,
        ErrorMessage
FROM    dbo.ErrorLog
GO
INSERT  INTO dbo.ErrorLog
        ( ErrorTime ,
          UserName ,
          ErrorNumber ,
          ErrorSeverity ,
          ErrorState ,
          ErrorProcedure ,
          ErrorMessage
        )
        SELECT  GETDATE() ,
                SYSTEM_USER ,
                100 ,
                12 ,
                1 ,
                'SomeProcedure' ,
                'Failed'
GO

SELECT  ErrorTime ,
        UserName ,
        ErrorNumber ,
        ErrorSeverity ,
        ErrorState ,
        ErrorProcedure ,
        ErrorMessage
FROM    dbo.ErrorLog
GO
BACKUP LOG [AdventureWorks]
TO DISK = N'D:\SQLBackups\AdventureWorks_Log1.bak'
WITH NOFORMAT,
INIT,
NAME = N'AdventureWorks-Transaction Log Backup',
SKIP,
STATS = 10
GO

-- Listing 9.3: An erroneous (marked) transaction deletes the SaleOrderDetail table.
BEGIN TRANSACTION Delete_Bad_SalesOrderDetail WITH MARK
DELETE  Sales.SalesOrderDetail
-- Forgotten WHERE clause = Oops
COMMIT TRANSACTION
GO
SELECT  SalesOrderID ,
        SalesOrderDetailID ,
        CarrierTrackingNumber ,
        OrderQty ,
        ProductID ,
        SpecialOfferID ,
        UnitPrice ,
        UnitPriceDiscount ,
        rowguid ,
        ModifiedDate
FROM    Sales.SalesOrderDetail
GO

-- Listing 9.4: Final log backup of the live transaction log.
USE [master]
GO
BACKUP LOG [AdventureWorks]
TO DISK = N'D:\SQLBackups\AdventureWorks_Log2.bak'
WITH NOFORMAT,
INIT,
NAME = N'AdventureWorks-Transaction Log Backup',
SKIP,
STATS = 10
GO

-- Listing 9.5: Full backup of the damaged database.
BACKUP DATABASE [AdventureWorks]
TO DISK = N'D:\SQLBackups\AdventureWorks_Damaged.bak'
WITH NOFORMAT,
INIT,
NAME = N'AdventureWorks-Damaged Full DB Backup',
SKIP,
STATS = 10,
CHECKSUM
GO

-- Listing 9.6: Restoring a copy of AdventureWorks from a full backup.
--Begin Recovery Process
RESTORE DATABASE [AdventureWorks_Copy]
FROM DISK = N'D:\SQLBackups\AdventureWorks.bak'
WITH FILE = 1,
MOVE N'AdventureWorks_Data' TO N'D:\SQLDATA\AdventureWorks_Copy.mdf',
MOVE N'AdventureWorks_Log' TO N'D:\SQLDATA\AdventureWorks_Copy_1.ldf',
NORECOVERY,
STATS = 10
GO

-- Listing 9.7: Restoring the first log backup.
RESTORE LOG [AdventureWorks_Copy]
FROM DISK = N'D:\SQLBackups\AdventureWorks_Log1.bak'
WITH FILE = 1,
NORECOVERY,
STATS = 10,
STOPBEFOREMARK = N'Delete_Bad_SalesOrderDetail'
GO

-- Listing 9.8: Restoring the second log backup, containing the marked transaction.
RESTORE LOG [AdventureWorks_Copy]
FROM DISK = N'D:\SQLBackups\AdventureWorks_Log2bak'
WITH FILE = 1,
NORECOVERY,
STATS = 10,
STOPBEFOREMARK = N'Delete_Bad_SalesOrderDetail'
GO

-- Listing 9.9: Recovering the AdventureWorks_Copy database.
RESTORE DATABASE [AdventureWorks_Copy]
WITH RECOVERY
GO

-- Listing 9.10: Inserting the lost data back into AdventureWorks.
USE [AdventureWorks]
GO
SET IDENTITY_INSERT Sales.SalesOrderDetail ON
INSERT  INTO Sales.SalesOrderDetail
        ( SalesOrderID ,
          SalesOrderDetailID ,
          CarrierTrackingNumber ,
          OrderQty ,
          ProductID ,
          SpecialOfferID ,
          UnitPrice ,
          UnitPriceDiscount ,
          rowguid ,
          ModifiedDate
        )
        SELECT  SalesOrderID ,
                SalesOrderDetailID ,
                CarrierTrackingNumber ,
                OrderQty ,
                ProductID ,
                SpecialOfferID ,
                UnitPrice ,
                UnitPriceDiscount ,
                rowguid ,
                ModifiedDate
        FROM    AdventureWorks_Copy.Sales.SalesOrderDetail
        WHERE   NOT EXISTS ( SELECT SalesOrderDetailID
                             FROM   Sales.SalesOrderDetail )
SET IDENTITY_INSERT Sales.SalesOrderDetail OFF
GO

-- Listing 9.11: Checking the state of the reinserted data.
-- comparing both data sets
SELECT  *
FROM    Sales.SalesOrderDetail
GO
SELECT  *
FROM    AdventureWorks_Copy.Sales.SalesOrderDetail
GO
-- data differences
SELECT  *
FROM    Sales.SalesOrderDetail
EXCEPT
SELECT  *
FROM    AdventureWorks_Copy.Sales.SalesOrderDetail
GO

-- Listing 9.12: Restoring a full backup of AdventureWorks in STANDBY.
--Begin Recovery Process
RESTORE DATABASE [AdventureWorks_Copy]
FROM DISK = N'D:\SQLBackups\AdventureWorks.bak'
WITH FILE = 1,
MOVE N'AdventureWorks_Data' TO N'D:\SQLDATA\AdventureWorks_Copy.mdf',
MOVE N'AdventureWorks_Log' TO N'D:\SQLDATA\AdventureWorks_Copy_1.ldf',
STANDBY = N'D:\SQLBackups\AdventureWorks_Copy_UNDO.bak',
STATS = 10
GO

-- Listing 9.13: Restoring log backups to the standby database.
RESTORE LOG [AdventureWorks_Copy]
FROM DISK = N'D:\SQLBackups\AdventureWorks_Log2.bak'
WITH FILE = 1,
STANDBY = N'D:\SQLBackups\AdventureWorks_Copy_UNDO.bak',
STATS = 10,
STOPAT = 'Jan 05, 2011 11:00 AM'
GO

-- Listing 9.14: Checking the recovery model.
-- SQL Server 2000
SELECT  name ,
        DATABASEPROPERTYEX(name, 'Recovery')
FROM    sysdatabases
-- SQL Server 2005/2008
SELECT  name ,
        recovery_model_desc
FROM    sys.databases

-- Listing 9.15: Querying sys.traces for the default trace characteristics.
SELECT  *
FROM    sys.traces
WHERE   is_default = 1 ;

-- Listing 9.16: Events collected by the default trace.
SELECT DISTINCT
        e.trace_event_id ,
        e.name
FROM    sys.fn_trace_geteventinfo (1) t
        JOIN sys.trace_events e ON t.eventID = e.trace_event_id

-- Listing 9.17: Reading a trace file using sys.fn_trace_gettable.
DECLARE @FileName NVARCHAR(260)
SELECT  @FileName = SUBSTRING(path, 0,
                              LEN(path) - CHARINDEX('\', REVERSE(path)) + 1)
        + '\Log.trc'
FROM    sys.traces
WHERE   is_default = 1 ;
SELECT  loginname ,
        hostname ,
        applicationname ,
        databasename ,
        objectName ,
        starttime ,
        e.name AS EventName ,
        databaseid
FROM    sys.fn_trace_gettable(@FileName, DEFAULT) AS gt
        INNER JOIN sys.trace_events e ON gt.EventClass = e.trace_event_id
WHERE   ( gt.EventClass = 47 -- Object:Deleted Event
-- from sys.trace_events
          OR gt.EventClass = 164
        ) -- Object:Altered Event from sys.trace_events
        AND gt.EventSubClass = 0
        AND gt.DatabaseID = DB_ID('AdventureWorks')

-- Listing 9.18: A DML trigger to log data changes to an audit table.
USE AdventureWorks
GO
CREATE TABLE Sales.SalesOrderDetailAudit
    (
      AuditID INT IDENTITY ,
      SalesOrderID INT ,
      SalesOrderDetailID INT ,
      CarrierTrackingNumber NVARCHAR(25) ,
      OrderQty SMALLINT ,
      ProductID INT ,
      SpecialOfferID INT ,
      UnitPrice MONEY ,
      UnitPriceDiscount MONEY ,
      LineTotal MONEY ,
      rowguid UNIQUEIDENTIFIER ,
      ModifiedDate DATETIME ,
      AuditAction VARCHAR(30) ,
      ChangeDate DATETIME ,
      ChangedBy SYSNAME ,
      CONSTRAINT PK_Audit_SalesOrderDetail_AuditID PRIMARY KEY CLUSTERED
        ( AuditID ASC )
    )
GO
CREATE TRIGGER SalesOrderDetail_AUDIT_TRIGGER ON Sales.SalesOrderDetail
    AFTER INSERT, UPDATE, DELETE
AS
    DECLARE @i_action VARCHAR(30) ,
        @d_action VARCHAR(30)
    SELECT  @i_action = 'INSERTED' ,
            @d_action = 'DELETED'
    IF EXISTS ( SELECT  1
                FROM    inserted )
        AND EXISTS ( SELECT 1
                     FROM   deleted )
--RECORD WAS UPDATED
        BEGIN
            SELECT  @i_action = 'UPDATED_TO' ,
                    @d_action = 'UPDATED_FROM'
        END
    INSERT  INTO Sales.SalesOrderDetailAudit
            ( SalesOrderID ,
              SalesOrderDetailID ,
              CarrierTrackingNumber ,
              OrderQty ,
              ProductID ,
              SpecialOfferID ,
              UnitPrice ,
              UnitPriceDiscount ,
              LineTotal ,
              rowguid ,
              ModifiedDate ,
              AuditAction ,
              ChangeDate ,
              ChangedBy
            )
            SELECT  SalesOrderID ,
                    SalesOrderDetailID ,
                    CarrierTrackingNumber ,
                    OrderQty ,
                    ProductID ,
                    SpecialOfferID ,
                    UnitPrice ,
                    UnitPriceDiscount ,
                    LineTotal ,
                    rowguid ,
                    ModifiedDate ,
                    @i_action ,
                    GETDATE() ,
                    ORIGINAL_LOGIN
            FROM    INSERTED
            UNION ALL
            SELECT  SalesOrderID ,
                    SalesOrderDetailID ,
                    CarrierTrackingNumber ,
                    OrderQty ,
                    ProductID ,
                    SpecialOfferID ,
                    UnitPrice ,
                    UnitPriceDiscount ,
                    LineTotal ,
                    rowguid ,
                    ModifiedDate ,
                    @d_action ,
                    GETDATE() ,
                    SYSTEM_USER
            FROM    DELETED
GO

-- Listing 9.19: An audited UPDATE on the SalesOrderDetail table.
UPDATE  Sales.SalesOrderDetail
SET     OrderQty = 10
WHERE   SalesOrderDetailID = 1
GO
SELECT  *
FROM    Sales.SalesOrderDetailAudit
GO

-- Listing 9.20: Reverting the UPDATE using the audit table.
UPDATE  sod
SET     sod.OrderQty = soda.OrderQty
FROM    Sales.SalesOrderDetail sod
        JOIN Sales.SalesOrderDetailAudit soda ON sod.SalesOrderDetailID = soda.SalesOrderDetailID
WHERE   soda.AuditAction = 'UPDATED_FROM'
        AND soda.SalesOrderDetailID = 1

-- Listing 9.21: Preventing any UPDATE that would affect more than 1,000 rows.
CREATE TRIGGER SalesOrderDetail_Prevent ON Sales.SalesOrderDetail
    FOR UPDATE, DELETE
AS
    DECLARE @INS INTEGER ,
        @DEL INTEGER
    SELECT  @INS = COUNT(*)
    FROM    INSERTED
    SELECT  @DEL = COUNT(*)
    FROM    DELETED
    IF ( ( @INS > 1000
           AND @DEL > 1000
         )
         OR @DEL > 1000
       ) 
        BEGIN
            PRINT 'You must disable Trigger "Sales.SalesOrderDetail_Prevent" to change more than 1000 rows.'
            ROLLBACK
        END
GO

-- Listing 9.22: Disabling and enabling DML triggers.
DISABLE TRIGGER Sales.SalesOrderDetail_Prevent
ON Sales.SalesOrderDetail
-- Perform data changes
ENABLE TRIGGER Sales.SalesOrderDetail_Prevent
ON Sales.SalesOrderDetail