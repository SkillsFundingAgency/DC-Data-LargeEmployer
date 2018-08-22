CREATE PROCEDURE [Staging].[usp_Process]
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

			RAISERROR('LargeEmployers',10,1) WITH NOWAIT;				
			EXEC [Staging].[usp_Process_LargeEmployers];
			
			RAISERROR('SourceFile',10,1) WITH NOWAIT;
			EXEC [Staging].[usp_Process_SourceFile];
			
			RAISERROR('VersionInfo',10,1) WITH NOWAIT;
			EXEC [Staging].[usp_Process_VersionInfo];
			
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
GO

GRANT EXECUTE ON [Staging].[usp_Process] TO [LargeEmployer_RW_User]
GO
