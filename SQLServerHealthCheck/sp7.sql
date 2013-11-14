Create proc [dbo].[chk_backup_db_status]  
as
begin
  set nocount on
  select 'Error: ******old or no backup at all! ' + s.dbname + ' days no backup='+ ' *****' ,s.[Days since Backup]
from (SELECT t.name as [DBName],
(COALESCE(Convert(varchar(10),MAX(datediff(d, getdate(), u.backup_finish_date))),101)) as [Days since Backup]
FROM SYS.DATABASES t left outer JOIN msdb.dbo.BACKUPSET u
ON t.name = u.database_name
group by t.Name) as s
where s.dbname <> 'tempdb' and
s.[Days since Backup] > (select configuration.threshold_value 
						FROM configuration
                         where configuration.threshold_category = 'BACKUP_DAYS')
                         
end
GO
