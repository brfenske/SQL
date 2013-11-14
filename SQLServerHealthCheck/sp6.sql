CREATE proc [dbo].[chk_tot_serv_cache_hit_ratio] 
as 
BEGIN
  declare @r real
 set nocount on
  select @r = 100.0 * (select avg(cntr_value) x 
              from sys.dm_os_performance_counters
                   where counter_name = ''Buffer cache hit ratio'') /
               (select avg(cntr_value) y 
              from sys.dm_os_performance_counters
                   where counter_name = ''Buffer cache hit ratio base'')

  if @r < (select threshold_value
           from configuration
            where threshold_category = ''HIT_RATIO'')
    BEGIN 
      print ''Error:****** cache hit ratio problem.... '' +Str(@r)
    END

end
