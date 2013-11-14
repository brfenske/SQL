USE [Recon]
GO

/****** Object:  StoredProcedure [dbo].[HostUpsert]    Script Date: 10/28/2013 13:06:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HostUpsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HostUpsert]
GO

USE [Recon]
GO

/****** Object:  StoredProcedure [dbo].[HostUpsert]    Script Date: 10/28/2013 13:06:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[HostUpsert] (
	@CSName VARCHAR(50)
	, @Caption VARCHAR(50) = NULL
	, @CSDVersion VARCHAR(50) = NULL
	, @FreePhysicalMemory DECIMAL(18, 0) = 0
	, @InstallDate DATETIME
	, @IPAddress VARCHAR(50) = NULL
	, @LastBootUpTime DATETIME
	, @NumberOfProcesses DECIMAL(18, 0) = 0
	, @NumberOfUsers DECIMAL(18, 0) = 0
	, @SerialNumber VARCHAR(50) = NULL
	, @ServicePackMajorVersion INT = 0
	, @ServicePackMinorVersion INT = 0
	, @Status VARCHAR(50) = NULL
	, @Version VARCHAR(50) = NULL
	, @VMName VARCHAR(50) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (
			SELECT *
			FROM Host
			WHERE CSName = @CSName
			)
		UPDATE [Recon].[dbo].[Host]
		SET [Caption] = @Caption
			, [CSDVersion] = @CSDVersion
			, [FreePhysicalMemory] = @FreePhysicalMemory
			, [InstallDate] = @InstallDate
			, [IPAddress] = @IPAddress
			, [LastBootUpTime] = @LastBootUpTime
			, [NumberOfProcesses] = @NumberOfProcesses
			, [NumberOfUsers] = @NumberOfUsers
			, [SerialNumber] = @SerialNumber
			, [ServicePackMajorVersion] = @ServicePackMajorVersion
			, [ServicePackMinorVersion] = @ServicePackMinorVersion
			, [Status] = @Status
			, [Version] = @Version
			, [VMName] = @VMName
		WHERE CSName = @CSName
	ELSE
		INSERT INTO [Recon].[dbo].[Host] (
			[Caption]
			, [CSDVersion]
			, [CSName]
			, [FreePhysicalMemory]
			, [InstallDate]
			, [IPAddress]
			, [LastBootUpTime]
			, [NumberOfProcesses]
			, [NumberOfUsers]
			, [SerialNumber]
			, [ServicePackMajorVersion]
			, [ServicePackMinorVersion]
			, [Status]
			, [Version]
			, [VMName]
			)
		VALUES (
			@Caption
			, @CSDVersion
			, @CSName
			, @FreePhysicalMemory
			, @InstallDate
			, @IPAddress
			, @LastBootUpTime
			, @NumberOfProcesses
			, @NumberOfUsers
			, @SerialNumber
			, @ServicePackMajorVersion
			, @ServicePackMinorVersion
			, @Status
			, @Version
			, @VMName
			)
END

GO


