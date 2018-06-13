CREATE TABLE [Staging].[SourceFile]
(
	[ID] INT IDENTITY(1,1) NOT NULL,
	[FileName] NVARCHAR(60) NOT NULL,
	[FilePreparationDate] DATETIME NOT NULL,
	[Created] DATETIME NULL, 
    CONSTRAINT [PK_SourceFile] PRIMARY KEY ([ID]),
)