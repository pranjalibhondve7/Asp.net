USE [Mydatabase]
GO
/****** Object:  StoredProcedure [dbo].[Fibonacii_Series2]    Script Date: 15-04-2021 11:47:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Fibonacii_Series2]
	As
		DECLARE @a INT
		DECLARE @b INT
		DECLARE @FIB INT
	BEGIN
		SET @a=1
		SET @b=1
		SET @FIB=0	
			print @a
			print @b  
		while @FIB<200
			SET @FIB=@a+@b
				print @FIB
			SET @a=@b	
			SET @b=@FIB
	End
	--EXEC Fibonacii_Series2