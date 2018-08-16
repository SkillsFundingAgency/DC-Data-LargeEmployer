CREATE TABLE [Staging].[LEMP_VersionInfo]
(
	[Version] INT NOT NULL,
	[Date] DATE NOT NULL, 
    CONSTRAINT [PK_Staging_VersionInfo] PRIMARY KEY ([Version])
)

GO
GRANT ALTER ON OBJECT::Staging.LEMP_VersionInfo TO [LargeEmployer_RW_User];