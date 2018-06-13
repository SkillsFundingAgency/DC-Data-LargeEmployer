CREATE TABLE [dbo].[LargeEmployers]
(
	[ERN] INT NOT NULL,
	[EffectiveFrom] DATE NOT NULL, 
	[EffectiveTo] DATE NULL, 
	PRIMARY KEY ([ERN], [EffectiveFrom]),
)