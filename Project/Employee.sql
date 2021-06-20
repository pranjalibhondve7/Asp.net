


use  Mydatabase

create table Employee
(
		E_Id int NOT NULL,
		[E_Name] varchar(30) NOT NULL ,
		[E_Address] varchar(50),
		Department varchar(30),
		Joining_Date Date,
		Salary float

);
select * from Employee;
--alter table Student  add  Marks int;


insert into Employee values (101,'Karishma','Ram Nagar','HR','2014/03/8',3500.45);
insert into Employee values (102,'Pranjali','Mahal','Softeware Developer','2015/03/05',2000.00);
insert into Employee values (102,'Ram','Ajani Road','QA','2014/08/02',20000.00);


update Employee set E_Id=103 where  E_Name='Ram' ;


