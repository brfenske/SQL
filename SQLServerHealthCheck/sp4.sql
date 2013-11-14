CREATE proc [dbo].[chk_mssql_error_log]
as 
begin
 set nocount on
 Create table #LogLines (Logdate datetime,
                         ProcessInfo varchar(200),
                         Msg_Text varchar(2000))
 
 Insert into #LogLines Exec sys.xp_readErrorLog

 select *,''******* Error: Reported in MSSQL Log! ****''
 from #LogLines 
 where  lower (Msg_Text) like ''%error %'' or lower (Msg_Text) like ''% error%''

 drop table #LogLines
end
