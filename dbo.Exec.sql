
DECLARE       @return_value int

EXEC   @return_value = [dbo].[sampledata_fillalldata]
              @patientcount = 50000,
              @providercount = 50,
              @facilitycount = 10,
              @episodecount = 150000

SELECT 'Return Value' = @return_value

GO
