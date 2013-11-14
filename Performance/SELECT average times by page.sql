SELECT   LoadTestRun.StartTime,
         WebLoadTestRequestMap.RequestUri,
         STR(LoadTestPageSummaryByNetwork.Average, 6, 2) AS Average,
         LoadTestRun.LoadTestName,
         LoadTestRun.RunDuration,
         LoadTestRun.Comment
FROM     LoadTestPageSummaryByNetwork
         INNER JOIN WebLoadTestRequestMap 
           ON LoadTestPageSummaryByNetwork.LoadTestRunId = WebLoadTestRequestMap.LoadTestRunId
           AND LoadTestPageSummaryByNetwork.PageId = WebLoadTestRequestMap.RequestId
         INNER JOIN LoadTestRun 
           ON WebLoadTestRequestMap.LoadTestRunId = LoadTestRun.LoadTestRunId
ORDER BY WebLoadTestRequestMap.RequestUri, LoadTestRun.StartTime DESC, LoadTestPageSummaryByNetwork.PageId;