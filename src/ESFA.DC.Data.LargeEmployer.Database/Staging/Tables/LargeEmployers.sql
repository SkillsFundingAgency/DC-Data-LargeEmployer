CREATE TABLE [Staging].[LEMP_Employers]
(
	[ERN] INT NOT NULL,
	[EffectiveFrom] DATE NOT NULL, 
	[EffectiveTo] DATE NULL, 
	PRIMARY KEY ([ERN], [EffectiveFrom]),
)