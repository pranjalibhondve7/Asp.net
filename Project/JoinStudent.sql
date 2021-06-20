
create table StudentJoin(
	Id int primary key  identity(1,1),
	Roll_No int ,
	[Name] varchar(30),
	Email varchar(30),
	[Address] varchar(50)
	
)
select * from StudentJoin;

create table Department(
	Id int primary key ,
	Dept_Name varchar(30),
	Joining_Date date

)
select * from Department;

insert into StudentJoin (Roll_No,Name,Email,Address)values(101,'Pranju','pranju@gmail.com','Nagpur');
insert into StudentJoin (Roll_No,Name,Email,Address)values(102,'Ragini','Ragini@gmail.com','Sakkardar');
insert into StudentJoin (Roll_No,Name,Email,Address)values(103,'Khushbu','khushbu@gmail.com','Dighori');
insert into StudentJoin (Roll_No,Name,Email,Address)values(104,'Rahul','rs07@gmail.com','Mauda');
insert into StudentJoin (Roll_No,Name,Email,Address)values(105,'Gayatri','gayu7@gmail.com','Manewada');
insert into StudentJoin (Roll_No,Name,Email,Address)values(106,'Snehal','snehu@gmail.com','Mahal');


insert into Department (Id,Dept_Name,Joining_Date)values(1,'Computer','04/12/2017');
insert into Department (Id,Dept_Name,Joining_Date)values(2,'Electrical','06/06/2015');
insert into Department (Id,Dept_Name,Joining_Date)values(3,'Mechanical','08/04/2016');
insert into Department (Id,Dept_Name,Joining_Date)values(6,'Civil','08/14/2016');

--SELECT * FROM StudentJoin FULL OUTER JOIN Department ON StudentJoin.Id = Department.Id;
     