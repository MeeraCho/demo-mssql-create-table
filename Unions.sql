--Unions
--Combine the results of more than one query into one result set 
-- 이 둘을 합쳐서 return 하면 27 records가 나와야하는데 
Select firstName, lastName from Student --17
Select firstName, lastName from Staff --10

--Oh No! We are missing 2 people. 25명이 나온다. 같은 이름은 하나만 출력된다. 
Select firstName, lastName from Student 
UNION 
Select firstName, lastName from Staff --25

-- Union uses distinct by default
-- To include duplicate records, use ALL 
Select firstName, lastName from Student 
UNION ALL
Select firstName, lastName from Staff --27

--Rules
--Can combine any number of queries
--Student names, Staff Names, StreetAdress, city 
Select firstName, lastName from Student 
Union All
Select firstName, lastName from Staff 
Union All
Select StreetAddress, city from Student

--Queries being Combined must have the same number of columns. 
Select firstName from Student --ERROR: column 1개 
Union All
Select firstName, lastName from Staff --column 2개 갯수 안맞아 에러 

--Columns being combined must be similar datatypes
Select firstName, birthdate from Student --ERROR: birthdate: small date time data type 
Union All
Select firstName, lastName from Staff

--Column names are determined by the first query 
Select firstname'StudentFirstName', city from student 
Union ALL
Select firstname'StaffFirstName', lastname from staff -- The first column names are StudentFirstName and city 

--ORDER BY
--Order by is the last clause in a query and can order your results in ascending or descending order
Select firstname, lastname from student 
order by lastname asc    --ascending order

Select firstname, lastname from student 
order by lastname desc    --descending order

--Order by is after the last query in your unions
Select firstName, lastName from Student 
Union All
Select firstName, lastName from Staff 
Union All
Select StreetAddress, city from Student
ORDER BY lastname asc

--NESTED
Select firstname, lastname from student 
order by lastname asc, firstName asc   --if there are same lastname, then firstNames have ascending order 


-- 1.	Write a script that will produce the ‘It Happened in October’ display.
-- The output of the display is shown below
Select * from student

-- step 1 각 테이블에서 내용을 뽑는다 
Select studentId'ID', 'Student Born:' + firstName + ' ' + LastName'Event:Name' from Student
where datename (mm, birthdate) = 'October'

Select staffID, 'Staff Hired:' + firstName + ' ' + LastName from Staff
where datename(mm,datehired) = 'October'

-- step 2 두 테이블 중간에 union으로 연결한다. 
Select studentId'ID', 'Student Born:' + firstName + ' ' + LastName'Event:Name' from Student
where datename (mm, birthdate) = 'October'
Union All 
Select staffID, 'Staff Hired:' + firstName + ' ' + LastName from Staff
where datename(mm,datehired) = 'October'

-- step 3 decending order
Select studentId'ID', 'Student Born:' + firstName + ' ' + LastName'Event:Name' from Student
where datename (mm, birthdate) = 'October'
Union All 
Select staffID, 'Staff Hired:' + firstName + ' ' + LastName from Staff
where datename(mm,datehired) = 'October'
order by ID desc 