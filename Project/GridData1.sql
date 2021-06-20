

create table GridEmployee(
	
	Eid int identity(1,1),
	[Name] nvarchar(30),
	Department nvarchar(30),
	[Location] nvarchar(30),
	JoiningDate date
);
select * from GridEmployee;

Insert into GridEmployee(Name,Department,Location,JoiningDate)values('Pranjali','Computer','Nagpur','2021-04-28');