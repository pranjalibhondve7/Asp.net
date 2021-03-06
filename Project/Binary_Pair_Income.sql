USE [Cursor_db]
GO
/****** Object:  StoredProcedure [dbo].[Binary_Income]    Script Date: 22-04-2021 15:48:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Binary_Income]
	
AS
	DECLARE @user_id NVARCHAR(100)
	DECLARE @L_Count INT
	DECLARE @R_Count INT
	DECLARE @description NVARCHAR(100)
	DECLARE @Pre_l_Count INT
	DECLARE @Pre_R_Count INT
	DECLARE @Pair INT
	DECLARE @L_carry INT
	DECLARE @R_carry INT
	DECLARE @binary_income DECIMAL(18,2)
	DECLARE @payout_amt DECIMAL(18,2)
	DECLARE @Total_admin DECIMAL(18,2)
	DECLARE @Total_TDS DECIMAL(18,2)
	DECLARE @Net_Amt DECIMAL(18,2)
	DECLARE @Admin DECIMAL(18,2)
	DECLARE @TDS DECIMAL(18,2)

BEGIN
	SET @description= 'Matching Income'
	SET @binary_income=100
	SET @Admin=(SELECT TOP 1 admin_charge FROM plan_setting)
	SET @TDS=(SELECT TOP 1 tds_charge FROM plan_setting)
	
	DECLARE cur_main CURSOR
	FOR
		SELECT User_Id FROM MLM_Reg_Binary WHERE JoinType='PAID'
	OPEN cur_main
	FETCH NEXT FROM cur_main INTO @user_id
	WHILE(@@FETCH_STATUS=0)
	BEGIN
		SET @L_Count=(SELECT [dbo].[LEFT_COUNT](@user_id,CAST(GETDATE() AS date)))
		SET @R_Count=(SELECT [dbo].[Right_Count](@user_id,CAST(GETDATE() AS date)))
		IF EXISTS(SELECT User_ID FROM Mem_Payment_Binary WHERE User_ID=@user_id AND Description=@description)
		BEGIN
			SET @Pre_l_Count=(SELECT TOP 1 ISNULL(L_Carry,0) FROM Mem_Payment_Binary WHERE User_ID=@user_id AND Description=@description ORDER BY ID DESC)
			SET @Pre_R_Count=(SELECT TOP 1 ISNULL(R_Carry,0) FROM Mem_Payment_Binary WHERE User_ID=@user_id AND Description=@description ORDER BY ID DESC)
			SET @L_Count=@L_Count+@Pre_l_Count
			SET @R_Count=@R_Count+@Pre_R_Count
		END
		IF(@L_Count>@R_Count)
		BEGIN
			SET @Pair=@R_Count
			SET @L_carry=@L_Count-@R_Count
			SET @R_carry=0
		END
		ELSE IF(@R_Count>@L_Count)
		BEGIN
			SET @Pair=@L_Count
			SET @L_carry=0
			SET @R_carry=@R_Count-@L_Count
		END
		ELSE
		BEGIN
			SET @Pair=@L_Count
			SET @L_carry=0
			SET @R_carry=0
		END
		
		SET @payout_amt=@binary_income*@Pair
		SET @Total_admin=(@payout_amt/100)*@admin
		SET @Total_TDS=(@payout_amt/100)*@TDS
		SET @Net_Amt=@payout_amt-(@Total_admin+@Total_TDS)

		INSERT INTO  Mem_Payment_Binary(User_ID,Payout_Amt,Admin,TDS,Net_AMT,Description,Date,User_ID_BY,Pair,L_Carry,R_Carry)VALUES(@user_id,@payout_amt,@Total_admin,@Total_TDS,@Net_Amt,@description,GETDATE(),'SELF',@Pair,@L_carry,@R_carry)
		FETCH NEXT FROM cur_main INTO @user_id
	END
	CLOSE cur_main
	DEALLOCATE cur_main
END
--EXEC Binary_Income
--SELECT * FROM Mem_Payment_Binary
--SELECT * FROM MLM_Reg_Binary
--TRUNCATE TABLE Mem_Payment_Binary
--DELETE FROM Mem_Payment_Binary WHERE ID>=7
--SELECT TOP 1 * FROM Mem_Payment_Binary WHERE User_ID='A' AND Description='Matching Income' ORDER BY ID DESC
--SELECT GETDATE()
