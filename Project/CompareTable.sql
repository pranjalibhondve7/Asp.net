
--select count(*) from Registraton union select count(*) from Master_Table

--SELECT 
--       CASE WHEN (select * from Registraton)=(select * from Master_Table)
--       THEN 1
--       ELSE 0
--       END AS RowCountResult
--FROM Registraton,Master_Table

IF  OBJECT_ID(N'tempdb..#diffcols', N'U') IS NOT NULL
    DROP TABLE #diffcols; 
SELECT  src.[Sr.No] ,
    CONCAT(
    IIF(EXISTS(SELECT src.[Sr.No] EXCEPT SELECT tgt.[Sr.No] ), RTRIM(', Sr.No'),''),
    IIF(EXISTS(SELECT src.[Name]  EXCEPT SELECT tgt.[Name] ), RTRIM(', Name'),''),
    IIF(EXISTS(SELECT src.Mob_No_1 EXCEPT SELECT tgt.Mob_No_1 ), RTRIM(',Mob_No_1'),''),
	IIF(EXISTS(SELECT src.Mob_No_2 EXCEPT SELECT tgt.Mob_No_2 ), RTRIM(',Mob_No_2'),''),
	IIF(EXISTS(SELECT src.Mob_No_3 EXCEPT SELECT tgt.Mob_No_3 ), RTRIM(',Mob_No_3'),''),
	IIF(EXISTS(SELECT src.Gender EXCEPT SELECT tgt.Gender ), RTRIM(',Gender'),''),
	IIF(EXISTS(SELECT src.Email EXCEPT SELECT tgt.Email ), RTRIM(',Email'),''),
	IIF(EXISTS(SELECT src.[Address] EXCEPT SELECT tgt.[Address] ), RTRIM(',Address'),''),
	IIF(EXISTS(SELECT src.DateOfBirth EXCEPT SELECT tgt.DateOfBirth ), RTRIM(',DateOfBirth'),''),
	IIF(EXISTS(SELECT src.City EXCEPT SELECT tgt.City ), RTRIM(',City'),''),
	IIF(EXISTS(SELECT src.Company_Name EXCEPT SELECT tgt.Company_Name ), RTRIM(',Company_Name'),''),
	IIF(EXISTS(SELECT src.Designation EXCEPT SELECT tgt.Designation ), RTRIM(',Designation'),''),
	IIF(EXISTS(SELECT src.[State] EXCEPT SELECT tgt.[State] ), RTRIM(',State'),''),
    IIF(EXISTS(SELECT src.Pincode EXCEPT SELECT tgt.Pincode), RTRIM(',Pincode'),'')) + ','
AS cols
INTO #diffcols FROM Master_Table src JOIN Registraton tgt ON src.Email = tgt.Email WHERE EXISTS(SELECT src.* EXCEPT SELECT tgt.*);
select * from #diffcols

select COUNT(*) from #diffcols

SELECT * FROM Master_Table o
JOIN Registraton r   ON o.Email = r.Email
JOIN #diffcols d ON o.[Sr.No] = d.[Sr.No]

 WITH src  AS ( select SUM(IIF(d.cols LIKE '%, Name, %' , 1, 0)) AS Name,
		SUM(IIF(d.cols LIKE '%, Mob_No_1, %'  , 1, 0)) AS Mob_No_1,
    	SUM(IIF(d.cols LIKE '%, Mob_No_2, %' , 1, 0)) AS Mob_No_2,
		SUM(IIF(d.cols LIKE '%, Mob_No_3, %' , 1, 0)) AS Mob_No_3,
		SUM(IIF(d.cols LIKE '%, Gender, %', 1, 0)) AS Gender,
		SUM(IIF(d.cols LIKE '%, Email, %' , 1, 0)) AS Email,
		SUM(IIF(d.cols LIKE '%, DateOfBirth, %'  , 1, 0)) AS DateOfBirth,
		SUM(IIF(d.cols LIKE '%, Address, %' , 1, 0)) AS Address,
		SUM(IIF(d.cols LIKE '%, City, %' , 1, 0)) AS City,
		SUM(IIF(d.cols LIKE '%, Company_Name, %' , 1, 0)) AS Company_Name,
		SUM(IIF(d.cols LIKE '%, Designation, %' , 1, 0)) AS Designation,
		SUM(IIF(d.cols LIKE '%, State, %' , 1, 0)) AS State,
		SUM(IIF(d.cols LIKE '%, Pincode, %' , 1, 0)) AS Pincode
		 FROM #diffcols d
)
SELECT ca.col AS ColumnName, ca.diff AS [Difference Count]
FROM src
CROSS APPLY ( VALUES
    --('[Sr.No] ', [Sr.No]),
    ('Name',[Name] ),
	('Mob_No_1',Mob_No_1),
	('Mob_No_2',Mob_No_2),
	('Mob_No_3',Mob_No_3),
	('Gender',Gender),
    ('Email',Email),
	('DateOfBirth',DateOfBirth),
	('Address',[Address]),
	('City',City),
	('Company_Name',Company_Name),
	('State',[State]),
	('Pincode',Pincode),
    ('Designation',Designation)
) ca(col,diff)
WHERE diff > 0
ORDER BY diff desc;




SELECT
Sum(CASE WHEN t1.Mob_No_1 IS NOT NULL AND t2.file_n IS NOT NULL THEN 1
ELSE 0 END) AS matched_count,
Sum( CASE WHEN t1.Mob_No_1 IS NOT NULL AND t2.file_n IS NOT NULL THEN 0
ELSE 1 END) AS un_matched_count
FROM Registraton AS t1
FULL OUTER JOIN
(
SELECT * FROM (SELECT DISTINCT Mob_No_1 AS file_n
FROM Master_Table) AS a
WHERE len(trim(file_n)) <>0 ) AS t2
ON trim(t1.Mob_No_1) = trim(file_n);




