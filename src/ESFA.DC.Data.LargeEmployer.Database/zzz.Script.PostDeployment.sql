﻿

/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

SET NOCOUNT ON;
GO

RAISERROR('Drop Non Required Objects :- ',10,1) WITH NOWAIT;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[usp_Process_LEMP_LargeEmployers]') AND type in (N'P', N'PC'))
BEGIN
	RAISERROR('Drop SP : [Staging].[usp_Process_LEMP_LargeEmployers]',10,1) WITH NOWAIT;
	DROP PROCEDURE [Staging].[usp_Process_LEMP_LargeEmployers];
END

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[usp_Process_LEMP_SourceFile]') AND type in (N'P', N'PC'))
BEGIN
	RAISERROR('Drop SP : [Staging].[usp_Process_LEMP_SourceFile]',10,1) WITH NOWAIT;
	DROP PROCEDURE [Staging].[usp_Process_LEMP_SourceFile];
END

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[usp_Process_LEMP_VersionInfo]') AND type in (N'P', N'PC'))
BEGIN
	RAISERROR('Drop SP : [Staging].[usp_Process_LEMP_VersionInfo]',10,1) WITH NOWAIT;
	DROP PROCEDURE [Staging].[usp_Process_LEMP_VersionInfo];
END

GO

GO
RAISERROR('		   Extended Property',10,1) WITH NOWAIT;
GO

RAISERROR('		         %s - %s',10,1,'BuildNumber','$(BUILD_BUILDNUMBER)') WITH NOWAIT;
IF NOT EXISTS (SELECT name, value FROM fn_listextendedproperty('BuildNumber', default, default, default, default, default, default))
	EXEC sp_addextendedproperty @name = N'BuildNumber', @value = '$(BUILD_BUILDNUMBER)';  
ELSE
	EXEC sp_updateextendedproperty @name = N'BuildNumber', @value = '$(BUILD_BUILDNUMBER)';  
	
GO
RAISERROR('		         %s - %s',10,1,'BuildBranch','$(BUILD_BRANCHNAME)') WITH NOWAIT;
IF NOT EXISTS (SELECT name, value FROM fn_listextendedproperty('BuildBranch', default, default, default, default, default, default))
	EXEC sp_addextendedproperty @name = N'BuildBranch', @value = '$(BUILD_BRANCHNAME)';  
ELSE
	EXEC sp_updateextendedproperty @name = N'BuildBranch', @value = '$(BUILD_BRANCHNAME)';  

GO
DECLARE @DeploymentTime VARCHAR(35) = CONVERT(VARCHAR(35),GETUTCDATE(),113) + ' UTC';
RAISERROR('		         %s - %s',10,1,'DeploymentDatetime',@DeploymentTime) WITH NOWAIT;
IF NOT EXISTS (SELECT name, value FROM fn_listextendedproperty('DeploymentDatetime', default, default, default, default, default, default))
	EXEC sp_addextendedproperty @name = N'DeploymentDatetime', @value = @DeploymentTime;  
ELSE
	EXEC sp_updateextendedproperty @name = N'DeploymentDatetime', @value = @DeploymentTime;  
GO

RAISERROR('		         %s - %s',10,1,'ReleaseName','$(RELEASE_RELEASENAME)') WITH NOWAIT;
IF NOT EXISTS (SELECT name, value FROM fn_listextendedproperty('ReleaseName', default, default, default, default, default, default))
	EXEC sp_addextendedproperty @name = N'ReleaseName', @value = '$(RELEASE_RELEASENAME)';  
ELSE
	EXEC sp_updateextendedproperty @name = N'ReleaseName', @value = '$(RELEASE_RELEASENAME)';  
GO
IF EXISTS (SELECT * FROM [sys].[objects] WHERE [type] = 'V' AND Name = 'DisplayDeploymentProperties_VW')
BEGIN 
	DROP VIEW [dbo].[DisplayDeploymentProperties_VW];
END

GO
EXEC ('CREATE VIEW [dbo].[DisplayDeploymentProperties_VW]
AS
	SELECT name, value 
	FROM fn_listextendedproperty(default, default, default, default, default, default, default);  
	');

GO

RAISERROR('		   Update User Account Passwords',10,1) WITH NOWAIT;
GO
ALTER USER [LargeEmployer_RO_User] WITH PASSWORD = N'$(ROUserPassword)';
ALTER USER [LargeEmployer_RW_User] WITH PASSWORD = N'$(RWUserPassword)';

GO
RAISERROR('Completed',10,1) WITH NOWAIT;
GO



