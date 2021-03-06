USE [Cursor_db]
GO
/****** Object:  StoredProcedure [dbo].[Level_Income]    Script Date: 21-04-2021 13:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Level_Income]
AS	
	DECLARE @userid NVARCHAR(100)
	DECLARE @sponsor_id NVARCHAR(100)
	DECLARE @package_id INT
	DECLARE @description NVARCHAR(100)
	DECLARE @admin DECIMAL(18,2)
	DECLARE @tds DECIMAL(18,2)
	DECLARE @package_amt DECIMAL(18,2)
	DECLARE @percent DECIMAL(18,2)
	DECLARE @admin_charge DECIMAL(18,2)
	DECLARE @tds_charge DECIMAL(18,2)
	DECLARE @payout_amt DECIMAL(18,2)
	DECLARE @net_amt DECIMAL(18,2)
	DECLARE @level INT
	DECLARE @next_user_id NVARCHAR(100)
	DECLARE @next_join_type NVARCHAR(100)
	DECLARE @join_type NVARCHAR(100)
	DECLARE @next_inner_user_id NVARCHAR(100)
	
BEGIN
	CREATE TABLE ##TEMP_1(user_id NVARCHAR(100))
	CREATE TABLE ##TEMP_2(user_id NVARCHAR(100))
	CREATE TABLE ##TEMP_3(user_id NVARCHAR(100))
	CREATE TABLE ##TEMP_4(user_id NVARCHAR(100))
	CREATE TABLE ##TEMP_5(user_id NVARCHAR(100))
	CREATE TABLE ##TEMP_6(user_id NVARCHAR(100))
	CREATE TABLE ##TEMP_7(user_id NVARCHAR(100))
	CREATE TABLE ##TEMP_8(user_id NVARCHAR(100))
	CREATE TABLE ##TEMP_9(user_id NVARCHAR(100))
	CREATE TABLE ##TEMP_10(user_id NVARCHAR(100))
	
	SET @description='LEVEL INCOME'
	SET @admin=(SELECT TOP 1 admin_charge FROM plan_setting )
	SET @tds=(SELECT TOP 1 tds_charge FROM plan_setting )

	DECLARE cur_name_main CURSOR
	FOR
		SELECT User_id FROM MMLG_Reg WHERE Jointype='PAID'
	OPEN cur_name_main
	FETCH NEXT FROM cur_name_main INTO @userid
	WHILE(@@FETCH_STATUS = 0)
	BEGIN 
	--level 1 CURSOR ----------------------------------------------------------------------
		DECLARE cur_level1 CURSOR
		FOR
			SELECT User_id,Jointype,Package_id FROM MMLG_Reg WHERE Placeunder_id=@userid
		OPEN cur_level1
		FETCH NEXT FROM cur_level1 INTO @next_user_id,@next_join_type,@package_id
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			IF @next_join_type='PAID'
			BEGIN
				SET @package_amt=(SELECT Amount FROM Package_Info WHERE ID=@package_id )
				SET @percent=(SELECT [Percent]  FROM Level_Master WHERE Level=1)	
				SET @payout_amt=(@package_amt/100)*@percent
				SET @admin_charge=(@payout_amt/100)*@admin
				SET @tds_charge=(@payout_amt/100)*@tds
				SET @net_amt=@payout_amt-(@admin_charge+@tds_charge)
				IF NOT EXISTS (SELECT User_ID FROM Mem_Payment_Level WHERE USER_ID=@userid AND USER_ID_BY=@next_user_id AND DESCRIPTION=@description)
				BEGIN
					INSERT INTO Mem_Payment_Level(USER_ID,PAYOUT_AMT,ADMIN,TDS,NETAMT,DESCRIPTION,DATE,USER_ID_BY,Level) VALUES (@userid,@payout_amt,@admin_charge,@tds_charge,@net_amt,@description,GETDATE(),@next_user_id,1) 		
				END
			END
			 INSERT INTO ##TEMP_1(user_id) VALUES(@next_user_id)
			 FETCH NEXT FROM cur_level1 INTO @next_user_id,@next_join_type,@package_id
		END
		CLOSE cur_level1
		DEALLOCATE cur_level1
		--FIRST LEVEL COMPLETE----------------------------------------------------------------------------------------------------------------------
		--NEXT LEVEL-----------------------------------------------------------------------------------------
		DECLARE cur_level2 CURSOR
		FOR
			SELECT user_id FROM ##TEMP_1
		OPEN cur_level2
		FETCH NEXT FROM cur_level2 INTO @next_user_id
		WHILE(@@FETCH_STATUS=0)
		BEGIN
		-- LEVEL 2 CURSOR-------------------------------------------------------------------------------------------------------------------------

			DECLARE cur_level2_inner CURSOR
			FOR
			SELECT User_id,Jointype,Package_id FROM MMLG_Reg WHERE Placeunder_id=@next_user_id
			OPEN cur_level2_inner
			FETCH NEXT FROM cur_level2_inner INTO @next_inner_user_id,@next_join_type,@package_id
			WHILE(@@FETCH_STATUS=0)
			BEGIN
				IF @next_join_type='PAID'
				BEGIN
					SET @package_amt=(SELECT Amount FROM Package_Info WHERE ID=@package_id )
					SET @percent=(SELECT [Percent]  FROM Level_Master WHERE Level=2)
					SET @payout_amt=(@package_amt/100) * @percent
					SET @admin_charge=(@payout_amt/100)*@admin
					SET @tds_charge=(@payout_amt/100)*@tds
					SET @net_amt=@payout_amt-(@admin_charge+@tds_charge)
					IF NOT EXISTS (SELECT User_ID FROM Mem_Payment_Level WHERE USER_ID=@userid AND USER_ID_BY=@next_inner_user_id AND DESCRIPTION=@description)
					BEGIN
						INSERT INTO Mem_Payment_Level(USER_ID,PAYOUT_AMT,ADMIN,TDS,NETAMT,DESCRIPTION,DATE,USER_ID_BY,Level) VALUES (@userid,@payout_amt,@admin_charge,@tds_charge,@net_amt,@description,GETDATE(),@next_inner_user_id,2) 		
					END
				END
					INSERT INTO ##TEMP_2(user_id) VALUES (@next_inner_user_id)
					FETCH NEXT FROM cur_level2_inner INTO @next_inner_user_id,@next_join_type,@package_id
			END
			CLOSE cur_level2_inner
			DEALLOCATE cur_level2_inner
			FETCH NEXT FROM cur_level2 INTO @next_user_id

		END
		CLOSE cur_level2
		DEALLOCATE cur_level2
		--END LEVEL 2--------------------------------
		--LEVEL 2 START-----------------------------------------------------------------------------------------------------------------

		DECLARE cur_level3 CURSOR
		FOR
			SELECT user_id FROM ##TEMP_2
		OPEN cur_level3
		FETCH NEXT FROM cur_level3 INTO @next_user_id
		WHILE(@@FETCH_STATUS=0)
		BEGIN
		
			DECLARE cur_level3_inner CURSOR
			FOR
			SELECT User_id,Jointype,Package_id FROM MMLG_Reg WHERE Placeunder_id=@next_user_id
			OPEN cur_level3_inner
			FETCH NEXT FROM cur_level3_inner INTO @next_inner_user_id,@next_join_type,@package_id
			WHILE(@@FETCH_STATUS=0)
			BEGIN
				IF @next_join_type='PAID'
				BEGIN
					SET @package_amt=(SELECT Amount FROM Package_Info WHERE ID=@package_id )
					SET @percent=(SELECT [Percent]  FROM Level_Master WHERE Level=3)
					SET @payout_amt=(@package_amt/100) * @percent
					SET @admin_charge=(@payout_amt/100)*@admin
					SET @tds_charge=(@payout_amt/100)*@tds
					SET @net_amt=@payout_amt-(@admin_charge+@tds_charge)
					IF NOT EXISTS (SELECT User_ID FROM Mem_Payment_Level WHERE USER_ID=@userid AND USER_ID_BY=@next_inner_user_id AND DESCRIPTION=@description)
					BEGIN
						INSERT INTO Mem_Payment_Level(USER_ID,PAYOUT_AMT,ADMIN,TDS,NETAMT,DESCRIPTION,DATE,USER_ID_BY,Level) VALUES (@userid,@payout_amt,@admin_charge,@tds_charge,@net_amt,@description,GETDATE(),@next_inner_user_id,3) 		
					END
				END
					INSERT INTO ##TEMP_3(user_id) VALUES (@next_inner_user_id)
					FETCH NEXT FROM cur_level3_inner INTO @next_inner_user_id,@next_join_type,@package_id
			END
			CLOSE cur_level3_inner
			DEALLOCATE cur_level3_inner
			FETCH NEXT FROM cur_level3 INTO @next_user_id
		END
		CLOSE cur_level3
		DEALLOCATE cur_level3
		--END LEVEL 3-------------------------------------------------------------------------------------
		--START LEVEL 4-------------------------------------------------------------------------------------------------------------------------------------------------

		DECLARE cur_level4 CURSOR
		FOR
			SELECT user_id FROM ##TEMP_3
		OPEN cur_level4
		FETCH NEXT FROM cur_level4 INTO @next_user_id
		WHILE(@@FETCH_STATUS=0)
		BEGIN
		
			DECLARE cur_level4_inner CURSOR
			FOR
			SELECT User_id,Jointype,Package_id FROM MMLG_Reg WHERE Placeunder_id=@next_user_id
			OPEN cur_level4_inner
			FETCH NEXT FROM cur_level4_inner INTO @next_inner_user_id,@next_join_type,@package_id
			WHILE(@@FETCH_STATUS=0)
			BEGIN
				IF @next_join_type='PAID'
				BEGIN
					SET @package_amt=(SELECT Amount FROM Package_Info WHERE ID=@package_id )
					SET @percent=(SELECT [Percent]  FROM Level_Master WHERE Level=4)
					SET @payout_amt=(@package_amt/100) * @percent
					SET @admin_charge=(@payout_amt/100)*@admin
					SET @tds_charge=(@payout_amt/100)*@tds
					SET @net_amt=@payout_amt-(@admin_charge+@tds_charge)
					IF NOT EXISTS (SELECT User_ID FROM Mem_Payment_Level WHERE USER_ID=@userid AND USER_ID_BY=@next_inner_user_id AND DESCRIPTION=@description)
					BEGIN
						INSERT INTO Mem_Payment_Level(USER_ID,PAYOUT_AMT,ADMIN,TDS,NETAMT,DESCRIPTION,DATE,USER_ID_BY,Level) VALUES (@userid,@payout_amt,@admin_charge,@tds_charge,@net_amt,@description,GETDATE(),@next_inner_user_id,4) 		
					END
				END
					INSERT INTO ##TEMP_4(user_id) VALUES (@next_inner_user_id)
					FETCH NEXT FROM cur_level4_inner INTO @next_inner_user_id,@next_join_type,@package_id
			END
			CLOSE cur_level4_inner
			DEALLOCATE cur_level4_inner
			FETCH NEXT FROM cur_level4 INTO @next_user_id
		END
		CLOSE cur_level4
		DEALLOCATE cur_level4
		--LEVEL 5 START----------------------------------------------------------------------------------------------------------------------------------------------

		DECLARE cur_level5 CURSOR
		FOR
			SELECT user_id FROM ##TEMP_4
		OPEN cur_level5
		FETCH NEXT FROM cur_level5 INTO @next_user_id
		WHILE(@@FETCH_STATUS=0)
		BEGIN
		
			DECLARE cur_level5_inner CURSOR
			FOR
			SELECT User_id,Jointype,Package_id FROM MMLG_Reg WHERE Placeunder_id=@next_user_id
			OPEN cur_level5_inner
			FETCH NEXT FROM cur_level5_inner INTO @next_inner_user_id,@next_join_type,@package_id
			WHILE(@@FETCH_STATUS=0)
			BEGIN
				IF @next_join_type='PAID'
				BEGIN
					SET @package_amt=(SELECT Amount FROM Package_Info WHERE ID=@package_id )
					SET @percent=(SELECT [Percent]  FROM Level_Master WHERE Level=5)
					SET @payout_amt=(@package_amt/100) * @percent
					SET @admin_charge=(@payout_amt/100)*@admin
					SET @tds_charge=(@payout_amt/100)*@tds
					SET @net_amt=@payout_amt-(@admin_charge+@tds_charge)
					IF NOT EXISTS (SELECT User_ID FROM Mem_Payment_Level WHERE USER_ID=@userid AND USER_ID_BY=@next_inner_user_id AND DESCRIPTION=@description)
					BEGIN
						INSERT INTO Mem_Payment_Level(USER_ID,PAYOUT_AMT,ADMIN,TDS,NETAMT,DESCRIPTION,DATE,USER_ID_BY,Level) VALUES (@userid,@payout_amt,@admin_charge,@tds_charge,@net_amt,@description,GETDATE(),@next_inner_user_id,5) 		
					END
				END
					INSERT INTO ##TEMP_5(user_id) VALUES (@next_inner_user_id)
					FETCH NEXT FROM cur_level5_inner INTO @next_inner_user_id,@next_join_type,@package_id
			END
			CLOSE cur_level5_inner
			DEALLOCATE cur_level5_inner
			FETCH NEXT FROM cur_level5 INTO @next_user_id
		END
		CLOSE cur_level5
		DEALLOCATE cur_level5
		--LEVEL 5 END---------------------------------------------------------------------------------------------------------
		--LEVEL 6 START-----------------------------------------------------------------------------------------------------------

		DECLARE cur_level6 CURSOR
		FOR
			SELECT user_id FROM ##TEMP_5
		OPEN cur_level6
		FETCH NEXT FROM cur_level6 INTO @next_user_id
		WHILE(@@FETCH_STATUS=0)
		BEGIN
		
			DECLARE cur_level6_inner CURSOR
			FOR
			SELECT User_id,Jointype,Package_id FROM MMLG_Reg WHERE Placeunder_id=@next_user_id
			OPEN cur_level6_inner
			FETCH NEXT FROM cur_level6_inner INTO @next_inner_user_id,@next_join_type,@package_id
			WHILE(@@FETCH_STATUS=0)
			BEGIN
				IF @next_join_type='PAID'
				BEGIN
					SET @package_amt=(SELECT Amount FROM Package_Info WHERE ID=@package_id )
					SET @percent=(SELECT [Percent]  FROM Level_Master WHERE Level=6)
					SET @payout_amt=(@package_amt/100) * @percent
					SET @admin_charge=(@payout_amt/100)*@admin
					SET @tds_charge=(@payout_amt/100)*@tds
					SET @net_amt=@payout_amt-(@admin_charge+@tds_charge)
					IF NOT EXISTS (SELECT User_ID FROM Mem_Payment_Level WHERE USER_ID=@userid AND USER_ID_BY=@next_inner_user_id AND DESCRIPTION=@description)
					BEGIN
						INSERT INTO Mem_Payment_Level(USER_ID,PAYOUT_AMT,ADMIN,TDS,NETAMT,DESCRIPTION,DATE,USER_ID_BY,Level) VALUES (@userid,@payout_amt,@admin_charge,@tds_charge,@net_amt,@description,GETDATE(),@next_inner_user_id,6) 		
					END
				END
					INSERT INTO ##TEMP_6(user_id) VALUES (@next_inner_user_id)
					FETCH NEXT FROM cur_level6_inner INTO @next_inner_user_id,@next_join_type,@package_id
			END
			CLOSE cur_level6_inner
			DEALLOCATE cur_level6_inner
			FETCH NEXT FROM cur_level6 INTO @next_user_id
		END
		CLOSE cur_level6
		DEALLOCATE cur_level6
		--LEVEL 7 START------------------------------------------------------------------------------------------------------------------------------------

		DECLARE cur_level7 CURSOR
		FOR
			SELECT user_id FROM ##TEMP_6
		OPEN cur_level7
		FETCH NEXT FROM cur_level7 INTO @next_user_id
		WHILE(@@FETCH_STATUS=0)
		BEGIN
		
			DECLARE cur_level7_inner CURSOR
			FOR
			SELECT User_id,Jointype,Package_id FROM MMLG_Reg WHERE Placeunder_id=@next_user_id
			OPEN cur_level7_inner
			FETCH NEXT FROM cur_level7_inner INTO @next_inner_user_id,@next_join_type,@package_id
			WHILE(@@FETCH_STATUS=0)
			BEGIN
				IF @next_join_type='PAID'
				BEGIN
					SET @package_amt=(SELECT Amount FROM Package_Info WHERE ID=@package_id )
					SET @percent=(SELECT [Percent]  FROM Level_Master WHERE Level=7)
					SET @payout_amt=(@package_amt/100) * @percent
					SET @admin_charge=(@payout_amt/100)*@admin
					SET @tds_charge=(@payout_amt/100)*@tds
					SET @net_amt=@payout_amt-(@admin_charge+@tds_charge)
					IF NOT EXISTS (SELECT User_ID FROM Mem_Payment_Level WHERE USER_ID=@userid AND USER_ID_BY=@next_inner_user_id AND DESCRIPTION=@description)
					BEGIN
						INSERT INTO Mem_Payment_Level(USER_ID,PAYOUT_AMT,ADMIN,TDS,NETAMT,DESCRIPTION,DATE,USER_ID_BY,Level) VALUES (@userid,@payout_amt,@admin_charge,@tds_charge,@net_amt,@description,GETDATE(),@next_inner_user_id,7) 		
					END
				END
					INSERT INTO ##TEMP_7(user_id) VALUES (@next_inner_user_id)
					FETCH NEXT FROM cur_level7_inner INTO @next_inner_user_id,@next_join_type,@package_id
			END
			CLOSE cur_level7_inner
			DEALLOCATE cur_level7_inner
			FETCH NEXT FROM cur_level7 INTO @next_user_id
		END
		CLOSE cur_level7
		DEALLOCATE cur_level7
		--START LEVEL 8---------------------------------------------------------------------------------------------------------------------------------------------

		DECLARE cur_level8 CURSOR
		FOR
			SELECT user_id FROM ##TEMP_7
		OPEN cur_level8
		FETCH NEXT FROM cur_level8 INTO @next_user_id
		WHILE(@@FETCH_STATUS=0)
		BEGIN
		
			DECLARE cur_level8_inner CURSOR
			FOR
			SELECT User_id,Jointype,Package_id FROM MMLG_Reg WHERE Placeunder_id=@next_user_id
			OPEN cur_level8_inner
			FETCH NEXT FROM cur_level8_inner INTO @next_inner_user_id,@next_join_type,@package_id
			WHILE(@@FETCH_STATUS=0)
			BEGIN
				IF @next_join_type='PAID'
				BEGIN
					SET @package_amt=(SELECT Amount FROM Package_Info WHERE ID=@package_id )
					SET @percent=(SELECT [Percent]  FROM Level_Master WHERE Level=8)
					SET @payout_amt=(@package_amt/100) * @percent
					SET @admin_charge=(@payout_amt/100)*@admin
					SET @tds_charge=(@payout_amt/100)*@tds
					SET @net_amt=@payout_amt-(@admin_charge+@tds_charge)
					IF NOT EXISTS (SELECT User_ID FROM Mem_Payment_Level WHERE USER_ID=@userid AND USER_ID_BY=@next_inner_user_id AND DESCRIPTION=@description)
					BEGIN
						INSERT INTO Mem_Payment_Level(USER_ID,PAYOUT_AMT,ADMIN,TDS,NETAMT,DESCRIPTION,DATE,USER_ID_BY,Level) VALUES (@userid,@payout_amt,@admin_charge,@tds_charge,@net_amt,@description,GETDATE(),@next_inner_user_id,8) 		
					END
				END
					INSERT INTO ##TEMP_8(user_id) VALUES (@next_inner_user_id)
					FETCH NEXT FROM cur_level8_inner INTO @next_inner_user_id,@next_join_type,@package_id
			END
			CLOSE cur_level8_inner
			DEALLOCATE cur_level8_inner
			FETCH NEXT FROM cur_level8 INTO @next_user_id
		END
		CLOSE cur_level8
		DEALLOCATE cur_level8
		--LEVEL 9 START---------------------------------------------------------------------------------------------------------------------------------------------

		DECLARE cur_level9 CURSOR
		FOR
			SELECT user_id FROM ##TEMP_8
		OPEN cur_level9
		FETCH NEXT FROM cur_level9 INTO @next_user_id
		WHILE(@@FETCH_STATUS=0)
		BEGIN
		
			DECLARE cur_level9_inner CURSOR
			FOR
			SELECT User_id,Jointype,Package_id FROM MMLG_Reg WHERE Placeunder_id=@next_user_id
			OPEN cur_level9_inner
			FETCH NEXT FROM cur_level9_inner INTO @next_inner_user_id,@next_join_type,@package_id
			WHILE(@@FETCH_STATUS=0)
			BEGIN
				IF @next_join_type='PAID'
				BEGIN
					SET @package_amt=(SELECT Amount FROM Package_Info WHERE ID=@package_id )
					SET @percent=(SELECT [Percent]  FROM Level_Master WHERE Level=9)
					SET @payout_amt=(@package_amt/100) * @percent
					SET @admin_charge=(@payout_amt/100)*@admin
					SET @tds_charge=(@payout_amt/100)*@tds
					SET @net_amt=@payout_amt-(@admin_charge+@tds_charge)
					IF NOT EXISTS (SELECT User_ID FROM Mem_Payment_Level WHERE USER_ID=@userid AND USER_ID_BY=@next_inner_user_id AND DESCRIPTION=@description)
					BEGIN
						INSERT INTO Mem_Payment_Level(USER_ID,PAYOUT_AMT,ADMIN,TDS,NETAMT,DESCRIPTION,DATE,USER_ID_BY,Level) VALUES (@userid,@payout_amt,@admin_charge,@tds_charge,@net_amt,@description,GETDATE(),@next_inner_user_id,9) 		
					END
				END
					INSERT INTO ##TEMP_9(user_id) VALUES (@next_inner_user_id)
					FETCH NEXT FROM cur_level9_inner INTO @next_inner_user_id,@next_join_type,@package_id
			END
			CLOSE cur_level9_inner
			DEALLOCATE cur_level9_inner
			FETCH NEXT FROM cur_level9 INTO @next_user_id
		END
		CLOSE cur_level9
		DEALLOCATE cur_level9
		--LEVEL 10 START-------------------------------------------------------------------------------------------------------------------------------------

		DECLARE cur_level10 CURSOR
		FOR
			SELECT user_id FROM ##TEMP_9
		OPEN cur_level10
		FETCH NEXT FROM cur_level10 INTO @next_user_id
		WHILE(@@FETCH_STATUS=0)
		BEGIN
		
			DECLARE cur_level10_inner CURSOR
			FOR
			SELECT User_id,Jointype,Package_id FROM MMLG_Reg WHERE Placeunder_id=@next_user_id
			OPEN cur_level10_inner
			FETCH NEXT FROM cur_level10_inner INTO @next_inner_user_id,@next_join_type,@package_id
			WHILE(@@FETCH_STATUS=0)
			BEGIN
				IF @next_join_type='PAID'
				BEGIN
					SET @package_amt=(SELECT Amount FROM Package_Info WHERE ID=@package_id )
					SET @percent=(SELECT [Percent]  FROM Level_Master WHERE Level=10)
					SET @payout_amt=(@package_amt/100) * @percent
					SET @admin_charge=(@payout_amt/100)*@admin
					SET @tds_charge=(@payout_amt/100)*@tds
					SET @net_amt=@payout_amt-(@admin_charge+@tds_charge)
					IF NOT EXISTS (SELECT User_ID FROM Mem_Payment_Level WHERE USER_ID=@userid AND USER_ID_BY=@next_inner_user_id AND DESCRIPTION=@description)
					BEGIN
						INSERT INTO Mem_Payment_Level(USER_ID,PAYOUT_AMT,ADMIN,TDS,NETAMT,DESCRIPTION,DATE,USER_ID_BY,Level) VALUES (@userid,@payout_amt,@admin_charge,@tds_charge,@net_amt,@description,GETDATE(),@next_inner_user_id,10) 		
					END
				END
					INSERT INTO ##TEMP_10(user_id) VALUES (@next_inner_user_id)
					FETCH NEXT FROM cur_level10_inner INTO @next_inner_user_id,@next_join_type,@package_id
			END
			CLOSE cur_level10_inner
			DEALLOCATE cur_level10_inner
			FETCH NEXT FROM cur_level10 INTO @next_user_id
		END
		CLOSE cur_level10
		DEALLOCATE cur_level10

		TRUNCATE TABLE ##TEMP_1
		TRUNCATE TABLE ##TEMP_2
		TRUNCATE TABLE ##TEMP_3
		TRUNCATE TABLE ##TEMP_4
		TRUNCATE TABLE ##TEMP_5
		TRUNCATE TABLE ##TEMP_6
		TRUNCATE TABLE ##TEMP_7
		TRUNCATE TABLE ##TEMP_8
		TRUNCATE TABLE ##TEMP_9
		TRUNCATE TABLE ##TEMP_10
		FETCH NEXT FROM cur_name_main INTO @userid
    END

	CLOSE cur_name_main
	DEALLOCATE cur_name_main
	DROP TABLE ##TEMP_1
	DROP TABLE ##TEMP_2
	DROP TABLE ##TEMP_3
	DROP TABLE ##TEMP_4
	DROP TABLE ##TEMP_5
	DROP TABLE ##TEMP_6
	DROP TABLE ##TEMP_7
	DROP TABLE ##TEMP_8
	DROP TABLE ##TEMP_9
	DROP TABLE ##TEMP_10
END
--EXEC Level_Income
--SELECT * FROM Mem_Payment_Level
--TRUNCATE TABLE Mem_Payment_Level
--SELECT * FROM MMLG_Reg
--SELECT * FROM Level_Master

