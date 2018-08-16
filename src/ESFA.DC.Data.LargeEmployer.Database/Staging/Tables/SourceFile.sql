CREATE TABLE [Staging].[LEMP_SourceFile]
(
	[ID] INT IDENTITY(1,1) NOT NULL,
	[FileName] NVARCHAR(60) NOT NULL,
	[FilePreparationDate] DATETIME NOT NULL,
	[Created] DATETIME NULL, 
    CONSTRAINT [PK_Staging_SourceFile] PRIMARY KEY ([ID]),
)

GO
GRANT ALTER ON OBJECT::Staging.LEMP_SourceFile TO [LargeEmployer_RW_User];
