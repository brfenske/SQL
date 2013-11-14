--declare @p12 int
--set @p12=0
--exec [dbo].[GetAutoAuthSubmissionsPaged] @userSessionID=24262,@startIndex=0,@pageSize=25,@sortColumn='DateOfService',@sort='DESC',@filterPatient=default,@filterDateOfSubmission=default,@filterDateOfService=default,@filterFacility=default,@filterStatus=default,@submitStatus='Draft',@recordCount=@p12 output,@debug=0
--select @p12


declare @p12 int 
set @p12=0 
exec [dbo].[GetAutoAuthSubmissionsPaged] @userSessionID=24267,@startIndex=0,@pageSize=25,@sortColumn='DateOfService',@sort='DESC',@filterPatient=default,@filterDateOfSubmission=default,@filterDateOfService=default,@filterFacility=default,@filterStatus=default,@submitStatus='Draft',@recordCount=@p12 output,@debug=0  

select @p12

