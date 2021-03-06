USE [Webform_Task2]
GO
/****** Object:  StoredProcedure [dbo].[Compare_2_Table]    Script Date: 17-06-2021 10:05:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Compare_2_Table]	
AS
	DECLARE @SrNo int
	DECLARE @Name NVARCHAR(MAX)	
	DECLARE @Mob1 NVARCHAR(MAX)	
	DECLARE @Mob2 NVARCHAR(MAX)	
	DECLARE @Mob3 NVARCHAR(MAX)	
	DECLARE @Gender NVARCHAR(MAX)	
	DECLARE @Email NVARCHAR(MAX)	
	DECLARE @DOB DATE
	DECLARE @Address NVARCHAR(MAX)	
	DECLARE @City NVARCHAR(MAX)	
	DECLARE @Company_name NVARCHAR(MAX)	
	DECLARE @Designation NVARCHAR(MAX)	
	DECLARE @State NVARCHAR(MAX)	
	DECLARE @Pincode NVARCHAR(MAX)	
	DECLARE @SrNo1 int	
	DECLARE @Name1 NVARCHAR(MAX)	
	DECLARE @Mob_1 NVARCHAR(MAX)	
	DECLARE @Mob_2 NVARCHAR(MAX)	
	DECLARE @Mob_3 NVARCHAR(MAX)	
	DECLARE @Gender1 NVARCHAR(MAX)	
	DECLARE @Email1 NVARCHAR(MAX)	
	DECLARE @DOB1	DATE
	DECLARE @Address1 NVARCHAR(MAX)	
	DECLARE @City1 NVARCHAR(MAX)	
	DECLARE @Company_name1 NVARCHAR(MAX)	
	DECLARE @Designation1 NVARCHAR(MAX)	
	DECLARE @State1 NVARCHAR(MAX)	
	DECLARE @Pincode1 NVARCHAR(MAX)	
	DECLARE @Total_Error int
	DECLARE @Total_Error_Des nvarchar(MAX)	
	Declare @Detail_Des NVARCHAR(MAX)	

	BEGIN
		CREATE TABLE ##TEMP1([Sr.No] INT,Error int,Total_Error int,Description NVARCHAR(MAX),Detail_Description nvarchar(max))--TO create temparary Table
	DECLARE cur_name CURSOR
	FOR
		SELECT [Sr.No],Name,Email,Mob_No_1,Mob_No_2,Mob_No_3,Address,Gender,Company_Name,Designation,Pincode,DateOfBirth,City,State FROM Registraton 
	OPEN cur_name
	FETCH NEXT FROM cur_name INTO @SrNo,@Name,@Email,@Mob1,@Mob2,@Mob3,@Address,@Gender,@Company_name,@Designation,@Pincode,@DOB,@City,@State
	WHILE(@@FETCH_STATUS=0)
	BEGIN			
			SET @SrNo1=(SELECT [Sr.No] FROM Master_Table WHERE [Sr.No]=@SrNo )
			SET @Name1=(SELECT NAME FROM Master_Table WHERE [Sr.No]=@SrNo)
			SET @Mob_1=(SELECT Mob_No_1 FROM Master_Table WHERE [Sr.No]=@SrNo)
			SET @Mob_2=(SELECT Mob_No_2 FROM Master_Table WHERE [Sr.No]=@SrNo)
			SET @Mob_3=(SELECT Mob_No_3 FROM Master_Table WHERE [Sr.No]=@SrNo)
			SET @Gender1=(SELECT Gender FROM Master_Table WHERE [Sr.No]=@SrNo)
			SET @Email1=(SELECT Email FROM Master_Table WHERE [Sr.No]=@SrNo)
			SET @DOB1=(SELECT DateOfBirth FROM Master_Table WHERE [Sr.No]=@SrNo)
			SET @Address1=(SELECT Address FROM Master_Table WHERE [Sr.No]=@SrNo)
			SET @City1=(SELECT City FROM Master_Table WHERE [Sr.No]=@SrNo)
			SET @Company_name1=(SELECT Company_Name FROM Master_Table WHERE [Sr.No]=@SrNo)
			SET @Designation1=(SELECT Designation FROM Master_Table WHERE [Sr.No]=@SrNo)
			SET @State1=(SELECT State FROM Master_Table WHERE [Sr.No]=@SrNo)
			SET @Pincode1=(SELECT Pincode FROM Master_Table WHERE [Sr.No]=@SrNo)

			IF(@SrNo=@SrNo1)
			BEGIN					
					IF CAST(@Name AS binary)= CAST(@Name1 AS binary)
					--IF (@Name ) = (@Name1 )
					BEGIN		
						
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)					
					END
					ELSE
					BEGIN							
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[Name]',@Name)												
					END
			
					IF(@Mob_1=@Mob1)
					BEGIN								
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)						
					END
					ELSE
					BEGIN						
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[Mob_No_1]',@Mob1)												
					END

					IF(@Mob_2=@Mob2)
					BEGIN								
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)						
					END
					ELSE
					BEGIN						
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[Mob_No_2]',@Mob2)												
					END

					IF(@Mob_3=@Mob3)
					BEGIN								
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)						
					END
					ELSE
					BEGIN						
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[Mob_No_3]',@Mob3)											
					END

					IF cast(@Email as binary) = cast(@Email as binary)
					--IF(@Email=@Email1)
					BEGIN								
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)						
					END
					ELSE
					BEGIN						
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[Email]',@Email)												
					END

					IF cast(@Gender as binary) = cast(@Gender as binary)
					--if  @Gender COLLATE Latin1_General_CS_AS  = @Gender COLLATE Latin1_General_CS_AS 
					if convert(varbinary(50),@Gender) = convert(varbinary(50),@Gender1)
					BEGIN								
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)						
					END
					ELSE
					BEGIN						
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[Gender]',@Gender)												
					END

					IF(@DOB=@DOB1)
					BEGIN								
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)						
					END
					ELSE
					BEGIN						
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[DateOfBirth]',@DOB)												
					END

					IF cast(@Address as binary) = cast(@Address as binary)
					--IF (@Address ) = (@Address1 )
					BEGIN								
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)						
					END
					ELSE
					BEGIN						
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[Address]',@Address)											
					END

					IF cast(@City as binary) = cast(@City1 as binary)
					--IF (@City ) = (@City1 )
					BEGIN								
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)						
					END
					ELSE
					BEGIN						
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[City]',@City)						
					END

					IF cast(@Company_name as binary) = cast(@Company_name1 as binary)
					--IF (@Company_name ) = (@Company_name1 )
					BEGIN								
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)
					END
					ELSE
					BEGIN						
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[Company_Name]',@Company_name)						
					END

					IF cast(@Designation as binary) = cast(@Designation1 as binary)
					--IF (@Designation ) = (@Designation1 )
					BEGIN								
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)
					END
					ELSE
					BEGIN						
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[Designation]',@Designation)						
					END

					IF cast(@State as binary) = cast(@State1  as binary)
					--IF @State = @State1 
					BEGIN								
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)
					END
					ELSE
					BEGIN						
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[State]',@State)						
					END

					IF(@Pincode=@Pincode1)
					BEGIN								
						Insert into  ##TEMP1 ([Sr.No],Error) VALUES(@SrNo,0)
					END
					ELSE
					BEGIN						
						Insert into  ##TEMP1 ([Sr.No],Error,Description,Detail_Description) VALUES(@SrNo,1,'[Pincode]',@Pincode)						
					END

					--FIND TOTAL ERROR5
				
					SET @Total_Error=(SELECT SUM(Error)FROM  ##TEMP1 WHERE [Sr.No]=@SrNo )
					select @Total_Error_Des=stuff( (select ','+ Description from ##TEMP1 where [Sr.No]=@SrNo for xml path('')),1,1,'')
					select @Detail_Des=stuff( (select ','+ Detail_Description from ##TEMP1 where [Sr.No]=@SrNo for xml path('')),1,1,'')
					--select @Detail_Des=stuff( (select ','+ Description from ##TEMP1 where [Sr.No]=@SrNo for xml path('')),1,1,'')
					Insert into  ##TEMP1 ([Sr.No],Total_Error,Description,Detail_Description) VALUES(@SrNo,@Total_Error,@Total_Error_Des,@Detail_Des)

					--UPDATE Show_Error Set Name=@Name,Mob_No_1=@Mob1,Mob_No_2=@Mob2,Mob_No_3=@Mob3,Gender=@Gender,Email=@Email,DateOfBirth=@DOB,Address=@Address,City=@City,Company_Name=@Company_name,Designation=@Designation,State=@State,Pincode=@Pincode,Error=@Total_Error WHERE Sr_No=@SrNo					
					Insert INTO  Show_Error(Sr_No,Name,Mob_No_1,Mob_No_2,Mob_No_3,Gender,Email,DateOfBirth,Address,City,Company_Name,Designation,State,Pincode,Error,Description,Detail_Description) VALUES(@SrNo,@Name,@Mob1,@Mob_2,@Mob3,@Gender,@Email,@DOB,@Address,@City,@Company_name,@Designation,@State,@Pincode,@Total_Error,@Total_Error_Des,@Detail_Des)					
			END			
		FETCH NEXT FROM cur_name INTO @SrNo,@Name,@Email,@Mob1,@Mob2,@Mob3,@Address,@Gender,@Company_name,@Designation,@Pincode,@DOB,@City,@State
	END
	CLOSE cur_name
	DEALLOCATE cur_name	
	SELECT * FROM ##TEMP1 
	TRUNCATE TABLE ##TEMP1
	DROP TABLE ##TEMP1
	
END

--EXEC  Compare_2_Table 
--select * from Show_Error
--truncate table Show_Error

