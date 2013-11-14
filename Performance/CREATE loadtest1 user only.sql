SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
DECLARE @pv binary(16)

BEGIN TRANSACTION

SET IDENTITY_INSERT [dbo].[AppUser] ON
INSERT INTO [dbo].[AppUser] ([UserID], [LoginName], [Password], [LastName], [FirstName], [Email], [ChangePassword], [LockDate], [PasswordChangedDate], [DeactivateDate], [UnsuccessfulAttempts], [LastAttemptedDate], [Active], [UpdateDate], [CreatedDate]) VALUES (4, N'loadtest1', N'loadtest1password1', N'Test1', N'Load', NULL, 0, NULL, GETUTCDATE(), NULL, 0, NULL, 1, GETUTCDATE(), GETUTCDATE())
SET IDENTITY_INSERT [dbo].[AppUser] OFF

INSERT INTO [dbo].[UserRole] ([UserID], [RoleID]) VALUES (4, 1)

INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate]) VALUES (4, 1, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())
INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate]) VALUES (4, 5, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())
INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate]) VALUES (4, 6, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())
INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate]) VALUES (4, 7, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())
INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate]) VALUES (4, 8, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())
INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate]) VALUES (4, 9, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())
INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate]) VALUES (4, 10, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())
INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate]) VALUES (4, 11, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())
INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate]) VALUES (4, 12, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())
INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate]) VALUES (4, 17, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())
INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate]) VALUES (4, 18, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())
INSERT INTO [dbo].[AccessControlGroupUser] ([UserID], [AccessControlGroupID], [AddUserID], [AddUserName], [InsertDate]) VALUES (4, 19, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())

SET IDENTITY_INSERT [Platform].[UserProfileRole] ON
INSERT INTO [Platform].[UserProfileRole] ([UserProfileRoleID], [UserID], [RefProfileRoleID], [InsertDate], [InsertUserID]) VALUES (37, 4, 1, GETUTCDATE(), 1)
INSERT INTO [Platform].[UserProfileRole] ([UserProfileRoleID], [UserID], [RefProfileRoleID], [InsertDate], [InsertUserID]) VALUES (38, 4, 2, GETUTCDATE(), 1)
INSERT INTO [Platform].[UserProfileRole] ([UserProfileRoleID], [UserID], [RefProfileRoleID], [InsertDate], [InsertUserID]) VALUES (39, 4, 3, GETUTCDATE(), 1)
INSERT INTO [Platform].[UserProfileRole] ([UserProfileRoleID], [UserID], [RefProfileRoleID], [InsertDate], [InsertUserID]) VALUES (40, 4, 4, GETUTCDATE(), 1)
INSERT INTO [Platform].[UserProfileRole] ([UserProfileRoleID], [UserID], [RefProfileRoleID], [InsertDate], [InsertUserID]) VALUES (41, 4, 5, GETUTCDATE(), 1)
INSERT INTO [Platform].[UserProfileRole] ([UserProfileRoleID], [UserID], [RefProfileRoleID], [InsertDate], [InsertUserID]) VALUES (42, 4, 6, GETUTCDATE(), 1)
INSERT INTO [Platform].[UserProfileRole] ([UserProfileRoleID], [UserID], [RefProfileRoleID], [InsertDate], [InsertUserID]) VALUES (43, 4, 7, GETUTCDATE(), 1)
INSERT INTO [Platform].[UserProfileRole] ([UserProfileRoleID], [UserID], [RefProfileRoleID], [InsertDate], [InsertUserID]) VALUES (44, 4, 8, GETUTCDATE(), 1)
INSERT INTO [Platform].[UserProfileRole] ([UserProfileRoleID], [UserID], [RefProfileRoleID], [InsertDate], [InsertUserID]) VALUES (45, 4, 9, GETUTCDATE(), 1)
INSERT INTO [Platform].[UserProfileRole] ([UserProfileRoleID], [UserID], [RefProfileRoleID], [InsertDate], [InsertUserID]) VALUES (46, 4, 10, GETUTCDATE(), 1)
INSERT INTO [Platform].[UserProfileRole] ([UserProfileRoleID], [UserID], [RefProfileRoleID], [InsertDate], [InsertUserID]) VALUES (47, 4, 11, GETUTCDATE(), 1)
INSERT INTO [Platform].[UserProfileRole] ([UserProfileRoleID], [UserID], [RefProfileRoleID], [InsertDate], [InsertUserID]) VALUES (48, 4, 12, GETUTCDATE(), 1)
SET IDENTITY_INSERT [Platform].[UserProfileRole] OFF

SET IDENTITY_INSERT [dbo].[UserPrivilegeChangeLog] ON
INSERT INTO [dbo].[UserPrivilegeChangeLog] ([UserPrivilegeChangeLogID], [PreviousAccessControlGroups], [CurrentAccessControlGroups], [UserID], [ChangeByUserID], [ChangeByUserName], [CreateDate]) VALUES (4, NULL, N'GENERAL USER, USER ADMIN, HELP DESK ADMIN, CONFIG ADMIN, SYS ADMIN, GUIDELINE ONLY, CUSTOMIZE CWQI, INTERFACE USER, GMM USER, BULK LOAD USER, AUTO AUTH USER, AUTO AUTH INTERFACE USER', 4, 1, N'ConfigUtil-brian.fenske', GETUTCDATE())
SET IDENTITY_INSERT [dbo].[UserPrivilegeChangeLog] OFF
COMMIT TRANSACTION
