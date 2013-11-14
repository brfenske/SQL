
cd /d "C:\Users\brian.fenske\Documents\SQL Server Management Studio\Projects\139521"
sqlcmd -E -S seat-care-tfs2 -i InvokeHealthChks.sql > result.log
pause

