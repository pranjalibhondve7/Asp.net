

--Select SUBSTRING( 
--( 
--     SELECT ',' + Name AS 'data()'
--         FROM Registraton FOR XML PATH('') 
--), 2 , 9999)
----------------------------------------------------------------------------------------------------------

--Declare @val Varchar(MAX); 
--Select @val = COALESCE(@val + ', ' + Name,Name) 
--        From Registraton Select @val;
--		print @val
----------------------------------------------------------------------------------------------------------
--		DECLARE @col NVARCHAR(MAX);
--SELECT @col= COALESCE(@col, '') + ',' + Name
--FROM Registraton where Name = 'Pranjali Bhondave';
--SELECT @col;
------------------------------------------------------------------------------------------------------------
-- declare @columnList varchar(8000)
--select @columnList=stuff( (select ','+Name
--				from Registraton
--				where [Sr.No]=1
				
--				for xml path('')),
--				1,1,'')

--select @columnList
-------------------------------------------------------------------------------------------------------------

--SELECT ASCII('P') AS [ASCII], ASCII('p') AS [Extended_ASCII];

--SET TEXTSIZE 0;  
--DECLARE @position INT, @string CHAR(8);  
---- Initialize the current position and the string variables.  
--SET @position = 1;  
--SET @string = 'New Moon';  
 

--WHILE @position <= DATALENGTH(@string)  
--   BEGIN  
--   SELECT ASCII(SUBSTRING(@string, @position, 1)) As Ascii ,   
--      CHAR(ASCII(SUBSTRING(@string, @position, 1)))  
--   SET @position = @position + 1  
   
--   END; 
 -----------------------------------------------------------------------------------------------------------------  
-- Alter Function SplitWordsToChar (@Sentence VARCHAR(MAX))
-- RETURNS VARCHAR(MAX)
--AS
--BEGIN
--	 DECLARE @Words VARCHAR(MAX)
--	 DECLARE @t VARCHAR(MAX)
--	 DECLARE @I INT

--   -- SET NOCOUNT ON
--    --SET XACT_ABORT ON
--    SET @Words = @Sentence    
--    SELECT @I = 0
 
--    WHILE(@I < LEN(@Words)+1)
--    BEGIN
--      SELECT @t = SUBSTRING(@words,@I,1)   
--      --PRINT @t
--      SET @I = @I + 1
--    END   
--	Return @t
--END

   
  
--GO
--SELECT [dbo].[SplitWordsToChar]('pranjali')

--EXEC SplitWordsToChar(@Sentence ='pranjali bhondve')
-----------------------------------------------------------------------------------------------------
--CREATE Function SplitInToChar (@Sentence VARCHAR(MAX))

--Returns varchar(Max)

--AS
--Begin
--declare @a varchar(100)  
  
--set @a = 'v_in_ay'  
    
--;with cte as
--(select STUFF(@a,1,1,'')TXT,LEFT(@a,1)COL1 
----convert(varchar(50),left(@a, CHARINDEX(',',@a)-1 )) col1

--union all  
  
--select STUFF(TXT,1,1,'')TXT,LEFT(TXT,1)col1 from cte where LEN(TXT)>0
----convert(varchar(50),left(number,(case when CHARINDEX(',',number) = 0 then len(number) else CHARINDEX(',',number)-1 end)) )col1  
  
 
--)  
--select col1,ISNUMERIC(col1) from cte 
--------------------------------------------------------------------------------------------------------------------------------------------
Declare @S1 varchar(20) = 'SQL'
Declare @S2 varchar(20) = 'sql'

  
if @S1 = @S2 print 'equal!' else print 'NOT equal!' -- equal (default non-case sensitivity for SQL

if cast(@S1 as binary) = cast(Upper(@S2) as binary) print 'equal!' else print 'NOT equal!' -- equal

if cast(@S1 as binary) = cast(@S2 as binary) print 'equal!' else print 'NOT equal!' -- not equal

if  @S1 COLLATE Latin1_General_CS_AS  = Upper(@S2) COLLATE Latin1_General_CS_AS  print 'equal!' else print 'NOT equal!' -- equal

if  @S1 COLLATE Latin1_General_CS_AS  = @S2 COLLATE Latin1_General_CS_AS  print 'equal!' else print 'NOT equal!' -- not equal

 