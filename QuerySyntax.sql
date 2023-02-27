--1. Simple queries
--1.1 Syntax
--1.1.1 Select column(s) from TableName
--Select all the records from the staff table
--If you get squiggles under columns/table names but they do exist and the query works you need to refresh the intellisense : cmd + shift + R)
select * from Staff --> NEVER use this syntax. It means all columns in a query 
--Always use the colunmn by name, Much more descriptive
Select StaffId, FirstName, LastName, Datehired, DateReleased, PositionId, LoginId from Staff

--Custom Column Names(aliases)
Select 'StaffFirstName'=firstName, 'StaffLastName'=lastname from staff
Select firstName as 'StaffFirstName', lastname as 'StaffLastName' from staff
Select firstName 'StaffFirstName', lastname 'StaffLastName' from staff

--Combine strings  
Select firstname + ' ' + lastname from staff 

--Custom Column
Select firstname + ' ' + lastname 'StaffFullName' from staff 

--Math
--Select the CourseId, CourseName, CourseCost, and Sale Course Cost (20%) for all the courses
Select CourseID, CourseName, CourseCost, CourseCost *.8 'SaleCourseCost' from Course  
--How much money is made from each course if the max number of students are enroled. Show the CourseId, coursename and the money made. 
select CourseId, CourseName, MaxStudents * CourseCost 'MoneyMade' from Course 

-- Select the StudentId's that have registered in at least one offering in Registration Table. 
Select distinct studentId from registration

--Where - which records to return
Select FirstName, LastName from Student
Where studentId = 199899200

--Select the paymentId adn the amount for all the payments that are over 600
Select paymentId, Amount from Payment
Where Amount > 600 

--Select the fullNames (as one column) of students whose lastnaem start with 's'
Select FirstName + ' ' + LastName 'StudentName' from Student
Where LastName like 's%' 

--Select the firstname of students whose studentId's are 198933540, 199912010, or 200688700
Select FirstName from Student
Where StudentId = 198933540 or  StudentId = 199912010 or  StudentId = 200688700

Select FirstName from Student
Where StudentId IN(198933540, 199912010, 200688700)

