USE [Cursor_db]
GO
/****** Object:  StoredProcedure [dbo].[MLM_Reg]    Script Date: 17-04-2021 11:11:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[MLM_Reg]
AS
	DECLARE @userid NVARCHAR(100)
	DECLARE @jointype NVARCHAR(100)
	DECLARE @count INT
BEGIN
	DECLARE cur_name CURSOR
	FOR
		SELECT User_ID,JoinType FROM mlm_Registration WHERE JoinType='PAID'
	OPEN cur_name
	FETCH NEXT FROM cur_name INTO @userid,@jointype
	WHILE(@@FETCH_STATUS=0)
	BEGIN
		SET @count =(SELECT COUNT(USER_ID) FROM Member_Payment WHERE User_ID=@userid AND Description='ROI INCOME')
		IF(@count<30)
		BEGIN
		INSERT INTO Member_Payment(User_ID,Payout_Amt,Admin_Charge,TDS_Charge,Net_Amt,Description,Date) VALUES (@userid,30,0,0,30,'ROI INCOME',getdate())
		END		
		FETCH NEXT FROM cur_name INTO @userid,@jointype
	END
	CLOSE cur_name
	DEALLOCATE cur_name
END
GO
--EXEC MLM_Reg
--SELECT * FROM mlm_Registration
--SELECT * FROM Member_Payment WHERE User_ID='A'
--TRUNCATE TABLE Member_Payment