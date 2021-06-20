

Create table Grid_Details
(
		[Name] nvarchar(50),
		Email nvarchar(100),
		Phone_No varchar(50),
		[Address] text,
		Pincode int
);

		select * from Grid_Details;
		
		alter table Grid_Details add photo varchar(1024);
		 alter table Grid_Details drop column [File_Name] ;
		 alter table Grid_Details add [File_Name] varchar(1024);
		 alter table Grid_Details add Photo varchar(300) ;

		 alter table Grid_Details add [Image] image;  
		  alter table Grid_Details drop column [Image] ;  
		  DELETE FROM Grid_Details  WHERE Name='Kanchan';
		  alter table Grid_Details  drop column Roll_No ; 
		  alter table Grid_Details add Roll_No int identity(100,1) ;