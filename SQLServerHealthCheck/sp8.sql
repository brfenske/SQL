Create proc [dbo].[chk_num_connections]
as
begin 
   declare @cntconn int
   declare @maxconn int
   
   set nocount on 
   select @cntconn = count(*) from sysprocesses 
   select @maxconn = floor (threshold_value ) 
         from configuration
         where threshold_category = '#CONNECTIONS'
   
   if (@cntconn > @maxconn) begin
      print  'Error: ******** Num connection exceeded threshold ' + STR(@cntconn) + '*********'
   end
 end
