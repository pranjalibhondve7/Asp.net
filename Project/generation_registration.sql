USE [Cursor_db]
GO
/****** Object:  StoredProcedure [dbo].[Generation_Reg]    Script Date: 22-04-2021 20:28:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Generation_Reg]
AS
	DECLARE @userid NVARCHAR(100)
	DECLARE @sponsor_id NVARCHAR(100)
	DECLARE @package_id INT
	DECLARE @description NVARCHAR(100)
	DECLARE @user_id_by NVARCHAR(100)
	DECLARE @payout_amt DECIMAL(18,2)
	DECLARE @admin DECIMAL(18,2)
	DECLARE @tds DECIMAL(18,2)
	DECLARE @admin_charge DECIMAL(18,2)
	DECLARE @tds_charge DECIMAL(18,2)
	DECLARE @net_amt DECIMAL(18,2)
	DECLARE @package_amt DECIMAL(18,2)
	DECLARE @percent DECIMAL(18,2)

BEGIN
	SET @description='DIRECT INCOME'
	SET @admin=(SELECT TOP 1 admin_charge FROM plan_setting )
	SET @tds=(SELECT TOP 1 tds_charge FROM plan_setting )
	DECLARE cur_name CURSOR
	FOR
		SELECT User_ID,Sponsors_ID,Package_ID FROM MLM_Reg_gen	WHERE Jointype='PAID'
	OPEN cur_name
	FETCH NEXT FROM cur_name INTO @userid,@sponsor_id,@package_id
	WHILE(@@FETCH_STATUS = 0)
	BEGIN 
		SET @package_amt=(SELECT Amount FROM Package_Info WHERE ID=@package_id)
		SET @percent=(SELECT Direct_per  FROM Package_Info WHERE ID=@package_id)		 
		SET @payout_amt=(@package_amt/100) * @percent
		SET @admin_charge=(@payout_amt/100)*@admin
		SET @tds_charge=(@payout_amt/100)*@tds
		SET @net_amt=@payout_amt-(@admin_charge+@tds_charge)

		IF NOT EXISTS (SELECT User_ID FROM Member_Payment2 WHERE User_ID=@sponsor_id AND User_ID_BY=@userid AND Description=@description)
		BEGIN
			INSERT INTO Member_Payment2(User_ID,Payout_Amt,Admin,TDS,Net_AMT,Description,Date,User_ID_BY) VALUES (@sponsor_id,@payout_amt,@admin_charge,@tds_charge,@net_amt,@description,GETDATE(),@userid) 
		END
		FETCH NEXT FROM cur_name INTO @userid,@sponsor_id,@package_id
		
	END	
	CLOSE cur_name
	DEALLOCATE cur_name
END
--EXEC Generation_Reg
--SELECT * FROM Member_Payment2
--TRUNCATE TABLE Member_Payment2
--SELECT * FROM plan_setting
--SELECT * FROM MLM_Reg_gen
--SELECT * FROM Package_Info