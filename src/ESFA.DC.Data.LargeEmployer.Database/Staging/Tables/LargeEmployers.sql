CREATE TABLE [Staging].[LEMP_Employers]
(
	[ERN] INT NOT NULL,
	[EffectiveFrom] DATE NOT NULL, 
	[EffectiveTo] DATE NULL, 
	CONSTRAINT [PK_Staging_Employers] PRIMARY KEY  ([ERN], [EffectiveFrom]),
)