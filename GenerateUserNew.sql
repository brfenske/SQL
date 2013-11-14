CREATE PROCEDURE [dbo].[GenerateUser]
AS
BEGIN
	--
	-- Bootstrap the administrative user, group, role and profile. Use direct
	-- DML instead of calling stored procedures to bypass access control.
	--
	DECLARE @userID INT, @now DATETIME, @AppUserID INT, @ChangeHistoryRowID INT, @IDSource VARCHAR(50), @LoginName NVARCHAR(50), @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @Password NVARCHAR(50);

	SELECT @IDSource = ABS(CHECKSUM(NEWID()));

	SELECT @LoginName = 'User' + @IDSource;

	SELECT @FirstName = 'UserFirst' + @IDSource;

	SELECT @LastName = 'UserLast' + @IDSource;

	SET @Password = LOWER(@LoginName + N'p@ssw0rd');

	IF NOT EXISTS (
			SELECT 1
			FROM [AppUser]
			WHERE LoginName = @LoginName
			)
	BEGIN
		SET @now = getutcdate()

		BEGIN TRANSACTION;

		INSERT INTO [dbo].[AppUser] ([LoginName], [Password], [LastName], [FirstName], [Email], [ChangePassword], [LockDate], [PasswordChangedDate], [DeactivateDate], [UnsuccessfulAttempts], [LastAttemptedDate], [Active], [UpdateDate], [CreatedDate])
		VALUES (@LoginName, @Password, @LastName, @FirstName, N'', 0, NULL, @now, NULL, 0, NULL, 1, @now, @now);

		SELECT @userID = UserID
		FROM AppUser
		WHERE LastName = @LastName;

		INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate])
		VALUES (@userID, 5, 1, N'admin, admin', @now)

		INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate])
		VALUES (@userID, 6, 1, N'admin, admin', @now)

		INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate])
		VALUES (@userID, 7, 1, N'admin, admin', @now)

		INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate])
		VALUES (@userID, 8, 1, N'admin, admin', @now)

		INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate])
		VALUES (@userID, 9, 1, N'admin, admin', @now)

		INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate])
		VALUES (@userID, 11, 1, N'admin, admin', @now)

		INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate])
		VALUES (@userID, 23, 1, N'admin, admin', @now)

		INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate])
		VALUES (@userID, 501, 1, N'admin, admin', @now)

		INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate])
		VALUES (@userID, 502, 1, N'admin, admin', @now)

		INSERT INTO [Platform].[UserProfileRole] ([UserID], [RefProfileRoleID], [InsertDate], [InsertUserID])
		VALUES (@userID, 1, @now, 1)

		INSERT INTO [Platform].[UserProfileRole] ([UserID], [RefProfileRoleID], [InsertDate], [InsertUserID])
		VALUES (@userID, 4, @now, 1)

		INSERT INTO [Platform].[UserProfileRole] ([UserID], [RefProfileRoleID], [InsertDate], [InsertUserID])
		VALUES (@userID, 5, @now, 1)

		INSERT INTO [Platform].[UserProfileRole] ([UserID], [RefProfileRoleID], [InsertDate], [InsertUserID])
		VALUES (@userID, 6, @now, 1)

		INSERT INTO [Platform].[UserProfileRole] ([UserID], [RefProfileRoleID], [InsertDate], [InsertUserID])
		VALUES (@userID, 21, @now, 1)

		INSERT INTO [Platform].[UserProfileRole] ([UserID], [RefProfileRoleID], [InsertDate], [InsertUserID])
		VALUES (@userID, 22, @now, 1)

		INSERT INTO [Platform].[UserProfileRole] ([UserID], [RefProfileRoleID], [InsertDate], [InsertUserID])
		VALUES (@userID, 10, @now, 1)

		INSERT INTO [Platform].[UserProfileRole] ([UserID], [RefProfileRoleID], [InsertDate], [InsertUserID])
		VALUES (@userID, 17, @now, 1)

		INSERT INTO [Platform].[UserProfileRole] ([UserID], [RefProfileRoleID], [InsertDate], [InsertUserID])
		VALUES (@userID, 7, @now, 1)

		INSERT INTO [dbo].[UserRole] ([UserID], [RoleID])
		VALUES (@userID, 1)

		SELECT @IDSource AS IDSource, @LoginName AS LoginName, @FirstName AS FirstName, @LastName AS LastName, @Password AS 'Password';

		COMMIT TRANSACTION;
	END;
END;
