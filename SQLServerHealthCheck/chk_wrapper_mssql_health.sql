CREATE PROCEDURE [dbo].[chk_wrapper_mssql_health]
AS
BEGIN
	SET NOCOUNT ON

	EXECUTE dbo.chk_cpu_busy

	EXECUTE dbo.chk_Db_Health_mssql

	EXECUTE dbo.chk_disks_free_space

	EXECUTE dbo.chk_mssql_error_log

	EXECUTE dbo.chk_network_errors

	EXECUTE dbo.chk_tot_serv_cache_hit_ratio

	EXECUTE dbo.chk_backup_db_status

	EXECUTE dbo.chk_num_connections
END
