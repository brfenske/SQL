SELECT * FROM workflow.RefState
SELECT * FROM workflow.RefTask
SELECT * FROM workflow.RefTaskStatus
SELECT * FROM workflow.RefWorkflow
SELECT * FROM workflow.StateTask

SELECT [RefStateID]
      ,[RefStateName]
      ,[Description]
      ,[RefWorkflowID]
      ,[RefObjectID]
      ,[Active]
      ,[InsertDate]
      ,[InsertUserID]
      ,[UpdateDate]
      ,[UpdateUserID]
  FROM [WorkflowDb].[workflow].[RefState]