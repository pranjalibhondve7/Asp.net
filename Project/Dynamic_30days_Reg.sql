USE [Cursor_db]
GO
/****** Object:  StoredProcedure [dbo].[Dynamic_mlm_reg]    Script Date: 23-04-2021 18:39:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Dynamic_mlm_reg]	
AS
	DECLARE @userid NVARCHAR(100)
	DECLARE @jointype NVARCHAR(100)
	DECLARE @count INT
	DECLARE @maxday INT
	DECLARE @roi_amt DECIMAL(18,2)
	DECLARE @payout_amt DECIMAL(18,2)
	DECLARE @admin_charge DECIMAL(18,2)
	DECLARE @tds_charge DECIMAL(18,2)
	DECLARE @net_amt DECIMAL(18,2)
	DECLARE @admin DECIMAL(18,2)
	DECLARE @tds DECIMAL(18,2)
	DECLARE @description NVARCHAR(100)

BEGIN
	SET @description='ROI INCOME'
	SET @maxday=(SELECT TOP 1 ROI_MAXDAY FROM ROI_MAX_DAY)
	SET @roi_amt=(SELECT TOP 1 ROI_AMT FROM ROI_MAX_DAY)
	SET @admin=(SELECT TOP 1 admin_charge FROM plan_setting)
	SET @tds=(SELECT TOP 1 tds_charge FROM plan_setting)

	DECLARE cur_name CURSOR
	FOR
		SELECT User_ID,JoinType FROM mlm_Registration WHERE JoinType='PAID'
	OPEN cur_name
	FETCH NEXT FROM cur_name INTO @userid,@jointype

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		SET @payout_amt=@roi_amt
		SET @admin_charge=(@payout_amt/100)*@admin
		SET @tds_charge=(@payout_amt/100)*@tds
		SET @net_amt=@payout_amt-(@admin_charge+@tds_charge)
		SET @count =(SELECT COUNT(USER_ID) FROM Member_Payment WHERE User_ID=@userid AND Description=@description)

		IF(@count<@maxday)
		BEGIN
		INSERT INTO Member_Payment(User_ID,Payout_Amt,Admin_Charge,TDS_Charge,Net_Amt,Description,Date) VALUES (@userid,@payout_amt,@admin_charge,@tds_charge,@net_amt,@description,getdate())
		END		
		FETCH NEXT FROM cur_name INTO @userid,@jointype
	END
	CLOSE cur_name
	DEALLOCATE cur_name
END
--EXEC Dynamic_mlm_reg
--SELECT * FROM Member_Payment
--TRUNCATE TABLE Member_Payment