USE [Cursor_db]
GO
/****** Object:  UserDefinedFunction [dbo].[LEFT_COUNT]    Script Date: 23-04-2021 09:31:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[LEFT_COUNT](@user_id nvarchar(100),@package_date DATE)  --return only one value it is a scalar function
RETURNS INT
AS
BEGIN

DECLARE @L_count INT
DECLARE @v_L_LEG NVARCHAR(100)
DECLARE @L_Jointype NVARCHAR(100)
DECLARE @L_package_date DATE
DECLARE @next_l_leg NVARCHAR(100)
DECLARE @user_id1 NVARCHAR(100)
DECLARE @next_R_leg NVARCHAR(100)
DECLARE @next_l_jointype NVARCHAR(100)
DECLARE @next_l_package_date DATE
DECLARE @next_R_jointype NVARCHAR(100)
DECLARE @next_R_package_date DATE
DECLARE @v_R_LEG NVARCHAR(100)

 DECLARE @TEMP TABLE(user_id1 NVARCHAR(100),jointype NVARCHAR(100),package_date DATE)	
 SET @v_L_LEG = (SELECT ISNULL (L_LEG,'NO RECORD') FROM MLM_Reg_Binary WHERE USER_ID=@user_id)

 IF @v_L_LEG = 'NO RECORD' 
 BEGIN
	SET @L_count=0
 END
 ELSE
 BEGIN
	--SET @L_count=1
	
	SET @L_Jointype=(SELECT JoinType FROM MLM_Reg_Binary WHERE User_Id=@v_L_LEG)
	SET @L_package_date=(SELECT Package_Date FROM MLM_Reg_Binary WHERE User_Id=@v_L_LEG )
	INSERT INTO @TEMP (user_id1,jointype,package_date) values(@v_L_LEG,@L_Jointype,@L_package_date)
	DECLARE cur_main CURSOR
	FOR
	SELECT user_id1 FROM @TEMP
	OPEN cur_main
	FETCH NEXT FROM cur_main INTO @user_id1
	WHILE(@@FETCH_STATUS=0)
	BEGIN
		SET @next_l_leg=(SELECT L_Leg FROM MLM_Reg_Binary WHERE User_Id=@user_id1)
		SET @next_R_leg=(SELECT R_Leg FROM MLM_Reg_Binary WHERE User_Id=@user_id1)
		IF @next_l_leg IS NOT NULL
		BEGIN
			SET @next_l_jointype=(SELECT JoinType FROM MLM_Reg_Binary WHERE User_Id=@next_l_leg)
			SET @next_l_package_date=(SELECT Package_Date FROM MLM_Reg_Binary WHERE User_Id=@next_l_leg)
			INSERT  INTO @TEMP(user_id1,jointype,package_date)VALUES(@next_l_leg,@next_l_jointype,@next_l_package_date)
		END
		IF @next_R_leg IS NOT NULL
		BEGIN
			SET @next_R_jointype=(SELECT JoinType FROM MLM_Reg_Binary WHERE User_Id=@next_R_leg)
			SET @next_R_package_date=(SELECT Package_Date FROM MLM_Reg_Binary WHERE User_Id=@next_R_leg)
			INSERT  INTO @TEMP(user_id1,jointype,package_date)VALUES(@next_R_leg,@next_R_jointype,@next_R_package_date)
		END
		FETCH NEXT FROM cur_main INTO @user_id1
	END
	CLOSE cur_main
	DEALLOCATE cur_main
	SET @L_count=(SELECT COUNT(user_id1) FROM  @TEMP WHERE jointype='PAID' AND package_date=@package_date)
 END
	RETURN @L_count

END
--SELECT LEFT_COUNT('A')
--SELECT [dbo].[LEFT_COUNT]('A','2021-04-21')