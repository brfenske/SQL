CREATE proc [dbo].[chk_cpu_busy]
as
begin
   set nocount on
   Create table #cpubusy (cpu_err int)
   insert into #cpubusy SELECT @@cpu_busy
   select * , ''Error:******** CPU BUSY OVERLOAD DETECTED! *******''
   from #cpubusy
   where convert(real,cpu_err) > (select threshold_value
                                 from configuration
                                 where threshold_category = ''CPU_BUSY'')
   DROP table #cpubusy
 end           
