IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[GenerateUser]')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE [dbo].[GenerateUser]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GenerateUser]
AS
BEGIN
	DECLARE @userID INT
		, @now DATETIME
		, @AppUserID INT
		, @ChangeHistoryRowID INT
		, @IDSource VARCHAR(50)
		, @LoginName NVARCHAR(50)
		, @FirstName NVARCHAR(50)
		, @LastName NVARCHAR(50)
		, @Password NVARCHAR(50);

	SET @IDSource = ABS(CHECKSUM(NEWID()));
	SET @LoginName = 'User' + @IDSource;
	SET @FirstName = 'UserFirst' + @IDSource;
	SET @LastName = 'UserLast' + @IDSource;
	SET @Password = LOWER(@LoginName) + N'p@ssw0rd';-- MUST STORE THE LOGINNAME PORTION IN LOWERCASE!! 

	IF NOT EXISTS (
			SELECT 1
			FROM [AppUser]
			WHERE LoginName = @LoginName
			)
	BEGIN
		SET @now = GETUTCDATE()

		BEGIN TRANSACTION;

		INSERT INTO [dbo].[AppUser] (
			[LoginName]
			, [Password]
			, [LastName]
			, [FirstName]
			, [Email]
			, [ChangePassword]
			, [LockDate]
			, [PasswordChangedDate]
			, [DeactivateDate]
			, [UnsuccessfulAttempts]
			, [LastAttemptedDate]
			, [Active]
			, [UpdateDate]
			, [CreatedDate]
			)
		VALUES (
			@LoginName
			, @Password
			, @LastName
			, @FirstName
			, N''
			, 0
			, NULL
			, @now
			, NULL
			, 0
			, NULL
			, 1
			, @now
			, @now
			);

		SELECT @userID = UserID
		FROM AppUser
		WHERE LastName = @LastName;

		INSERT INTO AccessControlGroupUser
		SELECT @userID AS UserID
			, AccessControlGroupID
			, 1 AS AddUserID
			, 'admin' AS AddUserName
			, @now AS InsertDate
		FROM AccessControlGroup

		INSERT INTO [Platform].[UserProfileRole]
		SELECT @userID AS UserID
			, RefProfileRoleID
			, @now AS InsertDate
			, 1 AS AddUserID
		FROM [Platform].RefProfileRole

		INSERT INTO [dbo].[UserRole] (
			[UserID]
			, [RoleID]
			)
		VALUES (
			@userID
			, 1
			)

		SELECT @IDSource AS IDSource
			, @LoginName AS LoginName
			, @FirstName AS FirstName
			, @LastName AS LastName
			, @Password AS 'Password';

		COMMIT TRANSACTION;
	END;
END;
GO


