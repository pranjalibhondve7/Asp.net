USE [Cursor_db]
GO
/****** Object:  UserDefinedFunction [dbo].[Right_Count]    Script Date: 23-04-2021 09:31:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[Right_Count](@user_id nvarchar(100),@package_date date)
RETURNS INT
AS
BEGIN

DECLARE @R_count INT
DECLARE @v_R_LEG NVARCHAR(100)
DECLARE @R_Jointype NVARCHAR(100)
DECLARE @R_package_date DATE
DECLARE @next_R_leg NVARCHAR(100)
DECLARE @user_id1 NVARCHAR(100)
DECLARE @next_L_leg NVARCHAR(100)
DECLARE @next_R_jointype NVARCHAR(100)
DECLARE @next_R_package_date DATE
DECLARE @next_L_jointype NVARCHAR(100)
DECLARE @next_L_package_date DATE
DECLARE @v_L_LEG NVARCHAR(100)

 DECLARE @TEMP TABLE(user_id1 NVARCHAR(100),jointype NVARCHAR(100),package_date DATE)	
 SET @v_R_LEG = (SELECT ISNULL (R_Leg,'NO RECORD') FROM MLM_Reg_Binary WHERE USER_ID=@user_id)

 IF @v_R_LEG = 'NO RECORD' 
 BEGIN
	SET @R_count=0
 END

 ELSE
 BEGIN
	--SET @R_count=1	
	SET @R_Jointype=(SELECT JoinType FROM MLM_Reg_Binary WHERE User_Id=@v_R_LEG)
	SET @R_package_date=(SELECT Package_Date FROM MLM_Reg_Binary WHERE User_Id=@v_R_LEG )
	INSERT INTO @TEMP (user_id1,jointype,package_date) values(@v_R_LEG,@R_Jointype,@R_package_date)
	DECLARE cur_main CURSOR
	FOR
		SELECT user_id1 FROM @TEMP
	OPEN cur_main
	FETCH NEXT FROM cur_main INTO @user_id1
	WHILE(@@FETCH_STATUS=0)
	BEGIN
		SET @next_R_leg=(SELECT R_Leg FROM MLM_Reg_Binary WHERE User_Id=@user_id1)
		SET @next_L_leg=(SELECT L_Leg FROM MLM_Reg_Binary WHERE User_Id=@user_id1)
		IF @next_R_leg IS NOT NULL
		BEGIN
			SET @next_R_jointype=(SELECT JoinType FROM MLM_Reg_Binary WHERE User_Id=@next_R_leg)
			SET @next_R_package_date=(SELECT Package_Date FROM MLM_Reg_Binary WHERE User_Id=@next_R_leg)
			INSERT  INTO @TEMP(user_id1,jointype,package_date)VALUES(@next_R_leg,@next_R_jointype,@next_R_package_date)
		END
		IF @next_L_leg IS NOT NULL
		BEGIN
			SET @next_L_jointype=(SELECT JoinType FROM MLM_Reg_Binary WHERE User_Id=@next_L_leg)
			SET @next_L_package_date=(SELECT Package_Date FROM MLM_Reg_Binary WHERE User_Id=@next_L_leg)
			INSERT  INTO @TEMP(user_id1,jointype,package_date)VALUES(@next_L_leg,@next_L_jointype,@next_L_package_date)
		END
		FETCH NEXT FROM cur_main INTO @user_id1
	END
	CLOSE cur_main
	DEALLOCATE cur_main
	SET @R_count=(SELECT COUNT(user_id1) FROM  @TEMP WHERE jointype='PAID' AND package_date=@package_date)
 END
	RETURN @R_count

END
--SELECT LEFT_COUNT('A')
--SELECT [dbo].[Right_Count]('A','2021-04-21')