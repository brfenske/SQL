IF EXISTS ( SELECT
                *
            FROM
                sys.objects
            WHERE
                object_id = OBJECT_ID(N'dbo.spWriteStringToFile')
                AND type IN (N'P', N'PC') ) 
    DROP PROCEDURE dbo.spWriteStringToFile ;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE spWriteStringToFile
    (
     @String VARCHAR(MAX),
     @Path VARCHAR(255),
     @Filename VARCHAR(100)
    )
AS 
    BEGIN
        DECLARE
            @objFileSystem INT,
            @objTextStream INT,
            @objErrorObject INT,
            @strErrorMessage VARCHAR(1000),
            @command VARCHAR(1000),
            @result INT,
            @fileAndPath VARCHAR(MAX)

        SET NOCOUNT ON

        SELECT
            @strErrorMessage = 'opening the File System Object'
        EXECUTE @result = sp_OACreate 
            'Scripting.FileSystemObject',
            @objFileSystem OUT

        SELECT
            @fileAndPath = @path + '\' + @filename
        IF @result = 0 
            SELECT
                @objErrorObject = @objFileSystem,
                @strErrorMessage = 'Creating file "' + @fileAndPath + '"'
        IF @result = 0 
            EXECUTE @result = sp_OAMethod 
                @objFileSystem,
                'CreateTextFile',
                @objTextStream OUT,
                @fileAndPath,
                2,
                True

        IF @result = 0 
            SELECT
                @objErrorObject = @objTextStream,
                @strErrorMessage = 'writing to the file "' + @fileAndPath + '"'
        IF @result = 0 
            EXECUTE @result = sp_OAMethod 
                @objTextStream,
                'Write',
                NULL,
                @String

        IF @result = 0 
            SELECT
                @objErrorObject = @objTextStream,
                @strErrorMessage = 'closing the file "' + @fileAndPath + '"'
        IF @result = 0 
            EXECUTE @result = sp_OAMethod 
                @objTextStream,
                'Close'

        IF @result <> 0 
            BEGIN
                DECLARE
                    @Source VARCHAR(255),
                    @Description VARCHAR(255),
                    @Helpfile VARCHAR(255),
                    @HelpID INT
	
                EXECUTE sp_OAGetErrorInfo 
                    @objErrorObject,
                    @source OUTPUT,
                    @Description OUTPUT,
                    @Helpfile OUTPUT,
                    @HelpID OUTPUT
                SELECT
                    @strErrorMessage = 'Error whilst ' + COALESCE(@strErrorMessage, 'doing something') + ', ' + COALESCE(@Description, '')
                RAISERROR (@strErrorMessage,16,1)
            END ;
        
        EXECUTE sp_OADestroy 
            @objTextStream ;
        EXECUTE sp_OADestroy 
            @objFileSystem ;
    END ;    
