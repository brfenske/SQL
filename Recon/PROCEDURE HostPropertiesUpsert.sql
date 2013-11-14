USE [Recon]
GO

/****** Object:  StoredProcedure [dbo].[HostPropertiesUpsert]    Script Date: 10/22/2013 09:48:27 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[HostPropertiesUpsert]')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE [dbo].[HostPropertiesUpsert]
GO

USE [Recon]
GO

/****** Object:  StoredProcedure [dbo].[HostPropertiesUpsert]    Script Date: 10/22/2013 09:48:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[HostPropertiesUpsert] (
	@HostName VARCHAR(50)
	, @Class VARCHAR(50)
	, @PropertyName VARCHAR(50)
	, @PropertyValue VARCHAR(8000)
	)
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (
			SELECT ID
			FROM HostProperties
			WHERE HostName = @HostName
				AND Class = @Class
				AND PropertyName = @PropertyName
			)
		UPDATE HostProperties
		SET PropertyValue = @PropertyValue
			, Modified = GETDATE()
			, Active = 1
		WHERE HostName = @HostName
			AND Class = @Class
			AND PropertyName = @PropertyName
	ELSE
		INSERT INTO [Recon].[dbo].[HostProperties] (
			HostName
			, Class
			, PropertyName
			, PropertyValue
			, Inserted
			, Active
			)
		VALUES (
			@HostName
			, @Class
			, @PropertyName
			, @PropertyValue
			, GETDATE()
			, 1
			)
END
GO


