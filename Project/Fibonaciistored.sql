                                    
	CREATE PROCEDURE Fibonacii_Series
	As
		DECLARE @a INT
		DECLARE @b INT
		DECLARE @FIB INT
		SET @a=1
		SET @b=1
		SET @FIB=0		     
		print @a
		print @b  
	while @FIB<100
	BEGIN             
		SET @FIB=@a+@b
		print @FIB
		SET @a=@b
		SET @b=@FIB
	End

  --EXEC Fibonacii_Series                                                                                                                      