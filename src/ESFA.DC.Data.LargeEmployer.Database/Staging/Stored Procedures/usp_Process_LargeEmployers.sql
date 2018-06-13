CREATE PROCEDURE [Staging].[usp_Process_LargeEmployers]
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		
		MERGE INTO [dbo].[LargeEmployers] AS Target
		USING (
				SELECT  [ERN] , 
						[EffectiveFrom], 
						[EffectiveTo]
				  FROM [Staging].[LargeEmployers]
			  )
			  AS Source 
		    ON Target.[ERN] = Source.[ERN]
	      AND Target.[EffectiveFrom] = Source.[EffectiveFrom]	
			WHEN MATCHED 
				AND EXISTS 
					(	SELECT 
							 Target.[EffectiveTo]							
					EXCEPT 
						SELECT 
							 Source.[EffectiveTo]
					)
		  THEN
			UPDATE SET   
				 [EffectiveTo] = Source.[EffectiveTo]						
		WHEN NOT MATCHED BY TARGET THEN
		INSERT (     [ERN]
					,[EffectiveFrom]
					,[EffectiveTo]
					)
			VALUES ( Source.[ERN]
					,Source.[EffectiveFrom]
					,Source.[EffectiveTo]
				  )
		WHEN NOT MATCHED BY SOURCE THEN DELETE
		;

		RETURN 0;

	END TRY
-- 
-------------------------------------------------------------------------------------- 
-- Handle any problems
-------------------------------------------------------------------------------------- 
-- 
	BEGIN CATCH

		DECLARE   @ErrorMessage		NVARCHAR(4000)
				, @ErrorSeverity	INT 
				, @ErrorState		INT
				, @ErrorNumber		INT
						
		SELECT	  @ErrorNumber		= ERROR_NUMBER()
				, @ErrorMessage		= 'Error in :' + ISNULL(OBJECT_NAME(@@PROCID),'') + ' - Error was :' + ERROR_MESSAGE()
				, @ErrorSeverity	= ERROR_SEVERITY()
				, @ErrorState		= ERROR_STATE();
	
		RAISERROR (
					  @ErrorMessage		-- Message text.
					, @ErrorSeverity	-- Severity.
					, @ErrorState		-- State.
				  );
			  
		RETURN @ErrorNumber;

	END CATCH
-- 
-------------------------------------------------------------------------------------- 
-- All done
-------------------------------------------------------------------------------------- 
-- 
END