CREATE USER [LargeEmployer_RO_User]
    WITH PASSWORD = N'$(LargeEmployerROUserPassword)';
GO
	GRANT CONNECT TO [LargeEmployer_RO_User]
GO


