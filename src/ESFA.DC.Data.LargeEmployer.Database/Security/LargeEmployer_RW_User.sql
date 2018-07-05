CREATE USER [LargeEmployer_RW_User]
    WITH PASSWORD = N'$(RWUserPassword)';
GO
	GRANT CONNECT TO [LargeEmployer_RW_User]
GO


