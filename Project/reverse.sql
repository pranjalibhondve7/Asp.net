
CREATE PROCEDURE REVERSE_No
AS
	DECLARE @n INT
	
	DECLARE @i INT
	DECLARE @rev INT
	DECLARE @r INT;
	SET @REV=0
	SET @n=123456
	while @n>0
BEGIN
	
	
		SET @r= @n%10 
		SET @rev=(@rev*10)+@r
		SET @n=(@n/10)
		PRINT @REV
	
end