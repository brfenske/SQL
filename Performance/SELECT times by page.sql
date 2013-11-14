SELECT   WebLoadTestRequestMap.RequestUri,
         CONVERT(VARCHAR(20), LoadTestRun.StartTime, 106) AS DATE,
         AVG(LoadTestPageSummaryByNetwork.Average) AS AveragePageLoadTime
FROM     LoadTestPageSummaryByNetwork
         INNER JOIN WebLoadTestRequestMap 
           ON LoadTestPageSummaryByNetwork.LoadTestRunId = WebLoadTestRequestMap.LoadTestRunId
           AND LoadTestPageSummaryByNetwork.PageId = WebLoadTestRequestMap.RequestId
         INNER JOIN LoadTestRun 
           ON WebLoadTestRequestMap.LoadTestRunId = LoadTestRun.LoadTestRunId
GROUP BY
 WebLoadTestRequestMap.RequestUri,
         CONVERT(VARCHAR(20), LoadTestRun.StartTime, 106)
ORDER BY WebLoadTestRequestMap.RequestUri, CONVERT(VARCHAR(20), LoadTestRun.StartTime, 106);