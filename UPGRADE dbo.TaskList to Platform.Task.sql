DECLARE @CompletedID INT
SELECT  @CompletedID = ID
FROM    Platform.RefTaskStatus
WHERE   [Text] = 'Completed'

SET IDENTITY_INSERT Platform.Task ON

INSERT  INTO Platform.Task
        (TaskID,
         TypeID,
         PriorityID,
         StatusID,
         ReasonID,
         OwnerID,
         AssigneeID,
         [Subject],
         Notes,
         ContactName,
         ContactDetails,
         Due,
         InsertDate,
         UpdateDate,
         InsertBy,
         UpdateBy,
         IsSystemTask,
         Active)
        SELECT  TaskID,
                RefTaskTypeID,
                RefTaskPriorityID,
                CASE WHEN Complete = 1 THEN @CompletedID
                     ELSE NULL
                END,
                NULL,
                AssignedBy,
                AssignedUserID,
                [Subject],
                Notes,
                NULL,
                NULL,
                DueDate,
                InsertDate,
                LastUpdateDate,
                InsertedBy,
                LastUpdatedUserID,
                0,
                Active
        FROM    dbo.TaskList 
        
SET IDENTITY_INSERT Platform.Task OFF
