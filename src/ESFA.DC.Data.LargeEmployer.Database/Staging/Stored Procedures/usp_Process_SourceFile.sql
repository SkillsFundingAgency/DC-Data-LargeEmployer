CREATE PROCEDURE [Staging].[usp_Process_SourceFile]
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY

		MERGE INTO [dbo].[LEMP_SourceFile] AS Target
		USING (
				SELECT  [ID] , 
						[FileName], 
						[FilePreparationDate],
						[Created]
				  FROM [Staging].[LEMP_SourceFile]
			  )
			  AS Source 
		    ON Target.[FileName] = Source.[FileName]
			WHEN MATCHED 
				AND EXISTS 
					(	SELECT 
							 --Target.[FileName],		
							 Target.[FilePreparationDate],		
							 Target.[Created]				
					EXCEPT 
						SELECT 
							 --Source.[FileName],
							 Source.[FilePreparationDate],
							 Source.[Created]
					)
		  THEN
			UPDATE SET   
				 --[FileName] = Source.[FileName]	,
				 [FilePreparationDate] = Source.[FilePreparationDate],
				 [Created] = Source.[Created]							
		WHEN NOT MATCHED BY TARGET THEN
		INSERT (    -- [ID]
					 [FileName]
					,[FilePreparationDate]
					,[Created]
					)
			VALUES ( --Source.[ID]
					 Source.[FileName]
					,Source.[FilePreparationDate]
					,Source.[Created]
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