/*
DELETE  FROM [Platform].TaskNote
DELETE  FROM dbo.TaskPatient
DELETE  FROM dbo.TaskEpisode
DELETE  FROM [Platform].Task
*/

-- Start with RefTaskType table

-- Get the highest sort order value so we know where to start from with the new rows
DECLARE @TaskTypeMaxSortOrder NUMERIC ;
SELECT  @TaskTypeMaxSortOrder = MAX(SortOrder)
FROM    dbo.RefTaskType ;
SET @TaskTypeMaxSortOrder = @TaskTypeMaxSortOrder - 1 ;

-- Make sure RefTaskType table is empty
DELETE  FROM Platform.RefTaskType ;

-- Copy TaskTypes to new table
SET IDENTITY_INSERT [Platform].RefTaskType ON ;

INSERT  INTO Platform.RefTaskType
        (ID,
         [Text],
         [Description],
         SortOrder,
         Active,
         IsUserEditable,
         InsertUserID,
         InsertDate,
         UpdateUserID,
         UpdateDate)
        SELECT  ID,
                [Text],
                [Text],
                [SortOrder],
                [Active],
                [IsUserEditable],
                [InsertUserID],
                [InsertDate],
                [UpdateUserID],
                [UpdateDate]
        FROM    [dbo].[RefTaskType];

SET IDENTITY_INSERT [Platform].[RefTaskType] OFF ;


-- Add new types
INSERT  INTO [Platform].[RefTaskType]
        ([Text],
         [Description],
         [SortOrder],
         [Active],
         [IsUserEditable],
         [InsertUserID],
         [InsertDate],
         [UpdateUserID],
         [UpdateDate])
        SELECT  N'Appointment',
                N'Appointment',
                @TaskTypeMaxSortOrder + 1,
                1,
                1,
                1,
                GETDATE(),
                NULL,
                NULL
        UNION ALL
        SELECT  N'FollowUpAssessment',
                N'Follow-Up Assessment',
                @TaskTypeMaxSortOrder + 2,
                1,
                1,
                1,
                GETDATE(),
                NULL,
                NULL
        UNION ALL
        SELECT  N'FollowUpCall',
                N'Follow-Up Call',
                @TaskTypeMaxSortOrder + 3,
                1,
                1,
                1,
                GETDATE(),
                NULL,
                NULL
        UNION ALL
        SELECT  N'InitialAssessment',
                N'Initial Assessment',
                @TaskTypeMaxSortOrder + 4,
                1,
                1,
                1,
                GETDATE(),
                NULL,
                NULL
        UNION ALL
        SELECT  N'Meeting',
                N'Meeting',
                @TaskTypeMaxSortOrder + 5,
                1,
                1,
                1,
                GETDATE(),
                NULL,
                NULL
        UNION ALL
        SELECT  N'PatientEducationalMaterials',
                N'Patient Educational Materials',
                @TaskTypeMaxSortOrder + 6,
                1,
                1,
                1,
                GETDATE(),
                NULL,
                NULL
        UNION ALL
        SELECT  N'Personal',
                N'Personal',
                @TaskTypeMaxSortOrder + 7,
                1,
                1,
                1,
                GETDATE(),
                NULL,
                NULL
        UNION ALL
        SELECT  N'RepeatAssessment',
                N'Repeat Assessment',
                @TaskTypeMaxSortOrder + 8,
                1,
                1,
                1,
                GETDATE(),
                NULL,
                NULL ;
--COMMIT ;
RAISERROR (N'[Platform].[RefTaskType]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT ;

--------------------------------------------------------------------------------------------

-- Make sure RefTaskType table is empty
DELETE  FROM Platform.RefTaskPriority ;

-- Copy existing TaskPriorities to new table
SET IDENTITY_INSERT [Platform].RefTaskPriority ON ;

INSERT  INTO Platform.RefTaskPriority
        (ID,
         [Text],
         [Description],
         SortOrder,
         Active,
         IsUserEditable,
         InsertUserID,
         InsertDate,
         UpdateUserID,
         UpdateDate)
        SELECT  [ID],
                [Text],
                [Description],
                [SortOrder],
                [Active],
                [IsUserEditable],
                [InsertUserID],
                [InsertDate],
                [UpdateUserID],
                [UpdateDate]
        FROM    [dbo].[RefTaskPriority] ;
  
SET IDENTITY_INSERT [Platform].RefTaskPriority OFF ;

--------------------------------------------------------------------------------------------

-- Load the main Task table
SET IDENTITY_INSERT [Platform].Task ON ;


DECLARE @InProgress INT ;
DECLARE @Complete INT ;
DECLARE @Reminder INT ;
DECLARE @IsSystemTask INT ;
DECLARE @MediumPriority INT ;

SET @InProgress = 2 ;
SET @Complete = 3 ;
SET @Reminder = 1 ;
SET @IsSystemTask = 0 ;
SET @MediumPriority = 3 ;
 
INSERT  INTO [Platform].Task
        (TaskID,
         TypeID,
         PriorityID,
         StatusID,
         OwnerID,
         AssigneeID,
         [Subject],
         Due,
         InsertBy,
         InsertDate,
         UpdateBy,
         UpdateDate,
         IsSystemTask,
         Active)
        SELECT  TaskID,
                ISNULL(RefTaskTypeID, @Reminder),
                ISNULL(RefTaskPriorityID, @MediumPriority),
                CASE WHEN Complete = 1 THEN @Complete
                     ELSE @InProgress
                END,
                AssignedBy,
                AssignedUserID,
                [Subject],
                DueDate,
                InsertedBy,
                InsertDate,
                LastUpdatedUserID,
                LastUpdateDate,
                @IsSystemTask,
                Active
        FROM    dbo.TaskList
        ORDER BY TaskID ;


SET IDENTITY_INSERT [Platform].Task OFF ;

--------------------------------------------------------------------------------------------

-- Create Task/Patient combinations
INSERT  INTO dbo.TaskPatient
        (TaskID,
         PatientID,
         Active,
         InsertDate,
         InsertBy,
         UpdateDate,
         UpdateBy)
        SELECT  TaskID,
                PatientID,
                Active,
                InsertDate,
                InsertedBy,
                LastUpdateDate,
                LastUpdatedUserID
        FROM    dbo.TaskList
        WHERE   PatientID IS NOT NULL ;

--------------------------------------------------------------------------------------------

-- Create Task/Episode combinations
INSERT  INTO dbo.TaskEpisode
        (TaskID,
         EpisodeID,
         Active,
         InsertDate,
         InsertBy,
         UpdateDate,
         UpdateBy)
        SELECT  TaskID,
                EpisodeID,
                Active,
                InsertDate,
                InsertedBy,
                LastUpdateDate,
                LastUpdatedUserID
        FROM    dbo.TaskList
        WHERE   EpisodeID IS NOT NULL ;

--------------------------------------------------------------------------------------------

-- Create Task/Patient combinations for Episodes since the PatientID was null if
-- EpisodeID was not null in the old table.
INSERT  INTO dbo.TaskPatient
        (TaskID,
         PatientID,
         Active,
         InsertDate,
         InsertBy,
         UpdateDate,
         UpdateBy)
        SELECT  tl.TaskID,
                e.PatientID,
                e.Active,
                e.InsertDate,
                tl.InsertedBy,
                tl.LastUpdateDate,
                tl.LastUpdatedUserID
        FROM    dbo.TaskList tl
                JOIN dbo.Episode e ON tl.EpisodeID = e.EpisodeID ;

--------------------------------------------------------------------------------------------

-- Copy the one note column into a new Task/TaskNote record
DECLARE @NoteSubjectType INT ;
SELECT  @NoteSubjectType = ID
FROM    [Platform].[RefNoteSubjectType]
WHERE   [Text] = 'NoneSpecified' ;

INSERT  INTO [Platform].TaskNote
        (TaskID,
         [Text],
         NoteSubjectTypeID,
         Active,
         InsertBy,
         InsertDate,
         UpdateBy,
         UpdateDate)
        SELECT  TaskID,
                Notes,
                @NoteSubjectType,
                Active,
                InsertedBy,
                InsertDate,
                LastUpdatedUserID,
                LastUpdateDate
        FROM    dbo.TaskList
        WHERE   Notes IS NOT NULL ;
GO

/*
DELETE  FROM [Platform].TaskNote
DELETE  FROM dbo.TaskPatient
DELETE  FROM dbo.TaskEpisode
DELETE  FROM [Platform].Task

SELECT  [Platform].Task.*,
        TaskEpisode.EpisodeID,
        TaskPatient.PatientID,
        [Platform].TaskNote.Text,
        [Platform].TaskNote.NoteConfigurationID,
        [Platform].TaskNote.NoteSubjectTypeID
FROM    [Platform].Task
        LEFT JOIN TaskEpisode ON [Platform].Task.TaskID = TaskEpisode.TaskID
        LEFT JOIN TaskPatient ON [Platform].Task.TaskID = TaskPatient.TaskID
        LEFT JOIN [Platform].TaskNote ON [Platform].Task.TaskID = [Platform].TaskNote.TaskID

VALIDATION SCRIPT

SELECT  Platform.Task.TaskID,
        RefTaskType_1.Text AS NewTaskType,
        RefTaskType.Text AS OldTaskType,
        RefTaskPriority_1.Text AS NewTaskPriority,
        RefTaskPriority.Text AS OldTaskPriority,
        Platform.Task.StatusID AS NewStatusID,
        TaskList.Complete AS OldStatus,
        Platform.Task.OwnerID AS NewOwnerID,
        TaskList.AssignedBy AS OldOwnerID,
        Platform.Task.AssigneeID AS NewAssigneeID,
        TaskList.AssignedUserID AS OldAssigneeID,
        Platform.Task.Subject AS NewSubject,
        TaskList.Subject AS OldSubject,
        Platform.TaskNote.Text AS NewNote,
        TaskList.Notes AS OldNote,
        Platform.Task.Due AS NewDueDate,
        TaskList.DueDate AS OldDueDate,
        Platform.Task.InsertBy AS NewInsertBy,
        TaskList.InsertedBy AS OldInsertBy,
        Platform.Task.InsertDate AS NewInsertDate,
        TaskList.InsertDate AS OldInsertDate,
        Platform.Task.UpdateBy AS NewUpdateBy,
        TaskList.LastUpdatedUserID AS OldUpdateBy,
        Platform.Task.UpdateDate AS NewUpdateDate,
        TaskList.LastUpdateDate AS OldUpdateDate,
        Platform.Task.Active AS NewActive,
        TaskList.Active AS OldActive
FROM    Platform.Task
        LEFT JOIN TaskList ON Platform.Task.TaskID = TaskList.TaskID
        LEFT JOIN RefTaskPriority ON TaskList.RefTaskPriorityID = RefTaskPriority.ID
                                     AND TaskList.RefTaskPriorityID = RefTaskPriority.ID
        LEFT JOIN RefTaskType ON TaskList.RefTaskTypeID = RefTaskType.ID
                                 AND TaskList.RefTaskTypeID = RefTaskType.ID
        LEFT JOIN Platform.RefTaskPriority AS RefTaskPriority_1 ON Platform.Task.PriorityID = RefTaskPriority_1.ID
                                                                   AND Platform.Task.PriorityID = RefTaskPriority_1.ID
                                                                   AND Platform.Task.PriorityID = RefTaskPriority_1.ID
        LEFT JOIN Platform.RefTaskType AS RefTaskType_1 ON Platform.Task.TypeID = RefTaskType_1.ID
                                                           AND Platform.Task.TypeID = RefTaskType_1.ID
                                                           AND Platform.Task.TypeID = RefTaskType_1.ID
        LEFT OUTER JOIN TaskEpisode ON Platform.Task.TaskID = TaskEpisode.TaskID
        LEFT OUTER JOIN TaskPatient ON Platform.Task.TaskID = TaskPatient.TaskID
        LEFT OUTER JOIN Platform.TaskNote ON Platform.Task.TaskID = Platform.TaskNote.TaskID
        
        
*/
