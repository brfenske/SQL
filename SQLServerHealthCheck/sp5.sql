CREATE proc [dbo].[chk_network_errors]
as
begin
   set nocount on 
   Create table #networkerr (net_err int)
   insert into #networkerr SELECT @@PACKET_ERRORS
   select * , ''Error:******** NETWORK PACKET ERRORS DETECTED! *******''
   from #networkerr
   where convert(real,net_err) < (select threshold_value
                                 from configuration
                                 where threshold_category = ''NET_ERRORS'')
   DROP table #networkerr
 end
