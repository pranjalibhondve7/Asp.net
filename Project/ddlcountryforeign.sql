
Create table Country
(
	C_Id int primary key identity(1,1),
	C_Name varchar(30)

)
 
Create table CountryState
(
	S_Id int primary key identity(1,1),
	S_Name varchar(30),
	C_Id int foreign key references Country(C_Id)
)

Create Table stateCity  
(  
   City_Id Int primary key identity(1,1),  
   S_Id Int Foreign Key References CountryState(S_Id),  
   City Varchar(30)  
)  


		insert into Country(C_Name) values('India')
		insert into Country(C_Name) values('Pakistan')
		insert into Country(C_Name) values('America')
		select * from Country

		insert into CountryState(S_Name,C_Id) values('Maharashtra',1)
		insert into CountryState(S_Name,C_Id) values('Bihar',1)
		insert into CountryState(S_Name,C_Id) values('UP',1)
		insert into CountryState(S_Name,C_Id) values('Gujrat',1)
		insert into CountryState(S_Name,C_Id) values('Kerla',1)
		insert into CountryState(S_Name,C_Id) values('Lahore',2)
		insert into CountryState(S_Name,C_Id) values('Karachi',2)
		insert into CountryState(S_Name,C_Id) values('Baluchistan',2)
		insert into CountryState(S_Name,C_Id) values('Sind',2)
		insert into CountryState(S_Name,C_Id) values('Newyork',3)
		insert into CountryState(S_Name,C_Id) values('Texas',3)
		insert into CountryState(S_Name,C_Id) values('Washington',3)
		select * from CountryState


		Insert Into stateCity(City,S_Id) Values('Nagpur',1)  
		Insert Into stateCity(City,S_Id) Values('Mumbai',1)  
		Insert Into stateCity(City,S_Id) Values('Pune',1) 
		Insert Into stateCity(City,S_Id) Values('Patna',2)  
		Insert Into stateCity(City,S_Id) Values('Gaya',2) 
		Insert Into stateCity(City,S_Id) Values('Kanpur',3)   
		Insert Into stateCity(City,S_Id) Values('Lucknow',3) 
		Insert Into stateCity(City,S_Id) Values('Ghaziabad',4) 
		Insert Into stateCity(City,S_Id) Values('Rajkot',4) 
		Insert Into stateCity(City,S_Id) Values('Surat',4)   
		Insert Into stateCity(City,S_Id) Values('Thiruvananthapuram',5) 
		Insert Into stateCity(City,S_Id) Values('Kochi',5) 
		Insert Into stateCity(City,S_Id) Values('Azizabad',6)   
		Insert Into stateCity(City,S_Id) Values('Dhair ',6) 
		Insert Into stateCity(City,S_Id) Values('Baldia Town.',7)   
		Insert Into stateCity(City,S_Id) Values('Bin Qasim Town',7) 
		Insert Into stateCity(City,S_Id) Values('Quetta',8) 
		Insert Into stateCity(City,S_Id) Values('Turbat',8) 
		Insert Into stateCity(City,S_Id) Values('Khuzdar',8) 
		Insert Into stateCity(City,S_Id) Values('Badin',9)
		Insert Into stateCity(City,S_Id) Values('Bandhi',9)
		Insert Into stateCity(City,S_Id) Values('Albany ',10)
		Insert Into stateCity(City,S_Id) Values('Auburn',10)
		Insert Into stateCity(City,S_Id) Values('Dallas',11)
		Insert Into stateCity(City,S_Id) Values('Austin',11)
		Insert Into stateCity(City,S_Id) Values('seattle',12)
		Insert Into stateCity(City,S_Id) Values('Olympia',12)
		select * from CountryState