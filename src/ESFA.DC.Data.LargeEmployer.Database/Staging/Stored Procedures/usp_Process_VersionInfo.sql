CREATE PROCEDURE [Staging].[usp_Process_VersionInfo]
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

		MERGE INTO [dbo].[LEMP_VersionInfo] AS Target
		USING (
				SELECT  [Version] , 
						[Date]
				  FROM [Staging].[LEMP_VersionInfo]
			  )
			  AS Source 
		    ON Target.[Version] = Source.[Version]
			WHEN MATCHED 
				AND EXISTS 
					(	SELECT 
							 Target.[Version],		
							 Target.[Date]				
					EXCEPT 
						SELECT 
							 Source.[Version],
							 Source.[Date]
					)
		  THEN
			UPDATE SET   
				 [Version] = Source.[Version],
				 [Date] = Source.[Date]							
		WHEN NOT MATCHED BY TARGET THEN
		INSERT (     [Version]
					,[Date]
					)
			VALUES ( Source.[Version]
					,Source.[Date]
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