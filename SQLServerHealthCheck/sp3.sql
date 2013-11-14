CREATE proc [dbo].[chk_disks_free_space]
as
begin
   set nocount on
   Create table #freeDisksSpace (drive varchar(5),MBFree varchar(20))
   insert into #freeDisksSpace exec sys.xp_fixeddrives
   select * , ''Error: ******** INSUFICIENT DISK SPACE *********''
   from #freeDisksSpace
   where convert(real,MBFree) < (select threshold_value
                                 from configuration
                                 where threshold_category = ''DISK_SPACE'')
   DROP table #freeDisksSpace
 end
