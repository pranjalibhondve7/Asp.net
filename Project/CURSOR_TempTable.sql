
CREATE PROCEDURE Cur_tmptable
	AS
		DECLARE @name NVARCHAR(100)
		DECLARE @marks DECIMAL(18,2)
	BEGIN
		CREATE TABLE ##TEMP_TABLE1(ID INT IDENTITY(1,1),
									NAME NVARCHAR(100),
									MARKS DECIMAL(18,2))  --TO create temparary Table
		DECLARE cur_temptable CURSOR
		FOR
			SELECT ISNULL(Name,'NO Name'),Marks FROM Demo_cur --ISNULL Used for null name replace to no name
		OPEN cur_temptable
		FETCH NEXT FROM cur_temptable INTO @name,@marks
			WHILE(@@FETCH_STATUS=0)
			BEGIN
				INSERT INTO ##TEMP_TABLE1(NAME,MARKS) VALUES(@name,@marks)
				--PRINT @name
				--PRINT @marks
				FETCH NEXT FROM cur_temptable INTO @name,@marks
			END
		CLOSE cur_temptable
		DEALLOCATE cur_temptable
		SELECT * FROM ##TEMP_TABLE1
		TRUNCATE TABLE ##TEMP_TABLE1
		DROP TABLE ##TEMP_TABLE1
	END
	
	--EXEC Cur_tmptable